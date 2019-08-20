CityMod.File = {}

function CityMod.File:Include(fileName)
    local isShared = string.find(fileName, "sh_")
    local isClient = string.find(fileName, "cl_")
    local isServer = string.find(fileName, "sv_")

    if (isServer and not SERVER) then
        error("Serverside file "..fileName.." was attempted to be included on client", 2)
        return
    end

    if (isClient and SERVER) then
        AddCSLuaFile(fileName)
        return
    elseif (isShared and SERVER) then
        AddCSLuaFile(fileName)
    end

    include(fileName)
end

function CityMod.File:IncludeDir(directory, fromBase)
    if (not fromBase) then
        directory = "CityMod/src/"..directory
    end

    if (string.sub(directory, -1) ~= "/") then
        directory = directory.."/"
    end

    for k, v in pairs(file.Find(directory.."*.lua", "LUA", "namedesc")) do
        self:Include(directory..v)
    end
end

-- A function to load the addons
--[[function CityMod.File:IncludeAddons()
    directory = "CityMod/addons/"

    local files,dirs = file.Find(directory.."*", "LUA", "namedesc")

    for k, v in pairs(dirs) do
        self:Include(directory..v.."/sh_"..v..".lua")
    end
end]]