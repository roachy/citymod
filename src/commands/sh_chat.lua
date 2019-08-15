local CMD = CityMod.Command:New("chat")

function CMD:Execute(ply,args)
    local text = table.concat(args, " ")
    print(text)

end
CMD:Register()