---------------------------------------
------------- Custom - Say
---------------------------------------

------------- Say
local say = eventsLibrary.new("say")

local function announce(msg)
    announceLibrary.popupAnnounce(msg, 6)
    chatAnnounce(msg)
end

---@param sayType "actual"|"fake"
say:connect(function(sayType, message, effectsPos)
    -- the main stuffs
    if sayType == "actual" then
        announce("Cuh Says: "..message)
    elseif sayType == "fake" then
        announce(message)
    else
        df.print("invalid cuhSays type", nil, "(say Event Handler)")
    end

    -- effects
    local vehicle = cuhFramework.vehicles.spawnAddonVehicle(1, cuhFramework.utilities.matrix.offsetPosition(effectsPos, 0, 25, 0))

    local self
    self = cuhFramework.callbacks.onVehicleLoad:connect(function(vehicle_id)
        if vehicle_id == vehicle.properties.vehicle_id then
            -- disconnect, no need to listen for vehicle loading anymore
            self:disconnect()

            -- start effects
            vehicle:press_button("activate")

            -- despawn
            cuhFramework.utilities.delay.create(3, function()
                vehicle:despawn()
            end)
        end
    end)
end)