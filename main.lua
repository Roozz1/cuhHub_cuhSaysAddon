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

---@param exception player
---@return player
getRandomPlayer = function(exception)
    local retrieved = cuhFramework.utilities.table.getRandomValue(players_unfiltered)

    if retrieved == exception and exception and miscellaneousLibrary.getPlayerCount() > 1 then
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
    local states = playerStatesLibrary.getAll()
    local disqualified = states["disqualify"]

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
    end

    -- continue replacement
    ::continue::
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
    if debounceLibrary.debounce("disqualify_"..player.properties.peer_id, config.game.timeToFullyEliminate) then
        return
    end

    if playerStatesLibrary.hasState(player, "disqualify") then
        -- already disqualified, so give back participant status
        playerStatesLibrary.removeState(player, "disqualify")
        chatAnnounce(player.properties.name.." is now a participant.")

        -- hide ui
        local ui = cuhFramework.ui.screen.get(player.properties.peer_id + 18000)
        if ui then
            ui:setVisibility(false)
        end
    else
        -- ascend the player into a fire
        local pos = player:get_position()
        local dest = cuhFramework.utilities.matrix.offsetPosition(pos, 0, 5, 0)

        local fire = server.spawnFire(dest, 1, 1, true, false, 0, 0)

        local animation = cuhFramework.animation.createLinearAnimation(pos, dest, 0.09, false, function(animation) ---@param animation animation
            player:teleport(animation.properties.current_pos)
        end)

        -- wait some time for animation to finish
        cuhFramework.utilities.delay.create(config.game.timeToFullyEliminate, function()
            -- remove the fire
            server.despawnObject(fire, true)

            -- stop animation
            animation:remove()

            -- not disqualified, so disqualify
            playerStatesLibrary.setState(player, "disqualify")
            chatAnnounce(player.properties.name.." has been eliminated.")
        end)
    end
end)

------------- Say
local say = eventsLibrary.new("say")

local function announce(msg)
    announceLibrary.popupAnnounce(msg, 6)
    chatAnnounce(msg)
end

---@param sayType "actual"|"fake"
say:connect(function(sayType, message, effectsPos)
    -- the main stuffs
    if sayType == "actual" then
        announce("Cuh Says: "..message)
    elseif sayType == "fake" then
        announce(message)
    else
        df.print("invalid cuhSays type", nil, "(say Event Handler)")
    end

    -- effects
    local vehicle = cuhFramework.vehicles.spawnAddonVehicle(1, cuhFramework.utilities.matrix.offsetPosition(effectsPos, 0, -10, 0))

    local self
    self = cuhFramework.callbacks.onVehicleLoad:connect(function(vehicle_id)
        if vehicle_id == vehicle.properties.vehicle_id then
            -- disconnect, no need to listen for vehicle loading anymore
            self:disconnect()

            -- start effects
            vehicle:press_button("activate")

            -- despawn
            cuhFramework.utilities.delay.create(3, function()
                vehicle:despawn()
            end)
        end
    end)
end)

------------- Mark Enforcers
---@param player player
eventsLibrary.get("playerJoin"):connect(function(player)
    -- check if admin first
    if not player.properties.admin then
        return
    end

    -- spawn object and attach to player
    local object = cuhFramework.objects.spawnObject((player:get_position()), 71) -- glowstick
    playerTagsLibrary.setTag(player, "enforcer_object", object) -- constantly teleported to player by loop above
end)

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

------------- Join Message
---@param player player
eventsLibrary.get("playerJoin"):connect(function(player)
    chatAnnounce("Welcome to the event! The event is simple, follow anything Cuh says IF his message begins with \"Cuh Says\". Last one participating wins.", player)
end)