---------------------------------------
------------- Easy Popups
---------------------------------------

------------- Variables
local popups = {
    ---@type table<number, physicalPopup>
    physical = {}
}

------------- Library
easyPopupsLibrary = {
    initialize = function()
        cuhFramework.callbacks.onPlayerLeave:connect(function(_, _, peer_id)
            local player = cuhFramework.players.getPlayerByPeerId(peer_id)

            if not player then
                return
            end

            for i, v in pairs(popups.physical) do
                if v.properties.player == player then
                    v:remove()
                end
            end
        end)
    end,

    physical = {
        ---@param attach number|nil 0, nil or object id/vehicle id
        ---@param player player
        create = function(text, pos, attach, id, player, renderDistance)
            -- defaults
            if not renderDistance then
                renderDistance = 15
            end

            if not attach then
                attach = 0
            end

            -- get object_id/vehicle_id
            local idType = miscellaneousLibrary.isVehicleOrObject(attach)
            local obj_id = 0
            local veh_id = 0

            if idType == "object" then
                obj_id = attach
            elseif idType == "vehicle" then
                veh_id = attach
            end

            -- set data
            popups.physical[id] = {
                properties = {
                    text = text,
                    pos = pos,
                    id = id,
                    player = player,
                    shownForAll = player == nil,
                    renderDistance = renderDistance,
                    visible = true,

                    obj_id = obj_id,
                    veh_id = veh_id
                },

                ---@param self physicalPopup
                setVisibility = function(self, new)
                    self.properties.visible = new
                    self:refresh()
                end,

                ---@param self physicalPopup
                refresh = function(self)
                    server.setPopup(easyPopupsLibrary.miscellaneous.getTarget(self.properties.player), self.properties.id, "", self.properties.visible, self.properties.text, self.properties.pos[13], self.properties.pos[14], self.properties.pos[15], self.properties.renderDistance, self.properties.veh_id, self.properties.obj_id)
                end,

                ---@param self physicalPopup
                edit = function(self, newText, newPos, newAttach, newPlayer, newRenderDistance)
                    self.properties.text = newText or self.properties.text
                    self.properties.pos = newPos or self.properties.pos
                    self.properties.player = newPlayer or self.properties.player
                    self.properties.renderDistance = newRenderDistance or self.properties.renderDistance

                    if not newAttach then
                        return
                    end

                    local new_idType = miscellaneousLibrary.isVehicleOrObject(newAttach)
                    local new_obj_id = 0
                    local new_veh_id = 0

                    if new_idType == "object" then
                        new_obj_id = attach
                    elseif new_idType == "vehicle" then
                        new_veh_id = attach
                    end

                    self.properties.obj_id = new_obj_id
                    self.properties.veh_id = new_veh_id

                    self:refresh()
                end,

                ---@param self physicalPopup
                remove = function(self)
                    return easyPopupsLibrary.physical.remove(self.properties.id)
                end
            }

            -- show
            popups.physical[id]:refresh()

            -- return
            return popups.physical[id]
        end,

        remove = function(id)
            local data = popups.physical[id]

            if not data then
                return
            end

            server.removePopup(easyPopupsLibrary.miscellaneous.getTarget(data.properties.player), id)

            popups.physical[id] = nil
        end,

        get = function(id)
            return popups.physical[id]
        end,

        getAll = function()
            return popups.physical
        end
    },

    miscellaneous = {
        ---@param player player|nil
        getTarget = function(player)
            if player then
                return player.properties.peer_id
            else
                return -1
            end
        end
    }
}