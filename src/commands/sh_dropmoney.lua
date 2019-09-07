local CMD = CityMod.Command:New("dropmoney")

function CMD:Execute(ply,args)
    
    local plyMoney = ply:GetMoney()

    -- Simply return if the player does not have any money
    if (plyMoney <= 0) then
        ply:NotifyError("You do not have any money to drop")
        return
    end

    -- Store the args
    local amount = tonumber(args[1])

    -- If args was nil, return
    if (not amount) then
        ply:NotifyError("Supply an amount of money to drop")
        return
    end

    -- Floor the value
    amount = math.floor(amount)

    -- The amount must be a positive number
    if (amount <= 0) then
        ply:NotifyError("Money to drop must be a positive number")
        return
    end

    -- If the player does not have the amount of money specified, return
    if (amount > plyMoney) then
        ply:NotifyError("You need another "..amount-plyMoney.."$")
        return
    end

    -- All checks passed, set money serverside and notify the player
    ply:TakeMoney(amount)
    ply:NotifyGeneric("You dropped "..amount.."$")
    CityMod.Database:Query("UPDATE account SET money = "..ply:GetMoney().." WHERE account_id = "..ply:AccountID())
end
CMD:Register()