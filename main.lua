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
globalStorage:add("spawn_point", matrix.translation(0, 5, 0))