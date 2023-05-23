---------------------------------------
------------- Announce
---------------------------------------

------------- Library
announceLibrary = {
	status = {
        success = function(msg, player)
            cuhFramework.ui.notifications.custom(miscellaneousLibrary.surround(config.info.addon_name, "[]").." Success", msg, player, 4)
        end,

        warning = function(msg, player)
            cuhFramework.ui.notifications.custom(miscellaneousLibrary.surround(config.info.addon_name, "[]").." Warning", msg, player, 1)
        end,

        failure = function(msg, player)
            cuhFramework.ui.notifications.custom(miscellaneousLibrary.surround(config.info.addon_name, "[]").." Failure", msg, player, 2)
        end,

        status = function(msg, player)
            cuhFramework.ui.notifications.custom(miscellaneousLibrary.surround(config.info.addon_name, "[]").." Status", msg, player, 11)
        end
    },

	reminder = function(msg)
        cuhFramework.ui.notifications.custom(miscellaneousLibrary.surround(config.info.addon_name, "[]").." Reminder", msg, nil, 8)
	end,

    popupAnnounce = function(text, timer)
        if announcementRemovalDelay then
            announcementRemovalDelay:remove()
        end

        local announce_ui = cuhFramework.ui.screen.create(2500, text, 0, 0)
        announcementRemovalDelay = cuhFramework.utilities.delay.create(timer or 10, function()
            announce_ui:remove()
        end)
    end
}