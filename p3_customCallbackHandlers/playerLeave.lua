---------------------------------------
------------- Custom - Player Leave
---------------------------------------

------------- Remove enforcer object
---@param player player
eventsLibrary.get("playerLeave"):connect(function(player)
    -- check if admin first
    if not player.properties.admin then
        return
    end

    -- despawn object
    ---@type object|nil
    local object = playerTagsLibrary.getTag(player, "enforcer_object")

    if object then
        object:despawn()
    end
end)