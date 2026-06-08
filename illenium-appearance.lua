if Config.Clothing ~= 'illenium-appearance' then
    return
end

function OpenWardrobe()
    TriggerEvent("illenium-appearance:client:openOutfitMenu")
end