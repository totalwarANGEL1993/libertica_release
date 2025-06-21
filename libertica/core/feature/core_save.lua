Lib.Core = Lib.Core or {};
Lib.Core.Save = {
    AutoSaveDisabled = true,
    SavingDisabled = false,
    LoadingDisabled = false,
};

Lib.Require("core/feature/Core_Report");
Lib.Require("core/feature/Core_Job");
Lib.Register("core/feature/Core_Save");

-- -------------------------------------------------------------------------- --

function DisableAutoSave(_Flag)
    if not IsLocalScript() then
        Lib.Core.Save.AutoSaveDisabled = _Flag == true;
        ExecuteLocal([[Lib.Core.Save.AutoSaveDisabled = %s]], tostring(_Flag == true))
    end
end
API.DisableAutomaticQuickSave = DisableAutoSave;
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
            if Lib.Core.Save.AutoSaveDisabled and not arg[1] then
                return;
            end
            -- Do quicksave
            KeyBindings_SaveGame_Orig_Core();
        end

        -- Unofficial patch: disable autosave
        GameCallback_Option_CanAutoSave = function()
            return Lib.Core.Save.AutoSaveDisabled ~= true;
        end
    end
end

function Lib.Core.Save:DisableSaving(_Flag)
    local Flag = _Flag == true;
    if not Framework.IsNetworkGame() then
        self.SavingDisabled = Flag;
        if not IsLocalScript() then
            ExecuteLocal([[Lib.Core.Save:DisableSaving(%s)]], tostring(Flag));
        else
            ExecuteGlobal([[Lib.Core.Save.SavingDisabled = %s]], tostring(Flag));
            self:UpdateSaveButtons();
        end
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
    local Flag = _Flag == true;
    if not Framework.IsNetworkGame() then
        self.LoadingDisabled = Flag;
        if not IsLocalScript() then
            ExecuteLocal([[Lib.Core.Save:DisableLoading(%s)]],tostring(_Flag));
        else
            ExecuteGlobal([[Lib.Core.Save.LoadingDisabled = %s]],tostring(_Flag));
            self:UpdateLoadButtons();
        end
    end
end

function Lib.Core.Save:UpdateLoadButtons()
    if IsLocalScript() then
        local VisibleFlag = (self.LoadingDisabled and 0) or 1;
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/LoadGame", VisibleFlag);
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/QuickLoad", VisibleFlag);
    end
end

