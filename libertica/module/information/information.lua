Lib.Information = Lib.Information or {};
Lib.Information.Name = "Information";
Lib.Information.CinematicEvents = {};
Lib.Information.Global = {
    CinematicEventID = 0,
    CinematicEventStatus = {},
    CinematicEventQueue = {},
};
Lib.Information.Local = {
    CinematicEventStatus = {},
};

CinematicEventTypes = {};

CinematicEventState = {
    NotTriggered = 0,
    Active = 1,
    Concluded = 2,
};

Lib.Require("comfort/IsMultiplayer");
Lib.Require("core/Core");
Lib.Require("module/ui/UIEffects");
Lib.Require("module/ui/UITools");
Lib.Require("module/settings/Sound");
Lib.Require("module/information/Requester");
Lib.Require("module/information/Information_API");
Lib.Register("module/information/Information");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Information.Global:Initialize()
    if not self.IsInstalled then
        Report.CinematicActivated = CreateReport("Event_CinematicEventActivated");
        Report.CinematicConcluded = CreateReport("Event_CinematicEventConcluded");

        for i= 1, 8 do
            self.CinematicEventStatus[i] = {};
            self.CinematicEventQueue[i] = {};
        end

        -- Garbage collection
        Lib.Information.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Information.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Information.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.CinematicActivated then
        self.CinematicEventStatus[arg[2]][arg[1]] = 1;
        --- @diagnostic disable-next-line: param-type-mismatch
        DeactivateImageScreen(arg[2]);
        --- @diagnostic disable-next-line: param-type-mismatch
        ActivateNormalInterface(arg[2]);
    elseif _ID == Report.CinematicConcluded then
        if self.CinematicEventStatus[arg[2]][arg[1]] then
            self.CinematicEventStatus[arg[2]][arg[1]] = 2;
        end
        if #self.CinematicEventQueue[arg[2]] > 0 then
            --- @diagnostic disable-next-line: param-type-mismatch
            ActivateImageScreen(arg[2], "", 0, 0, 0, 255);
            --- @diagnostic disable-next-line: param-type-mismatch
            DeactivateNormalInterface(arg[2]);
        end
    end
end

function Lib.Information.Global:UpdateQueue()
    for PlayerID = 1, 8 do
        if self:CanStartBriefing(PlayerID) then
            local Next = Lib.Information.Global:LookUpCinematicInQueue(PlayerID);
            if Next and Next[1] == CinematicEventTypes.Briefing then
                self:NextBriefing(PlayerID);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Information.Global:PushCinematicEventToQueue(_PlayerID, _Type, _Name, _Data)
    table.insert(self.CinematicEventQueue[_PlayerID], {_Type, _Name, _Data});
end

function Lib.Information.Global:LookUpCinematicInQueue(_PlayerID)
    if #self.CinematicEventQueue[_PlayerID] > 0 then
        return self.CinematicEventQueue[_PlayerID][1];
    end
end

function Lib.Information.Global:PopCinematicEventFromQueue(_PlayerID)
    if #self.CinematicEventQueue[_PlayerID] > 0 then
        return table.remove(self.CinematicEventQueue[_PlayerID], 1);
    end
end

function Lib.Information.Global:GetNewCinematicEventID()
    self.CinematicEventID = self.CinematicEventID +1;
    return self.CinematicEventID;
end

function Lib.Information.Global:GetCinematicEventStatus(_InfoID)
    for i= 1, 8 do
        if self.CinematicEventStatus[i][_InfoID] then
            return self.CinematicEventStatus[i][_InfoID];
        end
    end
    return 0;
end

function Lib.Information.Global:ActivateCinematicEvent(_PlayerID)
    local ID = self:GetNewCinematicEventID();
    SendReport(Report.CinematicActivated, ID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[SendReport(Report.CinematicActivated, %d, %d);
          if GUI.GetPlayerID() == %d then
            Lib.Information.Local.SavingWasDisabled = Lib.Core.Save.SavingDisabled == true;
            DisableSaving(true);
          end]],
        ID,
        _PlayerID,
        _PlayerID
    ))
    return ID;
end

function Lib.Information.Global:ConcludeCinematicEvent(_ID, _PlayerID)
    SendReport(Report.CinematicConcluded, _ID, _PlayerID);
    ExecuteLocal(
        [[SendReport(Report.CinematicConcluded, %d, %d);
          if GUI.GetPlayerID() == %d then
            if not Lib.Information.Local.SavingWasDisabled then
                DisableSaving(false);
            end
            Lib.Information.Local.SavingWasDisabled = false;
          end]],
        _ID,
        _PlayerID,
        _PlayerID
    );
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Information.Local:Initialize()
    if not self.IsInstalled then
        Report.CinematicActivated = CreateReport("Event_CinematicEventActivated");
        Report.CinematicConcluded = CreateReport("Event_CinematicEventConcluded");

        for i= 1, 8 do
            self.CinematicEventStatus[i] = {};
        end
        self:OverrideInterfaceUpdateForCinematicMode();
        self:OverrideInterfaceThroneroomForCinematicMode();

        -- Garbage collection
        Lib.Information.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Information.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.Information.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.CinematicActivated then
        self.CinematicEventStatus[arg[2]][arg[1]] = 1;
    elseif _ID == Report.CinematicConcluded then
        for i= 1, 8 do
            if self.CinematicEventStatus[i][arg[1]] then
                self.CinematicEventStatus[i][arg[1]] = 2;
            end
        end
    end
end

function Lib.Information.Local:GetCinematicEventStatus(_InfoID)
    for i= 1, 8 do
        if self.CinematicEventStatus[i][_InfoID] then
            return self.CinematicEventStatus[i][_InfoID];
        end
    end
    return 0;
end

function Lib.Information.Local:OverrideInterfaceUpdateForCinematicMode()
    self.Orig_GameCallback_GameSpeedChanged = GameCallback_GameSpeedChanged;
    GameCallback_GameSpeedChanged = function(_Speed)
        if not Lib.Information.Local.PauseScreenShown then
            Lib.Information.Local.Orig_GameCallback_GameSpeedChanged(_Speed);
        end
    end

    MissionTimerUpdate_Orig_Information = MissionTimerUpdate;
    MissionTimerUpdate = function()
        MissionTimerUpdate_Orig_Information();
        if Lib.Information.Local.NormalModeHidden
        or Lib.Information.Local.PauseScreenShown then
            XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 0);
        end
    end

    MissionGoodOrEntityCounterUpdate_Orig_Information = MissionGoodOrEntityCounterUpdate;
    MissionGoodOrEntityCounterUpdate = function()
        MissionGoodOrEntityCounterUpdate_Orig_Information();
        if Lib.Information.Local.NormalModeHidden
        or Lib.Information.Local.PauseScreenShown then
            XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 0);
        end
    end

    MerchantButtonsUpdater_Orig_Information = GUI_Merchant.ButtonsUpdater;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Merchant.ButtonsUpdater = function()
        MerchantButtonsUpdater_Orig_Information();
        if Lib.Information.Local.NormalModeHidden
        or Lib.Information.Local.PauseScreenShown then
            XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Merchant", 0);
        end
    end

    if GUI_Tradepost then
        TradepostButtonsUpdater_Orig_Information = GUI_Tradepost.ButtonsUpdater;
        --- @diagnostic disable-next-line: duplicate-set-field
        GUI_Tradepost.ButtonsUpdater = function()
            TradepostButtonsUpdater_Orig_Information();
            if Lib.Information.Local.NormalModeHidden
            or Lib.Information.Local.PauseScreenShown then
                XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Tradepost", 0);
            end
        end
    end
end

function Lib.Information.Local:OverrideInterfaceThroneroomForCinematicMode()
    GameCallback_Lib_Camera_StartButtonPressed = function(_PlayerID)
    end
    OnStartButtonPressed = function()
        GameCallback_Lib_Camera_StartButtonPressed(GUI.GetPlayerID());
    end

    GameCallback_Lib_Camera_BackButtonPressed = function(_PlayerID)
    end
    OnBackButtonPressed = function()
        GameCallback_Lib_Camera_BackButtonPressed(GUI.GetPlayerID());
    end

    GameCallback_Lib_Camera_SkipButtonPressed = function(_PlayerID)
    end
    OnSkipButtonPressed = function()
        GameCallback_Lib_Camera_SkipButtonPressed(GUI.GetPlayerID());
    end

    GameCallback_Lib_Camera_ThroneRoomLeftClick = function(_PlayerID)
    end
    ThroneRoomLeftClick = function()
        GameCallback_Lib_Camera_ThroneRoomLeftClick(GUI.GetPlayerID());
    end

    GameCallback_Lib_Camera_ThroneroomCameraControl = function(_PlayerID)
    end
    ThroneRoomCameraControl = function()
        GameCallback_Lib_Camera_ThroneroomCameraControl(GUI.GetPlayerID());
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Information.Name);

