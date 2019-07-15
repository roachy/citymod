CityMod.Donation = CityMod.Library:New("Donation")

local _donations = {}

local CLASS_TABLE = {__index = CLASS_TABLE}

function CLASS_TABLE:Register()
    return CityMod.Donation:Register(self)
end

function CityMod.Donation:Start()
timer.Create("CityModDonationTimer",5,0,
function()
    CityMod.Database:Query("SELECT donation_id,account_id,service,quantity,completed FROM donation WHERE completed = 0",function(result)
        for k,v in pairs(result) do -- Get all non-completed donations
            for k2,ply in pairs(player.GetAll()) do -- Get all players to compare accountid with in-game players
                if (result[k].accountid == ply:AccountID()) then
					playerFound = true
                    local service = CityMod.Donation:Get(result[k].service)

                    if (service == nil) then
                        print("Donation with invalid service id "..result[k].service.." was attempted to be given to "..ply:Name().." ("..ply:SteamID().."), please check over donation ids")
                        break
                    end

                    local stmt = CityMod.PreparedStatement.UpdateDonationSetCompleted -- Set the donation as completed
                    stmt:setNumber(1,os.time())
                    stmt:setNumber(2,result[k].id)
                    stmt:start()

                    service:Handle(ply,result[k].quantity) -- Call handle function to process the donation
					break
                end
            end
        end
    end)
end)
end

function CityMod.Donation:New(id)
    if (self:Get(id) ~= nil) then
        error("Donation ID "..id.." already exists.",2)
    end

    local object = CityMod.Metatable:New(CLASS_TABLE)
    object.Id = id
    return object
end

function CityMod.Donation:Register(data)
data.Id = data.Id or -1
_donations[data.Id] = data
end

function CityMod.Donation:Get(id)
    return _donations[id]
end

function CityMod.Donation:GetAll()
    return _donations
end