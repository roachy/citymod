CityMod.Library = {}

local _libraries = {}

function CityMod.Library:New(name)
    if (name == nil or name == "") then
        error("Unknown library name, please specify a name to this library in the initializer parameter",2)
        return
    end

    if (_libraries[name] ~= nil) then
        error("Library with name "..name.." already exists.",2)
    end


    local o = {}
    _libraries[name] = o

    print("Registered library: "..name)    
    return o
end