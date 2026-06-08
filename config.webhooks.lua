-- ██╗    ██╗███████╗██████╗ ██╗  ██╗ ██████╗  ██████╗ ██╗  ██╗███████╗
-- ██║    ██║██╔════╝██╔══██╗██║  ██║██╔═══██╗██╔═══██╗██║ ██╔╝██╔════╝
-- ██║ █╗ ██║█████╗  ██████╔╝███████║██║   ██║██║   ██║█████╔╝ ███████╗
-- ██║███╗██║██╔══╝  ██╔══██╗██╔══██║██║   ██║██║   ██║██╔═██╗ ╚════██║
-- ╚███╔███╔╝███████╗██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██╗███████║
--  ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝
Webhooks = {
    ['OBJECTS_PHOTOS_TOOL'] = "",   -- Needed to create furniture
    ['MARKETPLACE_PHOTOS'] = "",    -- Needed to marketplace option in manage
    

    -- Creator:
    ['CreatedProperty'] = "",
    ['EditedProperty'] = "",
    ['DeletedProperty'] = "",

    ['CreatedFurniture'] = "",
    ['EditedFurniture'] = "",
    ['DeletedFurniture'] = "",


    -- Property:
    ['PurchasedProperty'] = "",
    ['RentedProperty'] = "",
    ['LockpickedPropertyDoors'] = "",
    ['LockdownProperty'] = "",
    ['RemovedPoliceSealProperty'] = "",
    ['RaidProperty'] = "",
    ['BoughtKeys'] = "",
    ['GaveKeys'] = "",
    ['RemovedKeys'] = "",
    ['LockReplacement'] = "",
    ['OrderedFurniture'] = "",
    ['SoldFurniture'] = "",
    ['RemovedFurniture'] = "",
    ['ChangedSafePin'] = "",
    ['Upgraded'] = "",
    ['UpgradedToLevel'] = "",
    ['MarketplaceAdded'] = "",
    ['PaidBillRent'] = "",
    ['PaidBillServices'] = "",
    ['RentalTerminated'] = "",
    ['SetRentalTermination'] = "",
    ['StoppedRentalTermination'] = "",
    ['SoldProperty'] = "",
    ['RentedOutProperty'] = "",
    ['RentedOutPropertyFromMarketplace'] = "",
    ['AddedPermissions'] = "",
    ['UpdatedPermissions'] = "",
    ['RemovedPermissions'] = "",
}

WebhookText = {
    -- Creator:
    ['TITLE.CreatedProperty'] = "Created Property",
    ['DESCRIPTION.CreatedProperty'] = [[
        Player %s [%s] created a new **%s** Property #%s.

        Name: **%s**
        Description:
        **%s**
        
        Region: **%s**
        Address: **%s**
        Object: **%s**

        Sale: **%s**
        Rental: **%s**
    ]],
        
    ['TITLE.EditedProperty'] = "Edited Property",
    ['DESCRIPTION.EditedProperty'] = [[
        Player %s [%s] edited **%s** Property #%s.

        Name: **%s**
        Description:
        **%s**
        
        Region: **%s**
        Address: **%s**
        Object: **%s**

        Sale: **%s**
        Rental: **%s**
    ]],

    ['TITLE.DeletedProperty'] = "Deleted Property",
    ['DESCRIPTION.DeletedProperty'] = [[
        Player %s [%s] deleted Property #%s.
    ]],

    ['TITLE.CreatedFurniture'] = "Created Furniture",
    ['DESCRIPTION.CreatedFurniture'] = [[
        Player %s [%s] created a new furniture:

        ```
        %s
        ```
    ]],

    ['TITLE.EditedFurniture'] = "Edited Furniture",
    ['DESCRIPTION.EditedFurniture'] = [[
        Player %s [%s] edited furniture

        Label: **%s**
        Price: **$%s**
        Delivery Size: **%s**
        Tag: **%s**
        Is Outdoor: **%s**
        Is Indoor: **%s**
        Interactable Name: **%s**
        Metadata:
        **```json
        %s
        ```**
    ]],

    ['TITLE.DeletedFurniture'] = "Deleted Furniture",
    ['DESCRIPTION.DeletedFurniture'] = [[
        Player %s [%s] deleted furniture %s.
    ]],
    
    -- Property:
    ['TITLE.PurchasedProperty'] = "Purchased Property",
    ['DESCRIPTION.PurchasedProperty'] = [[
        Player %s [%s] purchased property #%s for $%s.
    ]],

    ['TITLE.RentedProperty'] = "Rented Property",
    ['DESCRIPTION.RentedProperty'] = [[
        Player %s [%s] rented property #%s for $%s/month.
    ]],

    ['TITLE.LockpickedPropertyDoors'] = "Lockpicked Property Doors",
    ['DESCRIPTION.LockpickedPropertyDoors'] = [[
        Player %s [%s] lockpicked property #%s doors.
    ]],

    ['TITLE.LockdownProperty'] = "Lockpicked Property Doors",
    ['DESCRIPTION.LockdownProperty'] = [[
        Player %s [%s] lockdowned property #%s.
    ]],
    
    ['TITLE.RemovedPoliceSealProperty'] = "Removed Police Seal",
    ['DESCRIPTION.RemovedPoliceSealProperty'] = [[
        Player %s [%s] have removed a police seal from property #%s.
    ]],
    
    ['TITLE.RaidProperty'] = "Raid Property",
    ['DESCRIPTION.RaidProperty'] = [[
        Player %s [%s] raided property #%s.
    ]],
    
    ['TITLE.BoughtKeys'] = "Bought Keys",
    ['DESCRIPTION.BoughtKeys'] = [[
        Player %s [%s] bought keys with serial **%s** to the property #%s.
    ]],
    
    ['TITLE.GaveKeys'] = "Gave the Keys",
    ['DESCRIPTION.GaveKeys'] = [[
        Player %s [%s] gave the keys key for %s [%s][%s] to the property #%s.
    ]],
    
    ['TITLE.RemovedKeys'] = "Removed Keys",
    ['DESCRIPTION.RemovedKeys'] = [[
        Player %s [%s] removed keys from %s [%s] to the property #%s.
    ]],
    
    ['TITLE.LockReplacement'] = "Lock Replacement",
    ['DESCRIPTION.LockReplacement'] = [[
        Player %s [%s] replaced lock from the property #%s.
    ]],

    ['TITLE.OrderedFurniture'] = "Ordered Furniture",
    ['DESCRIPTION.OrderedFurniture'] = [[
        Player %s [%s] ordered new furniture to property #%s.

        Furniture: **%s** (%s)
        
        Price: **$%s**
        Delivery Charge: **$%s**
        Total: **$%s**

        Delivery Time: <t:%s:R>

        Interactable Name: **%s**
        Metadata:
        **```json
        %s
        ```**
    ]],

    ['TITLE.SoldFurniture'] = "Sold Furniture",
    ['DESCRIPTION.SoldFurniture'] = [[
        Player %s [%s] sold furniture **%s** (%s) #%s in property #%s for **$%s**.
    ]],

    ['TITLE.RemovedFurniture'] = "Removed Furniture",
    ['DESCRIPTION.RemovedFurniture'] = [[
        Player %s [%s] removed furniture **%s** (%s) #%s in property #%s.
    ]],

    ['TITLE.ChangedSafePin'] = "Removed Furniture",
    ['DESCRIPTION.ChangedSafePin'] = [[
        Player %s [%s] changed PIN in safe #%s from %s to %s in property #%s.
    ]],

    ['TITLE.Upgraded'] = "Upgraded",
    ['DESCRIPTION.Upgraded'] = [[
        Player %s [%s] upgraded %s for $%s in property #%s.
    ]],
    
    ['TITLE.UpgradedToLevel'] = "Upgraded To Level",
    ['DESCRIPTION.UpgradedToLevel'] = [[
        Player %s [%s] upgraded %s to level %s for $%s in property #%s.
    ]],
    
    ['TITLE.MarketplaceAdded'] = "Marketplace Added",
    ['DESCRIPTION.MarketplaceAdded'] = [[
        Player %s [%s] added property #%s to marketplace.

        Description:
        **%s**
        Furnished: **%s**
        Contact Number: **%s**
        Sale: **%s**
        Rental: **%s**
    ]],

    ['TITLE.PaidBillRent'] = "Paid Rent Bill",
    ['DESCRIPTION.PaidBillRent'] = [[
        Player %s [%s] paid rent bill $%s in property #%s for period %s.

    ]],

    ['TITLE.PaidBillServices'] = "Paid Services Bill",
    ['DESCRIPTION.PaidBillServices'] = [[
        Player %s [%s] paid services bill $%s in property #%s for period %s.
    ]],

    ['TITLE.RentalTerminated'] = "Rental Terminated",
    ['DESCRIPTION.RentalTerminated'] = [[
        Player %s [%s] zakończył wynajem dla wynajmującego %s [%s] w nieruchomości #%s.
    ]],    

    ['TITLE.SetRentalTermination'] = "Rental Termination",
    ['DESCRIPTION.SetRentalTermination'] = [[
        Player %s [%s] ustawił zakończenie wynajmu na %s dla %s [%s] w nieruchomości #%s.
    ]],
    
    ['TITLE.StoppedRentalTermination'] = "Stopped Rental Termination",
    ['DESCRIPTION.StoppedRentalTermination'] = [[
        Player %s [%s] zatrzymał zakończenie wynajmu w nieruchomości #%s.
    ]],
    
    ['TITLE.SoldProperty'] = "Sold Property",
    ['DESCRIPTION.SoldProperty'] = [[
        Player %s [%s] sprzedał nieruchomość #%s dla %s [%s] za $%s.
    ]],
    
    ['TITLE.RentedOutProperty'] = "Rented Out Property",
    ['DESCRIPTION.RentedOutProperty'] = [[
        Player %s [%s] wynajął nieruchomość #%s dla %s [%s] za $%s/month.
    ]],
    
    ['TITLE.PurchasedPropertyFromMarketplace'] = "Purchased Property from Marketplace",
    ['DESCRIPTION.PurchasedPropertyFromMarketplace'] = [[
        Player %s [%s] zakupił nieruchomość #%s od %s [%s] za $%s.
    ]],
    
    ['TITLE.RentedOutPropertyFromMarketplace'] = "Rented Out Property from Marketplace",
    ['DESCRIPTION.RentedOutPropertyFromMarketplace'] = [[
        Player %s [%s] wynajął nieruchomość #%s od %s [%s] za $%s/month.
    ]],
    
    
    ['TITLE.AddedPermissions'] = "Added Permissions",
    ['DESCRIPTION.AddedPermissions'] = [[
        Player %s [%s] dodał permisje graczowi %s [%s] w nieruchomości #%s.
    ]],

    ['TITLE.UpdatedPermissions'] = "Updated Permissions",
    ['DESCRIPTION.UpdatedPermissions'] = [[
        Player %s [%s] zmienił permisje graczowi %s [%s] w nieruchomości #%s.

        Garage Access: %s
        Furniture: %s
        Bill Payments: %s
        Keys Management: %s
        Upgrades Management: %s
        Marketplace Manage: %s
        Sell: %s
        Automatic Sell: %s
        Rent: %s
        Renters Management: %s

    ]],

    ['TITLE.RemovedPermissions'] = "Removed Permissions",
    ['DESCRIPTION.RemovedPermissions'] = [[
        Player %s [%s] usunął permisje graczowi %s [%s] w nieruchomości #%s.
    ]],
    
}