local PANEL = {}

function PANEL:Init()
    local jobs = {}

    for k,v in pairs(CityMod.Job.GetAll()) do

        -- Create the job category if it does not exist
        if (jobs[v.Category] == nil) then

            print(k)

            jobs[v.Category] = {}

            jobs[v.Category].Cat = self:Add(v.Category)

            local cat = jobs[v.Category].Cat

            cat.A = vgui.Create("DIconLayout", cat)
            cat.A:Dock(FILL)
            cat.A:SetSpaceY(5)
            cat.A:SetSpaceX(5)
            cat:SetContents(cat.A)

            for i = 1, 20 do
                local ListItem = cat.A:Add("DPanel")
                ListItem:SetSize(80, 40)

                local SpawnI = vgui.Create( "SpawnIcon" , ListItem )

                -- Get Set it to a random spawn icon
                local randomJobModel = v.Models[math.random(#v.Models)]
                SpawnI:SetModel(randomJobModel)
            end
        end

        -- Add the job to the specified category here
        jobs[v.Category] = k
    end

    --[[local Cat = 
    Cat:Add( "Item 1" )
    local button = Cat:Add( "Item 2" )
    button.DoClick = function()
        print( "Item 2 was clicked." )
    end
    
    local Cat2 = self:Add( "Default" )
    Cat2:SetTall( 100 )
    
    local Contents = vgui.Create( "DButton" )
    Contents:SetText( "This is the content")
    Cat2:SetContents( Contents )

    -- The contents can be any panel, even a DPanelList
    local Cat3 = self:Add("Government")
    Cat3:SetTall( 100 )]]
end

vgui.Register("CityModJobs", PANEL, "DCategoryList")