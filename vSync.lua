if Config.Weather ~= 'vSync' then
    return
end

function ToggleWeather(toggle, isIPL)
    if toggle then
        -- When the player enters the house
        TriggerEvent('vSync:toggle', false)
        TriggerEvent('vSync:updateWeather', 'EXTRASUNNY', false) 
        
        if not isIPL then
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
        TriggerEvent('vSync:toggle', true)
        TriggerServerEvent('vSync:requestSync')
        SetArtificialLightsState(false)
    end
end