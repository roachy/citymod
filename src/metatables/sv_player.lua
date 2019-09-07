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

-- Give a player an item
function playerMeta:GiveItem(itemId, modifier, amount)
    return CityMod.Player:GiveItem(self, itemId, modifier, amount)
end

-- Take an item from a player
function playerMeta:TakeItem(itemId, modifier, amount)
    return CityMod.Player:TakeItem(self, itemId, modifier, amount)
end

-- Give a player money
function playerMeta:GiveMoney(amount)
    CityMod.Player:GiveMoney(self, amount)
end

-- Take money from a player
function playerMeta:TakeMoney(amount)
    CityMod.Player:TakeMoney(self, amount)
end

-- Check whether the player is a donator
function playerMeta:IsDonator()
    return self.Donator
end

-- Return the player's money
function playerMeta:GetMoney()
    return self.Money
end

-- Sets the player's money to the amount specified
function playerMeta:SetMoney(amount)
    CityMod.Player:SetMoney(self, amount)
end

-- Changes the player's job
function playerMeta:ChangeJob(jobName)
    CityMod.Player:ChangeJob(self, jobName, force)
end

-- Sets the player's job variable
function playerMeta:SetJob(jobName)
    self.Job = jobName
end