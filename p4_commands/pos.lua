---------------------------------------
------------- Command - Pos
---------------------------------------

------------- ?pos
cuhFramework.commands.create("pos", {"p"}, false, function(message, peer_id, admin, auth, command, ...)
    -- Get variables
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)
    local args = {...}

    -- Check
    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) or not admin then
        return
    end

    -- Show pos
    chatAnnounce(miscellaneousLibrary.matrixFormatted((player:get_position())))
end, "")