Lib.Core = Lib.Core or {};
Lib.Core.Save = {
    HistoryEditionQuickSave = false,
    SavingDisabled = false,
    LoadingDisabled = false,
};

Lib.Require("core/feature/Core_Report");
Lib.Require("core/feature/Core_Job");
Lib.Register("core/feature/Core_Save");

-- -------------------------------------------------------------------------- --

function DisableAutoSave(_Flag)
    if not IsLocalScript() then
        Lib.Core.Save.HistoryEditionQuickSave = _Flag == true;
        ExecuteLocal([[Lib.Core.Save.HistoryEditionQuickSave = %s]], tostring(_Flag == true))
    end
end
API.DisableAutoSave = DisableAutoSave;

function DisableSaving(_Flag)
    Lib.Core.Save:DisableSaving(_Flag);
end
API.DisableSaving = DisableSaving;

function DisableLoading(_Flag)
    Lib.Core.Save:DisableLoading(_Flag);
end
API.DisableLoading = DisableLoading;

-- -------------------------------------------------------------------------- --

function Lib.Core.Save:Initialize()
    Report.SaveGameLoaded = CreateReport("Event_SaveGameLoaded");

    self:SetupQuicksaveKeyCallback();
    self:SetupQuicksaveKeyTrigger();
end

function Lib.Core.Save:OnSaveGameLoaded()
    self:SetupQuicksaveKeyTrigger();
    self:UpdateLoadButtons();
    self:UpdateSaveButtons();

    SendReport(Report.SaveGameLoaded);
end

function Lib.Core.Save:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Save:SetupQuicksaveKeyTrigger()
    if IsLocalScript() then
        RequestHiResJob(
            function()
                Input.KeyBindDown(
                    Keys.ModifierControl + Keys.S,
                    "KeyBindings_SaveGame(true)",
                    2,
                    false
                );
                return true;
            end
        );
    end
end

function Lib.Core.Save:SetupQuicksaveKeyCallback()
    if IsLocalScript() then
        KeyBindings_SaveGame_Orig_Core = KeyBindings_SaveGame;
        KeyBindings_SaveGame = function(...)
            -- No quicksave if saving disabled
            if Lib.Core.Save.SavingDisabled then
                return;
            end
            -- No quicksave if forced by History Edition
            if not Lib.Core.Save.HistoryEditionQuickSave and not arg[1] then
                return;
            end
            -- Do quicksave
            KeyBindings_SaveGame_Orig_Core();
        end
    end
end

function Lib.Core.Save:DisableSaving(_Flag)
    self.SavingDisabled = _Flag == true;
    if not IsLocalScript() then
        ExecuteLocal([[Lib.Core.Save:DisableSaving(%s)]],tostring(_Flag));
    else
        self:UpdateSaveButtons();
    end
end

function Lib.Core.Save:UpdateSaveButtons()
    if IsLocalScript() then
        local VisibleFlag = (self.SavingDisabled and 0) or 1;
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/QuickSave", VisibleFlag);
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/SaveGame", VisibleFlag);
    end
end

function Lib.Core.Save:DisableLoading(_Flag)
    self.LoadingDisabled = _Flag == true;
    if not IsLocalScript() then
        ExecuteLocal([[Lib.Core.Save:DisableLoading(%s)]],tostring(_Flag));
    else
        self:UpdateLoadButtons();
    end
end

function Lib.Core.Save:UpdateLoadButtons()
    if IsLocalScript() then
        local VisibleFlag = (self.LoadingDisabled and 0) or 1;
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/LoadGame", VisibleFlag);
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/QuickLoad", VisibleFlag);
    end
end

