---------------------------------------
------------- Character Load
---------------------------------------

cuhFramework.callbacks.onObjectLoad:connect(function(object_id)
    -- Get variables
    local player = cuhFramework.players.getPlayerByObjectId(object_id)

    -- Checks
    if not player then
        return
    end

    if miscellaneousLibrary.unnamedClientOrServerOrDisconnecting(player) then
        return
    end

    -- Teleport
    player:teleport(getSpawnPoint())

    -- Disqualify if someone has already been disqualified
    if cuhFramework.utilities.table.getValueCountOfTable(playerStatesLibrary.getState("disqualified")) >= 1 then
        eventsLibrary.get("disqualify"):fire(player)
    end
end)