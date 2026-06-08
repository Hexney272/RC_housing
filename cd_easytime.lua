if Config.Weather ~= 'cd_easytime' then
    return
end

function ToggleWeather(toggle, isIPL)
    if toggle then
        -- When the player enters the house
        
        if isIPL then
            TriggerEvent('cd_easytime:PauseSync', true)
        else
            TriggerEvent('cd_easytime:PauseSync', true, 23)
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
        TriggerEvent('cd_easytime:PauseSync', false)
        SetArtificialLightsState(false)
    end
end