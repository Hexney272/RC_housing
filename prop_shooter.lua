-- Prop Shooter - Automated Furniture Photography Tool
-- Takes screenshots of furniture items for catalog/documentation
-- Includes interactive controls for positioning and camera adjustment

-- ============================================================================
-- Global Variables
-- ============================================================================

local propsToPhotograph = {}          -- List of prop models to photograph
local screenModel = "prop_big_cin_screen" -- Background screen model
local currentPropIndex = 1             -- Current position in props list

local currentProp = nil                -- Currently spawned prop entity
local screenTop = nil                  -- Top background screen
local screenMiddle = nil               -- Middle background screen
local screenBottom = nil               -- Bottom background screen
local camera = nil                     -- Active camera entity
local playerOriginalPosition = nil     -- Player's position before tool starts

-- Studio location (isolated area for clean photos)
local studioLocation = vector3(500.0, 500.0, 350.0)

local isCountdownActive = false        -- Whether countdown timer is running
local countdownTime = 3000             -- Countdown duration in milliseconds
local isTimerPaused = false            -- Whether timer is paused
local furnitureData = {}               -- Collected furniture data with sizes

-- ============================================================================
-- Helper Functions
-- ============================================================================

-- Calculate delivery size category based on model dimensions
-- Returns: 1 = Small, 2 = Medium, 3 = Large
local function calculateDeliverySize(minDimensions, maxDimensions)
    local size = vector3(
        math.abs(maxDimensions.x - minDimensions.x),
        math.abs(maxDimensions.y - minDimensions.y),
        math.abs(maxDimensions.z - minDimensions.z)
    )
    
    -- Calculate volume
    local volume = size.x * size.y * size.z
    
    -- Categorize by volume
    if volume <= 0.3 then
        return 1  -- Small
    elseif volume <= 1.0 then
        return 2  -- Medium
    else
        return 3  -- Large
    end
end

-- Draw 2D text on screen
function drawText2D(text, x, y, scale, red, green, blue)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.0, scale)
    SetTextColour(red, green, blue, 255)
    SetTextDropshadow(0, 0, 0, 0, 205)
    SetTextEdge(1, 0, 0, 0, 150)
    SetTextDropshadow()
    SetTextOutline()
    SetTextCentre(1)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

-- ============================================================================
-- Countdown Timer with Interactive Controls
-- ============================================================================
function startCountdown()
    isCountdownActive = true
    countdownTime = 3000
    isTimerPaused = false
    
    while isCountdownActive do
        Citizen.Wait(0)
        
        -- Update and display timer
        if not isTimerPaused then
            countdownTime = countdownTime - 10
            drawText2D(countdownTime .. "ms", 0.5, 0.5, 0.8, 200, 0, 0)
            drawText2D("Press SPACE to hold timer", 0.5, 0.54, 0.3, 210, 210, 210)
        else
            drawText2D(countdownTime .. "ms", 0.5, 0.5, 0.8, 200, 200, 0)
            drawText2D("Press SPACE to resume timer", 0.5, 0.54, 0.3, 210, 210, 210)
        end
        
        -- Display control instructions
        drawText2D("Change FOV using SCROLL", 0.5, 0.7, 0.4, 240, 240, 240)
        drawText2D("Change HEIGHT using LMB/RMB", 0.5, 0.73, 0.4, 240, 240, 240)
        drawText2D("Change ROTATION using ARROWS", 0.5, 0.76, 0.4, 240, 240, 240)
        
        -- Toggle pause with SPACE (Control 22)
        if IsControlJustPressed(0, 22) then
            isTimerPaused = not isTimerPaused
        end
        
        -- Adjust height with Left Mouse Button (Control 24)
        if IsControlPressed(0, 24) then
            local coords = GetEntityCoords(currentProp)
            SetEntityCoords(currentProp, coords.x, coords.y, coords.z + 0.01)
        end
        
        -- Adjust height with E key (Control 70)
        if IsControlPressed(0, 70) then
            local coords = GetEntityCoords(currentProp)
            SetEntityCoords(currentProp, coords.x, coords.y, coords.z - 0.01)
        end
        
        -- Rotate left with Left Arrow (Control 174)
        if IsControlPressed(0, 174) then
            local heading = GetEntityHeading(currentProp)
            heading = (heading + 1.0) % 360
            SetEntityHeading(currentProp, heading)
        end
        
        -- Rotate right with Right Arrow (Control 175)
        if IsControlPressed(0, 175) then
            local heading = GetEntityHeading(currentProp)
            heading = (heading - 1.0) % 360
            if heading < 0 then
                heading = heading + 360
            end
            SetEntityHeading(currentProp, heading)
        end
        
        -- Zoom in with Mouse Scroll Up (Control 180)
        if IsControlPressed(0, 180) then
            SetCamFov(camera, GetCamFov(camera) + 2.0)
        end
        
        -- Zoom out with Mouse Scroll Down (Control 181)
        if IsControlPressed(0, 181) then
            SetCamFov(camera, GetCamFov(camera) - 2.0)
        end
        
        -- Stop countdown when timer reaches zero
        if countdownTime <= 0 then
            isCountdownActive = false
        end
    end
    
    Citizen.Wait(1250)
end

-- ============================================================================
-- Main Registration Function
-- ============================================================================
-- Takes photos of all specified props and registers them with furniture data
function RegisterFurniture(propsList)
    if not OBJECTS_PHOTOS_TOOL_WEBHOOK then
        return library.Debug("Nie możesz korzystać z tej opcji. Nie ma skonfigurowanego webhooka.", "warn")
    end
    
    propsToPhotograph = propsList
    furnitureData = {}
    currentPropIndex = 1
    
    -- Save player's original position
    playerOriginalPosition = GetEntityCoords(PlayerPedId())
    
    Citizen.Wait(100)
    
    -- Teleport player to studio location
    local playerPed = PlayerPedId()
    SetEntityCoords(
        playerPed,
        studioLocation.x,
        studioLocation.y,
        studioLocation.z + 15.0,
        false, false, false, true
    )
    FreezeEntityPosition(playerPed, true)
    
    -- Spawn background screens for clean backdrop
    screenTop = library.SpawnProp(
        GetHashKey(screenModel),
        vector3(studioLocation.x, studioLocation.y, studioLocation.z + 15.0),
        false
    )
    FreezeEntityPosition(screenTop, true)
    
    screenMiddle = library.SpawnProp(
        GetHashKey(screenModel),
        vector3(studioLocation.x, studioLocation.y, studioLocation.z),
        false
    )
    FreezeEntityPosition(screenMiddle, true)
    
    screenBottom = library.SpawnProp(
        GetHashKey(screenModel),
        vector3(studioLocation.x, studioLocation.y, studioLocation.z - 15.0),
        false
    )
    FreezeEntityPosition(screenBottom, true)
    
    -- Hide HUD for clean screenshots
    CL.Hud.Disable()
    
    Wait(1000)
    
    -- Process each prop in the list
    while currentPropIndex ~= 0 do
        spawnNextProp()
        Citizen.Wait(1000)
    end
    
    Citizen.Wait(750)
    
    -- Cleanup: Delete all spawned entities
    if currentProp then DeleteEntity(currentProp) end
    if screenTop then DeleteEntity(screenTop) end
    if screenMiddle then DeleteEntity(screenMiddle) end
    if screenBottom then DeleteEntity(screenBottom) end
    
    -- Restore HUD
    CL.Hud.Enable()
    
    -- Unfreeze and teleport player back
    FreezeEntityPosition(PlayerPedId(), false)
    if playerOriginalPosition and playerOriginalPosition.x then
        SetEntityCoords(PlayerPedId(), playerOriginalPosition.x, playerOriginalPosition.y, playerOriginalPosition.z)
    end
    
    -- Cleanup camera
    DestroyCam(camera, false)
    SetCamActive(camera, false)
    RenderScriptCams(false, true, 500, true, true)
    
    -- Send furniture data to server
    TriggerServerEvent("vms_housing:sv:addFurniture", furnitureData)
end

-- ============================================================================
-- Spawn and Photograph Next Prop
-- ============================================================================
function spawnNextProp()
    -- Delete previous prop if exists
    if currentProp then
        DeleteEntity(currentProp)
    end
    
    local propModel = propsToPhotograph[currentPropIndex]
    
    -- Spawn the prop
    currentProp = library.SpawnProp(
        GetHashKey(propModel),
        vector3(studioLocation.x, studioLocation.y, studioLocation.z + 10.0),
        false
    )
    
    if DoesEntityExist(currentProp) then
        FreezeEntityPosition(currentProp, true)
        SetEntityHeading(currentProp, 25.0)
        
        -- Setup camera for this prop
        setupCamera(currentProp)
        
        Citizen.Wait(500)
        
        -- Start countdown timer for manual adjustments
        startCountdown()
        
        -- Take screenshot after countdown
        takeScreenshot(propModel, function(success)
            if DoesEntityExist(currentProp) then
                -- Calculate and store delivery size
                local minDim, maxDim = GetModelDimensions(propModel)
                furnitureData[propModel] = {
                    deliverySize = calculateDeliverySize(minDim, maxDim)
                }
            else
                print('Entity "' .. propModel .. '" does not exist')
            end
            
            -- Move to next prop
            currentPropIndex = currentPropIndex + 1
            if currentPropIndex > #propsToPhotograph then
                currentPropIndex = 0  -- Signal completion
            end
        end)
    else
        print('Entity "' .. propModel .. '" does not exist')
        
        -- Skip to next prop
        currentPropIndex = currentPropIndex + 1
        if currentPropIndex > #propsToPhotograph then
            currentPropIndex = 0
        end
    end
end

-- ============================================================================
-- Camera Setup
-- ============================================================================
-- Automatically positions and aims camera based on prop dimensions
function setupCamera(propEntity)
    -- Cleanup existing camera
    if camera then
        DestroyCam(camera, false)
        SetCamActive(camera, false)
    end
    
    -- Create new camera
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    -- Get prop position and dimensions
    local propCoords = GetEntityCoords(propEntity)
    local minDim, maxDim = GetModelDimensions(GetEntityModel(propEntity))
    
    -- Calculate prop size
    local size = maxDim - minDim
    local width = size.x
    local height = size.z
    local depth = size.y
    
    -- Calculate optimal camera distance based on largest dimension
    local maxSize = math.max(width, depth)
    local cameraDistance = math.max(2.5, maxSize * 1.4)
    
    -- Position camera in front of prop
    local camX = propCoords.x
    local camY = propCoords.y - cameraDistance
    local camZ = propCoords.z + (height * 1.2)
    
    SetCamCoord(camera, camX, camY, camZ)
    
    -- Aim camera at center of prop
    PointCamAtCoord(camera, propCoords.x, propCoords.y, propCoords.z + (height * 0.5))
    
    -- Calculate optimal FOV based on prop size
    local fov = math.max(40.0, math.min(70.0, 65.0 - (maxSize * 3.0)))
    SetCamFov(camera, fov)
    
    -- Activate camera
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 500, true, true)
end

-- ============================================================================
-- Screenshot Function
-- ============================================================================
-- Captures screenshot and sends to NUI for processing
function takeScreenshot(fileName, callback)
    exports["screenshot-basic"]:requestScreenshot(function(imageData)
        -- Send image to NUI for processing/upload
        SendNUIMessage({
            action = "ProcessImage",
            fileName = fileName,
            image = imageData
        })
        
        callback(true)
    end)
end