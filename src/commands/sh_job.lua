local CMD = CityMod.Command:New("job")

function CMD:Execute(ply,args)
    CityMod.Player:ChangeJob(ply,"Citizen")
end
CMD:Register()