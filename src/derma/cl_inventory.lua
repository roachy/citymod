local PANEL = {}

function PANEL:Init()
	--local panel3 = vgui.Create("DScrollPanel", self:GetParent())
	local List = vgui.Create( "DIconLayout", self )
	List:Dock(FILL)
	List:SetSpaceY(6)
	List:SetSpaceX(10)
	
	for i = 0, LocalPlayer().MaxInventorySize do -- Make a loop to create a bunch of panels inside of the DIconLayout
		local inventorySlot = vgui.Create("CityModInventorySlot", List)

		if (ply.Inventory[i] ~= nil) then
			local itemId = ply.Inventory[i].ItemId
			local itemModel = CityMod.Item:Get(itemId).Model
			
			inventorySlot.ModelPanel = vgui.Create("DModelPanel", inventorySlot)
			inventorySlot.ModelPanel:SetSize(80,40)
			inventorySlot.ModelPanel:Droppable("ItemSlot")

			inventorySlot.ModelPanel:SetModel(itemModel)
		
			local itemActionMenu = function()
				local dMenu = DermaMenu()
		
				dMenu:AddOption("Use", function() print("Used item!") end)
				dMenu:AddOption("Give")
				dMenu:AddOption("Drop")
				dMenu:AddOption("Destroy")
		
				dMenu:Open()
			end
		
			inventorySlot.ModelPanel.DoClick = itemActionMenu
			inventorySlot.ModelPanel.DoRightClick = itemActionMenu
		end

		local ListItem = List:Add(inventorySlot)
		ListItem:SetSize(80, 40)
	end
end

vgui.Register("CityModInventory", PANEL, "DScrollPanel")