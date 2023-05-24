---------------------------------------
------------- Player Open Map
---------------------------------------

local openMap = eventsLibrary.new("openMap")

cuhFramework.callbacks.onToggleMap:connect(function(peer_id, opened)
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
    openMap:fire(player)
end)