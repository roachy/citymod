local PANEL = {}

function PANEL:Init()
	self.List = vgui.Create("DIconLayout", self)

	self.List:Dock(FILL)
	self.List:SetSpaceY(6)
	self.List:SetSpaceX(10)
	
	for i = 0, LocalPlayer().MaxInventorySize-1 do -- Make a loop to create a bunch of panels inside of the DIconLayout
		local inventorySlot = vgui.Create("CityModInventorySlot", self.List)

		-- Set the inventory slot's ID
		inventorySlot.Id = i

		if (ply.Inventory[i] ~= nil) then
			local item = ply.Inventory[i]
			local itemId = item.Id

			local itemProperties = CityMod.Item:Get(itemId)
			
			inventorySlot.ModelPanel = vgui.Create("DModelPanel", inventorySlot)
			inventorySlot.ModelPanel:SetSize(80,40)
			inventorySlot.ModelPanel:Droppable("ItemSlot")

			inventorySlot.ModelPanel:SetModel(itemProperties.Model)

			-- Create item count
			local DLabel = vgui.Create("DLabel", inventorySlot.ModelPanel)
			DLabel:SetPos(65,20)
			DLabel:SetText(ply.Inventory[i].Amount)
			DLabel:SetTextColor(Color(0, 0, 0))

			local itemActionMenu = function()
				local dMenu = DermaMenu()
		
				dMenu:AddOption("Use", function()
					-- Tell server that we want to use the item in the given slot
					net.Start("UseItem")
						net.WriteUInt(inventorySlot.Id, 32)
					net.SendToServer()

					-- Wait for callback from server about the item
					net.Receive("UseItem", function()
						 -- Sets the new item amount. It will deduct the consumecount for now. It is very unlikely there will be an item, that upon using it, will increase its item count
						item.Amount = item.Amount-itemProperties.ConsumeCount

						if (item.Amount == 0) then
							inventorySlot.ModelPanel:Remove()
						end

						DLabel:SetText(ply.Inventory[i].Amount)
					end)
				end)
				dMenu:AddOption("Give")
				dMenu:AddOption("Drop")
				dMenu:AddOption("Destroy")
		
				dMenu:Open()
			end
		
			inventorySlot.ModelPanel.DoClick = itemActionMenu
			inventorySlot.ModelPanel.DoRightClick = itemActionMenu


		end

		local ListItem = self.List:Add(inventorySlot)
		ListItem:SetSize(80, 40)
	end
end

vgui.Register("CityModInventory", PANEL, "DScrollPanel")