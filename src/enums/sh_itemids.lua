-- A system for handling item ID
CityMod.ItemID = {}

local _itemids = {}

function CityMod.ItemID:New(itemId)

    -- Check whether an item with that ID already exists
    if (_itemids[itemId] ~= nil) then
        error("Item with ID "..itemId.." already exists", 2)
    end

    -- Store the item in the itemids table
    _itemids[itemId] = #_itemids
end

function CityMod.ItemID:Get(itemId)
    
    -- Check whether the item does note xist
    if (_itemids[itemId] == nil) then
        error("Item with ID "..itemId.." does not exist", 2)
    end

    -- Return the item's ID
    return _itemids[itemId]
end

-- NEVER change the order on this. KEEP items EVEN if they are unused
CityMod.ItemID:New("M4A1")