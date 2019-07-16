-- gamble
-- Gambles the specified money on a roll from 1 to 100, with no minimum on the cash required. You have to roll above 55 to double your money. An amount can be ex. /gamble 250

local CMD = CityMod.Command:New("gamble")

function CMD:Execute(ply,args)
local amount = tonumber(args[1])

print(amount)

if (not amount) then
    notification.AddLegacy("You must specify an amount of money. You have to roll higher than 55 to double the money.",1,5)
    return
end

if (amount <= 0) then
    notification.AddLegacy("No, you cannot gamble negative or 0 dollars",1,5)
    return
end

if (amount > ply.Money) then
    notification.AddLegacy("You need another "..amount-ply.Money.."$",1,5)
    return
end

local packet = CityMod.ClientPacket.Gamble
packet.Amount = amount
packet:Send()
end
CMD:Register()