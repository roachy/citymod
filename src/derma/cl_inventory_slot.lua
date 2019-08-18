local PANEL = {}

function PANEL:Init()

    -- Received drop event
    self:Receiver("ItemSlot", function(receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY)

        -- Check if the item was dropped onto the item slot
        if (not isDropped) then
            return
        end

        -- Grab the previous item slot
        local previousItemSlot = tableOfDroppedPanels[1]
        local previousSlotModel = previousItemSlot:GetModel()
        local previousItemSlotId = previousItemSlot:GetParent().Id

        local fromSlot = previousItemSlotId
        local toSlot = self.Id

        -- Tell server we want to move the item
        net.Start("MoveItem")
            net.WriteUInt(fromSlot, 16)
            net.WriteUInt(toSlot, 16)
        net.SendToServer()

        -- Wait for MoveItem callback
        net.Receive("MoveItem", function()
            -- Determine whether the receiver already has a child. If yes, we have to swap them
            if (#receiver:GetChildren() > 0) then

                -- Grab the current slot's model
                local currentSlot = receiver:GetChild(0)
                local currentSlotModel = currentSlot:GetModel()

                -- Swap the two slots
                previousItemSlot:SetModel(currentSlotModel)
                currentSlot:SetModel(previousSlotModel)
                return
            end

            previousItemSlot:Remove()

            local modelPanel = vgui.Create("DModelPanel", receiver)
            modelPanel:SetSize(80,40)
            modelPanel:SetModel(previousSlotModel)
            modelPanel:Droppable("ItemSlot")

            local itemActionMenu = function()
                local dMenu = DermaMenu()
        
                dMenu:AddOption("Use", function() print("Used item!") end)
                dMenu:AddOption("Give")
                dMenu:AddOption("Drop")
                dMenu:AddOption("Destroy")
        
                dMenu:Open()
            end
        
            modelPanel.DoClick = itemActionMenu
            modelPanel.DoRightClick = itemActionMenu
            
            -- Swap the item in the player's inventory based on the inventory's ID
            local item1 = LocalPlayer().Inventory[self.Id]
            local item2 = LocalPlayer().Inventory[previousItemSlotId]

            LocalPlayer().Inventory[self.Id] = item2
            LocalPlayer().Inventory[previousItemSlotId] = item1
        end)

    end, {})
end

vgui.Register("CityModInventorySlot", PANEL, "DPanel")