-- Gamemode Functions
function CityMod:PlayerSpawn(ply)
if (!ply.Initialized && !ply:IsBot()) then
    ply:Lock()
    ply:SetMoveType(MOVETYPE_NOCLIP)
    ply:SetColor(Color(0,0,0,0))
    ply:SetRenderMode(RENDERMODE_TRANSALPHA)
    return
end

CityMod:PlayerLoadout(ply)
ply:SetModel("models/player/breen.mdl")
ply:SetupHands()
end

function CityMod:PlayerLoadout(ply)
    ply:Give("weapon_physgun")
    ply:Give("gmod_tool")
    ply:Give("gmod_camera")
end

function CityMod:PlayerNoClip(ply)
    return ply.Rank <= CityMod.Rank.Moderator
end

function CityMod:CanPlayerEnterVehicle(ply,veh,role)
    return CityMod.Map().CanDriveCars
end



function CityMod:PlayerEnteredVehicle(ply,veh,role)

if (veh:GetVehicleClass() ~= "ast_db5tdm") then -- A car
    return
end

if (veh:GetDriver() ~= ply) then -- In driver seat
    return
end

local packet = CityMod.ServerPacket.PlayerEnteredVehicle
ply:SendPacket(packet)


end