---------------------------------------
------------- Player Open Map
---------------------------------------

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

    -- Show play area
    local spawnPoint = getSpawnPoint()
    local color = colorLibrary.RGB.new(0, 125, 255, 255)

    server.removeMapObject(peer_id, peer_id + 15000)
    server.addMapObject(
        peer_id,
        peer_id + 15000,
        0,
        9,
        spawnPoint[13],
        spawnPoint[15],
        0,
        0,
        0,
        0,
        "Play Area",
        config.game.playAreaSize,
        "You cannot leave this area.",
        colorLibrary.RGB.unpack(color)
    )
end)