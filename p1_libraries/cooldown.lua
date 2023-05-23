---------------------------------------
------------- Cooldown
---------------------------------------

------------- Variables
local cooldowns = {}

------------- Library
cooldownLibrary = {
    ---@param key any
    new = function(key, duration)
        cooldowns[key] = {
            delay = cuhFramework.utilities.delay.create(duration, function()
                cooldownLibrary.remove(key)
            end)
        }
    end,

    hasCooldown = function(key)
        return cooldowns[key] ~= nil
    end,

    remove = function(key)
        if cooldowns[key] then
            cooldowns[key].delay:remove()
        end

        cooldowns[key] = nil
    end
}