Config = {}


Config.Debug = false --Set to true to allow print statements when you get in a vehicle to see whats applied. only recommened when developing. 
Config.Wait = 5000 -- used to optizmize the resource .  this is how long it waits to check if player is in a vehcile.  5000 = 5 seconds. defalut. 
Config.defaultData = {  -- only used if class cant be found. 
    braking = 0.10
}

--does not effect bike.plane,bloat.heli
-- Value: 0.01 - 2.0 / above. 1.0 uses brake force calculation unmodified. 
-- I find that anything under 0.10 doesnt work well. 

Config.vehicleClassConfigurations = {
    [0] = { -- Compacts
        braking = 0.40
    },
    [1] = { -- Sedans
        braking = 0.45
    },
    [2] = { -- SUV's
        braking = 0.40
    },
    [3] = { -- Coupes
        braking = 0.45
    },
    [4] = { -- Muscle
        braking = 0.45
    },
    [5] = { -- Sport Classic
        braking = 0.45
    },
    [6] = { -- Sport
        braking = 0.45
    },
    [7] = { -- Super
        braking = 0.65
    },

    --[8]  Motorcycle

    [9] = { -- Offroad
        braking = 0.50
    },
    [10] = { -- Industrial
        braking = 0.45
    },
    [11] = { -- Utility
        braking = 0.45
    },
    [12] = { -- Vans
        braking = 0.45
    },
    --[13] = -- Bicycles
    --[14]  -- Boats 
    --[15]  -- Helicopter
    --[16] = -- Plane

    [17] = { -- Service
        braking = 0.65
    },
    [18] = { -- Emergency
        braking = 0.70
    },
    [19] = { -- Military
        braking = 0.65
    },
    [20] = { -- Commercial
        braking = 0.25
    },
}


-- note: slower classes like commercial trucks ... they dont go very fast so having brakes lower makes it more realistically