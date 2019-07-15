CityMod.Log = CityMod.Library:New("Log")

setmetatable(CityMod.Log, {
__call = function(self,text,...) CityMod.Log.Log(text,...) end}
)

function CityMod.Log.Log(text,...)
    print(string.format(text,...))
end

function CityMod.Log.Player(ply,text)
    CityMod.Log.Log(text,ply:Name().." ("..ply:SteamID()..")")
end

function CityMod.Log.PlayerIP(ply,text)
    CityMod.Log.Log(text,ply:Name().." ("..ply:SteamID()..") ["..ply:IPAddress().."]")
end

-- Set metamethods on the player object for simplifying logging
local playerMeta = FindMetaTable("Player")
function playerMeta:Log(text)
    CityMod.Log.Player(self,text)
end

function playerMeta:LogIP(text)
    CityMod.Log.PlayerIP(self,text)
end