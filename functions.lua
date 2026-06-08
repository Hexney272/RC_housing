-- Housing System Functions
-- Cleaned and deobfuscated version

-- ============================================
-- OWNERSHIP CHECKING FUNCTIONS
-- ============================================

function HasOwnership(property)
    if IsOwner(property) or IsRenter(property) or library.HasKeys(property.id) then
        return true
    end
    return false
end

function IsOwner(property)
    return property.owner ~= nil
end

function IsRenter(property)
    return property.renter ~= nil
end

function GetFurnitureLimit(upgrades)
    local upgradeConfig = Config.HousingUpgrades.furniture_limit
    
    if not upgradeConfig then
        return Config.FurnitureLimit
    end
    
    if not upgrades then
        return Config.FurnitureLimit
    end
    
    -- Get the furniture limit upgrade level
    local furnitureLimitLevel = upgrades[upgradeConfig.metadata] or upgrades.furnitureLimit
    
    if furnitureLimitLevel and upgradeConfig.levels and upgradeConfig.levels[tostring(furnitureLimitLevel)] then
        return upgradeConfig.levels[tostring(furnitureLimitLevel)].limit
    end
    
    return Config.FurnitureLimit
end

-- ============================================
-- BLIP MANAGEMENT
-- ============================================

function RefreshBlips()
    -- Remove all existing blips
    for i = 1, #Blips do
        RemoveBlip(Blips[i])
        Blips[i] = nil
    end
    
    -- Create new blips for all properties
    for propertyId, property in pairs(Properties) do
        local blipConfig = nil
        
        -- Determine blip type based on property status
        if property.type == "building" then
            blipConfig = Config.Blips.Building
            
        elseif property.type == "motel" then
            blipConfig = Config.Blips.Motel
            
        elseif property.owner == Identifier then
            blipConfig = Config.Blips.HouseOwner
            
        elseif property.renter == Identifier then
            blipConfig = Config.Blips.HouseRenter
            
        elseif library.HasKeys(propertyId) then
            blipConfig = Config.Blips.HouseKeyHolder
            
        elseif not property.owner and not property.renter then
            blipConfig = Config.Blips.HouseForSale
        end
        
        -- Create blip if config exists and property has metadata
        if blipConfig and property.metadata then
            if property.type == "motel" then
                local center = getZoneCenter(
                    property.metadata.zone.points,
                    property.metadata.zone.minZ,
                    property.metadata.zone.maxZ
                )
                
                table.insert(Blips, library.CreateBlip({
                    coords = vector3(center.x, center.y, center.z),
                    sprite = blipConfig.sprite,
                    display = blipConfig.display,
                    scale = blipConfig.scale,
                    color = blipConfig.color,
                    name = blipConfig.name,
                    blipCategory = property.blipCategory
                }))
                
            elseif property.metadata.menu and (property.metadata.menu.x ~= 0 or property.metadata.menu.y ~= 0 or property.metadata.menu.z ~= 0) then
                if not property.object_id then
                    table.insert(Blips, library.CreateBlip({
                        coords = vector3(
                            property.metadata.menu.x,
                            property.metadata.menu.y,
                            property.metadata.menu.z
                        ),
                        sprite = blipConfig.sprite,
                        display = blipConfig.display,
                        scale = blipConfig.scale,
                        color = blipConfig.color,
                        name = blipConfig.name,
                        blipCategory = property.blipCategory
                    }))
                end
                
            elseif property.metadata.zone and property.metadata.zone.points then
                -- Fallback: Use zone center for MLO properties without menu point
                if not property.object_id then
                    local center = getZoneCenter(
                        property.metadata.zone.points,
                        property.metadata.zone.minZ,
                        property.metadata.zone.maxZ
                    )
                    
                    table.insert(Blips, library.CreateBlip({
                        coords = vector3(center.x, center.y, center.z),
                        sprite = blipConfig.sprite,
                        display = blipConfig.display,
                        scale = blipConfig.scale,
                        color = blipConfig.color,
                        name = blipConfig.name,
                        blipCategory = property.blipCategory
                    }))
                end
                
            elseif property.metadata.enter then
                if not property.object_id then
                    table.insert(Blips, library.CreateBlip({
                        coords = vector3(
                            property.metadata.enter.x,
                            property.metadata.enter.y,
                            property.metadata.enter.z
                        ),
                        sprite = blipConfig.sprite,
                        display = blipConfig.display,
                        scale = blipConfig.scale,
                        color = blipConfig.color,
                        name = blipConfig.name,
                        blipCategory = property.blipCategory
                    }))
                end
            end
        end
    end
end

-- ============================================
-- TARGET SYSTEM
-- ============================================

function RefreshTargets()
    local propertyId = GetCurrentPropertyId()
    local property = GetCurrentPropertyData()
    
    if not property then
        -- Clean up if outside property
        if not CurrentShell and not CurrentIPL then
            for i = 1, #TargetPoints do
                if TargetPoints[i].type == "entity" or TargetPoints[i].type == "door" then
                    CL.Target("remove-entity", TargetPoints[i].entity)
                else
                    CL.Target("remove-zone", TargetPoints[i].id)
                end
            end
            TargetPoints = {}
        end
        return
    end
    
    -- Remove existing target points
    for i = 1, #TargetPoints do
        if TargetPoints[i].type == "entity" or TargetPoints[i].type == "door" then
            CL.Target("remove-entity", TargetPoints[i].entity)
        else
            CL.Target("remove-zone", TargetPoints[i].id)
        end
    end
    
    TargetPoints = {}
    
    -- Handle different property types
    if property.type == "building" then
        local apartments = Property:GetApartments(property, true)
        
        -- Create entrance target for building
        table.insert(TargetPoints, {
            type = "zone",
            id = CL.Target("zone", {
                coords = property.metadata.enter,
                size = vec(1.0, 1.5, 2.0),
                rotation = property.metadata.exit.w,
                options = {{
                    name = "property-offer",
                    icon = "fa-solid fa-scroll",
                    label = TRANSLATE("target.view_house"),
                    action = function()
                        Property:BuildingMenu(property, apartments)
                    end
                }}
            })
        })
        
        -- VMS Garages V2 integration
        if Config.Garages == "vms_garagesv2" then
            if property.metadata.parkingEnter and property.metadata.parkingSpaces then
                local parkingOptions = {}
                
                for spaceId, space in pairs(property.metadata.parkingSpaces) do
                    table.insert(parkingOptions, {
                        name = "property-garage-" .. spaceId,
                        icon = "fa-solid fa-warehouse",
                        label = TRANSLATE("target.enter_underground_parking", spaceId),
                        distance = 3.0,
                        action = function()
                            exports.vms_garagesv2:enterApartmentParking(
                                "vms_housing:parking:" .. propertyId .. ":" .. spaceId
                            )
                        end,
                        canInteract = function()
                            return Property.IsHaveAnyApartment(tostring(propertyId))
                        end
                    })
                end
                
                table.insert(TargetPoints, {
                    type = "zone",
                    id = CL.Target("zone", {
                        coords = vector3(
                            property.metadata.parkingEnter.x,
                            property.metadata.parkingEnter.y,
                            property.metadata.parkingEnter.z
                        ),
                        size = vec(2.0, 2.0, 2.0),
                        rotation = property.metadata.parkingEnter.w,
                        options = parkingOptions
                    })
                })
            end
        end
        
    elseif property.type == "motel" then
        local rooms = Property:GetMotelRooms(property)
        
        
        for _, room in pairs(rooms) do
            local options = {}
            local roomId = tostring(room.id)
            
            -- Options for rooms with owner/renter
            if room.owner or room.renter then
                if library.HasAnyPermission(roomId) then
                    table.insert(options, TargetHandler.Manage(roomId, function()
                        return not room.metadata.lockdown
                    end))
                end
                
                -- MLO furniture management
                if room.type == "mlo" then
                    if library.HasPermissions(roomId, "furniture") then
                        if room.metadata.allowFurnitureInside then
                            table.insert(options, TargetHandler.Furniture(function()
                                return IsInsideMLO and not room.metadata.lockdown
                            end))
                        end
                    end
                end
                
                -- Lock toggle (if not using keys on item)
                if not Config.UseKeysOnItem then
                    if room.type ~= "mlo" then
                        table.insert(options, TargetHandler.ToggleLock(roomId, function()
                            return library.HasKeys(roomId) and not room.metadata.lockdown
                        end))
                    end
                end
                
                -- Doorbell & Enter
                if room.type ~= "mlo" then
                    table.insert(options, TargetHandler.Doorbell(roomId))
                    table.insert(options, TargetHandler.Enter(
                        function()
                            Property:EnterProperty(room, roomId)
                        end,
                        function()
                            return not room.metadata.locked and not room.metadata.lockdown
                        end
                    ))
                    
                    -- Lockpick option
                    if Config.Lockpick and Config.Lockpick.Enable then
                        table.insert(options, TargetHandler.Lockpick(
                            roomId,
                            room.metadata?.upgrades?.antiBurglaryDoors,
                            room.metadata?.upgrades?.alarm,
                            function(success)
                                TriggerServerEvent("vms_housing:sv:lockpickDoors", roomId, success)
                            end,
                            function()
                                return room.metadata.locked and not room.metadata.lockdown
                            end
                        ))
                    end
                end
                
                -- Load MLO doors
                if room.type == "mlo" then
                    Property:LoadDoors(room.metadata.doors, roomId)
                end
                
                -- Police actions
                local lockdownOption = TargetHandler.Lockdown(
                    function()
                        TriggerServerEvent("vms_housing:sv:lockdown", roomId)
                    end,
                    function()
                        return not room.metadata.lockdown
                    end
                )
                if lockdownOption then
                    table.insert(options, lockdownOption)
                end
                
                local removeSealOption = TargetHandler.RemoveSeal(
                    function()
                        TriggerServerEvent("vms_housing:sv:removePoliceSeal", roomId)
                    end,
                    function()
                        return room.metadata.lockdown
                    end
                )
                if removeSealOption then
                    table.insert(options, removeSealOption)
                end
                
                if room.type ~= "mlo" then
                    local raidOption = TargetHandler.Raid(
                        roomId,
                        function(success)
                            if success then
                                TriggerServerEvent("vms_housing:sv:raidProperty", roomId)
                            end
                        end,
                        function()
                            return room.metadata.locked and not room.isUnderRaid
                        end
                    )
                    if raidOption then
                        table.insert(options, raidOption)
                    end
                    
                    local raidLockOption = TargetHandler.RaidLock(
                        function()
                            Property:ToggleLock(roomId, nil, true)
                        end,
                        function()
                            return room.isUnderRaid
                        end
                    )
                    if raidLockOption then
                        table.insert(options, raidLockOption)
                    end
                end
                
            else
                -- Room for sale/rent - show View Offer option
                if not room.owner and not room.renter then
                    if (room.sale and room.sale.active) or (room.rental and room.rental.active) then
                        table.insert(options, TargetHandler.ViewOffer(roomId))
                    end
                    if room.type == "mlo" and room.metadata.doors then
                        Property:LoadDoors(room.metadata.doors, roomId, false, true)
                    end
                end
            end
            
            -- Create target zone if there are options
            if next(options) then
                table.insert(TargetPoints, {
                    type = "zone",
                    id = CL.Target("zone", {
                        coords = (room.type == "mlo" and room.metadata.menu) or room.metadata.enter,
                        size = vec(1.0, 1.5, 2.8),
                        rotation = (room.type == "mlo" and 0.0) or room.metadata.exit.w,
                        options = options
                    })
                })
            end
        end
        
    else
        -- Handle shell/IPL/MLO/regular properties
        if not CurrentShell and not CurrentIPL then
            if property.metadata.enter or property.metadata.menu then
                local options = {}
                
                -- Options for owner/renter
                if property.owner or property.renter then
                    if library.HasAnyPermission(propertyId) then
                        table.insert(options, TargetHandler.Manage(nil, function()
                            return not property.metadata.lockdown
                        end))
                    end
                    
                    if library.HasPermissions(propertyId, "furniture") then
                        if property.metadata.allowFurnitureOutside then
                            table.insert(options, TargetHandler.Furniture(function()
                                return not property.metadata.lockdown
                            end))
                        end
                    end
                    
                    if not Config.UseKeysOnItem then
                        if property.type ~= "mlo" then
                            table.insert(options, TargetHandler.ToggleLock(nil, function()
                                return library.HasKeys(propertyId) and not property.metadata.lockdown
                            end))
                        end
                    end
                    
                    if property.type ~= "mlo" then
                        table.insert(options, TargetHandler.Doorbell(propertyId))
                        table.insert(options, TargetHandler.Enter(
                            function()
                                Property:EnterProperty(property)
                            end,
                            function()
                                return not property.metadata.locked and not property.metadata.lockdown
                            end
                        ))
                        
                        if Config.Lockpick and Config.Lockpick.Enable then
                            table.insert(options, TargetHandler.Lockpick(
                                propertyId,
                                property.metadata?.upgrades?.antiBurglaryDoors,
                                property.metadata?.upgrades?.alarm,
                                function(success)
                                    TriggerServerEvent("vms_housing:sv:lockpickDoors", propertyId, success)
                                end,
                                function()
                                    return property.metadata.locked and not property.metadata.lockdown
                                end
                            ))
                        end
                    end
                    
                    -- Police actions
                    local lockdownOption = TargetHandler.Lockdown(
                        function()
                            TriggerServerEvent("vms_housing:sv:lockdown", propertyId)
                        end,
                        function()
                            return not property.metadata.lockdown
                        end
                    )
                    if lockdownOption then
                        table.insert(options, lockdownOption)
                    end
                    
                    local removeSealOption = TargetHandler.RemoveSeal(
                        function()
                            TriggerServerEvent("vms_housing:sv:removePoliceSeal", propertyId)
                        end,
                        function()
                            return property.metadata.lockdown
                        end
                    )
                    if removeSealOption then
                        table.insert(options, removeSealOption)
                    end
                    
                    local raidOption = TargetHandler.Raid(
                        nil,
                        function(success)
                            if success then
                                TriggerServerEvent("vms_housing:sv:raidProperty", propertyId)
                            end
                        end,
                        function()
                            return property.metadata.locked and not property.isUnderRaid
                        end
                    )
                    if raidOption then
                        table.insert(options, raidOption)
                    end
                    
                    local raidLockOption = TargetHandler.RaidLock(
                        function()
                            Property:ToggleLock(nil, nil, true)
                        end,
                        function()
                            return property.isUnderRaid
                        end
                    )
                    if raidLockOption then
                        table.insert(options, raidLockOption)
                    end
                    
                else
                    -- Property for sale/rent                    
                    if property.sale then
                    else
                    end
                    
                    if property.rental then
                    else
                    end
                    
                    if not property.owner and not property.renter then
                        if (property.sale and property.sale.active) or 
                           (property.rental and property.rental.active) then
                            table.insert(options, TargetHandler.ViewOffer(propertyId))
                        else
                            print("^1[vms_housing] Property " .. tostring(propertyId) .. " is not for sale or rent^7")
                        end
                    end
                end
                
                -- Create target zone
                if next(options) then
                    -- Determine coordinates for target zone
                    local targetCoords
                    if property.type == "mlo" then
                        -- For MLO, use menu point if available and valid, otherwise use zone center
                        if property.metadata.menu and (property.metadata.menu.x ~= 0 or property.metadata.menu.y ~= 0 or property.metadata.menu.z ~= 0) then
                            targetCoords = property.metadata.menu
                        elseif property.metadata.zone and property.metadata.zone.points then
                            -- Calculate zone center as fallback                            
                            local sumX, sumY, sumZ = 0, 0, 0
                            local count = #property.metadata.zone.points
                            
                            if count > 0 then
                                for _, point in ipairs(property.metadata.zone.points) do
                                    sumX = sumX + point.x
                                    sumY = sumY + point.y
                                end
                                sumZ = (property.metadata.zone.minZ + property.metadata.zone.maxZ) / 2
                                targetCoords = vector3(sumX / count, sumY / count, sumZ)
                            else
                            end
                        end
                    else
                        targetCoords = property.metadata.enter
                    end
                    
                    if targetCoords then
                        -- Ensure coords are in proper format
                        local coords = type(targetCoords) == "vector3" and targetCoords or vec3(targetCoords.x, targetCoords.y, targetCoords.z)
                        
                        
                        table.insert(TargetPoints, {
                            type = "zone",
                            id = CL.Target("zone", {
                                coords = coords,
                                size = (property.type == "mlo" and vec(1.5, 1.5, 2.8)) or vec(1.0, 1.5, 2.8),
                                rotation = (property.type == "mlo" and 0.0) or (property.metadata.exit and property.metadata.exit.w or 0.0),
                                options = options
                            })
                        })
                    else
                        print("^1[vms_housing] Could not create target zone - no valid coordinates found^7")
                    end
                end
            end
        end
        
        -- Garage target
        if not CurrentShell and not CurrentIPL then
            if property.metadata.garage then
                if library.HasPermissions(propertyId, "garage") then
                    table.insert(TargetPoints, {
                        type = "zone",
                        id = CL.Target("zone", {
                            coords = property.metadata.garage,
                            size = vec(2.5, 2.5, 2.0),
                            rotation = property.metadata.garage.w,
                            options = {{
                                name = "property-garage",
                                icon = "fa-solid fa-warehouse",
                                label = TRANSLATE("target.garage"),
                                distance = 2.5,
                                action = function()
                                    if Property.EditingFurniture then
                                        return CL.Notification(
                                            TRANSLATE("notify.furniture:you_are_in_furniture_mode"),
                                            5000, "info"
                                        )
                                    end
                                    
                                    if not OpenGarage then
                                        return warn("")
                                    end
                                    
                                    OpenGarage(propertyId, property)
                                end,
                                canInteract = function()
                                    return not property.metadata.lockdown
                                end
                            }}
                        })
                    })
                end
            end
        end
    end
    
    -- Load interior interactables for MLO
    if CurrentPropertyData and CurrentPropertyData.type == "mlo" then
        if IsInsideMLO() then
            -- Wardrobe
            if CurrentPropertyData.metadata?.wardrobe?.x then
                table.insert(TargetPoints, TargetHandler.Wardrobe(
                    CurrentProperty,
                    CurrentPropertyData.metadata.wardrobe.x,
                    CurrentPropertyData.metadata.wardrobe.y,
                    CurrentPropertyData.metadata.wardrobe.z
                ))
            end
            
            -- Storage
            if CurrentPropertyData.metadata?.storage?.x then
                table.insert(TargetPoints, TargetHandler.Storage(
                    CurrentProperty,
                    CurrentPropertyData.metadata.storage.x,
                    CurrentPropertyData.metadata.storage.y,
                    CurrentPropertyData.metadata.storage.z,
                    CurrentPropertyData.metadata.storage.slots,
                    CurrentPropertyData.metadata.storage.weight
                ))
            end
        end
    end
    
    -- Load doors for MLO
    if property.type == "mlo" then
        Property:LoadDoors(
            property.metadata.doors,
            nil,
            true,
            property.owner == nil
        )
    end
    
    -- Load interior interactables for shell/IPL
    if CurrentShell or CurrentIPL then
        Property:LoadInteriorInteractable()
    end
end

-- ============================================
-- APARTMENT MENU FUNCTIONS
-- ============================================

function ReloadApartmentMenu()
    local apartment = Properties[SelectedApartment]
    
    local data = {
        isOwner = IsOwner(apartment),
        isRenter = IsRenter(apartment),
        isKeyHolder = library.HasKeys(SelectedApartment),
        apartmentData = apartment,
        hasPermManage = library.HasAnyPermission(SelectedApartment),
        canLockdown = false,
        canRemovePoliceSeal = false,
        canRaid = false,
        canLockAfterRaid = false
    }
    
    local serverPermissions = library.CallbackAwait(
        "vms_housing:checkApartmentActions",
        SelectedApartment
    )
    
    -- Check lockpick availability
    if Config.Lockpick and Config.Lockpick.Enable then
        data.canLockpick = apartment.metadata.locked and not apartment.metadata.lockdown
    end
    
    -- Check police action permissions
    data.canLockdown = not apartment.metadata.lockdown
    data.canRemovePoliceSeal = apartment.metadata.lockdown and serverPermissions.allowedRemovePoliceSeal
    data.canRaid = apartment.metadata.locked and not apartment.isUnderRaid
    data.canLockAfterRaid = apartment.isUnderRaid and serverPermissions.allowedLockAfterRaid
    
    SendNUIMessage({
        action = "Property",
        actionName = "ReloadApartmentMenu",
        data = data
    })
end

-- ============================================
-- SPAWN/TELEPORT FUNCTIONS
-- ============================================

function SpawnInLastProperty(callback)
    library.Callback("vms_housing:checkLastProperty", function(hasProperty, propertyData, buildingData)
        if not hasProperty or not propertyData then
            if callback then
                callback(false)
            end
            return
        end
        
        -- Validate shell/IPL existence
        if propertyData.type == "shell" then
            if not AvailableShells[propertyData.metadata.shell] then
                return warn('Could not find shell "' .. propertyData.metadata.shell .. '"!')
            end
            
            if not library.RequestEntity(propertyData.metadata.shell) then
                return warn('Failed to load shell "' .. propertyData.metadata.shell .. '" - make sure it is running!')
            end
            
        elseif propertyData.type == "ipl" then
            if not AvailableIPLS[propertyData.metadata.ipl] then
                return warn('Could not find ipl "' .. propertyData.metadata.ipl .. '"!')
            end
        end
        
        FreezeEntityPosition(PlayerPedId(), true)
        
        if callback then
            callback(true)
        end
        
        -- Set current property
        CurrentProperty = tostring(propertyData.id)
        
        if Properties and next(Properties) and not Properties[CurrentProperty] then
            Properties[CurrentProperty] = propertyData
        end
        
        if buildingData then
            if Properties and next(Properties) and not Properties[tostring(buildingData.id)] then
                Properties[tostring(buildingData.id)] = buildingData
            end
        end
        
        CurrentPropertyData = Properties[tostring(propertyData.id)]
        
        -- Load interior based on type
        if propertyData.type == "shell" then
            CurrentShell = CreateObjectNoOffset(
                joaat(propertyData.metadata.shell),
                0.0, 0.0, 500.0,
                false, false, false
            )
            
            while not DoesEntityExist(CurrentShell) do
                Wait(1)
            end
            
            SetEntityHeading(CurrentShell, 0.0)
            FreezeEntityPosition(CurrentShell, true)
            Property:LoadStaticInteractable(AvailableShells[propertyData.metadata.shell])
            
        elseif propertyData.type == "ipl" then
            CurrentIPL = propertyData.metadata.ipl
            IPL.LoadSettings(
                CurrentIPL,
                propertyData.metadata.iplTheme,
                propertyData.metadata.iplSettings
            )
            Property:LoadStaticInteractable(AvailableIPLS[propertyData.metadata.ipl])
        end
        
        TriggerServerEvent("vms_housing:sv:enterHouse", CurrentProperty)
        
        -- Toggle weather system
        if ToggleWeather then
            Citizen.CreateThread(function()
                while CurrentShell or CurrentIPL do
                    if CurrentShell or CurrentIPL then
                        ToggleWeather(true, propertyData.type == "ipl")
                    end
                    Citizen.Wait(30000)
                end
            end)
        end
        
        -- Set light state
        if propertyData.metadata.lightState ~= nil then
            SetArtificialLightsState(not propertyData.metadata.lightState)
        end
        
        -- Load furniture
        if propertyData and propertyData.furniture then
            Property:LoadFurniture("inside", propertyData.furniture, CurrentProperty)
        end
        
        FreezeEntityPosition(PlayerPedId(), false)
        Property:LoadInteriorInteractable()
    end)
end

-- ============================================
-- PLAYER PROPERTY FUNCTIONS
-- ============================================

function GetPlayerProperties()
    local playerProperties = {}
    
    for propertyId, property in pairs(Properties) do
        if property.owner == Identifier or property.renter == Identifier then
            table.insert(playerProperties, property)
        end
    end
    
    return playerProperties
end

function GetProperty(propertyId)
    local property = Properties[tostring(propertyId)]
    return property or nil
end

-- ============================================
-- EXPORTS
-- ============================================

exports("GetPlayerProperties", GetPlayerProperties)
exports("GetProperty", GetProperty)

exports("IsPlayerOnPropertyZone", function()
    local propertyId = GetCurrentPropertyId()
    return propertyId ~= nil, propertyId
end)

exports("IsPlayerInsideProperty", function()
    return CurrentProperty, CurrentPropertyData
end)

exports("GetConfiguration", function(key)
    return Config[key]
end)