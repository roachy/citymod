-- Create the job
local JOB = CityMod.Job:New("Thief")

-- Set the job fields
JOB.Description = "A sneaky thief."
JOB.Category = "Criminals"
JOB.Models = { "models/error.mdl" };
JOB.WeaponLoadout = {}
JOB.AmmoLoadout = {}
JOB.SpawnPoints = { Vector(0,0,0) }

-- Register the job
JOB:Register()