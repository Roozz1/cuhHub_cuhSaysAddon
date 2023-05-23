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

    -- UI
    local status = cuhFramework.ui.screen.create(peer_id + 15000, "Participant", 0, -0.9, player)
    cuhFramework.utilities.loop.create(0.5, function(id)
        if not cuhFramework.players.getPlayerByPeerId(peer_id) then
            cuhFramework.utilities.loop.ongoingLoops[id] = nil
            return
        end

        if status then
            status:edit(
                cuhFramework.utilities.miscellaneous.switchbox(
                    "Participant [:)]",
                    "Eliminated [!]",
                    playerStatesLibrary.hasState(player, "disqualify")
                )
            )
        end
    end)

    -- Add
    table.insert(players_unfiltered, player)
end)