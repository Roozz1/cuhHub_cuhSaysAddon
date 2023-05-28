---------------------------------------
------------- Custom - Disqualify
---------------------------------------

------------- Disqualify
local disqualify = eventsLibrary.new("disqualify")

---@param player player
disqualify:connect(function(player)
    if debounceLibrary.debounce("disqualify_"..player.properties.peer_id, config.game.timeToFullyEliminate) then
        return
    end

    if playerStatesLibrary.hasState(player, "disqualified") then
        -- already disqualified, so give back participant status
        playerStatesLibrary.removeState(player, "disqualified")
        chatAnnounce(player.properties.name.." is now a participant.")
    else
        -- ascend the player into a fire
        local pos = player:get_position()
        local dest = cuhFramework.utilities.matrix.offsetPosition(pos, 0, 5, 0)

        local fire = server.spawnFire(dest, 1, 1, true, false, 0, 0)

        local animation = cuhFramework.animation.createLinearAnimation(pos, dest, 0.09, false, function(animation) ---@param animation animation
            player:teleport(animation.properties.current_pos)
        end)

        -- wait some time for animation to finish
        cuhFramework.utilities.delay.create(config.game.timeToFullyEliminate, function()
            -- remove the fire
            server.despawnObject(fire, true)

            -- stop animation
            animation:remove()

            -- not disqualified, so disqualify
            playerStatesLibrary.setState(player, "disqualified")
            chatAnnounce(player.properties.name.." has been eliminated.")
        end)
    end
end)