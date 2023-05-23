---------------------------------------
------------- Player States
---------------------------------------

------------- Variables
---@type table<string, table>
local playerStates = {}

------------- Library
playerStatesLibrary = {
    ---@param player player
	setState = function(player, state)
        if not playerStates[state] then
            playerStates[state] = {}
        end

        playerStates[state][player.properties.peer_id] = true
        return true
    end,

    ---@param player player
    removeState = function(player, state)
        if not playerStates[state] then
            playerStates[state] = {}
        end

        playerStates[state][player.properties.peer_id] = nil
        return true
    end,

    ---@param player player
    hasState = function(player, state)
        if not playerStates[state] then
            playerStates[state] = {}
            return false
        end

        return playerStates[state][player.properties.peer_id] ~= nil
    end,

    ---@param player player
    clearStates = function(player)
        for i, v in pairs(playerStates) do
            local state = playerStates[i]
            if state[player.properties.peer_id] then
                playerStatesLibrary.removeState(player, i)
            end
        end
    end,

    getAll = function()
        return playerStates
    end
}