local PANEL = {}

function PANEL:Init()
    local jobs = {}

    for k,v in pairs(CityMod.Job.GetAll()) do

        -- Create the job category if it does not exist
        if (jobs[v.Category] == nil) then

            jobs[v.Category] = {}

            jobs[v.Category] = self:Add(v.Category)

            local collapsibleCategory = jobs[v.Category]

            collapsibleCategory.IconLayout = vgui.Create("DIconLayout", collapsibleCategory)
            collapsibleCategory.IconLayout:Dock(FILL)
            collapsibleCategory.IconLayout:SetSpaceY(5)
            collapsibleCategory.IconLayout:SetSpaceX(5)
            collapsibleCategory:SetContents(collapsibleCategory.IconLayout)

        end

        local ListItem = jobs[v.Category].IconLayout:Add("DPanel")
        ListItem:SetSize(80, 40)

        local SpawnI = vgui.Create( "SpawnIcon" , ListItem )
        SpawnI:SetSize(80,40)

        -- Get a random job model, and set it accordingly
        local randomJobModel = v.Models[math.random(#v.Models)]
        SpawnI:SetModel(randomJobModel)
        SpawnI.DoClick = function()
            net.Start("ChangeJob")
                net.WriteString(k)
            net.SendToServer()
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