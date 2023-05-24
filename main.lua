------------------------------------------------------------------------
    --cuhFramework || An addon creation framework to make SW addon development easier. 
	-- 		Created by cuh4#7366
	--		cuhHub - Stormworks Server Hub: https://discord.gg/zTQxaZjwDr
	--		This framework is open-source: https://github.com/Roozz1/cuhFramework
------------------------------------------------------------------------

--------------
--[[
    cuhHub - Cuh Says
    Created by cuh4#7366 [cuhHub Developer]

    This addon uses cuhFramework, see above.

    UI IDs:
        peer_id + 15000 = Play Area Map Object
        peer_id + 16000 = Status
        peer_id + 17000 = Nametag
]]
--------------

----------------------------------------------------------------
-- Variables
----------------------------------------------------------------
---@type table<integer, player>
players_unfiltered = {}

----------------------------------------------------------------
-- Functions
----------------------------------------------------------------
------------- Uncategorised
chatAnnounce = function(message, player)
    cuhFramework.chat.send_message(miscellaneousLibrary.surround(config.info.addon_name, "[]"), message, player)
end

notificationAnnounce = function(message, player)
    cuhFramework.ui.notifications.custom(miscellaneousLibrary.surround(config.info.addon_name, "[]"), message, player, 7)
end

---@return player
getRandomPlayer = function()
    return cuhFramework.utilities.table.getRandomValue(players_unfiltered)
end

getSpawnPoint = function()
    return globalStorage:get("spawn_point") or matrix.translation(0, 0, 0)
end

----------------------------------------------------------------
-- Setup
----------------------------------------------------------------
------------- Inits
debugLibrary.initialize()
easyPopupsLibrary.initialize()
eventsLibrary.initialize()

------------- Storages
globalStorage = storageLibrary.new("Global Storage")

------------- Other
-- Set Spawn
globalStorage:add("spawn_point", matrix.translation(-9998.7, 20.4, -6993.7))

----------------------------------------------------------------
-- Loops
----------------------------------------------------------------
------------- Teleport disqualified players away
cuhFramework.utilities.loop.create(0.01, function()
    -- grab disqualified state
    local states = playerStatesLibrary.getAll()
    local disqualified = states["disqualify"]

    if not disqualified then
        return
    end

    -- get spawn point
    local toTeleport = cuhFramework.utilities.matrix.offsetPosition(getSpawnPoint(), 0, 15, 15)

    -- for everyone who is disqualified, teleport em above the spawn point
    for i, v in pairs(disqualified) do
        v:teleport(toTeleport)
    end
end)

----------------------------------------------------------------
-- Zones
----------------------------------------------------------------
------------- Game Area Zone
cuhFramework.customZones.createPlayerZone(getSpawnPoint(), config.game.playAreaSize, function(player, entered) ---@param player player
    -- no need to do anything if the player entered the zone
    if entered then
        return
    end

    -- admin, so ignore
    if player.properties.admin then
        return
    end

    -- prevent restricting twice in a second somehow
    if debounceLibrary.debounce("left_spawn_point_"..player.properties.peer_id, 0.5) then
        return
    end

    -- and teleport
    player:teleport(getSpawnPoint())
    chatAnnounce("You cannot leave the play area.", player)
end)

----------------------------------------------------------------
-- UI
----------------------------------------------------------------
------------- UI
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
        status:edit(to_show)
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
        nametag:edit(to_show)
    end)
end)

------------- Map UI
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