---------------------------------------
------------- Custom - Player Join
---------------------------------------

------------- Join Message
---@param player player
eventsLibrary.get("playerJoin"):connect(function(player)
    chatAnnounce("Welcome to the event! The event is simple, follow anything Cuh says IF his message begins with \"Cuh Says\". Last one participating wins.", player)
end)

------------- Mark Enforcers
---@param player player
eventsLibrary.get("playerJoin"):connect(function(player)
    -- check if admin first
    if not player.properties.admin then
        return
    end

    -- spawn object and attach to player
    local object = cuhFramework.objects.spawnObject((player:get_position()), 71) -- glowstick
    playerTagsLibrary.setTag(player, "enforcer_object", object) -- constantly teleported to player by loop above
end)