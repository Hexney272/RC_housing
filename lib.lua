-- Initialize CL if not already defined (for notifications)
-- This will be overridden by config.client.lua but provides a fallback
if not CL then
    CL = {}
end

-- Ensure CL.Notification exists with proper VMS notify support
if not CL.Notification then
    CL.Notification = function(message, time, type)
        local duration = time or 5000
        type = type or "info"
        
        if GetResourceState("vms_notify") == 'started' then
            local color = "#4287f5" -- Default info color
            local icon = "fa-solid fa-house"
            
            if type == "success" then
                color = "#36f230"
            elseif type == "error" then
                color = "#f23030"
            elseif type == "info" then
                color = "#4287f5"
            end
            
            exports['vms_notify']:Notification("VMS Housing", message, duration, color, icon)
        else
            -- Fallback to native notification
            SetNotificationTextEntry("STRING")
            AddTextComponentString(message)
            DrawNotification(false, true)
        end
    end
end

-- Add other CL functions if they don't exist
if not CL.GetIdentifier then
    CL.GetIdentifier = function()
        return Identifier or GetPlayerServerId(PlayerId())
    end
end

if not CL.GetPlayerIdentifier then
    CL.GetPlayerIdentifier = function()
        return Identifier or GetPlayerServerId(PlayerId())
    end
end

if not CL.GetPlayerCharacterName then
    CL.GetPlayerCharacterName = function()
        return CharacterName or "Unknown"
    end
end

library = {}  -- Make library global so it can be accessed from other files

-- Properties to track animation and prop states
library.WaitGameTimer = nil
library.IsHaveProp = nil
library.IsHaveProp2 = nil
library.IsPlayingAnimation = false

-- Action rate limiter with cooldown
function library.ActionLimiter(cooldownMs)
    local currentTime = GetGameTimer()
    
    if library.WaitGameTimer and currentTime <= library.WaitGameTimer then
        CL.Notification(TRANSLATE("notify.wait"), 4500, "info")
        return true
    end
    
    local cooldown = cooldownMs or 1500
    library.WaitGameTimer = currentTime + cooldown
    return false
end

-- Debug logging utility
function library.Debug(message, logType)
    if not Config.Debug then
        return
    end
    
    if logType == "error" then
        error(message)
    elseif logType == "warn" then
        warn(message)
    else
        print(message)
    end
end

-- JSON dump with indentation
function library.Dump(data)
    return json.encode(data, { indent = true })
end

-- Check if player has permissions for a property
function library.HasPermissions(propertyId, permission)
    if not propertyId then return false end
    
    local property = Properties[tostring(propertyId)]
    if not property then return false end
    
    local identifier = CL.GetIdentifier()
    
    -- Owner has all permissions
    if property.owner == identifier then
        return true
    end
    
    -- Check if player has keys
    if property.keys and property.keys[identifier] then
        -- For basic permissions like garage, keys are enough
        if permission == "garage" or permission == "enter" then
            return true
        end
    end
    
    -- Check specific permissions
    if property.permissions and property.permissions[identifier] then
        local perms = property.permissions[identifier]
        
        -- Check if player has the specific permission
        if perms[permission] then
            return true
        end
        
        -- Check if player has all permissions
        if perms["*"] or perms["all"] then
            return true
        end
    end
    
    return false
end

-- Check if player has any permission for a property
function library.HasAnyPermission(propertyId)
    if not propertyId then return false end
    
    local property = Properties[tostring(propertyId)]
    if not property then return false end
    
    local identifier = CL.GetIdentifier()
    
    
    -- Owner always has permission
    if property.owner == identifier then
        return true
    end
    
    -- Check if player has keys
    if property.keys and property.keys[identifier] then
        return true
    end
    
    -- Check if player has any permissions
    if property.permissions and property.permissions[identifier] then
        return true
    end
    
    return false
end

-- Deep copy a table with metatable support
function library.Deepcopy(original)
    local originalType = type(original)
    local copy
    
    if originalType == 'table' then
        copy = {}
        for key, value in next, original, nil do
            copy[library.Deepcopy(key)] = library.Deepcopy(value)
        end
        setmetatable(copy, library.Deepcopy(getmetatable(original)))
    else
        copy = original
    end
    
    return copy
end

-- Trigger server callback (ESX/QBCore compatible)
function library.Callback(name, callback, ...)
    if Config.Core == "ESX" then
        ESX.TriggerServerCallback(name, callback, ...)
    else
        QBCore.Functions.TriggerCallback(name, callback, ...)
    end
end

-- Async callback with promise
function library.CallbackAwait(name, ...)
    local p = promise.new()
    
    local function resolver(...)
        p:resolve(...)
    end
    
    if Config.Core == "ESX" then
        ESX.TriggerServerCallback(name, resolver, ...)
    else
        QBCore.Functions.TriggerCallback(name, resolver, ...)
    end
    
    return Citizen.Await(p)
end

-- Create a map blip
function library.CreateBlip(data)
    local blip = AddBlipForCoord(data.coords)
    
    SetBlipSprite(blip, data.sprite)
    SetBlipDisplay(blip, data.display)
    SetBlipScale(blip, data.scale)
    SetBlipColour(blip, data.color)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(blip)
    
    if data.blipCategory ~= nil then
        SetBlipCategory(blip, data.blipCategory)
    end
    
    return blip
end

-- Delete a blip
function library.DeleteBlip(blip)
    if blip then
        RemoveBlip(blip)
        return nil
    end
end

-- Request and load a model/entity
function library.RequestEntity(model)
    local success = true
    local timeout = GetGameTimer() + 5000
    
    local modelHash = tonumber(model) or GetHashKey(model)
    
    RequestModel(modelHash)
    
    while not HasModelLoaded(modelHash) do
        RequestModel(modelHash)
        
        if GetGameTimer() > timeout then
            success = false
            break
        end
        
        Wait(1)
    end
    
    return success
end

-- Spawn a ped with optional animation
function library.SpawnPed(data)
    library.RequestEntity(data.model)
    
    local heading = data.coords.w or 0.0
    local ped = CreatePed(4, data.model, data.coords.x, data.coords.y, data.coords.z, heading, false, true)
    
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    TaskSetBlockingOfNonTemporaryEvents(ped, true)
    
    if data.animation then
        library.PlayAnimation(ped, data.animation[1], data.animation[2], 8.0, 8.0, -1, 1)
    end
    
    return ped
end

-- Spawn a prop/object
function library.SpawnProp(model, coords, networked, attachData, disableCollision, dynamicEntity)
    local playerPed = PlayerPedId()
    local modelHash = tonumber(model) or GetHashKey(model)
    
    local spawnCoords = coords and vec(coords.x, coords.y, coords.z) or GetEntityCoords(playerPed)
    
    library.RequestEntity(modelHash)
    
    local dynamic = dynamicEntity or false
    local prop = CreateObject(modelHash, spawnCoords.xyz, networked, false, true, dynamic)
    
    if attachData then
        AttachEntityToEntity(
            prop,
            attachData.attachTo,
            attachData.boneIndex,
            attachData.placement[1],
            attachData.placement[2],
            attachData.placement[3],
            attachData.placement[4],
            attachData.placement[5],
            attachData.placement[6],
            true, true, false, true, 1, true
        )
    end
    
    if disableCollision then
        SetEntityCollision(prop, false, true)
    end
    
    return prop
end

-- Load animation dictionary
function library.LoadDict(dict)
    local timeout = false
    
    SetTimeout(5000, function()
        timeout = true
    end)
    
    repeat
        RequestAnimDict(dict)
        Wait(50)
    until HasAnimDictLoaded(dict) or timeout
end

-- Play animation with optional props
function library.PlayAnimation(ped, dict, anim, blendInSpeed, blendOutSpeed, duration, flag, prop1Data, prop2Data)
    library.LoadDict(dict)
    
    if prop1Data then
        library.IsHaveProp = library.SpawnProp(
            GetHashKey(prop1Data[1]),
            prop1Data[2],
            prop1Data[3],
            prop1Data[4],
            prop1Data[5]
        )
    end
    
    if prop2Data then
        library.IsHaveProp2 = library.SpawnProp(
            GetHashKey(prop2Data[1]),
            prop2Data[2],
            prop2Data[3],
            prop2Data[4],
            prop2Data[5]
        )
    end
    
    library.IsPlayingAnimation = true
    
    TaskPlayAnim(
        ped,
        dict,
        anim,
        blendInSpeed or 8.0,
        blendOutSpeed or 8.0,
        duration,
        flag,
        0,
        false, false, false
    )
end

-- Stop animation and delete props
function library.StopAnimation(ped)
    if library.IsHaveProp then
        DeleteEntity(library.IsHaveProp)
        library.IsHaveProp = nil
    end
    
    if library.IsHaveProp2 then
        DeleteEntity(library.IsHaveProp2)
        library.IsHaveProp2 = nil
    end
    
    if library.IsPlayingAnimation then
        ClearPedTasks(ped)
    end
    
    library.IsPlayingAnimation = false
end

-- Start particle effects
function library.StartParticles(asset, effectName, coords, rotation, scale, colorData)
    RequestNamedPtfxAsset(asset)
    
    while not HasNamedPtfxAssetLoaded(asset) do
        Citizen.Wait(10)
    end
    
    UseParticleFxAssetNextCall(asset)
    
    local particle = StartParticleFxLoopedAtCoord(
        effectName,
        coords.x, coords.y, coords.z,
        rotation.x, rotation.y, rotation.z,
        scale,
        0.0, 0.0, 0.0, 0
    )
    
    if colorData and colorData[1] then
        SetParticleFxLoopedColour(
            particle,
            tonumber(colorData[1]) + 0.0,
            tonumber(colorData[2]) + 0.0,
            tonumber(colorData[3]) + 0.0,
            false
        )
        
        if colorData[4] then
            SetParticleFxLoopedAlpha(particle, tonumber(colorData[4]) + 0.0)
        end
    end
    
    return particle
end

-- Stop particle effects
function library.StopParticles(particle)
    if DoesParticleFxLoopedExist(particle) then
        RemoveParticleFx(particle, false)
    end
end

-- Play audio through NUI
function library.PlayAudio(audioType)
    local audioFile = ""
    local volume = 0
    
    if audioType == "enterHouse" then
        audioFile = "enter_house"
        volume = 0.1
    elseif audioType == "exitHouse" then
        audioFile = "exit_house"
        volume = 0.1
    elseif audioType == "openDoors" then
        audioFile = "open_doors"
        volume = 0.1
    elseif audioType == "lockDoors" then
        audioFile = "lock_doors"
        volume = 0.05
    elseif audioType == "doorbell" then
        audioFile = "doorbell"
        volume = 0.005
    elseif audioType == "doorbellInside" then
        audioFile = "doorbell"
        volume = 0.1
    elseif audioType == "lightSwitch" then
        audioFile = "light_switch"
        volume = 0.12
    end
    
    if audioFile == "" then
        return
    end
    
    SendNUIMessage({
        action = "PlayAudio",
        file = audioFile,
        volume = volume
    })
end

-- Get current region based on coordinates
function library.GetCurrentRegion(coords)
    for regionId, regionData in pairs(Config.Regions) do
        if regionData.zone then
            if isPointInPolygon(coords, regionData.zone) then
                return regionId
            end
        end
    end
    
    return nil
end

-- Check if player has keys to property
function library.HasKeys(propertyId)
    local property = Properties[propertyId]
    
    if not property then
        return false
    end
    
    if not Config.UseKeysAsItem then
        -- Check if player is owner
        if property.owner == Identifier then
            return true
        end
        
        -- Check if player is renter
        if property.renter == Identifier then
            return true
        end
        
        -- Check if player has been given keys
        if property.keys and string.find(property.keys, Identifier) then
            return true
        end
        
        return false
    end
end

return library