ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "CityMod Money"
ENT.Author = "Seraph"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Int",0,"Amount")
end