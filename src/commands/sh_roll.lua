-- roll
-- Makes a random roll between two specified parameter. Examples are: /roll 1-100, /roll 1-25, /roll 5-78
local CMD = CityMod.Command:New("roll")


local function Roll(ply,start,limit)
local roll = math.random(start,limit)
print(ply:Nick().." rolled "..roll.." ("..start.."-"..limit..")")
end

function CMD:Execute(ply,args)

if (!args[1]) then -- Default roll from 1 to 100
    Roll(ply,1,100)
    return
end

local customRollParameters = string.Split(args[1],"-") -- If the player specifies a roll, ex: "1-125", the server will handle the custom roll
local start = tonumber(customRollParameters[1])
local limit = tonumber(customRollParameters[2])

if (!start || !limit) then
    local exStart = math.random(1,999)
    local exLimit = math.random(exStart,1000)
    print("You must supply a valid roll parameter, ex. 1-100 or "..exStart.."-"..exLimit)
    return
end

if (start == 0) then
    print("Start value must be above 0")
    return
end

if (start > limit) then
    print("Limit must be higher than start value")
    return
end

Roll(ply,start,limit)
end
CMD:Register()