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

-- Server-side handler for commands
if (SERVER) then
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

        ply:LogIP("used command: "..commandName)
        command:Execute(ply,args) -- Execute the command
        return ""
    end

    -- Return the player's string if no command was specified
    return str
end