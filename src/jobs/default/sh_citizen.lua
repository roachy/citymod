-- Create the job
local JOB = CityMod.Job:New("Citizen")

-- Set the job fields
JOB.Description = "A normal citizen."
JOB.Category = "Default"
JOB.Models = { "models/error.mdl" };
JOB.WeaponLoadout = {}
JOB.AmmoLoadout = {}
JOB.SpawnPoints = { Vector(0,0,0), Vector(3000,0,0) }

-- Register the job
JOB:Register()