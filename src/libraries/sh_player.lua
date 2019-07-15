CityMod.Player = CityMod.Library:New("Player")

if (CLIENT) then

-- When the player's data has been received on the server
function CityMod.Player.Load()
    LocalPlayer().Initialized = true
    LocalPlayer().IngameName = net.ReadString()
    LocalPlayer().Money = net.ReadUInt(32)
    LocalPlayer().Rank = net.ReadUInt(8)
end
net.Receive("LoadPlayer", CityMod.Player.Load)

else -- SERVER

util.AddNetworkString("LoadPlayer")

function CityMod.Player.Load(len, ply)
    if (ply.Initialized) then
        return
    end

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

    -- Send the values to the client
    net.Start("LoadPlayer") -- Iterate over all players instead here.
    --net.WriteBool(false) -- Write bool depending on if it is the player self, or another player. If self, send whole thing like money etc. If not, send only the "public" info like name.
    net.WriteString(ply.IngameName)
    net.WriteUInt(ply.Money, 32)
    net.WriteUInt(ply.Rank, 8)
    net.Send(ply)

    if (new) then -- Do more stuff (Tutorial things maybe?)
        print(ply:Name().." ("..ply:SteamID()..") has been initialized for the first time")
        return
    end


    print(ply:Name().." ("..ply:SteamID()..") has been initialized")
    end)
end
net.Receive("LoadPlayer", CityMod.Player.Load)

end -- SHARED



function CityMod.Player:FindByID(id)
    for k, v in pairs(player.GetAll()) do
        if (v:UserID() == id or v:SteamID() == id or string.find(string.lower(v:Name()), string.lower(id), 1, true)) then
            return v
        end
    end
end