-- roll
-- Makes a random roll between two specified parameter. Examples are: /roll 1-100, /roll 1-25, /roll 5-78
local CMD = CityMod.Command:New("ban")

function CMD:Execute(ply,args)
if (!args[1] || args[1] == "") then
    notification.AddLegacy("Specify a player",1,5)
    return
end

local target = CityMod.Player:FindByID(args[1])
if (!target) then
    notification.AddLegacy("Player by ID '"..args[1].."' was not found",1,5)
    return
end

if (!args[2] || args[2] == "") then
    notification.AddLegacy("Please specify the amount of time, ex: 1d or 16h",1,5)
    return
end

local banMins = CityMod.Utilities:StringTimeToMins(args[2])

if (!banMins) then
    notification.AddLegacy("Time '"..args[2].."' is not correct, please verify the argument",1,5)
    return
end

if (!args[3] || args[3] == "") then
    notification.AddLegacy("A reason is mandatory before ban is issued",1,5)
    return
end


notification.AddLegacy("Player "..target:Name().." ("..target:SteamID()..") was banned for "..CityMod.Utilities:MinsToString(banMins)..", reason: "..table.concat(args," ",3),0,5)

end
CMD:Register()