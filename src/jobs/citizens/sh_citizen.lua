-- Create the job
local JOB = CityMod.Job:New("Citizen")

-- Set the job fields
JOB.Description = "A normal citizen."
JOB.Category = "Citizens"
JOB.Models = { "models/error.mdl", "models/props_borealis/mooring_cleat01.mdl" };
JOB.WeaponLoadout = {}
JOB.AmmoLoadout = {}
JOB.SpawnPoints = { Vector(0,0,0), Vector(3000,0,0) }

-- Register the job
JOB:Register()