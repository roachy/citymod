CityMod.Job = CityMod.Library:New("Job")
CityMod.Job.Category = {}

local CLASS_TABLE = {__index = CLASS_TABLE}

-- Set default values of a job
CLASS_TABLE.Description = "Sample Job"
CLASS_TABLE.Category = "None"
CLASS_TABLE.Models = { "models/error.mdl" };
CLASS_TABLE.WeaponLoadout = {}
CLASS_TABLE.AmmoLoadout = {}
CLASS_TABLE.SpawnPoints = {} -- Spawnpoints should be set for the specific map
CLASS_TABLE.CurrentActive = 0
CLASS_TABLE.MaxActive = 1

local _jobs = {}
local _categories = {}

-- Creation of a new item object
function CityMod.Job:New(id) -- The ID of the job
    local object = CityMod.Metatable:New(CLASS_TABLE)
    object.Name = id
    return object
end

function CLASS_TABLE:Register()
    if (self.Name == nil) then -- If name is nil, it is a category
        return CityMod.Job.Category:Register(self)
    end

    return CityMod.Job:Register(self)
end

-- Registering a new item
function CityMod.Job:Register(data)

    -- Check if an ID was specified to the item (the parameter of :New on item creation)
    if (not data.Name) then
        error("No ID specified to job", 2)
        return
    end

    -- Check if the item has a valid category
    if (data.Category == "None") then
        error("Job with name "..data.Name.." does not have a category", 2)
        return
    end

    -- Get the category of the item
    local jobCategory = CityMod.Job.Category:Get(data.Category)

    -- Check if the category was found
    if (jobCategory == nil) then
        error("Category with name "..data.Category.." does not exist", 2)
        return
    end

    -- Set metatable to the category to make it able to access its baseclass
    setmetatable(data, jobCategory)

    -- Store the item by its ID
    _jobs[data.Name] = data
end

function CityMod.Job:Get(item)
    return _jobs[item]
end

function CityMod.Job:GetAll()
    return _jobs
end

-- Creating a new item category
function CityMod.Job.Category:New(categoryName)
    local object = CityMod.Metatable:New(CLASS_TABLE)
    object.__index = object -- Set index to have baseclass be callable by children
    object.Category = categoryName
    return object
end

function CityMod.Job.Category:Register(data)
    _categories[data.Category] = data -- Store the category
end

function CityMod.Job.Category:Get(category)
    return _categories[category]
end

function CityMod.Job.Category:GetAll()
    return _categories
end