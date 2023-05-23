---------------------------------------
------------- Character Load
---------------------------------------

cuhFramework.callbacks.onObjectLoad:connect(function(object_id)
    -- Get variables
    local player = cuhFramework.players.getPlayerByObjectId(object_id)

    -- Checks
    if not player then
        return
    end

    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) then
        return
    end

    -- Teleport
    player:teleport(globalStorage:get("spawn_point") or matrix.translation(0, 0, 0))
end)