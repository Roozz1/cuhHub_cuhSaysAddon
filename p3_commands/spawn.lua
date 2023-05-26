---------------------------------------
------------- Command - Spawn
---------------------------------------

------------- ?spawn
cuhFramework.commands.create("spawn", {"sp"}, false, function(message, peer_id, admin, auth, command, ...)
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)
    local args = {...}

    -- Check
    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) or not admin then
        return
    end

    -- Main
    if not args[1] then
        return announceLibrary.status.failure("provide obj type", player)
    end

    -- Spawn the object
    cuhFramework.objects.spawnObject((player:get_position()), tonumber(args[1]) or 1)
end, "")