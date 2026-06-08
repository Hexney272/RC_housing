-- Property Marketplace System
-- Displays available properties for sale or rent
-- Shows property listings with images, parking, garage, and pricing information

-- ============================================================================
-- Global Variables
-- ============================================================================

isOfferByMarketplace = false
marketplaceOfferId = nil

-- ============================================================================
-- Open Marketplace Menu
-- ============================================================================
-- Displays all properties available for sale or rent in an interactive menu
function openMarketplace()
    -- Reset marketplace offer state
    isOfferByMarketplace = false
    marketplaceOfferId = nil
    
    local propertiesList = {}
    
    -- Iterate through all properties to find listings
    for propertyId, propertyData in pairs(Properties) do
        local shouldShowProperty = false
        
        -- Check if property is for sale
        if propertyData.sale and propertyData.sale.active == true then
            shouldShowProperty = true
        -- Check if property is for rent
        elseif propertyData.rental and propertyData.rental.active == true then
            shouldShowProperty = true
        end
        
        -- Filter based on marketplace settings
        if shouldShowProperty then
            -- If ShowSecondaryMarketOnly is enabled, only show properties without owners
            if not propertyData.owner and Config.Marketplace.ShowSecondaryMarketOnly then
                shouldShowProperty = false
            end
        end
        
        -- Build property listing data
        if shouldShowProperty then
            -- Find the first available property image (check slots 1-5)
            local propertyImage = nil
            for imageSlot = 1, 5 do
                local slotKey = tostring(imageSlot)
                if propertyData.metadata.images and 
                   propertyData.metadata.images[slotKey] then
                    propertyImage = propertyData.metadata.images[slotKey]
                    break
                end
            end
            
            -- Get property features
            local hasGarage = propertyData.metadata.garage ~= nil
            local parkingSpaces = propertyData.metadata.parking
            
            -- Build address with region
            local fullAddress = propertyData.address
            if Config.Regions[propertyData.region] then
                fullAddress = fullAddress .. ", " .. propertyData.region
            end
            
            -- Get property area (zone information)
            local propertyArea = nil
            if propertyData.metadata and propertyData.metadata.zone then
                propertyArea = propertyData.metadata.zone.area
            end
            
            -- Create property listing entry
            propertiesList[propertyId] = {
                name = fullAddress,
                parking = parkingSpaces,
                garage = hasGarage,
                image = propertyImage,
                area = propertyArea,
                sale = propertyData.sale,
                rental = propertyData.rental
            }
            
            -- Add building information if this is part of a building/complex
            if propertyData.object_id then
                local buildingId = tostring(propertyData.object_id)
                local buildingData = Properties[buildingId]
                
                if buildingData then
                    propertiesList[propertyId].building = {
                        type = buildingData.type,
                        name = buildingData.name,
                        parkingSpaces = buildingData.metadata and 
                                       buildingData.metadata.parkingSpaces
                    }
                end
            end
        end
    end
    
    -- Prepare NUI message data
    local menuData = {
        action = "Marketplace",
        actionName = "Open",
        data = {
            propertiesList = propertiesList,
            noRegion = Config.NoRegion,
            regions = Config.Regions
        }
    }
    
    -- Open the marketplace UI
    SetNuiFocus(true, true)
    SendNUIMessage(menuData)
    openedMenu = "Marketplace"
end

-- ============================================================================
-- Close Marketplace Menu
-- ============================================================================
function closeMarketplace()
    SendNUIMessage({
        action = "Marketplace",
        actionName = "Close"
    })
    
    SetNuiFocus(false, false)
    openedMenu = nil
    isOfferByMarketplace = false
    marketplaceOfferId = nil
end

-- ============================================================================
-- Exports
-- ============================================================================

-- Export the marketplace function for external use
exports("OpenMarketplace", openMarketplace)