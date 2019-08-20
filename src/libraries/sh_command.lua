local CityMod = CityMod
CityMod.Command = CityMod.Library:New("Command")

local CLASS_TABLE = {__index = CLASS_TABLE}

-- Storage for commands
local _commands = {}

function CLASS_TABLE:Register()
    return CityMod.Command:Register(self)
end

function CityMod.Command:New(name)
    local object = CityMod.Metatable:New(CLASS_TABLE)
    object.Name = name or "NULL"
    return object
end

-- Supposed to be called by object created with :New
function CityMod.Command:Register(data)
    _commands[data.Name] = data
end

function CityMod.Command:Get(name)
    return _commands[name]
end

function CityMod.Command:GetAll()
    return _commands
end