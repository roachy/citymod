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
    end, {})

    -- Create model panel
end

vgui.Register("CityModInventorySlot", PANEL, "DPanel")