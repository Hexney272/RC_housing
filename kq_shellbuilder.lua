-- KuzQuality Shell Builder Integration
-- Automatically imports and registers custom shells from kq_shellbuilder resource
-- Synchronizes shell data with the housing system

-- ============================================================================
-- Check if KuzQuality shells are enabled in config
-- ============================================================================
if not Config.Shells.KuzQuality then
    return
end

-- ============================================================================
-- Wait for kq_shellbuilder resource to start
-- ============================================================================
local resourceTimeout = GetGameTimer() + 10000  -- 10 second timeout

-- Wait until resource is started or timeout
while true do
    local resourceState = GetResourceState("kq_shellbuilder")
    
    if resourceState == "started" then
        break
    end
    
    -- Check if timeout reached
    if resourceTimeout < GetGameTimer() then
        resourceTimeout = -1
        break
    end
    
    Citizen.Wait(100)
end

-- Handle timeout error
if resourceTimeout == -1 then
    return warn("KuzQuality Shell Creator is not started, please check the resource state.")
end

-- ============================================================================
-- Load and Register KuzQuality Shells
-- ============================================================================
local function loadKuzQualityShells()
    -- Fetch shells from kq_shellbuilder
    GlobalState.vms_housing_kq_shells = exports.kq_shellbuilder:GetShells()
    
    local shellsToRegister = {}
    
    -- Check if shells were loaded
    if GlobalState.vms_housing_kq_shells and next(GlobalState.vms_housing_kq_shells) then
        -- Process each shell
        for _, shellData in pairs(GlobalState.vms_housing_kq_shells) do
            local shellId = "kq_sbx_shell_" .. shellData.id
            
            shellsToRegister[shellId] = {
                label = shellData.title,
                tags = {"kuzquality"},
                rooms = 1,
                model = "kq_sbx_shell_" .. shellData.id,
                doors = {
                    x = shellData.spawnPoint.x,
                    y = shellData.spawnPoint.y,
                    z = 500.0 + (shellData.spawnPoint.z * 1.5),  -- Elevated spawn point
                    heading = shellData.spawnPoint.w
                }
            }
        end
        
        -- Register shells with housing system
        addShells(shellsToRegister)
    end
end

-- ============================================================================
-- Initialize Shell Loading
-- ============================================================================
Citizen.CreateThread(function()
    -- Initial load
    loadKuzQualityShells()
    
    Citizen.Wait(500)
    
    -- Retry if no shells were loaded
    if #GlobalState.vms_housing_kq_shells <= 0 then
        Citizen.Wait(2500)
        loadKuzQualityShells()
    end
end)

-- ============================================================================
-- Handle Shell Updates
-- ============================================================================
-- Register event for shell updates
RegisterNetEvent("kq_shellbuilder:update")

-- Reload shells when kq_shellbuilder notifies of updates
AddEventHandler("kq_shellbuilder:update", function()
    loadKuzQualityShells()
end)