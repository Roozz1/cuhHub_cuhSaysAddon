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
        peer_id + 18000 = Spectating UI
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

---@param exception player
---@return player
getRandomPlayer = function(exception)
    local retrieved = cuhFramework.utilities.table.getRandomValue(players_unfiltered)

    if retrieved == exception and exception then
        return getRandomPlayer(exception)
    end

    return retrieved
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
------------- Teleport disqualified to whoever they are spectating
cuhFramework.utilities.loop.create(0.01, function()
    -- grab disqualified state
    local states = playerStatesLibrary.getAll()
    local disqualified = states["disqualify"]

    if not disqualified then
        return
    end

    -- for everyone who is disqualified, teleport em above whoever they are spectating
    for _, player in pairs(disqualified) do
        -- get player to spectate
        local target = playerTagsLibrary.getTag(player, "spectate")

        -- quick check
        if not target then
            df.print("no target tag despite player being disqualified!", nil, "(disqualify spectate loop)")
            goto continue
        end

        -- and teleport above em
        local toTeleport = cuhFramework.utilities.matrix.offsetPosition((target:get_position()), 0, 15, 15)
        player:teleport(toTeleport)

        -- thy continue replacement
        ::continue::
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
-- Handlers
----------------------------------------------------------------
------------- Disqualify
local disqualify = eventsLibrary.new("disqualify")

---@param player player
disqualify:connect(function(player)
    if playerStatesLibrary.hasState(player, "disqualify") then
        -- already disqualified, so give back participant status
        playerStatesLibrary.removeState(player, "disqualify")
        chatAnnounce(player.properties.name.." is now a participant.")

        -- remove tag
        playerTagsLibrary.removeTag(player, "spectate")
    else
        -- not disqualified, so disqualify
        playerStatesLibrary.setState(player, "disqualify")
        chatAnnounce(player.properties.name.." has been eliminated.")

        -- and give random player to spectate
        playerTagsLibrary.setTag(player, "spectate", getRandomPlayer(player))
    end
end)

------------- cuhSays
local cuhSays = eventsLibrary.new("cuhSays")

---@param type "actual"|"fake"
cuhSays:connect(function(type, message)
    -- thingy
    local function announce(msg)
        announceLibrary.popupAnnounce(msg, 6)
        chatAnnounce(msg, 6)
    end

    -- the main stuffs
    if type == "actual" then
        announce("[Cuh Says]\n"..message)
    elseif type =="fake" then
        announce(message)
    else
        df.print("invalid cuhSays type", nil, "(cuhSays Event Handler)")
    end
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
        nametag:edit(player.properties.name.."\n"..to_show)
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