print("Loading shared...")
include("citymod/src/sh_main.lua")
print(">> Finished loading shared")

print("Connecting to database...")
CityMod.Database:Connect(CityMod.Config["MySQL Host"], CityMod.Config["MySQL Username"], CityMod.Config["MySQL Password"], CityMod.Config["MySQL Database"], CityMod.Config["MySQL Port"])
print(">> Finished connecting to database")

print("Starting donation timer...")
CityMod.Donation:Start()
print(">> Finished starting donation timer")