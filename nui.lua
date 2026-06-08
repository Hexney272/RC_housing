-- Housing System NUI Callbacks
-- Cleaned and deobfuscated version

-- ============================================
-- INITIALIZATION
-- ============================================

RegisterNUICallback("loaded", function(data, cb)
    Citizen.Wait(1500)
    
    local payload = {
        action = "loaded",
        lang = Config.Language,
        availableShells = AvailableShells,
        availableIPLS = AvailableIPLS,
        characterName = CharacterName,
        keysOnItem = Config.UseKeysOnItem,
        keyPrice = Config.KeyPrice,
        keysLimit = Config.KeysLimit,
        lockReplacementPrice = Config.LockReplacementPrice,
        useServiceBills = Config.UseServiceBills,
        furnitureSellPercentage = Config.FurnitureSellPercentage,
        requirePurchaseFurniture = Config.RequirePurchaseFurniture,
        deliveryFurnitureType = Config.DeliveryType,
        areaUnit = Config.AreaUnit,
        rentalCycles = Config.RentalCycles,
        allowedUnpaidRentBills = Config.AllowedUnpaidRentBills,
        allowChangeStoragePosition = Config.AllowChangeStoragePosition,
        allowChangeWardrobePosition = Config.AllowChangeWardrobePosition,
        allowTransactionFromMenu = Config.Marketplace.AllowTransactionFromMenu,
        usingVMSGarages = (Config.Garages == "vms_garagesv2")
    }
    
    if Config.UseServiceBills then
        payload.allowedUnpaidBills = Config.AllowedUnpaidBills
    end
    
    Citizen.Wait(200)
    SendNUIMessage(payload)
end)

-- ============================================
-- CLOSE NUI HANDLER
-- ============================================

function closeNUI(forceClose)
    if not forceClose then
        if openedMenu == "HousingCreator" then
            HousingCreator.Close()
        elseif openedMenu == "PropertyManage" then
            closeManageMenu()
        elseif openedMenu == "PropertyFurniture" then
            closeFurnitureMenu()
        elseif openedMenu == "PropertyFurniturePurchase" then
            SetNuiFocus(false, false)
        elseif openedMenu == "Safe" then
            CloseSafe()
        elseif openedMenu == "Marketplace" then
            closeMarketplace()
        elseif openedMenu == "PropertyOffer" or openedMenu == "BuildingMenu" or 
               openedMenu == "ApartmentMenu" or openedMenu == "Contract" then
            if openedMenu == "Contract" then
                TriggerServerEvent("vms_housing:sv:cancelContract")
            end
            Property.CloseOffer()
        end
    else
        if openedMenu == "PropertyOffer" or openedMenu == "BuildingMenu" or 
           openedMenu == "ApartmentMenu" or openedMenu == "Contract" then
            
            if openedMenu == "Contract" then
                TriggerServerEvent("vms_housing:sv:cancelContract")
            end
            Property.CloseOffer()
            
        elseif openedMenu == "PropertyManage" then
            closeManageMenu()
            
        elseif openedMenu == "PropertyFurniture" then
            closeFurnitureMenu()
            
        elseif openedMenu == "PropertyFurniturePurchase" then
            SetNuiFocus(false, false)
            
        elseif openedMenu == "Safe" then
            CloseSafe()
            
        elseif openedMenu == "Marketplace" then
            closeMarketplace()
        end
    end
end

RegisterNUICallback("close", function()
    closeNUI()
end)

-- ============================================
-- HOUSING CREATOR - SHELL FUNCTIONS
-- ============================================

RegisterNUICallback("creator:selectShell", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    
    houseConfiguration.type = "shell"
    houseConfiguration.shell = data.shell
end)

RegisterNUICallback("creator:previewShell", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    
    SendNUIMessage({
        action = "HousingCreator",
        actionName = "Update",
        data = { type = "hide-menu" }
    })
    
    SetNuiFocus(false, false)
    
    HousingCreator:EnterShell(data.shell, function()
        Citizen.CreateThread(function()
            while CurrentShell do
                drawText2D("Selected Shell:", 0.5, 0.08, 0.4, 255, 255, 255)
                drawText2D("~p~" .. data.shell .. "~s~", 0.5, 0.1, 0.65, 255, 255, 255)
                drawText2D("Press ~g~[X]~s~ to back", 0.5, 0.14, 0.3, 255, 255, 255)
                
                if IsControlJustPressed(0, 73) then -- X key
                    DeleteObject(CurrentShell)
                    
                    if houseConfiguration.previousCoords and houseConfiguration.previousCoords.x then
                        SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
                    end
                    
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                    
                    SetNuiFocus(true, true)
                    CurrentShell = false
                    break
                end
                
                Citizen.Wait(1)
            end
        end)
    end)
end)

-- ============================================
-- HOUSING CREATOR - IPL FUNCTIONS
-- ============================================

RegisterNUICallback("creator:selectIPL", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    
    houseConfiguration.type = "ipl"
    houseConfiguration.ipl = data.ipl
end)

RegisterNUICallback("creator:previewIPL", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    
    SendNUIMessage({
        action = "HousingCreator",
        actionName = "Update",
        data = { type = "hide-menu" }
    })
    
    SetNuiFocus(false, false)
    
    local defaultTheme = nil
    if AvailableIPLS[data.ipl] and AvailableIPLS[data.ipl].settings and 
       AvailableIPLS[data.ipl].settings.Themes then
        for theme, _ in pairs(AvailableIPLS[data.ipl].settings.Themes) do
            defaultTheme = theme
            break
        end
    end
    
    HousingCreator:EnterIPL(data.ipl, function()
        Citizen.CreateThread(function()
            while CurrentIPL do
                drawText2D("Selected IPL:", 0.5, 0.08, 0.4, 255, 255, 255)
                drawText2D("~p~" .. data.ipl .. "~s~", 0.5, 0.1, 0.65, 255, 255, 255)
                drawText2D("Press ~g~[E]~s~ to back", 0.5, 0.14, 0.3, 255, 255, 255)
                
                if IsControlJustPressed(0, 38) then -- E key
                    if houseConfiguration.previousCoords and houseConfiguration.previousCoords.x then
                        SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
                    end
                    
                    IPL.UnloadSettings(data.ipl)
                    
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                    
                    SetNuiFocus(true, true)
                    CurrentIPL = false
                    break
                end
                
                Citizen.Wait(1)
            end
        end)
    end, defaultTheme)
end)

-- ============================================
-- HOUSING CREATOR - ACTION BUTTON HANDLER
-- ============================================

RegisterNUICallback("creator:actionButton", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    
    local response = { action = "HousingCreator" }
    
    if data.type == "shell" or data.type == "ipl" or data.type == "mlo" or 
       data.type == "building" or data.type == "motel" then
        
        if data.action == "save" then
            HousingCreator:Save(data)
            response.actionName = "Open"
            
        elseif data.action == "delete" then
            TriggerServerEvent("vms_housing:sv:deleteHouse", data.id)
            response.actionName = "Open"
            
        elseif data.action == "address" then
            houseConfiguration.type = data.type
            local coords = GetEntityCoords(PlayerPedId())
            local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            local streetName = GetStreetNameFromHashKey(streetHash)
            
            houseConfiguration.address = streetName
            if not houseConfiguration.address or houseConfiguration.address == "" then
                houseConfiguration.address = "-"
            end
            
            response.actionName = "Update"
            response.data = {
                type = "update-input-value",
                inputName = data.action,
                housingType = data.type,
                value = houseConfiguration.address
            }
            
        elseif data.action == "region" then
            houseConfiguration.type = data.type
            local coords = GetEntityCoords(PlayerPedId())
            local region = library.GetCurrentRegion(coords.xyz)
            
            houseConfiguration.region = region or "None"
            
            response.actionName = "Update"
            response.data = {
                type = "update-input-value",
                inputName = data.action,
                housingType = data.type,
                value = houseConfiguration.region
            }
            
        elseif data.action == "yard_zone" or data.action == "interior_zone" or 
               data.action == "enter_point" or data.action == "exit_point" or
               data.action == "emergency_exit_outside" or data.action == "emergency_exit_inside" or
               data.action == "menu_point" or data.action == "add_single_doors" or
               data.action == "add_double_doors" or data.action == "add_slide_gate" or
               data.action == "remove_door" or data.action == "garage_point" or
               data.action == "enter_garage_point" or data.action == "wardrobe_point" or
               data.action == "storage_point" or data.action == "delivery_coordinates" then
            
            response.actionName = "Update"
            response.data = { type = "hide-menu" }
            
            if data.action ~= "remove_door" then
                SetNuiFocus(false, false)
            end
            
            -- Handle specific actions
            if data.action == "yard_zone" then
                HousingCreator:Polyzone()
                
            elseif data.action == "interior_zone" then
                HousingCreator:Polyzone(true)
                
            elseif data.action == "enter_point" then
                HousingCreator:CreateEnterPoint()
                
            elseif data.action == "exit_point" then
                HousingCreator:CreateExitPoint()
                
            elseif data.action == "emergency_exit_outside" then
                HousingCreator:CreateEmergencyExitOutsidePoint()
                
            elseif data.action == "emergency_exit_inside" then
                HousingCreator:CreateEmergencyExitInsidePoint(data.houseTheme)
                
            elseif data.action == "menu_point" then
                HousingCreator:CreateMenuPoint()
                
            elseif data.action == "add_single_doors" then
                HousingCreator:CreateDoor()
                
            elseif data.action == "add_double_doors" then
                HousingCreator:CreateDoor(true)
                
            elseif data.action == "add_slide_gate" then
                HousingCreator:CreateDoor(false, true)
                
            elseif data.action == "remove_door" then
                HousingCreator:RemoveDoor(data.doorId)
                return
                
            elseif data.action == "garage_point" then
                if data.isGarage then
                    HousingCreator:CreateGaragePoint()
                elseif data.isParking then
                    HousingCreator:CreateParkingSpaces()
                end
                
            elseif data.action == "enter_garage_point" then
                HousingCreator:CreateEnterGaragePoint()
                
            elseif data.action == "wardrobe_point" then
                HousingCreator:CreateWardrobePoint(false, data.houseTheme)
                
            elseif data.action == "storage_point" then
                HousingCreator:CreateStoragePoint(false, data.houseTheme)
                
            elseif data.action == "delivery_coordinates" then
                HousingCreator:CreateDeliveryPoint(data.isInside, data.isOutside, data.houseTheme)
            end
        end
        
    elseif data.type == "furniture" then
        if data.action == "save" then
            if data.model then
                HousingCreator:SaveFurniture(data)
                response.actionName = "Open"
            else
                return
            end
            
        elseif data.action == "delete" then
            if data.model then
                TriggerServerEvent("vms_housing:sv:deleteFurniture", data.model)
                response.actionName = "Open"
            else
                return
            end
            
        elseif data.action == "register" then
            if data.props then
                Citizen.CreateThread(function()
                    RegisterFurniture(data.props)
                end)
                response.actionName = "Close"
            end
        end
    end
    
    Citizen.Wait(250)
    
    if response.actionName == "Close" then
        SetNuiFocus(false, false)
    end
    
    SendNUIMessage(response)
end)

-- ============================================
-- HOUSING CREATOR - LOAD PROPERTY CONFIG
-- ============================================

RegisterNUICallback("creator:loadPropertyConfig", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    if not data.id then return end
    
    -- Always get fresh data from Properties table
    local property = Properties[tostring(data.id)]
    if not property then return end
    
    -- Ensure we have the latest metadata
    local metadata = property.metadata
    if metadata and metadata.wardrobe then
    end
    if metadata and metadata.storage then
    end
    
    houseConfiguration.type = property.type
    
    if property.type == "shell" then
        houseConfiguration.shell = metadata.shell
        
    elseif property.type == "ipl" then
        houseConfiguration.ipl = metadata.ipl
        
    elseif property.type == "mlo" then
        houseConfiguration.interiorZone = {
            points = library.Deepcopy(metadata.interiorZone.points),
            minZ = metadata.interiorZone.minZ,
            maxZ = metadata.interiorZone.maxZ
        }
        
        houseConfiguration.doors = library.Deepcopy(metadata.doors)
        
        for _, door in pairs(houseConfiguration.doors) do
            if door.left and door.left.hash then
                door.left.hash = nil
            end
            if door.right and door.right.hash then
                door.right.hash = nil
            end
            if door.hash then
                door.hash = nil
            end
        end
        
        houseConfiguration.menuCoords = library.Deepcopy(metadata.menu)
    end
    
    houseConfiguration.address = property.address
    houseConfiguration.region = property.region
    
    if metadata then
        if metadata.zone then
            houseConfiguration.zone = {
                points = library.Deepcopy(metadata.zone.points),
                minZ = metadata.zone.minZ,
                maxZ = metadata.zone.maxZ
            }
        end
        
        if metadata.wardrobe then
            houseConfiguration.wardrobeCoords = {
                x = metadata.wardrobe.x,
                y = metadata.wardrobe.y,
                z = metadata.wardrobe.z
            }
        end
        
        if metadata.storage then
            houseConfiguration.storageCoords = {
                x = metadata.storage.x,
                y = metadata.storage.y,
                z = metadata.storage.z,
                slots = tonumber(metadata.storage.slots or 1),
                weight = tonumber(metadata.storage.weight or 1)
            }
        end
        
        if metadata.enter then
            houseConfiguration.enterCoords = {
                x = metadata.enter.x,
                y = metadata.enter.y,
                z = metadata.enter.z
            }
        end
        
        if metadata.exit then
            houseConfiguration.exitCoords = {
                x = metadata.exit.x,
                y = metadata.exit.y,
                z = metadata.exit.z,
                w = metadata.exit.w
            }
        end
        
        if metadata.emergencyOutside then
            houseConfiguration.emergencyOutsideCoords = {
                x = metadata.emergencyOutside.x,
                y = metadata.emergencyOutside.y,
                z = metadata.emergencyOutside.z,
                w = metadata.emergencyOutside.w
            }
        end
        
        if metadata.emergencyInside then
            houseConfiguration.emergencyInsideCoords = {
                x = metadata.emergencyInside.x,
                y = metadata.emergencyInside.y,
                z = metadata.emergencyInside.z
            }
        end
        
        if metadata.garage then
            houseConfiguration.garageCoords = {
                x = metadata.garage.x,
                y = metadata.garage.y,
                z = metadata.garage.z,
                w = metadata.garage.w
            }
        end
        
        if metadata.parking then
            houseConfiguration.parkingSpaces = library.Deepcopy(metadata.parking)
        end
        
        if metadata.deliveryType then
            houseConfiguration.deliveryPoint = {
                x = metadata.delivery.x,
                y = metadata.delivery.y,
                z = metadata.delivery.z,
                w = metadata.delivery.w
            }
        end
    end
end)

-- ============================================
-- HOUSING CREATOR - GET DATA FUNCTIONS
-- ============================================

RegisterNUICallback("creator:getAllBuildings", function(data, cb)
    local buildings, motels = HousingCreator:GetObjects(true, true)
    cb({ buildings = buildings, motels = motels })
end)

RegisterNUICallback("creator:getBuildingParking", function(data, cb)
    local parkingSpaces = HousingCreator:GetBuildingParkingSpaces(tostring(data.id))
    cb(parkingSpaces)
end)

RegisterNUICallback("creator:getAllProperties", function(data, cb)
    cb(Properties)
end)

RegisterNUICallback("creator:getAllFurniture", function(data, cb)
    cb(Furniture)
end)

-- ============================================
-- HOUSING CREATOR - TELEPORT FUNCTIONS
-- ============================================

RegisterNUICallback("creator:teleportToProperty", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    
    local property = Properties[tostring(data.id)]
    
    if property then
        if property.metadata.menu and (property.metadata.menu.x ~= 0 or property.metadata.menu.y ~= 0 or property.metadata.menu.z ~= 0) then
            SetEntityCoords(PlayerPedId(), 
                property.metadata.menu.x, 
                property.metadata.menu.y, 
                property.metadata.menu.z)
                
        elseif property.metadata.exit then
            SetEntityCoords(PlayerPedId(), 
                property.metadata.exit.x, 
                property.metadata.exit.y, 
                property.metadata.exit.z)
                
        elseif property.metadata.zone and property.metadata.zone.points then
            -- Fallback: Calculate zone center for MLO properties
            local sumX, sumY, sumZ = 0, 0, 0
            local count = #property.metadata.zone.points
            for _, point in ipairs(property.metadata.zone.points) do
                sumX = sumX + point.x
                sumY = sumY + point.y
            end
            sumZ = (property.metadata.zone.minZ + property.metadata.zone.maxZ) / 2
            SetEntityCoords(PlayerPedId(), sumX / count, sumY / count, sumZ)
            
        elseif property.object_id then
            local building = Properties[tostring(property.object_id)]
            if building and building.metadata.exit then
                SetEntityCoords(PlayerPedId(), 
                    building.metadata.exit.x, 
                    building.metadata.exit.y, 
                    building.metadata.exit.z)
            end
        end
    end
end)

RegisterNUICallback("creator:teleportToDoors", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    
    local door = houseConfiguration.doors[tonumber(data.id)]
    
    if door then
        -- Use coords field for all door types (single, double, gate)
        if door.coords then
            SetEntityCoords(PlayerPedId(), door.coords.x, door.coords.y, door.coords.z)
        elseif door.center then
            -- Fallback for old door format
            SetEntityCoords(PlayerPedId(), door.center.x, door.center.y, door.center.z)
        end
    end
end)

RegisterNUICallback("creator:removeOwner", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    TriggerServerEvent("vms_housing:sv:removeOwner", data.id)
end)

RegisterNUICallback("creator:removeRenter", function(data, cb)
    if openedMenu ~= "HousingCreator" then return end
    TriggerServerEvent("vms_housing:sv:removeRenter", data.id)
end)

-- ============================================
-- APARTMENT FUNCTIONS
-- ============================================

RegisterNUICallback("apartments:getInformations", function(data, cb)
    if not data.apartmentId then return end
    
    local apartmentId = tostring(data.apartmentId)
    local currentProperty = GetCurrentPropertyData()
    
    if not currentProperty or currentProperty.type ~= "building" then return end
    
    local apartment = Properties[apartmentId]
    if not apartment or not apartment.object_id then return end
    
    SelectedApartment = apartmentId
    
    if tostring(apartment.object_id) ~= tostring(currentProperty.id) then return end
    
    local payload = {}
    
    if not apartment.owner and not apartment.renter then
        Property:ViewOffer(apartmentId)
        return
    else
        payload.buildingData = currentProperty
        ReloadApartmentMenu()
    end
    
    SendNUIMessage({
        action = "Property",
        actionName = "ApartmentMenu",
        data = payload
    })
    
    SetNuiFocus(true, true)
    openedMenu = "ApartmentMenu"
end)

local actionLimiter = 0

RegisterNUICallback("apartments:action", function(data, cb)
    if not data.action or not data.apartmentId then return end
    
    local apartmentId = tostring(data.apartmentId)
    
    -- Action rate limiting
    if actionLimiter ~= 0 then
        if actionLimiter + 3000 > GetGameTimer() then
            return CL.Notification(TRANSLATE("notify.wait"), 4500, "error")
        end
    end
    
    local currentProperty = GetCurrentPropertyData()
    if not currentProperty or currentProperty.type ~= "building" then return end
    
    local apartment = Properties[apartmentId]
    if not apartment or not apartment.object_id then return end
    if tostring(apartment.object_id) ~= tostring(GetCurrentPropertyId()) then return end
    
    actionLimiter = GetGameTimer()
    
    if data.action == "manage" then
        local handler = TargetHandler.Manage(apartmentId)
        if not apartment.metadata.lockdown then
            handler.action()
            SelectedApartment = nil
            SendNUIMessage({
                action = "Property",
                actionName = "CloseViewOffer",
                dontRemoveCurrentMenu = true
            })
        end
        
    elseif data.action == "lockdown" then
        if not apartment.metadata.lockdown then
            TriggerServerEvent("vms_housing:sv:lockdown", apartmentId)
        end
        
    elseif data.action == "remove_police_seal" then
        if apartment.metadata.lockdown then
            TriggerServerEvent("vms_housing:sv:removePoliceSeal", apartmentId)
        end
        
    elseif data.action == "raid" then
        local handler = TargetHandler.Raid(apartmentId, function(success)
            if success then
                TriggerServerEvent("vms_housing:sv:raidProperty", apartmentId)
            end
        end)
        Property.CloseOffer()
        handler.action()
        
    elseif data.action == "raid_lock" then
        if apartment.isUnderRaid then
            Property:ToggleLock(apartmentId, nil, true)
        end
        
    elseif data.action == "enter" then
        Property:EnterProperty(apartment, apartmentId, function(success)
            if success then
                Property.CloseOffer()
            end
        end)
        
    elseif data.action == "doorbell" then
        TriggerServerEvent("vms_housing:sv:ringDoorbell", apartmentId)
        
    elseif data.action == "lock" then
        if not apartment.metadata.lockdown then
            Property:ToggleLock(apartmentId)
        end
        
    elseif data.action == "lockpick" then
        local handler = TargetHandler.Lockpick(
            apartmentId,
            apartment.metadata?.upgrades?.antiBurglaryDoors,
            apartment.metadata?.upgrades?.alarm,
            function(success)
                TriggerServerEvent("vms_housing:sv:lockpickDoors", apartmentId, success)
            end
        )
        
        if apartment.metadata.locked and not apartment.metadata.lockdown then
            Property.CloseOffer()
            handler.action()
        end
    end
end)

-- ============================================
-- PROPERTY OFFER FUNCTIONS
-- ============================================

RegisterNUICallback("propertyOffer:enterHouse", function(data, cb)
    local property = data.apartmentId and Properties[data.apartmentId] or GetCurrentPropertyData()
    if not property then return end
    
    if property.metadata.shell then
        local shellData = AvailableShells[property.metadata.shell]
        if not shellData then return end
        
        Property.CloseOffer()
        local doors = shellData.doors
        
        HousingCreator:EnterShell(property.metadata.shell, function()
            CL.HandleAction("enterInteriorPreview")
            TriggerServerEvent("vms_housing:sv:enterPreviewHouse", 
                data.apartmentId or GetCurrentPropertyId())
            
            if ToggleWeather then
                Citizen.CreateThread(function()
                    while CurrentShell do
                        if CurrentShell then
                            ToggleWeather(true)
                        end
                        Citizen.Wait(30000)
                    end
                end)
            end
            
            local zoneId = CL.Target("zone", {
                coords = vector3(doors.x, doors.y, doors.z + 1.5),
                size = vec(1.5, 2.1, 2.0),
                rotation = doors.heading,
                options = {{
                    name = "property-exit",
                    icon = "fa-solid fa-door-open",
                    label = TRANSLATE("target.exit"),
                    action = function()
                        DeleteObject(CurrentShell)
                        CurrentShell = false
                        
                        if ToggleWeather then
                            ToggleWeather(false)
                        end
                        
                        CL.Target("remove-zone", zoneId)
                        
                        -- Wait a frame for shell to be deleted
                        Citizen.Wait(100)
                        
                        -- Get exit coordinates - prioritize apartment's own exit, then parent building
                        local exitCoords = nil
                        
                        -- First check if this apartment has its own exit point
                        if property and property.metadata and property.metadata.exit then
                            exitCoords = property.metadata.exit
                        -- Otherwise try parent building exit
                        elseif property.object_id then
                            local parentBuilding = Properties[tostring(property.object_id)]
                            if parentBuilding and parentBuilding.metadata and parentBuilding.metadata.exit then
                                exitCoords = parentBuilding.metadata.exit
                            end
                        end
                        
                        if exitCoords then
                            SetEntityCoords(PlayerPedId(), 
                                exitCoords.x,
                                exitCoords.y,
                                exitCoords.z)
                            SetEntityHeading(PlayerPedId(), exitCoords.w)
                        end
                        
                        CL.HandleAction("exitInteriorPreview")
                        TriggerServerEvent("vms_housing:sv:exitPreviewHouse",
                            data.apartmentId or GetCurrentPropertyId())
                    end
                }}
            })
        end)
        
    elseif property.metadata.ipl then
        local iplData = AvailableIPLS[property.metadata.ipl]
        if not iplData then return end
        
        Property.CloseOffer()
        local doors = iplData.doors
        
        HousingCreator:EnterIPL(
            property.metadata.ipl,
            function()
                CL.HandleAction("enterInteriorPreview")
                TriggerServerEvent("vms_housing:sv:enterPreviewHouse",
                    data.apartmentId or GetCurrentPropertyId())
                
                if ToggleWeather then
                    Citizen.CreateThread(function()
                        while CurrentIPL do
                            if CurrentIPL then
                                ToggleWeather(true, true)
                            end
                            Citizen.Wait(30000)
                        end
                    end)
                end
                
                local zoneId = CL.Target("zone", {
                    coords = vector3(doors.x, doors.y, doors.z + 1.5),
                    size = vec(1.5, 2.1, 2.0),
                    rotation = doors.heading,
                    options = {{
                        name = "property-exit",
                        icon = "fa-solid fa-door-open",
                        label = TRANSLATE("target.exit"),
                        action = function()
                            IPL.UnloadSettings(CurrentIPL)
                            CurrentIPL = false
                            
                            if ToggleWeather then
                                ToggleWeather(false)
                            end
                            
                            CL.Target("remove-zone", zoneId)
                            
                            -- Wait a frame for IPL to be unloaded
                            Citizen.Wait(100)
                            
                            -- Get exit coordinates - prioritize apartment's own exit, then parent building
                            local exitCoords = nil
                            
                            -- First check if this apartment has its own exit point
                            if property and property.metadata and property.metadata.exit then
                                exitCoords = property.metadata.exit
                            -- Otherwise try parent building exit
                            elseif property.object_id then
                                local parentBuilding = Properties[tostring(property.object_id)]
                                if parentBuilding and parentBuilding.metadata and parentBuilding.metadata.exit then
                                    exitCoords = parentBuilding.metadata.exit
                                end
                            end
                            
                            if exitCoords then
                                SetEntityCoords(PlayerPedId(),
                                    exitCoords.x,
                                    exitCoords.y,
                                    exitCoords.z)
                                SetEntityHeading(PlayerPedId(), exitCoords.w)
                            end
                            
                            CL.HandleAction("exitInteriorPreview")
                            TriggerServerEvent("vms_housing:sv:exitPreviewHouse",
                                data.apartmentId or GetCurrentPropertyId())
                        end
                    }}
                })
            end,
            data.iplTheme or property.metadata.iplTheme
        )
    end
end)

-- ============================================
-- CONTRACT FUNCTIONS
-- ============================================

RegisterNUICallback("propertyOffer:contractDone", function(data, cb)
    
    if data.contractType == "rent" then
        if isOfferByMarketplace then
            TriggerServerEvent("vms_housing:sv:rentPropertyMarketplace",
                marketplaceOfferId, data.paymentMethod, data.rentCycle,
                { apartmentId = data.apartmentId })
        else
            TriggerServerEvent("vms_housing:sv:rentProperty",
                GetCurrentPropertyId(), data.paymentMethod, data.rentCycle,
                { selectedTheme = data.selectedTheme, apartmentId = data.apartmentId })
        end
    else
        if isOfferByMarketplace then
            TriggerServerEvent("vms_housing:sv:purchasePropertyMarketplace",
                marketplaceOfferId, data.paymentMethod,
                { apartmentId = data.apartmentId })
        else
            local propId = GetCurrentPropertyId()
            TriggerServerEvent("vms_housing:sv:purchaseProperty",
                propId, data.paymentMethod,
                { selectedTheme = data.selectedTheme, apartmentId = data.apartmentId })
        end
    end
    
    -- Don't close immediately, wait for server response
    
    -- Callback to UI
    cb({})
end)

RegisterNUICallback("propertyContract:send", function(data, cb)
    local propertyId = MotelManageId or CurrentProperty or GetCurrentPropertyId()
    
    TriggerServerEvent("vms_housing:sv:sendPropertyContract",
        propertyId, data.contractType, data.player, data.price,
        data.paymentMethod, data.rentCycle)
    
    closeManageMenu()
    Property.CloseOffer()
end)

RegisterNUICallback("propertyContract:signed", function(data, cb)
    TriggerServerEvent("vms_housing:sv:signedPropertyContract")
    Property.CloseOffer()
end)

RegisterNUICallback("propertyOffer:close", function(data, cb)
    Property.CloseOffer()
    cb({})
end)

RegisterNUICallback("propertyOffer:cancel", function(data, cb)
    Property.CloseOffer()
    cb({})
end)

-- ============================================
-- PROPERTY FURNITURE FUNCTIONS
-- ============================================

RegisterNUICallback("propertyTheme:edit", function(data, cb)
    closeFurnitureMenu()
    editTheme(data.theme)
end)

RegisterNUICallback("propertyFurniture:edit", function(data, cb)
    Property.EditingFurniture = true
    editFurniture()
    closeFurnitureMenu()
end)

RegisterNUICallback("propertyFurniture:placeNew", function(data, cb)
    manageFurniture(false, data.model, data.id)
    closeFurnitureMenu()
end)

RegisterNUICallback("propertyFurniture:purchaseAccept", function(data, cb)
    if Property.EditingTheme then
        library.Callback("vms_housing:buyTheme", function(success)
            if success then
                Property.EditingTheme = false
                SendNUIMessage({
                    action = "Property",
                    actionName = "CloseFurniturePurchase"
                })
                SetNuiFocus(false, false)
            end
        end, CurrentProperty or GetCurrentPropertyId(), Property.EditingTheme, data.paymentMethod)
    else
        library.Callback("vms_housing:buyFurniture", function(success)
            if success then
                Property.EditingFurniture = false
                DeleteObject(Property.EditingFurnitureObj)
                Property.EditingFurnitureObj = nil
                SendNUIMessage({
                    action = "Property",
                    actionName = "CloseFurniturePurchase"
                })
                SetNuiFocus(false, false)
            end
        end, CurrentProperty or GetCurrentPropertyId(), Property.EditingFurnitureData, data.paymentMethod)
    end
end)

RegisterNUICallback("propertyFurniture:purchaseCancel", function(data, cb)
    SendNUIMessage({
        action = "Property",
        actionName = "CloseFurniturePurchase"
    })
    
    if Property.EditingTheme then
        if CurrentIPL then
            local propertyData = CurrentPropertyData or GetCurrentPropertyData()
            IPL.LoadSettings(
                CurrentIPL,
                propertyData.metadata.iplTheme,
                propertyData.metadata.iplSettings,
                function()
                    local coords = GetEntityCoords(PlayerPedId())
                    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
                end
            )
            Property.EditingTheme = false
        end
    end
    
    if Property.EditingFurnitureObj then
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = true,
            controlsLabel = furnitureMode == "gizmo" and "furniture:gizmo" or "furniture:walkmode",
            controlsName = furnitureMode == "gizmo" and "Furniture:gizmo" or "Furniture:walkmode"
        })
    end
    
    SetNuiFocus(false, false)
end)

-- ============================================
-- PROPERTY MANAGE ACTIONS
-- ============================================

RegisterNuiCallback("propertyManage:action", function(data, cb)
    if not data.action then return end
    
    local propertyId = MotelManageId or CurrentProperty or GetCurrentPropertyId()
    
    if data.action == "buy-key" then
        if not library.HasPermissions(propertyId, "keysManage") then return end
        if library.ActionLimiter() then return end
        
        TriggerServerEvent("vms_housing:sv:buyKey", propertyId)
        
    elseif data.action == "lock-replacement" then
        if not library.HasPermissions(propertyId, "keysManage") then return end
        if library.ActionLimiter() then return end
        
        TriggerServerEvent("vms_housing:sv:lockReplacement", propertyId)
        
    elseif data.action == "take-to-storage" then
        if not data.furnitureId then return end
        if not library.HasPermissions(propertyId, "furniture") then return end
        
        TriggerServerEvent("vms_housing:sv:takeFurnitureToStorage", propertyId, data.furnitureId)
        
    elseif data.action == "checkout-furniture" then
        if not data.payment or not data.model then return end
        if not library.HasPermissions(propertyId, "furniture") then return end
        
        local property = Properties[tostring(propertyId)]
        local currentFurnitureCount = property.furniture and #property.furniture or 0
        local furnitureLimit = GetFurnitureLimit(property.metadata.upgrades)
        
        if currentFurnitureCount >= furnitureLimit then
            return CL.Notification(
                TRANSLATE("notify.property:reached_furniture_limit"),
                6000, "error"
            )
        end
        
        TriggerServerEvent("vms_housing:sv:checkoutFurniture", propertyId, data.payment, data.model)
        
    elseif data.action == "purchase-upgrade" then
        if not data.name then return end
        
        -- Check if player is owner or has permission
        local property = Properties[propertyId]
        local myIdentifier = CL.GetIdentifier()
        local isOwner = property and property.owner == myIdentifier
        
        if not isOwner and not library.HasPermissions(propertyId, "upgradesManage") then 
            return 
        end
        
        TriggerServerEvent("vms_housing:sv:upgrade", propertyId, data.name)
        
    elseif data.action == "marketplace-remove" then
        if not library.HasPermissions(propertyId, "marketplaceManage") then return end
        
        TriggerServerEvent("vms_housing:sv:marketplaceRemove", propertyId)
        
    elseif data.action == "marketplace-add" then
        if not library.HasPermissions(propertyId, "marketplaceManage") then return end
        if library.ActionLimiter() then return end
        
        TriggerServerEvent("vms_housing:sv:marketplaceAdd", propertyId, data)
        
    elseif data.action == "change-wardrobe-position" then
        if not library.HasPermissions(propertyId, "furniture") then return end
        
        HousingCreator:CreateWardrobePoint(true)
        closeNUI()
        
    elseif data.action == "change-storage-position" then
        if not library.HasPermissions(propertyId, "furniture") then return end
        
        HousingCreator:CreateStoragePoint(true)
        closeNUI()
        
    elseif data.action == "remove-permission" then
        if library.ActionLimiter() then return end
        
        TriggerServerEvent("vms_housing:sv:removePermission", propertyId, data.identifier)
        
    elseif data.action == "remove-key" then
        if not library.HasPermissions(propertyId, "keysManage") then return end
        
        TriggerServerEvent("vms_housing:sv:removeKey", propertyId, data.identifier)
        
    elseif data.action == "modal-accepted" then
        
        if data.type == "marketplace-sell" then
            if not library.HasPermissions(propertyId, "automaticSell") then return end
            
            TriggerServerEvent("vms_housing:sv:automaticSale", propertyId)
            
        elseif data.type == "pay-bill" then
            if not library.HasPermissions(propertyId, "billPayments") then return end
            
            TriggerServerEvent("vms_housing:sv:payTheBill", propertyId, data.period, data.billType)
            
        elseif data.type == "make-photo" then
            if not library.HasPermissions(propertyId, "marketplaceManage") then return end
            
            Property.MarketplacePhotoMode(propertyId, data.imageId)
            
        elseif data.type == "save-photo" then
            if not library.HasPermissions(propertyId, "marketplaceManage") then return end
            if not data.imageUrl or data.imageUrl == "" then return end
            
            TriggerServerEvent("vms_housing:sv:saveMarketplacePhoto",
                propertyId, data.imageId, data.imageUrl)
                
        elseif data.type == "remove-photo" then
            if not library.HasPermissions(propertyId, "marketplaceManage") then return end
            
            TriggerServerEvent("vms_housing:sv:saveMarketplacePhoto",
                propertyId, data.imageId, nil)
                
        elseif data.type == "rental-terminate-now" then
            if not library.HasPermissions(propertyId, "rentersManage") then return end
            
            TriggerServerEvent("vms_housing:sv:rentalTerminateNow", propertyId)
            
        elseif data.type == "rental-termination" then
            if not library.HasPermissions(propertyId, "rentersManage") then return end
            
            TriggerServerEvent("vms_housing:sv:setRentalTermination", propertyId)
            
        elseif data.type == "rental-cancel-termination" then
            if not library.HasPermissions(propertyId, "rentersManage") then return end
            
            TriggerServerEvent("vms_housing:sv:clearRentalTermination", propertyId)
            
        elseif data.type == "add-player-permission" then
            TriggerServerEvent("vms_housing:sv:addPermission", propertyId, data.id)
            
        elseif data.type == "save-permission" then
            TriggerServerEvent("vms_housing:sv:updatePermission", propertyId, data.identifier, {
                garage = data.garage,
                furniture = data.furniture,
                billPayments = data.billPayments,
                keysManage = data.keysManage,
                upgradesManage = data.upgradesManage,
                marketplaceManage = data.marketplaceManage,
                sell = data.sell,
                automaticSell = data.automaticSell,
                rent = data.rent,
                rentersManage = data.rentersManage
            })
            
        elseif data.type == "sell-furniture" then
            if not data.furnitureId then return end
            if not library.HasPermissions(propertyId, "furniture") then return end
            
            TriggerServerEvent("vms_housing:sv:sellFurniture",
                propertyId, data.furnitureId, data.model)
                
        elseif data.type == "remove-furniture" then
            if not data.furnitureId then return end
            if not library.HasPermissions(propertyId, "furniture") then return end
            
            TriggerServerEvent("vms_housing:sv:removeFurniture",
                propertyId, data.furnitureId, data.model)
                
        elseif data.type == "give-key" then
            if not library.HasPermissions(propertyId, "keysManage") then return end
            
            TriggerServerEvent("vms_housing:sv:giveKey", propertyId, data.id)
            
        elseif data.type == "move-out" then
            TriggerServerEvent("vms_housing:sv:moveOut", propertyId)
        end
    end
end)

-- ============================================
-- MARKETPLACE FUNCTIONS
-- ============================================

RegisterNuiCallback("marketplace:getProperty", function(data, cb)
    local property = Properties[tostring(data.id)]
    
    if property and 
       ((property.sale and property.sale.active == true) or 
        (property.rental and property.rental.active == true)) then
        
        local response = {
            isOwner = (property.owner == Identifier),
            id = data.id,
            type = property.type,
            name = property.name,
            region = property.region,
            regionData = Config.Regions[property.region] or Config.NoRegion,
            address = property.address,
            description = property.description,
            metadata = property.metadata,
            sale = property.sale,
            rental = property.rental
        }
        
        if property.object_id then
            local building = Properties[tostring(property.object_id)]
            if building then
                response.building = {
                    type = building.type,
                    name = building.name
                }
            end
        end
        
        cb(response)
    end
end)

RegisterNuiCallback("marketplace:markOnGps", function(data, cb)
    local property = Properties[tostring(data.id)]
    
    if property then
        if property.metadata.enter then
            SetNewWaypoint(property.metadata.enter.x, property.metadata.enter.y)
            CL.Notification(TRANSLATE("notify.marketplace:marked_on_gps"), 5000, "success")
            
        elseif property.metadata.menu then
            SetNewWaypoint(property.metadata.menu.x, property.metadata.menu.y)
            CL.Notification(TRANSLATE("notify.marketplace:marked_on_gps"), 5000, "success")
            
        elseif property.object_id then
            local building = Properties[tostring(property.object_id)]
            if building and building.metadata.enter then
                SetNewWaypoint(building.metadata.enter.x, building.metadata.enter.y)
                CL.Notification(TRANSLATE("notify.marketplace:marked_on_gps"), 5000, "success")
            end
        end
    end
end)

RegisterNuiCallback("marketplace:showContract", function(data, cb)
    local property = Properties[tostring(data.id)]
    
    if property then
        isOfferByMarketplace = true
        marketplaceOfferId = tostring(data.id)
        
        local electricity = (Config.Regions[property.region] and 
            Config.Regions[property.region].electricity) or Config.NoRegion.electricity
            
        local internet = (Config.Regions[property.region] and 
            Config.Regions[property.region].internet) or Config.NoRegion.internet
            
        local water = (Config.Regions[property.region] and 
            Config.Regions[property.region].water) or Config.NoRegion.water
        
        SendNUIMessage({
            action = "Property",
            actionName = "ViewOfferContract",
            data = {
                isByMarketplace = true,
                address = property.address,
                electricity = electricity,
                internet = internet,
                water = water,
                rentPrice = (property.rental and property.rental.active and property.rental.price) or nil,
                purchasePrice = (property.sale and property.sale.active and property.sale.price) or nil
            }
        })
    end
end)

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

RegisterNUICallback("getClosestPlayers", function(data, cb)
    if not openedMenu then return end
    
    local players = CL.GetClosestPlayers()
    local serverIds = {}
    
    if players and next(players) then
        for _, playerId in pairs(players) do
            if playerId ~= PlayerId() then
                table.insert(serverIds, GetPlayerServerId(playerId))
            end
        end
    end
    
    SendNUIMessage({
        action = "Property",
        actionName = "RefreshClosestPlayers",
        data = serverIds
    })
end)

RegisterNUICallback("sendNotification", function(data, cb)
    CL.Notification(TRANSLATE(data.name), 5000, data.type)
    cb({})
end)

-- Client event to update upgrade UI after purchase (without closing menu)
RegisterNetEvent("vms_housing:cl:upgradeCompleted")
AddEventHandler("vms_housing:cl:upgradeCompleted", function(upgradeName, ownUpgrades, furnitureLimit)
    
    -- Send message to NUI to update the upgrades UI
    SendNUIMessage({
        action = "Property",
        actionName = "UpgradeCompleted",
        upgradeName = upgradeName,
        ownUpgrades = ownUpgrades,
        furnitureLimit = furnitureLimit
    })
end)

-- ============================================
-- PROPERTY MANAGE - ACTION HANDLER
-- ============================================
RegisterNUICallback("propertyManageAction", function(data, cb)
    if not data.action then return end
    
    local propertyId = MotelManageId or CurrentProperty or GetCurrentPropertyId()
    
    if data.action == "purchase-upgrade" then
        if not data.name then return end
        
        -- Check if player is owner or has permission
        local property = Properties[propertyId]
        local myIdentifier = CL.GetIdentifier()
        local isOwner = property and property.owner == myIdentifier
        
        if not isOwner and not library.HasPermissions(propertyId, "upgradesManage") then 
            return 
        end
        
        TriggerServerEvent("vms_housing:sv:upgrade", propertyId, data.name)
        
    elseif data.action == "remove-permission" then
        -- Remove player permission
        TriggerServerEvent("vms_housing:sv:removePermission", propertyId, data.identifier)
        
    elseif data.action == "marketplace-add" then
        if not library.HasPermissions(propertyId, "marketplaceManage") then return end
        if library.ActionLimiter() then return end
        
        -- Add property to marketplace
        TriggerServerEvent("vms_housing:sv:addToMarketplace", propertyId, data)
        
    elseif data.action == "marketplace-remove" then
        if not library.HasPermissions(propertyId, "marketplaceManage") then return end
        
        -- Remove property from marketplace
        TriggerServerEvent("vms_housing:sv:marketplaceRemove", propertyId)
        
    elseif data.action == "buy-key" then
        -- Buy a new key
        TriggerServerEvent("vms_housing:sv:buyKey", propertyId, data.targetPlayerId)
        
    elseif data.action == "lock-replacement" then
        -- Replace lock (removes all keys)
        TriggerServerEvent("vms_housing:sv:lockReplacement", propertyId)
        
    elseif data.action == "checkout-furniture" then
        if not data.payment or not data.model then return end
        if not library.HasPermissions(propertyId, "furniture") then return end
        
        -- Check furniture limit
        local property = Properties[tostring(propertyId)]
        local currentFurnitureCount = property.furniture and #property.furniture or 0
        local furnitureLimit = GetFurnitureLimit(property.metadata.upgrades)
        
        if currentFurnitureCount >= furnitureLimit then
            return CL.Notification(
                TRANSLATE("notify.property:reached_furniture_limit"),
                6000, "error"
            )
        end
        
        TriggerServerEvent("vms_housing:sv:checkoutFurniture", propertyId, data.payment, data.model)
        
    elseif data.action == "take-to-storage" then
        if not data.furnitureId then return end
        if not library.HasPermissions(propertyId, "furniture") then return end
        
        TriggerServerEvent("vms_housing:sv:takeFurnitureToStorage", propertyId, data.furnitureId)
        
    elseif data.action == "change-wardrobe-position" then
        if not library.HasPermissions(propertyId, "furniture") then return end
        
        HousingCreator:CreateWardrobePoint(true)
        closeNUI()
        
    elseif data.action == "change-storage-position" then
        if not library.HasPermissions(propertyId, "furniture") then return end
        
        HousingCreator:CreateStoragePoint(true)
        closeNUI()
        
    elseif data.action == "check-cameras" then
        if not library.HasAnyPermission(propertyId) then return end
        
        checkCameras(propertyId, function(success)
            if success then
                closeNUI()
            else
                CL.Notification(
                    TRANSLATE("notify.cameras:no_cameras_installed"),
                    3000, "error"
                )
            end
        end, data.environment)
        
    elseif data.action == "modal-accepted" then
        -- Handle modal accepted actions
        if data.type == "marketplace-sell" then
            if not library.HasPermissions(propertyId, "automaticSell") then return end
            
            TriggerServerEvent("vms_housing:sv:autoSellProperty", propertyId)
            
        elseif data.type == "save-photo" then
            if not library.HasPermissions(propertyId, "marketplaceManage") then return end
            if not data.imageUrl or data.imageUrl == "" then return end
            
            TriggerServerEvent("vms_housing:sv:saveMarketplacePhoto",
                propertyId, data.imageId, data.imageUrl)
                
        elseif data.type == "remove-photo" then
            if not library.HasPermissions(propertyId, "marketplaceManage") then return end
            
            TriggerServerEvent("vms_housing:sv:saveMarketplacePhoto",
                propertyId, data.imageId, nil)
        else
        end
        
    else
        -- Handle other actions
    end
    
    cb({})
end)