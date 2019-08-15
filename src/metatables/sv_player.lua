local playerMeta = FindMetaTable("Player")

function playerMeta:Arrest()

end

function playerMeta:Unarrest()

end

function playerMeta:NotifyGeneric(text, length)
    CityMod.Player:Notify(self, text, 0, length)
end

function playerMeta:NotifyError(text, length)
    CityMod.Player:Notify(self, text, 1, length)
end

function playerMeta:NotifyUndo(text, length)
    CityMod.Player:Notify(self, text, 2, length)
end

function playerMeta:NotifyHint(text, length)
    CityMod.Player:Notify(self, text, 3, length)
end

-- Check whether the player has owner rank
function playerMeta:HasOwnerRank()
    return CityMod.Rank:IsOwner(self)
end

-- Check whether the player has admin rank
function playerMeta:HasAdminRank()
    return CityMod.Rank:IsAdmin(self)
end

-- Check whether the player has moderator rank
function playerMeta:HasModeratorRank()
    return CityMod.Rank:IsModerator(self)
end

-- Check whether the player has player rank
function playerMeta:HasPlayerRank()
    return CityMod.Rank:IsPlayer(self)
end