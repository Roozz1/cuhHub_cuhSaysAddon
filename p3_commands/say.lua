---------------------------------------
------------- Command - Say
---------------------------------------

------------- ?say
cuhFramework.commands.create("say", {"s"}, false, function(message, peer_id, admin, auth, command, ...)
    -- Get variables
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)
    local args = {...}

    -- Checks
    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) or not admin then -- admin command, hence why this command isnt too user friendly
        return
    end

    if not args[1] then
        return announceLibrary.status.failure("provide type | 1 = cuh says, 0 = no cuh says, just say", player)
    end

    -- Main
    local saysType = cuhFramework.utilities.miscellaneous.switchbox("fake", "actual", args[1] == "1")
    local timer = tonumber(args[2])

    for i = 1, cuhFramework.utilities.miscellaneous.switchbox(1, 2, timer) do -- remove the first one or two args to get the full announcement
        table.remove(args, 1)
    end

    eventsLibrary.get("say"):fire(saysType, table.concat(args, " "), (player:get_position()), timer)
end, "")