CityMod.Job = CityMod.Library:New("Job")

local _jobs = {}

local CLASS_TABLE = {__index = CLASS_TABLE}

function CLASS_TABLE:Register()
    return CityMod.Command:Register(self)
end

-- Note: Had to make use of "GAME" as client did not seem to accept "LUA" for whatever fucking reason it had. It is pretty easy to change functionality over once it works again however.
function CityMod.Job:Load(directory)

    if (directory == nil) then
    directory = "jobs"
    end

    local directory = debug.getinfo(2, "S").source:sub(2):match("(.*/)")..directory
    local files,dirs = file.Find(directory.."/*", "GAME", "namedesc")

    if (#files > #dirs) then
        print("[CityMod] Job -> There are more baseclasses than categories")
        return
    end

    for k, v in pairs(files) do
        CityMod.File:Include(directory:sub(11).."/"..v)
        
        local f = string.StripExtension(v):sub(4)
        local _categoryDir = directory.."/"..f
        
        if (file.Exists(_categoryDir,"GAME")) then
            local filesCategory,dirsCategory = file.Find(_categoryDir.."/*.lua", "game", "namedesc")
            
            for k2,v2 in pairs(filesCategory) do
                CityMod.File:Include(_categoryDir:sub(11).."/"..v2)
            end
        else
            print("[CityMod] Job -> Baseclass '"..f.."' is missing a category folder") 
            return
        end
    end
end

function CityMod.Job:New(categoryName)
    local object = {}
    setmetatable(object,self)
    
    if (categoryName) then
        object.__index = object
        object.Category = categoryName
        -- Do more stuff here for categories, such as GUI or just store the things in _jobs
    end
    return object
end

function CityMod.Job:Register()

    if (not self.Name) then
        print("No name specified to job in "..debug.getinfo(2, "S").source:sub(2))
        return
    end

    _jobs[string.StripExtension(string.GetFileFromFilename(debug.getinfo(2, "S").source:sub(2)))] = self
    self.Id = nil

    -- Remove things that are useless for client
    if (CLIENT) then
    self.Execute = nil
    end

    -- Remove things that are useless for server
    if (SERVER) then
    self.Name = nil
    end

end

function CityMod.Job:Get(item)
    return _jobs[item]
end

function CityMod.Job:GetAll()
    return _jobs
end