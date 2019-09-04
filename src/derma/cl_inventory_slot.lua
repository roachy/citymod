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
        local previousSlotModel = previousItemSlot.Model
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

            -- Swap the item in the player's inventory based on the inventory's ID
            local item1 = LocalPlayer().Inventory[self.Id]
            local item2 = LocalPlayer().Inventory[previousItemSlotId]

            LocalPlayer().Inventory[self.Id] = item2
            LocalPlayer().Inventory[previousItemSlotId] = item1

            -- Determine whether the receiver already has a child. If yes, we have to swap them
            if (#receiver:GetChildren() > 0) then

                -- Grab the current slot's model
                local currentSlot = receiver:GetChild(0)
                local currentSlotModel = currentSlot.Model

                -- Swap the two slots
                previousItemSlot:SetModel(currentSlotModel)
                previousItemSlot.Model = currentSlotModel

                currentSlot:SetModel(previousSlotModel)
                currentSlot.Model = previousSlotModel

                -- It is on index 1, not 0
                local previousItemSlotCount = previousItemSlot:GetChild(1)
                local currentSlotCount = currentSlot:GetChild(1)

                currentSlotCount:SetText(LocalPlayer().Inventory[self.Id].Amount)
                previousItemSlotCount:SetText(LocalPlayer().Inventory[previousItemSlotId].Amount)
                return
            end

            previousItemSlot:Remove()

            local modelPanel = vgui.Create("SpawnIcon", receiver)
            modelPanel:SetSize(80,40)
            modelPanel:SetModel(previousSlotModel)
            modelPanel.Model = previousSlotModel
            modelPanel:Droppable("ItemSlot")
            modelPanel:SetTooltip(false)

            -- Create item count
            modelPanel.ItemCount = vgui.Create("DLabel", modelPanel)
			modelPanel.ItemCount:SetPos(65,20)
			modelPanel.ItemCount:SetText(ply.Inventory[self.Id].Amount)
			modelPanel.ItemCount:SetTextColor(Color(0, 0, 0))

            local itemActionMenu = function()
                local dMenu = DermaMenu()
        
                dMenu:AddOption("Use", function()
                    
					-- Tell server that we want to use the item in the given slot
					net.Start("UseItem")
						net.WriteUInt(self.Id, 32)
					net.SendToServer()

					-- Wait for callback from server about the item
                    net.Receive("UseItem", function()
                        local item = ply.Inventory[self.Id]
                        local itemProperties = CityMod.Item:Get(item.Id)

						 -- Sets the new item amount. It will deduct the consumecount for now. It is very unlikely there will be an item, that upon using it, will increase its item count
						item.Amount = item.Amount-itemProperties.ConsumeCount

						if (item.Amount == 0) then
							modelPanel:Remove()
						end

						modelPanel.ItemCount:SetText(ply.Inventory[self.Id].Amount)
					end)

				end)
                dMenu:AddOption("Give")
                dMenu:AddOption("Drop")
                dMenu:AddOption("Destroy")
        
                dMenu:Open()
            end
        
            modelPanel.DoClick = itemActionMenu
            modelPanel.DoRightClick = itemActionMenu

            local item = ply.Inventory[toSlot]

            	-- Create panel that appears when you hover over the item
            local itemDescription = nil
            function modelPanel:OnCursorEntered()
                itemDescription = vgui.Create("DPanel")
                itemDescription:SetSize(300, 200)

                -- Get the item's properties
                local itemProperties = CityMod.Item:Get(item.Id)

                -- Set the item's name
                local itemName = vgui.Create( "DLabel", itemDescription )
                itemName:SetPos( 10, 10 )

                local itemNameText = nil
                if (type(itemProperties.Name) == "function") then
                    itemNameText = itemProperties.Name(item.Modifier)
                else
                    itemNameText = itemProperties.Name
                end

                itemName:SetText(itemNameText)
                itemName:SizeToContents()
                itemName:SetDark(1)

                -- Set the item's description
                local itemDescriptionText = nil
                if (type(itemProperties.Description) == "function") then
                    itemDescriptionText = itemProperties.Description(item.Modifier)
                else
                    itemDescriptionText = itemProperties.Description
                end

                local itemDescriptionLabel = vgui.Create( "DLabel", itemDescription )
                itemDescriptionLabel:SetPos(10, 30)
                itemDescriptionLabel:SetText(itemDescriptionText)
                itemDescriptionLabel:SizeToContents()
                itemDescriptionLabel:SetDark(1)

                -- Set the item's category
                local itemCategory = vgui.Create( "DLabel", itemDescription )
                itemCategory:SetPos(10, 50)
                itemCategory:SetText(itemProperties.Category)
                itemCategory:SizeToContents()
                itemCategory:SetDark(1)

                -- Set the panel on the left side of the mouse
                local w, h = itemDescription:GetSize()
                itemDescription:SetPos(gui.MouseX() - w, gui.MouseY() - h)
                itemDescription:SetDrawOnTop(true)
            end

            function modelPanel:OnCursorMoved()
                -- Set the panel on the left side of the mouse
                if (self:IsDragging()) then itemDescription:Remove() return end

                -- Extra check here as the panel is not deleted immediately, and can technically be called again
                if (not itemDescription:IsValid()) then
                    return
                end

                local w, h = itemDescription:GetSize()
                itemDescription:SetPos(gui.MouseX() - w, gui.MouseY() - h)
            end

            function modelPanel:OnCursorExited()
                itemDescription:Remove()
            end
        end)

    end, {})
end

vgui.Register("CityModInventorySlot", PANEL, "DPanel")