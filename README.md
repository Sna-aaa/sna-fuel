# sna-fuel
Fuel script that cover all vehicles, fuel, electric, air, sea with fuel nozzles and electric charging
For ESX and QBCore

Video : https://youtu.be/JC8tyz8AI5E
Package : https://github.com/Sna-aaa/sna-fuel

## Features
- Pumps with nozzle for electric or fuel
- Gas pump for fuel vehicles
- Electric chargers for electric vehicles
- Out of energies are handled by the script, the vehicle just stop his motor, no more sparks and backwards
- Every vehicles excepted blacklisted ones will stop when out of energy
- Electric cars have a specific consumption model (with nothing at idle)
- Electric cars have a charge curve (quickly until 80% then more and more slowly)
- Electric cars have a discharge curve (slowly until 40% then more and more quickly)
- Consumption can be specified for each vehicle separately
- Tank sizes can be specified for each vehicle separately
- Energy is specified in L or Kw, and price can be configured
- Automatic charging of electric vehicles in garages
- Admin command /fuel to refuel/charge vehicles
- Working jerrican for fuel vehicles
- Jerrican capacity is configurable
- A new export "ApplyFuel" to apply fuel without electric charge for persistence scripts
- Server synced nozzles and hozes

## Hud
This resource doesn't use standard GTA fuel level anymore, so to adapt your hud:
Verify if your hud is LegacyFuel compatible, to do so open the client script and search for:
GetVehicleFuelLevel(vehicle)                Resource is not LegacyFuel compatible
exports['LegacyFuel']:GetFuel(vehicle)      Resource is LegacyFuel compatible
For LegacyFuel compatible resources, just replace "LegacyFuel" with "sna-fuel" or what you named the directory of this script
For not compatible resources, you can replace GetVehicleFuelLevel(vehicle) by exports['sna-fuel']:GetFuel(vehicle)

## Requirements
- [es_extended] or [qb-core]
- [ox_inventory] or [qb-inventory]
- [ox_target] or [qb-target]

- [wtf_tesla_supercharger](https://github.com/wtf-fivem-mods/wtf_tesla_supercharger)

## Installation

1) Remove any fuel or electricity script that you may have including LegacyFuel, ps-fuel etc

2) Replace all occurences of "LegacyFuel" by "sna-fuel" (or wathever your directory name is) in all your resources

3) Replace all occurences of "GetVehicleFuelLevel(" by "exports['sna-fuel']:GetFuel(" in all your resources
Exemple of hud configuration esx_hud/client/vehicle/fuel.lua
```lua
if not Config.Disable.Vehicle then
    if GetResourceState("ox_fuel") == "started" then
        function HUD:FuelExport()
            return ESX.Math.Round(GetVehicleFuelLevel(HUD.Data.Vehicle), 2)
        end
    elseif GetResourceState("LegacyFuel") == "started" then
        function HUD:FuelExport()
            return ESX.Math.Round(exports["LegacyFuel"]:GetFuel(HUD.Data.Vehicle), 2)
        end
    elseif GetResourceState("sna-fuel") == "started" then
        function HUD:FuelExport()
            return ESX.Math.Round(exports["sna-fuel"]:GetFuel(HUD.Data.Vehicle), 2)
        end
    else
        function HUD:FuelExport()
            return false
        end
        TriggerServerEvent("esx_hud:ErrorHandle", "Setup your custom fuel resource at: client/vehicle/fuel.lua")
    end
end
```
4) If you want to use the auto charging function for electric vehicles in garage:
- Import the database.sql in your database
- In your garage script a line with UpdateVehicleDateTimeIn must be added when you park the car just before the vehicle deletion, here in qb-garage
```lua
local function enterVehicle(veh, indexgarage, type, garage)
    local plate = QBCore.Functions.GetPlate(veh)
    if GetVehicleNumberOfPassengers(veh) == 0 then
        QBCore.Functions.TriggerCallback('qb-garage:server:checkOwnership', function(owned)
            if owned then
                local bodyDamage = math.ceil(GetVehicleBodyHealth(veh))
                local engineDamage = math.ceil(GetVehicleEngineHealth(veh))
                local totalFuel = GetFuel(veh)
                local props = QBCore.Functions.GetVehicleProperties(veh)
                TriggerServerEvent('qb-garage:server:updateVehicle', 1, totalFuel, engineDamage, bodyDamage, plate, indexgarage, type, PlayerGang.name, Damages)
                TriggerServerEvent('sna-fuel:server:UpdateVehicleDateTimeIn', plate)     --Change
                DeleteVehicle(veh, garage)
                if type == "house" then
                    exports['qb-core']:DrawText(Lang:t("info.car_e"), 'left')
                    InputOut = true
                    InputIn = false
                end
    
                if plate then
                    TriggerServerEvent('qb-garage:server:UpdateOutsideVehicle', plate, nil)
                end
                QBCore.Functions.Notify(Lang:t("success.vehicle_parked"), "primary", 4500)
            else
                QBCore.Functions.Notify(Lang:t("error.not_owned"), "error", 3500)
            end
        end, plate, type, indexgarage, PlayerGang.name)
    else
        QBCore.Functions.Notify(Lang:t("error.vehicle_occupied"), "error", 5000)
    end
end
```