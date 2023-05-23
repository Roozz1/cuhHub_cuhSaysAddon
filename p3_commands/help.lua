---------------------------------------
------------- Command - Shows a help message
---------------------------------------

------------- ?help
cuhFramework.commands.create("help", {"h"}, false, function(message, peer_id, admin, auth, command, ...)
    -- Get player
    local player = cuhFramework.players.getPlayerByPeerId(peer_id)

    -- Check
    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) then
        return
    end

    -- Pack commands into table
    local commands = {}

    for i, v in pairs(cuhFramework.commands.registeredCommands) do
        -- probably an admin/internal command
        if v.description == "" then
            goto continue
        end

        -- new shorthands stuff
        local shorthands = {}
        for _, shorthand in pairs(v.shorthands) do
            table.insert(shorthands, "?"..shorthand)
        end

        -- add to commands list but nice and formatted
        table.insert(commands, "?"..v.command_name.."\n     \\___"..table.concat(shorthands, ", ").."\n     \\___"..v.description)

        ::continue::
    end

    -- Show commands and help message
    if not commands[1] then
        commands[1] = "This addon has no commands."
    end

    chatAnnounce("// Help\n"..config.info.help_message.."\n\n// Commands:\n"..table.concat(commands, "\n"), player)
end, "Shows all commands along with help.")