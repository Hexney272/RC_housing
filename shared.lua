-- Shared Configuration (Client/Server)
-- Manages available shells and IPLs for the housing system
-- Provides functions to register new property types

-- ============================================================================
-- Global Tables
-- ============================================================================

AvailableShells = {}  -- Registered shell interiors
AvailableIPLS = {}    -- Registered IPL interiors

-- ============================================================================
-- Shell Management Functions
-- ============================================================================

-- Add shells to the available shells list
-- @param shellsTable: Table of shell configurations to add
--   Format: { shellId = { label, tags, rooms, model, doors } }
function addShells(shellsTable)
    -- Check if table has any data
    if not next(shellsTable) then
        return
    end
    
    -- Iterate through provided shells
    for shellId, shellConfig in pairs(shellsTable) do
        -- Check for duplicates
        if not AvailableShells[shellId] then
            AvailableShells[shellId] = shellConfig
        else
            warn("Duplicated shell " .. shellId .. "! (CANCELED ACTION)")
        end
    end
end

-- Reload shells in the NUI (web interface)
function reloadShells()
    SendNUIMessage({
        action = "Reload",
        availableShells = AvailableShells
    })
end

-- ============================================================================
-- IPL Management Functions
-- ============================================================================

-- Add IPLs to the available IPLs list
-- @param iplsTable: Table of IPL configurations to add
--   Format: { iplId = { settings, options, doors } }
function addIPLS(iplsTable)
    -- Check if table has any data
    if not next(iplsTable) then
        return
    end
    
    -- Iterate through provided IPLs
    for iplId, iplConfig in pairs(iplsTable) do
        -- Check for duplicates
        if not AvailableIPLS[iplId] then
            AvailableIPLS[iplId] = iplConfig
        else
            warn("Duplicated IPL " .. iplId .. "! (CANCELED ACTION)")
        end
    end
end