---------------------------------------
------------- Debounce
---------------------------------------

------------- Variables
---@type table<string, boolean>
local debounces = {}

------------- Library
debounceLibrary = {
    ---@param key any
    debounce = function(key, duration)
        -- debounce in progress, so return true
        if debounces[key] then
            return true
        end

        -- add debounce
        debounces[key] = true

        -- remove after some time
        cuhFramework.utilities.delay.create(duration, function()
            debounces[key] = nil
        end)

        -- return false
        return false
    end,

    getAll = function()
        return debounces
    end
}