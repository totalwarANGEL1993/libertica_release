Lib.UIEffects = Lib.UIEffects or {};
Lib.UIEffects.Name = "UIEffects";
Lib.UIEffects.CinematicEvents = {};
Lib.UIEffects.Global = {
    CinematicEventID = 0,
    CinematicEventStatus = {},
    CinematicEventQueue = {},
    TypewriterEventData = {},
    TypewriterEventCounter = 0,
};
Lib.UIEffects.Local = {
    CinematicEventStatus = {},
    ChatOptionsWasShown = false,
    MessageLogWasShown = false,
    PauseScreenShown = false,
    NormalModeHidden = false,
};

CinematicEventTypes = {};
CinematicEventState = {
    NotTriggered = 0,
    Active = 1,
    Concluded = 2,
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
        --- A cinematic event, received by a player, has started.
        ---
        --- #### Parameter
        --- * `EventID`  - ID of cinematic event
        --- * `PlayerID` - ID of receiving Player
        Report.CinematicActivated = CreateReport("Event_CinematicEventActivated");

        --- A cinematic event, received by a player, has concluded.
        --- 
        --- #### Parameter
        --- * `EventID`  - ID of cinematic event
        --- * `PlayerID` - ID of receiving Player
        Report.CinematicConcluded = CreateReport("Event_CinematicEventConcluded");

        --- The normal interface is shown for the player.
        ---
        --- #### Parameter
        --- * `PlayerID` - ID of receiving Player
        Report.GameInterfaceShown = CreateReport("Event_GameInterfaceShown");

        --- The normal interface is hidden from the player.
        --- 
        --- #### Parameter
        --- * `PlayerID` - ID of receiving Player
        Report.GameInterfaceHidden = CreateReport("Event_GameInterfaceHidden");

        --- The fullscreen image background is shown for the player.
        ---
        --- #### Parameter
        --- * `PlayerID` - ID of receiving Player
        Report.ImageScreenShown = CreateReport("Event_ImageScreenShown");

        --- The fullscreen image background is hidden from the player.
        --- 
        --- #### Parameter
        --- * `PlayerID` - ID of receiving Player
        Report.ImageScreenHidden = CreateReport("Event_ImageScreenHidden");

        Report.TypewriterStarted = CreateReport("Event_TypewriterStarted");
        Report.TypewriterEnded = CreateReport("Event_TypewriterEnded");

        for i= 1, 8 do
            self.CinematicEventStatus[i] = {};
            self.CinematicEventQueue[i] = {};
        end
        RequestHiResJob(function()
            Lib.UIEffects.Global:ControlTypewriter();
        end);

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

-- -------------------------------------------------------------------------- --

function Lib.UIEffects.Global:PushCinematicEventToQueue(_PlayerID, _Type, _Name, _Data)
    table.insert(self.CinematicEventQueue[_PlayerID], {_Type, _Name, _Data});
end

function Lib.UIEffects.Global:LookUpCinematicInQueue(_PlayerID)
    if #self.CinematicEventQueue[_PlayerID] > 0 then
        return self.CinematicEventQueue[_PlayerID][1];
    end
end

function Lib.UIEffects.Global:PopCinematicEventFromQueue(_PlayerID)
    if #self.CinematicEventQueue[_PlayerID] > 0 then
        return table.remove(self.CinematicEventQueue[_PlayerID], 1);
    end
end

function Lib.UIEffects.Global:GetNewCinematicEventID()
    self.CinematicEventID = self.CinematicEventID +1;
    return self.CinematicEventID;
end

function Lib.UIEffects.Global:GetCinematicEventStatus(_InfoID)
    for i= 1, 8 do
        if self.CinematicEventStatus[i][_InfoID] then
            return self.CinematicEventStatus[i][_InfoID];
        end
    end
    return 0;
end

function Lib.UIEffects.Global:ActivateCinematicEvent(_PlayerID)
    local ID = self:GetNewCinematicEventID();
    SendReport(Report.CinematicActivated, ID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[SendReport(Report.CinematicActivated, %d, %d);
          if GUI.GetPlayerID() == %d then
            Lib.UIEffects.Local.SavingWasDisabled = Lib.Core.Save.SavingDisabled == true;
            DisableSaving(true);
          end]],
        ID,
        _PlayerID,
        _PlayerID
    ))
    return ID;
end

function Lib.UIEffects.Global:ConcludeCinematicEvent(_ID, _PlayerID)
    SendReport(Report.CinematicConcluded, _ID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[SendReport(Report.CinematicConcluded, %d, %d);
          if GUI.GetPlayerID() == %d then
            if not Lib.UIEffects.Local.SavingWasDisabled then
                DisableSaving(false);
            end
            Lib.UIEffects.Local.SavingWasDisabled = false;
          end]],
        _ID,
        _PlayerID,
        _PlayerID
    ))
end

-- -------------------------------------------------------------------------- --

function Lib.UIEffects.Global:StartTypewriter(_Data)
    self.TypewriterEventCounter = self.TypewriterEventCounter +1;
    local EventName = "CinematicEvent_Typewriter" ..self.TypewriterEventCounter;
    _Data.Name = EventName;
    if not self.LoadscreenClosed or IsCinematicEventActive(_Data.PlayerID) then
        Lib.UIEffects.Global:PushCinematicEventToQueue(
            _Data.PlayerID,
            CinematicEventTypes.Typewriter,
            EventName,
            _Data
        );
        return _Data.Name;
    end
    return self:PlayTypewriter(_Data);
end

function Lib.UIEffects.Global:PlayTypewriter(_Data)
    local ID = StartCinematicEvent(_Data.Name, _Data.PlayerID);
    _Data.ID = ID;
    _Data.TextTokens = self:TokenizeText(_Data);
    self.TypewriterEventData[_Data.PlayerID] = _Data;

    ExecuteLocal(
        [[
        if GUI.GetPlayerID() == %d then
            ActivateImageScreen(GUI.GetPlayerID(), "%s", %d, %d, %d, %d)
            DeactivateNormalInterface(GUI.GetPlayerID())
            DeactivateBorderScroll(GUI.GetPlayerID(), %d)
            Input.CutsceneMode()
            GUI.ClearNotes()
        end
        ]],
        _Data.PlayerID,
        _Data.Image,
        _Data.Color.R or 0,
        _Data.Color.G or 0,
        _Data.Color.B or 0,
        _Data.Color.A or 255,
        _Data.TargetEntity
    );

    SendReport(Report.TypewriterStarted, _Data.PlayerID, _Data.Name);
    SendReportToLocal(Report.TypewriterStarted, _Data.PlayerID, _Data.Name);
    return _Data.Name;
end

function Lib.UIEffects.Global:FinishTypewriter(_PlayerID)
    if self.TypewriterEventData[_PlayerID] then
        local EventData = table.copy(self.TypewriterEventData[_PlayerID]);
        local EventPlayer = self.TypewriterEventData[_PlayerID].PlayerID;

        ExecuteLocal([[
            if GUI.GetPlayerID() == %d then
                ResetRenderDistance()
                DeactivateImageScreen(GUI.GetPlayerID())
                ActivateNormalInterface(GUI.GetPlayerID())
                ActivateBorderScroll(GUI.GetPlayerID())
                if ModuleGuiControl then
                    Lib.UITools.Widget:UpdateHiddenWidgets()
                end
                Input.GameMode()
                GUI.ClearNotes()
            end
        ]], _PlayerID);

        SendReport(Report.TypewriterEnded, EventPlayer, EventData.Name);
        SendReportToLocal(Report.TypewriterEnded, EventPlayer, EventData.Name);
        self.TypewriterEventData[_PlayerID]:Callback();
        FinishCinematicEvent(EventData.Name, EventPlayer);
        self.TypewriterEventData[_PlayerID] = nil;
    end
end

function Lib.UIEffects.Global:TokenizeText(_Data)
    local TextTokens = {};
    local TempTokens = {};
    local Text = ConvertPlaceholders(Localize(_Data.Text));
    Text = Text:gsub("%s+", " ");
    while (true) do
        local s1, e1 = Text:find("{");
        local s2, e2 = Text:find("}");
        if not s1 or not s2 then
            table.insert(TempTokens, Text);
            break;
        end
        if s1 > 1 then
            table.insert(TempTokens, Text:sub(1, s1 -1));
        end
        table.insert(TempTokens, Text:sub(s1, e2));
        Text = Text:sub(e2 +1);
    end

    local LastWasPlaceholder = false;
    for i= 1, #TempTokens, 1 do
        if TempTokens[i]:find("{") then
            local Index = #TextTokens;
            if LastWasPlaceholder then
                TextTokens[Index] = TextTokens[Index] .. TempTokens[i];
            else
                table.insert(TextTokens, Index+1, TempTokens[i]);
            end
            LastWasPlaceholder = true;
        else
            local Index = 1;
            while (Index <= #TempTokens[i]) do
                if string.byte(TempTokens[i]:sub(Index, Index)) == 195 then
                    table.insert(TextTokens, TempTokens[i]:sub(Index, Index+1));
                    Index = Index +1;
                else
                    table.insert(TextTokens, TempTokens[i]:sub(Index, Index));
                end
                Index = Index +1;
            end
            LastWasPlaceholder = false;
        end
    end
    return TextTokens;
end

function Lib.UIEffects.Global:ControlTypewriter()
    -- Check queue for next event
    for i= 1, 8 do
        if self.LoadscreenClosed and not IsCinematicEventActive(i) then
            local Next = Lib.UIEffects.Global:LookUpCinematicInQueue(i);
            if Next and Next[1] == CinematicEventTypes.Typewriter then
                local Data = Lib.UIEffects.Global:PopCinematicEventFromQueue(i);
                self:PlayTypewriter(Data[3]);
            end
        end
    end

    -- Perform active events
    for k, v in pairs(self.TypewriterEventData) do
        if self.TypewriterEventData[k].Delay > 0 then
            self.TypewriterEventData[k].Delay = self.TypewriterEventData[k].Delay -1;

            ExecuteLocal(
                [[if GUI.GetPlayerID() == %d then GUI.ClearNotes() end]],
                self.TypewriterEventData[k].PlayerID
            );
        end
        if self.TypewriterEventData[k].Delay == 0 then
            self.TypewriterEventData[k].Index = v.Index + v.CharSpeed;
            if v.Index > #self.TypewriterEventData[k].TextTokens then
                self.TypewriterEventData[k].Index = #self.TypewriterEventData[k].TextTokens;
            end
            local Index = math.floor(v.Index + 0.5);
            local Text = "";
            for i= 1, Index, 1 do
                Text = Text .. self.TypewriterEventData[k].TextTokens[i];
            end

            ExecuteLocal(
                [[
                if GUI.GetPlayerID() == %d then
                    GUI.ClearNotes()
                    GUI.AddNote("%s")
                end
                ]],
                self.TypewriterEventData[k].PlayerID,
                Text
            );

            if Index == #self.TypewriterEventData[k].TextTokens then
                self.TypewriterEventData[k].Waittime = v.Waittime -1;
                if v.Waittime <= 0 then
                    self:FinishTypewriter(k);
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.UIEffects.Local:Initialize()
    if not self.IsInstalled then
        -- public reports
        Report.CinematicActivated = CreateReport("Event_CinematicEventActivated");
        Report.CinematicConcluded = CreateReport("Event_CinematicEventConcluded");
        Report.GameInterfaceShown = CreateReport("Event_GameInterfaceShown");
        Report.GameInterfaceHidden = CreateReport("Event_GameInterfaceHidden");
        Report.ImageScreenShown = CreateReport("Event_ImageScreenShown");

        -- internal reports
        Report.ImageScreenHidden = CreateReport("Event_ImageScreenHidden");
        Report.TypewriterStarted = CreateReport("Event_TypewriterStarted");
        Report.TypewriterEnded = CreateReport("Event_TypewriterEnded");

        for i= 1, 8 do
            self.CinematicEventStatus[i] = {};
        end
        self:OverrideInterfaceUpdateForCinematicMode();
        self:OverrideInterfaceThroneroomForCinematicMode();

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

function Lib.UIEffects.Local:GetCinematicEventStatus(_InfoID)
    for i= 1, 8 do
        if self.CinematicEventStatus[i][_InfoID] then
            return self.CinematicEventStatus[i][_InfoID];
        end
    end
    return 0;
end

function Lib.UIEffects.Local:OverrideInterfaceUpdateForCinematicMode()
    GameCallback_GameSpeedChanged_Orig_UIEffects = GameCallback_GameSpeedChanged;
    GameCallback_GameSpeedChanged = function(_Speed)
        if not Lib.UIEffects.Local.PauseScreenShown then
            GameCallback_GameSpeedChanged_Orig_UIEffects(_Speed);
        end
    end

    MissionTimerUpdate_Orig_UIEffects = MissionTimerUpdate;
    MissionTimerUpdate = function()
        MissionTimerUpdate_Orig_UIEffects();
        if Lib.UIEffects.Local.NormalModeHidden
        or Lib.UIEffects.Local.PauseScreenShown then
            XGUIEng.ShowWidget("/InGame/Root/Normal/MissionTimer", 0);
        end
    end

    MissionGoodOrEntityCounterUpdate_Orig_UIEffects = MissionGoodOrEntityCounterUpdate;
    MissionGoodOrEntityCounterUpdate = function()
        MissionGoodOrEntityCounterUpdate_Orig_UIEffects();
        if Lib.UIEffects.Local.NormalModeHidden
        or Lib.UIEffects.Local.PauseScreenShown then
            XGUIEng.ShowWidget("/InGame/Root/Normal/MissionGoodOrEntityCounter", 0);
        end
    end

    MerchantButtonsUpdater_Orig_UIEffects = GUI_Merchant.ButtonsUpdater;
    GUI_Merchant.ButtonsUpdater = function()
        MerchantButtonsUpdater_Orig_UIEffects();
        if Lib.UIEffects.Local.NormalModeHidden
        or Lib.UIEffects.Local.PauseScreenShown then
            XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Merchant", 0);
        end
    end

    if GUI_Tradepost then
        TradepostButtonsUpdater_Orig_UIEffects = GUI_Tradepost.ButtonsUpdater;
        GUI_Tradepost.ButtonsUpdater = function()
            TradepostButtonsUpdater_Orig_UIEffects();
            if Lib.UIEffects.Local.NormalModeHidden
            or Lib.UIEffects.Local.PauseScreenShown then
                XGUIEng.ShowWidget("/InGame/Root/Normal/Selected_Tradepost", 0);
            end
        end
    end
end

function Lib.UIEffects.Local:OverrideInterfaceThroneroomForCinematicMode()
    GameCallback_Camera_StartButtonPressed = function(_PlayerID)
    end
    OnStartButtonPressed = function()
        GameCallback_Camera_StartButtonPressed(GUI.GetPlayerID());
    end

    GameCallback_Camera_BackButtonPressed = function(_PlayerID)
    end
    OnBackButtonPressed = function()
        GameCallback_Camera_BackButtonPressed(GUI.GetPlayerID());
    end

    GameCallback_Camera_SkipButtonPressed = function(_PlayerID)
    end
    OnSkipButtonPressed = function()
        GameCallback_Camera_SkipButtonPressed(GUI.GetPlayerID());
    end

    GameCallback_Camera_ThroneRoomLeftClick = function(_PlayerID)
    end
    ThroneRoomLeftClick = function()
        GameCallback_Camera_ThroneRoomLeftClick(GUI.GetPlayerID());
    end

    GameCallback_Camera_ThroneroomCameraControl = function(_PlayerID)
    end
    ThroneRoomCameraControl = function()
        GameCallback_Camera_ThroneroomCameraControl(GUI.GetPlayerID());
    end
end

function Lib.UIEffects.Local:InterfaceActivateImageBackground(_PlayerID, _Graphic, _R, _G, _B, _A)
    if _PlayerID ~= GUI.GetPlayerID() or self.PauseScreenShown then
        return;
    end
    self.PauseScreenShown = true;

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
end

function Lib.UIEffects.Local:InterfaceDeactivateImageBackground(_PlayerID)
    if _PlayerID ~= GUI.GetPlayerID() or not self.PauseScreenShown then
        return;
    end
    self.PauseScreenShown = false;

    XGUIEng.ShowWidget("/InGame/Root/Normal/PauseScreen", 0);
    XGUIEng.SetMaterialTexture("/InGame/Root/Normal/PauseScreen", 0, "");
    XGUIEng.SetMaterialColor("/InGame/Root/Normal/PauseScreen", 0, 40, 40, 40, 180);
    XGUIEng.PopPage();
    SendReportToGlobal(Report.ImageScreenHidden, _PlayerID);
    SendReport(Report.ImageScreenHidden, _PlayerID);
end

function Lib.UIEffects.Local:InterfaceDeactivateNormalInterface(_PlayerID)
    if GUI.GetPlayerID() ~= _PlayerID or self.NormalModeHidden then
        return;
    end
    self.NormalModeHidden = true;

    XGUIEng.PushPage("/InGame/Root/Normal/NotesWindow", false);
    XGUIEng.ShowWidget("/InGame/Root/3dOnScreenDisplay", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/TextMessages", 1);
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
end

function Lib.UIEffects.Local:InterfaceActivateNormalInterface(_PlayerID)
    if GUI.GetPlayerID() ~= _PlayerID or not self.NormalModeHidden then
        return;
    end
    self.NormalModeHidden = false;

    XGUIEng.ShowWidget("/InGame/Root/Normal", 1);
    XGUIEng.ShowWidget("/InGame/Root/3dOnScreenDisplay", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopRight", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/TopBar", 1);
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
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.UIEffects.Name);

