if (game.SinglePlayer()) then -- Prevent the gamemode from running in singleplayer
    print("[CityMod] Gamemode cannot be run in singleplayer")
    return
end

local _startTime = os.clock()

if (CityModLoaded) then
   MsgC(Color(0,255,255),"Autorefreshing Serverside CityMod...\n")
else
    MsgC(Color(0,255,255),"Starting Serverside CityMod...\n")
end

-- Load and authenticate CityGuard
require("cityguard")
CityGuard.Authenticate()

-- Send files to the client
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("citymod/src/cl_main.lua")

-- Initialize main file for server
include("citymod/src/sv_main.lua")

local _endTime = os.clock()

if (CityModLoaded) then
MsgC(Color(0,255,255),"CityMod Serverside Autorefresh took "..math.Round(_endTime - _startTime,2).." seconds\n")
else
MsgC(Color(0,255,255),"CityMod Serverside initialized on "..os.date("%d/%m/%Y - %H:%M:%S" , os.time())..". It took "..math.Round(_endTime - _startTime,2).." seconds to load.\n")
end

CityModLoaded = true