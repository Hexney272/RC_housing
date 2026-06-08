if Config.Weather ~= 'qb-weathersync' and Config.Weather ~= 'qbx_weathersync' then
    return
end

function ToggleWeather(toggle, isIPL)
    if toggle then
        -- When the player enters the house
        if not isIPL then
            TriggerEvent('qb-weathersync:client:DisableSync')
        end
    else
        -- When the player leaves the house
        TriggerEvent('qb-weathersync:client:EnableSync')
        SetArtificialLightsState(false)
    end
end