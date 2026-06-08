-- Renewed-Weathersync Integration for VMS Housing
-- This script provides weather synchronization compatibility for Renewed-Weathersync

if Config.Weather ~= 'Renewed-Weathersync' then
    return
end

function ToggleWeather(toggle, isIPL)
    if toggle then
        -- When the player enters the house
        
        -- Renewed-Weathersync uses state bags for weather control
        -- We'll pause the weather sync for the player
        LocalPlayer.state.syncWeather = false
        
        if not isIPL then
            -- For shell houses, set nice weather and time
            Citizen.Wait(100)
            NetworkOverrideClockTime(23, 30, 0)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist('EXTRASUNNY')
            SetWeatherTypeNow('EXTRASUNNY')
            SetWeatherTypeNowPersist('EXTRASUNNY')
        end
    else
        -- When the player leaves the house
        -- Re-enable weather sync
        LocalPlayer.state.syncWeather = true
        -- Don't set artificial lights here as it's handled by the exit function
    end
end

-- Optional: Export function for other resources to check if weather is paused
exports('IsWeatherPaused', function()
    return LocalPlayer.state.syncWeather == false
end)
