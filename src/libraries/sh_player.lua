CityMod.Player = CityMod.Library:New("Player")

if (CLIENT) then

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

else -- SERVER

util.AddNetworkString("LoadPlayer")
util.AddNetworkString("LoadInventory")
util.AddNetworkString("NotifyPlayer")

function CityMod.Player.Load(len, ply)
    if (ply.Initialized) then -- Do not allow the player to initialize themself again if they have already been initialized
        return
    end

    ply.Initialized = true

    -- Removes the kick timer
    timer.Remove(ply:SteamID().." KickTimer")

    CityMod.Database:Query("SELECT name,staff_rank,money FROM account WHERE account_id = '"..ply:AccountID().."'",function(result)

        local isNewPlayer = false

        -- If the player does not exist in the database, create them with default stats.
        if (#result == 0) then
            isNewPlayer = true
            result[1] = {}
        end
            
        ply.IngameName = result[1].name or ply:Name()
        ply.Rank = result[1].staff_rank or CityMod.Config["Default Rank"]
        ply.Money = result[1].money or CityMod.Config["Default Money"]
        ply.MaxInventorySize = result[1].max_inventory_size or CityMod.Config["Default Maximum Inventory Size"]
        ply.MaxInventoryWeight = result[1].max_inventory_weight or CityMod.Config["Default Maximum Inventory Weight"]

        -- Save the (potentially) new player's data, along with showing message of having been initialized now.
        if (isNewPlayer) then -- Do more stuff (Tutorial things maybe?)
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

function CityMod.Player:LoadInventory(ply, isNewPlayer)
    -- Create the player's inventory
    ply.Inventory = {}

    -- Iterate over their inventory and add items
    CityMod.Database:Query("SELECT inventory_slot,item_id,modifier,amount FROM account_inventory WHERE account_id = '"..ply:AccountID().."'",function(result)
        for _,v in pairs(result) do
            if (ply.Inventory[v.inventory_slot] == nil) then -- Create item ID in player's inventory if it does not exist
                ply.Inventory[v.inventory_slot] = {}
            end

            -- Set the inventory slot's item id, modifier, and amount.
            ply.Inventory[v.inventory_slot].ItemId = v.item_id
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

end -- SHARED


function CityMod.Player:FindByID(id)
    for k, v in pairs(player.GetAll()) do
        if (v:UserID() == id or v:SteamID() == id or string.find(string.lower(v:Name()), string.lower(id), 1, true)) then
            return v
        end
    end
end