---------------------------------------
------------- Reminders
---------------------------------------

------------- Variables
---@type table<any, reminder>
local reminders = {}

---@type table<integer, reminder>
local reminders_raw = {}

---@type table<string, reminderCategory>
local reminderCategories = {}

------------- Library
remindersLibrary = {
    reminder = {
        new = function(category, id, description)
            reminders[id] = {
                properties = {
                    id = id,
                    category = category,
                    description = description
                },

                ---@param self reminder
                remove = function(self)
                    return remindersLibrary.reminder.remove(self.properties.id)
                end,

                ---@param self reminder
                announce = function(self)
                    return remindersLibrary.reminder.announce(self)
                end
            }

            table.insert(reminders_raw, reminders[id])
            return remindersLibrary.reminder.get(id)
        end,

        remove = function(id)
            cuhFramework.utilities.table.removeValueFromTable(reminders_raw, reminders[id])
            reminders[id] = nil
        end,

        get = function(id)
            return reminders[id]
        end,

        getRandom = function()
            return cuhFramework.utilities.table.getRandomValue(reminders_raw)
        end,

        ---@param reminder reminder
        announce = function(reminder)
            announceLibrary.reminder(reminder.properties.description.."\n\\__Category: "..reminder.properties.category.properties.name)
            announceLibrary.discordAnnounce("\n"..reminder.properties.description, "[Category - "..reminder.properties.category.properties.name.."]", ":tickets: :grey_question:")
        end
    },

    category = {
        new = function(name)
            reminderCategories[name] = {
                properties = {
                    name = name
                },

                ---@param self reminderCategory
                newReminder = function(self, id, description)
                    return remindersLibrary.reminder.new(self, id, description)
                end
            }

            return remindersLibrary.category.get(name)
        end,

        get = function(name)
            return reminderCategories[name]
        end
    },

    misc = {
        getAll = function()
            return reminders
        end
    }
}