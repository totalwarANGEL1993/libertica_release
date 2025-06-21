Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/CutsceneSystem_API");

function NewCutscene(_Name, _PlayerID, _Cutscene)
    assert(GUI == nil);
    _Cutscene = _Cutscene or {};
    assert(type(_Cutscene) == "table");

    _Cutscene.Name = _Name;
    _Cutscene.PlayerID = _PlayerID;
    Lib.CutsceneSystem.Global:ExpandCutsceneTable(_Cutscene);

    local AP = function(_Page)
        local Page, Camera, MC;
        if type(_Page) == "table" then
            -- Page
            Page = _Cutscene:BeginFlight()

            -- Properties
                :UseSkipping(_Page.DisableSkipping ~= true)
                :SetBarOpacity(_Page.BarOpacity)
                :SetFlight(_Page.Flight)
                :SetFarClipPlane(_Page.FarClipPlane)
                :SetTitle(_Page.Title)
                :SetText(_Page.Text)
                :SetSpeech(_Page._Speech)
                :SetFadeIn(_Page.FadeIn)
                :SetFadeOut(_Page.FadeOut)
                :SetFaderAlpha(_Page.FaderAlpha)
                :SetAction(_Page.Action);
                if _Page.BigBars then
                    Page:UseBigBars(_Page.BigBars);
                end
            -- /Properties

            -- /Page
            Page:EndFlight();
        else
            _Cutscene:Redirect(_Page)
            Page = _Page or -1;
        end
        return Page;
    end
    _Cutscene.AP = AP;
    return _Cutscene;
end
API.NewCutscene = NewCutscene;

function AddCutscenePages(_Cutscene)
    local Cutscene = NewCutscene(nil, nil, _Cutscene);
    return Cutscene.AP;
end
API.AddFlights = AddCutscenePages;
API.AddCutscenePages = AddCutscenePages;

function RequestCutsceneAlternateGraphics()
    if not GUI then
        ExecuteLocal("RequestCutsceneAlternateGraphics()");
        return;
    end
    Lib.BriefingSystem.Local:RequestAlternateGraphics();
end
API.RequestCutsceneAlternateGraphics = RequestCutsceneAlternateGraphics;

function IsCutsceneActive(_PlayerID)
    if not IsLocalScript() then
        return Lib.CutsceneSystem.Global:GetCurrentCutscene(_PlayerID) ~= nil;
    end
    return Lib.CutsceneSystem.Local:GetCurrentCutscene(_PlayerID) ~= nil;
end
API.IsCutsceneActive = IsCutsceneActive;

function StartCutscene(_Cutscene, _Name, _PlayerID)
    if GUI then
        return;
    end
    local PlayerID = _PlayerID;
    if not PlayerID and not Framework.IsNetworkGame() then
        PlayerID = 1; -- Human Player
    end
    assert(_Name ~= nil);
    assert(_PlayerID ~= nil);
    assert(type(_Cutscene) == "table", "Cutscene must be a table!");
    assert(#_Cutscene > 0, "Cutscene does not contain pages!");
    for i=1, #_Cutscene do
        assert(
            type(_Cutscene[i]) ~= "table" or _Cutscene[i].__Legit,
            "A page is not initialized!"
        );
    end
    if _Cutscene.EnableSky == nil then
        _Cutscene.EnableSky = true;
    end
    if _Cutscene.EnableFoW == nil then
        _Cutscene.EnableFoW = false;
    end
    if _Cutscene.HideNotes == nil then
        _Cutscene.HideNotes = false;
    end
    if _Cutscene.EnableGlobalImmortality == nil then
        _Cutscene.EnableGlobalImmortality = true;
    end
    if _Cutscene.EnableBorderPins == nil then
        _Cutscene.EnableBorderPins = false;
    end
    Lib.CutsceneSystem.Global:StartCutscene(_Name, PlayerID, _Cutscene);
end
API.CutsceneStart = StartCutscene;
API.StartCutscene = StartCutscene;

function AP(_Data)
    assert(false);
end

