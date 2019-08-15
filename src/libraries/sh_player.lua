CityMod.Player = CityMod.Library:New("Player")

if (CLIENT) then

-- When the player has to load a player's data (which could be their own)
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
    end
        
end
net.Receive("LoadPlayer", CityMod.Player.Load)

function CityMod.Player.LoadInventory()
    -- Set our inventory to the one we received from the server
    LocalPlayer().Inventory = net.ReadTable()

    PrintTable(LocalPlayer().Inventory)
end
net.Receive("LoadInventory", CityMod.Player.LoadInventory)

else -- SERVER

util.AddNetworkString("LoadPlayer")
util.AddNetworkString("LoadInventory")

function CityMod.Player.Load(len, ply)
    if (ply.Initialized) then
        return
    end

    ply.Initialized = true

    CityMod.Database:Query("SELECT name,staff_rank,money FROM account WHERE account_id = '"..ply:AccountID().."'",function(result)

    local newPlayer = false

    -- If player does not exist, create them with default stats.
    if (#result == 0) then
        local stmt = CityMod.PreparedStatement.InsertAccountDetail
        stmt:setNumber(1,ply:AccountID())
        stmt:setString(2,"John Cena")
        stmt:setNumber(3,CityMod.Rank.Player)
        stmt:setNumber(4,12345)
        stmt:start()

        newPlayer = true
            
        result[1] = {}
    end
        
    ply.IngameName = result[1].name or "Brian Johnson"
    ply.Money = result[1].money or 10000
    ply.Rank = result[1].rank or 1

    -- Allow the player to move
    ply:UnLock()
    ply:SetColor(Color(255,255,255,255))
    ply:SetRenderMode(RENDERMODE_NORMAL)
    CityMod:PlayerLoadout(ply)
    ply:SetModel("models/player/breen.mdl")
    ply:SetupHands()

    -- Send information about the loaded player to all players
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
            end

        net.Send(v)
    end

    if (new) then -- Do more stuff (Tutorial things maybe?)
        print(ply:Name().." ("..ply:SteamID()..") has been initialized for the first time")
        return
    end


    print(ply:Name().." ("..ply:SteamID()..") has been initialized")
    CityMod.Player:LoadInventory(ply) -- Load the player's inventory
    end)
end
net.Receive("LoadPlayer", CityMod.Player.Load)

function CityMod.Player:LoadInventory(ply)
    -- Create the player's inventory
    ply.Inventory = {}

    -- Iterate over their inventory and add items
    CityMod.Database:Query("SELECT item_id,modifier,amount FROM account_inventory WHERE account_id = '"..ply:AccountID().."'",function(result)
        for _,v in pairs(result) do
            if (ply.Inventory[v.item_id] == nil) then -- Create item ID in player's inventory if it does not exist
                ply.Inventory[v.item_id] = {}
            end

            -- Set the item's modifier and amount. A single item id can have multiple modifiers with a certain amount (Ex. 20 bullets in a magazine, 32 bullets in another magazine, although they are the same type)
            ply.Inventory[v.item_id][v.modifier] = v.amount
        end

        -- Send the player their inventory
        net.Start("LoadInventory")
        net.WriteTable(ply.Inventory)
        net.Send(ply)
    end)
end

end -- SHARED



function CityMod.Player:FindByID(id)
    for k, v in pairs(player.GetAll()) do
        if (v:UserID() == id or v:SteamID() == id or string.find(string.lower(v:Name()), string.lower(id), 1, true)) then
            return v
        end
    end
end