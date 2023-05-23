---------------------------------------
------------- Command - Mutes/unmutes a player
---------------------------------------

------------- Mute Handler
local muted = {}
local random = {"#", "!", "?"}

---@param message message
messageLibrary.events.onMessageSend:connect(function(message)
    for i, v in pairs(muted) do
        -- quick check
        if not v[message.properties.author.properties.peer_id] then -- the person who sent this message isnt muted by v, so go to next mute data thing
            goto continue
        end

        -- get thy player
        local player = cuhFramework.players.getPlayerByPeerId(i)

        if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) then -- player probably left
            goto continue
        end

        -- edit/delete message
        if config.deleteInsteadOfEdit then
            message:delete(player)
        else
            -- cool new message styling thing
            local new = ""

            for i1 = 1, cuhFramework.utilities.number.clamp(#message.properties.content, 1, #message.properties.content) do
                local letter = message.properties.content:sub(i1, i1)
                local to_add = " "

                if letter ~= " " then
                    to_add = cuhFramework.utilities.table.getRandomValue(random)
                end

                new = new..to_add
            end

            -- edit message
            message:edit(new.." [MUTED]", player)
        end

        -- continue
        ::continue::
    end
end)

cuhFramework.callbacks.onPlayerLeave:connect(function(_, _, peer_id)
    -- remove mute data
    muted[peer_id] = nil
end)

------------- ?mute
cuhFramework.commands.create("mute", {"m"}, false, function(message, peer_id, admin, auth, command, ...)
    -- Get variables
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)
    local args = {...}

    -- Check
    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) then
        return
    end

    -- Make sure this player is setup
    if not muted[peer_id] then
        muted[peer_id] = {}
    end

    -- Main
    if args[1] then
        -- get target player
        local targetPlayer = cuhFramework.players.getPlayerByNameWithAllowedPartialName(args[1], false)

        -- check if valid
        if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(targetPlayer) or targetPlayer == player then
            return announceLibrary.status.failure("This player doesn't exist (or you attempted to mute yourself). Did you type their name correctly?", player)
        end

        -- check if player is already muted
        local mutedData = muted[peer_id]

        if not mutedData[targetPlayer.properties.peer_id] then
            -- mute
            mutedData[targetPlayer.properties.peer_id] = targetPlayer

            -- and announce
            announceLibrary.status.success("You have muted "..targetPlayer.properties.name..".", player)
            announceLibrary.status.warning(player.properties.name.." muted you.", targetPlayer)
        else
            -- unmute
            mutedData[targetPlayer.properties.peer_id] = nil

            -- announce
            announceLibrary.status.success("You have unmuted "..targetPlayer.properties.name..".", player)
            announceLibrary.status.warning(player.properties.name.." unmuted you.", targetPlayer)
        end
    else
        return announceLibrary.status.failure("Please specify the player you would like to mute/unmute.\nThe name can be partial, as if you were searching for something on Google.\nExample: '?mute "..player.properties.name:sub(1, 3).."'", player)
    end
end, "Mute/unmute a player.")