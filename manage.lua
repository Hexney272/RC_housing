-- Property Management Menu System
-- Handles opening and managing property UI for owners and renters
-- Includes permissions, bills, furniture, upgrades, and marketplace features

-- ============================================================================
-- Global Variables
-- ============================================================================

local lastPropertyChecked = nil
local cacheExpirationTime = nil

-- ============================================================================
-- Open Property Management Menu
-- ============================================================================
-- @param propertyId: ID of the property to manage (optional, uses current property if not provided)
-- @param isDevice: Boolean indicating if opened from a device/tablet
function openManageMenu(propertyId, isDevice)
    
    -- Set motel management ID if provided
    if propertyId then
        MotelManageId = propertyId
    end
    
    -- Determine which property to manage
    if not propertyId then
        propertyId = CurrentProperty or GetCurrentPropertyId()
    end
    
    if not propertyId then
        print("^1[vms_housing] No property ID available^7")
        CL.Notification(TRANSLATE("notify.you_are_not_in_house"), 5000, "error")
        return
    end
    
    -- Get property data
    local propertyData
    if Properties[propertyId] then
        propertyData = Properties[propertyId]
    else
        propertyData = CurrentPropertyData or GetCurrentPropertyData()
    end
    
    if not propertyData then
        print("^1[vms_housing] No property data found^7")
        return
    end
    
    -- Check if player has any permissions for this property
    
    if not library.HasAnyPermission(propertyId) then
        print("^1[vms_housing] Player has no permissions for this property^7")
        CL.Notification(TRANSLATE("notify.you_dont_have_permission"), 5000, "error")
        return
    end
    
    -- Determine if player is inside the property
    local isInside = false
    local isNotInside = false
    
    if propertyData.type == "shell" then
        if CurrentShell then
            isInside = true
        else
            isNotInside = true
        end
    elseif propertyData.type == "ipl" then
        if CurrentIPL then
            isInside = true
        else
            isNotInside = true
        end
    elseif propertyData.type == "mlo" then
        isInside = IsInsideMLO()
        isNotInside = not isInside
    end
    
    -- Get region configuration
    local regionConfig = Config.Regions[propertyData.region] or Config.NoRegion
    
    -- Fetch or use cached property data
    local serverData = nil
    local shouldFetchData = false
    
    if cacheExpirationTime then
        local currentTime = GetGameTimer()
        if currentTime > cacheExpirationTime or lastPropertyChecked ~= propertyId then
            shouldFetchData = true
        end
    else
        shouldFetchData = true
    end
    
    if shouldFetchData then
        local dataPromise = promise.new()
        
        library.Callback("vms_housing:openManageMenu", function(data)
            -- Cache for 60 seconds
            cacheExpirationTime = GetGameTimer() + 60000
            dataPromise:resolve(data)
        end, propertyId)
        
        lastPropertyChecked = propertyId
        serverData = Citizen.Await(dataPromise)
        
        -- Update cached property data
        Properties[propertyId].bills = serverData.bills
        Properties[propertyId].unpaidRentBills = serverData.unpaidRentBills
        Properties[propertyId].unpaidBills = serverData.unpaidBills
    end
    
    -- Check ownership and renter status
    local isOwner = propertyData.owner and propertyData.owner == Identifier
    local isRenter = propertyData.renter and propertyData.renter == Identifier
    
    -- Build NUI message data
    local menuData = {
        action = "Property",
        actionName = "OpenManage",
        data = {
            -- Property type and status
            type = propertyData.type,
            isObject = propertyData.object_id ~= nil,
            isDevice = isDevice,
            isOwner = isOwner,
            isRenter = isRenter,
            
            -- Renter information
            renter = propertyData.renter,
            renterName = propertyData.renter_name,
            
            -- Permissions
            myPermissions = propertyData.permissions[Identifier] or {},
            
            -- Bills and finances
            bills = propertyData.bills,
            unpaidBills = propertyData.unpaidBills,
            unpaidRentBills = propertyData.unpaidRentBills,
            
            -- Keys and deliveries
            keys = json.decode(propertyData.keys),
            deliveries = Config.Deliveries,
            
            -- Property information
            name = propertyData.name,
            description = propertyData.description,
            address = propertyData.address,
            region = propertyData.region,
            
            -- Utilities (from region config)
            electricity = regionConfig and regionConfig.electricity,
            internet = regionConfig and regionConfig.internet,
            water = regionConfig and regionConfig.water,
            
            -- Status
            isInside = isInside,
            lastEnter = propertyData.last_enter,
            
            -- Features
            garage = propertyData.metadata.garage ~= nil,
            parking = propertyData.metadata.parking and #propertyData.metadata.parking,
            
            -- Sale and rental
            sale = propertyData.sale,
            rental = propertyData.rental,
            
            -- Limits
            keysLimit = propertyData.metadata.keysLimit,
            furnitureLimit = GetFurnitureLimit(propertyData.metadata.upgrades),
            
            -- Auto-sell price calculation
            autoSellPrice = propertyData.sale.defaultPrice and 
                           propertyData.sale.defaultPrice >= 1 and 
                           propertyData.sale.defaultPrice * (Config.AutomaticSell / 100)
        }
    }
    
    -- Add permissions data for owners and renters
    if isOwner or isRenter then
        menuData.data.permissions = propertyData.permissions
    end
    
    -- Add furniture data if player has furniture permissions
    if library.HasPermissions(propertyId, "furniture") then
        menuData.data.furniture = propertyData.furniture
        menuData.data.allowedInside = propertyData.metadata.allowFurnitureInside
        menuData.data.allowedOutside = propertyData.metadata.allowFurnitureOutside
        
        -- Check for wardrobe
        menuData.data.hasWardrobe = propertyData.metadata.wardrobe and 
                                    propertyData.metadata.wardrobe.x ~= nil
        
        -- Check for storage
        menuData.data.hasStorage = propertyData.metadata.storage and 
                                   propertyData.metadata.storage.x ~= nil
    end
    
    -- Add upgrade data if player has upgrade management permissions
    if library.HasPermissions(propertyId, "upgradesManage") then
        menuData.data.upgrades = Config.HousingUpgrades
        menuData.data.ownUpgrades = {}
        
        -- Check which upgrades the property owns
        for upgradeName, upgradeConfig in pairs(Config.HousingUpgrades) do
            if propertyData.metadata.upgrades and 
               propertyData.metadata.upgrades[upgradeConfig.metadata] then
                menuData.data.ownUpgrades[upgradeConfig.metadata] = 
                    propertyData.metadata.upgrades[upgradeConfig.metadata]
            end
        end
    end
    
    -- Add marketplace data if player has marketplace management permissions
    if library.HasPermissions(propertyId, "marketplaceManage") then
        menuData.data.furnished = propertyData.metadata.furnished
        menuData.data.contact_number = propertyData.metadata.contact_number
        menuData.data.images = propertyData.metadata.images
    end
    
    -- Open the NUI menu
    SetNuiFocus(true, true)
    SendNUIMessage(menuData)
    openedMenu = "PropertyManage"
end

-- Export the function for external use
exports("OpenManageMenu", openManageMenu)

-- ============================================================================
-- NUI Callback for Closing Manage Menu
-- ============================================================================
RegisterNUICallback("closeManageMenu", function(data, cb)
    closeManageMenu()
    cb({})
end)

-- ============================================================================
-- Close Property Management Menu
-- ============================================================================
function closeManageMenu()
    SendNUIMessage({
        action = "Property",
        actionName = "CloseManage"
    })
    
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    openedMenu = nil
    MotelManageId = nil
end

-- ============================================================================
-- Register Command and Key Mapping
-- ============================================================================

-- Register command if enabled in config
if Config.HousingManagement and Config.HousingManagement.Command then
    RegisterCommand(Config.HousingManagement.Command, function()
        openManageMenu()
    end)
    
    if Config.HousingManagement.Key then
        RegisterKeyMapping(
            Config.HousingManagement.Command,
            Config.HousingManagement.Description or "",
            "keyboard",
            Config.HousingManagement.Key
        )
    end
else
    print("^1[vms_housing] Config.HousingManagement not found or Command not set^7")
end

-- Register close command (workaround for ESC not working)
RegisterCommand("closemanagemenu", function()
    if openedMenu == "PropertyManage" then
        closeManageMenu()
    end
end, false)

-- Map BACKSPACE key to close menu
RegisterKeyMapping("closemanagemenu", "Close Property Management Menu", "keyboard", "BACK")