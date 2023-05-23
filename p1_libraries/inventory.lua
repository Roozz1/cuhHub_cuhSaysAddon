---------------------------------------
------------- Inventory
---------------------------------------

------------- Variables
---@type table<string, inventory>
local inventories = {}

---@type table<string, item>
local items = {}

------------- Library
inventoryLibrary = {
    items = {
        new = function(name, equipment_id, int, float, slot)
            items[name] = {
                name = name,
                equipment_id = equipment_id,
                int = int,
                float = float,
                slot = slot
            }

            return inventoryLibrary.items.get(name)
        end,

        get = function(name)
            return items[name]
        end,

        getAll = function()
            return items
        end
    },

    inventories = {
        new = function(name, ...)
            inventories[name] = {
                properties = {
                    items = {...},
                    name = name
                },

                ---@param self inventory
                ---@param player player
                give = function(self, player)
                    for i, v in pairs(self.properties.items) do
                        player:give_item(v.slot, v.equipment_id, v.int, v.float)
                    end
                end,

                ---@param self inventory
                remove = function(self)
                    return inventoryLibrary.inventories.remove(self)
                end,

                ---@param self inventory
                itemsToNamesInTable = function(self)
                    local itemNames = {}

                    for i, v in pairs(self.properties.items) do
                        itemNames[i] = v.name .." [Slot "..v.slot.."]"
                    end

                    return itemNames
                end
            }

            return inventoryLibrary.inventories.get(name)
        end,

        get = function(name)
            return inventories[name]
        end,

        ---@param inventory inventory
        remove = function(inventory)
            inventories[inventory.properties.name] = nil
        end,

        getAll = function()
            return inventories
        end
    }
}