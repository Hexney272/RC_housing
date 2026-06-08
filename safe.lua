-- Safe/Storage PIN Code Management System
-- Handles secure access to storage with PIN code verification
-- Supports first-time setup and PIN code changes

-- ============================================================================
-- Global Variables
-- ============================================================================

local currentSafeFurnitureId = nil     -- ID of the safe furniture being accessed
local currentSafeData = nil            -- Safe data including PIN and configuration

-- ============================================================================
-- Open Safe Interface
-- ============================================================================
-- Opens the safe UI, either for first-time PIN setup or PIN verification
-- @param safeFurnitureId: The furniture ID of the safe
-- @param safeData: Safe configuration data including PIN
function OpenSafe(safeFurnitureId, safeData)
    -- Validate parameters
    if not safeFurnitureId or not safeData then
        return
    end
    
    -- Enable NUI focus for interaction
    SetNuiFocus(true, true)
    openedMenu = "Safe"
    
    -- Store safe information
    currentSafeFurnitureId = safeFurnitureId
    currentSafeData = safeData
    
    -- Check if PIN is set
    if not safeData.pin or safeData.pin == "" then
        -- First time setup - no PIN set yet
        SendNUIMessage({
            action = "Safe",
            actionName = "SetFirstTime"
        })
    else
        -- PIN exists - show verification screen
        SendNUIMessage({
            action = "Safe",
            actionName = "Open"
        })
    end
end

-- ============================================================================
-- Close Safe Interface
-- ============================================================================
-- Closes the safe UI and clears stored data
function CloseSafe()
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        action = "Safe",
        actionName = "Close"
    })
    
    openedMenu = nil
    currentSafeFurnitureId = nil
    currentSafeData = nil
end

-- ============================================================================
-- NUI Callback: Verify PIN Code
-- ============================================================================
-- Verifies entered PIN code against stored PIN
-- Opens storage if successful, or allows PIN change
RegisterNuiCallback("safe:verifyCode", function(data, callback)
    local storedPin = currentSafeData and currentSafeData.pin
    local enteredCode = data.code
    
    -- Check if entered code matches stored PIN
    if storedPin == enteredCode then
        -- PIN is correct
        if storedPin and storedPin ~= "" then
            callback(true)
            
            -- If not changing PIN, open the storage
            if not data.isChanging then
                SetNuiFocus(false, false)
                
                -- Open storage after brief delay for UI transition
                Citizen.CreateThread(function()
                    Citizen.Wait(1200)
                    
                    -- Open the storage interface
                    CL.InteractableFurniture(
                        nil,
                        "storage",
                        currentSafeFurnitureId,
                        currentSafeData
                    )
                    
                    -- Clear safe data
                    currentSafeFurnitureId = nil
                    currentSafeData = nil
                end)
            end
        end
    else
        -- PIN is incorrect
        callback(false)
    end
end)

-- ============================================================================
-- NUI Callback: Change PIN Code
-- ============================================================================
-- Updates the safe's PIN code after verification
RegisterNUICallback("safe:changeCode", function(data, callback)
    local oldCode = data.oldCode
    local newCode = data.newCode
    
    -- Get current property ID
    local propertyId = CurrentProperty or GetCurrentPropertyId()
    
    -- Send to server for verification and update
    TriggerServerEvent(
        "vms_housing:sv:changeSafePin",
        propertyId,
        currentSafeFurnitureId,
        newCode,
        oldCode
    )
end)