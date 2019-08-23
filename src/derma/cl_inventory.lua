local PANEL = {}

function PANEL:Init()
	self.List = vgui.Create("DIconLayout", self)

	self.List:Dock(FILL)
	self.List:SetSpaceY(6)
	self.List:SetSpaceX(10)

	-- Create inventory slots table
	self.List.InventorySlots = {}
	
	for i = 0, LocalPlayer().MaxInventorySize-1 do -- Make a loop to create a bunch of panels inside of the DIconLayout
		self.List.InventorySlots[i] = vgui.Create("CityModInventorySlot", self.List)

		-- Set the inventory slot's ID
		self.List.InventorySlots[i].Id = i

		if (ply.Inventory[i] ~= nil) then
			self:CreateItem(self.List.InventorySlots, i)
		end

		local ListItem = self.List:Add(self.List.InventorySlots[i])
		ListItem:SetSize(80, 40)
	end

	-- Add handler for when we should update our inventory (such as picking up an item, destroying an item, dropping an item etc.)
	net.Receive("UpdateInventory", function()
		-- Call the UpdateInventory to set the item in its slot etc. It returns the inventory slot.
		local inventorySlot = CityMod.Player.UpdateInventory()		

		-- Create the item
		self:CreateItem(self.List.InventorySlots, inventorySlot)
	end)
end

function PANEL:CreateItem(panel, index)
	local item = ply.Inventory[index]
	local itemId = item.Id

	local itemProperties = CityMod.Item:Get(itemId)

	local modelPanel = panel[index].ModelPanel

	-- Remove the panel if it exists already
	if (modelPanel ~= nil) then
		modelPanel:Remove()
	end
	
	modelPanel = vgui.Create("DModelPanel", panel[index])
	modelPanel:SetSize(80,40)
	modelPanel:Droppable("ItemSlot")

	modelPanel:SetModel(itemProperties.Model)

	-- Create item count
	local DLabel = vgui.Create("DLabel", modelPanel)
	DLabel:SetPos(65,20)
	DLabel:SetText(ply.Inventory[index].Amount)
	DLabel:SetDark(1)

	local function ActionMenu()
		local dMenu = DermaMenu()
			
		dMenu:AddOption("Use", function()
			-- Tell server that we want to use the item in the given slot
			net.Start("UseItem")
				net.WriteUInt(panel[index].Id, 32)
			net.SendToServer()
	
			-- Wait for callback from server about the item
			net.Receive("UseItem", function()
				 -- Sets the new item amount. It will deduct the consumecount for now. It is very unlikely there will be an item, that upon using it, will increase its item count
				item.Amount = item.Amount-itemProperties.ConsumeCount
	
				if (item.Amount == 0) then
					modelPanel:Remove()
				end
	
				DLabel:SetText(ply.Inventory[index].Amount)
			end)
		end)
		dMenu:AddOption("Give")
		dMenu:AddOption("Drop")
		dMenu:AddOption("Destroy")
	
		dMenu:Open()
	end

	-- Set action menu
	modelPanel.DoClick = ActionMenu
	modelPanel.DoRightClick = ActionMenu

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
		-- On drag on top of item
		if (itemDescription == nil) then
			return
		end

		itemDescription:Remove()
	end
end

vgui.Register("CityModInventory", PANEL, "DScrollPanel")