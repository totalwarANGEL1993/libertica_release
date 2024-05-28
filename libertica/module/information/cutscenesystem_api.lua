Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/CutsceneSystem_API");

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
    if _Cutscene.EnableGlobalImmortality == nil then
        _Cutscene.EnableGlobalImmortality = true;
    end
    if _Cutscene.EnableBorderPins == nil then
        _Cutscene.EnableBorderPins = false;
    end
    Lib.CutsceneSystem.Global:StartCutscene(_Name, PlayerID, _Cutscene);
end
API.StartCutscene = StartCutscene;

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

function AddCutscenePages(_Cutscene)
    Lib.CutsceneSystem.Global:CreateCutsceneGetPage(_Cutscene);
    Lib.CutsceneSystem.Global:CreateCutsceneAddPage(_Cutscene);

    local AP = function(_Page)
        return _Cutscene:AddPage(_Page);
    end
    return AP;
end
API.AddCutscenePages = AddCutscenePages;

function AP(_Data)
    assert(false);
end

