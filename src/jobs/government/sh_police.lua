-- Create the job
local JOB = CityMod.Job:New("Police Officer")

-- Set the job fields
JOB.Description = "A police officer."
JOB.Category = "Government"
JOB.Model = "models/error.mdl";
JOB.WeaponLoadout = {}
JOB.AmmoLoadout = {}

-- Register the job
JOB:Register()