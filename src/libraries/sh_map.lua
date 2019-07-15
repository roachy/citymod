CityMod.Map = CityMod.Library:New("Map")

local _maps = {}

local CLASS_TABLE = {__index = CLASS_TABLE}

function CLASS_TABLE:Register()
    return CityMod.Map:Register(self)
end

function CityMod.Map:New(name)
    local o = CityMod.Metatable:New(CLASS_TABLE)
    o.Name = name
    return o
end

function CityMod.Map:Register(data)
data.Name = data.Name or "NULL"
_maps[data.Name] = data
end

function CityMod.Map:Get(name)
    if (name == nil) then
        return _maps[game.GetMap()]
    end
    
    return _maps[name]
end

function CityMod.Map:GetAll()
    return _maps
end