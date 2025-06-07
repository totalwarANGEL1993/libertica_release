Lib.UIEffects = Lib.UIEffects or {};
Lib.UIEffects.Name = "UIEffects";
Lib.UIEffects.Global = {};
Lib.UIEffects.Local = {
    ChatOptionsWasShown = false,
    MessageLogWasShown = false,
    PauseScreenShown = false,
    NormalModeHidden = false,
};

Lib.Require("core/Core");
Lib.Require("module/settings/Camera");
Lib.Require("module/ui/UIEffects_API");
Lib.Register("module/ui/UIEffects");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.UIEffects.Global:Initialize()
    if not self.IsInstalled then
        Report.GameInterfaceShown = CreateReport("Event_GameInterfaceShown");
        Report.GameInterfaceHidden = CreateReport("Event_GameInterfaceHidden");
        Report.ImageScreenShown = CreateReport("Event_ImageScreenShown");
        Report.ImageScreenHidden = CreateReport("Event_ImageScreenHidden");

        -- Garbage collection
        Lib.UIEffects.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.UIEffects.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.UIEffects.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.UIEffects.Local:Initialize()
    if not self.IsInstalled then
        -- public reports
        Report.GameInterfaceShown = CreateReport("Event_GameInterfaceShown");
        Report.GameInterfaceHidden = CreateReport("Event_GameInterfaceHidden");
        Report.ImageScreenShown = CreateReport("Event_ImageScreenShown");

        -- internal reports
        Report.ImageScreenHidden = CreateReport("Event_ImageScreenHidden");

        -- Garbage collection
        Lib.UIEffects.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.UIEffects.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.UIEffects.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.UIEffects.Local:InterfaceActivateImageBackground(_PlayerID, _Graphic, _R, _G, _B, _A)
    if _PlayerID ~= GUI.GetPlayerID() or self.PauseScreenShown then
        return;
    end

    XGUIEng.PushPage("/InGame/Root/Normal/PauseScreen", false);
    XGUIEng.ShowWidget("/InGame/Root/Normal/PauseScreen", 1);
    if _Graphic and _Graphic ~= "" then
        local Size = {GUI.GetScreenSize()};
        local u0, v0, u1, v1 = 0, 0, 1, 1;
        if Size[1]/Size[2] < 1.6 then
            u0 = u0 + (u0 / 0.125);
            u1 = u1 - (u1 * 0.125);
        end
        XGUIEng.SetMaterialTexture("/InGame/Root/Normal/PauseScreen", 0, _Graphic);
        XGUIEng.SetMaterialUV("/InGame/Root/Normal/PauseScreen", 0, u0, v0, u1, v1);
    end
    XGUIEng.SetMaterialColor("/InGame/Root/Normal/PauseScreen", 0, _R, _G, _B, _A);
    SendReportToGlobal(Report.ImageScreenShown, _PlayerID);
    SendReport(Report.ImageScreenShown, _PlayerID);
    self.PauseScreenShown = true;
end

function Lib.UIEffects.Local:InterfaceDeactivateImageBackground(_PlayerID)
    if _PlayerID ~= GUI.GetPlayerID() or not self.PauseScreenShown then
        return;
    end

    XGUIEng.ShowWidget("/InGame/Root/Normal/PauseScreen", 0);
    XGUIEng.SetMaterialTexture("/InGame/Root/Normal/PauseScreen", 0, "");
    XGUIEng.SetMaterialColor("/InGame/Root/Normal/PauseScreen", 0, 40, 40, 40, 180);
    XGUIEng.PopPage();
    SendReportToGlobal(Report.ImageScreenHidden, _PlayerID);
    SendReport(Report.ImageScreenHidden, _PlayerID);
    self.PauseScreenShown = false;
end

function Lib.UIEffects.Local:InterfaceDeactivateNormalInterface(_PlayerID)
    if GUI.GetPlayerID() ~= _PlayerID or self.NormalModeHidden then
        return;
    end

    XGUIEng.PushPage("/InGame/Root/Normal/NotesWindow", false);
    XGUIEng.ShowWidget("/InGame/Root/3dOnScreenDisplay", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/TextMessages", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopRight", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/TopBar", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/TopBar/UpdateFunction", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestLogButton", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestTimers", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Merchant", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 0);
    HideOtherMenus();
    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/AlignTopLeft/GameClock") == 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 0);
        self.GameClockWasShown = true;
    end
    if XGUIEng.IsWidgetShownEx("/InGame/Root/Normal/ChatOptions/Background") == 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions", 0);
        self.ChatOptionsWasShown = true;
    end
    if XGUIEng.IsWidgetShownEx("/InGame/Root/Normal/MessageLog/Name") == 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog", 0);
        self.MessageLogWasShown = true;
    end
    if g_GameExtraNo > 0 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Tradepost", 0);
    end

    SendReportToGlobal(Report.GameInterfaceHidden, GUI.GetPlayerID());
    SendReport(Report.GameInterfaceHidden, GUI.GetPlayerID());
    self.NormalModeHidden = true;
end

function Lib.UIEffects.Local:InterfaceActivateNormalInterface(_PlayerID)
    if GUI.GetPlayerID() ~= _PlayerID or not self.NormalModeHidden then
        return;
    end

    XGUIEng.ShowWidget("/InGame/Root/Normal", 1);
    XGUIEng.ShowWidget("/InGame/Root/3dOnScreenDisplay", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopRight", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/TopBar", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/TextMessages", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/TopBar/UpdateFunction", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/Buttons", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestLogButton", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/QuestTimers", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Merchant", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message", 1);
    XGUIEng.PopPage();

    -- Timer
    if g_MissionTimerEndTime then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 1);
    end
    -- Counter
    if g_MissionGoodOrEntityCounterAmountToReach then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 1);
    end
    -- Debug Clock
    if self.GameClockWasShown then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 1);
        self.GameClockWasShown = false;
    end
    -- Chat Options
    if self.ChatOptionsWasShown then
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions", 1);
        self.ChatOptionsWasShown = false;
    end
    -- Message Log
    if self.MessageLogWasShown then
        XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog", 1);
        self.MessageLogWasShown = false;
    end
    -- Handelsposten
    if g_GameExtraNo > 0 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Tradepost", 1);
    end

    SendReportToGlobal(Report.GameInterfaceShown, GUI.GetPlayerID());
    SendReport(Report.GameInterfaceShown, GUI.GetPlayerID());
    self.NormalModeHidden = false;
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.UIEffects.Name);

