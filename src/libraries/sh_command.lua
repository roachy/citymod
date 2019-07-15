local CityMod = CityMod
CityMod.Command = CityMod.Library:New("Command")

local CLASS_TABLE = {__index = CLASS_TABLE}

-- Storage for commands
local _commands = {}

function CLASS_TABLE:Register()
    return CityMod.Command:Register(self)
end

function CityMod.Command:New(name)
    local object = CityMod.Metatable:New(CLASS_TABLE)
    object.Name = name or "NULL"
    return object
end

-- Supposed to be called by object created with :New
function CityMod.Command:Register(data)
    _commands[data.Name] = data
end

function CityMod.Command:Get(name)
    return _commands[name]
end

function CityMod.Command:GetAll()
    return _commands
end

-- Command handler
if (SERVER) then
    function GM:PlayerSay(ply, str)
        if (string.sub(str,1,1) == "/") then
            local args = string.Split(string.sub(str,2)," ")

            if (args[1] == "") then
                print("No command specified", 1,5)
                return ""
            end

            local commandName = string.lower(args[1])
            local command = CityMod.Command:Get(commandName)
            if (command == nil) then
                print("Invalid command: "..commandName)
                return ""
            end
            table.remove(args,1) -- Remove the command itself from the args table

            command:Execute(ply,args) -- Execute the command
            return ""
        end

        return str
    end
end