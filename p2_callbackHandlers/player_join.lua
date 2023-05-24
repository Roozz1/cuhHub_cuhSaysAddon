---------------------------------------
------------- Player Join
---------------------------------------

local playerJoin = eventsLibrary.new("playerJoin")

cuhFramework.callbacks.onPlayerJoin:connect(function(steam_id, name, peer_id, admin, auth)
    -- Get variables
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)

    -- Checks
    if not player then
        return
    end

    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) then
        return
    end

    -- Fire events
    playerJoin:fire(player)

    -- Add
    table.insert(players_unfiltered, player)
end)