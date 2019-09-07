-- Create the job
local JOB = CityMod.Job:New("Police Officer")

-- Set the job fields
JOB.Description = "A police officer."
JOB.Category = "Government"
JOB.Models = { "models/error.mdl" };
JOB.WeaponLoadout = {}
JOB.AmmoLoadout = {}
JOB.SpawnPoints = { Vector(0,0,0), Vector(3000,0,0) }

-- Register the job
JOB:Register()