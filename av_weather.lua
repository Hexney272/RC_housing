if Config.Weather ~= 'av_weather' then
    return
end

function ToggleWeather(toggle, isIPL)
    if toggle then
        -- When the player enters the house
        if not isIPL then
            TriggerEvent('av_weather:freeze', true, 23, 30, "EXTRASUNNY", false, false, false)
        end
    else
        -- When the player leaves the house
        TriggerEvent('av_weather:freeze', false)
        SetArtificialLightsState(false)
    end
end