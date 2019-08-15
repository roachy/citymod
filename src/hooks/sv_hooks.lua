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
    return ply:HasModeratorRank()
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

-- Determines whether a player can suicide
function CityMod:CanPlayerSuicide(ply)
	return ply:HasModeratorRank()
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
    if (ent:IsPlayer() and ply:HasAdminRank()) then
        if ply:KeyPressed(IN_ATTACK2) then return end
        
		ent:DropToFloor()
		ent:Freeze(false)
		ent:SetMoveType(MOVETYPE_WALK)
	end
end

function CityMod:CheckPassword(steamID64, ipAddress, svPassword, clPassword, name)

end

--[[gameevent.Listen( "player_connect" ) -- Deprecated, use CheckPassword
hook.Add( "player_connect", "CityModPlayerConnect", function(data)
	for k, v in pairs( player.GetAll() ) do
		v:ChatPrint( data.name .. " has connected to the server." )
    end

    -- Check if player is banned
    

    -- Create an idle loading timer before a kick will occur
    timer.Create(data.networkid.." KickTimer", 1200, 1, function() RunConsoleCommand("kickid", data.userid, "You took too long to load the server. Please rejoin.") end)
end)]]