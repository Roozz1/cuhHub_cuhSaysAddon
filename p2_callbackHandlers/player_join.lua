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

    -- status ui and nametag
    local object_id = player:get_character()

    local nametag = easyPopupsLibrary.physical.create(player.properties.name, matrix.translation(0, 3, 0), object_id, peer_id + 17000, nil, 5)
    local status = cuhFramework.ui.screen.create(peer_id + 15000, "Participant", 0, -0.6, player)

    cuhFramework.utilities.loop.create(0.1, function(id)
        if not cuhFramework.players.getPlayerByPeerId(peer_id) then
            cuhFramework.utilities.loop.ongoingLoops[id] = nil
            return
        end

        local to_show = cuhFramework.utilities.miscellaneous.switchbox(
            "Participant [:)]",
            "Eliminated [!]",
            playerStatesLibrary.hasState(player, "disqualify")
        )

        if status then
            status:edit(to_show)
        end

        if nametag then
            nametag:edit(player.properties.name.."\n"..to_show)
        end
    end)

    -- Add
    table.insert(players_unfiltered, player)
end)