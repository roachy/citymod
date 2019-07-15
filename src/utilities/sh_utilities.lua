CityMod.Utilities = {}

function CityMod.Utilities:StringTimeToMins(str)
    str = str:gsub( " ", "" )
    local minutes = 0
    local keycode_location = str:find( "%a" )
    while keycode_location do
        local keycode = str:sub( keycode_location, keycode_location )
        local num = tonumber( str:sub( 1, keycode_location - 1 ) )
        if not num then
            return nil
        end

        local multiplier
        if keycode == "h" then
            multiplier = 60
        elseif keycode == "d" then
            multiplier = 60 * 24
        elseif keycode == "w" then
            multiplier = 60 * 24 * 7
        elseif keycode == "m" then
            multiplier = 60 * 24 * 30
        elseif keycode == "y" then
            multiplier = 60 * 24 * 365
        else
            return nil
        end

        str = str:sub( keycode_location + 1 )
        keycode_location = str:find( "%a" )
        minutes = minutes + num * multiplier
    end

    local num = 0
    if str ~= "" then
        num = tonumber( str )
    end

    if num == nil then
        return nil
    end

    return minutes + num
end

function CityMod.Utilities:MinsToString(time)
    if(!time or type(time) != "number") then
        return "Invalid Number"
    end

    if(time == 0) then
        return "permanent"
    end
    
    if(time < 60) then
        showmins = true
    end
    
    local mins = math.floor(time)
    local hours = math.floor(mins / 60)
    local days = math.floor(hours / 24)
    local minstorem = hours * 60
    local minsrem = mins - minstorem
    local hourstorem = days * 24
    local hoursrem = hours - hourstorem
    local timestring = ""
    if(days > 0) then timestring = days.." day"
        if(days > 1) then timestring = timestring.."s" end
        if(minsrem > 0 and showmins and hoursrem > 0) then timestring = timestring..", " 
        elseif((minsrem > 0 and showmins) or hoursrem > 0) then timestring = timestring.." and " end
    end
    if(hoursrem > 0) then timestring = timestring..hoursrem.." hour"
        if(hoursrem > 1) then timestring = timestring.."s" end
        if(minsrem > 0 and showmins) then timestring = timestring.." and " end
    end
    if(minsrem > 0 and showmins) then timestring = timestring..minsrem.." minute" end
    if(minsrem > 1 and showmins) then timestring = timestring.."s" end
    return (timestring)
end