local ITEM = CityMod.Item:New(0)
ITEM.Name = "m4a1"
ITEM.Category = "Contraband"
ITEM.Model = "models/props_borealis/bluebarrel001.mdl"

function ITEM:Execute(ply)
    print("Item use!")
end

ITEM:Register()