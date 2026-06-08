-- Housing Creator System
-- Cleaned and deobfuscated version

-- ============================================
-- STATE VARIABLES
-- ============================================

local isPolyzone = false
local isInteriorZone = false
local isEnterPoint = false
local isExitPoint = false
local isEmergencyExitOutside = false
local isEmergencyExitInside = false
local isMenuPoint = false
local isDoorMode = false
local isGaragePoint = false
local isEnterGaragePoint = false
local isParkingSpaces = false
local isDeliveryPoint = false
local isWardrobePoint = false
local isStoragePoint = false
local isCreatingDoor = false
local isDoubleDoor = false
local isSlideGateDoor = false
local isWardrobeChange = false
local isStorageChange = false

local currentDoorId = nil
local selectedParkingIndex = nil
local currentAction = nil
local lastHighlightedEntity = 0

-- House configuration data structure
houseConfiguration = {
    previousCoords = nil,
    type = nil,
    shell = nil,
    ipl = nil,
    address = nil,
    region = nil,
    zone = {
        points = {},
        minZ = -90.0,
        maxZ = 90.0
    },
    interiorZone = {
        points = {},
        minZ = -90.0,
        maxZ = 90.0
    },
    doors = {},
    doorsDistance = 2.0,
    enterGarageCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
    enterCoords = { x = 0.0, y = 0.0, z = 0.0 },
    exitCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
    emergencyInsideCoords = { x = 0.0, y = 0.0, z = 0.0 },
    emergencyOutsideCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
    menuCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
    __garageVehicleObj = nil,
    garageCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
    parkingSpaces = {},
    wardrobeCoords = { x = 0.0, y = 0.0, z = 0.0 },
    storageCoords = { x = 0.0, y = 0.0, z = 0.0 },
    __deliveryObj = nil,
    deliveryPoint = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 }
}

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

function resetHouseCreationTable()
    houseConfiguration = {
        previousCoords = nil,
        type = nil,
        shell = nil,
        ipl = nil,
        address = nil,
        region = nil,
        zone = { points = {}, minZ = -90.0, maxZ = 90.0 },
        interiorZone = { points = {}, minZ = -90.0, maxZ = 90.0 },
        doors = {},
        doorsDistance = 2.0,
        enterGarageCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
        enterCoords = { x = 0.0, y = 0.0, z = 0.0 },
        exitCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
        emergencyInsideCoords = { x = 0.0, y = 0.0, z = 0.0 },
        emergencyOutsideCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
        menuCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
        __garageVehicleObj = nil,
        garageCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
        parkingSpaces = {},
        wardrobeCoords = { x = 0.0, y = 0.0, z = 0.0 },
        storageCoords = { x = 0.0, y = 0.0, z = 0.0 },
        __deliveryObj = nil,
        deliveryPoint = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 }
    }
end

function OpenHousingCreator()
    
    -- Check job requirement
    if Config.HousingCreator.RequiredJob then
        local playerJob = CL.GetPlayerJob("name")
        if playerJob ~= Config.HousingCreator.RequiredJob then
            print("^1[vms_housing] Player doesn't have required job^7")
            CL.Notification(TRANSLATE("notify.you_dont_have_permission"), 5000, "error")
            return
        end
    end
    
    if openedMenu == "HousingCreator" then
        print("^1[vms_housing] Menu already open^7")
        return
    end
    
    resetHouseCreationTable()
    
    -- Wait for NUI to be ready after restart
    Citizen.Wait(100)
    
    SendNUIMessage({
        action = "HousingCreator",
        actionName = "Open"
    })
    
    -- Small delay to ensure NUI is ready
    Citizen.Wait(50)
    
    SetNuiFocus(true, true)
    openedMenu = "HousingCreator"
end

-- Register command if enabled
if Config.HousingCreator and Config.HousingCreator.Command then
    RegisterCommand(Config.HousingCreator.Command, function()
        OpenHousingCreator()
    end)
    
    if Config.HousingCreator.Key then
        RegisterKeyMapping(
            Config.HousingCreator.Command,
            Config.HousingCreator.Description or "",
            "keyboard",
            Config.HousingCreator.Key
        )
    end
else
    print("^1[vms_housing] Config.HousingCreator not found or Command not set^7")
end

-- ============================================
-- CAMERA SYSTEM
-- ============================================

HousingCreator = {
    camera = nil
}

function HousingCreator.CreateCamera(self, skipHeight, callback)
    local camX, camY, camZ = table.unpack(GetGameplayCamCoord())
    local rotX, rotY, rotZ = table.unpack(GetGameplayCamRot(2))
    local fov = GetGameplayCamFov()
    
    self.camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    local heightOffset = skipHeight and -1.0 or 20.0
    SetCamCoord(self.camera, camX, camY, camZ + heightOffset)
    SetCamRot(self.camera, rotX, rotY, rotZ, 2)
    SetCamFov(self.camera, fov)
    
    RenderScriptCams(true, true, 500, true, true)
    FreezeEntityPosition(PlayerPedId(), true)
    
    if callback then
        callback(self.camera)
    end
end

function HousingCreator.DeleteCamera(self)
    if self.camera then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(self.camera, false)
        DetachCam(self.camera)
        DestroyCam(self.camera, true)
        self.camera = nil
    end
end

-- ============================================
-- POLYZONE CREATION
-- ============================================

function HousingCreator.Polyzone(self, isInterior)
    if isInterior then
        isInteriorZone = true
    end
    
    isPolyzone = true
    self.CreateCamera(self)
    
    -- Initialize zone with proper ground height
    local playerCoords = GetEntityCoords(PlayerPedId())
    local zone = isInterior and houseConfiguration.interiorZone or houseConfiguration.zone
    zone.minZ = playerCoords.z - 3.0  -- Start 3 meters below ground
    zone.maxZ = playerCoords.z + 6.0  -- Start 5 meters above ground
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = isInterior and "creator:interiorzone" or "creator:polyzone",
        controlsName = "HousingCreator:polyzone"
    })
    
    Citizen.CreateThread(function()
        while isPolyzone do
            startRaycast(HousingCreator.camera)
            rotateCamInputs()
            moveCamInputs()
            DisabledControls()
            
            -- Check for finish key (Enter)
            if IsControlJustPressed(0, Config.HousingCreatorControls.ENTER.controlIndex) then
                local zone = isInteriorZone and houseConfiguration.interiorZone or houseConfiguration.zone
                if #zone.points >= 3 then
                    -- Save zone type before resetting flags
                    local wasInteriorZone = isInteriorZone
                    
                    -- Minimum 3 points for a valid polygon
                    isPolyzone = false
                    isInteriorZone = false
                    
                    -- Reopen the menu after saving with zone data
                    Citizen.Wait(500)
                    SetNuiFocus(true, true)
                    
                    -- First send the zone update with full coordinate data
                    local zoneData = {
                        maxZ = zone.maxZ,
                        points = zone.points,
                        minZ = zone.minZ
                    }
                    
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = {
                            type = "update-input-value",
                            inputName = wasInteriorZone and "interior_zone" or "yard_zone",
                            housingType = houseConfiguration.type or "mlo",
                            value = json.encode(zoneData)
                        }
                    })
                    
                    -- Then show the menu
                    Citizen.Wait(100)
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                else
                    print("^1[vms_housing] Need at least 3 points for a valid zone (current: " .. #zone.points .. ")^7")
                end
            end
            
            -- Check for cancel key (Backspace/ESC)
            if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                local zone = isInteriorZone and houseConfiguration.interiorZone or houseConfiguration.zone
                zone.points = {}
                isPolyzone = false
                isInteriorZone = false
                
                -- Reopen the menu after cancelling
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
            -- Remove last point with Right Click
            if IsControlJustPressed(0, Config.HousingCreatorControls.BACK.controlIndex) then
                local zone = isInteriorZone and houseConfiguration.interiorZone or houseConfiguration.zone
                if #zone.points > 0 then
                    table.remove(zone.points, #zone.points)
                end
            end
            
            -- Adjust zone height with scroll wheel (hold CTRL for lower zone)
            local zone = isInteriorZone and houseConfiguration.interiorZone or houseConfiguration.zone
            if IsControlPressed(0, Config.HousingCreatorControls.LEFT_CTRL.controlIndex) then
                -- Adjust lower zone (minZ) while holding CTRL
                if IsControlPressed(0, Config.HousingCreatorControls.SCROLL_UP.controlIndex) then
                    zone.minZ = zone.minZ + 0.1
                elseif IsControlPressed(0, Config.HousingCreatorControls.SCROLL_DOWN.controlIndex) then
                    zone.minZ = zone.minZ - 0.1
                end
            else
                -- Adjust upper zone (maxZ) without CTRL
                if IsControlPressed(0, Config.HousingCreatorControls.SCROLL_UP.controlIndex) then
                    zone.maxZ = zone.maxZ + 0.1
                elseif IsControlPressed(0, Config.HousingCreatorControls.SCROLL_DOWN.controlIndex) then
                    zone.maxZ = zone.maxZ - 0.1
                end
            end
            
            -- Draw zone visualization
            local zone = isInteriorZone and houseConfiguration.interiorZone or houseConfiguration.zone
            
            if #zone.points >= 3 then
                -- Draw filled polygon walls (like in the reference image)
                for i = 1, #zone.points do
                    local point1 = zone.points[i]
                    local point2 = zone.points[i + 1] or zone.points[1]
                    
                    -- Draw vertical corner lines
                    DrawLine(
                        point1.x, point1.y, zone.minZ,
                        point1.x, point1.y, zone.maxZ,
                        178, 128, 255, 255
                    )
                    
                    -- Draw filled wall polygons from both sides for complete coverage
                    -- Outside face
                    DrawPoly(
                        point1.x, point1.y, zone.minZ,
                        point1.x, point1.y, zone.maxZ,
                        point2.x, point2.y, zone.maxZ,
                        140, 90, 205, 180  -- Darker purple with more opacity
                    )
                    DrawPoly(
                        point1.x, point1.y, zone.minZ,
                        point2.x, point2.y, zone.maxZ,
                        point2.x, point2.y, zone.minZ,
                        140, 90, 205, 180  -- Darker purple with more opacity
                    )
                    
                    -- Inside face (reverse winding)
                    DrawPoly(
                        point2.x, point2.y, zone.maxZ,
                        point1.x, point1.y, zone.maxZ,
                        point1.x, point1.y, zone.minZ,
                        140, 90, 205, 180  -- Darker purple with more opacity
                    )
                    DrawPoly(
                        point2.x, point2.y, zone.minZ,
                        point2.x, point2.y, zone.maxZ,
                        point1.x, point1.y, zone.minZ,
                        140, 90, 205, 180  -- Darker purple with more opacity
                    )
                    
                    -- Draw edge lines for clarity
                    DrawLine(point1.x, point1.y, zone.minZ, point2.x, point2.y, zone.minZ, 178, 128, 255, 255)
                    DrawLine(point1.x, point1.y, zone.maxZ, point2.x, point2.y, zone.maxZ, 178, 128, 255, 255)
                end
                
                -- Draw floor and ceiling polygons with darker purple
                if #zone.points >= 3 then
                    -- Draw floor - darker purple
                    for i = 1, #zone.points - 2 do
                        DrawPoly(
                            zone.points[1].x, zone.points[1].y, zone.minZ,
                            zone.points[i + 1].x, zone.points[i + 1].y, zone.minZ,
                            zone.points[i + 2].x, zone.points[i + 2].y, zone.minZ,
                            140, 90, 205, 100  -- Darker purple for floor
                        )
                    end
                    
                    -- Draw ceiling - darker purple and visible from both sides
                    for i = 1, #zone.points - 2 do
                        -- Top side
                        DrawPoly(
                            zone.points[1].x, zone.points[1].y, zone.maxZ,
                            zone.points[i + 1].x, zone.points[i + 1].y, zone.maxZ,
                            zone.points[i + 2].x, zone.points[i + 2].y, zone.maxZ,
                            140, 90, 205, 150  -- Darker purple for ceiling, more visible
                        )
                        -- Bottom side (visible from inside)
                        DrawPoly(
                            zone.points[i + 2].x, zone.points[i + 2].y, zone.maxZ,
                            zone.points[i + 1].x, zone.points[i + 1].y, zone.maxZ,
                            zone.points[1].x, zone.points[1].y, zone.maxZ,
                            140, 90, 205, 150  -- Darker purple for ceiling, more visible
                        )
                    end
                end
            elseif #zone.points >= 1 then
                -- Draw points and preview lines while creating
                for i = 1, #zone.points do
                    -- Draw vertical lines at each point
                    DrawLine(
                        zone.points[i].x, zone.points[i].y, zone.minZ,
                        zone.points[i].x, zone.points[i].y, zone.maxZ,
                        178, 128, 255, 255
                    )
                    
                    -- Draw preview line to next point
                    if zone.points[i + 1] then
                        DrawLine(
                            zone.points[i].x, zone.points[i].y, zone.minZ,
                            zone.points[i + 1].x, zone.points[i + 1].y, zone.minZ,
                            178, 128, 255, 200
                        )
                    end
                end
            end
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
        
        FreezeEntityPosition(PlayerPedId(), false)
        self.DeleteCamera(self)
    end)
end

-- ============================================
-- POINT CREATION FUNCTIONS
-- ============================================

function HousingCreator.CreateEnterPoint(self)
    isEnterPoint = true
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:enter",
        controlsName = "HousingCreator:default"
    })
    
    Citizen.CreateThread(function()
        while isEnterPoint do
            startRaycast()
            DisabledControls()
            
            -- Draw zone lines
            -- [Zone drawing code similar to polyzone]
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
    end)
end

function HousingCreator.CreateExitPoint(self)
    isExitPoint = true
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:exit",
        controlsName = "HousingCreator:default"
    })
    
    Citizen.CreateThread(function()
        while isExitPoint do
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            
            -- Draw marker at player position
            DrawMarker(
                26, coords.x, coords.y, coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, heading,
                1.0, 1.0, 1.0,
                159, 15, 255, 145,
                false, false, 2, false, nil, nil, false
            )
            
            -- Handle mouse click to save exit point
            if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                houseConfiguration.exitCoords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = heading
                }
                isExitPoint = false
                
                -- Reopen menu and update UI with coordinates
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                
                -- Send the exit point coordinates to UI
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = {
                        type = "update-input-value",
                        inputName = "exit_point",
                        housingType = houseConfiguration.type or "mlo",
                        value = json.encode(houseConfiguration.exitCoords)
                    }
                })
                
                -- Show the menu
                Citizen.Wait(100)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
            -- Handle cancel
            if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                isExitPoint = false
                
                -- Reopen menu
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
            DisabledControls()
            
            -- [Zone visualization code]
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
    end)
end

function HousingCreator.CreateMenuPoint(self)
    isMenuPoint = true
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:menu",
        controlsName = "HousingCreator:default"
    })
    
    Citizen.CreateThread(function()
        while isMenuPoint do
            startRaycast()
            DisabledControls()
            
            -- Handle cancel
            if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                isMenuPoint = false
                
                -- Reopen menu
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
    end)
end

function HousingCreator.CreateEmergencyExitOutsidePoint(self)
    isEmergencyExitOutside = true
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:emergency_exit",
        controlsName = "HousingCreator:default"
    })
    
    Citizen.CreateThread(function()
        while isEmergencyExitOutside do
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            
            -- Draw marker at player position
            DrawMarker(
                26, coords.x, coords.y, coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, heading,
                1.0, 1.0, 1.0,
                255, 100, 100, 145,  -- Red color for emergency
                false, false, 2, false, nil, nil, false
            )
            
            -- Handle mouse click to save emergency exit outside point
            if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                houseConfiguration.emergencyOutsideCoords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = heading
                }
                isEmergencyExitOutside = false
                
                -- Reopen menu and update UI with coordinates
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                
                -- Send the emergency exit outside coordinates to UI
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = {
                        type = "update-input-value",
                        inputName = "emergency_exit_outside",
                        housingType = houseConfiguration.type or "shell",
                        value = json.encode(houseConfiguration.emergencyOutsideCoords)
                    }
                })
                
                -- Show the menu
                Citizen.Wait(100)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
            -- Handle cancel
            if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                isEmergencyExitOutside = false
                
                -- Reopen menu
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
            DisabledControls()
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
    end)
end

function HousingCreator.CreateEmergencyExitInsidePoint(self, theme)
    isEmergencyExitInside = true
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:emergency_exit",
        controlsName = "HousingCreator:default"
    })
    
    Citizen.CreateThread(function()
        -- Enter shell/IPL if needed
        if houseConfiguration.shell then
            HousingCreator.EnterShell(self, houseConfiguration.shell)
        elseif houseConfiguration.ipl then
            HousingCreator.EnterIPL(self, houseConfiguration.ipl, nil, theme)
        end
        
        while isEmergencyExitInside do
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            
            -- Draw marker at player position
            DrawMarker(
                26, coords.x, coords.y, coords.z - 0.9,
                0.0, 0.0, 0.0, 0.0, 0.0, heading,
                1.0, 1.0, 1.0,
                255, 100, 100, 145,  -- Red color for emergency
                false, false, 2, false, nil, nil, false
            )
            
            -- Handle mouse click to save emergency exit inside point
            if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                houseConfiguration.emergencyInsideCoords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = heading
                }
                isEmergencyExitInside = false
                
                -- Exit shell/IPL
                if CurrentShell then
                    DeleteObject(CurrentShell)
                    CurrentShell = false
                end
                CurrentIPL = nil
                
                if (houseConfiguration.shell or houseConfiguration.ipl) and houseConfiguration.previousCoords then
                    SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
                end
                
                -- Reopen menu and update UI with coordinates
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                
                -- Send the emergency exit inside coordinates to UI
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = {
                        type = "update-input-value",
                        inputName = "emergency_exit_inside",
                        housingType = houseConfiguration.type or "shell",
                        value = json.encode(houseConfiguration.emergencyInsideCoords)
                    }
                })
                
                -- Show the menu
                Citizen.Wait(100)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
            -- Handle cancel
            if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                isEmergencyExitInside = false                
                -- Exit shell/IPL
                if CurrentShell then
                    DeleteObject(CurrentShell)
                    CurrentShell = false
                end
                CurrentIPL = nil
                
                if (houseConfiguration.shell or houseConfiguration.ipl) and houseConfiguration.previousCoords then
                    SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
                end
                
                -- Reopen menu
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
            DisabledControls()
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
    end)
end

-- ============================================
-- GARAGE & PARKING FUNCTIONS
-- ============================================

function HousingCreator.CreateGaragePoint(self)
    isGaragePoint = true
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:garage",
        controlsName = "HousingCreator:garage"
    })
    
    Citizen.CreateThread(function()
        -- Clean up existing vehicle
        if houseConfiguration.__garageVehicleObj ~= nil then
            if DoesEntityExist(houseConfiguration.__garageVehicleObj) then
                DeleteVehicle(houseConfiguration.__garageVehicleObj)
                houseConfiguration.__garageVehicleObj = nil
            end
        end
        
        -- Spawn preview vehicle
        library.RequestEntity("baller7")
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        -- Create vehicle first at player position
        houseConfiguration.__garageVehicleObj = CreateVehicle(
            joaat("baller7"),
            playerCoords.x, playerCoords.y, playerCoords.z + 1.0,
            GetEntityHeading(PlayerPedId()),
            false, false  -- Not on network, not as mission entity
        )
        
        -- Wait for vehicle to exist
        while not DoesEntityExist(houseConfiguration.__garageVehicleObj) do
            Citizen.Wait(1)
        end
        
        -- Get proper ground position and place vehicle
        local vehCoords = GetEntityCoords(houseConfiguration.__garageVehicleObj)
        local found, groundZ = GetGroundZFor_3dCoord(vehCoords.x, vehCoords.y, vehCoords.z + 10.0, false)
        if found then
            SetEntityCoords(houseConfiguration.__garageVehicleObj, vehCoords.x, vehCoords.y, groundZ + 0.1, false, false, false, false)
        end
        
        -- Completely disable physics and collision
        FreezeEntityPosition(houseConfiguration.__garageVehicleObj, true)
        SetEntityCollision(houseConfiguration.__garageVehicleObj, false, false)
        SetEntityCompletelyDisableCollision(houseConfiguration.__garageVehicleObj, false, false)
        SetVehicleGravity(houseConfiguration.__garageVehicleObj, false)
        SetEntityAlpha(houseConfiguration.__garageVehicleObj, 200, false)  -- Make slightly transparent
        SetVehicleDoorsLocked(houseConfiguration.__garageVehicleObj, 2)  -- Lock doors
        SetEntityInvincible(houseConfiguration.__garageVehicleObj, true)  -- Make invincible
        SetEntityCanBeDamaged(houseConfiguration.__garageVehicleObj, false)  -- Prevent damage
        SetVehicleEngineOn(houseConfiguration.__garageVehicleObj, false, true, true)  -- Engine off
        
        while isGaragePoint do
            startRaycast()
            DisabledControls()
            
            -- [Zone visualization]
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
    end)
end

function HousingCreator.CreateParkingSpaces(self)
    isParkingSpaces = true
    
    self.CreateCamera(self)
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:parking",
        controlsName = "HousingCreator:parking"
    })
    
    -- Load existing parking spaces or create new one
    if #houseConfiguration.parkingSpaces >= 1 then
        library.RequestEntity("baller3")
        
        for index, space in pairs(houseConfiguration.parkingSpaces) do
            if space.coords then
                space.vehicle = CreateVehicle(
                    GetHashKey("baller3"),
                    space.coords.x, space.coords.y, space.coords.z,
                    space.coords.w,
                    false, true
                )
                
                Citizen.Wait(5)
                
                -- Snap to ground
                local found, groundZ = GetGroundZFor_3dCoord(
                    space.coords.x, space.coords.y, space.coords.z, 0
                )
                
                if found then
                    SetEntityCoords(space.vehicle, space.coords.x, space.coords.y, groundZ)
                    local rotation = GetEntityRotation(space.vehicle, 2)
                    SetEntityHeading(space.vehicle, space.coords.w)
                    SetEntityRotation(space.vehicle, rotation.x, rotation.y, space.coords.w, 2, true)
                else
                    SetEntityCoords(space.vehicle, space.coords.x, space.coords.y, space.coords.z)
                    SetEntityHeading(space.vehicle, space.coords.w)
                end
                
                Citizen.Wait(5)
                FreezeEntityPosition(space.vehicle, true)
            end
        end
        
        Citizen.Wait(100)
        
        -- Add new parking space
        selectedParkingIndex = #houseConfiguration.parkingSpaces + 1
        houseConfiguration.parkingSpaces[selectedParkingIndex] = {
            coords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 }
        }
        
        houseConfiguration.parkingSpaces[selectedParkingIndex].vehicle = CreateVehicle(
            GetHashKey("baller3"),
            x, y, z,
            houseConfiguration.parkingSpaces[selectedParkingIndex].coords.w,
            false, true
        )
        
        FreezeEntityPosition(
            houseConfiguration.parkingSpaces[selectedParkingIndex].vehicle,
            true
        )
    else
        -- Create first parking space
        selectedParkingIndex = 1
        houseConfiguration.parkingSpaces[selectedParkingIndex] = {}
        
        library.RequestEntity("baller3")
        
        houseConfiguration.parkingSpaces[selectedParkingIndex].coords = {
            x = 0.0, y = 0.0, z = 0.0, w = 0.0
        }
        
        houseConfiguration.parkingSpaces[selectedParkingIndex].vehicle = CreateVehicle(
            GetHashKey("baller3"),
            x, y, z,
            houseConfiguration.parkingSpaces[selectedParkingIndex].coords.w,
            false, true
        )
        
        FreezeEntityPosition(
            houseConfiguration.parkingSpaces[selectedParkingIndex].vehicle,
            true
        )
    end
    
    Citizen.CreateThread(function()
        while isParkingSpaces do
            startRaycast(HousingCreator.camera)
            rotateCamInputs()
            moveCamInputs()
            DisabledControls()
            
            -- [Zone visualization]
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
        
        FreezeEntityPosition(PlayerPedId(), false)
        self.DeleteCamera(self)
    end)
end

-- ============================================
-- DOOR MANAGEMENT
-- ============================================

function HousingCreator.CreateDoor(self, isDouble, isSlideGate)
    isCreatingDoor = true
    houseConfiguration.doorsDistance = 1.5
    
    if isDouble then
        isDoubleDoor = true
    end
    
    if isSlideGate then
        isSlideGateDoor = true
        houseConfiguration.doorsDistance = 8.5
    end
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:doors",
        controlsName = "HousingCreator:doors"
    })
    
    Citizen.CreateThread(function()
        if not houseConfiguration.doors then
            houseConfiguration.doors = {}
        end
        
        currentDoorId = #houseConfiguration.doors + 1
        
        while isCreatingDoor do
            startRaycast()
            DisabledControls()
            
            -- [Zone visualization]
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
    end)
end

function HousingCreator.RemoveDoor(self, doorId)
    if houseConfiguration.doors[doorId] then
        table.remove(houseConfiguration.doors, doorId)
    end
    
    SendNUIMessage({
        action = "HousingCreator",
        actionName = "Update",
        data = {
            type = "update-doors-list",
            value = houseConfiguration.doors
        }
    })
end

-- ============================================
-- SAVE FUNCTIONS
-- ============================================

function HousingCreator.Save(self, data)
    local address = houseConfiguration.address
    local region = houseConfiguration.region
    local name = data.buildingName or data.motelName or data.houseName
    local description = data.houseDescription or ""
    
    local metadata = {}
    local saleData = { defaultActive = false, defaultPrice = 0 }
    local rentalData = { defaultActive = false, defaultPrice = 0 }
    
    -- Build metadata based on property type
    if houseConfiguration.type == "shell" or 
       houseConfiguration.type == "ipl" or 
       houseConfiguration.type == "mlo" then
        
        metadata.upgrades = {}
        metadata.lightState = false
        metadata.locked = false
        
        if not data.building and not data.motel then
            metadata.zone = houseConfiguration.zone
            metadata.zone.area = calculatePolygonArea(houseConfiguration.zone.points)
            metadata.allowFurnitureOutside = data.allowFurnitureOutside
        end
        
        if houseConfiguration.type == "shell" or houseConfiguration.type == "ipl" then
            metadata.enter = houseConfiguration.enterCoords
            metadata.exit = houseConfiguration.exitCoords
        end
        
        -- Always preserve existing wardrobe position when editing, unless explicitly changed
        if data.id and Properties[tostring(data.id)] and Properties[tostring(data.id)].metadata and Properties[tostring(data.id)].metadata.wardrobe then
            metadata.wardrobe = Properties[tostring(data.id)].metadata.wardrobe
        elseif data.isWardrobe and houseConfiguration.wardrobeCoords and 
               (houseConfiguration.wardrobeCoords.x ~= 0 or 
                houseConfiguration.wardrobeCoords.y ~= 0 or 
                houseConfiguration.wardrobeCoords.z ~= 0) then
            metadata.wardrobe = houseConfiguration.wardrobeCoords
        end
        
        -- Always preserve existing storage position when editing, unless explicitly changed
        if data.id and Properties[tostring(data.id)] and Properties[tostring(data.id)].metadata and Properties[tostring(data.id)].metadata.storage then
            metadata.storage = Properties[tostring(data.id)].metadata.storage
            -- Update slots and weight if provided in the form
            if data.isStorage then
                if data.storageSlots then
                    metadata.storage.slots = tonumber(data.storageSlots)
                end
                if data.storageWeight then
                    metadata.storage.weight = tonumber(data.storageWeight)
                end
            end
        elseif data.isStorage and houseConfiguration.storageCoords and 
               (houseConfiguration.storageCoords.x ~= 0 or 
                houseConfiguration.storageCoords.y ~= 0 or 
                houseConfiguration.storageCoords.z ~= 0) then
            metadata.storage = houseConfiguration.storageCoords
            metadata.storage.slots = tonumber(data.storageSlots)
            metadata.storage.weight = tonumber(data.storageWeight)
        end
        
        -- Keys and permissions limits
        if data.isKeysLimit and data.keysLimit then
            local keysLimit = tonumber(data.keysLimit)
            if keysLimit and keysLimit >= 0 then
                metadata.keysLimit = data.keysLimit
            end
        else
            metadata.keysLimit = nil
        end
        
        if data.isPermissionsLimit and data.permissionsLimit then
            local permLimit = tonumber(data.permissionsLimit)
            if permLimit and permLimit >= 0 then
                metadata.permissionsLimit = data.permissionsLimit
            end
        else
            metadata.permissionsLimit = nil
        end
        
        metadata.allowFurnitureInside = data.allowFurnitureInside
    end
    
    -- Type-specific metadata
    if houseConfiguration.type == "shell" then
        metadata.shell = houseConfiguration.shell
        
        if data.isEmergencyExit then
            metadata.emergencyInside = houseConfiguration.emergencyInsideCoords
            metadata.emergencyOutside = houseConfiguration.emergencyOutsideCoords
        else
            metadata.emergencyInside = nil
            metadata.emergencyOutside = nil
        end
        
    elseif houseConfiguration.type == "ipl" then
        metadata.ipl = houseConfiguration.ipl
        
        -- Handle IPL themes
        if AvailableIPLS[houseConfiguration.ipl].settings and 
           AvailableIPLS[houseConfiguration.ipl].settings.Themes then
            
            if AvailableIPLS[houseConfiguration.ipl].settings.Themes[data.houseTheme] then
                metadata.iplTheme = data.houseTheme
            else
                -- Use first available theme
                for theme, _ in pairs(AvailableIPLS[houseConfiguration.ipl].settings.Themes) do
                    metadata.iplTheme = theme
                    break
                end
            end
            
            metadata.allowChangeTheme = data.allowChangeTheme
            metadata.allowChangeThemePurchased = data.allowChangeThemePurchased
        end
        
        metadata.iplSettings = {}
        
        if data.isEmergencyExit then
            metadata.emergencyInside = houseConfiguration.emergencyInsideCoords
            metadata.emergencyOutside = houseConfiguration.emergencyOutsideCoords
        else
            metadata.emergencyInside = nil
            metadata.emergencyOutside = nil
        end
        
    elseif houseConfiguration.type == "mlo" then
        metadata.interiorZone = houseConfiguration.interiorZone
        metadata.interiorZone.area = calculatePolygonArea(houseConfiguration.interiorZone.points)
        metadata.menu = houseConfiguration.menu
        
        -- Handle doors
        if houseConfiguration.doors and next(houseConfiguration.doors) then
            local cleanedDoors = {}
            
            for _, door in pairs(houseConfiguration.doors) do
                if door.type == "double" then
                    door.left.entity = nil
                    door.right.entity = nil
                else
                    door.entity = nil
                end
                
                table.insert(cleanedDoors, door)
            end
            
            metadata.doors = cleanedDoors
        end
        
    elseif houseConfiguration.type == "building" then
        metadata.zone = houseConfiguration.zone
        metadata.enter = houseConfiguration.enterCoords
        metadata.exit = houseConfiguration.exitCoords
        
        if data.apartmentParking then
            metadata.parkingEnter = houseConfiguration.enterGarageCoords
        end
        
    elseif houseConfiguration.type == "motel" then
        metadata.zone = houseConfiguration.zone
    end
    
    -- Garage and parking
    if data.isGarage then
        metadata.garage = houseConfiguration.garageCoords
    end
    
    if data.isParking then
        metadata.parking = houseConfiguration.parkingSpaces
        
        if #metadata.parking >= 1 then
            for _, space in pairs(metadata.parking) do
                space.vehicle = nil
            end
        end
    end
    
    -- Delivery point
    if data.isDeliveryInside then
        metadata.deliveryType = "inside"
        metadata.delivery = houseConfiguration.deliveryPoint
    elseif data.isDeliveryOutside then
        metadata.deliveryType = "outside"
        metadata.delivery = houseConfiguration.deliveryPoint
    else
        metadata.deliveryType = nil
        metadata.delivery = nil
    end
    
    -- Sale and rental settings
    if data.isPurchase then
        saleData.defaultActive = true
        saleData.defaultPrice = tonumber(data.purchasePrice)
    end
    
    if data.isRent then
        rentalData.defaultActive = true
        rentalData.defaultPrice = tonumber(data.rentPrice)
    end
    
    -- Send to server
    TriggerServerEvent(
        "vms_housing:sv:createNewHouse",
        houseConfiguration.type,
        {
            building = data.building,
            motel = data.motel,
            parkingSpaces = data.parkingSpaces,
            apartmentParking = data.apartmentParking,
            parkingFloors = data.apartmentParking and data.parkingFloors or nil,
            address = address,
            region = region,
            name = name,
            description = description,
            metadata = json.encode(metadata),
            sale = json.encode(saleData),
            rental = json.encode(rentalData)
        },
        data.isModifying
    )
    
    resetHouseCreationTable()
end

function HousingCreator.SaveFurniture(self, data)
    TriggerServerEvent("vms_housing:sv:modifyFurniture", data.model, data)
end

function HousingCreator.Close()
    SendNUIMessage({
        action = "HousingCreator",
        actionName = "Close"
    })
    
    SetNuiFocus(false, false)
    openedMenu = nil
end

-- ============================================
-- SHELL/IPL ENTRY FUNCTIONS
-- ============================================

function HousingCreator.EnterShell(self, shellName, callback)
    if CurrentShell then
        return warn("You are already in shell!")
    end
    
    if not shellName then
        SendNUIMessage({
            action = "HousingCreator",
            actionName = "Update",
            data = { type = "show-menu" }
        })
        SetNuiFocus(true, true)
        return
    end
    
    if not AvailableShells[shellName] then
        SendNUIMessage({
            action = "HousingCreator",
            actionName = "Update",
            data = { type = "show-menu" }
        })
        SetNuiFocus(true, true)
        return warn('Could not find shell "' .. shellName .. '"!')
    end
    
    -- Try to request the shell model
    local shellRequested = library.RequestEntity(shellName)
    
    if not shellRequested then
        -- Try with the model property if it exists
        if AvailableShells[shellName] and AvailableShells[shellName].model then
            shellRequested = library.RequestEntity(AvailableShells[shellName].model)
        end
    end
    
    if not shellRequested then
        SendNUIMessage({
            action = "HousingCreator",
            actionName = "Update",
            data = { type = "show-menu" }
        })
        SetNuiFocus(true, true)
        
        -- Provide helpful error message
        print("^1[vms_housing] ERROR: Failed to load shell '" .. shellName .. "'")
        
        CL.Notification("Shell resource not loaded! Check F8 console for details.", 5000, "error")
        return
    end
    
    houseConfiguration.previousCoords = GetEntityCoords(PlayerPedId())
    
    FreezeEntityPosition(PlayerPedId(), true)
    DoScreenFadeOut(1500)
    Wait(1500)
    
    -- Use the model property if it exists, otherwise use shellName
    local modelToUse = (AvailableShells[shellName] and AvailableShells[shellName].model) or shellName
    
    CurrentShell = CreateObjectNoOffset(
        joaat(modelToUse),
        0.0, 0.0, 500.0,
        false, false, false
    )
    
    while not DoesEntityExist(CurrentShell) do
        Wait(1)
    end
    
    SetEntityHeading(CurrentShell, 0.0)
    FreezeEntityPosition(CurrentShell, true)
    
    SetEntityCoords(
        PlayerPedId(),
        vector3(
            AvailableShells[shellName].doors.x,
            AvailableShells[shellName].doors.y,
            AvailableShells[shellName].doors.z
        )
    )
    
    SetEntityHeading(PlayerPedId(), AvailableShells[shellName].doors.heading)
    
    Wait(1500)
    DoScreenFadeIn(1500)
    FreezeEntityPosition(PlayerPedId(), false)
    
    if callback then
        callback()
    end
end

function HousingCreator.EnterIPL(self, iplName, callback, theme)
    if CurrentIPL then
        return warn("You are already in IPL!")
    end
    
    if not iplName then
        SendNUIMessage({
            action = "HousingCreator",
            actionName = "Update",
            data = { type = "show-menu" }
        })
        SetNuiFocus(true, true)
        return
    end
    
    if not AvailableIPLS[iplName] then
        SendNUIMessage({
            action = "HousingCreator",
            actionName = "Update",
            data = { type = "show-menu" }
        })
        SetNuiFocus(true, true)
        return warn('Could not find IPL "' .. iplName .. '"!')
    end
    
    houseConfiguration.previousCoords = GetEntityCoords(PlayerPedId())
    
    FreezeEntityPosition(PlayerPedId(), true)
    DoScreenFadeOut(1500)
    Wait(1500)
    
    CurrentIPL = iplName
    
    if theme and AvailableIPLS[iplName]?.settings?.Themes[theme] then
        IPL.LoadSettings(CurrentIPL, theme)
    end
    
    SetEntityCoords(
        PlayerPedId(),
        vector3(
            AvailableIPLS[iplName].doors.x,
            AvailableIPLS[iplName].doors.y,
            AvailableIPLS[iplName].doors.z
        )
    )
    
    SetEntityHeading(PlayerPedId(), AvailableIPLS[iplName].doors.heading)
    
    Wait(1500)
    DoScreenFadeIn(1500)
    FreezeEntityPosition(PlayerPedId(), false)
    
    if callback then
        callback()
    end
end

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

function HousingCreator.GetObjects(self, buildings, motels)
    local buildingList = {}
    local motelList = {}
    
    for id, property in pairs(Properties) do
        if property.type == "building" and buildings then
            table.insert(buildingList, {
                id = property.id,
                label = property.name,
                parkingSpaces = property.metadata and property.metadata.parkingSpaces or nil,
                isMenuBuilding = true
            })
        elseif property.type == "motel" and motels then
            table.insert(motelList, {
                id = property.id,
                label = property.name
            })
        end
    end
    
    return buildingList, motelList
end

function HousingCreator.GetBuildingParkingSpaces(self, buildingId)
    local building = Properties[buildingId]
    
    if not building then
        return nil
    end
    
    if building.metadata and building.metadata.parkingSpaces then
        return building.metadata.parkingSpaces
    end
    
    return nil
end

-- ============================================
-- CAMERA MOVEMENT & CONTROLS
-- ============================================

local MAX_CAMERA_DISTANCE = 1580
local CAMERA_SPEED = 0.18

function moveCamInputs()
    local camX, camY, camZ = table.unpack(GetCamCoord(HousingCreator.camera))
    local rotX, rotY, rotZ = table.unpack(GetCamRot(HousingCreator.camera, 2))
    
    local speed = CAMERA_SPEED
    
    -- Adjust speed with modifier keys
    if IsControlPressed(0, 60) then -- Left Alt (slow)
        speed = CAMERA_SPEED / 2
    elseif IsControlPressed(0, 21) then -- Left Shift (fast)
        speed = CAMERA_SPEED * 2
    end
    
    -- Calculate forward/backward movement
    local forwardX = math.sin(-rotZ * math.pi / 180) * speed
    local forwardY = math.cos(-rotZ * math.pi / 180) * speed
    local upDown = math.tan(rotX * math.pi / 180) * speed
    
    -- Calculate strafe movement
    local strafeX = math.sin(math.floor(rotZ + 90.0) % 360 * -1.0 * math.pi / 180) * speed
    local strafeY = math.cos(math.floor(rotZ + 90.0) % 360 * -1.0 * math.pi / 180) * speed
    
    -- W - Forward
    if IsControlPressed(0, 32) then
        camX = camX + forwardX
        camY = camY + forwardY
    end
    
    -- S - Backward
    if IsControlPressed(0, 33) then
        camX = camX - forwardX
        camY = camY - forwardY
    end
    
    -- D - Strafe Right
    if IsControlPressed(0, 35) then
        camX = camX - strafeX
        camY = camY - strafeY
    end
    
    -- A - Strafe Left
    if IsControlPressed(0, 34) then
        camX = camX + strafeX
        camY = camY + strafeY
    end
    
    -- E - Up
    if IsControlPressed(0, 46) then
        camZ = camZ + speed
    end
    
    -- Q - Down
    if IsControlPressed(0, 52) then
        camZ = camZ - speed
    end
    
    -- Check distance from player
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(
        vector3(camX, camY, camZ) - pedCoords,
        true
    )
    
    if distance <= MAX_CAMERA_DISTANCE then
        SetCamCoord(HousingCreator.camera, camX, camY, camZ)
    end
end

function rotateCamInputs()
    local newRotX = nil
    local mouseX = GetControlNormal(0, 220)
    local mouseY = GetControlNormal(0, 221)
    local rotation = GetCamRot(HousingCreator.camera, 2)
    
    local rotY = mouseY * 5
    local rotZ = rotation.z + (mouseX * -10)
    local rotX = rotation.x - rotY
    
    -- Clamp vertical rotation
    if rotX > -85.0 and rotX < 45.0 then
        newRotX = rotX
    end
    
    if newRotX and rotZ then
        SetCamRot(
            HousingCreator.camera,
            vector3(newRotX, rotation.y, rotZ),
            2
        )
    end
end

function rotateCamInputs()
    if HousingCreator.camera then
        local rightAxisX = GetDisabledControlNormal(0, 220)
        local rightAxisY = GetDisabledControlNormal(0, 221)
        
        if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
            local rotation = GetCamRot(HousingCreator.camera, 2)
            local newZ = rotation.z + rightAxisX * -5.0
            local newX = math.max(math.min(rotation.x + rightAxisY * -5.0, 89.0), -89.0)
            SetCamRot(HousingCreator.camera, newX, rotation.y, newZ, 2)
        end
    end
end

function moveCamInputs()
    if HousingCreator.camera then
        local coords = GetCamCoord(HousingCreator.camera)
        local rotation = GetCamRot(HousingCreator.camera, 2)
        local direction = RotationToDirection(rotation)
        local speed = 0.5
        
        -- Increase speed with shift
        if IsControlPressed(0, 21) then
            speed = 2.0
        end
        
        -- Convert direction table to vector3
        local dirVector = vector3(direction.x, direction.y, direction.z)
        
        -- Forward/Backward
        if IsControlPressed(0, 32) then -- W
            coords = coords + dirVector * speed
        elseif IsControlPressed(0, 33) then -- S
            coords = coords - dirVector * speed
        end
        
        -- Left/Right
        if IsControlPressed(0, 34) then -- A
            local right = vector3(dirVector.y, -dirVector.x, 0)
            coords = coords - right * speed
        elseif IsControlPressed(0, 35) then -- D
            local right = vector3(dirVector.y, -dirVector.x, 0)
            coords = coords + right * speed
        end
        
        -- Up/Down (Fixed: Q goes up, E goes down)
        if IsControlPressed(0, 52) then -- Q
            coords = coords + vector3(0, 0, speed)
        elseif IsControlPressed(0, 46) then -- E
            coords = coords - vector3(0, 0, speed)
        end
        
        SetCamCoord(HousingCreator.camera, coords.x, coords.y, coords.z)
    end
end

function DisabledControls()
    if HousingCreator.camera then
        -- Disable all controls when camera is active
        DisableAllControlActions(0)
        
        -- Enable specific movement controls
        EnableControlAction(0, 60, true)  -- Left Alt
        EnableControlAction(0, 21, true)  -- Left Shift
        EnableControlAction(0, 32, true)  -- W
        EnableControlAction(0, 33, true)  -- S
        EnableControlAction(0, 34, true)  -- A
        EnableControlAction(0, 35, true)  -- D
        EnableControlAction(0, 46, true)  -- E
        EnableControlAction(0, 52, true)  -- Q
        EnableControlAction(0, 322, true) -- ESC
        EnableControlAction(0, 220, true) -- Mouse X
        EnableControlAction(0, 221, true) -- Mouse Y
    else
        -- Disable weapon controls when not in camera mode
        DisableControlAction(0, 24, true)  -- Attack
        DisableControlAction(0, 25, true)  -- Aim
        DisableControlAction(0, 140, true) -- Melee Attack Light
        DisableControlAction(0, 141, true) -- Melee Attack Heavy
        DisableControlAction(0, 142, true) -- Melee Attack Alternate
        
        -- Enable camera look controls for placement modes
        EnableControlAction(0, 1, true)   -- Camera Look LR
        EnableControlAction(0, 2, true)   -- Camera Look UD
        EnableControlAction(0, 220, true) -- Mouse X
        EnableControlAction(0, 221, true) -- Mouse Y
    end
    
    -- Always enable these controls
    EnableControlAction(0, 55, true) -- Inventory/Chat
    EnableControlAction(0, Config.HousingCreatorControls.LEFT_CTRL.controlIndex, true)
    EnableControlAction(0, Config.HousingCreatorControls.SELECT.controlIndex, true)
    EnableControlAction(0, Config.HousingCreatorControls.BACK.controlIndex, true)
    EnableControlAction(0, Config.HousingCreatorControls.SCROLL_DOWN.controlIndex, true)
    EnableControlAction(0, Config.HousingCreatorControls.SCROLL_UP.controlIndex, true)
    EnableControlAction(0, Config.HousingCreatorControls.ENTER.controlIndex, true)
    EnableControlAction(0, Config.HousingCreatorControls.CANCEL.controlIndex, true)
end

-- ============================================
-- RAYCAST & HELPER FUNCTIONS
-- ============================================

function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    
    return direction
end

function RayCastGamePlayCamera(camera, distance)
    local ped = PlayerPedId()
    
    local rotation = camera and GetCamRot(camera, 2) or GetGameplayCamRot()
    local coords = camera and GetCamCoord(camera) or GetGameplayCamCoord()
    
    local direction = RotationToDirection(rotation)
    
    local destination = {
        x = coords.x + direction.x * distance,
        y = coords.y + direction.y * distance,
        z = coords.z + direction.z * distance
    }
    
    local rayHandle = StartShapeTestRay(
        coords.x, coords.y, coords.z,
        destination.x, destination.y, destination.z,
        -1, ped, 0
    )
    
    local _, hit, hitCoords, _, entityHit = GetShapeTestResult(rayHandle)
    
    return hit, hitCoords, entityHit
end

function startRaycast(camera)
    local hit, coords, entity = RayCastGamePlayCamera(camera, 1000.0)
    
    if hit then
        -- Handle raycast hit based on current mode
        if isPolyzone or isInteriorZone then
            -- Add point to zone on click
            if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                local zone = isInteriorZone and houseConfiguration.interiorZone or houseConfiguration.zone
                table.insert(zone.points, { x = coords.x, y = coords.y })
            end
            
        elseif isEnterPoint then
            -- Save enter point with mouse click instead of Enter
            if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                houseConfiguration.enterCoords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z
                }
                isEnterPoint = false
                
                -- Reopen menu and update UI with coordinates
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                
                -- Send the enter point coordinates to UI
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = {
                        type = "update-input-value",
                        inputName = "enter_point",
                        housingType = houseConfiguration.type or "mlo",
                        value = json.encode(houseConfiguration.enterCoords)
                    }
                })
                
                -- Show the menu
                Citizen.Wait(100)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
        elseif isMenuPoint then
            -- Save menu point with mouse click
            if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                local ped = PlayerPedId()
                local heading = GetEntityHeading(ped)
                
                houseConfiguration.menu = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = heading
                }
                isMenuPoint = false
                
                -- Reopen menu and update UI with coordinates
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                
                -- Send the menu point coordinates to UI
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = {
                        type = "update-input-value",
                        inputName = "menu_point",
                        housingType = houseConfiguration.type or "mlo",
                        value = json.encode(houseConfiguration.menu)
                    }
                })
                
                -- Show the menu
                Citizen.Wait(100)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
        elseif isGaragePoint then
            -- Handle garage point placement
            if houseConfiguration.__garageVehicleObj then
                -- Get ground level at raycast position with better detection
                local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 50.0, false)
                
                -- If ground not found, try from current position
                if not found then
                    found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)
                end
                
                local placeZ = found and (groundZ + 0.1) or coords.z  -- Add small offset to prevent clipping
                
                -- Temporarily unfreeze to move, then refreeze
                FreezeEntityPosition(houseConfiguration.__garageVehicleObj, false)
                SetEntityCoords(houseConfiguration.__garageVehicleObj, coords.x, coords.y, placeZ, false, false, false, false)
                FreezeEntityPosition(houseConfiguration.__garageVehicleObj, true)
                
                -- Stop any residual movement
                SetEntityVelocity(houseConfiguration.__garageVehicleObj, 0.0, 0.0, 0.0)
                SetEntityAngularVelocity(houseConfiguration.__garageVehicleObj, 0.0, 0.0, 0.0)
                
                -- Rotation controls with scroll wheel
                if IsControlPressed(0, Config.HousingCreatorControls.LEFT_CTRL.controlIndex) then
                    -- Fine rotation with CTRL held
                    if IsControlJustPressed(0, Config.HousingCreatorControls.SCROLL_UP.controlIndex) then
                        local heading = GetEntityHeading(houseConfiguration.__garageVehicleObj)
                        SetEntityHeading(houseConfiguration.__garageVehicleObj, (heading + 1.0) % 360)
                    elseif IsControlJustPressed(0, Config.HousingCreatorControls.SCROLL_DOWN.controlIndex) then
                        local heading = GetEntityHeading(houseConfiguration.__garageVehicleObj)
                        SetEntityHeading(houseConfiguration.__garageVehicleObj, (heading - 1.0) % 360)
                    end
                else
                    -- Normal rotation without CTRL
                    if IsControlJustPressed(0, Config.HousingCreatorControls.SCROLL_UP.controlIndex) then
                        local heading = GetEntityHeading(houseConfiguration.__garageVehicleObj)
                        SetEntityHeading(houseConfiguration.__garageVehicleObj, (heading + 5.0) % 360)
                    elseif IsControlJustPressed(0, Config.HousingCreatorControls.SCROLL_DOWN.controlIndex) then
                        local heading = GetEntityHeading(houseConfiguration.__garageVehicleObj)
                        SetEntityHeading(houseConfiguration.__garageVehicleObj, (heading - 5.0) % 360)
                    end
                end
                
                -- Save with mouse click
                if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                    local vehCoords = GetEntityCoords(houseConfiguration.__garageVehicleObj)
                    local vehHeading = GetEntityHeading(houseConfiguration.__garageVehicleObj)
                    
                    houseConfiguration.garageCoords = {
                        x = vehCoords.x,
                        y = vehCoords.y,
                        z = vehCoords.z,
                        w = vehHeading
                    }
                    
                    isGaragePoint = false
                    
                    -- Delete preview vehicle
                    DeleteVehicle(houseConfiguration.__garageVehicleObj)
                    houseConfiguration.__garageVehicleObj = nil
                    
                    -- Reopen menu and update UI with coordinates
                    Citizen.Wait(500)
                    SetNuiFocus(true, true)
                    
                    -- Send the garage coordinates to UI
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = {
                            type = "update-input-value",
                            inputName = "garage_point",
                            housingType = houseConfiguration.type or "mlo",
                            value = json.encode(houseConfiguration.garageCoords)
                        }
                    })
                    
                    -- Show the menu
                    Citizen.Wait(100)
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                end
                
                -- Cancel with backspace
                if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                    isGaragePoint = false                    
                    -- Delete preview vehicle
                    DeleteVehicle(houseConfiguration.__garageVehicleObj)
                    houseConfiguration.__garageVehicleObj = nil
                    
                    -- Reopen menu
                    Citizen.Wait(500)
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                end
            end
            
        elseif isDeliveryPoint then
            -- Handle delivery point placement
            if houseConfiguration.__deliveryObj then
                -- Move delivery box to raycast position
                SetEntityCoords(houseConfiguration.__deliveryObj, coords.x, coords.y, coords.z, false, false, false, false)
                
                -- Rotation controls with scroll wheel
                if IsControlPressed(0, Config.HousingCreatorControls.LEFT_CTRL.controlIndex) then
                    -- Fine rotation with CTRL held
                    if IsControlJustPressed(0, Config.HousingCreatorControls.SCROLL_UP.controlIndex) then
                        local heading = GetEntityHeading(houseConfiguration.__deliveryObj)
                        SetEntityHeading(houseConfiguration.__deliveryObj, (heading + 1.0) % 360)
                    elseif IsControlJustPressed(0, Config.HousingCreatorControls.SCROLL_DOWN.controlIndex) then
                        local heading = GetEntityHeading(houseConfiguration.__deliveryObj)
                        SetEntityHeading(houseConfiguration.__deliveryObj, (heading - 1.0) % 360)
                    end
                else
                    -- Normal rotation without CTRL
                    if IsControlJustPressed(0, Config.HousingCreatorControls.SCROLL_UP.controlIndex) then
                        local heading = GetEntityHeading(houseConfiguration.__deliveryObj)
                        SetEntityHeading(houseConfiguration.__deliveryObj, (heading + 5.0) % 360)
                    elseif IsControlJustPressed(0, Config.HousingCreatorControls.SCROLL_DOWN.controlIndex) then
                        local heading = GetEntityHeading(houseConfiguration.__deliveryObj)
                        SetEntityHeading(houseConfiguration.__deliveryObj, (heading - 5.0) % 360)
                    end
                end
                
                -- Save with mouse click
                if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                    local objCoords = GetEntityCoords(houseConfiguration.__deliveryObj)
                    local objHeading = GetEntityHeading(houseConfiguration.__deliveryObj)
                    
                    houseConfiguration.deliveryPoint = {
                        x = objCoords.x,
                        y = objCoords.y,
                        z = objCoords.z,
                        w = objHeading
                    }
                    
                    isDeliveryPoint = false
                    
                    -- Delete preview object
                    DeleteObject(houseConfiguration.__deliveryObj)
                    houseConfiguration.__deliveryObj = nil
                    
                    -- Exit shell/IPL if inside
                    if CurrentShell then
                        DeleteObject(CurrentShell)
                        CurrentShell = false
                    end
                    CurrentIPL = nil
                    
                    if houseConfiguration.shell or houseConfiguration.ipl then
                        if houseConfiguration.previousCoords then
                            SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
                        end
                    end
                    
                    -- Reopen menu and update UI with coordinates
                    Citizen.Wait(500)
                    SetNuiFocus(true, true)
                    
                    -- Send the delivery coordinates to UI
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = {
                            type = "update-input-value",
                            inputName = "delivery_coordinates",
                            housingType = houseConfiguration.type or "mlo",
                            value = json.encode(houseConfiguration.deliveryPoint)
                        }
                    })
                    
                    -- Show the menu
                    Citizen.Wait(100)
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                end
                
                -- Cancel with backspace
                if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                    isDeliveryPoint = false                    
                    -- Delete preview object
                    DeleteObject(houseConfiguration.__deliveryObj)
                    houseConfiguration.__deliveryObj = nil
                    
                    -- Exit shell/IPL if inside
                    if CurrentShell then
                        DeleteObject(CurrentShell)
                        CurrentShell = false
                    end
                    CurrentIPL = nil
                    
                    if houseConfiguration.shell or houseConfiguration.ipl then
                        if houseConfiguration.previousCoords then
                            SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
                        end
                    end
                    
                    -- Reopen menu
                    Citizen.Wait(500)
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                end
            end
            
        elseif isParkingSpaces then
            -- Handle parking space placement
            if selectedParkingIndex and houseConfiguration.parkingSpaces[selectedParkingIndex] then
                local vehicle = houseConfiguration.parkingSpaces[selectedParkingIndex].vehicle
                
                if vehicle and DoesEntityExist(vehicle) then
                    SetEntityCoords(vehicle, coords.x, coords.y, coords.z)
                    
                    if IsControlPressed(0, Config.HousingCreatorControls.LEFT_CTRL.controlIndex) then
                        local heading = GetEntityHeading(vehicle)
                        SetEntityHeading(vehicle, heading + 1.0)
                    end
                    
                    if IsControlJustPressed(0, Config.HousingCreatorControls.ENTER.controlIndex) then
                        local vehCoords = GetEntityCoords(vehicle)
                        local vehHeading = GetEntityHeading(vehicle)
                        
                        houseConfiguration.parkingSpaces[selectedParkingIndex].coords = {
                            x = vehCoords.x,
                            y = vehCoords.y,
                            z = vehCoords.z,
                            w = vehHeading
                        }
                        
                        -- Create next parking space
                        selectedParkingIndex = #houseConfiguration.parkingSpaces + 1
                        houseConfiguration.parkingSpaces[selectedParkingIndex] = {
                            coords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 }
                        }
                        
                        library.RequestEntity("baller3")
                        houseConfiguration.parkingSpaces[selectedParkingIndex].vehicle = CreateVehicle(
                            GetHashKey("baller3"),
                            coords.x, coords.y, coords.z, 0.0,
                            false, true
                        )
                        FreezeEntityPosition(houseConfiguration.parkingSpaces[selectedParkingIndex].vehicle, true)
                    end
                end
            end
            
        elseif isWardrobePoint then
            -- Handle wardrobe point placement
            if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                houseConfiguration.wardrobeCoords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z
                }
                
                isWardrobePoint = false
                
                -- If changing position, save to server
                if isWardrobeChange then
                    local propertyId = CurrentProperty or GetCurrentPropertyId()
                    local propertyData = CurrentPropertyData or GetCurrentPropertyData()
                    
                    -- Update local property data with new wardrobe position
                    if propertyData and propertyData.metadata then
                        propertyData.metadata.wardrobe = houseConfiguration.wardrobeCoords
                    end
                    
                    -- Update Properties table directly
                    if Properties[tostring(propertyId)] then
                        if not Properties[tostring(propertyId)].metadata then
                            Properties[tostring(propertyId)].metadata = {}
                        end
                        Properties[tostring(propertyId)].metadata.wardrobe = houseConfiguration.wardrobeCoords
                    end
                    
                    -- Save to server
                    TriggerServerEvent("vms_housing:sv:changeWardrobePosition", propertyId, houseConfiguration.wardrobeCoords)
                    
                    -- Reload interior targets (this automatically removes old ones and creates new ones)
                    Citizen.Wait(500)
                    Property:LoadInteriorInteractable()
                    
                    CL.Notification(TRANSLATE("notify.wardrobe_position_changed") or "Wardrobe position changed", 3000, "success")
                else
                    -- Reopen menu and update UI with coordinates
                    Citizen.Wait(500)
                    SetNuiFocus(true, true)
                    
                    -- Send the wardrobe coordinates to UI
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = {
                            type = "update-input-value",
                            inputName = "wardrobe_point",
                            housingType = houseConfiguration.type or "mlo",
                            value = json.encode(houseConfiguration.wardrobeCoords)
                        }
                    })
                    
                    -- Show the menu
                    Citizen.Wait(100)
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                end
            end
            
            -- Cancel with backspace
            if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                isWardrobePoint = false                
                -- Exit shell/IPL if inside
                if not isWardrobeChange then
                    if CurrentShell then
                        DeleteObject(CurrentShell)
                        CurrentShell = false
                    end
                    CurrentIPL = nil
                    
                    if (houseConfiguration.shell or houseConfiguration.ipl) and houseConfiguration.previousCoords then
                        SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
                    end
                    
                    -- Reopen housing creator menu
                    Citizen.Wait(500)
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                else
                    -- If changing position from manage menu, reopen manage menu
                    Citizen.Wait(500)
                    openManageMenu()
                end
            end
            
        elseif isStoragePoint then
            -- Handle storage point placement
            if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                houseConfiguration.storageCoords = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z
                }
                
                isStoragePoint = false
                
                -- If changing position, save to server
                if isStorageChange then
                    local propertyId = CurrentProperty or GetCurrentPropertyId()
                    local propertyData = CurrentPropertyData or GetCurrentPropertyData()
                    
                    -- Update local property data with new storage position
                    if propertyData and propertyData.metadata then
                        propertyData.metadata.storage = houseConfiguration.storageCoords
                    end
                    
                    -- Update Properties table directly
                    if Properties[tostring(propertyId)] then
                        if not Properties[tostring(propertyId)].metadata then
                            Properties[tostring(propertyId)].metadata = {}
                        end
                        Properties[tostring(propertyId)].metadata.storage = houseConfiguration.storageCoords
                    end
                    
                    -- Save to server
                    TriggerServerEvent("vms_housing:sv:changeStoragePosition", propertyId, houseConfiguration.storageCoords)
                    
                    -- Reload interior targets (this automatically removes old ones and creates new ones)
                    Citizen.Wait(500)
                    Property:LoadInteriorInteractable()
                    
                    CL.Notification(TRANSLATE("notify.storage_position_changed") or "Storage position changed", 3000, "success")
                else
                    -- Reopen menu and update UI with coordinates
                    Citizen.Wait(500)
                    SetNuiFocus(true, true)
                    
                    -- Send the storage coordinates to UI
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = {
                            type = "update-input-value",
                            inputName = "storage_point",
                            housingType = houseConfiguration.type or "mlo",
                            value = json.encode(houseConfiguration.storageCoords)
                        }
                    })
                    
                    -- Show the menu
                    Citizen.Wait(100)
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                end
            end
            
            -- Cancel with backspace
            if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                isStoragePoint = false                
                -- Exit shell/IPL if inside
                if not isStorageChange then
                    if CurrentShell then
                        DeleteObject(CurrentShell)
                        CurrentShell = false
                    end
                    CurrentIPL = nil
                    
                    if (houseConfiguration.shell or houseConfiguration.ipl) and houseConfiguration.previousCoords then
                        SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
                    end
                    
                    -- Reopen housing creator menu
                    Citizen.Wait(500)
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "HousingCreator",
                        actionName = "Update",
                        data = { type = "show-menu" }
                    })
                else
                    -- If changing position from manage menu, reopen manage menu
                    Citizen.Wait(500)
                    openManageMenu()
                end
            end
            
        elseif isCreatingDoor then
            -- Highlight door entity if it's a door object
            if entity and entity > 0 and GetEntityType(entity) == 3 then
                -- Check if entity changed
                if lastHighlightedEntity ~= entity then
                    -- Remove outline from previous entity
                    if lastHighlightedEntity > 0 then
                        SetEntityDrawOutline(lastHighlightedEntity, false)
                    end
                    -- Add outline to new entity
                    SetEntityDrawOutline(entity, true)
                    lastHighlightedEntity = entity
                end
            else
                -- No valid entity, remove outline from last entity
                if lastHighlightedEntity > 0 then
                    SetEntityDrawOutline(lastHighlightedEntity, false)
                    lastHighlightedEntity = 0
                end
            end
            
            -- Handle door placement
            if IsControlJustPressed(0, Config.HousingCreatorControls.SELECT.controlIndex) then
                local ped = PlayerPedId()
                local heading = GetEntityHeading(ped)
                
                -- Create door data
                local doorData = {
                    coords = {
                        x = coords.x,
                        y = coords.y,
                        z = coords.z
                    },
                    heading = heading,
                    locked = true,
                    distance = houseConfiguration.doorsDistance or 1.5
                }
                
                -- Add door type
                if isDoubleDoor then
                    doorData.double = true
                elseif isSlideGateDoor then
                    doorData.gate = true
                end
                
                -- Add door to configuration
                if not houseConfiguration.doors then
                    houseConfiguration.doors = {}
                end
                table.insert(houseConfiguration.doors, doorData)
                
                -- Remove outline before exiting
                if lastHighlightedEntity > 0 then
                    SetEntityDrawOutline(lastHighlightedEntity, false)
                    lastHighlightedEntity = 0
                end
                
                isCreatingDoor = false
                isDoubleDoor = false
                isSlideGateDoor = false
                
                
                -- Reopen menu and update doors list
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                
                -- Send updated doors list to UI
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = {
                        type = "update-doors-list",
                        value = houseConfiguration.doors
                    }
                })
                
                -- Show the menu
                Citizen.Wait(100)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
            
            -- Cancel with backspace
            if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
                -- Remove outline before exiting
                if lastHighlightedEntity > 0 then
                    SetEntityDrawOutline(lastHighlightedEntity, false)
                    lastHighlightedEntity = 0
                end
                
                isCreatingDoor = false
                isDoubleDoor = false
                isSlideGateDoor = false                
                -- Reopen menu
                Citizen.Wait(500)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "HousingCreator",
                    actionName = "Update",
                    data = { type = "show-menu" }
                })
            end
        end
    end
    
    -- Draw marker at raycast hit location
    if hit and coords then
        DrawMarker(
            28, coords.x, coords.y, coords.z,
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            0.2, 0.2, 0.2,
            255, 0, 0, 150,
            false, false, 2, false, nil, nil, false
        )
    end
end

function keyControls(coords)
    -- Handle keyboard controls for point placement
    if IsControlJustPressed(0, Config.HousingCreatorControls.ENTER.controlIndex) then
        -- Confirm placement
        -- Logic handled in startRaycast for specific modes
    end
    
    if IsControlJustPressed(0, Config.HousingCreatorControls.CANCEL.controlIndex) then
        -- Cancel current action
        isPolyzone = false
        isInteriorZone = false
        isEnterPoint = false
        isExitPoint = false
        isEmergencyExitOutside = false
        isEmergencyExitInside = false
        isMenuPoint = false
        isGaragePoint = false
        isEnterGaragePoint = false
        isParkingSpaces = false
        isDeliveryPoint = false
        isWardrobePoint = false
        isStoragePoint = false
        isCreatingDoor = false
    end
end

function _drawWall(point1, point2, minZ, maxZ, r, g, b)
    -- Draw wall between two points with better visibility
    -- Bottom edge
    DrawLine(point1.x, point1.y, minZ, point2.x, point2.y, minZ, r, g, b, 255)
    -- Top edge
    DrawLine(point1.x, point1.y, maxZ, point2.x, point2.y, maxZ, r, g, b, 255)
    -- Vertical edges at corners (already drawn by main loop)
    
    -- Draw additional lines for better wall visibility
    local steps = 5
    for i = 0, steps do
        local z = minZ + (maxZ - minZ) * (i / steps)
        DrawLine(point1.x, point1.y, z, point2.x, point2.y, z, r, g, b, 150)
    end
end

function calculatePolygonArea(points)
    if #points < 3 then return 0 end
    
    local area = 0
    local j = #points
    
    for i = 1, #points do
        area = area + (points[j].x + points[i].x) * (points[j].y - points[i].y)
        j = i
    end
    
    return math.abs(area / 2)
end

function getZoneCenter(points, minZ, maxZ)
    if #points == 0 then
        return { x = 0.0, y = 0.0, z = 0.0 }
    end
    
    local sumX, sumY = 0, 0
    
    for _, point in ipairs(points) do
        sumX = sumX + point.x
        sumY = sumY + point.y
    end
    
    return {
        x = sumX / #points,
        y = sumY / #points,
        z = (minZ + maxZ) / 2
    }
end

-- ============================================
-- WARDROBE & STORAGE POINT CREATION
-- ============================================

function HousingCreator.CreateWardrobePoint(self, isChange, theme)
    if isChange then
        isWardrobeChange = true
        
        -- Load current property's wardrobe position from Properties table first
        local propertyId = CurrentProperty or GetCurrentPropertyId()
        if propertyId and Properties[tostring(propertyId)] and Properties[tostring(propertyId)].metadata and Properties[tostring(propertyId)].metadata.wardrobe then
            houseConfiguration.wardrobeCoords = Properties[tostring(propertyId)].metadata.wardrobe
        else
            -- Fallback to CurrentPropertyData
            local propertyData = CurrentPropertyData or GetCurrentPropertyData()
            if propertyData and propertyData.metadata and propertyData.metadata.wardrobe then
                houseConfiguration.wardrobeCoords = propertyData.metadata.wardrobe
            end
        end
    end
    
    isWardrobePoint = true
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:wardrobe",
        controlsName = "HousingCreator:default"
    })
    
    Citizen.CreateThread(function()
        if not isWardrobeChange then
            if houseConfiguration.shell then
                HousingCreator:EnterShell(houseConfiguration.shell)
            elseif houseConfiguration.ipl then
                HousingCreator:EnterIPL(houseConfiguration.ipl, nil, theme)
            end
        end
        
        while isWardrobePoint do
            startRaycast()
            DisabledControls()
            
            -- Draw interior zone if MLO
            if not houseConfiguration.shell and not houseConfiguration.ipl then
                if #houseConfiguration.interiorZone.points >= 1 then
                    for i = 1, #houseConfiguration.interiorZone.points do
                        DrawLine(
                            houseConfiguration.interiorZone.points[i].x,
                            houseConfiguration.interiorZone.points[i].y,
                            houseConfiguration.interiorZone.minZ,
                            houseConfiguration.interiorZone.points[i].x,
                            houseConfiguration.interiorZone.points[i].y,
                            houseConfiguration.interiorZone.maxZ,
                            178, 128, 255, 230
                        )
                        
                        if i < #houseConfiguration.interiorZone.points then
                            _drawWall(
                                houseConfiguration.interiorZone.points[i],
                                houseConfiguration.interiorZone.points[i + 1],
                                houseConfiguration.interiorZone.minZ,
                                houseConfiguration.interiorZone.maxZ,
                                114, 49, 212
                            )
                        end
                        
                        if i == #houseConfiguration.interiorZone.points then
                            _drawWall(
                                houseConfiguration.interiorZone.points[i],
                                houseConfiguration.interiorZone.points[1],
                                houseConfiguration.interiorZone.minZ,
                                houseConfiguration.interiorZone.maxZ,
                                114, 49, 212
                            )
                        end
                    end
                end
            end
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
        
        if not isWardrobeChange then
            if CurrentShell then
                DeleteObject(CurrentShell)
                CurrentShell = false
            end
            CurrentIPL = nil
            
            if (houseConfiguration.shell or houseConfiguration.ipl) and houseConfiguration.previousCoords then
                SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
            end
        end
        
        isWardrobeChange = false
    end)
end

function HousingCreator.CreateStoragePoint(self, isChange, theme)
    if isChange then
        isStorageChange = true
        
        -- Load current property's storage position from Properties table first
        local propertyId = CurrentProperty or GetCurrentPropertyId()
        if propertyId and Properties[tostring(propertyId)] and Properties[tostring(propertyId)].metadata and Properties[tostring(propertyId)].metadata.storage then
            houseConfiguration.storageCoords = Properties[tostring(propertyId)].metadata.storage
        else
            -- Fallback to CurrentPropertyData
            local propertyData = CurrentPropertyData or GetCurrentPropertyData()
            if propertyData and propertyData.metadata and propertyData.metadata.storage then
                houseConfiguration.storageCoords = propertyData.metadata.storage
            end
        end
    end
    
    isStoragePoint = true
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:storage",
        controlsName = "HousingCreator:default"
    })
    
    Citizen.CreateThread(function()
        if not isStorageChange then
            if houseConfiguration.shell then
                HousingCreator:EnterShell(houseConfiguration.shell)
            elseif houseConfiguration.ipl then
                HousingCreator:EnterIPL(houseConfiguration.ipl, nil, theme)
            end
        end
        
        while isStoragePoint do
            startRaycast()
            DisabledControls()
            
            -- Draw interior zone if MLO
            if not houseConfiguration.shell and not houseConfiguration.ipl then
                if #houseConfiguration.interiorZone.points >= 1 then
                    for i = 1, #houseConfiguration.interiorZone.points do
                        DrawLine(
                            houseConfiguration.interiorZone.points[i].x,
                            houseConfiguration.interiorZone.points[i].y,
                            houseConfiguration.interiorZone.minZ,
                            houseConfiguration.interiorZone.points[i].x,
                            houseConfiguration.interiorZone.points[i].y,
                            houseConfiguration.interiorZone.maxZ,
                            178, 128, 255, 230
                        )
                        
                        if i < #houseConfiguration.interiorZone.points then
                            _drawWall(
                                houseConfiguration.interiorZone.points[i],
                                houseConfiguration.interiorZone.points[i + 1],
                                houseConfiguration.interiorZone.minZ,
                                houseConfiguration.interiorZone.maxZ,
                                114, 49, 212
                            )
                        end
                        
                        if i == #houseConfiguration.interiorZone.points then
                            _drawWall(
                                houseConfiguration.interiorZone.points[i],
                                houseConfiguration.interiorZone.points[1],
                                houseConfiguration.interiorZone.minZ,
                                houseConfiguration.interiorZone.maxZ,
                                114, 49, 212
                            )
                        end
                    end
                end
            end
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
        
        if not isStorageChange then
            if CurrentShell then
                DeleteObject(CurrentShell)
                CurrentShell = false
            end
            CurrentIPL = nil
            
            if (houseConfiguration.shell or houseConfiguration.ipl) and houseConfiguration.previousCoords then
                SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
            end
        end
        
        isStorageChange = false
    end)
end

function HousingCreator.CreateDeliveryPoint(self, isInside, isOutside, theme)
    isDeliveryPoint = true
    
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "creator:delivery",
        controlsName = "HousingCreator:delivery"
    })
    
    Citizen.CreateThread(function()
        if isInside then
            if houseConfiguration.shell then
                HousingCreator:EnterShell(houseConfiguration.shell)
            elseif houseConfiguration.ipl then
                HousingCreator:EnterIPL(houseConfiguration.ipl, nil, theme)
            end
        end
        
        -- Clean up existing delivery object
        if houseConfiguration.__deliveryObj ~= nil then
            if DoesEntityExist(houseConfiguration.__deliveryObj) then
                DeleteObject(houseConfiguration.__deliveryObj)
                SetEntityCollision(houseConfiguration.__deliveryObj, false, true)
                houseConfiguration.__deliveryObj = nil
            end
        end
        
        -- Spawn delivery box preview
        houseConfiguration.__deliveryObj = library.SpawnProp(
            joaat("prop_boxpile_01a"),
            GetEntityCoords(PlayerPedId()),
            false, nil, true
        )
        
        while isDeliveryPoint do
            startRaycast()
            DisabledControls()
            
            -- Draw zone based on mode
            local zone = isInside and houseConfiguration.interiorZone or houseConfiguration.zone
            
            if not houseConfiguration.shell and not houseConfiguration.ipl then
                if #zone.points >= 1 then
                    for i = 1, #zone.points do
                        DrawLine(
                            zone.points[i].x, zone.points[i].y, zone.minZ,
                            zone.points[i].x, zone.points[i].y, zone.maxZ,
                            178, 128, 255, 230
                        )
                        
                        if i < #zone.points then
                            _drawWall(
                                zone.points[i], zone.points[i + 1],
                                zone.minZ, zone.maxZ,
                                114, 49, 212
                            )
                        end
                        
                        if i == #zone.points then
                            _drawWall(
                                zone.points[i], zone.points[1],
                                zone.minZ, zone.maxZ,
                                114, 49, 212
                            )
                        end
                    end
                end
            end
            
            Citizen.Wait(0)
        end
        
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
        
        if isInside then
            if CurrentShell then
                DeleteObject(CurrentShell)
                CurrentShell = false
            end
            
            if houseConfiguration.previousCoords then
                SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
            end
        end
        
        CurrentIPL = nil
        DeleteObject(houseConfiguration.__deliveryObj)
        houseConfiguration.__deliveryObj = nil
    end)
end