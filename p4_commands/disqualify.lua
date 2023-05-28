---------------------------------------
------------- Command - Disqualify
---------------------------------------

------------- ?disqualify
cuhFramework.commands.create("disqualify", {"di"}, false, function(message, peer_id, admin, auth, command, ...)
    -- Get variables
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)
    local args = {...}

    -- Check
    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) or not admin then
        return
    end

    -- Main
    if not args[1] then
        return announceLibrary.status.failure("provide name", player)
    end

    -- Disqualify
    local target = cuhFramework.players.getPlayerByNameWithAllowedPartialName(table.concat(args, " "), false)

    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(target) then
        return announceLibrary.status.failure("invalid", player)
    end

    eventsLibrary.get("disqualify"):fire(target)
end, "")