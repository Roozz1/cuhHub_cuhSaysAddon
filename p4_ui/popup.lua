---------------------------------------
------------- UI - Popup
---------------------------------------
---@param player player
eventsLibrary.get("playerJoin"):connect(function(player)
    -- Participant Status
    local status = cuhFramework.ui.screen.create(player.properties.peer_id + 15000, "Participant", 0, -0.6, player)

    cuhFramework.utilities.loop.create(0.1, function(id)
        -- Quick check to see if player still exists
        if not cuhFramework.players.getPlayerByPeerId(player.properties.peer_id) then
            cuhFramework.utilities.loop.ongoingLoops[id] = nil
            return
        end

        -- Prepare UI Text
        local to_show = cuhFramework.utilities.miscellaneous.switchbox(
            "Participant [:)]",
            "Eliminated [!]",
            playerStatesLibrary.hasState(player, "disqualify")
        )

        -- Make sure UI is all good
        if not status then
            return
        end

        -- Andddd, edit the UI
        status:edit(player.properties.name.."\n"..to_show)
    end)

    -- Nametag [Physical]
    local object_id = player:get_character()
    local nametag = easyPopupsLibrary.physical.create(player.properties.name, matrix.translation(0, 3, 0), object_id, player.properties.peer_id + 17000, nil, 5)

    cuhFramework.utilities.loop.create(0.1, function(id)
        -- Quick check to see if player still exists
        if not cuhFramework.players.getPlayerByPeerId(player.properties.peer_id) then
            cuhFramework.utilities.loop.ongoingLoops[id] = nil
            return
        end

        -- Prepare UI text... again
        local to_show = cuhFramework.utilities.miscellaneous.switchbox(
            "Participant [:)]",
            "Eliminated [!]",
            playerStatesLibrary.hasState(player, "disqualify")
        )

        if player.properties.admin then
            to_show = "Enforcer [!!]"
        end

        -- Edit thy nametag UI
        nametag:edit(player.properties.name.."\n"..to_show)
        server.removePopup(player.properties.peer_id, nametag.properties.id)
    end)

    -- Enforcers
    local enforcers = cuhFramework.ui.screen.create(player.properties.peer_id + 18000, "Enforcers: N/A", 0, 0.92, player)
    local enforcersInServer = {} ---@type table<integer, player>

    eventsLibrary.get("playerJoin"):connect(function(newPlayer) ---@param newPlayer player
        if not newPlayer.properties.admin then
            return
        end

        table.insert(enforcersInServer, player.properties.name)
        enforcers:edit("Enforcers: "..table.concat(enforcersInServer, ", "))
    end)

    eventsLibrary.get("playerLeave"):connect(function(leftPlayer) ---@param leftPlayer player
        if not leftPlayer.properties.admin then
            return
        end

        for i, v in pairs(enforcersInServer) do
            if v.properties.peer_id == leftPlayer.properties.peer_id then
                table.remove(enforcersInServer, i)
            end
        end

        if #enforcersInServer <= 0 then
            enforcers:edit("Enforcers: N/A")
        else
            enforcers:edit("Enforcers: "..table.concat(enforcersInServer, ", "))
        end
    end)
end)