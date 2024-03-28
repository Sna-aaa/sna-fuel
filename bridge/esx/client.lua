if GetResourceState('es_extended') ~= 'started' then return end

local ESX = exports.es_extended:getSharedObject()

function ShowNotification(text, type)
	ESX.ShowNotification(text, type)
end

local CurrentMessage
function ShowHelpNotification(text)
    CurrentMessage = text
end
CreateThread(function() -- Frame thread
    while true do
        local sleep = 1000
        if CurrentMessage then
            sleep = 0
            ESX.ShowHelpNotification(CurrentMessage)
        end
        Wait(sleep)
    end
end)

function ServerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb,  ...)
end

function GetPlayerMoney()
    local accounts = ESX.GetPlayerData().accounts
    for i = 1, #accounts do
        if accounts[i].name == 'money' then
            return accounts[i].money
        end
    end
    return false
end

function UpdateWeaponAmmo(ammo)
    TriggerServerEvent('ox_inventory:updateWeapon', "ammo", ammo)
end

--Target
function AddTargetModel(models, options, distance)
    exports.ox_target:addModel(models, options)
end

--Events
RegisterNetEvent('esx:playerLoaded',function(xPlayer, isNew, skin)
end)

RegisterNetEvent('esx:onPlayerDeath', function()
end)

RegisterNetEvent('esx:onPlayerSpawn', function()
end)



RegisterNetEvent(GetCurrentResourceName()..":showNotification", function(text)
    ShowNotification(text)
end)
