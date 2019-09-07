function CityMod:PlayerSpawn(ply)
    if (not ply.Initialized and not ply:IsBot()) then
        ply:Lock()
        ply:SetMoveType(MOVETYPE_NOCLIP)
        ply:SetColor(Color(0,0,0,0))
        ply:SetRenderMode(RENDERMODE_TRANSALPHA)
        return
    end

    ply:SetModel("models/player/breen.mdl")
    -- Call this to give the player their loadout
    return self.BaseClass.PlayerSpawn(self, ply)
end

function CityMod:PlayerLoadout(ply)
    ply:Give("weapon_physgun")
    ply:Give("gmod_tool")
    ply:Give("gmod_camera")

    -- Get the custom loadout of the player, both weapons and ammo.
    --local job = CityMod.Job:Get(ply.Job)


end

function CityMod:PlayerNoClip(ply)
    return ply:HasModeratorRank() -- Only allow moderators to noclip
end

function CityMod:CanPlayerEnterVehicle(ply,veh,role)
    return CityMod.Map:Get().CanDriveCars
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

    -- Allow picking up players if the player is a moderator
    if (ent:IsPlayer() and ply:HasModeratorRank()) then
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
    local steamid32 = util.SteamIDFrom64(steamID64)

    CityMod.Database:Query("SELECT ban_expiration,ban_reason FROM ban WHERE steam_id = '"..steamid.."' AND ban_expiration > NOW()",function(result)
        -- If no current bans were found on the player, return
        if (#result == 0) then
            return
        end

        local ban_reason = "You have been banned for the following reason: "..v.ban_reason.."\nYour ban will expire on: "..v.ban_expiration

        -- At this point, the player has a ban. Return false and show their ban reason
        return false, ban_reason
    end)
end

function CityMod:PlayerSay(ply, str)
    -- If it is not a symbol for commands, return the string
    if (string.sub(str,1,1) ~= "/") then
        return str
    end

    -- Split the string into arguments
    local args = string.Split(string.sub(str,2)," ")

    -- If the fhe first argument is the empty string, no command was specified
    if (args[1] == "") then
        print("No command specified", 1,5)
        return ""
    end

    -- Lowercase the string, and grab the command from the table
    local commandName = string.lower(args[1])
    local command = CityMod.Command:Get(commandName)
    if (command == nil) then
        ply:NotifyError("Invalid command: "..commandName) -- TODO: Notify player instead
        ply:LogIP("specified an invalid command: "..commandName)
        return ""
    end
    table.remove(args,1) -- Remove the command itself from the args table

    if (#args > 0) then
        ply:LogIP("used command \""..commandName.."\" with arguments: "..table.concat(args," "))
    else
        ply:LogIP("used command \""..commandName.."\"")
    end

    command:Execute(ply,args) -- Execute the command
    return ""
end

-- Return the player's string if no command was specified
return str