local PANEL = {}

-- Called when the panel is initialized
function PANEL:Init()


	self.Frame = vgui.Create( "DFrame" )
	self.Frame:SetSize( ScrW() / 2, ScrH() / 2 )
	self.Frame:SetTitle("Main Menu")
	self.Frame:SetDraggable(false)
	self.Frame:Center()
	self.Frame:MakePopup()

	-- Override closing
	self.Frame.btnClose.DoClick = function(button) self.Frame:Hide() end

	-- Hide useless buttons
	self.Frame.btnMaxim:SetVisible(false)
	self.Frame.btnMinim:SetVisible(false)

	local sheet = vgui.Create("DPropertySheet", self.Frame)
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
		print("Called Set Name")
	end

	

	sheet:AddSheet( "Character", panel1, "icon16/user.png" )

	local panel2 = vgui.Create("CityModJobs", sheet)
	sheet:AddSheet( "Jobs", panel2, "icon16/group.png" )


	local inventory = vgui.Create("CityModInventory", sheet)
	sheet:AddSheet( "Inventory", inventory, "icon16/box.png" )

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