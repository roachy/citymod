print("Loading shared...")
include("citymod/src/sh_main.lua")
print(">> Finished loading shared")

print("Connecting to database...")
CityMod.Database:Connect("127.0.0.1","root","root","citymod",3306)
print(">> Finished connecting to database")

print("Starting donation timer...")
CityMod.Donation:Start()
print(">> Finished starting donation timer")