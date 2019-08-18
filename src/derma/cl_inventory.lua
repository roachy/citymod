local PANEL = {}

function PANEL:Init()
	--local panel3 = vgui.Create("DScrollPanel", self:GetParent())
	local List = vgui.Create( "DIconLayout", self )
	List:Dock(FILL)
	List:SetSpaceY(6)
	List:SetSpaceX(10)
	
	for i = 1, 20 do -- Make a loop to create a bunch of panels inside of the DIconLayout
		local inventoryPanel = vgui.Create( "DPanel" )
		inventoryPanel:Receiver( "ItemSlot", function(receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY)
			
			-- Check if the item was dropped onto the item slot
			if (not isDropped) then
				return
			end

			-- Grab the previous item slot
			local previousItemSlot = tableOfDroppedPanels[1]
			local previousSlotModel = previousItemSlot:GetModel()

			-- Determine whether the receiver already has a child. If yes, we have to swap them
			if (#receiver:GetChildren() > 0) then
				-- Grab the previous slot's model

				-- Grab the current slot's model
				local currentSlot = receiver:GetChild(0)
				local currentSlotModel = currentSlot:GetModel()

				-- Swap the two slots
				previousItemSlot:SetModel(currentSlotModel)
				currentSlot:SetModel(previousSlotModel)
				return
			end

			previousItemSlot:Remove()

			local icon = vgui.Create("DModelPanel", receiver)
			icon:SetSize(80,40)
			icon:SetModel( previousSlotModel )
			icon:SetTooltip(false)
			icon:Droppable("ItemSlot")
		end, {} )

		if (i == 5 or i == 2) then

			local icon = vgui.Create( "DModelPanel", inventoryPanel )
			icon:SetSize(80,40)
			if (i == 2) then
				icon:SetModel( LocalPlayer():GetModel() )
			else
				icon:SetModel( "models/props_phx/gears/bevel24.mdl" )
			end
			icon:SetTooltip(false)
			icon:Droppable("ItemSlot")

			local itemActionMenu = function()
				local dMenu = DermaMenu()

				dMenu:AddOption("Use", function() print("Used item!") end)
				dMenu:AddOption("Give")
				dMenu:AddOption("Drop")
				dMenu:AddOption("Destroy")

				dMenu:Open()
			end

			icon.DoClick = itemActionMenu
			icon.DoRightClick = itemActionMenu
		end

		local ListItem = List:Add(inventoryPanel)
		ListItem:SetSize( 80, 40 )

		--[[local ListItem = List:Add( "DModelPanel" )
		ListItem:SetSize(80, 40) -- Set the size of it
		ListItem:SetModel(LocalPlayer():GetModel())
		function ListItem:LayoutEntity(Entity) return end -- Disable rotation]]

		ListItem.DoRightClick = function()
			print(1)
		end
	end
end

vgui.Register("CityModInventory", PANEL, "DScrollPanel")