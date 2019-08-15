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