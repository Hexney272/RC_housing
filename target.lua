-- Housing System Target Handler
-- Cleaned and deobfuscated version

TargetHandler = {}

-- ============================================
-- PROPERTY INTERACTION TARGETS
-- ============================================

function TargetHandler.ViewOffer(propertyId)
    return {
        name = "property-offer",
        icon = "fa-solid fa-scroll",
        label = TRANSLATE("target.view_house"),
        action = function()
            Property:ViewOffer(propertyId)
        end
    }
end

function TargetHandler.Enter(actionCallback, canInteractCallback)
    return {
        name = "property-enter",
        icon = "fa-solid fa-door-open",
        label = TRANSLATE("target.enter"),
        action = actionCallback,
        canInteract = canInteractCallback
    }
end

function TargetHandler.Furniture(canInteractCallback)
    return {
        name = "property-furniture",
        icon = "fa-solid fa-chair",
        label = TRANSLATE("target.furniture"),
        action = function()
            -- Check if already in furniture/theme mode
            if Property.EditingFurniture or Property.EditingTheme then
                return CL.Notification(
                    TRANSLATE("notify.furniture:you_are_in_furniture_mode"),
                    5000,
                    "info"
                )
            end
            
            openFurnitureMenu()
        end,
        canInteract = canInteractCallback
    }
end

function TargetHandler.Doorbell(propertyId)
    return {
        name = "property-doorbell",
        icon = "fa-solid fa-bell",
        label = TRANSLATE("target.doorbell"),
        action = function()
            TriggerServerEvent("vms_housing:sv:ringDoorbell", propertyId)
        end
    }
end

-- ============================================
-- LOCKPICK TARGET
-- ============================================

function TargetHandler.Lockpick(propertyId, hasAntiBurglaryDoors, hasAlarm, successCallback, canInteractCallback)
    local target = {
        name = "property-lockpick",
        icon = "fa-solid fa-unlock-keyhole",
        label = TRANSLATE("target.lockpick"),
        action = function()
            -- Alert police on lockpick start
            if DispatchAlertClient then
                if Config.Alarm.AlertPoliceOnLockpickStart then
                    if Config.Alarm.AlertPoliceOnlyWithUpgrade then
                        if Config.Alarm.AlertPoliceOnlyWithUpgrade and hasAlarm then
                            DispatchAlertClient(
                                Properties[tostring(propertyId)],
                                "start"
                            )
                        end
                    end
                end
            end
            
            -- Notify server
            TriggerServerEvent("vms_housing:sv:startedLockpickDoors", propertyId)
            
            -- Start lockpick minigame
            CL.Minigame("lockpick", function(success)
                if success then
                    -- Alert police on success
                    if DispatchAlertClient then
                        if Config.Alarm.AlertPoliceOnLockpickSuccess then
                            if Config.Alarm.AlertPoliceOnlyWithUpgrade then
                                if Config.Alarm.AlertPoliceOnlyWithUpgrade and hasAlarm then
                                    DispatchAlertClient(
                                        Properties[tostring(propertyId)],
                                        "success"
                                    )
                                end
                            end
                        end
                    end
                else
                    -- Alert police on failure
                    if DispatchAlertClient then
                        if Config.Alarm.AlertPoliceOnLockpickFail then
                            if Config.Alarm.AlertPoliceOnlyWithUpgrade then
                                if Config.Alarm.AlertPoliceOnlyWithUpgrade and hasAlarm then
                                    DispatchAlertClient(
                                        Properties[tostring(propertyId)],
                                        "failed"
                                    )
                                end
                            end
                        end
                    end
                end
                
                successCallback(success)
            end, {
                antiBurglaryDoors = hasAntiBurglaryDoors
            })
        end,
        canInteract = canInteractCallback
    }
    
    -- Add required item if configured
    if Config.Lockpick?.Item?.Required and Config.Lockpick?.Item?.Name then
        target.requiredItem = Config.Lockpick.Item.Name
    end
    
    return target
end

-- ============================================
-- POLICE INTERACTION TARGETS
-- ============================================

function TargetHandler.Lockdown(actionCallback, canInteractCallback)
    -- Check if lockdown is enabled
    if not (Config.PropertyLockdown and Config.PropertyLockdown.Enable) then
        return nil
    end
    
    local target = {
        name = "property-lockdown",
        icon = "fa-solid fa-road-barrier",
        label = TRANSLATE("target.lockdown"),
        action = actionCallback,
        canInteract = canInteractCallback
    }
    
    -- Add job restrictions
    if Config.PropertyLockdown.Jobs and next(Config.PropertyLockdown.Jobs) then
        target.jobs = Config.PropertyLockdown.Jobs
    end
    
    -- Add required item
    if Config.PropertyLockdown.Item?.Required and Config.PropertyLockdown.Item?.Name then
        target.requiredItem = Config.PropertyLockdown.Item.Name
    end
    
    return target
end

function TargetHandler.RemoveSeal(actionCallback, canInteractCallback)
    -- Check if lockdown is enabled
    if not (Config.PropertyLockdown and Config.PropertyLockdown.Enable) then
        return nil
    end
    
    local target = {
        name = "property-removeseal",
        icon = "fa-solid fa-lock-open",
        label = TRANSLATE("target.removeseal"),
        action = actionCallback,
        canInteract = canInteractCallback
    }
    
    -- Add job restrictions
    if Config.PropertyLockdown.Jobs and next(Config.PropertyLockdown.Jobs) then
        target.jobs = Config.PropertyLockdown.Jobs
    end
    
    return target
end

function TargetHandler.Raid(propertyId, successCallback, canInteractCallback)
    -- Check if raids are enabled
    if not (Config.PropertyRaids and Config.PropertyRaids.Enable) then
        return nil
    end
    
    local target = {
        name = "property-raid",
        icon = "fa-solid fa-person-walking-arrow-right",
        label = TRANSLATE("target.raid"),
        action = function()
            -- Check if player is allowed to raid
            local allowed = library.CallbackAwait(
                "vms_housing:isAllowedToRaid",
                propertyId or GetCurrentPropertyId()
            )
            
            if not allowed then
                return
            end
            
            local ped = PlayerPedId()
            local property = propertyId and Properties[propertyId] or GetCurrentPropertyData()
            
            -- Play animation
            library.PlayAnimation(
                ped,
                "missheistfbi3b_ig7",
                "lift_fibagent_loop",
                8.0, 8.0, -1, 1
            )
            
            -- Start raid minigame
            CL.Minigame("police_raid", function(success)
                library.StopAnimation(ped)
                successCallback(success)
            end, {
                antiBurglaryDoors = property.metadata?.upgrades?.antiBurglaryDoors
            })
        end,
        canInteract = canInteractCallback
    }
    
    -- Add job restrictions
    if Config.PropertyRaids.Jobs and next(Config.PropertyRaids.Jobs) then
        target.jobs = Config.PropertyRaids.Jobs
    end
    
    -- Add required item
    if Config.PropertyRaids.Item?.Required and Config.PropertyRaids.Item?.Name then
        target.requiredItem = Config.PropertyRaids.Item.Name
    end
    
    return target
end

function TargetHandler.RaidLock(actionCallback, canInteractCallback)
    -- Check if raids are enabled
    if not (Config.PropertyRaids and Config.PropertyRaids.Enable) then
        return nil
    end
    
    local target = {
        name = "property-complete_raid",
        icon = "fa-solid fa-door-closed",
        label = TRANSLATE("target.complete_raid"),
        action = actionCallback,
        canInteract = canInteractCallback
    }
    
    -- Add job restrictions
    if Config.PropertyRaids.Jobs and next(Config.PropertyRaids.Jobs) then
        target.jobs = Config.PropertyRaids.Jobs
    end
    
    return target
end

-- ============================================
-- STORAGE & WARDROBE TARGETS
-- ============================================

function TargetHandler.Storage(propertyId, x, y, z, slots, weight)
    local option = {
        name = "property-storage",
        icon = "fa-solid fa-boxes-stacked",
        label = TRANSLATE("target.storage"),
        action = function()
            -- Check if in furniture mode
            if Property.EditingFurniture or Property.EditingTheme then
                return CL.Notification(
                    TRANSLATE("notify.furniture:you_are_in_furniture_mode"),
                    5000,
                    "info"
                )
            end
            
            OpenStorage({
                id = "house_storage-" .. propertyId,
                slots = slots,
                weight = weight
            })
        end
    }
    
    -- Set access level
    if Config.StaticInteractionAccess == 2 then
        option.canInteract = function()
            return library.HasAnyPermission(propertyId)
        end
    elseif Config.StaticInteractionAccess == 3 then
        option.canInteract = function()
            return library.HasPermissions(propertyId, "furniture")
        end
    end
    
    return {
        type = "storage",
        id = CL.Target("zone", {
            coords = vector3(x, y, z),
            size = vec(1.5, 1.5, 2.0),
            rotation = 0.0,
            options = { option }
        })
    }
end

function TargetHandler.Wardrobe(propertyId, x, y, z)
    local option = {
        name = "property-wardrobe",
        icon = "fa-solid fa-shirt",
        label = TRANSLATE("target.wardrobe"),
        action = function()
            -- Check if in furniture mode
            if Property.EditingFurniture or Property.EditingTheme then
                return CL.Notification(
                    TRANSLATE("notify.furniture:you_are_in_furniture_mode"),
                    5000,
                    "info"
                )
            end
            
            OpenWardrobe()
        end
    }
    
    -- Set access level
    if Config.StaticInteractionAccess == 2 then
        option.canInteract = function()
            return library.HasAnyPermission(propertyId)
        end
    elseif Config.StaticInteractionAccess == 3 then
        option.canInteract = function()
            return library.HasPermissions(propertyId, "furniture")
        end
    end
    
    return {
        type = "wardrobe",
        id = CL.Target("zone", {
            coords = vector3(x, y, z),
            size = vec(1.5, 1.5, 2.0),
            rotation = 0.0,
            options = { option }
        })
    }
end

-- ============================================
-- MANAGEMENT TARGETS
-- ============================================

function TargetHandler.Manage(propertyId, canInteractCallback)
    return {
        name = "property-manage",
        icon = "fa-solid fa-gear",
        label = TRANSLATE("target.manage"),
        action = function()
            -- Check if in furniture mode
            if Property.EditingFurniture or Property.EditingTheme then
                return CL.Notification(
                    TRANSLATE("notify.furniture:you_are_in_furniture_mode"),
                    5000,
                    "info"
                )
            end
            
            openManageMenu(propertyId)
        end,
        canInteract = canInteractCallback
    }
end

function TargetHandler.ToggleLock(propertyId, canInteractCallback)
    return {
        name = "property-lock",
        icon = "fa-solid fa-key",
        label = TRANSLATE("target.toggle_lock"),
        action = function()
            Property:ToggleLock(propertyId)
        end,
        canInteract = canInteractCallback
    }
end