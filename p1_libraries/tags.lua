---------------------------------------
------------- Player Tags
---------------------------------------

------------- Variables
---@type table<integer, table>
local tags = {}

------------- Library
playerTagsLibrary = {
    ---@param player player
    setTag = function(player, index, value)
        -- get stuffs
        local peer_id = player.properties.peer_id
        local data = tags[peer_id]

        -- make sure exists
        if not data then
            tags[peer_id] = {}
            data = tags[peer_id]
        end

        -- give tag
        data[index] = value
    end,

    ---@param player player
    removeTag = function(player, index)
        -- get stuffs
        local peer_id = player.properties.peer_id
        local data = tags[peer_id]

        -- make sure exists
        if not data then
            tags[peer_id] = {}
            data = tags[peer_id]
        end

        -- give tag
        data[index] = nil
    end,

    ---@param player player
    getTag = function(player, index)
        -- get stuffs
        local peer_id = player.properties.peer_id
        local data = tags[peer_id]

        -- make sure exists
        if not data then
            tags[peer_id] = {}
            data = tags[peer_id]
        end

        -- return thy tag
        return data[index]
    end,

    ---@param player player
    clearTags = function(player)
        -- get stuffs
        local peer_id = player.properties.peer_id

        -- clear
        tags[peer_id] = {}
    end,
}