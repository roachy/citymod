if (CLIENT) then

timer.Create("StaminaTimer", 0.1, 0, function()

if (not LocalPlayer().Initialized) then -- Return if the player is not yet initialized
    return
end

if (not LocalPlayer():KeyDown(IN_SPEED)) then -- Check if the player has the run key down
    return
end

if (not LocalPlayer():IsOnGround()) then -- Check whether the player is on the ground
    return
end

local runSpeed = LocalPlayer():GetVelocity():Length() -- Calculate the running speed

if (runSpeed == 0) then -- Return if the player is not moving
    return
end

print("DEBUG: Run speed = "..math.ceil(runSpeed))

end)

end