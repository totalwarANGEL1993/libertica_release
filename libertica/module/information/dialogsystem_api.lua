Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/DialogSystem_API");

function StartDialog(_Dialog, _Name, _PlayerID)
    if GUI then
        return;
    end
    local PlayerID = _PlayerID;
    if not PlayerID and not Framework.IsNetworkGame() then
        PlayerID = 1; -- Human player?
    end
    assert(_Name ~= nil);
    assert(_PlayerID ~= nil);
    assert(type(_Dialog) == "table", "Dialog must be a table!");
    assert(#_Dialog > 0, "Dialog does not contain pages!");
    for i=1, #_Dialog do
        assert(
            type(_Dialog[i]) ~= "table" or _Dialog[i].__Legit,
            "Page is not initialized!"
        );
    end
    if _Dialog.EnableSky == nil then
        _Dialog.EnableSky = true;
    end
    if _Dialog.EnableFoW == nil then
        _Dialog.EnableFoW = false;
    end
    if _Dialog.EnableGlobalImmortality == nil then
        _Dialog.EnableGlobalImmortality = true;
    end
    if _Dialog.EnableBorderPins == nil then
        _Dialog.EnableBorderPins = false;
    end
    if _Dialog.RestoreGameSpeed == nil then
        _Dialog.RestoreGameSpeed = true;
    end
    if _Dialog.RestoreCamera == nil then
        _Dialog.RestoreCamera = true;
    end
    Lib.DialogSystem.Global:StartDialog(_Name, PlayerID, _Dialog);
end
API.StartDialog = StartDialog;

function RequestDialogAlternateGraphics()
    if not GUI then
        ExecuteLocal("RequestDialogAlternateGraphics()");
        return;
    end
    Lib.DialogSystem.Local:RequestAlternateGraphics();
end
API.RequestDialogAlternateGraphics = RequestDialogAlternateGraphics;

function IsDialogActive(_PlayerID)
    if not IsLocalScript() then
        return Lib.DialogSystem.Global:GetCurrentDialog(_PlayerID) ~= nil;
    end
    return Lib.DialogSystem.Local:GetCurrentDialog(_PlayerID) ~= nil;
end
API.IsDialogActive = IsDialogActive;

function AddDialogPages(_Dialog)
    Lib.DialogSystem.Global:CreateDialogGetPage(_Dialog);
    Lib.DialogSystem.Global:CreateDialogAddPage(_Dialog);
    Lib.DialogSystem.Global:CreateDialogAddMCPage(_Dialog);
    Lib.DialogSystem.Global:CreateDialogAddRedirect(_Dialog);

    local AP = function(_Page)
        local Page;
        if type(_Page) == "table" then
            if _Page.MC then
                Page = _Dialog:AddMCPage(_Page);
            else
                Page = _Dialog:AddPage(_Page);
            end
        else
            Page = _Dialog:AddRedirect(_Page);
        end
        return Page;
    end

    local ASP = function(...)
        if type(arg[1]) ~= "number" then
            Name = table.remove(arg, 1);
        end
        local Sender   = table.remove(arg, 1);
        local Position = table.remove(arg, 1);
        local Title    = table.remove(arg, 1);
        local Text     = table.remove(arg, 1);
        local Dialog   = table.remove(arg, 1);
        local Action;
        if type(arg[1]) == "function" then
            Action = table.remove(arg, 1);
        end
        return _Dialog:AddPage{
            Name         = Name,
            Title        = Title,
            Text         = Text,
            Actor        = Sender,
            Target       = Position,
            DialogCamera = Dialog == true,
            Action       = Action,
        };
    end
    return AP, ASP;
end
API.AddDialogPages = AddDialogPages;

function AP(_Data)
    assert(false);
end

function ASP(...)
    assert(false);
end

