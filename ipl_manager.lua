-- IPL Manager - Interior Prop List Management System
-- Handles loading and configuring game interiors with various options
-- Works with bob74_ipl resource for FiveM

IPL = {}

-- ============================================================================
-- Load Settings - Configure an interior with specified options
-- ============================================================================
-- @param iplName: Name of the IPL to configure
-- @param themeName: Theme/style to apply to the interior
-- @param enabledOptions: Table of options to enable (furniture, decorations, etc.)
-- @param callback: Optional callback function to execute after loading
function IPL.LoadSettings(iplName, themeName, enabledOptions, callback)
    -- Get IPL configuration from AvailableIPLS table
    local iplConfig = AvailableIPLS[iplName]
    if not iplConfig then
        return false
    end
    
    local settings = iplConfig.settings
    
    -- Get the interior export from bob74_ipl
    local interior = exports.bob74_ipl[settings.GetInteriorExport]()
    
    -- Clear existing style and apply new theme
    interior.Style.Clear()
    interior.Style.Set(interior.Style.Theme[themeName], true, false)
    
    -- Process interior options (furniture, decorations, etc.)
    if settings.options then
        for optionCategory, optionList in pairs(settings.options) do
            local itemsToDisable = {}
            local itemsToEnable = {}
            
            -- Check if this is a "Swag" (special decoration) category
            local isSwagCategory = interior.Swag and interior.Swag[optionCategory]
            
            if isSwagCategory then
                -- Handle Swag category items
                if interior.Swag[optionCategory] then
                    for itemName, itemValue in pairs(interior.Swag[optionCategory]) do
                        if not itemsToDisable[optionCategory] then
                            itemsToDisable[optionCategory] = {}
                        end
                        table.insert(itemsToDisable[optionCategory], itemValue)
                    end
                end
            else
                -- Handle regular category items
                if interior[optionCategory] then
                    for itemName, itemValue in pairs(optionList) do
                        local shouldEnable = false
                        
                        if not itemsToDisable[optionCategory] then
                            itemsToDisable[optionCategory] = {}
                        end
                        
                        -- Check if this item should be enabled based on user options
                        if enabledOptions and enabledOptions[optionCategory] then
                            for _, enabledItem in ipairs(enabledOptions[optionCategory]) do
                                if itemName == enabledItem then
                                    shouldEnable = true
                                    table.insert(itemsToEnable, interior[optionCategory][itemName])
                                    break
                                end
                            end
                        end
                        
                        -- Add to disable list if not enabled
                        if not shouldEnable then
                            table.insert(itemsToDisable[optionCategory], interior[optionCategory][itemName])
                        end
                    end
                end
            end
            
            -- Process items that should be enabled
            if enabledOptions and enabledOptions[optionCategory] ~= nil then
                if interior.Swag then
                    -- Enable Swag items
                    for _, itemName in ipairs(enabledOptions[optionCategory]) do
                        local itemConfig = settings.options[optionCategory][itemName]
                        if itemConfig ~= nil then
                            table.insert(itemsToEnable, interior.Swag[optionCategory][itemName])
                            
                            -- Remove from disable list if it was added
                            for i = #itemsToDisable[optionCategory], 1, -1 do
                                if itemsToDisable[optionCategory][i] == interior.Swag[optionCategory][itemName] then
                                    table.remove(itemsToDisable[optionCategory], i)
                                end
                            end
                        end
                    end
                end
                
                -- Enable the selected items
                if interior.Swag then
                    interior.Swag.Enable(itemsToEnable, true)
                else
                    if interior[optionCategory] and interior[optionCategory].Enable then
                        interior[optionCategory].Enable(itemsToEnable, true)
                    end
                end
            end
            
            -- Disable unselected items
            if interior.Swag then
                interior.Swag.Enable(itemsToDisable[optionCategory], false)
            end
        end
    end
    
    -- Handle Chairs option
    if settings.Chairs ~= nil then
        if enabledOptions and enabledOptions.Chairs then
            interior.Chairs.Set(interior.Chairs.on)
        else
            interior.Chairs.Set(interior.Chairs.off)
        end
    end
    
    -- Handle Booze (alcohol) option
    if settings.Booze ~= nil then
        if enabledOptions and enabledOptions.Booze then
            if interior.Booze.on ~= nil then
                interior.Booze.Set(interior.Booze.on)
            end
        else
            if interior.Booze.off ~= nil then
                interior.Booze.Set(interior.Booze.off)
            end
        end
    end
    
    -- Handle left safe door
    if settings.SafeLeft ~= nil then
        if enabledOptions and enabledOptions.SafeLeft then
            interior.Safe.Open("left", true)
        else
            interior.Safe.Close("left", false)
        end
    end
    
    -- Handle right safe door
    if settings.SafeRight ~= nil then
        if enabledOptions and enabledOptions.SafeRight then
            interior.Safe.Open("right", true)
        else
            interior.Safe.Close("right", false)
        end
    end
    
    -- Get interior ID at door coordinates and refresh it
    local interiorId = GetInteriorAtCoords(
        AvailableIPLS[iplName].doors.x,
        AvailableIPLS[iplName].doors.y,
        AvailableIPLS[iplName].doors.z
    )
    RefreshInterior(interiorId)
    
    -- Execute callback if provided
    if callback then
        callback()
    end
end

-- ============================================================================
-- Unload Settings - Reset an interior to default configuration
-- ============================================================================
-- @param iplName: Name of the IPL to reset
function IPL.UnloadSettings(iplName)
    -- Get IPL configuration
    local iplConfig = AvailableIPLS[iplName]
    if not iplConfig then
        return false
    end
    
    -- Get the interior export and load default settings
    local interior = exports.bob74_ipl[iplConfig.settings.GetInteriorExport]()
    interior.LoadDefault()
end

-- Export the IPL module
return IPL