Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/BriefingSystem_API");

function StartBriefing(_Briefing, _Name, _PlayerID)
    if GUI then
        return;
    end
    local PlayerID = _PlayerID;
    if not PlayerID and not Framework.IsNetworkGame() then
        PlayerID = 1; -- Human Player
    end
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
    Lib.BriefingSystem.Global:StartBriefing(_Name, PlayerID, _Briefing);
end
API.StartBriefing = StartBriefing;

function RequestBriefingAlternateGraphics()
    if not GUI then
        ExecuteLocal("RequestBriefingAlternateGraphics()");
        return;
    end
    Lib.BriefingSystem.Local:RequestAlternateGraphics();
end
API.RequestBriefingAlternateGraphics = RequestBriefingAlternateGraphics;

function IsBriefingActive(_PlayerID)
    if not IsLocalScript() then
        return Lib.BriefingSystem.Global:GetCurrentBriefing(_PlayerID) ~= nil;
    end
    return Lib.BriefingSystem.Local:GetCurrentBriefing(_PlayerID) ~= nil;
end
API.IsBriefingActive = IsBriefingActive;

function GetFramePosition(_Entity, _ZOffset)
    local x,y,z = Logic.EntityGetPos(GetID(_Entity));
    return x, y, z + (_ZOffset or 0);
end

function GetFrameVector(_Entity1, _ZOffset1, _Entity2, _ZOffset2)
    local x1,y1,z1 = Logic.EntityGetPos(GetID(_Entity1));
    local x2,y2,z2 = Logic.EntityGetPos(GetID(_Entity2));
    return x1, y1, z1 + (_ZOffset1 or 0), x2, y2, z2 + (_ZOffset2 or 0);
end

function AddBriefingPages(_Briefing)
    Lib.BriefingSystem.Global:CreateBriefingGetPage(_Briefing);
    Lib.BriefingSystem.Global:CreateBriefingAddPage(_Briefing);
    Lib.BriefingSystem.Global:CreateBriefingAddMCPage(_Briefing);
    Lib.BriefingSystem.Global:CreateBriefingAddRedirect(_Briefing);

    local AP = function(_Page)
        local Page;
        if type(_Page) == "table" then
            if _Page.MC then
                Page = _Briefing:AddMCPage(_Page);
            else
                Page = _Briefing:AddPage(_Page);
            end
        else
            Page = _Briefing:AddRedirect(_Page);
        end
        return Page;
    end

    local ASP = function(...)
        _Briefing.PageAnimation = _Briefing.PageAnimation or {};

        local Name, Title,Text, Position;
        local DialogCam = false;
        local Action = function() end;
        local NoSkipping = false;

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
        if #arg > 0 then
            NoSkipping = not table.remove(arg, 1);
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
        return _Briefing:AddPage {
            Name            = Name,
            Title           = Title,
            Text            = Text,
            Action          = Action,
            Position        = Position,
            DisableSkipping = NoSkipping,
            DialogCamera    = DialogCam,
            Rotation        = Rotation,
        };
    end

    return AP, ASP;
end
API.AddBriefingPages = AddBriefingPages;

function AP(_Data)
    assert(false);
end

function ASP(...)
    assert(false);
end

