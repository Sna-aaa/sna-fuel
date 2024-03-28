if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function ServerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb,  ...)
end

function ShowNotification(text, type)
	QBCore.Functions.Notify(text, type)
end

function ShowHelpNotification(text)
    local DrawTextLocation
    if text then
        exports['qb-core']:DrawText(text, DrawTextLocation)
    else
        exports['qb-core']:HideText()        
    end
end

function GetPlayerMoney()
    return QBCore.Functions.GetPlayerData().money['cash']
end

local CurrentWeaponData
function UpdateWeaponAmmo(ammo)
    TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, ammo)
end
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if bool ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)

--Target
function AddTargetModel(models, options, distance)
    exports['qb-target']:AddTargetModel(models, {options = options, distance = distance})
end

--Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
end)

RegisterNetEvent(GetCurrentResourceName()..":showNotification", function(text)
    ShowNotification(text)
end)


