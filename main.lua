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
    local states = playerStatesLibrary.getAll()
    local disqualified = states["disqualify"]

    if not disqualified then
        return
    end

    local toTeleport = globalStorage:get("spawn_point") or matrix.translation(0, 0, 0)
    toTeleport = cuhFramework.utilities.matrix.offsetPosition(toTeleport, 0, 15, 15)

    for i, v in pairs(disqualified) do
        v:teleport(toTeleport)
    end
end)

----------------------------------------------------------------
-- Zones
----------------------------------------------------------------
cuhFramework.customZones.createPlayerZone(globalStorage:get("spawn_point") or matrix.translation(0, 0, 0), config.game.playAreaSize, function(player, entered) ---@param player player
    if not entered and not player.properties.admin and not debounceLibrary.debounce("left_spawn_point_"..player.properties.peer_id, 0.5) then
        player:teleport(globalStorage:get("spawn_point") or matrix.translation(0, 0, 0)) -- so much repetition but oh well
        chatAnnounce("You cannot leave the play area.", player)
    end
end)