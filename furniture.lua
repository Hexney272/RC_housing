-- Furniture placement system
-- Configuration tables for housing creator

-- Ensure Config exists and merge with existing FurnitureControls
Config = Config or {}
Config.FurnitureControls = Config.FurnitureControls or {}

-- Add/override only the controls we need (don't overwrite GIZMO_TRANSLATION and GIZMO_ROTATION)
Config.FurnitureControls.ACCEPT = Config.FurnitureControls.ACCEPT or { controlIndex = 191 }
Config.FurnitureControls.CLOSE = Config.FurnitureControls.CLOSE or { controlIndex = 194 }
Config.FurnitureControls.CHANGE_MODE = Config.FurnitureControls.CHANGE_MODE or { controlIndex = 47 }
Config.FurnitureControls.SNAP_TO_GROUND = Config.FurnitureControls.SNAP_TO_GROUND or { controlIndex = 19 }
Config.FurnitureControls.ENABLE_CURSOR = Config.FurnitureControls.ENABLE_CURSOR or { controlIndex = 25 }
Config.FurnitureControls.UP = Config.FurnitureControls.UP or { controlIndex = 27 }
Config.FurnitureControls.DOWN = Config.FurnitureControls.DOWN or { controlIndex = 173 }
Config.FurnitureControls.ROTATE_LEFT = Config.FurnitureControls.ROTATE_LEFT or { controlIndex = 174 }
Config.FurnitureControls.ROTATE_RIGHT = Config.FurnitureControls.ROTATE_RIGHT or { controlIndex = 175 }
Config.FurnitureControls.SPEED_DOWN = Config.FurnitureControls.SPEED_DOWN or { controlIndex = 21 }

-- Merge FurnitureSettings
Config.FurnitureSettings = Config.FurnitureSettings or {}
Config.FurnitureSettings.HeightSpeed = Config.FurnitureSettings.HeightSpeed or 0.1
Config.FurnitureSettings.HeightSpeedSlow = Config.FurnitureSettings.HeightSpeedSlow or 0.01
Config.FurnitureSettings.RotateSpeed = Config.FurnitureSettings.RotateSpeed or 2.0
Config.FurnitureSettings.RotateSpeedSlow = Config.FurnitureSettings.RotateSpeedSlow or 0.5

-- Global state
furnitureMode = false
local cursorEnabled = false
local creatorCam = nil

-- Camera control functions
local function rotateCamInputs()
    if not creatorCam or cursorEnabled then return end
    
    local mouseX = GetDisabledControlNormal(0, 1) * 8.0
    local mouseY = GetDisabledControlNormal(0, 2) * 8.0
    
    if math.abs(mouseX) > 0.1 or math.abs(mouseY) > 0.1 then
        local camRot = GetCamRot(creatorCam, 2)
        SetCamRot(creatorCam, 
            camRot.x - mouseY,
            camRot.y,
            camRot.z - mouseX,
            2
        )
    end
end

local function moveCamInputs(isGizmo)
    if not creatorCam then return end
    
    local camCoords = GetCamCoord(creatorCam)
    local camRot = GetCamRot(creatorCam, 2)
    local moveSpeed = isGizmo and 0.01 or 0.05
    
    -- Calculate forward and right vectors
    local forward = vector3(
        -math.sin(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
        math.cos(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
        math.sin(math.rad(camRot.x))
    )
    local right = vector3(
        math.cos(math.rad(camRot.z)),
        math.sin(math.rad(camRot.z)),
        0
    )
    
    local newPos = camCoords
    
    -- WASD movement
    if IsControlPressed(0, 32) then -- W
        newPos = newPos + forward * moveSpeed
    end
    if IsControlPressed(0, 33) then -- S
        newPos = newPos - forward * moveSpeed
    end
    if IsControlPressed(0, 34) then -- A
        newPos = newPos - right * moveSpeed
    end
    if IsControlPressed(0, 35) then -- D
        newPos = newPos + right * moveSpeed
    end
    
    -- Q/E for up/down
    if IsControlPressed(0, 44) then -- Q
        newPos = newPos - vector3(0, 0, moveSpeed)
    end
    if IsControlPressed(0, 38) then -- E
        newPos = newPos + vector3(0, 0, moveSpeed)
    end
    
    SetCamCoord(creatorCam, newPos.x, newPos.y, newPos.z)
end

-- Furniture camera functions (local to avoid conflict with HousingCreator)
local function CreateFurnitureCamera(freeze)
    if creatorCam then
        DeleteFurnitureCamera()
    end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local rot = GetEntityRotation(playerPed, 2)
    
    creatorCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(creatorCam, coords.x, coords.y, coords.z + 2.0)
    SetCamRot(creatorCam, -10.0, 0.0, rot.z, 2)
    SetCamActive(creatorCam, true)
    RenderScriptCams(true, true, 500, true, true)
    
    if freeze then
        FreezeEntityPosition(playerPed, true)
    end
end

function DeleteFurnitureCamera()
    if creatorCam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(creatorCam, false)
        creatorCam = nil
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

-- Toggle cursor visibility
local function ToggleCursor(enable)
    if enable ~= nil then
        cursorEnabled = enable
    else
        cursorEnabled = not cursorEnabled
    end
    
    if cursorEnabled then
        SetCursorLocation(0.5, 0.5)
        EnterCursorMode()
    else
        LeaveCursorMode()
    end
end

-- Disable conflicting controls during furniture placement
local function DisabledControls(isGizmoMode)
    -- Only disable look controls in gizmo mode
    if isGizmoMode then
        DisableControlAction(0, 1, true)    -- Look Left/Right
        DisableControlAction(0, 2, true)    -- Look Up/Down
    end
    
    -- Always disable combat controls
    DisableControlAction(0, 24, true)   -- Attack
    DisableControlAction(0, 25, true)   -- Aim
    DisableControlAction(0, 37, true)   -- Weapon Wheel
    DisableControlAction(0, 44, true)   -- Cover
    DisableControlAction(0, 45, true)   -- Reload
    DisableControlAction(0, 47, true)   -- Detonate
    DisableControlAction(0, 58, true)   -- Throw Grenade
    DisableControlAction(0, 140, true)  -- Melee Attack Light
    DisableControlAction(0, 141, true)  -- Melee Attack Heavy
    DisableControlAction(0, 142, true)  -- Melee Attack Alternate
    DisableControlAction(0, 143, true)  -- Melee Block
    DisableControlAction(0, 263, true)  -- Melee Attack 1
    DisableControlAction(0, 264, true)  -- Melee Attack 2
    DisableControlAction(0, 257, true)  -- Attack 2
end

-- Handle camera rotation inputs
local function rotateCamInputs()
    if not cursorEnabled and creatorCam then
        local rightAxisX = GetDisabledControlNormal(0, 220)
        local rightAxisY = GetDisabledControlNormal(0, 221)
        
        if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
            local camRot = GetCamRot(creatorCam, 2)
            local newZ = camRot.z + rightAxisX * -5.0
            local newX = math.max(math.min(camRot.x + rightAxisY * -5.0, 89.0), -89.0)
            SetCamRot(creatorCam, newX, 0.0, newZ, 2)
        end
    end
end

-- Handle camera movement inputs
local function moveCamInputs(allowVertical)
    if not cursorEnabled and creatorCam then
        local camCoords = GetCamCoord(creatorCam)
        local camRot = GetCamRot(creatorCam, 2)
        
        local moveSpeed = 0.1
        local fastSpeed = 0.5
        
        -- Check for shift key for fast movement
        if IsDisabledControlPressed(0, 21) then
            moveSpeed = fastSpeed
        end
        
        -- Forward/Backward (W/S keys)
        local moveForward = 0.0
        if IsDisabledControlPressed(0, 32) then -- W
            moveForward = moveSpeed
        elseif IsDisabledControlPressed(0, 33) then -- S
            moveForward = -moveSpeed
        end
        
        -- Left/Right (A/D keys)
        local moveSide = 0.0
        if IsDisabledControlPressed(0, 34) then -- A
            moveSide = -moveSpeed
        elseif IsDisabledControlPressed(0, 35) then -- D
            moveSide = moveSpeed
        end
        
        -- Up/Down (Q/E keys) if allowed
        local moveUp = 0.0
        if allowVertical then
            if IsDisabledControlPressed(0, 44) then -- Q
                moveUp = -moveSpeed
            elseif IsDisabledControlPressed(0, 38) then -- E
                moveUp = moveSpeed
            end
        end
        
        if moveForward ~= 0.0 or moveSide ~= 0.0 or moveUp ~= 0.0 then
            local heading = math.rad(camRot.z)
            local pitch = math.rad(camRot.x)
            
            local newX = camCoords.x + (math.sin(-heading) * moveForward) + (math.sin(-heading + 90.0) * moveSide)
            local newY = camCoords.y + (math.cos(-heading) * moveForward) + (math.cos(-heading + 90.0) * moveSide)
            local newZ = camCoords.z + moveUp + (math.sin(pitch) * moveForward)
            
            SetCamCoord(creatorCam, newX, newY, newZ)
        end
    end
end

-- Main furniture placement/management function
function manageFurniture(isEditing, furnitureModel, furnitureId)
    local propertyId = CurrentProperty or GetCurrentPropertyId()
    local propertyData = CurrentPropertyData or GetCurrentPropertyData()
    
    local heightOffset = 0.0
    local isInside = false
    
    -- Determine if player is inside
    if propertyData.type == "mlo" then
        isInside = IsInsideMLO()
    else
        if CurrentProperty then
            isInside = true
        end
    end
    
    -- Send UI message
    SendNUIMessage({
        action = "Property",
        actionName = "FurniturePlace"
    })
    SetNuiFocus(false, false)
    
    -- Clean up existing furniture object
    if Property.EditingFurnitureObj then
        DeleteEntity(Property.EditingFurnitureObj)
        Property.EditingFurnitureObj = nil
        Property.EditingFurnitureData = {}
    end
    
    -- Load furniture object
    if isEditing then
        -- Find existing furniture object
        for _, furniture in pairs(Property.LoadedFurnitures) do
            if furniture.furnitureId == furnitureId then
                Property.EditingFurnitureObj = furniture.entity
            end
        end
    elseif furnitureModel then
        -- Spawn new furniture object
        local playerPos = GetEntityCoords(PlayerPedId())
        local playerHeading = GetEntityHeading(PlayerPedId())
        
        -- Calculate spawn position in front of player at player height
        local forwardX = playerPos.x + (2.0 * math.sin(math.rad(-playerHeading)))
        local forwardY = playerPos.y + (2.0 * math.cos(math.rad(-playerHeading)))
        -- Use player Z coordinate so it spawns at player height (works in shells)
        local spawnPos = vector3(forwardX, forwardY, playerPos.z)
        
        Property.EditingFurnitureObj = library.SpawnProp(
            furnitureModel,
            spawnPos,
            false,
            nil,
            true
        )
        
        -- Wait for object to load
        local timeout = GetGameTimer() + 5000
        local timedOut = false
        
        while not DoesEntityExist(Property.EditingFurnitureObj) do
            if GetGameTimer() > timeout then
                timedOut = true
                break
            end
            Citizen.Wait(5)
        end
        
        if timedOut then
            CL.Notification(TRANSLATE("notify.furniture:unable_to_load") or "Unable to load furniture object", 3000, "error")
            return
        end
    end
    
    -- Configure furniture object properties
    if DoesEntityExist(Property.EditingFurnitureObj) then
        -- Only place on ground for new furniture, not when editing
        if not isEditing then
            -- Don't snap to ground on spawn - keep at player height
            -- Player can use LEFT ALT to snap to ground if needed
        end
        
        -- Move camera to look at the object
        local objPos = GetEntityCoords(Property.EditingFurnitureObj)
        local camPos = GetGameplayCamCoord()
        local camRot = GetGameplayCamRot(2)
        
        -- Point camera at object
        TaskLookAtCoord(PlayerPedId(), objPos.x, objPos.y, objPos.z, 1000, 0, 2)
    end
    SetEntityAsMissionEntity(Property.EditingFurnitureObj, true, true)
    SetEntityCollision(Property.EditingFurnitureObj, false, false)
    SetEntityNoCollisionEntity(PlayerPedId(), Property.EditingFurnitureObj, false)
    SetEntityNoCollisionEntity(Property.EditingFurnitureObj, PlayerPedId(), false)
    FreezeEntityPosition(Property.EditingFurnitureObj, true)
    SetEntityDynamic(Property.EditingFurnitureObj, false)
    SetEntityProofs(Property.EditingFurnitureObj, true, true, true, true, true, true, true, true)
    SetEntityCanBeDamaged(Property.EditingFurnitureObj, false)
    
    -- Setup placement mode
    local lastModeChange = 0
    
    -- Start in walk mode for editing, gizmo for new placement
    if isEditing then
        furnitureMode = "normal"
        -- Don't freeze player when editing
        FreezeEntityPosition(PlayerPedId(), false)
    else
        furnitureMode = "gizmo"
        CreateFurnitureCamera(true)
        ToggleCursor()
    end
    
    -- Update controls UI
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = furnitureMode == "gizmo" and "furniture:gizmo" or "furniture:walkmode",
        controlsName = furnitureMode == "gizmo" and "Furniture:gizmo" or "Furniture:walkmode"
    })
    
    -- Main placement loop
    while Property.EditingFurnitureObj do
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        
        -- Hide HUD elements
        HudForceWeaponWheel(false)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        
        -- Get furniture object properties
        local furniturePos = GetEntityCoords(Property.EditingFurnitureObj)
        local furnitureHeading = GetEntityHeading(Property.EditingFurnitureObj)
        local furnitureRot = GetEntityRotation(Property.EditingFurnitureObj, 2)
        
        -- Draw outline
        SetEntityDrawOutline(Property.EditingFurnitureObj, true)
        SetEntityDrawOutlineColor(159, 15, 255, 200)
        SetEntityDrawOutlineShader(1)
        
        -- Pass current mode to control disabling
        DisabledControls(furnitureMode == "gizmo")
        Wait(0)
        
        -- Handle gizmo mode
        if furnitureMode == "gizmo" then
            -- Keep player frozen in gizmo mode
            local playerPed = PlayerPedId()
            FreezeEntityPosition(playerPed, true)
            DisableAllControlActions(0)
            
            -- Enable only camera controls and mouse for gizmo
            EnableControlAction(0, 1, true)    -- Look Left/Right
            EnableControlAction(0, 2, true)    -- Look Up/Down
            EnableControlAction(0, 32, true)   -- W
            EnableControlAction(0, 33, true)   -- S
            EnableControlAction(0, 34, true)   -- A
            EnableControlAction(0, 35, true)   -- D
            EnableControlAction(0, 44, true)   -- Q
            EnableControlAction(0, 38, true)   -- E
            EnableControlAction(0, 24, true)   -- Left Mouse Button
            EnableControlAction(0, 25, true)   -- Right Mouse Button
            
            -- Use native gizmo (like original VMS Housing)
            if DoesEntityExist(Property.EditingFurnitureObj) then
                local entityMatrix = makeEntityMatrix(Property.EditingFurnitureObj)
                
                -- Call native gizmo (0xEB2EDCA2)
                local gizmoResult = Citizen.InvokeNative(
                    0xEB2EDCA2,
                    entityMatrix:Buffer(),
                    "Editor1",
                    Citizen.ReturnResultAnyway()
                )
                
                -- If gizmo was manipulated, apply the matrix back to entity
                if gizmoResult then
                    applyEntityMatrix(Property.EditingFurnitureObj, entityMatrix)
                end
            end
            
            -- Enable cursor toggle
            EnableControlAction(0, Config.FurnitureControls.ENABLE_CURSOR.controlIndex, true)
            if IsControlJustPressed(0, Config.FurnitureControls.ENABLE_CURSOR.controlIndex) then
                ToggleCursor()
            end
            
            -- Enable other necessary controls for gizmo mode
            EnableControlAction(0, Config.FurnitureControls.ACCEPT.controlIndex, true) -- Enter
            EnableControlAction(0, Config.FurnitureControls.CLOSE.controlIndex, true) -- Backspace
            EnableControlAction(0, Config.FurnitureControls.CHANGE_MODE.controlIndex, true) -- G key
            
            rotateCamInputs()
            moveCamInputs(true)
        else
            -- Walk mode - player can move freely
            FreezeEntityPosition(PlayerPedId(), false)
            
            -- Get player position for raycast line
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            -- Perform raycast from camera
            local hit, coords = RayCastGamePlayCamera(nil, 150.0)
            
            if hit then
                -- Draw raycast line from player to target position
                DrawLine(
                    playerCoords.x, playerCoords.y, playerCoords.z + 0.5,
                    coords.x, coords.y, coords.z,
                    159, 15, 255, 100  -- Purple with some transparency
                )
                
                if Property.EditingFurnitureObj then
                    SetEntityCoords(
                        Property.EditingFurnitureObj,
                        coords.x,
                        coords.y,
                        coords.z + heightOffset
                    )
                end
            end
            
            -- Enable scroll wheel controls
            EnableControlAction(0, 241, true) -- Scroll wheel up
            EnableControlAction(0, 242, true) -- Scroll wheel down
            
            -- Scroll wheel rotation
            local scrollDelta = 0
            if IsControlJustPressed(0, 241) then -- Scroll wheel up
                scrollDelta = 5.0 -- Larger increments for scroll
            elseif IsControlJustPressed(0, 242) then -- Scroll wheel down
                scrollDelta = -5.0
            end
            
            if scrollDelta ~= 0 then
                furnitureHeading = (furnitureHeading + scrollDelta) % 360
                SetEntityRotation(Property.EditingFurnitureObj, 0, 0, furnitureHeading, 1, true)
            end
            
            -- Height adjustment (UP key)
            if IsControlPressed(0, Config.FurnitureControls.UP.controlIndex) then
                local speed = IsControlReleased(0, Config.FurnitureControls.SPEED_DOWN.controlIndex) 
                    and Config.FurnitureSettings.HeightSpeed 
                    or Config.FurnitureSettings.HeightSpeedSlow
                heightOffset = heightOffset + speed
            end
            
            -- Height adjustment (DOWN key)
            if IsControlPressed(0, Config.FurnitureControls.DOWN.controlIndex) then
                local speed = IsControlReleased(0, Config.FurnitureControls.SPEED_DOWN.controlIndex)
                    and Config.FurnitureSettings.HeightSpeed
                    or Config.FurnitureSettings.HeightSpeedSlow
                heightOffset = heightOffset - speed
            end
            
            -- Rotate left (Arrow Left)
            if IsControlPressed(0, Config.FurnitureControls.ROTATE_LEFT.controlIndex) then
                local speed = IsControlReleased(0, Config.FurnitureControls.SPEED_DOWN.controlIndex)
                    and Config.FurnitureSettings.RotateSpeed
                    or Config.FurnitureSettings.RotateSpeedSlow
                furnitureHeading = furnitureHeading + speed
                SetEntityRotation(Property.EditingFurnitureObj, 0, 0, furnitureHeading, 1, true)
            end
            
            -- Rotate right (Arrow Right)
            if IsControlPressed(0, Config.FurnitureControls.ROTATE_RIGHT.controlIndex) then
                local speed = IsControlReleased(0, Config.FurnitureControls.SPEED_DOWN.controlIndex)
                    and Config.FurnitureSettings.RotateSpeed
                    or Config.FurnitureSettings.RotateSpeedSlow
                furnitureHeading = furnitureHeading - speed
                SetEntityRotation(Property.EditingFurnitureObj, 0, 0, furnitureHeading, 1, true)
            end
        end
        
        -- Change mode (gizmo <-> walk)
        EnableControlAction(0, Config.FurnitureControls.CHANGE_MODE.controlIndex, true)
        if IsControlJustPressed(0, Config.FurnitureControls.CHANGE_MODE.controlIndex) then
            if GetGameTimer() >= lastModeChange + 3000 then
                lastModeChange = GetGameTimer()
                
                if furnitureMode == "gizmo" then
                    furnitureMode = "normal"
                    if cursorEnabled then
                        ToggleCursor(false)
                    end
                    DeleteFurnitureCamera()
                    FreezeEntityPosition(PlayerPedId(), false)
                    
                    -- Reset camera to player
                    SetCamActive(GetRenderingCam(), false)
                    RenderScriptCams(false, true, 500, true, true)
                else
                    furnitureMode = "gizmo"
                    ToggleCursor(true)
                    CreateFurnitureCamera(true)
                end
                
                -- Update controls UI
                SendNUIMessage({
                    action = "ControlsMenu",
                    toggle = true,
                    controlsLabel = furnitureMode == "gizmo" and "furniture:gizmo" or "furniture:walkmode",
                    controlsName = furnitureMode == "gizmo" and "Furniture:gizmo" or "Furniture:walkmode"
                })
            else
                CL.Notification(
                    TRANSLATE("notify.furniture:mode_cooldown") or "Please wait before changing modes",
                    4000,
                    "error"
                )
            end
        end
        
        -- Snap to ground (only in gizmo mode)
        if furnitureMode == "gizmo" then
            EnableControlAction(0, Config.FurnitureControls.SNAP_TO_GROUND.controlIndex, true)
            if IsControlJustPressed(0, Config.FurnitureControls.SNAP_TO_GROUND.controlIndex) then
                if DoesEntityExist(Property.EditingFurnitureObj) then
                    local objPos = GetEntityCoords(Property.EditingFurnitureObj)
                    local objRot = GetEntityRotation(Property.EditingFurnitureObj, 2)
                    
                    -- Use raycast to find ground below object (works for shells and world)
                    local rayHandle = StartShapeTestRay(
                        objPos.x, objPos.y, objPos.z + 1.0,
                        objPos.x, objPos.y, objPos.z - 50.0,
                        -1, -- All entities
                        Property.EditingFurnitureObj, -- Ignore the furniture object itself
                        0
                    )
                    
                    local _, hit, hitCoords = GetShapeTestResult(rayHandle)
                    
                    if hit then
                        -- Snap to the hit position
                        SetEntityCoordsNoOffset(Property.EditingFurnitureObj, objPos.x, objPos.y, hitCoords.z, false, false, false)
                        PlaceObjectOnGroundProperly_2(Property.EditingFurnitureObj)
                        
                        -- Restore rotation after ground placement
                        SetEntityRotation(Property.EditingFurnitureObj, objRot.x, objRot.y, objRot.z, 2, true)
                        
                        CL.Notification(TRANSLATE("notify.furniture:snapped_to_ground") or "Snapped to ground", 2000, "success")
                    else
                        CL.Notification("No ground found below object", 2000, "error")
                    end
                end
            end
        end
        
        -- Check if entity still exists
        if not DoesEntityExist(Property.EditingFurnitureObj) then
            Property.EditingFurniture = false
            DeleteObject(Property.EditingFurnitureObj)
            Property.EditingFurnitureObj = nil
        end
        
        -- Cancel placement
        if IsControlJustPressed(0, Config.FurnitureControls.CLOSE.controlIndex) then
            -- Clean up furniture object
            if Property.EditingFurnitureObj then
                DeleteObject(Property.EditingFurnitureObj)
                Property.EditingFurnitureObj = nil
            end
            
            -- Clean up camera and cursor
            DeleteFurnitureCamera()
            if cursorEnabled then
                ToggleCursor(false)
            end
            
            -- Mark as cancelled to reopen menu
            Property.EditingFurniture = false
            Property.CancelledPlacement = true
            
            -- Reload furniture if needed
            Property:RemoveFurniture(nil, function()
                Property:LoadFurniture(
                    CurrentProperty and "inside" or "outside",
                    propertyData.furniture,
                    CurrentProperty
                )
                
                if propertyData.type == "mlo" then
                    Property:LoadFurniture(
                        CurrentProperty and "outside" or "inside",
                        propertyData.furniture,
                        CurrentProperty
                    )
                end
            end)
            
            -- Exit the loop
            break
        end
        
        -- Accept placement
        EnableControlAction(0, Config.FurnitureControls.ACCEPT.controlIndex, true)
        if IsControlJustPressed(0, Config.FurnitureControls.ACCEPT.controlIndex) then
            local finalPos = GetEntityCoords(Property.EditingFurnitureObj)
            local isInZone = false
            
            -- Check if in property zone
            if propertyData.metadata.zone then
                isInZone = isPointInPolygon(finalPos, propertyData.metadata.zone.points)
            end
            
            local canPlace = true
            
            -- Must be inside or in zone
            if not isInside and not isInZone then
                canPlace = false
            end
            
            -- MLO specific checks
            if propertyData.type == "mlo" then
                local isInInterior = isPointInPolygon(
                    finalPos,
                    propertyData.metadata.interiorZone.points
                )
                
                local furnitureData = Furniture[furnitureModel]
                local isIndoorFurniture = furnitureData.isIndoor == 1
                local isOutdoorFurniture = furnitureData.isOutdoor == 1
                local allowInside = propertyData.metadata.allowFurnitureInside ~= false
                local allowOutside = propertyData.metadata.allowFurnitureOutside ~= false
                
                if isInInterior then
                    if not isIndoorFurniture then
                        canPlace = false
                        CL.Notification(
                            TRANSLATE("notify.furniture:cannot_place_inside") or "This furniture cannot be placed inside",
                            4000,
                            "error"
                        )
                    elseif not allowInside then
                        canPlace = false
                        CL.Notification(
                            TRANSLATE("notify.furniture:inside_disabled") or "Indoor furniture placement is disabled",
                            4000,
                            "error"
                        )
                    end
                else
                    if not isOutdoorFurniture then
                        canPlace = false
                        CL.Notification(
                            TRANSLATE("notify.furniture:cannot_place_outside") or "This furniture cannot be placed outside",
                            4000,
                            "error"
                        )
                    elseif not allowOutside then
                        canPlace = false
                        CL.Notification(
                            TRANSLATE("notify.furniture:outside_disabled") or "Outdoor furniture placement is disabled",
                            4000,
                            "error"
                        )
                    end
                    
                    if propertyData.object_id then
                        canPlace = false
                        CL.Notification(
                            TRANSLATE("notify.furniture:no_outdoor_area") or "No outdoor area available",
                            4000,
                            "error"
                        )
                    end
                end
            end
            
            if canPlace then
                -- Save furniture data
                Property.EditingFurnitureData = {
                    id = furnitureId,
                    model = furnitureModel,
                    coords = finalPos,
                    rotation = GetEntityRotation(Property.EditingFurnitureObj),
                    isInside = isInside,
                    isExisting = isEditing
                }
                
                -- Either save directly or show purchase menu
                if Config.RequirePurchaseFurniture or isEditing then
                    TriggerServerEvent(
                        "vms_housing:sv:placeFurniture",
                        propertyId,
                        Property.EditingFurnitureData
                    )
                    Property.EditingFurniture = false
                    DeleteObject(Property.EditingFurnitureObj)
                    Property.EditingFurnitureObj = nil
                    
                    -- Clean up camera and cursor
                    DeleteFurnitureCamera()
                    if cursorEnabled then
                        ToggleCursor(false)
                    end
                    
                    -- Mark as placed successfully
                    Property.PlacedSuccessfully = true
                    
                    break
                else
                    -- Show purchase confirmation
                    SendNUIMessage({
                        action = "Property",
                        actionName = "OpenFurniturePurchase",
                        data = {
                            label = Furniture[furnitureModel].label,
                            price = Furniture[furnitureModel].price
                        }
                    })
                    openedMenu = "PropertyFurniturePurchase"
                    SetNuiFocus(true, true)
                end
            else
                CL.Notification(
                    TRANSLATE("notify.furniture:outside_zone") or "Furniture must be placed within property zone",
                    4000,
                    "error"
                )
            end
        end
    end
    
    -- Cleanup
    if cursorEnabled then
        ToggleCursor(false)
    end
    DeleteFurnitureCamera()
    FreezeEntityPosition(PlayerPedId(), false)
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = false
    })
    Property.EditingFurnitureData = {}
    
    -- Check if we should reopen the menu
    if Property.CancelledPlacement or Property.PlacedSuccessfully then
        local shouldReopen = Property.CancelledPlacement or Property.PlacedSuccessfully
        local delay = Property.PlacedSuccessfully and 500 or 100
        
        -- Clear all flags
        Property.CancelledPlacement = false
        Property.PlacedSuccessfully = false
        Property.EditingFurniture = false
        
        -- Use a thread to reopen menu after delay
        Citizen.CreateThread(function()
            Citizen.Wait(delay)
            if shouldReopen then
                openFurnitureMenu()
            end
        end)
    else
        Property.EditingFurniture = false -- Clear flag even if no action
    end
end

-- Edit existing furniture (raycast selection)
function editFurniture()
    -- Check if there's any furniture to edit
    if not Property.LoadedFurnitures or not next(Property.LoadedFurnitures) then
        CL.Notification(TRANSLATE("notify.furniture:no_furniture") or "No furniture found in this property", 3000, "error")
        Property.EditingFurniture = false
        openFurnitureMenu()
        return
    end
    
    -- Count furniture for debugging
    local furnitureCount = 0
    for _, _ in pairs(Property.LoadedFurnitures) do
        furnitureCount = furnitureCount + 1
    end
    
    -- Show instructions to the player
    local editMessage = TRANSLATE("notify.furniture:edit_mode")
    if not editMessage then
        editMessage = string.format("Look at furniture and press ENTER to edit placement, BACKSPACE to cancel (%d items)", furnitureCount)
    end
    CL.Notification(editMessage, 5000, "inform")
    
    -- Show controls UI for edit selection mode
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "furniture:edit_select",
        controlsName = "Furniture - Select to Edit"
    })
    
    Citizen.CreateThread(function()
        local outlinedEntities = {}
        local selectedEntity = nil
        
        while Property.EditingFurniture do
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            
            -- Hide HUD elements
            HudForceWeaponWheel(false)
            HideHudComponentThisFrame(19)
            HideHudComponentThisFrame(20)
            
            DisabledControls(false) -- Pass false for edit mode (not gizmo)
            
            -- Raycast to find furniture
            local hit, coords, entity = RayCastGamePlayCamera(nil, 80.0)
            
            if hit then
                -- Draw raycast line
                DrawLine(
                    playerPos.x, playerPos.y, playerPos.z,
                    coords.x, coords.y, coords.z,
                    159, 15, 255, 250
                )
                
                if entity then
                    -- Check if this entity is furniture
                    local isFurniture = false
                    local furnitureData = nil
                    
                    for furnitureId, furniture in pairs(Property.LoadedFurnitures) do
                        if furniture.entity == entity then
                            isFurniture = true
                            -- Ensure we have all needed data
                            furnitureData = {
                                entity = furniture.entity,
                                model = furniture.model or GetEntityModel(entity),
                                furnitureId = furniture.furnitureId or furnitureId
                            }
                            break
                        end
                    end
                    
                    -- Handle entity selection
                    if isFurniture then
                        if selectedEntity ~= entity then
                            -- Remove outline from previous entity
                            if selectedEntity and outlinedEntities[selectedEntity] then
                                SetEntityDrawOutline(selectedEntity, false)
                                outlinedEntities[selectedEntity] = nil
                            end
                            
                            -- Add outline to new entity
                            selectedEntity = entity
                            outlinedEntities[entity] = furnitureData
                            SetEntityDrawOutline(entity, true)
                            SetEntityDrawOutlineColor(159, 15, 255, 200)
                            SetEntityDrawOutlineShader(0)
                        end
                    else
                        -- Not furniture, clear selection
                        if selectedEntity and outlinedEntities[selectedEntity] then
                            SetEntityDrawOutline(selectedEntity, false)
                            outlinedEntities[selectedEntity] = nil
                            selectedEntity = nil
                        end
                    end
                    
                    -- Accept selection
                    EnableControlAction(0, Config.FurnitureControls.ACCEPT.controlIndex, true)
                    if IsControlJustPressed(0, Config.FurnitureControls.ACCEPT.controlIndex) then
                        if outlinedEntities[entity] then
                            -- Clear all outlines
                            for ent, _ in pairs(outlinedEntities) do
                                SetEntityDrawOutline(ent, false)
                            end
                            
                            -- Store the selected furniture data
                            local selectedFurniture = outlinedEntities[entity]
                            
                            -- Debug notification
                            CL.Notification(string.format("Editing furniture: %s (ID: %s)", 
                                selectedFurniture.model or "unknown", 
                                selectedFurniture.furnitureId or "unknown"), 3000, "inform")
                            
                            -- Exit edit selection mode
                            Property.EditingFurniture = false
                            
                            -- Hide the edit controls
                            SendNUIMessage({
                                action = "ControlsMenu",
                                toggle = false
                            })
                            
                            -- Start editing the selected furniture
                            Citizen.Wait(100)
                            manageFurniture(
                                true,
                                selectedFurniture.model,
                                selectedFurniture.furnitureId
                            )
                            break
                        else
                            CL.Notification(TRANSLATE("notify.furniture:no_selection") or "No furniture selected", 2000, "error")
                        end
                    end
                end
            else
                -- Clear outlines when not hitting anything
                if next(outlinedEntities) then
                    for ent, _ in pairs(outlinedEntities) do
                        SetEntityDrawOutline(ent, false)
                    end
                    outlinedEntities = {}
                end
            end
            
            -- Cancel editing (Backspace key)
            EnableControlAction(0, Config.FurnitureControls.CLOSE.controlIndex, true)
            if IsControlJustPressed(0, Config.FurnitureControls.CLOSE.controlIndex) then
                if next(outlinedEntities) then
                    for ent, _ in pairs(outlinedEntities) do
                        SetEntityDrawOutline(ent, false)
                    end
                    outlinedEntities = {}
                end
                Property.EditingFurniture = false
                CL.Notification(TRANSLATE("notify.furniture:edit_cancelled") or "Edit mode cancelled", 3000, "inform")
                break
            end
            
            Citizen.Wait(1)
        end
        
        -- Cleanup when exiting edit mode
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
        
        -- Re-open furniture menu if not placing new furniture
        if not Property.EditingFurnitureObj then
            openFurnitureMenu()
        end
    end)
end

-- Edit property theme (IPL interiors only)
function editTheme(themeId)
    Property.EditingTheme = themeId
    
    local propertyId = CurrentProperty or GetCurrentPropertyId()
    local propertyData = CurrentPropertyData or GetCurrentPropertyData()
    
    if CurrentIPL then
        local themeData = AvailableIPLS[propertyData.metadata.ipl].settings.Themes[Property.EditingTheme]
        
        if themeData then
            -- Load the theme
            IPL.LoadSettings(
                CurrentIPL,
                Property.EditingTheme,
                propertyData.metadata.iplSettings,
                function()
                    -- Refresh player position
                    local pos = GetEntityCoords(PlayerPedId())
                    SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
                end
            )
            
            -- Wait for user confirmation or cancellation
            while Property.EditingTheme do
                -- Cancel theme preview
                if IsControlJustPressed(0, Config.FurnitureControls.CLOSE.controlIndex) then
                    -- Restore original theme
                    IPL.LoadSettings(
                        CurrentIPL,
                        propertyData.metadata.iplTheme,
                        propertyData.metadata.iplSettings,
                        function()
                            local pos = GetEntityCoords(PlayerPedId())
                            SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
                        end
                    )
                    Property.EditingTheme = nil
                end
                
                -- Purchase theme
                if IsControlJustPressed(0, Config.FurnitureControls.ACCEPT.controlIndex) then
                    SendNUIMessage({
                        action = "Property",
                        actionName = "OpenFurniturePurchase",
                        data = {
                            label = themeData.label,
                            price = themeData.price
                        }
                    })
                    SetNuiFocus(true, true)
                    openedMenu = "PropertyFurniturePurchase"
                end
                
                Citizen.Wait(1)
            end
        end
    end
    
    Property.EditingTheme = nil
end

-- Open furniture menu
function openFurnitureMenu()
    local propertyId = CurrentProperty or GetCurrentPropertyId()
    local propertyData = CurrentPropertyData or GetCurrentPropertyData()
    
    if waitingForLoadAfterRestart then
        return
    end
    
    if not propertyData then
        return
    end
    
    if Property.EditingFurniture or Property.EditingTheme then
        return
    end
    
    -- Check permissions
    if not library.HasPermissions(propertyId, "furniture") then
        return
    end
    
    -- Determine if player is inside
    local isInside = false
    local isOutside = false
    
    if propertyData.type == "shell" then
        if CurrentShell then
            isInside = true
        end
    elseif propertyData.type == "ipl" then
        if CurrentIPL then
            isInside = true
        end
    elseif propertyData.type == "mlo" then
        isInside = IsInsideMLO()
    end
    
    isOutside = not isInside
    
    -- Send menu data to UI
    SendNUIMessage({
        action = "Property",
        actionName = "OpenFurniture",
        data = {
            propertyFurniture = propertyData.furniture,
            ipl = isInside and CurrentIPL or nil,
            allowChangeThemePurchased = propertyData.metadata.allowChangeThemePurchased,
            isInside = isInside,
            isOutside = isOutside,
            allowedInside = propertyData.metadata.allowFurnitureInside,
            allowedOutside = propertyData.metadata.allowFurnitureOutside
        }
    })
    SetNuiFocus(true, true)
    openedMenu = "PropertyFurniture"
end

-- Close furniture menu
function closeFurnitureMenu()
    SendNUIMessage({
        action = "Property",
        actionName = "CloseFurniture"
    })
    SetNuiFocus(false, false)
    openedMenu = nil
end

-- Register command if enabled
if Config.HousingFurniture.Command then
    RegisterCommand(Config.HousingFurniture.Command, function()
        openFurnitureMenu()
    end)
    
    -- Register keybind if configured
    if Config.HousingFurniture.Key then
        RegisterKeyMapping(
            Config.HousingFurniture.Command,
            Config.HousingFurniture.Description or "",
            "keyboard",
            Config.HousingFurniture.Key
        )
    end
end

-- Export functions
exports("OpenFurnitureMenu", openFurnitureMenu)