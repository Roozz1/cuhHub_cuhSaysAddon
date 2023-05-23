---------------------------------------
------------- Storage
---------------------------------------

------------- Variables
---@type table<string, storage>
local storages = {}

------------- Library
storageLibrary = {
    new = function(name)
        storages[name] = {
            name = name,
            storage = {},

            ---@param self storage
            add = function(self, index, value)
                self.storage[index] = value
                return self.storage[index]
            end,

            ---@param self storage
            remove = function(self, index)
                self.storage[index] = nil
                return self.storage
            end,

            ---@param self storage
            get = function(self, index)
                local retrieved = self.storage[index]
                return retrieved
            end,
        }

        return storageLibrary.get(name)
    end,

    get = function(name)
        local retrieved = storages[name]
        return retrieved
    end
}