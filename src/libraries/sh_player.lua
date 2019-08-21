CityMod.Player = CityMod.Library:New("Player")

if (CLIENT) then -- CLIENT

-- When the player has to load a player's data (which could be their own data)
function CityMod.Player.Load()
    -- Read the player from the server
    local ply = net.ReadEntity()

    -- Set public data (name, rank etc)
    ply.IngameName = net.ReadString()
    ply.Rank = net.ReadUInt(8)

    -- If we have already been initialized, we can skip the next few steps
    if (LocalPlayer().Initialized) then
        return
    end

    -- If it is our own data, set ourselves as initialized and load our personal data (such as money)
    if (ply == LocalPlayer()) then
        ply.Initialized = true
        ply.Money = net.ReadUInt(32)
        ply.MaxInventorySize = net.ReadUInt(32)
        ply.MaxInventoryWeight = net.ReadUInt(32)
    end
        
end
net.Receive("LoadPlayer", CityMod.Player.Load)

-- Update the player's inventory. Please note that this method gets overriden in the inventory once the inventory has been initialized.
function CityMod.Player.UpdateInventory()
    -- Store variables
    local inventorySlot = net.ReadUInt(32)
    local itemId = net.ReadUInt(16)
    local modifier = net.ReadInt(32)
    local amount = net.ReadUInt(16)

    -- Set the item's properties
    LocalPlayer().Inventory[inventorySlot] = {}
    LocalPlayer().Inventory[inventorySlot].Id = itemId
    LocalPlayer().Inventory[inventorySlot].Modifier = modifier
    LocalPlayer().Inventory[inventorySlot].Amount = amount

    -- Return the inventory slot so the inventory panel can use it
    return inventorySlot
end
net.Receive("UpdateInventory", CityMod.Player.UpdateInventory)

function CityMod.Player.LoadInventory()
    -- Set our inventory to the one we received from the server
    LocalPlayer().Inventory = net.ReadTable()

    print("Our inventory was received on the clientside!")
end
net.Receive("LoadInventory", CityMod.Player.LoadInventory)

-- Show the player a notification
function CityMod.Player.Notify()
    local text = net.ReadString()
    local type = net.ReadUInt(3)
    local length = net.ReadUInt(8)

    notification.AddLegacy(text, type, length)
end
net.Receive("NotifyPlayer", CityMod.Player.Notify)

-- Update a player's money
function CityMod.Player.UpdateMoney()
    local amount = net.ReadUInt(32)

    ply.Money = amount
end
net.Receive("UpdateMoney", CityMod.Player.UpdateMoney)

else -- SERVER

-- Create network messages
util.AddNetworkString("LoadPlayer")
util.AddNetworkString("LoadInventory")
util.AddNetworkString("NotifyPlayer")
util.AddNetworkString("MoveItem")
util.AddNetworkString("UseItem")
util.AddNetworkString("UpdateMoney")
util.AddNetworkString("UpdateInventory")

-- Load a player's data when they have been initialized, and told the server so
function CityMod.Player.Load(len, ply)
    if (ply.Initialized) then -- Do not allow the player to initialize themself again if they have already been initialized
        return
    end

    ply.Initialized = true

    -- Removes the kick timer
    timer.Remove(ply:SteamID().." KickTimer")

    CityMod.Database:Query("SELECT name,staff_rank,money FROM account WHERE account_id = '"..ply:AccountID().."'",function(result)

        local isNewPlayer = false

        -- If the player does not exist in the database, set the newPlayer bool, along with making a placeholder result table.
        if (#result == 0) then
            isNewPlayer = true
            result[1] = {}
        end
            
        -- Set the player's data
        ply.IngameName = result[1].name or ply:Name()
        ply.Rank = result[1].staff_rank or CityMod.Config["Default Rank"]
        ply.Money = result[1].money or CityMod.Config["Default Money"]
        ply.MaxInventorySize = result[1].max_inventory_size or CityMod.Config["Default Maximum Inventory Size"]
        ply.MaxInventoryWeight = result[1].max_inventory_weight or CityMod.Config["Default Maximum Inventory Weight"]

        -- Save the (potentially) new player's data, along with showing message of having been initialized now.
        if (isNewPlayer) then
            ply:LogIP("has been initialized for the first time")

            -- Save their data immediately
            local stmt = CityMod.PreparedStatement.InsertAccountDetail
            stmt:setNumber(1, ply:AccountID())
            stmt:setString(2, ply:SteamID())
            stmt:setString(3, ply.IngameName)
            stmt:setNumber(4, ply.Rank)
            stmt:setNumber(5, ply.Money)
            stmt:setNumber(6, ply.MaxInventorySize)
            stmt:setNumber(7, ply.MaxInventoryWeight)
            stmt:start()
        else 
            ply:LogIP("has been initialized")
        end

        -- Allow the player to move
        ply:UnLock()
        ply:SetColor(Color(255,255,255,255))
        ply:SetRenderMode(RENDERMODE_NORMAL)
        CityMod:PlayerLoadout(ply)
        ply:SetModel("models/player/breen.mdl")
        ply:SetupHands()

        -- Send information about the loaded player to all players, including themself
        for k,v in pairs(player.GetAll()) do
            net.Start("LoadPlayer")
                net.WriteEntity(ply)

                -- Public data available for everyone to see
                net.WriteString(ply.IngameName)
                net.WriteUInt(ply.Rank, 8)

                -- If the iterated player is equivalent to the player itself, send them their personal data, such as money.
                if (ply == v) then
                    -- Private data only the player themself should know (money ex)
                    net.WriteUInt(ply.Money, 32)
                    net.WriteUInt(ply.MaxInventorySize, 32)
                    net.WriteUInt(ply.MaxInventoryWeight, 32)
                end

            net.Send(v)
        end
        
        CityMod.Player:LoadInventory(ply, isNewPlayer) -- Load the player's inventory
    end)
end
net.Receive("LoadPlayer", CityMod.Player.Load)

-- Move an item in a player's inventory between two inventory slots
function CityMod.Player.MoveItem(len, ply)

    -- Do not bother with uninitialized players
    if (not ply.Initialized) then
        return
    end

    local fromSlot = net.ReadUInt(16)
    local toSlot = net.ReadUInt(16)

    -- Fromslot and toslot should not be equal
    if (fromSlot == toSlot) then
        return
    end

    -- Prevent moving the inventory slots outside of bounds
    if (fromSlot < 0 or fromSlot > ply.MaxInventorySize) then
        return
    end

    -- Prevent moving the inventory slots outside of bounds
    if (toSlot < 0 or toSlot > ply.MaxInventorySize) then
        return
    end

    -- Set the inventory item and callback to the client
    local item1 = ply.Inventory[fromSlot]
    local item2 = ply.Inventory[toSlot]

    ply.Inventory[fromSlot] = item2
    ply.Inventory[toSlot] = item1

    -- Tell the client the move is correct
    net.Start("MoveItem")
    net.Send(ply)

    -- If the from slot is now empty, it means that there was no item there. Simply send a query telling to update the position of the moved item
    if (ply.Inventory[fromSlot] == nil) then
        CityMod.Database:Query("UPDATE account_inventory SET inventory_slot = "..toSlot.." WHERE inventory_slot = "..fromSlot.." AND account_id = "..ply:AccountID())
    else
        -- Swap items
        CityMod.Database:Query("UPDATE account_inventory SET inventory_slot = "..fromSlot.." WHERE account_id = "..ply:AccountID().." AND item_id = "..ply.Inventory[fromSlot].Id.." AND modifier = "..ply.Inventory[fromSlot].Modifier)
        CityMod.Database:Query("UPDATE account_inventory SET inventory_slot = "..toSlot.." WHERE account_id = "..ply:AccountID().." AND item_id = "..ply.Inventory[toSlot].Id.." AND modifier = "..ply.Inventory[toSlot].Modifier)
    end

    --CityMod.Database:Query("UPDATE account_inventory s1, account_inventory s2 SET s1.inventory_slot=s1.y, s1.y=s2.x WHERE s1.account_id=s2.id;")
end
net.Receive("MoveItem", CityMod.Player.MoveItem)

-- Create an item at a designated slot
function CityMod.Player:CreateItemInSlot(ply, inventorySlot, itemId, modifier, amount)
    -- Initialize the inventory slot's table
    ply.Inventory[inventorySlot] = {}

    -- Set the properties of the item (item id, modifier, amount)
    ply.Inventory[inventorySlot].Id = itemId
    ply.Inventory[inventorySlot].Modifier = modifier
    ply.Inventory[inventorySlot].Amount = amount

    -- Store the newly created item in the database
    CityMod.Database:Query("INSERT INTO account_inventory(account_id,inventory_slot,item_id,modifier,amount) VALUES ("..ply:AccountID()..","..inventorySlot..","..itemId..","..modifier..","..amount..")")

    -- Update the player's inventory client-side
    self:UpdateInventory(ply, inventorySlot, itemId, modifier, amount)
end

--  Update the player's inventory with the specified item at the position
function CityMod.Player:UpdateInventory(ply, inventorySlot, itemId, modifier, amount)
    net.Start("UpdateInventory")
    net.WriteUInt(inventorySlot, 32)
    net.WriteUInt(itemId, 16)
    net.WriteInt(modifier, 32)
    net.WriteUInt(amount, 16)
    net.Send(ply)
end

function CityMod.Player:GiveItem(ply, itemId, modifier, amount, force)

    -- Negative numbers should not be used here
    if (amount <= 0) then
        error("Negative numbers and zero should NOT be used in TakeItem", 2)
    end
    
    -- TODO: Check against the item's weight here. This can however be bypassed with the "force" parameter
    -- if (ply.Weight...)
    --end
    
    -- Free slot variable for potentially storing an item
    local freeSlot = nil

    -- Iterate over the player's inventory to see whether an already existing item can be stacked
    for i = 0, ply.MaxInventorySize-1 do -- 0-indexed

        -- If a free slot was found, and the freeslot variable was not already set, set it to the current i
        if (ply.Inventory[i] == nil and freeSlot == nil) then
            freeSlot = i
        end

        -- Check whether an item exists in the given inventory slot
        if (ply.Inventory[i] ~= nil) then
            local item = ply.Inventory[i]

            -- Since the item exists, check against the item's id and modifier
            if (item.Id == itemId and item.Modifier == modifier) then


                -- All checks passed, modify the item by the new count and save to database.
                item.Amount = item.Amount+amount
                CityMod.Database:Query("UPDATE account_inventory SET amount = "..item.Amount.." WHERE account_id = "..ply:AccountID().." AND item_id = "..item.Id.." AND modifier = "..item.Modifier)
                
                -- Update the player's inventory with the new item in slot i
                self:UpdateInventory(ply, i, item.Id, item.Modifier, item.Amount)
                return true
            end
        end
    end

    -- The player does not have free space in their inventory
    if (not freeSlot) then
        return false
    end

    -- Since the item could not be stacked, and a free slot exists, create the item
    self:CreateItemInSlot(ply, freeSlot, itemId, modifier, amount)
    return true
end

function CityMod.Player:TakeItem(ply, itemId, modifier, amount, force)

    -- Negative numbers should not be used here
    if (amount <= 0) then
        error("Negative numbers and zero should NOT be used in TakeItem", 2)
    end

    -- Iterate over the player's inventory
    for i = 0, ply.MaxInventorySize-1 do -- 0-indexed

        -- Check whether an item exists in the given inventory slot
        if (ply.Inventory[i] ~= nil) then
            local item = ply.Inventory[i]

            -- Since the item exists, check against the item's id and modifier
            if (item.Id == itemId and item.Modifier == modifier) then

                -- The right item is now found. Test whether the player at least has the item's amount
                if (amount > item.Amount and not force) then
                    return false -- Return as the player does not have the amount requested to be taken.
                end

                -- All checks passed, modify the item by the new count and save to database.
                item.Amount = item.Amount-amount

                -- If the item's count is 0, delete its entry in the database
                if (item.Amount == 0) then
                    CityMod.Database:Query("DELETE FROM account_inventory WHERE account_id = "..ply:AccountID().." AND item_id = "..item.Id.." AND modifier = "..item.Modifier)
                else
                    -- Else, update the item's amount to the new one
                    CityMod.Database:Query("UPDATE account_inventory SET amount = "..item.Amount.." WHERE account_id = "..ply:AccountID().." AND item_id = "..item.Id.." AND modifier = "..item.Modifier)
                end

                return true
            end
        end
    end

    -- No item with that id and modifier was found, simply return.
    return false
end

function CityMod.Player.UseItem(len, ply)
    local inventorySlot = net.ReadUInt(32)

    -- If there is no item in that slot, return
    if (ply.Inventory[inventorySlot] == nil) then
        return
    end

    -- Get the item's properties
    local item = CityMod.Item:Get(ply.Inventory[inventorySlot].Id)

    local itemModifier = ply.Inventory[inventorySlot].Modifier

    -- Check whether the item should be consumed
    if (item.ConsumeOnUse) then
        
        -- If the amount to consume is greater than what the player possesses, return as they cannot do this.
        if (item.ConsumeCount > ply.Inventory[inventorySlot].Amount) then
            return
        end

        local itemId = ply.Inventory[inventorySlot].Id

        -- Take the item from their inventory
        if (not ply:TakeItem(itemId, itemModifier, item.ConsumeCount)) then
            return
        end
    end

    -- Execute the item's function, passing both the player and item's modifier
    item:Execute(ply, itemModifier)

    -- Log the usage of the item
    ply:LogIP("used item with name: "..item.Name)

    -- Send callback to the player that the item was used
    net.Start("UseItem")
    net.Send(ply)
end
net.Receive("UseItem", CityMod.Player.UseItem)

function CityMod.Player:LoadInventory(ply, isNewPlayer)
    -- Create the player's inventory
    ply.Inventory = {}

    if (isNewPlayer) then
        -- Set their inventory compared to some default state, if there is any. No querying is necessary, as they do not have anything in their inventory

        return
    end

    -- Iterate over their inventory and add items
    CityMod.Database:Query("SELECT inventory_slot,item_id,modifier,amount FROM account_inventory WHERE account_id = '"..ply:AccountID().."'",function(result)
        for _,v in pairs(result) do
            if (ply.Inventory[v.inventory_slot] == nil) then -- Create item slot in player's inventory if it does not exist
                ply.Inventory[v.inventory_slot] = {}
            end

            -- Set the inventory slot's item id, modifier, and amount server-side.
            ply.Inventory[v.inventory_slot].Id = v.item_id
            ply.Inventory[v.inventory_slot].Modifier = v.modifier
            ply.Inventory[v.inventory_slot].Amount = v.amount
        end

        ply:LogIP("finished loading inventory")

        -- Send the player their inventory
        net.Start("LoadInventory")
        net.WriteTable(ply.Inventory)
        net.Send(ply)
    end)
end

-- Send a notification to the player
function CityMod.Player:Notify(ply, text, type, length)
    if (length == nil) then -- Set default length if it was not specified
        length = 3
    end

    net.Start("NotifyPlayer")
    net.WriteString(text)
    net.WriteUInt(type,3) -- 3 bits is enough
    net.WriteUInt(length,8)
    net.Send(ply)
end

function CityMod.Player:GiveMoney(ply, amount)

    -- Check if money is negative or zero
    if (amount <= 0) then
        error("You cannot give negative or zero money to a player", 2)
    end

    -- Update the player's money
    ply.Money = ply.Money+amount

    -- Call UpdateMoney
    self:UpdateMoney(ply)
end

function CityMod.Player:TakeMoney(ply, amount)

    -- Check if money is negative or zero
    if (amount <= 0) then
        error("You cannot take negative or zero money from a player", 2)
    end

    -- Update the player's money
    ply.Money = ply.Money-amount

    -- Call UpdateMoney
    self:UpdateMoney(ply)
end

-- Update the player's money client-side
function CityMod.Player:UpdateMoney(ply)
    net.Start("UpdateMoney")
    net.WriteUInt(ply.Money, 32)
    net.Send(ply)
end




end -- SHARED


function CityMod.Player:FindByID(id)
    for k, v in pairs(player.GetAll()) do
        if (v:UserID() == id or v:SteamID() == id or string.find(string.lower(v:Name()), string.lower(id), 1, true)) then
            return v
        end
    end
end