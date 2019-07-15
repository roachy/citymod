local CMD = CityMod.Command:New("dropmoney")

function CMD:Execute(ply,args)
local amount = tonumber(args[1])

if (not amount) then
    ply:NotifyError("Supply an amount of money")
    return
end

amount = math.floor(amount)

if (amount <= 0) then
    ply:NotifyError("Amount must be a positive number")
    return
end

if (amount > ply.Money) then
    if (amount == 1) then
        ply:Notify("You need a dollar dollar, a dollar is what you need")
        return
    end
    ply:NotifyError("You need another "..amount-ply.Money.."$")
    return
end

ply.Money = ply.Money-amount -- All checks passed, set money serverside
ply:Notify("You dropped "..amount.."$")

local packet = CityMod.ServerPacket.UpdatePlayerMoney -- Let the client know how much they have
packet.Amount = -amount
ply:SendPacket(packet)

end
CMD:Register()