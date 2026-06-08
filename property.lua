-- Property and Furniture Management Module

Property = {}
Property.EditingFurniture = false
Property.EditingFurnitureObj = nil
Property.EditingFurnitureData = {}
Property.EditingTheme = false
Property.LoadedFurnitures = {}
Property.StaticInteractable = {}
Property.LastLockedDoors = nil

-- Enter property
function Property:EnterProperty(property, propertyId, callback)
    
    -- Get property ID if not provided
    if not propertyId then
        if type(property) == "table" and property.id then
            propertyId = property.id
        else
            propertyId = GetCurrentPropertyId()
        end
    end
    
    
    -- Trigger the enter house event
    TriggerEvent("vms_housing:cl:enterHouse", propertyId)
    
    if callback then
        callback(true)
    end
end

-- View property offer UI
function Property.ViewOffer(showOffer, propertyId)
    local isBuilding = false
    local isMotel = false
    local propertyData = GetCurrentPropertyData()
    
    if showOffer then
        if propertyData.type == "building" then
            isBuilding = true
        elseif propertyData.type == "motel" then
            isMotel = true
        end
        propertyData = Properties[tostring(propertyId)]
    else
        propertyId = GetCurrentPropertyId()
    end
    
    if not propertyData then
        return
    end
    
    local rooms = nil
    local iplName = nil
    local allowChangeTheme = false
    
    -- Get rooms based on property type
    if propertyData.type == "shell" then
        local shellData = AvailableShells[propertyData.metadata.shell]
        if shellData and shellData.rooms then
            rooms = shellData.rooms
        end
    elseif propertyData.type == "ipl" then
        local iplData = AvailableIPLS[propertyData.metadata.ipl]
        if iplData and iplData.rooms then
            rooms = iplData.rooms
        end
        iplName = propertyData.metadata.ipl
        allowChangeTheme = propertyData.metadata.allowChangeTheme
    end
    
    -- Check garage and parking
    local hasGarage = propertyData.metadata.garage ~= nil
    local parking = propertyData.metadata.parking
    local parkingSpaces = nil
    
    if propertyData.object_id then
        local parentProperty = Properties[tostring(propertyData.object_id)]
        if parentProperty and parentProperty.metadata then
            parkingSpaces = parentProperty.metadata.parkingSpaces
        end
    end
    
    -- Get sale and rental prices
    local salePrice = nil
    if propertyData.sale and propertyData.sale.active and propertyData.sale.price then
        salePrice = propertyData.sale.price
    end
    
    local rentalPrice = nil
    if propertyData.rental and propertyData.rental.active and propertyData.rental.price then
        rentalPrice = propertyData.rental.price
    end
    
    
    -- Get utility costs from region config
    local electricity = Config.Regions[propertyData.region] and 
                       Config.Regions[propertyData.region].electricity or 
                       Config.NoRegion.electricity
    
    local internet = Config.Regions[propertyData.region] and 
                    Config.Regions[propertyData.region].internet or 
                    Config.NoRegion.internet
    
    local water = Config.Regions[propertyData.region] and 
                 Config.Regions[propertyData.region].water or 
                 Config.NoRegion.water
    
    -- Get area from metadata
    local area = nil
    if propertyData.metadata and propertyData.metadata.zone then
        area = propertyData.metadata.zone.area
    end
    
    -- Send data to UI
    SendNUIMessage({
        action = "Property",
        actionName = "OpenViewOffer",
        data = {
            id = propertyId,
            type = propertyData.type,
            address = propertyData.address,
            region = propertyData.region,
            name = propertyData.name,
            description = propertyData.description,
            purchasePrice = salePrice,
            rentPrice = rentalPrice,
            electricity = electricity,
            internet = internet,
            water = water,
            area = area,
            rooms = rooms,
            garage = hasGarage,
            parking = parking,
            parkingSpaces = parkingSpaces,
            ipl = iplName,
            allowChangeTheme = allowChangeTheme
        }
    })
    
    SetNuiFocus(true, true)
    openedMenu = "PropertyOffer"
end

-- Close property offer UI
function Property.CloseOffer()
    SendNUIMessage({
        action = "Property",
        actionName = "CloseViewOffer"
    })
    
    SetNuiFocus(false, false)
    openedMenu = nil
    marketplaceOfferId = nil
    isOfferByMarketplace = false
    SelectedApartment = nil
end

-- Load furniture into property
function Property.LoadFurniture(self, environment, furnitureData, propertyId)
    local deliveryBoxSpawned = false
    
    for _, furniture in pairs(furnitureData) do
        -- Only load furniture that's not stored and matches environment
        if furniture.stored == 0 and furniture.position and furniture.position.environment == environment then
            local furnitureObj = library.SpawnProp(
                furniture.model,
                vector3(furniture.position.x, furniture.position.y, furniture.position.z),
                false
            )
            
            while not DoesEntityExist(furnitureObj) do
                Citizen.Wait(5)
            end
            
            SetEntityCoordsNoOffset(furnitureObj, furniture.position.x, furniture.position.y, furniture.position.z)
            SetEntityRotation(furnitureObj, furniture.position.pitch, furniture.position.roll, furniture.position.yaw, 0, false)
            SetEntityAsMissionEntity(furnitureObj, true, true)
            FreezeEntityPosition(furnitureObj, true)
            
            -- Add interactable furniture targets
            local hasMetadata = next(furniture.metadata)
            if hasMetadata and furniture.metadata.interactableName then
                local interactableName = furniture.metadata.interactableName
                
                -- Skip device furniture if purchase is required
                if interactableName == "device" and Config.RequirePurchaseFurniture then
                    interactableName = nil
                end
                
                if interactableName and interactableName ~= "device" then
                    local targetOption = {
                        interactableName = furniture.metadata.interactableName,
                        name = "furniture-" .. furniture.id,
                        label = TRANSLATE("target.interactable:" .. furniture.metadata.interactableName) or furniture.metadata.interactableName,
                        action = function()
                            CL.InteractableFurniture(furniture.model, furniture.metadata.interactableName, furniture.id, furniture.metadata)
                        end
                    }
                    
                    -- Add permission checks based on config
                    if Config.FurnitureInteractionAccess == 2 then
                        targetOption.canInteract = function()
                            return library.HasAnyPermission(propertyId)
                        end
                    elseif Config.FurnitureInteractionAccess == 3 then
                        targetOption.canInteract = function()
                            return library.HasPermissions(propertyId, "furniture")
                        end
                    end
                    
                    CL.Target("entity", {
                        entity = furnitureObj,
                        options = {targetOption}
                    })
                end
            end
            
            -- Add to loaded furniture list
            table.insert(self.LoadedFurnitures, {
                entity = furnitureObj,
                model = furniture.model,
                furnitureId = furniture.id,
                metadata = furniture.metadata
            })
            
        -- Handle furniture delivery system
        elseif Config.RequirePurchaseFurniture and Config.DeliveryType == 3 and not deliveryBoxSpawned then
            if furniture.stored == 1 and furniture.metadata and furniture.metadata.delivered then
                local currentProperty = CurrentPropertyData or GetCurrentPropertyData()
                
                if currentProperty.metadata and currentProperty.metadata.deliveryType then
                    if currentProperty.metadata.deliveryType == environment and currentProperty.metadata.delivery then
                        deliveryBoxSpawned = true
                        
                        -- Spawn delivery box
                        local deliveryBox = library.SpawnProp(
                            Config.DeliveryObject,
                            vector3(
                                currentProperty.metadata.delivery.x,
                                currentProperty.metadata.delivery.y,
                                currentProperty.metadata.delivery.z
                            ),
                            false
                        )
                        
                        while not DoesEntityExist(deliveryBox) do
                            Citizen.Wait(5)
                        end
                        
                        SetEntityCoordsNoOffset(
                            deliveryBox,
                            currentProperty.metadata.delivery.x,
                            currentProperty.metadata.delivery.y,
                            currentProperty.metadata.delivery.z
                        )
                        SetEntityHeading(deliveryBox, currentProperty.metadata.delivery.w)
                        SetEntityAsMissionEntity(deliveryBox, true, true)
                        FreezeEntityPosition(deliveryBox, true)
                        
                        -- Add delivery box target
                        CL.Target("entity", {
                            entity = deliveryBox,
                            options = {{
                                interactableName = "delivery",
                                name = "furniture-delivery",
                                label = TRANSLATE("target.interactable:delivery"),
                                action = function()
                                    Property:UnpackDelivery(deliveryBox)
                                end,
                                canInteract = function()
                                    return library.HasAnyPermission(propertyId)
                                end
                            }}
                        })
                        
                        table.insert(self.LoadedFurnitures, {
                            entity = deliveryBox,
                            furnitureId = "delivery"
                        })
                    end
                end
            end
        end
    end
    
    -- Handle property lockdown (police tape/barrier)
    if environment == "outside" then
        local propertyData = GetCurrentPropertyData()
        if propertyData and propertyData.metadata.lockdown then
            local isBuilding = false
            
            if propertyData.object_id then
                local parentProperty = Properties[propertyData.object_id]
                if parentProperty and parentProperty.type == "building" then
                    isBuilding = true
                end
            end
            
            if not isBuilding then
                local lockdownObj = library.SpawnProp(
                    Config.PropertyLockdown.ObjectModel,
                    vector3(
                        propertyData.metadata.exit.x,
                        propertyData.metadata.exit.y,
                        propertyData.metadata.exit.z - 0.12
                    ),
                    false
                )
                
                while not DoesEntityExist(lockdownObj) do
                    Citizen.Wait(5)
                end
                
                SetEntityCoordsNoOffset(
                    lockdownObj,
                    propertyData.metadata.exit.x,
                    propertyData.metadata.exit.y,
                    propertyData.metadata.exit.z - 0.12
                )
                SetEntityHeading(lockdownObj, propertyData.metadata.exit.w)
                SetEntityAsMissionEntity(lockdownObj, true, true)
                FreezeEntityPosition(lockdownObj, true)
                
                table.insert(self.LoadedFurnitures, {
                    entity = lockdownObj,
                    furnitureId = "lockdown"
                })
            end
        end
    end
end

-- Remove furniture from property
function Property.RemoveFurniture(self, furnitureId, callback)
    if not next(self.LoadedFurnitures) then
        if callback then
            callback()
        end
        return
    end
    
    if furnitureId then
        -- Remove specific furniture by ID
        for index, furniture in ipairs(self.LoadedFurnitures) do
            if furniture.furnitureId == furnitureId then
                if furniture.entity then
                    CL.Target("remove-entity", furniture.entity)
                    DeleteObject(furniture.entity)
                    table.remove(self.LoadedFurnitures, index)
                    break
                end
            end
        end
    else
        -- Remove all furniture
        for _, furniture in ipairs(self.LoadedFurnitures) do
            if furniture.entity then
                CL.Target("remove-entity", furniture.entity)
                DeleteObject(furniture.entity)
            end
        end
        self.LoadedFurnitures = {}
    end
    
    if callback then
        callback()
    end
end

-- Toggle property lights
function Property.ToggleLight(self)
    if not CurrentProperty then
        return
    end
    TriggerServerEvent("vms_housing:sv:toggleLight", CurrentProperty)
end

-- Toggle door locks
function Property.ToggleLock(self, propertyId, doorIndex, doorType)
    -- Rate limit check (2 second cooldown)
    if Property.LastLockedDoors then
        if GetGameTimer() <= Property.LastLockedDoors then
            CL.Notification(TRANSLATE("notify.doors:wait"), 3500, "info")
            return
        end
    end
    
    local targetPropertyId = propertyId or GetCurrentPropertyId() or CurrentProperty
    
    TriggerServerEvent("vms_housing:sv:toggleLock", targetPropertyId, doorIndex, doorType)
    Property.LastLockedDoors = GetGameTimer() + 2000
end

-- Unpack furniture delivery
function Property.UnpackDelivery(self, deliveryEntity)
    -- Handle both calling styles (with self or without)
    if type(self) == "number" then
        -- Called without self, self is actually the deliveryEntity
        deliveryEntity = self
        self = Property
    end
    
    CL.Target("remove-entity", deliveryEntity)
    
    -- Play unpacking animation
    library.PlayAnimation(
        PlayerPedId(),
        "anim@scripted@ulp_missions@empty_crate@male@",
        "action",
        8.0,
        1.0,
        3800,
        1
    )
    
    Citizen.Wait(3650)
    
    -- Delete the delivery box entity
    if DoesEntityExist(deliveryEntity) then
        DeleteObject(deliveryEntity)
        DeleteEntity(deliveryEntity)
    end
    
    -- Remove from loaded furniture list
    for i = #self.LoadedFurnitures, 1, -1 do
        if self.LoadedFurnitures[i] and self.LoadedFurnitures[i].object == deliveryEntity then
            table.remove(self.LoadedFurnitures, i)
            break
        end
    end
    
    local propertyId = CurrentProperty or GetCurrentPropertyId()
    TriggerServerEvent("vms_housing:sv:unpackDelivery", propertyId)
end

-- Load interior interaction targets
function Property.LoadInteriorInteractable(self)
    if not CurrentProperty or not CurrentPropertyData then
        return
    end
    
    -- Only for shell and IPL types
    if CurrentPropertyData.type ~= "shell" and CurrentPropertyData.type ~= "ipl" then
        return
    end
    
    local parentBuilding = nil
    if CurrentPropertyData.object_id then
        local parent = Properties[tostring(CurrentPropertyData.object_id)]
        if parent and parent.type == "building" then
            parentBuilding = parent
        end
    end
    
    -- Clear existing target points (including wardrobe, storage, emergency_exit, etc.)
    for i = 1, #TargetPoints do
        if TargetPoints[i].id then
            CL.Target("remove-zone", TargetPoints[i].id)
        end
    end
    TargetPoints = {}
    
    local doorOptions = {}
    
    -- Add management option for property owners
    if library.HasAnyPermission(CurrentProperty) then
        table.insert(doorOptions, TargetHandler.Manage(nil, function()
            return not CurrentPropertyData.metadata.lockdown
        end))
    end
    
    -- Add furniture option
    if library.HasPermissions(CurrentProperty, "furniture") then
        if CurrentPropertyData.metadata.allowFurnitureInside then
            table.insert(doorOptions, TargetHandler.Furniture(function()
                return not CurrentPropertyData.metadata.lockdown
            end))
        end
    end
    
    -- Add wardrobe target
    if CurrentPropertyData.metadata and CurrentPropertyData.metadata.wardrobe and CurrentPropertyData.metadata.wardrobe.x then
        table.insert(TargetPoints, TargetHandler.Wardrobe(
            CurrentProperty,
            CurrentPropertyData.metadata.wardrobe.x,
            CurrentPropertyData.metadata.wardrobe.y,
            CurrentPropertyData.metadata.wardrobe.z
        ))
    end
    
    -- Add storage target
    if CurrentPropertyData.metadata and CurrentPropertyData.metadata.storage and CurrentPropertyData.metadata.storage.x then
        table.insert(TargetPoints, TargetHandler.Storage(
            CurrentProperty,
            CurrentPropertyData.metadata.storage.x,
            CurrentPropertyData.metadata.storage.y,
            CurrentPropertyData.metadata.storage.z,
            CurrentPropertyData.metadata.storage.slots,
            CurrentPropertyData.metadata.storage.weight
        ))
    end
    
    -- Add emergency exit target
    if CurrentPropertyData.metadata and CurrentPropertyData.metadata.emergencyInside and CurrentPropertyData.metadata.emergencyInside.x then
        local emergencyExitId = CL.Target("zone", {
            coords = vector3(
                CurrentPropertyData.metadata.emergencyInside.x,
                CurrentPropertyData.metadata.emergencyInside.y,
                CurrentPropertyData.metadata.emergencyInside.z
            ),
            size = vec(1.5, 1.5, 2.0),
            rotation = 0.0,
            options = {{
                name = "property-emergency-exit",
                icon = "fa-solid fa-person-through-window",
                label = TRANSLATE("target.emergency_exit"),
                action = function()
                    if self.EditingFurniture or self.EditingTheme then
                        return CL.Notification(TRANSLATE("notify.furniture:you_are_in_furniture_mode"), 5000, "info")
                    end
                    self:ExitProperty(nil, false, false, true)
                end
            }}
        })
        
        table.insert(TargetPoints, {
            type = "emergency_exit",
            id = emergencyExitId
        })
    end
    
    -- Add door peephole option
    table.insert(doorOptions, {
        name = "property-door-peephole",
        icon = "fa-solid fa-video",
        label = TRANSLATE("target.door_peephole"),
        action = function()
            if self.EditingFurniture or self.EditingTheme then
                return CL.Notification(TRANSLATE("notify.furniture:you_are_in_furniture_mode"), 5000, "info")
            end
            self:OpenDoorPeephole()
        end
    })
    
    -- Add light toggle option
    table.insert(doorOptions, {
        name = "property-light",
        icon = "fa-solid fa-lightbulb",
        label = TRANSLATE("target.toggle_light"),
        action = function()
            if self.EditingFurniture or self.EditingTheme then
                return CL.Notification(TRANSLATE("notify.furniture:you_are_in_furniture_mode"), 5000, "info")
            end
            self:ToggleLight()
        end
    })
    
    -- Add door lock toggle option
    table.insert(doorOptions, TargetHandler.ToggleLock(nil, function()
        return not CurrentPropertyData.metadata.lockdown
    end))
    
    -- Add exit door option
    table.insert(doorOptions, {
        name = "property-exit",
        icon = "fa-solid fa-door-open",
        label = TRANSLATE("target.exit"),
        action = function()
            if self.EditingFurniture or self.EditingTheme then
                return CL.Notification(TRANSLATE("notify.furniture:you_are_in_furniture_mode"), 5000, "info")
            end
            
            if not CL.CanExitHouse() then
                return
            end
            
            library.Callback("vms_housing:canExitHouse", function(canExit)
                if not canExit then
                    return
                end
                -- Exit the property
                DoScreenFadeOut(1500)
                Wait(1500)
                
                -- Trigger server event to exit
                TriggerServerEvent("vms_housing:sv:exitHouse", CurrentProperty)
                
                -- Clean up shell/IPL
                if CurrentShell then
                    DeleteObject(CurrentShell)
                    CurrentShell = nil
                elseif CurrentIPL then
                    CurrentIPL = nil
                end
                
                -- Teleport player to exit position
                local property = CurrentPropertyData
                if property and property.metadata and property.metadata.exit then
                    SetEntityCoords(PlayerPedId(), property.metadata.exit.x, property.metadata.exit.y, property.metadata.exit.z, false, false, false, false)
                    SetEntityHeading(PlayerPedId(), property.metadata.exit.w or 0.0)
                end
                
                -- Reset current property
                CurrentProperty = nil
                CurrentPropertyData = nil
                
                -- Reset artificial lights state when exiting
                SetArtificialLightsState(false)
                SetArtificialLightsStateAffectsVehicles(true)
                
                -- Fade back in
                DoScreenFadeIn(1500)
                
                -- Refresh targets
                RefreshTargets()
            end)
        end,
        canInteract = function()
            return not CurrentPropertyData.metadata.locked
        end
    })
    
    -- Add underground parking options (if vms_garagesv2 is used)
    if Config.Garages == "vms_garagesv2" and parentBuilding then
        if parentBuilding.metadata and parentBuilding.metadata.parkingEnter and parentBuilding.metadata.parkingSpaces then
            for parkingIndex, parkingSpace in pairs(parentBuilding.metadata.parkingSpaces) do
                table.insert(doorOptions, {
                    name = "property-garage-" .. parkingIndex,
                    icon = "fa-solid fa-warehouse",
                    label = TRANSLATE("target.enter_underground_parking", parkingIndex),
                    action = function()
                        if self.EditingFurniture or self.EditingTheme then
                            return CL.Notification(TRANSLATE("notify.furniture:you_are_in_furniture_mode"), 5000, "info")
                        end
                        
                        if not CL.CanExitHouse() then
                            return
                        end
                        
                        library.Callback("vms_housing:canExitHouse", function(canExit)
                            if not canExit then
                                return
                            end
                            
                            self:ExitProperty(function()
                                exports.vms_garagesv2:enterApartmentParking("vms_housing:parking:" .. parentBuilding.id .. ":" .. parkingIndex)
                            end, false, true)
                        end)
                    end,
                    canInteract = function()
                        return not CurrentPropertyData.metadata.locked
                    end
                })
            end
        end
    end
    
    -- Create door zone for shells
    if CurrentPropertyData.type == "shell" then
        local shellData = AvailableShells[CurrentPropertyData.metadata.shell]
        -- Check if doors.z is already an absolute position or a relative offset
        local doorZ = shellData.doors.z
        if doorZ > 100 then
            -- It's likely an absolute position, add small correction offset
            doorZ = shellData.doors.z + 1.0  -- Add 1.0 to match actual door position
        else
            -- It's a relative offset, add to base height
            doorZ = 500.0 + shellData.doors.z
        end
        
        local doorZoneId = CL.Target("zone", {
            coords = vector3(
                shellData.doors.x,
                shellData.doors.y,
                doorZ
            ),
            size = vec(2.0, 2.5, 2.5),  -- Increased size for better detection
            rotation = shellData.doors.heading or shellData.doors.h or 0.0,
            options = doorOptions
        })
        
        table.insert(TargetPoints, {
            type = "zone",
            id = doorZoneId
        })
        
    -- Create door zone for IPLs
    elseif CurrentPropertyData.type == "ipl" then
        local iplData = AvailableIPLS[CurrentPropertyData.metadata.ipl]
        local doorZoneId = CL.Target("zone", {
            coords = vector3(
                iplData.doors.x,
                iplData.doors.y,
                iplData.doors.z + 1.5
            ),
            size = vec(1.5, 2.1, 2.0),
            rotation = iplData.doors.heading,
            options = doorOptions
        })
        
        table.insert(TargetPoints, {
            type = "zone",
            id = doorZoneId
        })
    end
end

-- Load static interactable objects (sinks, stoves, etc.)
function Property.LoadStaticInteractable(self, shellOrIplData)
    if not shellOrIplData.interactable then
        return
    end
    
    for _, interactable in pairs(shellOrIplData.interactable) do
        local options = {}
        
        for _, option in pairs(interactable.options) do
            local targetOption = {
                name = option.type,
                icon = option.targetIcon,
                label = TRANSLATE("target.interactable:" .. option.type),
                distance = 1.0,
                action = function()
                    library.Callback("vms_housing:useStaticInteractable", function(canUse)
                        if not canUse then
                            return
                        end
                        
                        CL.InteractableFurniture(
                            nil,
                            option.type,
                            nil,
                            {
                                data = interactable,
                                option = option
                            }
                        )
                    end, CurrentProperty, option.type, option.timeUsage, option.waterUsage, option.billType)
                end
            }
            
            -- Add permission checks
            if Config.StaticInteractionAccess == 2 then
                targetOption.canInteract = function()
                    return library.HasAnyPermission(CurrentProperty)
                end
            elseif Config.StaticInteractionAccess == 3 then
                targetOption.canInteract = function()
                    return library.HasPermissions(CurrentProperty, "furniture")
                end
            end
            
            table.insert(options, targetOption)
        end
        
        -- Create target zone for interactable
        local targetId = CL.Target("zone", {
            coords = interactable.target,
            rotation = interactable.target.w,
            size = interactable.targetSize,
            options = options
        })
        
        table.insert(self.StaticInteractable, {
            type = interactable.type,
            coords = interactable.coords,
            id = targetId
        })
    end
end

-- Remove all static interactables
function Property.RemoveStaticInteractable(self)
    if self.StaticInteractable and next(self.StaticInteractable) then
        for _, interactable in pairs(self.StaticInteractable) do
            CL.Target("remove-zone", interactable.id)
        end
    end
    
    self.StaticInteractable = {}
end

-- Register door system for property
function Property.RegisterDoors(self, doorData)
    for doorIndex, door in pairs(doorData.doors) do
        if door.type == "slide_gate" then
            -- Sliding gate door
            door.hash = joaat(string.format("vms_housing_%s_%s", doorData.propertyId, doorIndex))
            
            AddDoorToSystem(
                door.hash,
                door.model,
                door.coords.x,
                door.coords.y,
                door.coords.z,
                false, false, false
            )
            
            DoorSystemSetDoorState(door.hash, 4, false, false)
            
            local lockState = (doorData.forceLock or door.locked == true) and 1 or 0
            DoorSystemSetDoorState(door.hash, lockState, false, false)
            DoorSystemSetAutomaticRate(door.hash, 5.0, false, false)
            
        elseif door.type == "single" then
            -- Single door
            door.hash = joaat(string.format("vms_housing_%s_%s", doorData.propertyId, doorIndex))
            
            AddDoorToSystem(
                door.hash,
                door.model,
                door.coords.x,
                door.coords.y,
                door.coords.z,
                false, false, false
            )
            
            DoorSystemSetDoorState(door.hash, 4, false, false)
            
            local lockState = (doorData.forceLock or door.locked == true) and 1 or 0
            DoorSystemSetDoorState(door.hash, lockState, false, false)
            DoorSystemSetAutomaticRate(door.hash, 10.0, false, false)
            
        elseif door.type == "double" then
            -- Double doors (left and right)
            if door.left then
                door.left.hash = joaat(string.format("vms_housing_%s_%s_left", doorData.propertyId, doorIndex))
                
                AddDoorToSystem(
                    door.left.hash,
                    door.left.model,
                    door.left.coords.x,
                    door.left.coords.y,
                    door.left.coords.z,
                    false, false, false
                )
                
                DoorSystemSetDoorState(door.left.hash, 4, false, false)
                
                local lockState = (doorData.forceLock or door.locked == true) and 1 or 0
                DoorSystemSetDoorState(door.left.hash, lockState, false, false)
                DoorSystemSetAutomaticRate(door.left.hash, 10.0, false, false)
            end
            
            if door.right then
                door.right.hash = joaat(string.format("vms_housing_%s_%s_right", doorData.propertyId, doorIndex))
                
                AddDoorToSystem(
                    door.right.hash,
                    door.right.model,
                    door.right.coords.x,
                    door.right.coords.y,
                    door.right.coords.z,
                    false, false, false
                )
                
                DoorSystemSetDoorState(door.right.hash, 4, false, false)
                
                local lockState = (doorData.forceLock or door.locked == true) and 1 or 0
                DoorSystemSetDoorState(door.right.hash, lockState, false, false)
                DoorSystemSetAutomaticRate(door.right.hash, 10.0, false, false)
            end
        end
    end
end

-- Lock all doors in property
function Property.LockDoors(self, doors)
    if doors then
        for _, door in pairs(doors) do
            if door.type == "double" then
                DoorSystemSetDoorState(door.left.hash, 1, false, false)
                DoorSystemSetDoorState(door.right.hash, 1, false, false)
            elseif door.type == "slide_gate" or door.type == "single" then
                DoorSystemSetDoorState(door.hash, 1, false, false)
            end
        end
    end
end

-- Unlock all doors in property
function Property.UnlockDoors(self, doors)
    if doors then
        for _, door in pairs(doors) do
            if door.type == "double" then
                DoorSystemSetDoorState(door.left.hash, 0, false, false)
                DoorSystemSetDoorState(door.right.hash, 0, false, false)
            elseif door.type == "slide_gate" or door.type == "single" then
                DoorSystemSetDoorState(door.hash, 0, false, false)
            end
        end
    end
end

-- Load door entities and create interaction targets
function Property.LoadDoors(self, doors, propertyId, skipRegistration, removeDoorTargets)
    -- Remove existing door targets if requested
    if removeDoorTargets then
        for i = #TargetPoints, 1, -1 do
            if TargetPoints[i].type == "door" then
                CL.Target("remove-entity", TargetPoints[i].entity)
                table.remove(TargetPoints, i)
            end
        end
    end
    
    -- Create door target options
    local function CreateDoorTarget(doorEntity, doorIndex, distance)
        local targetPropertyId = propertyId or GetCurrentPropertyId()
        local propertyData = propertyId and Properties[tostring(propertyId)] or GetCurrentPropertyData()
        
        local doorOptions = {}
        
        -- Add manual lock toggle (if not using keys on item)
        if not Config.UseKeysOnItem then
            table.insert(doorOptions, {
                interactableName = "door",
                name = "door-left-" .. doorIndex,
                label = TRANSLATE("target.toggle_lock_door"),
                distance = distance or 1.2,
                action = function()
                    if self.LastLockedDoors and GetGameTimer() <= self.LastLockedDoors then
                        return CL.Notification(TRANSLATE("notify.doors:wait"), 3500, "info")
                    end
                    
                    TriggerServerEvent("vms_housing:sv:toggleDoorlock", targetPropertyId, doorIndex, nil, false, false)
                    self.LastLockedDoors = GetGameTimer() + 2000
                end,
                canInteract = function()
                    return HasOwnership(propertyData)
                end
            })
        end
        
        -- Add lockpick option
        local antiBurglaryDoors = propertyData.metadata and propertyData.metadata.upgrades and propertyData.metadata.upgrades.antiBurglaryDoors
        local hasAlarm = propertyData.metadata and propertyData.metadata.upgrades and propertyData.metadata.upgrades.alarm
        
        table.insert(doorOptions, TargetHandler.Lockpick(
            targetPropertyId,
            antiBurglaryDoors,
            hasAlarm,
            function(success)
                TriggerServerEvent("vms_housing:sv:toggleDoorlock", targetPropertyId, doorIndex, nil, true, false, success)
            end,
            function()
                return propertyData.metadata.doors[doorIndex].locked and not propertyData.metadata.lockdown
            end
        ))
        
        -- Add raid option
        local raidOption = TargetHandler.Raid(
            targetPropertyId,
            function(success)
                if success then
                    TriggerServerEvent("vms_housing:sv:toggleDoorlock", targetPropertyId, doorIndex, nil, false, true)
                end
            end,
            function()
                return propertyData.metadata.doors[doorIndex].locked and not propertyData.isUnderRaid
            end
        )
        
        if raidOption then
            table.insert(doorOptions, raidOption)
        end
        
        -- Add raid lock option
        local raidLockOption = TargetHandler.RaidLock(
            function(success)
                if success then
                    TriggerServerEvent("vms_housing:sv:toggleDoorlock", targetPropertyId, doorIndex, nil, false, true)
                end
            end,
            function()
                return propertyData.isUnderRaid
            end
        )
        
        if raidLockOption then
            table.insert(doorOptions, raidLockOption)
        end
        
        -- Register target on door entity
        CL.Target("entity", {
            entity = doorEntity,
            options = doorOptions
        })
        
        table.insert(TargetPoints, {
            type = "door",
            entity = doorEntity
        })
    end
    
    -- Find and register door entities
    if doors and not skipRegistration then
        for doorIndex, door in pairs(doors) do
            if door.type == "double" then
                -- Find left and right door entities
                local leftDoor = GetClosestObjectOfType(
                    door.left.coords.x, door.left.coords.y, door.left.coords.z,
                    1.0, door.left.model,
                    false, false, false
                )
                
                local rightDoor = GetClosestObjectOfType(
                    door.right.coords.x, door.right.coords.y, door.right.coords.z,
                    1.0, door.right.model,
                    false, false, false
                )
                
                if leftDoor and leftDoor ~= 0 then
                    CreateDoorTarget(leftDoor, doorIndex, door.distance)
                end
                
                if rightDoor and rightDoor ~= 0 then
                    CreateDoorTarget(rightDoor, doorIndex, door.distance)
                end
                
            elseif door.type == "slide_gate" or door.type == "single" then
                -- Find door entity (larger search radius for sliding gates)
                local searchRadius = door.type == "slide_gate" and 15.0 or 1.0
                local doorEntity = GetClosestObjectOfType(
                    door.coords.x, door.coords.y, door.coords.z,
                    searchRadius, door.model,
                    false, false, false
                )
                
                if doorEntity and doorEntity ~= 0 then
                    CreateDoorTarget(doorEntity, doorIndex, door.distance)
                end
            end
        end
    end
end

-- Check if player has any apartment in a building
function Property.IsHaveAnyApartment(self, buildingId)
    local hasApartment = false
    
    for _, property in pairs(Properties) do
        if property.object_id then
            if tostring(property.object_id) == tostring(buildingId) then
                if library.HasAnyPermission(property.id) then
                    hasApartment = true
                    break
                end
            end
        end
    end
    
    return hasApartment
end

-- Get all apartments in a building
function Property.GetApartments(self, buildingData, simpleList)
    local apartments = {}
    local buildingId = buildingData.id
    
    for _, property in pairs(Properties) do
        if property.object_id == buildingId then
            if simpleList then
                table.insert(apartments, {
                    id = property.id,
                    name = property.name
                })
            else
                table.insert(apartments, property)
            end
        end
    end
    
    return apartments, true
end

-- Open building menu UI
function Property.BuildingMenu(self, buildingData, apartments)
    SendNUIMessage({
        action = "Property",
        actionName = "BuildingMenu",
        data = {
            buildingData = buildingData,
            apartments = apartments
        }
    })
    
    SetNuiFocus(true, true)
    openedMenu = "BuildingMenu"
end

-- Get all rooms in a motel
function Property.GetMotelRooms(self, motelData)
    if not motelData or not motelData.id then
        print("^1[vms_housing] GetMotelRooms: motelData or motelData.id is nil^7")
        return {}
    end
    
    local motelId = motelData.id
    local rooms = {}
    
    
    for propId, property in pairs(Properties) do
        if property.object_id == motelId then
            table.insert(rooms, property)
        end
    end
    
    return rooms
end

-- Open door peephole camera view
function Property.OpenDoorPeephole(self)
    -- Fade out and prepare
    DoScreenFadeOut(1500)
    Wait(1500)
    FreezeEntityPosition(PlayerPedId(), true)
    
    -- Notify server
    TriggerServerEvent("vms_housing:sv:exitHouse", CurrentProperty, true)
    
    -- Disable weather
    if ToggleWeather then
        ToggleWeather(false)
    end
    
    -- Clean up shell/IPL
    if CurrentShell then
        DeleteObject(CurrentShell)
        CurrentShell = nil
    end
    
    if CurrentIPL then
        IPL.UnloadSettings(CurrentIPL)
        CurrentIPL = nil
    end
    
    -- Remove furniture
    self:RemoveFurniture(nil, function() end)
    
    -- Show controls
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "property:peephole",
        controlsName = "Property:peephole"
    })
    
    -- Apply visual effect for smart peephole
    local hasSmartPeephole = CurrentPropertyData.metadata and 
                            CurrentPropertyData.metadata.upgrades and 
                            CurrentPropertyData.metadata.upgrades.smartPeephole
    
    if hasSmartPeephole then
        ClearFocus()
        SetTimecycleModifier("CAMERA_secuirity")
        SetTimecycleModifierStrength(0.8)
    else
        SendNUIMessage({
            action = "Property",
            actionName = "OpenDoorPeephole"
        })
    end
    
    Wait(1500)
    DoScreenFadeIn(1500)
    SetEntityVisible(PlayerPedId(), false, 0)
    
    -- Calculate camera position
    local offsetDistance = 0.05  -- Very close to door for centered view
    local heightOffset = 1.35  -- Lower height for realistic peephole position
    
    -- Get building data if in apartment
    local buildingData = nil
    if CurrentPropertyData.object_id then
        local parent = Properties[tostring(CurrentPropertyData.object_id)]
        if parent and parent.type == "building" then
            buildingData = parent
        end
    end
    
    -- Calculate angle and positions
    local exitData = buildingData and buildingData.metadata.exit or CurrentPropertyData.metadata.exit
    local angle = math.rad(exitData.w + 90.0)
    
    -- Camera position (inside looking out, very close to door)
    local camX = exitData.x - (math.cos(angle) * offsetDistance)
    local camY = exitData.y - (math.sin(angle) * offsetDistance)
    local camZ = exitData.z + heightOffset
    
    -- Look at position (outside, further away)
    local lookX = exitData.x + (math.cos(angle) * 5.0)
    local lookY = exitData.y + (math.sin(angle) * 5.0)
    local lookZ = exitData.z + heightOffset
    
    -- Force texture loading at camera position
    SetFocusPosAndVel(camX, camY, camZ, 0.0, 0.0, 0.0)
    
    -- Create and configure camera
    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(camera, camX, camY, camZ)
    PointCamAtCoord(camera, lookX, lookY, lookZ)
    
    local fov = hasSmartPeephole and 110.0 or 160.0
    SetCamFov(camera, fov)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1, true, true)
    
    -- Wait for exit key
    while true do
        DisableAllControlActions(0)
        EnableControlAction(0, 194, true) -- BACKSPACE key
        
        if IsControlJustPressed(0, 194) then
            break
        end
        
        Citizen.Wait(1)
    end
    
    -- Close peephole view
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = false
    })
    
    -- Re-enter property
    self:EnterProperty(CurrentPropertyData, CurrentProperty, function(success)
        if success then
            Citizen.CreateThread(function()
                -- Wait before cleanup
                Citizen.Wait(2500)
                
                -- Make player visible again
                SetEntityVisible(PlayerPedId(), true, 0)
                
                -- Disable script cameras
                RenderScriptCams(false, true, 500, true, true)
                
                -- Destroy the camera
                DestroyCam(camera, false)
                
                -- Clear visual effects
                ClearFocus()
                ClearTimecycleModifier()
                ClearExtraTimecycleModifier()
                
                -- Close peephole UI
                SendNUIMessage({
                    action = "Property",
                    actionName = "CloseDoorPeephole"
                })
            end)
        end
    end, true)
end

-- Police raid property
function Property.Raid(self, propertyId)
    -- Check raid permissions
    local targetPropertyId = propertyId or GetCurrentPropertyId()
    local canRaid, reason = library.CallbackAwait("vms_housing:isAllowedToRaid", targetPropertyId)
    
    if not canRaid then
        return CL.Notification(TRANSLATE("notify.raid:" .. reason), 5500, "error")
    end
    
    local ped = PlayerPedId()
    local propertyData = GetCurrentPropertyData()
    
    -- Play raid animation
    library.PlayAnimation(
        ped,
        "missheistfbi3b_ig7",
        "lift_fibagent_loop",
        8.0, 8.0, -1, 1
    )
    
    -- Start raid minigame
    CL.Minigame("police_raid", function(success)
        library.StopAnimation(ped)
        
        if success then
            local raidPropertyId = propertyId or GetCurrentPropertyId()
            TriggerServerEvent("vms_housing:sv:raidProperty", raidPropertyId)
        end
    end, {
        antiBurglaryDoors = propertyData.metadata and 
                           propertyData.metadata.upgrades and 
                           propertyData.metadata.upgrades.antiBurglaryDoors
    })
end

-- Marketplace photo mode for property listings
function Property.MarketplacePhotoMode(self, propertyId, marketplaceId)
    -- Check if webhook is configured
    if not MARKETPLACE_PHOTOS_WEBHOOK then
        return library.Debug("Nie możesz korzystać z tej opcji. Nie ma skonfigurowanego webhooka.", "warn")
    end
    
    local active = true
    local phoneActive = false
    local storedPropertyId = propertyId
    local storedMarketplaceId = marketplaceId
    
    closeManageMenu()
    
    -- Toggle phone camera
    local function TogglePhoneCamera()
        phoneActive = not phoneActive
        
        if phoneActive then
            CreateMobilePhone(0)
            CellCamActivate(true, true)
            
            SendNUIMessage({
                action = "ControlsMenu",
                toggle = true,
                controlsLabel = "property:photomode",
                controlsName = "Property:photomode_on"
            })
            
            CL.Notification(TRANSLATE("notify.property:marketplace_photomode_on"), 4000, "info")
        else
            DestroyMobilePhone()
            CellCamActivate(false, false)
            
            SendNUIMessage({
                action = "ControlsMenu",
                toggle = true,
                controlsLabel = "property:photomode",
                controlsName = "Property:photomode_off"
            })
            
            CL.Notification(TRANSLATE("notify.property:marketplace_photomode_off"), 4000, "info")
        end
    end
    
    -- Disable HUD
    CL.Hud:Disable()
    
    -- Show controls
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "property:photomode",
        controlsName = "Property:photomode_off"
    })
    
    local photoTaken = false
    
    -- Main photo mode loop
    while active do
        DisabledControls()
        
        if not photoTaken then
            -- Take photo (ENTER key)
            if phoneActive and IsControlJustPressed(0, 191) then
                photoTaken = true
                
                SendNUIMessage({
                    action = "ControlsMenu",
                    toggle = false
                })
                
                Citizen.Wait(100)
                
                -- Upload screenshot
                exports["screenshot-basic"]:requestScreenshotUpload(
                    MARKETPLACE_PHOTOS_WEBHOOK,
                    "files[]",
                    function(data)
                        local response = json.decode(data)
                        
                        if response and response.attachments and response.attachments[1].url then
                            -- Save photo to marketplace listing
                            TriggerServerEvent(
                                "vms_housing:sv:saveMarketplacePhoto",
                                storedPropertyId,
                                storedMarketplaceId,
                                response.attachments[1].url
                            )
                            active = false
                        else
                            photoTaken = false
                        end
                    end
                )
            end
            
            -- Toggle phone camera (E key)
            if IsControlJustPressed(0, 38) then
                TogglePhoneCamera()
            end
            
            -- Exit photo mode (BACKSPACE key)
            if IsControlJustPressed(0, 202) then
                active = false
            end
        end
        
        Citizen.Wait(1)
    end
    
    -- Cleanup
    DestroyMobilePhone()
    CellCamActivate(false, false)
    CL.Hud:Enable()
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = false
    })
end

-- Export functions
exports("IsHaveAnyApartment", Property.IsHaveAnyApartment)

return Property