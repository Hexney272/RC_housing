if Config.Clothing ~= 'qb-clothing' then
    return
end

function OpenWardrobe()
    TriggerEvent('qb-clothing:client:openOutfitMenu')
end