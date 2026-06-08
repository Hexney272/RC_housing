-- Security camera viewing system for properties

-- State variables
local isInCameraMode = false
local currentCameraIndex = nil
local currentCamera = nil
local currentCameraEntity = nil
local availableCameras = {}

-- Main camera viewing function
function checkCameras(propertyId, callback, environment)
    local propertyData = Properties[propertyId]
    
    -- Check permissions
    if not library.HasAnyPermission(propertyId) then
        return
    end
    
    -- Build camera list if empty
    if not next(availableCameras) then
        availableCameras = {}
        
        -- Find all camera furniture in the property
        for _, furniture in pairs(propertyData.furniture) do
            local isCameraModel = Config.Cameras[furniture.model]
            local hasPosition = furniture.position
            local isPlaced = furniture.stored == 0
            
            if isCameraModel and hasPosition and isPlaced then
                -- Filter by environment if specified
                if environment then
                    if furniture.position.environment == environment then
                        table.insert(availableCameras, furniture)
                    end
                else
                    table.insert(availableCameras, furniture)
                end
            end
        end
    end
    
    -- Exit if no cameras found
    if not next(availableCameras) then
        if callback then
            callback(false)
        end
        return
    end
    
    -- Confirm cameras are available
    if callback then
        callback(true)
    end
    
    -- Exit camera mode if already in camera mode and no valid camera
    if isInCameraMode and (not currentCameraIndex or not availableCameras[currentCameraIndex] or not availableCameras[currentCameraIndex].position) then
        DoScreenFadeOut(400)
        isInCameraMode = false
        Wait(400)
        
        -- Cleanup camera
        ClearFocus()
        ClearTimecycleModifier()
        ClearExtraTimecycleModifier()
        RenderScriptCams(false, false, 0, true, false)
        
        -- Restore player
        local playerPed = PlayerPedId()
        SetFocusEntity(playerPed)
        SetEntityCollision(playerPed, true, true)
        SetEntityVisible(playerPed, true)
        Wait(300)
        
        -- Handle environment transitions
        if environment then
            if CurrentProperty then
                if environment == "outside" then
                    -- Exit to outside
                    Property:EnterProperty(propertyData, propertyId, function(success)
                        if success then
                            Citizen.CreateThread(function()
                                Citizen.Wait(3000)
                                openManageMenu()
                            end)
                        end
                    end, true)
                else
                    FreezeEntityPosition(playerPed, false)
                    DoScreenFadeIn(400)
                end
            elseif environment == "inside" then
                -- Exit from inside view
                TriggerServerEvent("vms_housing:sv:exitCameraMode", propertyId, environment)
                
                if ToggleWeather then
                    ToggleWeather(false)
                end
                
                if CurrentShell then
                    DeleteObject(CurrentShell)
                    CurrentShell = nil
                end
                
                if CurrentIPL then
                    IPL.UnloadSettings(CurrentIPL)
                    CurrentIPL = nil
                end
                
                openManageMenu()
                Property:RemoveFurniture()
                FreezeEntityPosition(playerPed, false)
                DoScreenFadeIn(400)
            else
                FreezeEntityPosition(playerPed, false)
                DoScreenFadeIn(400)
            end
        else
            openManageMenu()
            FreezeEntityPosition(playerPed, false)
            DoScreenFadeIn(400)
        end
        
        availableCameras = {}
        SendNUIMessage({
            action = "ControlsMenu",
            toggle = false
        })
        return
    end
    
    -- Initialize camera mode
    DoScreenFadeOut(300)
    Wait(300)
    
    -- Handle environment switching
    if not isInCameraMode then
        if environment then
            if CurrentProperty then
                if environment == "outside" then
                    -- Exit house to view outside cameras
                    TriggerServerEvent("vms_housing:sv:exitHouse", CurrentProperty, true)
                    
                    if ToggleWeather then
                        ToggleWeather(false)
                    end
                    
                    if CurrentShell then
                        DeleteObject(CurrentShell)
                        CurrentShell = nil
                    end
                    
                    if CurrentIPL then
                        IPL.UnloadSettings(CurrentIPL)
                        CurrentIPL = nil
                    end
                end
            elseif environment == "inside" then
                -- Enter house to view inside cameras
                TriggerServerEvent("vms_housing:sv:enterCameraModeDifferentEnvironment", propertyId, environment)
                
                if propertyData.type == "shell" then
                    Property:RemoveFurniture()
                    
                    -- Spawn shell
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
                    
                    -- Toggle weather inside shell
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
                elseif propertyData.type == "ipl" then
                    CurrentIPL = propertyData.metadata.ipl
                    IPL.LoadSettings(
                        CurrentIPL,
                        propertyData.metadata.iplTheme,
                        propertyData.metadata.iplSettings
                    )
                end
                
                Wait(1500)
                
                -- Set light state
                if propertyData.metadata.lightState ~= nil then
                    SetArtificialLightsState(not propertyData.metadata.lightState)
                end
                
                -- Load interior furniture
                if propertyData and propertyData.furniture then
                    Property:LoadFurniture("inside", propertyData.furniture, propertyId)
                end
            end
        end
        
        currentCameraIndex = 1
        isInCameraMode = true
    end
    
    -- Cleanup previous camera
    if isInCameraMode then
        if currentCameraEntity then
            SetEntityVisible(currentCameraEntity, true)
        end
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(currentCamera, false)
        currentCamera = false
    end
    
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local cameraData = availableCameras[currentCameraIndex]
    
    ClearFocus()
    
    -- Create scripted camera
    currentCamera = CreateCamWithParams(
        "DEFAULT_SCRIPTED_CAMERA",
        vector3(cameraData.position.x, cameraData.position.y, cameraData.position.z),
        0, 0, 0,
        50.0
    )
    
    -- Find the camera entity (furniture object)
    currentCameraEntity = GetClosestObjectOfType(
        cameraData.position.x,
        cameraData.position.y,
        cameraData.position.z,
        0.5,
        GetHashKey(cameraData.model),
        false, false, false
    )
    
    -- Wait for entity to load
    local timeout = GetGameTimer() + 3000
    while GetGameTimer() < timeout do
        if DoesEntityExist(currentCameraEntity) then
            break
        end
        Wait(1)
        currentCameraEntity = GetClosestObjectOfType(
            cameraData.position.x,
            cameraData.position.y,
            cameraData.position.z,
            0.5,
            GetHashKey(cameraData.model),
            false, false, false
        )
    end
    
    -- Set camera rotation based on entity rotation
    local entityRot = GetEntityRotation(currentCameraEntity)
    local camRotX = entityRot.x - 18.0
    local camRotZ = (entityRot.z + 180.0) % 360.0
    
    SetCamRot(currentCamera, camRotX, entityRot.y, camRotZ, 2)
    SetCamActive(currentCamera, true)
    
    -- Apply camera effects
    SetTimecycleModifier("scanline_cam_cheap")
    DisableAllControlActions(0)
    
    -- Hide player
    FreezeEntityPosition(playerPed, true)
    SetEntityCollision(playerPed, false, true)
    SetEntityVisible(playerPed, false)
    SetEntityVisible(currentCameraEntity, false)
    
    SetTimecycleModifierStrength(2.0)
    SetFocusArea(cameraData.position.x, cameraData.position.y, cameraData.position.z, 0.0, 0.0, 0.0)
    PointCamAtCoord(currentCamera, vector3(cameraData.position.x, cameraData.position.y, cameraData.position.z))
    RenderScriptCams(true, false, 1, true, false)
    
    Wait(1000)
    DoScreenFadeIn(500)
    
    -- Request audio banks
    RequestAmbientAudioBank("Phone_Soundset_Franklin", 0, 0)
    RequestAmbientAudioBank("HintCamSounds", 0, 0)
    
    -- Show controls UI
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "property:camera",
        controlsName = "Property:camera"
    })
    
    -- Camera view loop
    while IsCamActive(currentCamera) do
        Citizen.Wait(2)
        DisableAllControlActions(0)
        
        -- Hide HUD elements
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
        
        SetEntityLocallyInvisible(currentCameraEntity)
        
        -- Previous camera (Left Arrow)
        if IsDisabledControlPressed(0, 174) then
            if availableCameras[currentCameraIndex - 1] then
                currentCameraIndex = currentCameraIndex - 1
                checkCameras(propertyId, nil, environment)
            else
                if currentCameraIndex ~= #availableCameras then
                    currentCameraIndex = #availableCameras
                    checkCameras(propertyId, nil, environment)
                end
            end
        end
        
        -- Next camera (Right Arrow)
        if IsDisabledControlPressed(0, 175) then
            if availableCameras[currentCameraIndex + 1] then
                currentCameraIndex = currentCameraIndex + 1
                checkCameras(propertyId, nil, environment)
            else
                if currentCameraIndex ~= 1 then
                    currentCameraIndex = 1
                    checkCameras(propertyId, nil, environment)
                end
            end
        end
        
        -- Draw camera info overlay
        SetTextFont(4)
        SetTextScale(0.8, 0.8)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0.1, 3, 27, 27, 255)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(
            propertyData.address .. " - Cam " .. currentCameraIndex .. "/" .. #availableCameras
        )
        EndTextCommandDisplayText(0.01, 0.01)
        
        -- Draw timestamp
        SetTextFont(4)
        SetTextScale(0.7, 0.7)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0.1, 3, 27, 27, 255)
        BeginTextCommandDisplayText("STRING")
        
        local year, month, day, hour, minute, second = GetPosixTime()
        AddTextComponentSubstringPlayerName(
            "" .. day .. "/" .. month .. "/" .. year .. " " .. hour .. ":" .. minute .. ":" .. second
        )
        EndTextCommandDisplayText(0.01, 0.055)
        
        -- Exit camera mode (BACKSPACE)
        if IsDisabledControlPressed(1, 194) then
            DoScreenFadeOut(400)
            isInCameraMode = false
            Wait(400)
            
            -- Cleanup
            ClearFocus()
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
            RenderScriptCams(false, false, 0, true, false)
            SetCamActive(currentCamera, false)
            DestroyCam(currentCamera, false)
            
            -- Restore player
            SetFocusEntity(playerPed)
            SetEntityCollision(playerPed, true, true)
            SetEntityVisible(playerPed, true)
            Wait(300)
            
            -- Handle environment transitions
            if environment then
                if CurrentProperty then
                    if environment == "outside" then
                        Property:EnterProperty(propertyData, propertyId, function(success)
                            if success then
                                Citizen.CreateThread(function()
                                    Citizen.Wait(3000)
                                    openManageMenu()
                                end)
                            end
                        end, true)
                    else
                        FreezeEntityPosition(playerPed, false)
                        DoScreenFadeIn(400)
                    end
                elseif environment == "inside" then
                    TriggerServerEvent("vms_housing:sv:exitCameraMode", propertyId, environment)
                    
                    if ToggleWeather then
                        ToggleWeather(false)
                    end
                    
                    if CurrentShell then
                        DeleteObject(CurrentShell)
                        CurrentShell = nil
                    end
                    
                    if CurrentIPL then
                        IPL.UnloadSettings(CurrentIPL)
                        CurrentIPL = nil
                    end
                    
                    openManageMenu()
                    Property:RemoveFurniture()
                    FreezeEntityPosition(playerPed, false)
                    DoScreenFadeIn(400)
                else
                    FreezeEntityPosition(playerPed, false)
                    DoScreenFadeIn(400)
                end
            else
                openManageMenu()
                FreezeEntityPosition(playerPed, false)
                DoScreenFadeIn(400)
            end
            
            SetEntityVisible(currentCameraEntity, true)
            availableCameras = {}
            break
        end
    end
    
    -- Hide controls UI
    SendNUIMessage({
        action = "ControlsMenu",
        toggle = false
    })
    
    SetEntityVisible(currentCameraEntity, true)
end