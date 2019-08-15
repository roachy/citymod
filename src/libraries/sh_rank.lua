CityMod.Rank = CityMod.Library:New("Rank")

-- The possible ranks
CityMod.Rank.Owner =       0
CityMod.Rank.Admin =       1
CityMod.Rank.Moderator =   2
CityMod.Rank.Player =      3

-- Test whether the player has a certain rank
function CityMod.Rank:HasRank(rankNum, ply)
    print(ply.Rank)
    return rankNum >= ply.Rank
end

function CityMod.Rank:IsOwner(ply)
    return self:HasRank(self.Owner, ply)
end

function CityMod.Rank:IsAdmin(ply)
    return self:HasRank(self.Admim, ply)
end

function CityMod.Rank:IsModerator(ply)
    return self:HasRank(self.Moderator, ply)
end

function CityMod.Rank:IsPlayer(ply)
    return self:HasRank(self.Player, ply)
end