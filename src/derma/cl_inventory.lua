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
		-- Store variables
		local inventorySlot = net.ReadUInt(32)
		local itemId = net.ReadUInt(16)
		local modifier = net.ReadInt(32)
		local amount = net.ReadUInt(16)

		-- Set the item's properties
		LocalPlayer().Inventory[inventorySlot] = {}
		LocalPlayer().Inventory[inventorySlot].Id = itemId
		LocalPlayer().Inventory[inventorySlot].Modifier = modifier
		LocalPlayer().Inventory[inventorySlot].Amount = amount
		
		self:CreateItem(self.List.InventorySlots, inventorySlot)
	end)
end

function PANEL:CreateItem(panel, index)
	local item = ply.Inventory[index]
	local itemId = item.Id

	local itemProperties = CityMod.Item:Get(itemId)

	-- Remove the panel if it exists already
	if (panel[index].ModelPanel ~= nil) then
		panel[index].ModelPanel:Remove()
	end
	
	panel[index].ModelPanel = vgui.Create("DModelPanel", panel[index])
	panel[index].ModelPanel:SetSize(80,40)
	panel[index].ModelPanel:Droppable("ItemSlot")

	panel[index].ModelPanel:SetModel(itemProperties.Model)

	-- Create item count
	local DLabel = vgui.Create("DLabel", panel[index].ModelPanel)
	DLabel:SetPos(65,20)
	DLabel:SetText(ply.Inventory[index].Amount)
	DLabel:SetTextColor(Color(0, 0, 0))

	-- Set action menu
	panel[index].ModelPanel.DoClick = CreateActionMenu
	panel[index].ModelPanel.DoRightClick = CreateActionMenu
end

local function CreateActionMenu()
	local dMenu = DermaMenu()
		
	dMenu:AddOption("Use", function()
		-- Tell server that we want to use the item in the given slot
		net.Start("UseItem")
			net.WriteUInt(self.List.InventorySlots[i].Id, 32)
		net.SendToServer()

		-- Wait for callback from server about the item
		net.Receive("UseItem", function()
			 -- Sets the new item amount. It will deduct the consumecount for now. It is very unlikely there will be an item, that upon using it, will increase its item count
			item.Amount = item.Amount-itemProperties.ConsumeCount

			if (item.Amount == 0) then
				self.List.InventorySlots[i].ModelPanel:Remove()
			end

			DLabel:SetText(ply.Inventory[i].Amount)
		end)
	end)
	dMenu:AddOption("Give")
	dMenu:AddOption("Drop")
	dMenu:AddOption("Destroy")

	dMenu:Open()
end

vgui.Register("CityModInventory", PANEL, "DScrollPanel")