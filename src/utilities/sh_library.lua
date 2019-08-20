CityMod.Library = {}

local _libraries = {}

function CityMod.Library:New(libraryName)
    if (libraryName == nil or libraryName == "") then
        error("Unknown library libraryName, please specify a libraryName to this library in the initializer parameter", 2)
        return
    end

    if (_libraries[libraryName] ~= nil) then
        error("Library with libraryName "..libraryName.." already exists.", 2)
    end


    local o = {}
    _libraries[libraryName] = o

    print("Registered library: "..libraryName)    
    return o
end