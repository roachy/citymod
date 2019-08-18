CityMod.Item = CityMod.Library:New("Item")
CityMod.Item.Category = {}

local CLASS_TABLE = {__index = CLASS_TABLE}

-- Set default values of an item
CLASS_TABLE.Name = "Base Item"
CLASS_TABLE.Cost = 0
CLASS_TABLE.Batch = 10
CLASS_TABLE.Model = "models/error.mdl";
CLASS_TABLE.Weight = 1
CLASS_TABLE.Category = "None"
CLASS_TABLE.Description = "Sample item"
CLASS_TABLE.ConsumeOnUse = true -- In most cases, an item will be consumed on use

local _items = {}
local _categories = {}

-- Creation of a new item object
function CityMod.Item:New(id) -- The ID of the item
    local object = CityMod.Metatable:New(CLASS_TABLE)
    object.Id = id
    return object
end

function CLASS_TABLE:Register()
    if (self.Id == nil) then -- If name is nil, it is a category
        return CityMod.Item.Category:Register(self)
    end

    return CityMod.Item:Register(self)
end

-- Registering a new item
function CityMod.Item:Register(data)

    -- Check if an ID was specified to the item (the parameter of :New on item creation)
    if (not data.Id) then
        print("No ID specified to item in file "..debug.getinfo(2, "S").source:sub(2))
        return
    end

    -- Check if the item has a valid category
    if (data.Category == "None") then
        print("Item with name "..data.Name.." does not have a category")
        return
    end

    -- Get the category of the item
    local category = CityMod.Item.Category:Get(data.Category)

    -- Check if the category was found
    if (category == nil) then
        print("Category with name "..data.Category.." does not exist")
        return
    end

    -- Set metatable to the category to make it able to access its baseclass
    setmetatable(data, category)

    -- Store the item by its ID
    _items[data.Id] = data
end

function CityMod.Item:Get(item)
    return _items[item]
end

function CityMod.Item:GetAll()
    return _items
end

-- Creating a new item category
function CityMod.Item.Category:New(categoryName)
    local object = CityMod.Metatable:New(CLASS_TABLE)
    object.__index = object -- Set index to have baseclass be callable by children
    object.Category = categoryName
    return object
end

function CityMod.Item.Category:Register(data)
    _categories[data.Category] = data -- Store the category
end

function CityMod.Item.Category:Get(category)
    return _categories[category]
end

function CityMod.Item.Category:GetAll()
    return _categories
end