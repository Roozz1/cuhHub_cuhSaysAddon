---------------------------------------
------------- Events
---------------------------------------

------------- Variables
---@type table<string, event>
local events = {}

------------- Library
eventsLibrary = {
    initialize = function()
        -- debug
        if not df.debugEnabled() then
            return
        end

        local handled = {}

        cuhFramework.utilities.loop.create(5, function()
            for i, v in pairs(events) do
                if not handled[v.name] then
                    handled[v.name] = true

                    v:connect(function(...)
                        local args = {...}
                        df.print(v.name.." (event) - fired with args: "..table.concat(cuhFramework.utilities.table.tostringValues(args), ", "), nil, "eventsLibrary.initialize")
                    end)
                end
            end
        end)
    end,

    new = function(name)
        events[name] = {
            name = name,
            connections = {},

            connect = function(self, func)
                table.insert(self.connections, func)
            end,

            fire = function(self, ...)
                for i, v in pairs(self.connections) do
                    v(...)
                end
            end,

            remove = function(self)
                return eventsLibrary.remove(self.name)
            end
        }

        return events[name]
    end,

    get = function(name)
        return events[name]
    end,

    remove = function(name)
        events[name] = nil
    end,

    getAll = function()
        return events
    end
}