---------------------------------------
------------- Command - Say
---------------------------------------

------------- ?say
cuhFramework.commands.create("say", {"s"}, false, function(message, peer_id, admin, auth, command, ...)
    -- Get variables
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)
    local args = {...}

    -- Check
    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) or not admin then
        return
    end

    -- Main
    if not args[1] then
        return announceLibrary.status.failure("provide type | 1 = cuh says, 0 = no cuh says, just say", player)
    end

    if args[1] == "1" then
        -- cuh says
        table.remove(args, 1)
        announceLibrary.popupAnnounce("[Cuh Says]\n"..table.concat(args, " "), 6)
    else
        -- cuh no say
        table.remove(args, 1)
        announceLibrary.popupAnnounce(table.concat(args, " "), 6)
    end

    -- Effects
    local vehicle = cuhFramework.vehicles.spawnAddonVehicle(1, cuhFramework.utilities.matrix.offsetPosition((player:get_position()), 0, -10, 0))
    self = cuhFramework.callbacks.onVehicleLoad:connect(function(vehicle_id)
        if vehicle_id == vehicle.properties.vehicle_id then
            -- disconnect, no need to listen for vehicle loading anymore
            self:disconnect()

            -- start effects
            vehicle:press_button("start")

            -- despawn
            cuhFramework.utilities.delay.create(3, function()
                vehicle:despawn()
            end)
        end
    end)
end, "")