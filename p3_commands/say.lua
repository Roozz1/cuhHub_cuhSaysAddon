---------------------------------------
------------- Command - Say
---------------------------------------

------------- ?say
cuhFramework.commands.create("say", {"s"}, false, function(message, peer_id, admin, auth, command, ...)
    -- Get variables
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)
    local args = {...}

    -- Checks
    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) or not admin then -- admin command, hence why code isnt too clean
        return
    end

    if not args[1] then
        return announceLibrary.status.failure("provide type | 1 = cuh says, 0 = no cuh says, just say", player)
    end

    -- Main
    if args[1] == "1" then
        -- cuh says
        table.remove(args, 1)
        eventsLibrary.get("cuhSays"):fire("actual", table.concat(args, " "), (player:get_position()))
    else
        -- cuh no say
        table.remove(args, 1)
        eventsLibrary.get("cuhSays"):fire("fake", table.concat(args, " "), (player:get_position()))
    end
end, "")