CityMod.Rank = CityMod.Library:New("Rank")

-- The possible ranks
CityMod.Rank.Owner =       0
CityMod.Rank.SuperAdmin =  1
CityMod.Rank.Admin =       2
CityMod.Rank.Moderator =   3
CityMod.Rank.Player =      4

-- Test whether the player has a certain rank
function CityMod.Rank:HasRank(rankNum, ply)
    return rankNum >= ply.Rank
end

function CityMod.Rank:IsOwner(ply)
    return self:HasRank(self.Owner, ply)
end

function CityMod.Rank:IsSuperAdmin(ply)
    return self:HasRank(self.SuperAdmin, ply)
end

function CityMod.Rank:IsAdmin(ply)
    return self:HasRank(self.Admin, ply)
end

function CityMod.Rank:IsModerator(ply)
    return self:HasRank(self.Moderator, ply)
end

function CityMod.Rank:IsPlayer(ply)
    return self:HasRank(self.Player, ply)
end