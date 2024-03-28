RegisterServerEvent('sna-fuel:server:Pay', function(amount)
    local src = source
    RemoveMoney(src, amount)
end)

RegisterServerEvent('sna-fuel:server:GiveJerrican', function()
    local src = source
    AddInventory(src, 'weapon_petrolcan', 1)
end)

RegisterServerEvent('sna-fuel:server:AttachRope', function(netIdProp, coordPumps, model)
	local src = source
    TriggerClientEvent('sna-fuel:client:AttachRope', -1, netIdProp, coordPumps, model, GetIdentifier(src))
end)

RegisterServerEvent('sna-fuel:server:DetachRope', function(srcin)
	local src = source
    TriggerClientEvent('sna-fuel:client:DetachRope', -1, GetIdentifier(src), srcin)
end)

RegisterNetEvent('sna-fuel:server:UpdateVehicleDateTimeIn', function(plate)
    MySQL.update('UPDATE '..GetDatabase()..' SET datetimein = ? WHERE '..GetDatabaseKeyField()..' = ?', {os.time(), plate})
end)

RegisterCallback('sna-fuel:server:GetTimeInGarage', function(source, cb, plate) 
    local result = MySQL.single.await('SELECT * FROM '..GetDatabase()..' WHERE '..GetDatabaseKeyField()..' = ?', { plate })
    if result then
        if result.datetimein and result.datetimein ~= 0 then
            cb(os.time() - result.datetimein)
        else
            cb(false)            
        end
    else
        cb(false)
    end
end)

RegisterCommand("fuel", "Set fuel/charge for vehicle", {{name = "amount", validate = false, help = "Amount", type = "number"}}, 'admin', function(xPlayer, args, showError)
    local amount = CommandGetArgs(args.amount, args[1])
    if not amount then
        amount = 100
    end
    CommandEventTrigger('sna-fuel:SetFuel', xPlayer, amount)
end)
