-- Player Dropped Event Handler
RegisterNetEvent("vms_housing:cl:playerDropped", function()
    if ToggleWeather then
        ToggleWeather(false)
    end
    
    if CurrentShell then
        DeleteObject(CurrentShell)
    end
    
    Property:RemoveFurniture()
    
    if Config.Marketplace.__ped then
        DeleteEntity(Config.Marketplace.__ped)
    end
end)

-- House Created Event Handler
RegisterNetEvent("vms_housing:cl:createdHouse", function(propertyId, propertyData)
    if not propertyData then return end
    
    -- Update property data
    Properties[propertyId] = propertyData
    local property = Properties[propertyId]
    
    -- Register new MLO doors
    if property and property.type == "mlo" then
        local doors = property.metadata and property.metadata.doors
        if doors then
            local forceLock = not (property.owner or property.renter)
            Property:RegisterDoors({
                propertyId = propertyId,
                forceLock = forceLock,
                doors = doors
            })
        end
    end
    
    RefreshBlips()
    RefreshTargets()
    
    -- Check if should exit zone
    local currentPropertyId = GetCurrentPropertyId()
    if currentPropertyId ~= propertyId then
        local objectId = property.object_id
        if objectId and tostring(currentPropertyId) == tostring(objectId) then
            ExitZone()
        end
    else
        ExitZone()
    end
end)

-- House Removed Event Handler
RegisterNetEvent("vms_housing:cl:removedHouse", function(propertyId)
    local property = Properties[propertyId]
    
    -- Remove MLO doors
    if property and property.type == "mlo" then
        local doors = property.metadata and property.metadata.doors
        if doors then
            for _, door in pairs(doors) do
                if door.type == "double" then
                    if door.left and door.left.hash then
                        DoorSystemSetDoorState(door.left.hash, 4, false, false)
                        DoorSystemSetDoorState(door.left.hash, 0, false, false)
                        RemoveDoorFromSystem(door.left.hash)
                    end
                    if door.right and door.right.hash then
                        DoorSystemSetDoorState(door.right.hash, 4, false, false)
                        DoorSystemSetDoorState(door.right.hash, 0, false, false)
                        RemoveDoorFromSystem(door.right.hash)
                    end
                elseif door.hash then
                    DoorSystemSetDoorState(door.hash, 4, false, false)
                    DoorSystemSetDoorState(door.hash, 0, false, false)
                    RemoveDoorFromSystem(door.hash)
                end
            end
        end
    end
    
    Properties[propertyId] = nil
    RefreshBlips()
    
    if GetCurrentPropertyId() == propertyId then
        ExitZone()
    end
end)

-- Enter House Event Handler
RegisterNetEvent("vms_housing:cl:enterHouse", function(propertyId)
        
    local property = GetProperty(propertyId)
    if not property then 
        return 
    end
    
    if CurrentShell then 
        return 
    end
    
    if CurrentIPL then 
        return 
    end
    
    -- Skip callback checks for now and do client-side permission check
        
    local playerIdentifier = CL.GetIdentifier()
    
    -- Check if player can enter
    local canEnter = false
    if property.owner == playerIdentifier then
                canEnter = true
    elseif property.renter == playerIdentifier then
                canEnter = true
    elseif property.metadata and not property.metadata.locked then
                canEnter = true
    else
                library.Notification(TRANSLATE("notify.property:locked"), 5000, "error")
        return
    end
    
        
    -- Load shell or IPL
    if property.type == "shell" then
        local shellData = AvailableShells[property.metadata.shell]
        if not shellData then
            return warn("Could not find shell \"" .. property.metadata.shell .. "\"!")
        end
        
        local loaded = library.RequestEntity(property.metadata.shell)
        if not loaded then
            return warn("Failed to load shell \"" .. property.metadata.shell .. "\" - make sure it is running!")
        end
    elseif property.type == "ipl" then
        local iplData = AvailableIPLS[property.metadata.ipl]
        if not iplData then
            return warn("Could not find ipl \"" .. property.metadata.ipl .. "\"!")
        end
    elseif property.type == "mlo" then
        -- For MLO properties, set current property data and load interactables
        CurrentProperty = tostring(propertyId)
        CurrentPropertyData = property
        
        -- Notify server that player has entered
        TriggerServerEvent("vms_housing:sv:enterHouse", propertyId)
        
        -- Load furniture
        if property and property.furniture then
            Property:LoadFurniture("inside", property.furniture, CurrentProperty)
        end
        
        -- Refresh targets to load wardrobe, storage, etc.
        RefreshTargets()
        
        return
    else
        return
    end
    
    Property:RemoveFurniture()
    
    -- Fade out screen
    DoScreenFadeOut(1500)
    Wait(1500)
    FreezeEntityPosition(PlayerPedId(), true)
    
    CurrentProperty = tostring(propertyId)
    CurrentPropertyData = property
    
    -- Create shell
    if property.type == "shell" then
                CurrentShell = CreateObjectNoOffset(
            joaat(property.metadata.shell),
            0.0, 0.0, 500.0,
            false, false, false
        )
        
        while not DoesEntityExist(CurrentShell) do
            Wait(1)
        end
        
                SetEntityHeading(CurrentShell, 0.0)
        FreezeEntityPosition(CurrentShell, true)
        
        -- Wait for shell collision to load
        Wait(500)
        
        -- Teleport player to shell entrance
        local shellData = AvailableShells[property.metadata.shell]
        if shellData and shellData.doors then
            -- Check if doors.z is already an absolute position or a relative offset
            local doorZ = shellData.doors.z
            if doorZ > 100 then
                -- It's likely an absolute position (like 499.59), use it directly
                doorZ = shellData.doors.z
            else
                -- It's a relative offset, add to base height
                doorZ = 500.0 + shellData.doors.z
            end
            
            local doorPos = vector3(shellData.doors.x, shellData.doors.y, doorZ)
                        
            -- Keep player frozen during teleport
            FreezeEntityPosition(PlayerPedId(), true)
            SetEntityCoords(PlayerPedId(), doorPos.x, doorPos.y, doorPos.z, false, false, false, false)
            SetEntityHeading(PlayerPedId(), shellData.doors.h or 0.0)
            
            -- Wait for position to settle and collision to load
            Wait(500)
            
            -- Try setting position again to ensure it sticks
            SetEntityCoords(PlayerPedId(), doorPos.x, doorPos.y, doorPos.z, false, false, false, false)
            
                    else
        end
        
        Property:LoadStaticInteractable(AvailableShells[property.metadata.shell])
        
    elseif property.type == "ipl" then
        CurrentIPL = property.metadata.ipl
        IPL.LoadSettings(CurrentIPL, property.metadata.iplTheme, property.metadata.iplSettings)
        
        -- Teleport player to IPL entrance
        local iplData = AvailableIPLS[property.metadata.ipl]
        if iplData and iplData.doors then
            local doorPos = vector3(iplData.doors.x, iplData.doors.y, iplData.doors.z)
            SetEntityCoords(PlayerPedId(), doorPos.x, doorPos.y, doorPos.z, false, false, false, false)
            SetEntityHeading(PlayerPedId(), iplData.doors.h or 0.0)
        end
        
        Property:LoadStaticInteractable(AvailableIPLS[property.metadata.ipl])
    end
    
    TriggerServerEvent("vms_housing:sv:enterHouse", CurrentProperty)
    
    -- Toggle weather system
    if ToggleWeather then
        Citizen.CreateThread(function()
            while CurrentShell or CurrentIPL do
                if CurrentShell or CurrentIPL then
                    ToggleWeather(true, property.type == "ipl")
                end
                Citizen.Wait(30000)
            end
        end)
    end
    
    Wait(1500)
    
    -- Unfreeze player after teleportation
    FreezeEntityPosition(PlayerPedId(), false)
    
    -- Set lighting state for interior only
    -- Note: SetArtificialLightsState affects the entire world, so we only use it inside shells/IPLs
    -- where the player is isolated from the outside world
    if CurrentPropertyData.metadata.lightState ~= nil and (CurrentShell or CurrentIPL) then
        -- SetArtificialLightsState(true) = lights OFF, SetArtificialLightsState(false) = lights ON
        SetArtificialLightsState(not CurrentPropertyData.metadata.lightState)
        SetArtificialLightsStateAffectsVehicles(false)  -- Don't affect vehicle lights
    else
    end
    
    DoScreenFadeIn(1500)
        
    -- Notify server that player has entered
    TriggerServerEvent("vms_housing:sv:enterHouse", propertyId)
    
    -- Load furniture
    if property and property.furniture then
        Property:LoadFurniture("inside", property.furniture, CurrentProperty)
    end
    
    -- Load interior interactables (including exit door)
    Property:LoadInteriorInteractable()
        
    FreezeEntityPosition(PlayerPedId(), false)
    RefreshTargets()
end)

-- Key Item Used Event Handler
RegisterNetEvent("vms_housing:cl:usedKeyItem", function(propertyId, isLocked)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local property = Properties[propertyId]
    local isInsideBuilding = false
    
    -- Check if inside building
    if property.object_id then
        local currentId = tostring(GetCurrentPropertyId())
        local objectId = tostring(property.object_id)
        isInsideBuilding = (currentId == objectId)
    end
    
    local currentPropertyId = GetCurrentPropertyId()
    
    -- Handle MLO doors
    if (currentPropertyId == propertyId or isInsideBuilding) and property.type == "mlo" then
        local doors = property.metadata.doors
        if not doors then return end
        
        local closestDoorId = nil
        
        -- Find closest door
        for doorId, door in pairs(doors) do
            if door.type == "slide_gate" then
                local doorCoords = vector3(door.coords.x, door.coords.y, door.coords.z)
                local distance = #(playerCoords.xyz - doorCoords)
                local maxDist = door.distance or 8.5
                
                if distance < maxDist then
                    closestDoorId = doorId
                end
                
            elseif door.type == "double" then
                local centerCoords = vector3(door.center.x, door.center.y, door.center.z)
                local distance = #(playerCoords.xyz - centerCoords)
                local maxDist = door.distance or 1.5
                
                if distance < maxDist then
                    closestDoorId = doorId
                    break
                end
                
            elseif door.type == "single" then
                local doorCoords = vector3(door.coords.x, door.coords.y, door.coords.z)
                local distance = #(playerCoords.xyz - doorCoords)
                local maxDist = door.distance or 1.5
                
                if distance < maxDist then
                    closestDoorId = doorId
                    break
                end
            end
        end
        
        if not closestDoorId then return end
        
        -- Check cooldown
        if Property.LastLockedDoors then
            if GetGameTimer() <= Property.LastLockedDoors then
                CL.Notification(TRANSLATE("notify.doors:wait"), 3500, "info")
                return
            end
        end
        
        TriggerServerEvent("vms_housing:sv:toggleDoorlock", propertyId, closestDoorId, nil, false, false)
        Property.LastLockedDoors = GetGameTimer() + 2000
        
    -- Handle shell/IPL interior doors
    elseif (currentPropertyId == propertyId or isInsideBuilding) and property.metadata and property.metadata.enter then
        local enterCoords = vector3(property.metadata.enter.x, property.metadata.enter.y, property.metadata.enter.z)
        local distance = #(playerCoords.xyz - enterCoords)
        
        if distance > 1.5 then return end
        
        Property:ToggleLock(propertyId, isLocked)
        
    -- Handle current property doors (inside shell/IPL)
    elseif CurrentProperty == propertyId then
        if CurrentShell then
            local shellData = AvailableShells[property.metadata.shell]
            if not shellData or not shellData.doors then return end
            
            local doorCoords = vector3(shellData.doors.x, shellData.doors.y, shellData.doors.z)
            local distance = #(playerCoords.xyz - doorCoords)
            
            if distance > 1.5 then return end
            
            Property:ToggleLock(propertyId, isLocked)
            
        elseif CurrentIPL then
            local iplData = AvailableIPLS[property.metadata.ipl]
            if not iplData or not iplData.doors then return end
            
            local doorCoords = vector3(iplData.doors.x, iplData.doors.y, iplData.doors.z)
            local distance = #(playerCoords.xyz - doorCoords)
            
            if distance > 1.5 then return end
            
            Property:ToggleLock(propertyId, isLocked)
        end
    end
end)

-- ============================================================================
-- EVENT: Sync Property (Full property update from server)
-- ============================================================================
RegisterNetEvent("vms_housing:cl:syncProperty")
AddEventHandler("vms_housing:cl:syncProperty", function(propertyId, propertyData)
    
    -- Update the Properties table with new data
    if Properties[tostring(propertyId)] then
        Properties[tostring(propertyId)] = propertyData
        
        -- Update CurrentPropertyData if this is the current property
        if CurrentProperty == tostring(propertyId) then
            CurrentPropertyData = propertyData
        end
    end
end)

-- ============================================================================
-- EVENT: Update Property
-- ============================================================================
RegisterNetEvent("vms_housing:cl:updateProperty")
AddEventHandler("vms_housing:cl:updateProperty", function(updateType, propId, updateData, sourcePlayer)
    propId = tostring(propId)
    local shouldRefreshBlips = false
    local shouldRefreshTargets = false
    local shouldReloadFurniture = false
    local shouldReloadTheme = false
    local shouldRegisterDoors = false
    
    local property = Properties[propId]
    if not property and updateType ~= "deliveredFurniture" then return end
    
    local objectId = property and property.object_id
    local isBuilding = false
    
    if objectId then
        objectId = tostring(objectId)
        local buildingData = Properties[objectId]
        isBuilding = buildingData and buildingData.type == "building"
    end
    
    local uiUpdateData = nil
    
    -- Handle different update types
    if updateType == "newOwner" then
        Property:UnlockDoors(property.metadata and property.metadata.doors)
        
        property.owner = updateData.owner
        property.owner_name = updateData.owner_name
        property.renter = updateData.renter
        property.renter_name = updateData.renter_name
        property.sale = updateData.sale
        property.rental = updateData.rental
        
        if updateData.permissions then
            property.permissions = updateData.permissions
        end
        if updateData.keys then
            property.keys = updateData.keys
        end
        if updateData.bills then
            property.bills = updateData.bills
        end
        if updateData.iplTheme then
            property.metadata.iplTheme = updateData.iplTheme
        end
        
        -- Close property offer UI if open and player just purchased
        local myIdentifier = CL.GetIdentifier()
        
        if openedMenu == "PropertyOffer" and property.owner == myIdentifier then
            Property.CloseOffer()
        end
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        shouldRefreshBlips = true
        shouldRefreshTargets = true
        
    elseif updateType == "newRenter" then
        Property:UnlockDoors(property.metadata and property.metadata.doors)
        
        property.renter = updateData.renter
        property.renter_name = updateData.renter_name
        property.permissions = updateData.permissions
        property.sale = updateData.sale
        property.rental = updateData.rental
        
        if updateData.keys then
            property.keys = updateData.keys
        end
        property.bills = updateData.bills
        
        if updateData and updateData.iplTheme then
            property.metadata.iplTheme = updateData.iplTheme
        end
        
        -- Close property offer UI if open and player just rented
        local myIdentifier = CL.GetIdentifier()
        if openedMenu == "PropertyOffer" and property.renter == myIdentifier then
            Property.CloseOffer()
        end
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        shouldRefreshBlips = true
        shouldRefreshTargets = true
        
    elseif updateType == "forceRemovedOwner" then
        if not property.renter then
            Property:LockDoors(property.metadata and property.metadata.doors)
        end
        
        property.owner = nil
        property.owner_name = nil
        
        if updateData.completelyRemoved then
            property.keys = updateData.keys
            property.permissions = updateData.permissions
            property.metadata = updateData.metadata
            property.sale = updateData.sale
            property.rental = updateData.rental
        end
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        if openedMenu == "HousingCreator" then
            SendNUIMessage({
                action = "HousingCreator",
                actionName = "RefreshPropertiesMenu"
            })
        end
        
        shouldRefreshBlips = true
        shouldRefreshTargets = true
        shouldRegisterDoors = true
        
    elseif updateType == "forceRemovedRenter" then
        if not property.owner then
            Property:LockDoors(property.metadata and property.metadata.doors)
        end
        
        property.renter = nil
        property.renter_name = nil
        property.keys = updateData.keys
        property.permissions = updateData.permissions
        
        if updateData.completelyRemoved then
            property.metadata = updateData.metadata
            property.sale = updateData.sale
            property.rental = updateData.rental
        end
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        if openedMenu == "HousingCreator" then
            SendNUIMessage({
                action = "HousingCreator",
                actionName = "RefreshPropertiesMenu"
            })
        end
        
        shouldRefreshBlips = true
        shouldRefreshTargets = true
        
    elseif updateType == "autoSellProperty" then
        Property:LockDoors(property.metadata and property.metadata.doors)
        
        property.owner = nil
        property.owner_name = nil
        property.renter = nil
        property.renter_name = nil
        property.keys = updateData.keys
        property.permissions = {}
        property.metadata = updateData.metadata
        property.sale = updateData.sale
        property.rental = updateData.rental
        property.furniture = {}
        
        shouldRefreshBlips = true
        shouldRefreshTargets = true
        shouldRegisterDoors = true
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            closeManageMenu()
        end
        
    elseif updateType == "metadata" then
        -- Update entire metadata object
        property.metadata = updateData
        
        -- Update current property data if we're inside
        if CurrentProperty and CurrentProperty == propId then
            CurrentPropertyData.metadata = updateData
        end
        
        -- Refresh targets to update wardrobe/storage positions
        shouldRefreshTargets = true
        
    elseif updateType == "toggleLight" then
        property.metadata.lightState = updateData.lightState
        
        -- Only toggle lights if we're inside the property and in a shell/IPL
        if CurrentProperty and CurrentProperty == propId and (CurrentShell or CurrentIPL) then
            -- When lightState is true (lights ON), we want SetArtificialLightsState(false) to enable lights
            -- When lightState is false (lights OFF), we want SetArtificialLightsState(true) to disable lights
            SetArtificialLightsState(not property.metadata.lightState)
            SetArtificialLightsStateAffectsVehicles(false)
            
            -- For shells, we might need to force a lighting update
            if CurrentShell then
                -- Force lighting refresh for shell
                if property.metadata.lightState then
                    -- Lights ON - ensure they're visible
                    SetArtificialLightsState(false)
                    SetArtificialLightsStateAffectsVehicles(false)
                else
                    -- Lights OFF
                    SetArtificialLightsState(true)
                    SetArtificialLightsStateAffectsVehicles(false)
                end
            end
            
        else
        end
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            library.PlayAnimation(PlayerPedId(), "mini@sprunk@first_person", "PLYR_BUY_DRINK_PT1", 8.0, 8.0, 1800, 1)
            Citizen.CreateThread(function()
                Citizen.Wait(650)
                library.PlayAudio("lightSwitch")
            end)
        end
        
    elseif updateType == "toggleLock" then
        property.metadata.locked = updateData.locked
        property.isUnderRaid = updateData.isUnderRaid
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            library.PlayAnimation(PlayerPedId(), "veh@std@habanero@ps@enter_exit", "d_locked", 8.0, 8.0, 890, 1)
            Citizen.CreateThread(function()
                Citizen.Wait(400)
                if updateData.locked == true then
                    library.PlayAudio("lockDoors")
                else
                    library.PlayAudio("openDoors")
                end
            end)
        end
        
    elseif updateType == "toggleDoorlock" then
        property.metadata.doors[updateData.doorId].locked = updateData.locked
        property.metadata.upgrades.antiBurglaryDoors = updateData.antiBurglaryDoors
        property.isUnderRaid = updateData.isUnderRaid
        
        local door = property.metadata.doors[updateData.doorId]
        
        if door.type == "double" then
            local state = updateData.locked == true and 1 or 0
            DoorSystemSetDoorState(door.left.hash, state, false, false)
            DoorSystemSetDoorState(door.right.hash, state, false, false)
        else
            local state = updateData.locked == true and 1 or 0
            DoorSystemSetDoorState(door.hash, state, false, false)
        end
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                library.PlayAnimation(PlayerPedId(), "veh@std@habanero@ps@enter_exit", "d_locked", 8.0, 8.0, 890, 1)
            end
            
            Citizen.CreateThread(function()
                Citizen.Wait(400)
                if updateData.locked == true then
                    library.PlayAudio("lockDoors")
                else
                    library.PlayAudio("openDoors")
                end
            end)
        end
        
        shouldRefreshBlips = true
        
    elseif updateType == "lockdown" then
        property.metadata.lockdown = updateData.lockdown
        shouldRefreshTargets = true
        shouldRefreshBlips = true
        shouldReloadFurniture = true
        
        -- If lockdown is being removed, explicitly remove the lockdown prop
        if not updateData.lockdown then
            Property:RemoveFurniture("lockdown")
        end
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
    elseif updateType == "raided" then
        property.isUnderRaid = true
        property.metadata.locked = false
        property.metadata.upgrades.antiBurglaryDoors = updateData.antiBurglaryDoors
        
        shouldRefreshBlips = true
        shouldRefreshTargets = true
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
    elseif updateType == "upgrade" then
        if not property.metadata.upgrades then
            property.metadata.upgrades = {}
        end
        
        property.metadata.upgrades[updateData.metadataName] = updateData[updateData.metadataName]
        shouldRefreshBlips = true
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "upgrades",
            forcedUpdate = true,
            ownUpgrades = {},
            furnitureLimit = GetFurnitureLimit(property.metadata.upgrades)
        }
        
        for _, upgrade in pairs(Config.HousingUpgrades) do
            if property.metadata.upgrades[upgrade.metadata] then
                uiUpdateData.ownUpgrades[upgrade.metadata] = property.metadata.upgrades[upgrade.metadata]
            end
        end
        
    elseif updateType == "keys" then
        property.keys = updateData.keys
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "keys",
            forcedUpdate = true,
            keys = json.decode(property.keys)
        }
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        if sourcePlayer and GetPlayerServerId(PlayerId()) == sourcePlayer then
            SendNUIMessage({
                action = "Property",
                actionName = "CloseModal"
            })
        end
        
    elseif updateType == "marketplace" then
        if updateData.description then
            property.description = updateData.description
        end
        
        property.sale = updateData.sale
        property.rental = updateData.rental
        property.metadata.contact_number = updateData.contact_number
        property.metadata.furnished = updateData.furnished
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "marketplace",
            forcedUpdate = true,
            description = property.description,
            sale = property.sale,
            rental = property.rental,
            images = property.metadata.images,
            contact_number = property.metadata.contact_number,
            furnished = property.metadata.furnished
        }
        
    elseif updateType == "marketplaceImage" then
        if not property.metadata.images then
            property.metadata.images = {}
        end
        
        property.metadata.images[updateData.imageId] = updateData.imageURL
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "marketplace",
            forcedUpdate = true,
            onlyPhotos = true,
            images = property.metadata.images
        }
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            uiUpdateData.closeModal = true
        end
        
    elseif updateType == "unpackedDelivery" then
        if not property.furniture then return end
        
        for _, furniture in pairs(property.furniture) do
            if furniture.metadata and furniture.metadata.delivered then
                furniture.metadata.delivered = nil
            end
        end
        
        -- Update UI to show furniture is now available
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "furniture",
            forcedUpdate = true,
            furniture = property.furniture
        }
        
    elseif updateType == "wardrobePosition" then
        -- Update wardrobe position in property metadata
        if not property.metadata then
            property.metadata = {}
        end
        property.metadata.wardrobe = updateData
        
        -- Reload interior targets if player is in this property
        if CurrentProperty == propId then
            Property:LoadInteriorInteractable()
        end
        
        
    elseif updateType == "storagePosition" then
        -- Update storage position in property metadata
        if not property.metadata then
            property.metadata = {}
        end
        property.metadata.storage = updateData
        
        -- Reload interior targets if player is in this property
        if CurrentProperty == propId then
            Property:LoadInteriorInteractable()
        end
        
        
    elseif updateType == "storeFurniture" then
        if not updateData.furnitureId then return end
        
        for index, furniture in pairs(property.furniture) do
            if furniture.id == updateData.furnitureId then
                -- Remove if currently placed
                if furniture.position then
                    local env = furniture.position.environment
                    if env == "inside" and CurrentProperty == propId then
                        Property:RemoveFurniture(updateData.furnitureId)
                    elseif env == "outside" and GetCurrentPropertyId() == propId then
                        Property:RemoveFurniture(updateData.furnitureId)
                    end
                end
                
                property.furniture[index].stored = 1
                property.furniture[index].position = nil
                break
            end
        end
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "furniture",
            forcedUpdate = true,
            furniture = property.furniture
        }
        
    elseif updateType == "orderedFurniture" then
        if not property.furniture then
            property.furniture = {}
        end
        
        table.insert(property.furniture, updateData.furniture)
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "ordered-furniture",
            forcedUpdate = true,
            furniture = property.furniture
        }
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            uiUpdateData.forcedClose = true
        end
        
    elseif updateType == "deliveredFurniture" then
        -- For deliveredFurniture, the updateData contains the actual delivery data
        -- and propertyId might be "multiple"
        local deliveryData = updateData
        if propertyId == "multiple" then
            deliveryData = updateData
        end
        
        local hasDeliveries = false
        
        for deliveryPropId, furnitureIds in pairs(deliveryData) do
            deliveryPropId = tostring(deliveryPropId)
            
            if GetCurrentPropertyId() == deliveryPropId or CurrentProperty == deliveryPropId then
                propId = deliveryPropId
            end
            
            for _, furnitureId in pairs(furnitureIds) do
                if not Properties[deliveryPropId].furniture then
                    Properties[deliveryPropId].furniture = {}
                end
                
                for _, furniture in pairs(Properties[deliveryPropId].furniture) do
                    if furniture.id == furnitureId then
                        if furniture.metadata then
                            furniture.metadata.deliveryTime = nil
                            
                            if Config.DeliveryType == 3 then
                                local propMeta = Properties[deliveryPropId].metadata
                                if propMeta and propMeta.deliveryType and propMeta.delivery then
                                    furniture.metadata.delivered = true
                                    hasDeliveries = true
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
        
        -- Load delivery furniture if needed
        if hasDeliveries and propId and propId ~= "nil" then
            local alreadyLoaded = false
            
            if next(Property.LoadedFurnitures) then
                for _, loadedFurn in pairs(Property.LoadedFurnitures) do
                    if loadedFurn.furnitureId == "delivery" then
                        alreadyLoaded = true
                        break
                    end
                end
            end
            
            if not alreadyLoaded then
                local property = Properties[propId]
                
                -- Use enter point if delivery point is not set
                local spawnPoint = property.metadata.delivery or property.metadata.enter
                
                if property and property.metadata and spawnPoint then
                    -- Spawn delivery box at the delivery/enter point
                    local deliveryBox = library.SpawnProp(
                        Config.DeliveryObject,
                        vector3(
                            spawnPoint.x,
                            spawnPoint.y,
                            spawnPoint.z
                        ),
                        false
                    )
                    
                    if deliveryBox and DoesEntityExist(deliveryBox) then
                        -- Wait for entity to exist
                        local timeout = GetGameTimer() + 2000
                        while not DoesEntityExist(deliveryBox) and GetGameTimer() < timeout do
                            Citizen.Wait(10)
                        end
                        
                        -- Set position and heading
                        SetEntityCoordsNoOffset(deliveryBox, spawnPoint.x, spawnPoint.y, spawnPoint.z, false, false, false)
                        SetEntityHeading(deliveryBox, spawnPoint.w or 0.0)
                        
                        -- Place on ground properly
                        PlaceObjectOnGroundProperly(deliveryBox)
                        local coords = GetEntityCoords(deliveryBox)
                        
                        -- Make sure it's not underground
                        local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 10.0, false)
                        if found and groundZ > coords.z - 1.0 then
                            SetEntityCoordsNoOffset(deliveryBox, coords.x, coords.y, groundZ + 0.1, false, false, false)
                        end
                        
                        SetEntityAsMissionEntity(deliveryBox, true, true)
                        FreezeEntityPosition(deliveryBox, true)
                        
                        
                        -- Add delivery box target
                        CL.Target("entity", {
                            entity = deliveryBox,
                            options = {{
                                interactableName = "delivery",
                                name = "furniture-delivery",
                                label = TRANSLATE("target.interactable:delivery") or "Unpack Delivery",
                                action = function()
                                    Property:UnpackDelivery(deliveryBox)
                                end,
                                canInteract = function()
                                    return library.HasAnyPermission(propId)
                                end
                            }}
                        })
                        
                        -- Track the delivery box
                        table.insert(Property.LoadedFurnitures, {
                            furnitureId = "delivery",
                            object = deliveryBox,
                            type = "delivery"
                        })
                        
                        -- Notify player with location
                        CL.Notification("Your furniture has been delivered! Check " .. (property.metadata.delivery and "the delivery point" or "the entrance"), 5000, "success")
                    else
                        print("^1[vms_housing] Failed to spawn delivery box^7")
                    end
                else
                    print("^1[vms_housing] Cannot spawn delivery box - no valid spawn point^7")
                end
            end
        end
        
    elseif updateType == "soldFurniture" or updateType == "removedFurniture" then
        if not updateData.furnitureId then return end
        
        for index, furniture in pairs(property.furniture) do
            if furniture.id == updateData.furnitureId then
                table.remove(property.furniture, index)
                break
            end
        end
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "furniture",
            forcedUpdate = true,
            furniture = property.furniture
        }
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            SendNUIMessage({
                action = "Property",
                actionName = "CloseModal"
            })
        end
        
    elseif updateType == "placedFurniture" then
        for _, furniture in pairs(property.furniture) do
            if furniture.id == updateData.furnitureId then
                furniture.position = updateData.position
                furniture.stored = 0
            end
        end
        
        shouldReloadFurniture = true
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            uiUpdateData = {
                action = "Property",
                actionName = "CloseFurniture"
            }
        end
        
    elseif updateType == "addedFurniture" then
        if not property.furniture then
            property.furniture = {}
        end
        
        table.insert(property.furniture, updateData.furniture)
        shouldReloadFurniture = true
        
    elseif updateType == "modifiedFurniture" then
        property.furniture[updateData.furnitureId] = updateData.furniture
        shouldReloadFurniture = true
        
    elseif updateType == "modifiedTheme" then
        property.metadata.iplTheme = updateData.iplTheme
        shouldReloadTheme = true
        
    elseif updateType == "changedSafePin" then
        if not updateData.furnitureId then return end
        
        for index, furniture in pairs(property.furniture) do
            if furniture.id == updateData.furnitureId then
                property.furniture[index].metadata.pin = updateData.newPin
                break
            end
        end
        
        shouldReloadFurniture = true
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            uiUpdateData = {
                action = "Safe",
                actionName = "ChangedPIN",
                success = true
            }
            
            SetNuiFocus(false, false)
            Citizen.CreateThread(function()
                Wait(1200)
                CloseSafe()
            end)
        end
        
    elseif updateType == "ringDoorbell" then
        if sourcePlayer then
            if GetPlayerServerId(PlayerId()) == sourcePlayer then
                library.PlayAnimation(PlayerPedId(), "mp_doorbell", "open_door", 8.0, 8.0, 2130, 1)
                Citizen.CreateThread(function()
                    Wait(1200)
                    library.PlayAudio("doorbell")
                end)
            end
        else
            if CurrentProperty == propId then
                library.PlayAudio("doorbellInside")
            end
        end
        
    elseif updateType == "paidBill" then
        if property.bills and next(property.bills) then
            for _, bill in pairs(property.bills) do
                if bill.period == updateData.period and bill.type == updateData.type then
                    bill.paid = 1
                    break
                end
            end
        end
        
        property.unpaidBills = updateData.unpaidBills
        property.unpaidRentBills = updateData.unpaidRentBills
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "bills",
            forcedUpdate = true,
            bills = property.bills,
            unpaidBills = property.unpaidBills,
            unpaidRentBills = property.unpaidRentBills
        }
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            SendNUIMessage({
                action = "Property",
                actionName = "CloseModal"
            })
        end
        
    elseif updateType == "changedWardrobePosition" then
        property.metadata.wardrobe = updateData.wardrobe
        
        if CurrentProperty and CurrentProperty == propId then
            -- Remove old wardrobe target
            for i = 1, #TargetPoints do
                if TargetPoints[i].type == "wardrobe" then
                    CL.Target("remove-zone", TargetPoints[i].id)
                    table.remove(TargetPoints, i)
                    break
                end
            end
            
            -- Add new wardrobe target if inside
            if CurrentShell or CurrentIPL or IsInsideMLO() then
                table.insert(TargetPoints, TargetHandler.Wardrobe(
                    CurrentProperty,
                    CurrentPropertyData.metadata.wardrobe.x,
                    CurrentPropertyData.metadata.wardrobe.y,
                    CurrentPropertyData.metadata.wardrobe.z
                ))
            end
        end
        
    elseif updateType == "changedStoragePosition" then
        property.metadata.storage = updateData.storage
        
        if CurrentProperty and CurrentProperty == propId then
            -- Remove old storage target
            for i = 1, #TargetPoints do
                if TargetPoints[i].type == "storage" then
                    CL.Target("remove-zone", TargetPoints[i].id)
                    table.remove(TargetPoints, i)
                    break
                end
            end
            
            -- Add new storage target if inside
            if CurrentShell or CurrentIPL or IsInsideMLO() then
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
        
    elseif updateType == "rentalTerminated" then
        Property:LockDoors(property.metadata and property.metadata.doors)
        
        property.renter = nil
        property.renter_name = nil
        property.unpaidRentBills = nil
        property.keys = updateData.keys
        property.permissions = updateData.permissions
        property.metadata = updateData.metadata
        property.rental = updateData.rental
        property.bills = updateData.bills
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "rental-termination",
            forcedUpdate = true,
            keys = json.decode(property.keys),
            metadata = property.metadata,
            permissions = property.permissions,
            rental = property.rental,
            bills = property.bills
        }
        
        shouldRefreshBlips = true
        shouldRegisterDoors = true
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            SendNUIMessage({
                action = "Property",
                actionName = "CloseModal"
            })
        end
        
    elseif updateType == "rentalTermination" then
        property.rental = updateData.rental
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "rental-termination",
            forcedUpdate = true,
            rental = property.rental
        }
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            SendNUIMessage({
                action = "Property",
                actionName = "CloseModal"
            })
        end
        
    elseif updateType == "clearRentalTermination" then
        property.rental = updateData.rental
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "rental-termination",
            forcedUpdate = true,
            rental = property.rental
        }
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            SendNUIMessage({
                action = "Property",
                actionName = "CloseModal"
            })
        end
        
    elseif updateType == "updatedPermissions" then
        property.permissions = updateData.permissions
        shouldRefreshBlips = true
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "permissions",
            forcedUpdate = true,
            permissions = property.permissions
        }
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            SendNUIMessage({
                action = "Property",
                actionName = "CloseModal"
            })
        end
        
    elseif updateType == "movedOut" then
        if not property.owner then
            Property:LockDoors(property.metadata and property.metadata.doors)
        end
        
        property.renter = nil
        property.renter_name = nil
        property.unpaidRentBills = nil
        property.keys = updateData.keys
        property.permissions = updateData.permissions
        property.metadata = updateData.metadata
        property.sale = updateData.sale
        property.rental = updateData.rental
        property.bills = updateData.bills
        
        uiUpdateData = {
            action = "Property",
            actionName = "UpdateManage",
            type = "rental-termination",
            forcedUpdate = true,
            keys = json.decode(property.keys),
            metadata = property.metadata,
            permissions = property.permissions,
            rental = property.rental,
            bills = property.bills
        }
        
        shouldRefreshBlips = true
        shouldRegisterDoors = true
        
        if SelectedApartment == propId then
            ReloadApartmentMenu()
        end
        
        if GetPlayerServerId(PlayerId()) == sourcePlayer then
            closeManageMenu()
        end
    end
    
    -- Apply updates based on context
    if shouldRefreshBlips then
        RefreshBlips()
    end
    
    if shouldRegisterDoors then
        if property.type == "mlo" then
            local forceLock = not (property.owner or property.renter)
            Property:RegisterDoors({
                propertyId = propId,
                forceLock = forceLock,
                doors = property.metadata.doors
            })
        end
    end
    
    local currentId = GetCurrentPropertyId()
    
    -- Handle updates for current property
    if currentId == propId or CurrentProperty == propId then
        if not library.HasAnyPermission(propId) then
            if openedMenu == "PropertyManage" then
                closeManageMenu()
            elseif openedMenu == "PropertyFurniture" or openedMenu == "PropertyFurniturePurchase" then
                closeFurnitureMenu()
            end
        end
        
        if uiUpdateData then
            if openedMenu == "PropertyManage" or openedMenu == "Safe" then
                SendNUIMessage(uiUpdateData)
            end
        end
        
        if shouldRefreshTargets then
            RefreshTargets()
        end
        
        if shouldReloadFurniture then
            Property:RemoveFurniture(nil, function()
                local environment = CurrentProperty and "inside" or "outside"
                Property:LoadFurniture(environment, property.furniture, propId)
                
                -- Handle MLO building furniture
                if property.type == "mlo" and not property.object_id then
                    local altEnvironment = CurrentProperty and "outside" or "inside"
                    Property:LoadFurniture(altEnvironment, property.furniture, propId)
                end
            end)
        end
        
        if shouldReloadTheme then
            if CurrentIPL then
                IPL.LoadSettings(CurrentIPL, property.metadata.iplTheme, property.metadata.iplSettings, function()
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    SetEntityCoords(PlayerPedId(), playerCoords.x, playerCoords.y, playerCoords.z)
                end)
            end
        end
        
        if updateType == "unpackedDelivery" then
            Property:RemoveFurniture("delivery")
        end
        
        if updateType == "autoSellProperty" then
            if CurrentProperty == propId then
                Property:ExitProperty()
            end
        end
        
        if updateType == "movedOut" then
            if CurrentProperty == propId then
                if not CurrentPropertyData.owner or GetPlayerServerId(PlayerId()) == sourcePlayer then
                    Property:ExitProperty()
                end
            end
        end
        
        -- Refresh targets if needed (for wardrobe/storage position updates)
        if shouldRefreshTargets then
            RefreshTargets()
        end
        
    -- Handle building property updates
    elseif currentId == objectId then
        if uiUpdateData and isBuilding then
            if openedMenu == "BuildingMenu" or openedMenu == "ApartmentMenu" then
                SendNUIMessage(uiUpdateData)
            end
        end
        
        if uiUpdateData and not isBuilding then
            if openedMenu == "PropertyManage" then
                SendNUIMessage(uiUpdateData)
            end
        end
        
        if uiUpdateData and isBuilding then
            if MotelManageId and MotelManageId == propId then
                if openedMenu == "PropertyManage" then
                    SendNUIMessage(uiUpdateData)
                end
            end
        end
        
        if not isBuilding and shouldRefreshBlips then
            RefreshBlips()
            RefreshTargets()
        end
    end
end)

-- Send Property Contract Event Handler
RegisterNetEvent("vms_housing:cl:sendPropertyContract", function(contractData)
    local property = Properties[contractData.propertyId]
    if not property then return end
    
    contractData.address = property.address
    contractData.characterName = CharacterName
    
    local region = property.region and Config.Regions[property.region] or Config.NoRegion
    contractData.electricity = region.electricity
    contractData.water = region.water
    contractData.internet = region.internet
    
    SendNUIMessage({
        action = "Property",
        actionName = "ShowContract",
        data = contractData
    })
    
    SetNuiFocus(true, true)
    openedMenu = "Contract"
end)

-- Reload Furniture List Event Handler
RegisterNetEvent("vms_housing:cl:reloadFurnitureList", function(furnitureJson)
    Furniture = json.decode(furnitureJson)
    
    SendNUIMessage({
        action = "Property",
        actionName = "ReloadAvailableFurniture",
        data = Furniture
    })
end)

-- Reload Single Furniture Event Handler
RegisterNetEvent("vms_housing:cl:reloadFurniture", function(furnitureId, furnitureData)
    if Furniture[furnitureId] then
        Furniture[furnitureId] = furnitureData
        
        SendNUIMessage({
            action = "Property",
            actionName = "ReloadAvailableFurniture",
            data = Furniture
        })
    end
end)