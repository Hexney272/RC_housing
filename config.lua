Config = Config or {}


-- ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
-- ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
-- █████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
-- ██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
-- ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
-- ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
local DetectActiveFramework = function()
    if GetResourceState('es_extended') == 'started' then
        return "ESX"
    elseif GetResourceState('qb-core') == 'started' then
        return "QB-Core"
    end
end

Config.Core = DetectActiveFramework()
Config.CoreExport = function()
    if Config.Core == "ESX" then
        return exports['es_extended']:getSharedObject()
    elseif Config.Core == "QB-Core" then
        return exports['qb-core']:GetCoreObject()
    end
end

---@field PlayerLoaded string: ESX: "esx:playerLoaded" / QB-Core: "QBCore:Client:OnPlayerLoaded"
Config.PlayerLoaded = Config.Core == "ESX" and "esx:playerLoaded" or "QBCore:Client:OnPlayerLoaded"

---@field PlayerLogoutServer string: ESX: "esx:playerDropped" / QB-Core: "QBCore:Server:OnPlayerUnload"
Config.PlayerLogoutServer = Config.Core == "ESX" and "esx:playerDropped" or "QBCore:Server:OnPlayerUnload"

---@field PlayerSetJob string: ESX: "esx:setJob" / QB-Core: "QBCore:Client:OnJobUpdate"
Config.PlayerSetJob = Config.Core == "ESX" and "esx:setJob" or "QBCore:Client:OnJobUpdate"



-- ███╗   ███╗ █████╗ ██╗███╗   ██╗    ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
-- ████╗ ████║██╔══██╗██║████╗  ██║    ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
-- ██╔████╔██║███████║██║██╔██╗ ██║    ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
-- ██║╚██╔╝██║██╔══██║██║██║╚██╗██║    ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
-- ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║    ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
-- ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
---@class AutoExecuteQuery<boolean>
-- Automatically creates required SQL tables on resource start (recommended for first install).
Config.AutoExecuteQuery = true

---@class Debug<boolean>
-- By running debugging, you will receive prints at various activities, in case of any problems, this will be able to help you find the cause of the misconfiguration.
Config.Debug = true                 -- Enables debug prints for various system events.
Config.DebugTarget = false          -- Enables debug related to target zones.
Config.DebugPolyZone = false        -- Enables debug related to PolyZone entries/exits.
Config.DebugRegionsZone = false     -- Enables debug related to Regions PolyZone.


local function DetectActiveTarget()
    local resources = {
        'ox_target',
        'qb-target',
    }

    for i=1, #resources, 1 do
        if GetResourceState(resources[i]) == 'started' then
            return resources[i]
        end
    end
    return nil
end

---@class TargetResource<string>
-- Automatically detects the active target system (ox_target or qb-target).
Config.TargetResource = DetectActiveTarget()



--  ██████╗ ███████╗███╗   ██╗███████╗██████╗  █████╗ ██╗         ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
-- ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔══██╗██╔══██╗██║         ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
-- ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ██████╔╝███████║██║         ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
-- ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║██║         ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
-- ╚██████╔╝███████╗██║ ╚████║███████╗██║  ██║██║  ██║███████╗    ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
--  ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
Config.Blips = {
    ['Motel'] = {
        sprite = 475,
        display = 2,
        scale = 0.9,
        color = 0,
        name = TRANSLATE('blip.motel'),
    },
    ['Building'] = {
        sprite = 475,
        display = 2,
        scale = 0.9,
        color = 0,
        name = TRANSLATE('blip.building'),
    },
    ['HouseOwner'] = {
        sprite = 40,
        display = 2,
        scale = 0.8,
        color = 0,
        blipCategory = 11,
        name = TRANSLATE('blip.house_owner'),
    },
    ['HouseRenter'] = {
        sprite = 40,
        display = 2,
        scale = 0.8,
        color = 0,
        blipCategory = 11,
        name = TRANSLATE('blip.house_renter'),
    },
    ['HouseKeyHolder'] = {
        sprite = 811,
        display = 2,
        scale = 0.9,
        color = 26,
        blipCategory = 11,
        name = TRANSLATE('blip.house_key_holder'),
    },
    ['HouseForSale'] = {
        sprite = 350,
        display = 2,
        scale = 0.6,
        color = 0,
        blipCategory = 10,
        name = TRANSLATE('blip.house_for_sale'),
    },
    ['Marketplace'] = {
        sprite = 476,
        display = 2,
        scale = 1.0,
        color = 2,
        name = TRANSLATE('blip.marketplace'),
    },
}

---@class AreaUnit<string>
-- Unit used for displaying property area ("m2" for meters, "ft2" for feet)
Config.AreaUnit = "m2"

---@class TeleportToLastPropertyOnJoin<boolean>
-- Automatically teleport player to last property after joining the server when he left the server while in the interiors.
-- If you are using a custom spawnselector, make sure you cancel running it when the player has data in the `last_property` column.
Config.TeleportToLastPropertyOnJoin = true

---@class FurnitureInteractionAccess<number>
-- 1 : Every player who is inside or on the property has access to the interaction
-- 2 : Only players who have any permission in the property have access to furniture interaction
-- 3 : Only players who have the furniture permission in the property have access to furniture interaction
Config.FurnitureInteractionAccess = 2

---@class StaticInteractionAccess<number>
-- 1 : Every player who is inside or on the property has access to the interaction
-- 2 : Only players who have any permission in the property have access to furniture interaction
-- 3 : Only players who have the furniture permission in the property have access to furniture interaction
Config.StaticInteractionAccess = 1

---@class AllowChangeStoragePosition<boolean>
-- Allows the player to reposition the default storage unit inside the property.
-- Only applies if the house was created with a pre-set storage location (e.g., via housing creator).
-- Useful for letting the owner place it elsewhere inside the house after purchase.
Config.AllowChangeStoragePosition = true

---@class AllowChangeWardrobePosition<boolean>
-- Allows the player to reposition the default wardrobe inside the property.
-- Only applies if the house was created with a pre-set wardrobe location (e.g., via housing creator).
-- Gives flexibility to organize the interior layout more freely.
Config.AllowChangeWardrobePosition = true

---@class MaxPropertiesPerPlayer<number | false>
-- You can set a limit on the maximum number of properties owned by one player, if you do not want to use the limit, set false
Config.MaxPropertiesPerPlayer = false

---@class RentalCycles<table>
Config.RentalCycles = {
    ['weekly'] = true,
    ['monthly'] = true,
}


-- ███████╗████████╗ █████╗ ██████╗ ████████╗███████╗██████╗      █████╗ ██████╗  █████╗ ██████╗ ████████╗███╗   ███╗███████╗███╗   ██╗████████╗███████╗
-- ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗    ██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
-- ███████╗   ██║   ███████║██████╔╝   ██║   █████╗  ██████╔╝    ███████║██████╔╝███████║██████╔╝   ██║   ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ███████╗
-- ╚════██║   ██║   ██╔══██║██╔══██╗   ██║   ██╔══╝  ██╔══██╗    ██╔══██║██╔═══╝ ██╔══██║██╔══██╗   ██║   ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║
-- ███████║   ██║   ██║  ██║██║  ██║   ██║   ███████╗██║  ██║    ██║  ██║██║     ██║  ██║██║  ██║   ██║   ██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ███████║
-- ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
---@class StarterApartments<table>
-- Configuration of automatically assigned starter apartments for new players
-- https://docs.vames-store.com/assets/vms_housing/guides/how-to-use-starter-apartments
Config.StarterApartments = {
    Object = 114, -- You need to have a property building created and here is to find the id of this building from the database.
    Name = 'Starting Apartment #%s', -- Name of the starter apartment, which will be displayed in the menu.
    Type = 'shell', -- 'shell' / 'ipl'

    Shell = 'standardmotel_shell',
    Ipl = 'apa_v_mp_h_01_a',

    DefaultPurchasePrice = 0, -- Default purchase price of the starter apartment. (By setting 0, the player will not be able to sell the property to make money)
    DefaultRentPrice = 0, -- Default rent price of the starter apartment.

    AllowFurnitureInside = true, -- true : Allow furniture inside the starter apartment
    AllowChangeTheme = true, -- true : Allow changing the theme of the starter apartment IPL
    DefaultThemeIpl = 'modern',

    Delivery = {
        Enabled = true,
        Coords = vector4(2.4304, -2.1917, 498.4416, 79.99999237060547), -- Coords of the storage in the starter apartment
    },

    Storage = {
        Enabled = true,
        Coords = vector3(1.5388, -3.0803, 499.7162), -- Coords of the storage in the starter apartment
        Slots = 20, -- Slots of the storage in the starter apartment
        Weight = 25000, -- Weight of the storage in the starter apartment
    },

    Wardrobe = {
        Enabled = true,
        Coords = vector3(1.3227, 2.8945, 500.0726), -- Coords of the wardrobe in the starter apartment
    },
}



-- ██╗  ██╗ ██████╗ ██╗   ██╗███████╗██╗███╗   ██╗ ██████╗     ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗███╗   ███╗███████╗███╗   ██╗████████╗
-- ██║  ██║██╔═══██╗██║   ██║██╔════╝██║████╗  ██║██╔════╝     ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
-- ███████║██║   ██║██║   ██║███████╗██║██╔██╗ ██║██║  ███╗    ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
-- ██╔══██║██║   ██║██║   ██║╚════██║██║██║╚██╗██║██║   ██║    ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
-- ██║  ██║╚██████╔╝╚██████╔╝███████║██║██║ ╚████║╚██████╔╝    ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
-- ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
Config.HousingManagement = {
    Command = 'housemanage',                    -- Command to open the property management menu
    Key = 'F6',                                 -- Keyboard shortcut to open the management menu
    Description = 'Property management menu',   -- Description shown in keybind hint
}

---@class AutomaticSell<number>
-- Percentage (%) refunded to player when selling their property via menu
Config.AutomaticSell = 50



-- ██╗  ██╗███████╗██╗   ██╗███████╗    ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗
-- ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║
-- █████╔╝ █████╗   ╚████╔╝ ███████╗    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║
-- ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║    ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
-- ██║  ██╗███████╗   ██║   ███████║    ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║
-- ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝    ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝
---@class UseKeysOnItem<boolean>
-- true = keys are given as inventory items (e.g. qb-inventory / ox_inventory)
-- false = key ownership stored internally (no item given)
Config.UseKeysOnItem = true

---@class KeysLimit<number>
-- Max number of physical keys a player can generate for a property
Config.KeysLimit = 8

---@class KeyPrice<number>
-- Price ($) to generate an additional key
Config.KeyPrice = 300

---@class LockReplacementPrice<number>
-- Price ($) to replace the lock and invalidate old keys
Config.LockReplacementPrice = 1000

---@class RemoveKeysOnRentEnd<boolean>
-- Remove all keys from tenants when the rent ends
Config.RemoveKeysOnRentEnd = true

---@class AutomaticGiveKeyForProperty<boolean>
-- Do you want the player to receive the key item immediately after buying/renting the property?
Config.AutomaticGiveKeyForProperty = true



-- ██████╗  ██████╗  ██████╗ ██████╗     ███████╗████████╗ █████╗ ████████╗███████╗
-- ██╔══██╗██╔═══██╗██╔═══██╗██╔══██╗    ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝
-- ██║  ██║██║   ██║██║   ██║██████╔╝    ███████╗   ██║   ███████║   ██║   █████╗  
-- ██║  ██║██║   ██║██║   ██║██╔══██╗    ╚════██║   ██║   ██╔══██║   ██║   ██╔══╝  
-- ██████╔╝╚██████╔╝╚██████╔╝██║  ██║    ███████║   ██║   ██║  ██║   ██║   ███████╗
-- ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝
---@class SaveDoorsState<boolean>
-- true = door state (open/closed) is saved and restored after a server restart
Config.SaveDoorsState = true

---@class DefaultDoorsLocked<boolean>
-- Default door state if SaveDoorsState is false
-- true = doors locked
-- false = doors unlocked
Config.DefaultDoorsLocked = true



-- ██████╗ ███████╗██████╗ ███╗   ███╗██╗███████╗███████╗██╗ ██████╗ ███╗   ██╗███████╗
-- ██╔══██╗██╔════╝██╔══██╗████╗ ████║██║██╔════╝██╔════╝██║██╔═══██╗████╗  ██║██╔════╝
-- ██████╔╝█████╗  ██████╔╝██╔████╔██║██║███████╗███████╗██║██║   ██║██╔██╗ ██║███████╗
-- ██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║██║╚════██║╚════██║██║██║   ██║██║╚██╗██║╚════██║
-- ██║     ███████╗██║  ██║██║ ╚═╝ ██║██║███████║███████║██║╚██████╔╝██║ ╚████║███████║
-- ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
---@class DefaultPermissionsForRenter<table>
-- Default permissions granted to a renter when added to a property
Config.DefaultPermissionsForRenter = {
    'garage',           -- Access to garage
    'furniture',        -- Can manage furniture
    'billPayments',     -- Can pay bills
    'keysManage',       -- Can manage keys
    'upgradesManage',   -- Can manage house upgrades
}

---@class PermissionsLimit<number>
-- Max number of players with permissions for a property
Config.PermissionsLimit = 10



-- ████████╗ █████╗ ██╗  ██╗███████╗███████╗
-- ╚══██╔══╝██╔══██╗╚██╗██╔╝██╔════╝██╔════╝
--    ██║   ███████║ ╚███╔╝ █████╗  ███████╗
--    ██║   ██╔══██║ ██╔██╗ ██╔══╝  ╚════██║
--    ██║   ██║  ██║██╔╝ ██╗███████╗███████║
--    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝
---@class CityHallTaxes<table>
-- City tax configuration for property-related transactions (Only for VMS City Hall Users)
Config.CityHallTaxes = {
    PropertyPurchase = {
        Enabled = true,
        Type = 'percentage', -- 'percentage' / 'static'
        Value = 3, -- 3% for percentage Type or 3$ for static Type
        Title = 'Property Purchase - %s %s',
    },
    PropertyResale = {
        Enabled = true,
        Type = 'percentage', -- 'percentage' / 'static'
        Value = 12, -- 12% for percentage Type or 12$ for static Type
        Title = 'Property Resale - %s %s',
    },
    RentalIncome = {
        Enabled = true,
        Type = 'percentage', -- 'percentage' / 'static'
        Value = 15, -- 15% for percentage Type or 15$ for static Type
        Title = 'Property Rental - %s %s',
    },
    PropertyCadastralTax = {
        Enabled = true,
        Type = 'percentage', -- 'percentage' / 'static'
        Value = 1, -- 1% for percentage Type or 1$ for static Type
        Title = 'Property Cadastral Tax - %s %s',
    },
}



-- ██████╗ ██╗██╗     ██╗     ███████╗
-- ██╔══██╗██║██║     ██║     ██╔════╝
-- ██████╔╝██║██║     ██║     ███████╗
-- ██╔══██╗██║██║     ██║     ╚════██║
-- ██████╔╝██║███████╗███████╗███████║
-- ╚═════╝ ╚═╝╚══════╝╚══════╝╚══════╝
---@class UseBills<boolean>
-- Enable utility bills system (electricity, water, internet)
Config.UseServiceBills = true

---@class AllowedUnpaidBills<number>
-- Max number of unpaid utility bills before services are disabled
Config.AllowedUnpaidBills = 2

---@class AllowedUnpaidRentBills<number>
-- Max number of unpaid rent bills before tenant is evicted
-- Do not set to 1 to avoid instant eviction!
Config.AllowedUnpaidRentBills = 2

---@class RemoveBillsOnRentEnd<boolean>
-- Delete all unpaid bills assigned to the tenant when the rent ends
Config.RemoveBillsOnRentEnd = true

---@class OptimizeBillsTable<boolean>
-- true = Removes paid bills from the database at server startup
-- false = Doesn't remove bills from the database
Config.OptimizeBillsTable = false



-- ███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗
-- ██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝
-- ███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝ 
-- ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝  
-- ███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║   
-- ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   
---@class Lockpick<table>
-- Configuration related to the possibility of breaking into a property
Config.Lockpick = {
    Enable = true, -- Enable or disable lockpicking for properties

    Item = {
        Required = true,           -- true = item is required to lockpick
        Name = 'lockpick',         -- Name of the item used for lockpicking
        Count = 1,                 -- Amount required
        RemoveOnUse = true         -- true = item will be removed after use
    },
}

Config.Alarm = { -- ./integration/[dispatch]/*
    AlertPoliceOnlyWithUpgrade = true, -- Only alert the police if the property has the alarm upgrade installed

    AlarmJobs = { 'police', 'sheriff' },

    AlertPoliceOnLockpickStart = true,     -- Notify police when a lockpick attempt starts
    AlertPoliceOnLockpickSuccess = false,  -- Notify police only if the break-in is successful
    AlertPoliceOnLockpickFail = false,     -- Notify police only if the break-in attempt fails
}

Config.PropertyLockdown = {
    Enable = true, -- Enable the property lockdown system (e.g., police tape to restrict access)

    ObjectModel = 'prop_barrier_work05', -- Model used as the physical lockdown object (e.g., barrier or tape)

    Jobs = { 'police' }, -- List of jobs allowed to initiate property lockdown

    Item = {
        Required = true,       -- true = item is required to lockdown
        Name = 'police_barrier',   -- Name of the required item
        Count = 1,              -- Amount required
        RemoveOnUse = true      -- true = item will be removed after use
    },
}

Config.PropertyRaids = {
    Enable = true, -- Enable the ability to raid properties by specific jobs

    Jobs = { 'police' }, -- List of jobs allowed to initiate raids

    AntiBurglaryDoors = {
        AllowRaid = true, -- Allow raiding even if the property has Anti-Burglary Doors installed
        RaidChance = 10, -- % chance that the raid will succeed if Anti-Burglary Doors are present

        ---@field BreakOnRam<boolean>
        -- true = Raiding will remove the Anti-Burglary Doors upgrade and require repurchase
        -- false = Raiding will not remove the Anti-Burglary Doors upgrade
        BreakOnRam = true
    }, 

    Item = {
        Required = true,            -- true = item is required to raid
        Name = 'police_stormram',         -- Name of the required item
        Count = 1,                   -- Amount required
        RemoveOnUse = true           -- true = item will be removed after use
    },
}



-- ██╗  ██╗ ██████╗ ██╗   ██╗███████╗██╗███╗   ██╗ ██████╗      ██████╗██████╗ ███████╗ █████╗ ████████╗ ██████╗ ██████╗ 
-- ██║  ██║██╔═══██╗██║   ██║██╔════╝██║████╗  ██║██╔════╝     ██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
-- ███████║██║   ██║██║   ██║███████╗██║██╔██╗ ██║██║  ███╗    ██║     ██████╔╝█████╗  ███████║   ██║   ██║   ██║██████╔╝
-- ██╔══██║██║   ██║██║   ██║╚════██║██║██║╚██╗██║██║   ██║    ██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██║   ██║██╔══██╗
-- ██║  ██║╚██████╔╝╚██████╔╝███████║██║██║ ╚████║╚██████╔╝    ╚██████╗██║  ██║███████╗██║  ██║   ██║   ╚██████╔╝██║  ██║
-- ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝      ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
Config.HousingCreator = {
    Command = 'housing',                    -- Command to open the housing creator menu
    Key = 'F7',                             -- Keyboard shortcut to open the housing creator menu
    Description = 'Open Housing Creator',   -- Description shown in keybind hint
    RequiredJob = 'realestate'              -- Required job to access the housing creator
}

Config.HousingCreatorControls = {
    ['SELECT'] = {controlIndex = 24},           -- Default: Mouse Left
    ['BACK'] = {controlIndex = 70},             -- Default: Mouse Right
    ['SCROLL_DOWN'] = {controlIndex = 180},     -- Default: Scroll Down
    ['SCROLL_UP'] = {controlIndex = 181},       -- Default: Scroll UP
    ['LEFT_CTRL'] = {controlIndex = 210},       -- Default: Left CTRL
    ['ENTER'] = {controlIndex = 191},           -- Default: Enter
    ['CANCEL'] = {controlIndex = 202},          -- Default: BACKSPACE / ESC
}

Config.Shells = {
    K4MB1 = true,                                                       -- Enable shell support for K4MB1
    ENVI = false,                                                       -- Enable shell support for ENVI
    DCCustomz = true,                                                  -- Enable shell support for DCCustomz
    KuzQuality = GetResourceState('kq_shellbuilder') ~= 'missing',      -- Enable shell support for Kuz Quality Shell Creator
}



-- ███╗   ███╗ █████╗ ██████╗ ██╗  ██╗███████╗████████╗██████╗ ██╗      █████╗  ██████╗███████╗
-- ████╗ ████║██╔══██╗██╔══██╗██║ ██╔╝██╔════╝╚══██╔══╝██╔══██╗██║     ██╔══██╗██╔════╝██╔════╝
-- ██╔████╔██║███████║██████╔╝█████╔╝ █████╗     ██║   ██████╔╝██║     ███████║██║     █████╗  
-- ██║╚██╔╝██║██╔══██║██╔══██╗██╔═██╗ ██╔══╝     ██║   ██╔═══╝ ██║     ██╔══██║██║     ██╔══╝  
-- ██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██╗███████╗   ██║   ██║     ███████╗██║  ██║╚██████╗███████╗
-- ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝╚══════╝
Config.Marketplace = {
    Enabled = true, -- Enables or disables the marketplace system
    AllowTransactionFromMenu = true, -- Allow transactions directly from the property management menu

    ShowSecondaryMarketOnly = true, -- Show only the secondary market (properties for sale by players)

    Blip = Config.Blips['Marketplace'], -- Blip settings (see Config.Blips section)
    BlipCoords = vector3(-1082.89, -249.45, 43.98), -- Location of the blip on the map

    TargetCoords = vector4(-1083.08, -249.66, 44.02, 296.5), -- Target interaction coordinates (for targeting systems like ox_target)
    TargetSize = vec3(2.0, 1.6, 1.8), -- Target zone dimensions (length, width, height)

    Ped = { -- NPC configuration for visual immersion
        Model = 'ig_drfriedlander', -- Model of the NPC ped
        Coords = vector4(-1082.72, -249.5, 43.02, 296.32), -- Position and heading of the ped
        Animation = {'switch@michael@sitting', 'idle'} -- Animation dictionary and name used by the ped
    },
}



-- ███████╗██╗   ██╗██████╗ ███╗   ██╗██╗████████╗██╗   ██╗██████╗ ███████╗
-- ██╔════╝██║   ██║██╔══██╗████╗  ██║██║╚══██╔══╝██║   ██║██╔══██╗██╔════╝
-- █████╗  ██║   ██║██████╔╝██╔██╗ ██║██║   ██║   ██║   ██║██████╔╝█████╗  
-- ██╔══╝  ██║   ██║██╔══██╗██║╚██╗██║██║   ██║   ██║   ██║██╔══██╗██╔══╝  
-- ██║     ╚██████╔╝██║  ██║██║ ╚████║██║   ██║   ╚██████╔╝██║  ██║███████╗
-- ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
Config.HousingFurniture = {
    Command = 'furniture',                     -- Command to open the property furniture menu
    Key = nil,                                 -- Keyboard shortcut to open the furniture menu
    Description = 'Property furniture menu',   -- Description shown in keybind hint
}

---@class RequirePurchaseFurniture<boolean>
-- true: Players must order furniture before placement
-- false: Furniture can be placed without ordering
Config.RequirePurchaseFurniture = true

---@class FurnitureSellPercentage<number>
-- Percentage (%) refunded when selling furniture through the menu
Config.FurnitureSellPercentage = 80

---@class FurnitureLimit<number>
-- Default maximum number of placed furniture per property without upgrades
Config.FurnitureLimit = 10

---@class RemoveFurnitureOnRentEnd<boolean>
-- Remove all furniture placed by tenant when the rent ends
Config.RemoveFurnitureOnRentEnd = true

Config.FurnitureControls = {
    ['CLOSE'] = {controlIndex = 202},           -- Default: BACKSPACE / ESC

    ['ACCEPT'] = {controlIndex = 201},          -- Default: Mouse Left
    ['UP'] = {controlIndex = 172},              -- Default: Arrow Up
    ['DOWN'] = {controlIndex = 173},            -- Default: Arrow Down
    ['ROTATE_LEFT'] = {controlIndex = 181},     -- Default: Scroll UP
    ['ROTATE_RIGHT'] = {controlIndex = 180},    -- Default: Scroll Down
    ['SPEED_DOWN'] = {controlIndex = 210},      -- Default: Left CTRL

    ['SNAP_TO_GROUND'] = {controlIndex = 19},   -- Default: Left ALT
    ['ENABLE_CURSOR'] = {controlIndex = 238},   -- Default: PPM
    ['CHANGE_MODE'] = {controlIndex = 58},      -- Default: G
    
    ['GIZMO_TRANSLATION'] = {control = 'X'},
    ['GIZMO_ROTATION'] = {control = 'C'},
}

Config.FurnitureSettings = {
    HeightSpeed = 0.01,       -- Default height movement speed
    HeightSpeedSlow = 0.005,  -- Slower height movement speed (when holding CTRL)
    RotateSpeed = 5.0,        -- Default rotation speed
    RotateSpeedSlow = 1.0,    -- Slower rotation speed (when holding CTRL)
}

---@class Cameras<table>
-- List of object models recognized as security cameras, allowing interaction or placement
Config.Cameras = {
    ['prop_cctv_cam_04c'] = true,
    ['prop_cctv_cam_05a'] = true,
    ['prop_cctv_cam_06a'] = true,
}



-- ██████╗ ███████╗██╗     ██╗██╗   ██╗███████╗██████╗ ██╗███████╗███████╗
-- ██╔══██╗██╔════╝██║     ██║██║   ██║██╔════╝██╔══██╗██║██╔════╝██╔════╝
-- ██║  ██║█████╗  ██║     ██║██║   ██║█████╗  ██████╔╝██║█████╗  ███████╗
-- ██║  ██║██╔══╝  ██║     ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗██║██╔══╝  ╚════██║
-- ██████╔╝███████╗███████╗██║ ╚████╔╝ ███████╗██║  ██║██║███████╗███████║
-- ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝
---@class DeliveryType<number>
-- 1: No Delivery - Furniture is added instantly to the property, no waiting time.
-- 2: Auto-Delivery - Furniture is delivered after a set delay and automatically appears in the furniture menu.
-- 3: Realistic Delivery - Furniture arrives after a set delay as boxes on the property, which must be unpacked manually.
Config.DeliveryType = 1
Config.DeliveryObject = 'prop_boxpile_01a'

Config.Deliveries = {
    ['1'] = { -- Delivery Size 1
        defaultDeliveryCharge = 2000,           -- Cost for small deliveries
        defaultDeliveryTime = 1 * 60 * 1000,   -- 10 minutes
    },
    ['2'] = { -- Delivery Size 2
        defaultDeliveryCharge = 2000,           -- Cost for medium deliveries
        defaultDeliveryTime = 30 * 60 * 1000,   -- 30 minutes
    },
    ['3'] = { -- Delivery Size 3
        defaultDeliveryCharge = 2000,           -- Cost for large deliveries
        defaultDeliveryTime = 60 * 60 * 1000,   -- 60 minutes
    },
}
-- ██║   ██║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝
-- ██║   ██║██████╔╝██║  ███╗██████╔╝███████║██║  ██║█████╗  ███████╗
-- ██║   ██║██╔═══╝ ██║   ██║██╔══██╗██╔══██║██║  ██║██╔══╝  ╚════██║
-- ╚██████╔╝██║     ╚██████╔╝██║  ██║██║  ██║██████╔╝███████╗███████║
--  ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝
---@class HousingUpgrades<table>
-- Property upgrades available for players to purchase through the management menu.
-- Each upgrade enhances property features like security or furniture capacity.
Config.HousingUpgrades = {
    ['alarm'] = {
        metadata = 'alarm',
        price = 60000,

        icon = 'fa-solid fa-car-on',
        label = "Alarm",

        description = [[
            An advanced alarm system that immediately triggers an alert when unauthorized entry is detected.
            Highly effective against break-ins, especially when you're offline.
        ]],
    },

    ['anti_burglary_doors'] = {
        metadata = 'antiBurglaryDoors',
        price = 80000,

        icon = 'fa-solid fa-door-closed',
        label = "Anti-Burglary Doors",

        description = [[
            Reinforced doors designed to resist forced entry attempts.
            Adds an extra layer of security and delays break-in time significantly.
        ]],
    },

    ['smart_peephole'] = {
        metadata = 'smartPeephole',
        price = 80000,

        icon = 'fa-solid fa-door-closed',
        label = "Smart Peephole",

        description = [[
            Reinforced doors designed to resist forced entry attempts.
            Adds an extra layer of security and delays break-in time significantly.
        ]],
    },

    ['furniture_limit'] = {
        metadata = 'furnitureLimit',

        icon = 'fa-solid fa-couch',
        label = "Furniture Limit",

        description = ([[
            Upgrade to be able to have more furniture in your property.
            Your current furniture limit is %s - after this upgrade, it will increase to 30.
        ]]):format(Config.FurnitureLimit),

        levels = {
            ['1'] = {
                limit = 30,     -- Furniture Limit with LVL 1
                price = 60000,
                description = [[
                    Increase your furniture limit from 30 to 50.
                    Useful if you're running out of space in your current setup.
                ]],
            },
            ['2'] = {
                limit = 50,
                price = 80000,
                description = [[
                    Increase your furniture limit from 50 to 100.
                    Great for heavily customized interiors.
                ]],
            },
            ['3'] = {
                limit = 100,
                price = 100000,
                description = [[
                    Increase your furniture limit from 100 to 150.
                    Perfect for large homes with detailed furnishing needs.
                ]],
            },
            ['4'] = {
                limit = 150,
                price = 120000,
                description = [[
                    You've reached the maximum furniture level.
                    No further upgrades are available.
                ]],
            },
        },
    },
}



-- ██╗    ██╗███████╗ █████╗ ████████╗██╗  ██╗███████╗██████╗ 
-- ██║    ██║██╔════╝██╔══██╗╚══██╔══╝██║  ██║██╔════╝██╔══██╗
-- ██║ █╗ ██║█████╗  ███████║   ██║   ███████║█████╗  ██████╔╝
-- ██║███╗██║██╔══╝  ██╔══██║   ██║   ██╔══██║██╔══╝  ██╔══██╗
-- ╚███╔███╔╝███████╗██║  ██║   ██║   ██║  ██║███████╗██║  ██║
--  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
local function DetectActiveWeather()
    local weathers = {
        'Renewed-Weathersync',
        'cd_easytime',
        'vSync',
        'qb-weathersync',
        'qbx_weathersync',
        'av_weather',
    }

    for i=1, #weathers, 1 do
        if GetResourceState(weathers[i]) == 'started' then
            return weathers[i]
        end
    end
    return nil
end

Config.Weather = DetectActiveWeather()



--  ██████╗██╗      ██████╗ ████████╗██╗  ██╗██╗███╗   ██╗ ██████╗ 
-- ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║██║████╗  ██║██╔════╝ 
-- ██║     ██║     ██║   ██║   ██║   ███████║██║██╔██╗ ██║██║  ███╗
-- ██║     ██║     ██║   ██║   ██║   ██╔══██║██║██║╚██╗██║██║   ██║
-- ╚██████╗███████╗╚██████╔╝   ██║   ██║  ██║██║██║ ╚████║╚██████╔╝
--  ╚═════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
local function DetectActiveClothing()
    local resources = {
        'vms_clothestore',
        'qb-clothing',
        'ak47_clothing',
        'rcore_clothing',
        'raid_clothes',
        'bl_appearance',
        'fivem-appearance',
        'illenium-appearance',
        'codem-appearance',
        'qs-appearance',
        '17mov_CharacterSystem',
    }

    for i=1, #resources, 1 do
        if GetResourceState(resources[i]) == 'started' then
            return resources[i]
        end
    end
    return nil
end

Config.Clothing = DetectActiveClothing()



--  ██████╗  █████╗ ██████╗  █████╗  ██████╗ ███████╗███████╗
-- ██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝██╔════╝
-- ██║  ███╗███████║██████╔╝███████║██║  ███╗█████╗  ███████╗
-- ██║   ██║██╔══██║██╔══██╗██╔══██║██║   ██║██╔══╝  ╚════██║
-- ╚██████╔╝██║  ██║██║  ██║██║  ██║╚██████╔╝███████╗███████║
--  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝
local function DetectActiveGarage()
    local resources = {
        'vms_garagesv2',
        'rcore_garages',
        'cd_garage',
        'loaf_garage',
        'jg-advancedgarages',
        'okokGarage',
        'RxGarages',
    }

    for i=1, #resources, 1 do
        if GetResourceState(resources[i]) == 'started' then
            return resources[i]
        end
    end
    return nil
end

Config.Garages = DetectActiveGarage()



-- ██╗███╗   ██╗██╗   ██╗███████╗███╗   ██╗████████╗ ██████╗ ██████╗ ██╗   ██╗
-- ██║████╗  ██║██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝
-- ██║██╔██╗ ██║██║   ██║█████╗  ██╔██╗ ██║   ██║   ██║   ██║██████╔╝ ╚████╔╝ 
-- ██║██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ██║   ██║██╔══██╗  ╚██╔╝  
-- ██║██║ ╚████║ ╚████╔╝ ███████╗██║ ╚████║   ██║   ╚██████╔╝██║  ██║   ██║   
-- ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   
local function DetectActiveInventory()
    local resources = {
        'codem-inventory',
        'tgiann-inventory',
        'origen_inventory',
        'ak47_inventory',
        'core_inventory',
        'qs-inventory',
        'ox_inventory',
        'qb-inventory',
        'inventory', -- Chezza Inventory
    }

    for i=1, #resources, 1 do
        if GetResourceState(resources[i]) == 'started' then
            return resources[i]
        end
    end
    return nil
end

Config.Inventory = DetectActiveInventory()



-- ██████╗ ██╗███████╗██████╗  █████╗ ████████╗ ██████╗██╗  ██╗
-- ██╔══██╗██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║
-- ██║  ██║██║███████╗██████╔╝███████║   ██║   ██║     ███████║
-- ██║  ██║██║╚════██║██╔═══╝ ██╔══██║   ██║   ██║     ██╔══██║
-- ██████╔╝██║███████║██║     ██║  ██║   ██║   ╚██████╗██║  ██║
-- ╚═════╝ ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝
local function DetectActiveDispatch()
    local resources = {
        'lb-tablet',
        'ps-dispatch',
        'cd_dispatch',
        'qs-dispatch',
        'rcore_dispatch',
        'tk_dispatch',
        'core_dispatch',
    }

    for i=1, #resources, 1 do
        if GetResourceState(resources[i]) == 'started' then
            return resources[i]
        end
    end
    return nil
end

Config.Dispatch = DetectActiveDispatch()