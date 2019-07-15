local donation = CityMod.Donation:New(0)

function donation:Handle(ply,quantity)
print("DEBUG: DONATION Test 1")
print(quantity)

if (quantity == 2) then
    print("DEBUG: DONATION Test 2")
end

ply:Kill()
end

donation:Register()