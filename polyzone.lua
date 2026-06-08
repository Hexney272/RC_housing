-- Property zone detection and management system

-- Global state
local isInPropertyZone = false
local isInMLOInterior = false
local currentPropertyId = nil
local currentPropertyData = nil

-- Getter functions
function GetCurrentPropertyId()
    return currentPropertyId
end

function GetCurrentPropertyData()
    return currentPropertyData
end

function IsInsideMLO()
    return isInMLOInterior
end

-- Enter property zone
function EnterZone(isEntering, propertyId, data)
    currentPropertyId = propertyId
    
    -- Wait for restart to complete
    while waitingForLoadAfterRestart do
        Citizen.Wait(200)
    end
    
    
    local propertyData = Properties[currentPropertyId]
    if not propertyData then
        return
    end
    
    currentPropertyData = propertyData
    RefreshTargets()
    
    -- Load furniture if available
    if currentPropertyData and currentPropertyData.furniture then
        Property:LoadFurniture("outside", currentPropertyData.furniture, currentPropertyId)
        
        -- Load interior furniture for MLO properties
        if currentPropertyData.type == "mlo" then
            Property:LoadFurniture("inside", currentPropertyData.furniture, currentPropertyId)
        end
    end
    
    -- Handle door loading for motel/MLO properties
    Citizen.CreateThread(function()
        while currentPropertyId do
            if propertyData.type == "motel" or propertyData.type == "mlo" then
                break
            end
            
            if propertyData.type == "motel" then
                -- Get motel rooms
                local rooms = Property.GetMotelRooms(currentPropertyData)
                
                -- Remove old door targets
                for i = #TargetPoints, 1, -1 do
                    if TargetPoints[i].type == "door" then
                        CL.Target("remove-entity", TargetPoints[i].entity)
                        table.remove(TargetPoints, i)
                    end
                end
                
                -- Load doors for each room
                for _, room in pairs(rooms) do
                    if room.type == "mlo" then
                        local isLocked = not (room.owner or room.renter)
                        Property:LoadDoors(
                            room.metadata.doors,
                            tostring(room.id),
                            false,
                            isLocked
                        )
                    end
                end
            else
                -- Load doors for MLO property
                local isLocked = currentPropertyData.owner == nil
                Property:LoadDoors(
                    currentPropertyData.metadata.doors,
                    nil,
                    true,
                    isLocked
                )
            end
            
            Wait(1500)
        end
    end)
end

-- Exit property zone
function ExitZone(isExiting, propertyId, data)
    library.Debug(string.format("You have left the Property Zone: %s", currentPropertyId))
    
    -- Reset state
    isInPropertyZone = nil
    currentPropertyId = nil
    currentPropertyData = nil
    
    -- Remove all furniture
    Property:RemoveFurniture()
    
    -- Clean up editing furniture if exists
    if Property.EditingFurnitureObj then
        if DoesEntityExist(Property.EditingFurnitureObj) then
            DeleteObject(Property.EditingFurnitureObj)
        end
        Property.EditingFurniture = false
        Property.EditingFurnitureObj = nil
        Property.EditingFurnitureData = {}
    end
    
    closeNUI(true)
    
    -- Remove all target points
    for i = 1, #TargetPoints do
        if TargetPoints[i].type == "entity" or TargetPoints[i].type == "door" then
            CL.Target("remove-entity", TargetPoints[i].entity)
        else
            CL.Target("remove-zone", TargetPoints[i].id)
        end
    end
    
    TargetPoints = {}
    RefreshTargets()
end

-- Calculate center point of a polygon zone
function getZoneCenter(points, minZ, maxZ)
    local sumX = 0
    local sumY = 0
    local count = #points
    
    for i = 1, count do
        sumX = sumX + points[i].x
        sumY = sumY + points[i].y
    end
    
    local avgZ = 0.0
    if minZ and maxZ then
        avgZ = (minZ + maxZ) / 2
    end
    
    return vector3(sumX / count, sumY / count, avgZ)
end

-- Calculate polygon area (Shoelace formula)
function calculatePolygonArea(points)
    local area = 0
    local j = #points
    
    for i = 1, #points do
        area = area + (points[j].x + points[i].x) * (points[j].y - points[i].y)
        j = i
    end
    
    area = math.abs(area) / 2
    
    -- Convert to square feet if configured
    if Config.AreaUnit == "ft2" then
        area = area * 10.7639
    end
    
    return math.floor(area)
end

-- Check if point is inside polygon (Ray casting algorithm)
function isPointInPolygon(point, polygon)
    local intersections = 0
    local n = #polygon
    local x, y = point.x, point.y
    
    for i = 1, n do
        local j = (i % n) + 1
        local vertex1 = polygon[i]
        local vertex2 = polygon[j]
        
        -- Check if point crosses the edge
        if (y < vertex1.y) ~= (y < vertex2.y) then
            local xIntersection = (vertex2.x - vertex1.x) * (y - vertex1.y) / (vertex2.y - vertex1.y) + vertex1.x
            if x < xIntersection then
                intersections = intersections + 1
            end
        end
    end
    
    -- Point is inside if intersections is odd
    return (intersections % 2) == 1
end

-- Draw a wall between two points (for debug visualization)
local function _drawWall(point1, point2, minZ, maxZ, r, g, b)
    local corner1 = vector3(point1.x, point1.y, minZ)
    local corner2 = vector3(point1.x, point1.y, maxZ)
    local corner3 = vector3(point2.x, point2.y, minZ)
    local corner4 = vector3(point2.x, point2.y, maxZ)
    
    -- Draw two triangles to form a quad
    DrawPoly(corner1, corner2, corner3, r, g, b, 70)
    DrawPoly(corner2, corner4, corner3, r, g, b, 70)
    DrawPoly(corner3, corner4, corner2, r, g, b, 70)
    DrawPoly(corner3, corner2, corner1, r, g, b, 70)
end

-- Debug: Visualize property zones
Citizen.CreateThread(function()
    while waitingForLoadAfterRestart do
        Citizen.Wait(200)
    end
    
    while Config.DebugPolyZone do
        for _, property in pairs(Properties) do
            if property.metadata and property.metadata.zone and property.metadata.zone.points then
                -- Draw main zone
                for i = 1, #property.metadata.zone.points do
                    if i < #property.metadata.zone.points then
                        _drawWall(
                            property.metadata.zone.points[i],
                            property.metadata.zone.points[i + 1],
                            property.metadata.zone.minZ,
                            property.metadata.zone.maxZ,
                            76, 17, 166  -- Purple
                        )
                    end
                    
                    if i == #property.metadata.zone.points then
                        _drawWall(
                            property.metadata.zone.points[i],
                            property.metadata.zone.points[1],
                            property.metadata.zone.minZ,
                            property.metadata.zone.maxZ,
                            76, 17, 166
                        )
                    end
                end
                
                -- Draw interior zone if exists
                if property.metadata.interiorZone then
                    for i = 1, #property.metadata.interiorZone.points do
                        if i < #property.metadata.interiorZone.points then
                            _drawWall(
                                property.metadata.interiorZone.points[i],
                                property.metadata.interiorZone.points[i + 1],
                                property.metadata.interiorZone.minZ,
                                property.metadata.interiorZone.maxZ,
                                114, 49, 212  -- Blue
                            )
                        end
                        
                        if i == #property.metadata.interiorZone.points then
                            _drawWall(
                                property.metadata.interiorZone.points[i],
                                property.metadata.interiorZone.points[1],
                                property.metadata.interiorZone.minZ,
                                property.metadata.interiorZone.maxZ,
                                114, 49, 212
                            )
                        end
                    end
                end
            end
        end
        
        Citizen.Wait(1)
    end
end)

-- Debug: Visualize region zones
Citizen.CreateThread(function()
    while waitingForLoadAfterRestart do
        Citizen.Wait(200)
    end
    
    if Config.DebugRegionsZone then
        RegisterCommand("getRegion", function()
            local coords = GetEntityCoords(PlayerPedId())
            local region = library.GetCurrentRegion(coords.xyz) or "None"
            print(string.format("Region: ^3%s", region))
        end)
    end
    
    while Config.DebugRegionsZone do
        for _, region in pairs(Config.Regions) do
            if region.zone then
                for i = 1, #region.zone do
                    if i < #region.zone then
                        _drawWall(
                            region.zone[i],
                            region.zone[i + 1],
                            -20.0,
                            350.0,
                            region.debugColor and region.debugColor.x or 76,
                            region.debugColor and region.debugColor.y or 17,
                            region.debugColor and region.debugColor.z or 166
                        )
                    end
                    
                    if i == #region.zone then
                        _drawWall(
                            region.zone[i],
                            region.zone[1],
                            -20.0,
                            350.0,
                            region.debugColor and region.debugColor.x or 76,
                            region.debugColor and region.debugColor.y or 17,
                            region.debugColor and region.debugColor.z or 166
                        )
                    end
                end
            end
        end
        
        Citizen.Wait(1)
    end
end)

-- Main zone detection loop
Citizen.CreateThread(function()
    while waitingForLoadAfterRestart do
        Citizen.Wait(200)
    end
    
    local isPlayerInside = true
    
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local coords2D = vec2(coords.x, coords.y)
        
        isPlayerInside = true
        
        -- Check all properties for zone entry
        for propertyId, property in pairs(Properties) do
            if property.metadata and property.metadata.zone and property.metadata.zone.points then
                local inZone = isPointInPolygon(coords2D, property.metadata.zone.points)
                
                if inZone then
                    -- Check Z bounds
                    if coords.z >= property.metadata.zone.minZ and coords.z <= property.metadata.zone.maxZ then
                        -- Enter property zone
                        if not isInPropertyZone then
                            isInPropertyZone = true
                            EnterZone(true, propertyId)
                            Citizen.Wait(150)
                        end
                        
                        -- Check interior zone for MLO properties
                        if property.metadata.interiorZone then
                            local inInterior = isPointInPolygon(coords2D, property.metadata.interiorZone.points)
                            
                            if inInterior then
                                if coords.z >= property.metadata.interiorZone.minZ and 
                                   coords.z <= property.metadata.interiorZone.maxZ then
                                    if not isInMLOInterior then
                                        isInMLOInterior = true
                                        Property:EnterProperty(property, property.id)
                                    end
                                end
                            end
                        end
                        
                        isPlayerInside = false
                        break
                    end
                end
            end
        end
        
        -- Check motel room interior zones
        if currentPropertyId and not isInMLOInterior then
            if currentPropertyData.type == "motel" then
                for _, room in pairs(Properties) do
                    if room.type == "mlo" and room.object_id == tonumber(currentPropertyId) then
                        if room.metadata.interiorZone then
                            local inRoomInterior = isPointInPolygon(coords2D, room.metadata.interiorZone.points)
                            
                            if inRoomInterior then
                                if coords.z >= room.metadata.interiorZone.minZ and 
                                   coords.z <= room.metadata.interiorZone.maxZ then
                                    isInMLOInterior = true
                                    Property:EnterProperty(room, room.id)
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- Check if player left interior zone
        if isInPropertyZone and currentPropertyId and currentPropertyData then
            if isInMLOInterior and CurrentPropertyData and CurrentPropertyData.metadata.interiorZone then
                local inInterior = isPointInPolygon(coords2D, CurrentPropertyData.metadata.interiorZone.points)
                
                if not inInterior or 
                   coords.z < CurrentPropertyData.metadata.interiorZone.minZ or 
                   coords.z > CurrentPropertyData.metadata.interiorZone.maxZ then
                    isInMLOInterior = false
                    
                    -- Clean up MLO interior state
                    if CurrentPropertyData.type == "mlo" then
                        -- Remove interior furniture
                        Property:RemoveFurniture()
                        
                        -- Remove interior target points (wardrobe, storage, etc.)
                        for i = #TargetPoints, 1, -1 do
                            if TargetPoints[i].type == "wardrobe" or TargetPoints[i].type == "storage" then
                                if TargetPoints[i].id then
                                    CL.Target("remove-zone", TargetPoints[i].id)
                                end
                                table.remove(TargetPoints, i)
                            end
                        end
                        
                        -- Clear current property data
                        CurrentProperty = nil
                        CurrentPropertyData = nil
                        
                        -- Notify server
                        TriggerServerEvent("vms_housing:sv:exitHouse")
                    end
                end
            end
            
            -- Check if player left property zone
            local inMainZone = isPointInPolygon(coords2D, currentPropertyData.metadata.zone.points)
            
            if not inMainZone or 
               coords.z < currentPropertyData.metadata.zone.minZ or 
               coords.z > currentPropertyData.metadata.zone.maxZ then
                isInPropertyZone = false
                isInMLOInterior = false
                ExitZone(true, currentPropertyId)
                Citizen.Wait(150)
            end
        end
        
        -- Optimize wait time based on whether player is in a zone
        Citizen.Wait(isPlayerInside and 800 or 100)
    end
end)