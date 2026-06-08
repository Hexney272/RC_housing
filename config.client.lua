CL = {}

-- ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
-- ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
-- ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
-- ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
-- ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
-- ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
CL.Notification = function(message, time, type)
    if type == "success" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("", message, time, "#36f230", "fa-solid fa-house")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'success', time)
        end
    elseif type == "error" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("", message, time, "#f23030", "fa-solid fa-house")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'error', time)
        end
    elseif type == "info" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("", message, time, "#4287f5", "fa-solid fa-house")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'primary', time)
        end
    elseif type == "dispatch" then
        if GetResourceState("vms_notify") == 'started' then
            exports['vms_notify']:Notification("", message, time, "#429aff", "fa-solid fa-person-through-window")
        else
            TriggerEvent('esx:showNotification', message)
            TriggerEvent('QBCore:Notify', message, 'primary', time)
        end
    end
end



-- ██╗  ██╗██╗   ██╗██████╗ 
-- ██║  ██║██║   ██║██╔══██╗
-- ███████║██║   ██║██║  ██║
-- ██╔══██║██║   ██║██║  ██║
-- ██║  ██║╚██████╔╝██████╔╝
-- ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
CL.Hud = {
    Enable = function()
        if GetResourceState('vms_hud') ~= 'missing' then
            exports['vms_hud']:Display(true)
        end
    end,
    Disable = function()
        if GetResourceState('vms_hud') ~= 'missing' then
            exports['vms_hud']:Display(false)
        end
    end
}



-- ████████╗ █████╗ ██████╗  ██████╗ ███████╗████████╗
-- ╚══██╔══╝██╔══██╗██╔══██╗██╔════╝ ██╔════╝╚══██╔══╝
--    ██║   ███████║██████╔╝██║  ███╗█████╗     ██║   
--    ██║   ██╔══██║██╔══██╗██║   ██║██╔══╝     ██║   
--    ██║   ██║  ██║██║  ██║╚██████╔╝███████╗   ██║   
--    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   
CL.Target = function(type, data)
    if type == 'zone' then
        if Config.TargetResource == 'ox_target' then
            local options = {}
            
            if data.options and next(data.options) then
                for k, v in pairs(data.options) do
                    options[#options + 1] = {
                        name = v.name,
                        icon = v.icon,
                        label = v.label,
                        onSelect = v.action,
                        canInteract = v.canInteract,
                        distance = v.distance or 1.2,
                        items = v.requiredItem,
                        groups = v.jobs,
                    }
                end
            end

            return exports['ox_target']:addBoxZone({
                coords = vec(data.coords.x, data.coords.y, data.coords.z-0.5),
                size = data.size,
                debug = Config.DebugTarget,
                useZ = true,
                rotation = data.rotation or 0.0,
                options = options
            })
        elseif Config.TargetResource == 'qb-target' then
            local uniqueName = 'vms_housing-'..math.random(1000000, 9999999999)
            local options = {}

            if data.options and next(data.options) then
                for k, v in pairs(data.options) do
                    options[#options + 1] = {
                        num = #options + 1,
                        icon = v.icon,
                        label = v.label,
                        action = v.action,
                        canInteract = v.canInteract,
                        distance = v.distance or 1.2,
                        item = v.requiredItem,
                        job = v.jobs,
                    }
                end
            end

            exports['qb-target']:AddBoxZone(
                uniqueName,
                vec(data.coords.x, data.coords.y, data.coords.z),
                data.size and data.size.x or 1.2,
                data.size and data.size.y or 1.2,
                {
                    name = uniqueName,
                    heading = data.rotation and data.rotation - 90.0 or 0.0,
                    debugPoly = false,
                    minZ = data.coords.z - (data.size and data.size.y or 1.2),
                    maxZ = data.coords.z + (data.size and data.size.y or 1.2),
                },
                {
                    options = options,
                    distance = 1.2,
                }
            )

            return uniqueName
        else
            warn('You need to prepare CL.Target for the target system')
        end
        
    elseif type == 'remove-zone' then
        if Config.TargetResource == 'ox_target' then
            exports['ox_target']:removeZone(data)
        elseif Config.TargetResource == 'qb-target' then
            exports['qb-target']:RemoveZone(data)
        else
            warn('You need to prepare CL.Target for the target system')
        end
        
    elseif type == 'entity' then
        if Config.TargetResource == 'ox_target' then
            local options = {}
            
            if data.options and next(data.options) then
                for k, v in pairs(data.options) do
                    local icon = v.icon or 'fa-solid fa-bars' -- Default Icon

                    if v.interactableName then
                        if v.interactableName == 'delivery' then
                            icon = 'fa-solid fa-box-open'
                        elseif v.interactableName == 'storage' then
                            icon = 'fa-solid fa-box'
                        elseif v.interactableName == 'wardrobe' then
                            icon = 'fa-solid fa-shirt'
                        elseif v.interactableName == 'device' then
                            icon = 'fa-solid fa-laptop'
                        elseif v.interactableName == 'door' then
                            icon = 'fa-solid fa-door-closed'
                        end
                    end
                    
                    options[#options + 1] = {
                        name = v.name,
                        icon = icon,
                        label = v.label,
                        distance = v.distance or 1.2,
                        items = v.requiredItem,
                        groups = v.jobs,
                        onSelect = v.action,
                        canInteract = v.canInteract,
                    }
                end
            end

            exports['ox_target']:addLocalEntity(data.entity, options)
        elseif Config.TargetResource == 'qb-target' then
            local options = {}
            
            if data.options and next(data.options) then
                for k, v in pairs(data.options) do
                    local icon = v.icon or 'fa-solid fa-bars' -- Default Icon

                    if v.interactableName then
                        if v.interactableName == 'delivery' then
                            icon = 'fa-solid fa-box-open'
                        elseif v.interactableName == 'storage' then
                            icon = 'fa-solid fa-box'
                        elseif v.interactableName == 'wardrobe' then
                            icon = 'fa-solid fa-shirt'
                        elseif v.interactableName == 'device' then
                            icon = 'fa-solid fa-laptop'
                        elseif v.interactableName == 'door' then
                            icon = 'fa-solid fa-door-closed'
                        end
                    end
                    
                    options[#options + 1] = {
                        num = #options + 1,
                        icon = icon,
                        label = v.label,
                        distance = v.distance or 1.2,
                        item = v.requiredItem,
                        job = v.jobs,
                        action = v.action,
                        canInteract = v.canInteract,
                    }
                end
            end
            
            exports['qb-target']:AddTargetEntity(data.entity, {
                options = options,
                distance = 1.2
            })
        else
            warn('You need to prepare CL.Target for the target system')
        end
        
    elseif type == 'remove-entity' then
        if Config.TargetResource == 'ox_target' then
            exports['ox_target']:removeLocalEntity(data)
        elseif Config.TargetResource == 'qb-target' then
            exports['qb-target']:RemoveTargetEntity(data)
        else
            warn('You need to prepare CL.Target for the target system')
        end

    end
end



-- ███╗   ███╗██╗███╗   ██╗██╗ ██████╗  █████╗ ███╗   ███╗███████╗███████╗
-- ████╗ ████║██║████╗  ██║██║██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔════╝
-- ██╔████╔██║██║██╔██╗ ██║██║██║  ███╗███████║██╔████╔██║█████╗  ███████╗
-- ██║╚██╔╝██║██║██║╚██╗██║██║██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ╚════██║
-- ██║ ╚═╝ ██║██║██║ ╚████║██║╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗███████║
-- ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝
CL.Minigame = function(type, cb, data)
    if type == 'lockpick' then
        -- Check for ox_lib first
        if GetResourceState('ox_lib') == 'started' then
            local difficulty = {'easy', 'easy', 'medium'}
            if data.antiBurglaryDoors then
                difficulty = {'easy', 'easy', 'medium', 'hard'}
            end
            
            local success = lib.skillCheck(difficulty, {'w', 'a', 's', 'd'})
            cb(success)
        -- Fall back to t3_lockpick
        elseif GetResourceState('t3_lockpick') == 'started' then
            local difficulty = {
                strength = 0.55,
                difficulty = 2,
                pins = 5
            }
            if data.antiBurglaryDoors then
                difficulty = {
                    strength = 0.2,
                    difficulty = 1,
                    pins = 6
                }
            end

            local result = exports['t3_lockpick']:startLockpick(difficulty.strength, difficulty.difficulty, difficulty.pins)
            cb(result)
        else
            warn('No lockpick resource found! Please install ^2ox_lib^7 or ^2t3_lockpick^7')
            return cb(false)
        end

    elseif type == 'police_raid' then
        -- Check for ox_lib first
        if GetResourceState('ox_lib') == 'started' then
            local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}, 'medium'}, {'w', 'a', 's', 'd'})
            cb(success)
        -- Fall back to tgiann-skillbar
        elseif GetResourceState('tgiann-skillbar') == 'started' then
            local finished = exports["tgiann-skillbar"]:taskBar(3000)
            cb(finished)
        else
            warn('No skillbar resource found! Please install ^2ox_lib^7 or ^2tgiann-skillbar^7')
            return cb(false)
        end

    end
end



-- ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
-- ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
-- █████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
-- ██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
-- ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
-- ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
CL.IsPlayerLoaded = function(type)
    if Config.Core == "ESX" then
        return ESX.IsPlayerLoaded()
    elseif Config.Core == "QB-Core" then
        return CL.GetPlayerData() and CL.GetPlayerData().job ~= nil
    end
end

CL.GetPlayerData = function(type)
    if Config.Core == "ESX" then
        return ESX.GetPlayerData()
    elseif Config.Core == "QB-Core" then
        return QBCore.Functions.GetPlayerData()
    end
end

CL.GetPlayerIdentifier = function()
    if Config.Core == "ESX" then
        return PlayerData.identifier
    elseif Config.Core == "QB-Core" then
        return PlayerData.citizenid
    end
end

CL.GetPlayerCharacterName = function()
    if Config.Core == "ESX" then
        return PlayerData.firstName .. ' ' .. PlayerData.lastName
    elseif Config.Core == "QB-Core" then
        return PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname
    end
end

CL.GetPlayerJob = function(type)
    if Config.Core == "ESX" and PlayerData.job then
        if type == "table" then
            return PlayerData.job
        end
        if type == "name" then
            return PlayerData.job.name
        end
        if type == "label" then
            return PlayerData.job.label
        end
        if type == "grade" then
            return PlayerData.job.grade
        end
        if type == "grade_name" then
            return PlayerData.job.grade_name
        end
    elseif Config.Core == "QB-Core" and PlayerData.job then
        if type == "table" then
            return PlayerData.job
        end
        if type == "name" then
            return PlayerData.job.name
        end
        if type == "label" then
            return PlayerData.job.label
        end
        if type == "grade" then
            return PlayerData.job.grade.level
        end
        if type == "grade_name" then
            return PlayerData.job.grade.name
        end
    end
    return nil
end

CL.GetClosestPlayers = function()
    if Config.Core == "ESX" then
        return ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)
    elseif Config.Core == "QB-Core" then
        return QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 5.0)
    end
end



-- ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
-- ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
-- ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
-- ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
--  ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
--   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝
CL.HandleAction = function(action)
    if action == 'enterInteriorPreview' then -- enterInteriorPreview: is called when the player enters the interior preview in the bid using the "Check Inside" button
        if Config.Inventory == 'ox_inventory' then
            LocalPlayer.state.invBusy = true -- Lock player inventory during preview
            LocalPlayer.state.canUseWeapons = false
        end
        if Config.Inventory == 'qb-inventory' then
            LocalPlayer.state:set('inv_busy', true, true) -- Lock player inventory during preview
        end
        if Config.Inventory == 'qs-inventory' then
            exports['qs-inventory']:setInventoryDisabled(true) -- Lock player inventory during preview
        end

    elseif action == 'exitInteriorPreview' then -- exitInteriorPreview: is called when the player exits the interior preview
        if Config.Inventory == 'ox_inventory' then
            LocalPlayer.state.invBusy = false -- Unlock the player's inventory after previewing
            LocalPlayer.state.canUseWeapons = true -- Unlock the player's inventory after previewing
        end
        if Config.Inventory == 'qb-inventory' then
            LocalPlayer.state:set('inv_busy', true, true) -- Unlock the player's inventory after previewing
        end
        if Config.Inventory == 'qs-inventory' then
            exports['qs-inventory']:setInventoryDisabled(false) -- Unlock the player's inventory after previewing
        end
        
    end
end

CL.CanEnterHouse = function()
    -- This function is triggered when a player tries to enter the property.
    -- You can return false to block access, for example if they are handcuffed or anything else

    if IsEntityDead(PlayerPedId()) then
        return false
    end

    return true
end

CL.CanExitHouse = function()
    -- This function is triggered when a player tries to exit the property.
    -- You can return false to block access, for example if they are handcuffed or anything else

    return true
end

CL.InteractableFurniture = function(model, type, furnitureId, metadata)
    if type == 'wardrobe' then
        OpenWardrobe()

    elseif type == 'storage' then
        OpenStorage(metadata)
        
    elseif type == 'safe' then
        OpenSafe(furnitureId, metadata)

    elseif type == 'device' then
        openManageMenu(nil, true)

    elseif type == 'sink' then
        local timeUsage = metadata.option.timeUsage or 7000
        local myPed = PlayerPedId()
        SetEntityCoords(myPed, metadata.option.coords.player.xyz)
        SetEntityHeading(myPed, metadata.option.coords.player.w)
        FreezeEntityPosition(myPed, true)
        Citizen.Wait(100)
        local particle = library.StartParticles('core', 'water_cannon_jet', metadata.option.coords.particles, vector3(-70.0, 180.0, 0.0), 0.5)
        library.PlayAnimation(myPed, 'missheist_agency3aig_23', 'urinal_sink_loop', 8.0, 8.0, timeUsage, 1)
        
        -- Update player hygiene status
        if Config.Core == "ESX" then
            TriggerEvent('esx_status:add', 'hygiene', 200000)
        elseif Config.Core == "QB-Core" then
            TriggerServerEvent('hud:server:RelieveStress', 2)
        end
        
        Citizen.Wait(timeUsage + 200)
        FreezeEntityPosition(myPed, false)
        library.StopParticles(particle)

    elseif type == 'sink_drink' then
        local timeUsage = metadata.option.timeUsage or 5000
        local myPed = PlayerPedId()
        SetEntityCoords(myPed, metadata.option.coords.player.xyz)
        SetEntityHeading(myPed, metadata.option.coords.player.w)
        FreezeEntityPosition(myPed, true)
        library.PlayAnimation(myPed, 'anim@scripted@player@fix_drink_juice@heeled@', 'drink_wheatgrass_stage1', 8.0, 4.0, timeUsage, 1, {
            'lts_prop_tumbler_01_s2', nil, false, {
                attachTo = myPed,
                boneIndex = GetPedBoneIndex(myPed, 57005),
                placement = {0.124000, 0.024000, -0.064000, -86.069855, 215.931122, -369.073578}
            }, true, false
        })
        Citizen.Wait(1250)
        local particle = library.StartParticles('core', 'water_cannon_jet', metadata.option.coords.particles, vector3(-70.0, 180.0, 0.0), 0.5)
        
        -- Update player thirst status
        if Config.Core == "ESX" then
            TriggerEvent('esx_status:add', 'thirst', 300000)
        elseif Config.Core == "QB-Core" then
            TriggerServerEvent('hud:server:UpdateNeeds', 'thirst', 100)
        end
        
        Citizen.Wait(2000)
        library.StopParticles(particle)
        Citizen.Wait(timeUsage - 3250)
        FreezeEntityPosition(myPed, false)
        library.StopAnimation(myPed)

    elseif type == 'shower' then
        local timeUsage = metadata.option.timeUsage or 10000
        local myPed = PlayerPedId()
        FreezeEntityPosition(myPed, true)
        SetEntityCoords(myPed, metadata.option.coords.player.xyz)
        SetEntityHeading(myPed, metadata.option.coords.player.w)
        Citizen.Wait(100)
        local particle = library.StartParticles('core', 'water_cannon_jet', metadata.option.coords.particles, vector3(-80.0, 180.0, 0.0), 0.7)
        library.PlayAnimation(myPed, 'mp_safehouseshower@female@', 'shower_idle_a', 8.0, 8.0, timeUsage, 1)
        
        -- Update player hygiene and stress status
        if Config.Core == "ESX" then
            TriggerEvent('esx_status:add', 'hygiene', 500000)
            TriggerEvent('esx_status:remove', 'stress', 200000)
        elseif Config.Core == "QB-Core" then
            TriggerServerEvent('hud:server:RelieveStress', 5)
            TriggerServerEvent('hud:server:UpdateNeeds', 'hygiene', 100)
        end
        
        Citizen.Wait(timeUsage + 200)
        FreezeEntityPosition(myPed, false)
        library.StopParticles(particle)

    end
end



--  ██████╗ ██╗  ██╗    ██╗███╗   ██╗██╗   ██╗███████╗███╗   ██╗████████╗ ██████╗ ██████╗ ██╗   ██╗    ███╗   ███╗███████╗████████╗ █████╗ ██████╗  █████╗ ████████╗ █████╗ 
-- ██╔═══██╗╚██╗██╔╝    ██║████╗  ██║██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝    ████╗ ████║██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
-- ██║   ██║ ╚███╔╝     ██║██╔██╗ ██║██║   ██║█████╗  ██╔██╗ ██║   ██║   ██║   ██║██████╔╝ ╚████╔╝     ██╔████╔██║█████╗     ██║   ███████║██║  ██║███████║   ██║   ███████║
-- ██║   ██║ ██╔██╗     ██║██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ██║   ██║██╔══██╗  ╚██╔╝      ██║╚██╔╝██║██╔══╝     ██║   ██╔══██║██║  ██║██╔══██║   ██║   ██╔══██║
-- ╚██████╔╝██╔╝ ██╗    ██║██║ ╚████║ ╚████╔╝ ███████╗██║ ╚████║   ██║   ╚██████╔╝██║  ██║   ██║       ██║ ╚═╝ ██║███████╗   ██║   ██║  ██║██████╔╝██║  ██║   ██║   ██║  ██║
--  ╚═════╝ ╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
Citizen.CreateThread(function()
    Citizen.Wait(500)
    if GetResourceState('ox_inventory') ~= 'missing' then
        exports.ox_inventory:displayMetadata({
            propertyId = 'Property',
            keySerialNumber = 'Serial',
        });
    end
end)