if (game.SinglePlayer()) then -- Prevent gamemode from running in singleplayer, this is due to AccountID()
    print("[CityMod] Gamemode cannot be run in singleplayer")
    return
end

local _startTime = os.clock()

if (CityModLoaded) then
	MsgC(Color(255,230,0),"Autorefreshing Clientside CityMod...\n")
else
	MsgC(Color(255,230,0),"Starting Clientside CityMod...\n")
end

include("citymod/src/cl_main.lua")

local _endTime = os.clock()

if (CityModLoaded) then
MsgC(Color(255,230,0),"CityMod Clientside Autorefresh took "..math.Round(_endTime - _startTime,2).." seconds\n\n")
else
MsgC(Color(255,230,0),"CityMod Clientside initialized on "..os.date("%d/%m/%Y - %H:%M:%S" , os.time())..". It took "..math.Round(_endTime - _startTime,2).." seconds to load.\n\n")
end
CityModLoaded = true
