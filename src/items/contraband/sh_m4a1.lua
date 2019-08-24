-- Create the item
local ITEM = CityMod.Item:New("M4A1")

-- Set the item fields
ITEM.Name = "M4A1"
ITEM.Category = "Weapons"
ITEM.Model = "models/props_borealis/bluebarrel001.mdl"
ITEM.ConsumeCount = 1

-- Function to execute when the item is used
function ITEM:Execute(ply, modifier)
    ply:Give("cw_g4p_m4a1")
    ply:GiveAmmo(modifier, "AR2")
end

-- Register the item
ITEM:Register()