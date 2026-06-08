SV = {}

-- ██╗    ██╗███████╗██████╗ ██╗  ██╗ ██████╗  ██████╗ ██╗  ██╗███████╗
-- ██║    ██║██╔════╝██╔══██╗██║  ██║██╔═══██╗██╔═══██╗██║ ██╔╝██╔════╝
-- ██║ █╗ ██║█████╗  ██████╔╝███████║██║   ██║██║   ██║█████╔╝ ███████╗
-- ██║███╗██║██╔══╝  ██╔══██╗██╔══██║██║   ██║██║   ██║██╔═██╗ ╚════██║
-- ╚███╔███╔╝███████╗██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██╗███████║
--  ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝
SV.Webhook = function(webhook_id, title, description, color, footer)
    local DiscordWebHook = Webhooks[webhook_id]
    if not DiscordWebHook or DiscordWebHook == "" then
        return
    end
    local embeds = {{
        ["title"] = title,
        ["type"] = "rich",
        ["description"] = description,
        ["color"] = color,
        ["footer"] = {
            ["text"] = footer..' - '..os.date(),
        },
    }}
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({embeds = embeds}), {['Content-Type'] = 'application/json'})
end



-- ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
-- ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
-- █████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
-- ██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
-- ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
-- ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
SV.GetPlayer = function(src)
    if Config.Core == "ESX" then
        return Core.GetPlayerFromId(src)
    elseif Config.Core == "QB-Core" then
        return Core.Functions.GetPlayer(src)
    end
end

SV.GetSource = function(xPlayer)
    if Config.Core == "ESX" then
        return xPlayer.source
    elseif Config.Core == "QB-Core" then
        return xPlayer.PlayerData.source
    end
end

SV.GetIdentifier = function(xPlayer)
    if Config.Core == "ESX" then
        return xPlayer.identifier
    elseif Config.Core == "QB-Core" then
        return xPlayer.PlayerData.citizenid
    end
end

SV.GetPlayerByIdentifier = function(identifier)
    if Config.Core == "ESX" then
        return Core.GetPlayerFromIdentifier(identifier)
    elseif Config.Core == "QB-Core" then
        return Core.Functions.GetPlayerByCitizenId(identifier)
    end
end

SV.GetCharacterName = function(xPlayer)
    if Config.Core == "ESX" then
        return xPlayer.getName()
    elseif Config.Core == "QB-Core" then
        return xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    end
end

SV.GetPlayerJob = function(xPlayer, type)
    if Config.Core == "ESX" and xPlayer.job then
        if type == "table" then
            return xPlayer.job
        end
        if type == "name" then
            return xPlayer.job.name
        end
        if type == "label" then
            return xPlayer.job.label
        end
        if type == "grade" then
            return xPlayer.job.grade
        end
        if type == "grade_name" then
            return xPlayer.job.grade_name
        end
    elseif Config.Core == "QB-Core" and xPlayer.PlayerData.job then
        if type == "table" then
            return xPlayer.PlayerData.job
        end
        if type == "name" then
            return xPlayer.PlayerData.job.name
        end
        if type == "label" then
            return xPlayer.PlayerData.job.label
        end
        if type == "grade" then
            return xPlayer.PlayerData.job.grade.level
        end
        if type == "grade_name" then
            return xPlayer.PlayerData.job.grade.name
        end
    end
    return nil
end



-- ███╗   ███╗ ██████╗ ███╗   ██╗███████╗██╗   ██╗
-- ████╗ ████║██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝
-- ██╔████╔██║██║   ██║██╔██╗ ██║█████╗   ╚████╔╝ 
-- ██║╚██╔╝██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝  
-- ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║███████╗   ██║   
-- ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝   
SV.GetMoney = function(xPlayer, moneyType)
    if Config.Core == "ESX" then
        local moneyType = moneyType == 'cash' and 'money' or moneyType
        return xPlayer.getAccount(moneyType).money
    elseif Config.Core == "QB-Core" then
        return xPlayer.Functions.GetMoney(moneyType)
    end
end

SV.AddMoney = function(xPlayer, moneyType, count)
    if Config.Core == "ESX" then
        local moneyType = moneyType == 'cash' and 'money' or moneyType == 'dirty' and 'black_money' or moneyType
        xPlayer.addAccountMoney(moneyType, count)
    elseif Config.Core == "QB-Core" then
        xPlayer.Functions.AddMoney(moneyType, count)
    end
end

SV.RemoveMoney = function(xPlayer, moneyType, count)
    if Config.Core == "ESX" then
        local moneyType = moneyType == 'cash' and 'money' or moneyType
        xPlayer.removeAccountMoney(moneyType, count)
    elseif Config.Core == "QB-Core" then
        xPlayer.Functions.RemoveMoney(moneyType, count)
    end
end

SV.AddMoneyOffline = function(identifier, moneyType, count)
    if Config.Core == "ESX" then
        local moneyType = moneyType == 'cash' and 'money' or moneyType == 'dirty' and 'black_money' or moneyType

        local data = MySQL.query.await("SELECT accounts FROM `users` WHERE `identifier` = @identifier", {
            ['@identifier'] = identifier
        })
        if not data or not data[1] then return end

        local accounts = json.decode(data[1].accounts)
        if not accounts or not accounts[moneyType] then return end

        accounts[moneyType] = tonumber(accounts[moneyType]) + tonumber(count)
        local updatedAccountsJson = json.encode(accounts)
        MySQL.Async.execute('UPDATE `users` SET accounts = @accounts WHERE `identifier` = @identifier', {
            ['@accounts'] = updatedAccountsJson,
            ['@identifier'] = identifier
        })

    elseif Config.Core == "QB-Core" then
        local data = MySQL.query.await("SELECT money FROM `players` WHERE `citizenid` = @citizenid", {
            ['@citizenid'] = identifier
        })
        if not data or not data[1] then return end

        local accounts = json.decode(data[1].money)
        if not accounts or not accounts[moneyType] then return end

        accounts[moneyType] = tonumber(accounts[moneyType]) + tonumber(count)
        local updatedAccountsJson = json.encode(accounts)
        MySQL.Async.execute('UPDATE `players` SET money = @money WHERE `citizenid` = @citizenid', {
            ['@money'] = updatedAccountsJson,
            ['@citizenid'] = identifier
        })
    end
end



-- ██╗████████╗███████╗███╗   ███╗███████╗
-- ██║╚══██╔══╝██╔════╝████╗ ████║██╔════╝
-- ██║   ██║   █████╗  ██╔████╔██║███████╗
-- ██║   ██║   ██╔══╝  ██║╚██╔╝██║╚════██║
-- ██║   ██║   ███████╗██║ ╚═╝ ██║███████║
-- ╚═╝   ╚═╝   ╚══════╝╚═╝     ╚═╝╚══════╝
SV.RegisterUsableItem = function(name, cb)
    if RegisterUsableItem then -- The script looks for functions in ./integration/[inventory]/*
        RegisterUsableItem(name, cb)
    else
        if Config.Core == "ESX" then
            Core.RegisterUsableItem(name, function(src, itemName, itemData)
                cb(src, itemName, {metadata = itemData.metadata})
            end)
        elseif Config.Core == "QB-Core" then
            Core.Functions.CreateUseableItem(name, function(src, item)
                cb(src, item.name, {metadata = item.info})
            end)
        end
    end
end

SV.GetItem = function(src, xPlayer, name, data, search)
    if search == 'key' then
        if GetItem then -- The script looks for functions in ./integration/[inventory]/*
            return GetItem(src, xPlayer, 'house_key', data, search)
        end
    end
end

SV.GetItemCount = function(xPlayer, name)
    if Config.Core == "ESX" then
        return xPlayer.getInventoryItem(name).count
    elseif Config.Core == "QB-Core" then
        return xPlayer.Functions.GetItemByName(name) and xPlayer.Functions.GetItemByName(name).amount or 0
    end
end

SV.AddItem = function(src, xPlayer, name, count, metadata)
    if AddItem then -- The script looks for functions in ./integration/[inventory]/*
        AddItem(src, xPlayer, name, count, metadata)
    else
        if Config.Core == "ESX" then
            xPlayer.addInventoryItem(name, count)
        elseif Config.Core == "QB-Core" then
            xPlayer.Functions.AddItem(name, count)
        end
    end
end

SV.RemoveItem = function(src, xPlayer, name, count)
    if RemoveItem then -- The script looks for functions in ./integration/[inventory]/*
        RemoveItem(src, xPlayer, name, count)
    else
        if Config.Core == "ESX" then
            xPlayer.removeInventoryItem(name, count)
        elseif Config.Core == "QB-Core" then
            xPlayer.Functions.RemoveItem(name, count)
        end
    end
end



--  ██████╗██╗████████╗██╗   ██╗██╗  ██╗ █████╗ ██╗     ██╗     
-- ██╔════╝██║╚══██╔══╝╚██╗ ██╔╝██║  ██║██╔══██╗██║     ██║     
-- ██║     ██║   ██║    ╚████╔╝ ███████║███████║██║     ██║     
-- ██║     ██║   ██║     ╚██╔╝  ██╔══██║██╔══██║██║     ██║     
-- ╚██████╗██║   ██║      ██║   ██║  ██║██║  ██║███████╗███████╗
--  ╚═════╝╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝
SV.AddTax = function(identifier, characterName, propertyName, propertyAddress, type, fromAmount)
    local isCityHall = GetResourceState('vms_cityhall') == 'started'
    if not isCityHall then return false end
    if not Config.CityHallTaxes then return false end

    local amount = 0
    local percentage = 0

    if type == 'property_purchase_tax' then
        if Config.CityHallTaxes.PropertyPurchase.Type == 'percentage' then
            amount = fromAmount
            percentage = Config.CityHallTaxes.PropertyPurchase.Value
        else
            amount = Config.CityHallTaxes.PropertyPurchase.Value
            percentage = 100
        end
        
        if amount >= 1 and percentage >= 1 then
            exports['vms_cityhall']:addPlayerCustomTaxToPay({
                identifier = identifier,
                characterName = characterName,
            }, amount, percentage, (Config.CityHallTaxes.PropertyPurchase.Title):format(propertyName, propertyAddress))
        end

    elseif type == 'property_resale_tax' then
        if Config.CityHallTaxes.PropertyResale.Type == 'percentage' then
            amount = fromAmount
            percentage = Config.CityHallTaxes.PropertyResale.Value
        else
            amount = Config.CityHallTaxes.PropertyResale.Value
            percentage = 100
        end

        if amount >= 1 and percentage >= 1 then
            exports['vms_cityhall']:addPlayerCustomTaxToPay({
                identifier = identifier,
                characterName = characterName,
            }, amount, percentage, (Config.CityHallTaxes.PropertyResale.Title):format(propertyName, propertyAddress))
        end

    elseif type == 'rental_income_tax' then
        if Config.CityHallTaxes.RentalIncome.Type == 'percentage' then
            amount = fromAmount
            percentage = Config.CityHallTaxes.RentalIncome.Value
        else
            amount = Config.CityHallTaxes.RentalIncome.Value
            percentage = 100
        end
        
        if amount >= 1 and percentage >= 1 then
            exports['vms_cityhall']:addPlayerCustomTaxToPay({
                identifier = identifier,
                characterName = characterName,
            }, amount, percentage, (Config.CityHallTaxes.RentalIncome.Title):format(propertyName, propertyAddress))
        end
        
    elseif type == 'property_cadastral_tax' then
        if Config.CityHallTaxes.PropertyCadastralTax.Type == 'percentage' then
            amount = fromAmount
            percentage = Config.CityHallTaxes.PropertyCadastralTax.Value
        else
            amount = Config.CityHallTaxes.PropertyCadastralTax.Value
            percentage = 100
        end
        
        if amount >= 1 and percentage >= 1 then
            exports['vms_cityhall']:addPlayerCustomTaxToPay({
                identifier = identifier,
                characterName = characterName,
            }, amount, percentage, (Config.CityHallTaxes.PropertyCadastralTax.Title):format(propertyName, propertyAddress))
        end

    end

    return true -- DO NOT REMOVE!
end



-- ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
-- ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
-- ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
-- ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
--  ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
--   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝
SV.CanEnterHouse = function(src, xPlayer)
    -- This function is triggered when a player tries to enter the property.
    -- You can return false to block access, for example if they are handcuffed or anything else
    return true
end

SV.CanExitHouse = function(src, xPlayer)
    -- This function is triggered when a player tries to exit the property.
    -- You can return false to block access, for example if they are handcuffed or anything else
    return true
end
