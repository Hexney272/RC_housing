-- Discord Webhooks
OBJECTS_PHOTOS_TOOL_WEBHOOK = nil
MARKETPLACE_PHOTOS_WEBHOOK = nil

-- State variables
waitingForLoadAfterRestart = true

-- Data tables
AlarmBlips = {}
Blips = {}
TargetPoints = {}
Properties = {}
Furniture = {}

-- Current state
CurrentShell = nil
CurrentIPL = nil
CurrentProperty = nil
CurrentPropertyData = nil
SelectedApartment = nil
openedMenu = nil

-- Player data
PlayerData = {}
Identifier = nil
CharacterName = ""

-- Initialize framework (ESX or QBCore)
if Config.Core == "ESX" then
    ESX = Config.CoreExport()
elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()
end

-- Player initialization function
local function InitializePlayer(waitTime, playerData)
    Citizen.CreateThread(function()
        PlayerData = playerData
        Identifier = CL.GetPlayerIdentifier()
        CharacterName = CL.GetPlayerCharacterName()
        
        SpawnInLastProperty()
        TriggerEvent("vms_housing:init")
        
        -- Wait for UI to load
        Citizen.Wait(waitTime and 5000 or 0)
        
        -- Send character name to UI
        SendNUIMessage({
            action = "loaded2",
            characterName = CharacterName
        })
        
        -- Request data from server
        TriggerServerEvent("vms_housing:sv:fetchData")
    end)
end

-- Register notification event with debug
RegisterNetEvent("vms_housing:notification")
AddEventHandler("vms_housing:notification", function(message, time, type)
    CL.Notification(message, time, type)
end)

-- Handle resource start
AddEventHandler("onResourceStart", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    
    -- Reset menu state on resource restart
    openedMenu = nil
    SetNuiFocus(false, false)
    
    -- Wait for framework to load
    if Config.Core == "ESX" then
        while not ESX do
            Citizen.Wait(100)
        end
    else
        while not QBCore do
            Citizen.Wait(100)
        end
    end

    -- Check if player is in a property after resource restart
    Citizen.CreateThread(function()
        Citizen.Wait(2000) -- Wait for everything to load
        
        -- Check if player is at shell height (around z=500)
        local playerCoords = GetEntityCoords(PlayerPedId())
        if playerCoords.z > 450 and playerCoords.z < 550 then
            -- Player is likely in a shell, but we've lost track of which property
            -- Best to teleport them out for safety
            SetEntityCoords(PlayerPedId(), 195.17, -933.77, 29.7, false, false, false, false)
        end
    end)

    -- Initialize player if already loaded
    if CL.IsPlayerLoaded() then
        InitializePlayer(true, CL.GetPlayerData())
    end
end)

-- Handle resource stop - cleanup
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Exit current property
        if CurrentProperty then
            TriggerServerEvent("vms_housing:sv:exitHouse", CurrentProperty)
            
            if ToggleWeather then
                ToggleWeather(false)
            end
            
            if CurrentShell then
                DeleteObject(CurrentShell)
            end
        end
        
        -- Remove all furniture
        Property:RemoveFurniture()
        
        -- Delete marketplace ped
        if Config.Marketplace.__ped then
            DeleteEntity(Config.Marketplace.__ped)
        end
    end
end)

-- Handle player loaded event
RegisterNetEvent(Config.PlayerLoaded, function(playerData)
    local data = playerData
    
    -- Get player data based on framework
    if Config.Core ~= "ESX" then
        data = CL.GetPlayerData()
    end
    
    InitializePlayer(false, data)
end)

-- Handle job update
RegisterNetEvent(Config.PlayerSetJob, function(job)
    PlayerData.job = job
end)

-- Load properties from server
RegisterNetEvent("vms_housing:cl:loadProperties", function(propertiesJson)
    
    if not propertiesJson then
        print("^1[vms_housing] ERROR: Properties data is nil!^7")
        return
    end
    
    Properties = json.decode(propertiesJson)
    
    -- Count properties
    local propCount = 0
    for _ in pairs(Properties) do
        propCount = propCount + 1
    end
    
    -- Update current property data if inside a property
    if CurrentProperty then
        CurrentPropertyData = Properties[tostring(CurrentProperty)]
    end
    
    -- Register doors for MLO properties
    for propertyId, propertyData in pairs(Properties) do
        if propertyData.type == "mlo" and propertyData.metadata and propertyData.metadata.doors then
            Property:RegisterDoors({
                propertyId = propertyId,
                forceLock = not propertyData.owner and not propertyData.renter,
                doors = propertyData.metadata.doors
            })
        end
    end
    
    -- Refresh blips and targets to show loaded properties
    RefreshBlips()
    RefreshTargets()
end)

-- Load furniture from server
RegisterNetEvent("vms_housing:cl:loadFurniture", function(furnitureJson)
    Furniture = json.decode(furnitureJson)
    
    -- Update UI with available furniture
    SendNUIMessage({
        action = "Property",
        actionName = "ReloadAvailableFurniture",
        data = Furniture
    })
end)

-- Handle initial data fetch from server
RegisterNetEvent("vms_housing:cl:fetchedData", function(objectsWebhook, marketplaceWebhook)
    waitingForLoadAfterRestart = false
    
    OBJECTS_PHOTOS_TOOL_WEBHOOK = objectsWebhook
    MARKETPLACE_PHOTOS_WEBHOOK = marketplaceWebhook
    
    -- Send webhook to UI
    SendNUIMessage({
        action = "LoadWebhook",
        webhook = OBJECTS_PHOTOS_TOOL_WEBHOOK
    })
    
    -- Refresh blips and targets after loading properties
    RefreshBlips()
    RefreshTargets()
    
    -- Debug logging
    if Config.Debug then
        Citizen.CreateThread(function()
            -- Count and log properties
            local propertyCount = 0
            for _ in pairs(Properties) do
                propertyCount = propertyCount + 1
            end
            library.Debug(string.format("^4[Loaded]^7 Loaded %s Properties!", propertyCount))
            
            -- Count and log furniture
            local furnitureCount = 0
            for _ in pairs(Furniture) do
                furnitureCount = furnitureCount + 1
            end
            library.Debug(string.format("^4[Loaded]^7 Loaded %s Furniture!", furnitureCount))
        end)
    end
    
    RefreshBlips()
end)

-- Setup marketplace ped and blip
local function SetupMarketplace()
    local marketplace = Config.Marketplace
    
    if not marketplace.Enabled then
        return
    end
    
    -- Spawn marketplace ped
    if marketplace.Ped and marketplace.Ped.Model and marketplace.Ped.Coords then
        marketplace.__ped = library.SpawnPed({
            model = marketplace.Ped.Model,
            coords = marketplace.Ped.Coords,
            animation = marketplace.Ped.Animation
        })
    end
    
    -- Create marketplace blip
    if marketplace.Blip and marketplace.BlipCoords then
        marketplace.__blip = library.CreateBlip({
            coords = marketplace.BlipCoords,
            sprite = marketplace.Blip.sprite,
            display = marketplace.Blip.display,
            scale = marketplace.Blip.scale,
            color = marketplace.Blip.color,
            name = marketplace.Blip.name
        })
    end
    
    -- Create target interaction zone
    CL.Target("zone", {
        coords = marketplace.TargetCoords.xyz,
        rotation = marketplace.TargetCoords.w,
        size = marketplace.TargetSize,
        options = {
            {
                name = "marketplace",
                icon = "fa-solid fa-building",
                label = TRANSLATE("target.marketplace"),
                action = function()
                    openMarketplace()
                end
            }
        }
    })
end

-- Initialize script on start
Citizen.CreateThread(function()
    Citizen.Wait(2000)
    
    -- Log compatibility checks
    library.Debug(
        Config.Weather 
        and string.format("^2[Compatibility]^7 Found Compatible Weather: ^3%s^7", Config.Weather)
        or "^1[Compatibility]^7 No compatible weather found!"
    )
    
    library.Debug(
        Config.Clothing
        and string.format("^2[Compatibility]^7 Found Compatible Clothing: ^3%s^7", Config.Clothing)
        or "^1[Compatibility]^7 No compatible clothing found!"
    )
    
    library.Debug(
        Config.Garages
        and string.format("^2[Compatibility]^7 Found Compatible Garage: ^3%s^7", Config.Garages)
        or "^1[Compatibility]^7 No compatible garage found!"
    )
    
    library.Debug(
        Config.Inventory
        and string.format("^2[Compatibility]^7 Found Compatible Inventory: ^3%s^7", Config.Inventory)
        or "^1[Compatibility]^7 No compatible inventory found!"
    )
    
    -- Setup marketplace
    SetupMarketplace()
end)