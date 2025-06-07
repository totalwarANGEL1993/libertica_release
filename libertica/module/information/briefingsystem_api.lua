Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/BriefingSystem_API");

function NewBriefing(_Name, _PlayerID, _Briefing)
    assert(GUI == nil);
    _Briefing = _Briefing or {};
    assert(type(_Briefing) == "table");

    _Briefing.Name = _Name;
    _Briefing.PlayerID = _PlayerID;
    Lib.BriefingSystem.Global:ExpandBriefingTable(_Briefing);

    local AP = function(_Page)
        local Page, Camera, MC;
        if type(_Page) == "table" then
            -- Page
            Page = _Briefing:BeginPage()

            -- Properties
                :UseSkipping(_Page.DisableSkipping ~= true)
                :SetName(_Page.Name)
                :SetSpeech(_Page.Speech)
                :SetTitle(_Page.Title)
                :SetText(_Page.Text)
                :SetDuration(_Page.Duration)
                :SetFadeIn(_Page.FadeIn)
                :SetFadeOut(_Page.FadeOut)
                :SetFaderAlpha(_Page.FaderAlpha)
                :SetAction(_Page.Action);
                if _Page.BigBars then
                    Page:UseBigBars(_Page.BigBars);
                end
            -- /Properties

            -- MC
            if _Page.MC then
                MC = Page:BeginChoice();
                for i= 1, #_Page.MC do
                    local Option = Array_Append({}, _Page.MC[i]);
                    if _Page.MC[i].ID then
                        table.insert(Option, 1, _Page.MC[i].ID);
                    end
                    MC:Option(unpack(Option));
                end
            -- /MC
                MC:EndChoice();
            end

            -- Camera
            if _Page.Position then
                Camera = Page:BeginCamera()
                    :SetPosition(_Page.Position)
                    :UseCloseUp(_Page.DialogCamera)
                    :SetAngle(_Page.Angle)
                    :SetZoom(_Page.Zoom)
                    :SetRotation(_Page.Rotation);

                -- Camera.FlyTo
                if _Page.FlyTo then
                    Camera:BeginFlyTo()
                        :SetPosition(_Page.FlyTo.Position)
                        :SetAngle(_Page.FlyTo.Angle)
                        :SetZoom(_Page.FlyTo.Zoom)
                        :SetRotation(_Page.FlyTo.Rotation)
                    -- /Camera.FlyTo
                    :EndFlyTo();
                end
            -- /Camera
                Camera:EndCamera();
            end

            -- /Page
            Page:EndPage();
        else
            _Briefing:Redirect(_Page)
            Page = _Page or -1;
        end
        return Page;
    end

    local ASP = function(...)
        _Briefing.PageAnimation = _Briefing.PageAnimation or {};

        local Name, Title,Text, Position;
        local DialogCam = false;
        local Action = function() end;

        -- Set page parameters
        if (#arg == 3 and type(arg[1]) == "string")
        or (#arg >= 4 and type(arg[4]) == "boolean") then
            Name = table.remove(arg, 1);
        end
        Title = table.remove(arg, 1);
        Text = table.remove(arg, 1);
        if #arg > 0 then
            DialogCam = table.remove(arg, 1) == true;
        end
        if #arg > 0 then
            Position = table.remove(arg, 1);
        end
        if #arg > 0 then
            Action = table.remove(arg, 1);
        end

        -- Calculate camera rotation
        local Rotation;
        if Position then
            Rotation = CONST_BRIEFING.CAMERA_ROTATIONDEFAULT;
            if Position and Logic.IsSettler(GetID(Position)) == 1 then
                Rotation = Logic.GetEntityOrientation(GetID(Position)) + 90;
            end
        end

        -- Create page
        return AP {
            Name            = Name,
            Title           = Title,
            Text            = Text,
            Action          = Action,
            Position        = Position,
            Duration        = -1,
            DialogCamera    = DialogCam,
            Rotation        = Rotation,
        };
    end

    _Briefing.AP = AP;
    _Briefing.ASP = ASP;
    return _Briefing;
end
API.NewBriefing = NewBriefing;

function AddBriefingPages(_Briefing)
    local Briefing = NewBriefing(nil, nil, _Briefing);
    return Briefing.AP, Briefing.ASP;
end
API.AddBriefingPages = AddBriefingPages;

function IsBriefingActive(_PlayerID)
    if not IsLocalScript() then
        return Lib.BriefingSystem.Global:GetCurrentBriefing(_PlayerID) ~= nil;
    end
    return Lib.BriefingSystem.Local:GetCurrentBriefing(_PlayerID) ~= nil;
end
API.IsBriefingActive = IsBriefingActive;

function StartBriefing(_Briefing, _Name, _PlayerID)
    assert(GUI == nil);
    assert(_Name ~= nil);
    assert(_PlayerID ~= nil);
    assert(type(_Briefing) == "table", "Briefing must be a table!");
    assert(#_Briefing > 0, "Briefing does not contain pages!");
    for i=1, #_Briefing do
        assert(
            type(_Briefing[i]) ~= "table" or _Briefing[i].__Legit,
            "A page is not initalized!"
        );
    end
    if _Briefing.EnableSky == nil then
        _Briefing.EnableSky = true;
    end
    if _Briefing.EnableFoW == nil then
        _Briefing.EnableFoW = false;
    end
    if _Briefing.HideNotes == nil then
        _Briefing.HideNotes = false;
    end
    if _Briefing.EnableGlobalImmortality == nil then
        _Briefing.EnableGlobalImmortality = true;
    end
    if _Briefing.EnableBorderPins == nil then
        _Briefing.EnableBorderPins = false;
    end
    if _Briefing.RestoreGameSpeed == nil then
        _Briefing.RestoreGameSpeed = true;
    end
    if _Briefing.RestoreCamera == nil then
        _Briefing.RestoreCamera = true;
    end
    Lib.BriefingSystem.Global:StartBriefing(_Name, _PlayerID, _Briefing);
end
API.StartBriefing = StartBriefing;

function AP(_Data)
    assert(false);
end

function ASP(...)
    assert(false);
end

