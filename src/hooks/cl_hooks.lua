
-- At this point, LocalPlayer() exists. Tell the server that we are ready to load.
function CityMod:InitPostEntity()
    net.Start("LoadPlayer")
    net.SendToServer()
end

function CityMod:PlayerNoClip(ply)
    return CityMod.Rank:IsModerator(ply)
end

local hud = {["CHudHealth"] = true, ["CHudBattery"] = true, ["CHudAmmo"] = true, ["CHudSecondaryAmmo"] = true}
function GM:HUDShouldDraw(name)
   if hud[name] then return false end

   return true
end

hook.Add("HUDPaint", "CityModHUD", function()

    local client = LocalPlayer()

    if (client.Initialized) then

        --if not client:Alive() then
        --    return
        --end

        local nicewhite = Color(237,230,230,255)

        draw.RoundedBoxEx(6, 0, ScrH() - 100, 200, 100, Color(30, 30, 30, 215),false,true,false,false)

        --surface.SetDrawColor(255,255,255)
        --surface.SetTexture(surface.GetTextureID("gui/sniper_corner"))
        --surface.DrawTexturedRect(25 + 10,ScrH() - 140,16,16)

        draw.SimpleText(string.Comma(LocalPlayer().Money), "DermaDefaultBold", 10, ScrH() - 90, Color(255,255,255,255), 0, 0)

        draw.RoundedBox(0, 10, ScrH() - 65, 100 * 1.75, 15, Color(0, 0, 255, 30))
        draw.RoundedBox(0, 10, ScrH() - 65, math.Clamp(client:Health(), 0, 100) * 1.75, 15, Color(34, 139, 34, 255))
        draw.SimpleText(client:Health(), "DermaDefaultBold", 85, ScrH() - 64, nicewhite, 0, 0)

        draw.RoundedBox(0, 10, ScrH() - 45, 100 * 1.75, 15, Color(0, 0, 255, 30))
        draw.RoundedBox(0, 10, ScrH() - 45, math.Clamp(client:Health(), 0, 100) * 1.75, 15, Color(70, 130, 180, 255))
        draw.SimpleText(client:Health(), "DermaDefaultBold", 85, ScrH() - 44, nicewhite, 0, 0)

        draw.RoundedBox(0, 10, ScrH() - 25, 100 * 1.75, 15, Color(255, 0, 0, 30))
        draw.RoundedBox(0, 10, ScrH() - 25, math.Clamp(client:Health(), 0, 100) * 1.75, 15, Color(214, 34, 34, 255))
        draw.SimpleText(client:Health(), "DermaDefaultBold", 85, ScrH() - 24, nicewhite, 0, 0)
        --draw.RoundedBox(0, 10, ScrH() - 75, math.Clamp(client:Health(), 0, 100) * 2.25, 5, Color(255, 30, 30, 255)) 201, 38, 38, 255

        --[[draw.SimpleText("Armor: "..client:Armor().."%", "DermaDefaultBold", 10, ScrH() - 45, Color(255, 255, 255, 255), 0, 0)
        draw.RoundedBox(0, 10, ScrH() - 30, 100 * 2.25, 15, Color(0, 0, 255, 30))
        draw.RoundedBox(0, 10, ScrH() - 30, math.Clamp(client:Armor(), 0, 100) * 2.25, 15, Color(0, 0, 255, 255))
        draw.RoundedBox(0, 10, ScrH() - 30, math.Clamp(client:Armor(), 0, 100) * 2.25, 5, Color(15, 15, 255, 255))]]
        
        --draw.RoundedBox(0, 255, ScrH() - 100, 125, 25, Color(30, 30, 30, 230))
        --ddraw.SimpleText("$ " .. client.Money, "DermaDefaultBold", 260, ScrH() - 95, Color(255, 255, 255, 255), 0)

        -- Check whether the player has a weapon on them
        if (client:GetActiveWeapon():IsValid()) then

            --if (client:GetActiveWeapon():GetPrintName() ~= nil) then
            --    draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "DermaDefaultBold", 260, ScrH() - 60, Color(255, 255, 255, 255), 0, 0)
            --end

            if (client:GetActiveWeapon() and client:GetActiveWeapon():Clip1() ~= -1) then
                draw.RoundedBox(0, 202.5, ScrH() - 35, 125, 70, Color(30, 30, 30, 230))
                draw.RoundedBox(0, 210, ScrH() - 25, 107, 15, Color(255, 140, 0, 30))
                draw.RoundedBox(0, 210, ScrH() - 25, 107 - (107/client:GetActiveWeapon():GetMaxClip1())*(client:GetActiveWeapon():GetMaxClip1()-client:GetActiveWeapon():Clip1()), 15, Color(255, 120, 0, 255))
                draw.SimpleText(client:GetActiveWeapon():Clip1() .. "/" .. client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "DermaDefaultBold", 245, ScrH() - 25, Color(255, 255, 255, 255), 0, 0)
            else
                --draw.SimpleText("Ammo: " .. client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "DermaDefaultBold", 260, ScrH() - 40, Color(255, 255, 255, 255), 0, 0)
            end

            if (client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType()) > 0) then
                draw.SimpleText("Secondary: " .. client:GetAmmoCount(client:GetActiveWeapon():GetSecondaryAmmoType()), "DermaDefaultBold", 260, ScrH() - 25, Color(255, 255, 255, 255), 0, 0)
            end
        end
    end
end)

local gameMenu = nil
-- Called when a player presses a bind on the server-side
function CityMod:PlayerBindPress(ply,bind,pressed)

    if (not LocalPlayer().Initialized) then
        return true
    end

    if (bind == "gm_showhelp") then -- F1
        if (pressed) then
            --RunString(file.Read("gamemodes/citymod/gameMenu.lua", true))
        end
        return true
    end

    if (bind == "gm_showteam") then -- F2
        if (pressed) then
            print("Pressed F2")
        end
        return true
    end

    if (bind == "gm_showspare1") then -- F3
        if (pressed) then
            print("Pressed F3")
        end
        return true
    end

    if (bind == "gm_showspare2") then -- F4
        if (pressed) then
            if (gameMenu ~= nil) then
                gameMenu.Frame:Show()
            else
                gameMenu = vgui.Create("CityModSampleMenu")
            end
        end
        return true
    end
end

function CityMod:HUDDrawTargetID()
end