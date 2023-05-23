-------------------------------------------------
-------------------------- Easy Popups
-------------------------------------------------
------------- Physical Popup
---@class physicalPopup
---@field properties physicalPopupProperties
---@field setVisibility function<self, boolean>
---@field refresh function<self>
---@field edit function<self, string|nil, SWMatrix|nil, number|nil, player|nil, number|nil>
---@field remove function<self>

------------- Physical Popup Properties
---@class physicalPopupProperties
---@field text string
---@field pos SWMatrix
---@field id number
---@field player player|nil
---@field shownForAll boolean
---@field renderDistance number
---@field visible boolean
---
---@field obj_id number
---@field veh_id number

-------------------------------------------------
-------------------------- Miscellaneous
-------------------------------------------------
------------- Message
---@class message
---@field properties messageProperties
---@field delete function<self, player|nil>
---@field edit function<self, string, player|nil>

---@class messageProperties
---@field author player
---@field content string

------------- Color
---@class colorRGB
---@field r number
---@field g number
---@field b number
---@field a number

---@class colorHSV
---@field h number
---@field s number
---@field v number
---@field a number

------------- Event
---@class event
---@field name string
---@field connections table<any, function>
---
---@field connect function<self, function>
---@field fire function<self, any>
---@field remove function<self>

------------- Storage
---@class storage
---@field name string
---@field storage table<any, any>
---
---@field add function<self, any, any>
---@field remove function<self, any>
---@field get function<self, any>

------------- MinMax
---@class minMax
---@field min number
---@field max number

------------- Reminder
---@class reminder
---@field properties reminderProperties
---@field remove function<self>
---@field announce function<self>

---@class reminderProperties
---@field id any
---@field category reminderCategory
---@field description string

------------- Reminder Category
---@class reminderCategory
---@field properties reminderCategoryProperties
---@field newReminder function<self, any, description>

---@class reminderCategoryProperties
---@field name string