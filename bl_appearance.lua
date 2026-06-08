if Config.Clothing ~= 'bl_appearance' then
    return
end

function OpenWardrobe()
    exports['bl_appearance']:OpenMenu('outfits')
end