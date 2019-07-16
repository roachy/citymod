-- Gamemode Functions
function CityMod:PlayerSpawn(ply)
    if (not ply.Initialized and not ply:IsBot()) then
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

function CityMod:CanPlayerSuicide(ply)
	return ply:IsSuperAdmin()
end


function CityMod:PhysgunPickup(ply, ent)

    -- Allow picking up players if the player is an admin
    if (ent:IsPlayer() and ply:IsAdmin()) then
        ent:Freeze(true)
		ent:SetMoveType(MOVETYPE_NONE)
        return true
    end

    -- TODO: Prop protection
    if (ent:GetClass() == "prop_physics") then
        return true
    end

    return false
end


function CityMod:PhysgunDrop(ply,ent)

    if (ent:IsPlayer() and ply:IsAdmin()) then
        if ply:KeyPressed(IN_ATTACK2) then return end
        
		ent:DropToFloor()
		ent:Freeze(false)
		ent:SetMoveType(MOVETYPE_WALK)
	end
end