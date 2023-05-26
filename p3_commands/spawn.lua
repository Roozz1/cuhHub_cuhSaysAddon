---------------------------------------
------------- Command - Spawn
---------------------------------------

------------- ?spawn
cuhFramework.commands.create("spawn", {"sp"}, false, function(message, peer_id, admin, auth, command, ...)
    -- Get variables
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)
    local args = {...}

    -- Checks
    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) or not admin then
        return
    end

    if not args[1] then
        return announceLibrary.status.failure("provide type | 1 = cuh says, 0 = no cuh says, just say", player)
    end

    -- Main
    local saysType = cuhFramework.utilities.miscellaneous.switchbox("fake", "actual", args[1] == "1")

    table.remove(args, 1)
    eventsLibrary.get("say"):fire(saysType, table.concat(args, " "), (player:get_position()))
end, "")