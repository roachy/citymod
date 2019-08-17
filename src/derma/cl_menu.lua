local PANEL = {}

-- Called when the panel is initialized
function PANEL:Init()


	local frame = vgui.Create( "DFrame" )
	frame:SetSize( ScrW() / 2, ScrH() / 2 )
	frame:SetTitle("Main Menu")
	frame:SetDraggable(false)
	frame:Center()
	frame:MakePopup()

	local sheet = vgui.Create("DPropertySheet", frame)
	sheet:Dock( FILL )

	--local panel1 = vgui.Create("DPanel", sheet) -- Use /news command instead
	--panel1.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255, self:GetAlpha() ) ) end
	--sheet:AddSheet( "News", panel1, "icon16/world.png" )

	local panel1 = vgui.Create("DScrollPanel", sheet)

	local SheetItem1 = vgui.Create("DTextEntry", panel1)
	SheetItem1:SetText(LocalPlayer().IngameName)
	SheetItem1:SetSize(100,50)

	local SheetItem2 = vgui.Create("DButton", panel1)
	SheetItem2:SetText("Set Name")
	SheetItem2:SetPos(0,50)
	SheetItem2:SetSize(100,25)
	SheetItem2.DoClick = function()
		print("called")
	end

	

	sheet:AddSheet( "Character", panel1, "icon16/user.png" )

	local panel2 = vgui.Create("DScrollPanel", sheet)


	sheet:AddSheet( "Jobs", panel2, "icon16/group.png" )

	local panel3 = vgui.Create("DScrollPanel", sheet)

	
	local List = vgui.Create( "DIconLayout", panel3 )
	List:Dock( FILL )
	List:SetSpaceY(6)
	List:SetSpaceX(10)
	
	for i = 1, 20 do -- Make a loop to create a bunch of panels inside of the DIconLayout


		local inventoryPanel = vgui.Create( "DPanel" )
		inventoryPanel:Receiver( "ItemSlot", function(receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY)
			
			if (not isDropped) then
				return
			end

			-- Do not allow to drag ontop of an existing item for now
			if (#inventoryPanel:GetChildren() > 0) then
				return
			end

			-- TODO: Add swapping
			local previousItemSlot = tableOfDroppedPanels[1]
			previousItemSlot:Remove()

			local icon = vgui.Create("SpawnIcon", receiver)
			icon:SetSize(80,40)
			icon:SetModel( LocalPlayer():GetModel() )
			icon:SetTooltip(false)
			icon:Droppable("ItemSlot")
		end, {} )

		if (i == 5 or i == 2) then

			local icon = vgui.Create( "SpawnIcon", inventoryPanel )
			icon:SetSize(80,40)
			icon:SetModel( LocalPlayer():GetModel() )
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


	sheet:AddSheet( "Inventory", panel3, "icon16/box.png" )

	local panel4 = vgui.Create("DPanel", sheet)
	panel4.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 128, 0, self:GetAlpha() ) ) end
	sheet:AddSheet( "Store", panel4, "icon16/cart.png" )
end

-- Called when the layout should be performed
function PANEL:PerformLayout(width, height)
end

-- Called when the panel is painted
function PANEL:Paint(width, height)
	return true
end

-- Called each frame.
function PANEL:Think()
end

vgui.Register("CityModSampleMenu", PANEL, "EditablePanel")