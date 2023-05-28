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
    local retrieved = cuhFramework.utilities.table.getRandomValue(players_unfiltered)
    return retrieved
end

getSpawnPoint = function()
    return globalStorage:get("spawn_point") or matrix.translation(0, 0, 0)
end

----------------------------------------------------------------
-- Setup
----------------------------------------------------------------
------------- Reload
for i = 1, 25000 do
    server.removePopup(-1, i)
    server.removeMapID(-1, i)
    server.despawnVehicle(i, true)
    server.despawnObject(i, true)
end

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
------------- Random meteors
local meteorPositions = {
    matrix.translation(-9828.7, -0.8, -6582.5),
    matrix.translation(-9852.5, 11.5, -7414.6),
    matrix.translation(-10470.8, 12.9, -7333.8)
}

cuhFramework.utilities.loop.create(20, function()
    local position = cuhFramework.utilities.table.getRandomValue(meteorPositions)
    server.spawnMeteor(position, 0.4, false)
end)

------------- Teleport disqualified
cuhFramework.utilities.loop.create(0.01, function()
    -- grab disqualified state
    local disqualified = playerStatesLibrary.getState("disqualified")

    if not disqualified then
        return
    end

    -- for everyone who is disqualified, teleport em above whoever they are spectating
    for _, player in pairs(disqualified) do ---@param player player
        -- teleport above spawn
        local toTeleport = cuhFramework.utilities.matrix.offsetPosition(getSpawnPoint(), 0, 15, -5)
        player:teleport(toTeleport)
    end
end)

------------- Mark Enforcers
cuhFramework.utilities.loop.create(0.01, function()
    -- attack enforcer objects to enforcers
    for _, player in pairs(cuhFramework.players.connectedPlayers) do
        -- quick check
        if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) or not player.properties.admin then
            goto continue
        end

        -- get object
        ---@type object
        local object = playerTagsLibrary.getTag(player, "enforcer_object")

        -- make sure it exists
        if not object then
            goto continue
        end

        -- tp to player
        local position = player:get_position()
        position = cuhFramework.utilities.matrix.offsetPosition(position, 0, 2, 0)

        object:teleport(position)

        -- continue replacement
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