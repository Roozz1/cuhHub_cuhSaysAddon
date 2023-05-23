---------------------------------------
------------- Player Leave
---------------------------------------

cuhFramework.callbacks.onPlayerLeave:connect(function(steam_id, name, peer_id, admin, auth)
    -- Get variables
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)

    -- Checks
    if not player then
        return
    end

    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player, true) then
        return
    end

    -- Remove from players table
    for i, v in pairs(players_unfiltered) do
        if v.properties.peer_id == peer_id then
            table.remove(players_unfiltered, i)
        end
    end

    -- Clear States
    cuhFramework.utilities.delay.create(0.01, function() -- give time for other playerleave callbacks using plaayerstates to do stuff
        playerStatesLibrary.clearStates(player)
    end)
end)