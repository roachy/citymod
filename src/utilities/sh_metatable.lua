CityMod.Metatable = {}

function CityMod.Metatable:New(metaTable)
    if (metaTable == nil or type(metaTable) ~= "table") then
        error("Nil table referenced",2)
        return
    end

    local o = {}
    setmetatable(o,metaTable)
    metaTable.__index = metaTable
    return o
end

--[[function CityMod.Metatable:New(metaTable)

    -- Check if there was passed a parameter
    if (metaTable == nil or metaTable == "") then
        error("You must specify a metatable name as the parameter",2)
        return
    end

    -- Get the metatable using FindMetaTable
    local foundMetaTable = FindMetaTable(metaTable)

    -- Determine if the found metatable exists
    if (foundMetaTable == nil) then
        error("Specified metatable was not found",2)
        return
    end
    
    -- Return the found metatable
    return foundMetaTable
end]]