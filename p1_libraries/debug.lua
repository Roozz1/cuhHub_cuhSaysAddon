---------------------------------------
------------- Debug
---------------------------------------

------------- Variables
local debug_addon_name = "Debug library hasn't been initialized."

------------- Library
debugLibrary = {
    initialize = function()
        -- set addon name
        local index = server.getAddonIndex()
        debug_addon_name = server.getAddonData(index).name

        -- alive loop
        cuhFramework.utilities.loop.create(1, function()
            df.print("i am alive!", nil, "debugLibrary.initialize")
        end)

        -- check
        if not debugLibrary.debugEnabled() then
            return
        end

        -- inject into callbacks (ERR: breaks addon)
        -- for i, v in pairs(cuhFramework.callbacks) do
        --     if i == "onTick" then
        --         goto continue
        --     end

        --     df.printTbl(v, nil, "debugLibrary.initialize")

        --     v:connect(function(...)
        --         df.print("cuhframework callback - "..i.." | called with args: "..cuhFramework.utilities.table.tostringValues({...}), nil, "debugLibrary.initialize")
        --     end)

        --     ::continue::
        -- end
    end,

    debugEnabled = function()
        return config.debugEnabled
    end,

    print = function(toPrint, disableSep, source)
        if not debugLibrary.debugEnabled() then
            return
        end

        toPrint = tostring(toPrint)
        toPrint = "DEBUG | "..debug_addon_name.." - "..toPrint..cuhFramework.utilities.miscellaneous.switchbox("\n-----------------", "", disableSep)..(" (%s)"):format(source or "No source specified.")

        if config.debugShouldLog then
            debug.log(toPrint)
        else
            chatAnnounce(toPrint)
        end
    end,

    printTbl = function(tbl, indent, source)
        if not indent then
            indent = 0
        end

        for i, v in pairs(tbl) do
            formatting = string.rep("  ", indent)..i..": "

            if type(v) == "table" then
                df.print(formatting, true, source)
                df.printTbl(v, indent + 1)
            else
                df.print(formatting..tostring(v), true, source)
            end
        end
    end
}

df = debugLibrary