local ITEM = CityMod.Item:New(123)
ITEM.Name = "m4a1"
ITEM.Category = "Contraband"

function ITEM:Execute(ply)
    print(self.Dab)
end

ITEM:Register()