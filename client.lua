local defaultData = Config.defaultData
local vehicleClassConfigurations = Config.vehicleClassConfigurations

-- Function to set vehicle handling data
function setVehData(vehicle, data)
    if not DoesEntityExist(vehicle) or not data then
        return
    end

    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce", data.braking)
    
    if Config.Debug == true then
        print('Handling data modified.')
    end
end

-- Function to check if a value exists in a table
function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Function to modify vehicle brakes based on class configuration
function ModifyVehicleBrakes(vehicle)
    if not DoesEntityExist(vehicle) or not IsEntityAVehicle(vehicle) then
        return
    end

    -- Retrieve the class of the vehicle
    local vehicleClass = GetVehicleClass(vehicle)

    -- Check if the vehicle class should be excluded (boats, planes, etc.)
    local excludedClasses = {8, 13, 14, 15, 16}
    if contains(excludedClasses, vehicleClass) then
        return
    end

    -- Retrieve the configuration based on the vehicle class or use default class configuration
    local config = vehicleClassConfigurations[vehicleClass] or defaultData

    -- Determine the configuration type
    local configType = vehicleClassConfigurations[vehicleClass] and "Class Found" or "Default"

    -- Apply the configuration to the vehicle
    setVehData(vehicle, config)

    if Config.Debug == true then
        -- Debugging prints
        local modelNameHash = GetEntityModel(vehicle)

        print('Vehicle Class: ' .. vehicleClass)
        print('Configuration Type: ' .. configType)
        print('Configuration: ' .. json.encode(config))
        print('Modified brakes for vehicle: ' .. tostring(vehicle))
    end
end

-- Exported function to be called from other scripts
exports('RealisticBrakes', function(vehicle)
    ModifyVehicleBrakes(vehicle)
end)



------------------------------------------------------------------------------------------------------------------------
local brakesModified = false

function OnPlayerEnterVehicle(vehicle)
    -- Check if the player is in the driver's seat and brakes haven't been modified yet
    if not brakesModified and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        ModifyVehicleBrakes(vehicle)
        brakesModified = true
    end
end

function UpdatePlayerVehicleStatus()
    local ped = PlayerPedId()
    local isInVehicle = IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false)

    if isInVehicle then
        -- Check if the player is in the driver's seat
        if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped then
            OnPlayerEnterVehicle(GetVehiclePedIsIn(ped, false))
        else
            -- Reset the flag if player is not in the driver's seat
            brakesModified = false
        end
    else
        -- Reset the flag if player is not in any vehicle
        brakesModified = false
    end
end



Citizen.CreateThread(function()
    while true do
        UpdatePlayerVehicleStatus()
        Wait(Config.Wait)  -- Adjust the delay as needed 5 secomds default
    end
end)


AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print('Resource started. Frequency Studios Realistic Brakes.')

    end
end)


------------------------------------------Simple Gearbox code. The below code is from pp2amd6.  OP found here https://github.com/pp2amd6/simpleGearbox ------------------------------

local PreventReverse = false
local PreventForward = false
local neutralGear = true

function ResetVariableStates()
    PreventReverse = false
    PreventForward = false
    neutralGear = true
end

function SpeedSetter()
    if (PreventReverse) then
        DisableControlAction(2, 72, true)
    else
        EnableControlAction(2, 72, true)
    end

    if (PreventForward) then
        DisableControlAction(2, 71, true)
    else
        EnableControlAction(2, 71, true)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()

        if (IsPedInAnyVehicle(ped)) then
            local veh = GetVehiclePedIsIn(ped, false)

            if (GetPedInVehicleSeat(veh, -1) == ped) then -- ped is driver?
                if (GetEntitySpeed(veh) > 0) then -- vehicle is moving
                    if (GetVehicleCurrentGear(veh) > 0) then -- forward gears
                        if ((IsControlPressed(2, 71) or IsDisabledControlPressed(2, 71)) and PreventForward) then -- INPUT_VEH_ACCELERATE
                            SpeedSetter()
                        else
                            PreventForward = false
                        end

                        if (IsControlPressed(2, 72)) then -- INPUT_VEH_BRAKE
                            PreventReverse = true
                        else
                            PreventReverse = false
                        end
                    else -- reverse gear (neutral also)
                        if ((IsControlPressed(2, 72) or IsDisabledControlPressed(2, 72)) and PreventReverse) then -- INPUT_VEH_BRAKE
                            SpeedSetter()
                        else
                            PreventReverse = false
                        end

                        if (IsControlPressed(2, 71) and (not neutralGear)) then -- INPUT_VEH_ACCELERATE
                            PreventForward = true
                        else
                            PreventForward = false
                            neutralGear = false
                        end
                    end
                else -- vehicle is stopped
                    neutralGear = true
                end
            end
        else
            ResetVariableStates()
        end
    end
end)