---------------------------------------
------------- Player Join
---------------------------------------

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

    -- Credit
    -- chatAnnounce(("This server uses the %s created by %s.\nIf you would like to download the addon for yourself, join the Discord: %s."):format(config.info.addon_name, config.info.creator, config.info.discord), player)

    -- Add
    table.insert(players_unfiltered, player)
end)