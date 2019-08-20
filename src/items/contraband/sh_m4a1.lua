local ITEM = CityMod.Item:New(CityMod.ItemID:Get("M4A1"))
ITEM.Name = "m4a1"
ITEM.Category = "Contraband"
ITEM.Model = "models/props_borealis/bluebarrel001.mdl"
ITEM.ConsumeCount = 1

function ITEM:Execute(ply, modifier)
    ply:Give("cw_g4p_m4a1")
    ply:GiveAmmo(modifier, "AR2")
end

ITEM:Register()