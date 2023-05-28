---------------------------------------
------------- UI - Map
---------------------------------------
---@param player player
eventsLibrary.get("openMap"):connect(function(player)
    -- Play Area
    local spawnPoint = getSpawnPoint()
    local color = colorLibrary.RGB.new(0, 125, 255, 255)

    server.removeMapObject(player.properties.peer_id, player.properties.peer_id + 15000)
    server.addMapObject(
        player.properties.peer_id,
        player.properties.peer_id + 15000,
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