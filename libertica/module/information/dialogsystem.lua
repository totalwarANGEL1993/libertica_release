Lib.DialogSystem = Lib.DialogSystem or {};
Lib.DialogSystem.Name = "DialogSystem";
Lib.DialogSystem.Global = {
    Dialog = {},
    DialogQueue = {},
    DialogCounter = 0,
};
Lib.DialogSystem.Local = {
    Config = {
        DoAlternateGraphics = true,
    },
    Dialog = {},
};

CONST_DIALOG = {
    TIMER_PER_CHAR = 0.175,
    CAMERA_ANGLEDEFAULT = 43,
    CAMERA_ROTATIONDEFAULT = -45,
    CAMERA_ZOOMDEFAULT = 6500,
    CAMERA_FOVDEFAULT = 42,
    DLGCAMERA_ANGLEDEFAULT = 27,
    DLGCAMERA_ROTATIONDEFAULT = -45,
    DLGCAMERA_ZOOMDEFAULT = 1750,
    DLGCAMERA_FOVDEFAULT = 25,
}

Lib.Require("comfort/GetPosition");
Lib.Require("comfort/IsMultiplayer");
Lib.Require("core/Core");
Lib.Require("module/information/Information");
Lib.Require("module/information/DialogSystem_Text");
Lib.Require("module/information/DialogSystem_API");
Lib.Require("module/information/DialogSystem_Behavior");
Lib.Register("module/information/DialogSystem");

CinematicEventTypes.Dialog = 4;

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.DialogSystem.Global:Initialize()
    if not self.IsInstalled then
        Report.DialogStarted = CreateReport("Event_DialogStarted");
        Report.DialogEnded = CreateReport("Event_DialogEnded");
        Report.DialogPageShown = CreateReport("Event_DialogPageShown");
        Report.DialogOptionSelected = CreateReport("Event_DialogOptionSelected");

        for i= 1, 8 do
            self.DialogQueue[i] = {};
        end
        RequestHiResJob(function()
            Lib.DialogSystem.Global:UpdateQueue();
            Lib.DialogSystem.Global:DialogExecutionController();
        end);

        -- Garbage collection
        Lib.DialogSystem.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.DialogSystem.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.DialogSystem.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.EscapePressed then
        self:SkipButtonPressed(arg[1]);
    elseif _ID == Report.DialogStarted then
        self:NextPage(arg[1]);
    elseif _ID == Report.DialogEnded then
        -- Nothing to do?
    elseif _ID == Report.DialogPageShown then
        -- Nothing to do?
    elseif _ID == Report.DialogOptionSelected then
        self:OnOptionSelected(arg[1], arg[2]);
    end
end

-- Manages the actual activation of dialogues.
function Lib.DialogSystem.Global:UpdateQueue()
    for i= 1, 8 do
        if self:CanStartDialog(i) then
            local Next = Lib.Information.Global:LookUpCinematicInQueue(i);
            if Next and Next[1] == CinematicEventTypes.Dialog then
                self:NextDialog(i);
            end
        end
    end
end

-- Manages auto skipping of pages.
function Lib.DialogSystem.Global:DialogExecutionController()
    for i= 1, 8 do
        if self.Dialog[i] then
            local PageID = self.Dialog[i].CurrentPage;
            local Page = self.Dialog[i][PageID];
            if Page and not Page.MC and Page.Duration > 0 and Page.AutoSkip then
                if (Page.Started + Page.Duration) < Logic.GetTime() then
                    self:NextPage(i);
                end
            end
        end
    end
end

function Lib.DialogSystem.Global:ExpandDialogTable(_Dialog)
    assert(type(_Dialog) == "table");
    Lib.DialogSystem.Global:CreateDialogProperties(_Dialog);
    Lib.DialogSystem.Global:CreateDialogGetPage(_Dialog);
    Lib.DialogSystem.Global:CreateDialogAddPage(_Dialog);
end

function Lib.DialogSystem.Global:CreateDialogProperties(_Dialog)
    _Dialog.EnableSky = true;
    _Dialog.EnableFoW = false;
    _Dialog.HideNotes = false;
    _Dialog.EnableGlobalImmortality = true;
    _Dialog.EnableBorderPins = false;
    _Dialog.RestoreGameSpeed = true;
    _Dialog.RestoreCamera = true;

    _Dialog.SetName = function(_self, _Name)
        _self.Name = _Name;
        return _self;
    end

    _Dialog.SetPlayer = function(_self, _Player)
        _self.PlayerID = _Player;
        return _self;
    end

    _Dialog.UseRestoreCamera = function(_self, _RestoreCamera)
        _self.RestoreCamera = _RestoreCamera == true;
        return _self;
    end

    _Dialog.UseRestoreGameSpeed = function(_self, _RestoreGameSpeed)
        _self.RestoreGameSpeed = _RestoreGameSpeed == true;
        return _self;
    end

    _Dialog.UseGlobalImmortality = function(_self, _EnableGlobalImmortality)
        _self.EnableGlobalImmortality = _EnableGlobalImmortality == true;
        return _self;
    end

    _Dialog.SetEnableBorderPins = function(_self, _EnableBorderPins)
        _self.EnableBorderPins = _EnableBorderPins == true;
        return _self;
    end

    _Dialog.SetEnableFoW = function(_self, _EnableFoW)
        _self.EnableFoW = _EnableFoW == true;
        return _self;
    end

    _Dialog.SetEnableSky = function(_self, _EnableSky)
        _self.EnableSky = _EnableSky == true;
        return _self;
    end

    _Dialog.SetHideNotes = function(_self, _HideNotes)
        _self.HideNotes = _HideNotes == true;
        return _self;
    end

    _Dialog.SetOnBegin = function(_self, _OnBegin)
        _self.Starting = _OnBegin;
        return _self;
    end

    _Dialog.SetOnFinish = function(_self, _OnFinish)
        _self.Finished = _OnFinish;
        return _self;
    end

    _Dialog.Start = function(_self)
        assert(GUI == nil);

        local Count = Lib.DialogSystem.Global.DialogCounter +1;
        Lib.DialogSystem.Global.DialogCounter = Count;
        _self.Name = _self.Name or ("DialogSystem_Dialog_" .. Count);
        _self.PlayerID = _self.PlayerID or 1;

        assert(type(_self.Name) == "string");
        assert(_self.PlayerID ~= nil);
        assert(type(_self) == "table", "Dialog must be a table!");
        assert(#_self > 0, "Dialog does not contain pages!");

        Lib.DialogSystem.Global:StartDialog(_self.Name, _self.PlayerID, _self);
        return _self.Name;
    end
end

function Lib.DialogSystem.Global:CreateDialogGetPage(_Dialog)
    _Dialog.GetPage = _Dialog.GetPage or function(this, _NameOrID)
        local ID = Lib.DialogSystem.Global:GetPageIDByName(_Dialog.PlayerID, _NameOrID);
        return Lib.DialogSystem.Global.Dialog[_Dialog.PlayerID][ID];
    end
end

function Lib.DialogSystem.Global:CreateDialogAddPage(_Dialog)
    local Dialog = _Dialog;

    Dialog.BeginPage = Dialog.BeginPage or function(_self)
        Dialog.Length = (Dialog.Length or 0) +1;
        local Page = {};
        Page.__Legit = true;
        Page.Name = "Page" ..(#Dialog +1);
        Page.DialogCamera = false;
        Page.AutoSkip = false;

        Page.GetSelected = function(_Page)
            if _Page.MC then
                return _Page.MC.Selected or 0;
            end
            return 0;
        end

        Page.SetName = function(_Page, _Name)
            _Page.Name = _Name;
            return _Page;
        end

        Page.SetActor = function(_Page, _Actor)
            _Page.Actor = _Actor;
            return _Page;
        end

        Page.SetTitle = function(_Page, _Title)
            _Page.Title = Localize(_Title or "");
            return _Page;
        end

        Page.SetText = function(_Page, _Text)
            _Page.Text = Localize(_Text or "");
            return _Page;
        end

        Page.SetSpeech = function(_Page, _Speech)
            _Page.Speech = _Speech;
            return _Page;
        end

        Page.SetDuration = function(_Page, _Duration)
            _Page.Duration = _Duration;
            return _Page;
        end

        Page.UseSkipping = function(_Page, _Skip)
            _Page.AutoSkip = _Skip ~= true;
            return _Page;
        end

        Page.SetAction = function(_Page, _Action)
            _Page.Action = _Action;
            return _Page;
        end

        Page.SetFadeIn = function(_Page, _FadeIn)
            _Page.FadeIn = _FadeIn;
            return _Page;
        end

        Page.SetFadeOut = function(_Page, _FadeOut)
            _Page.FadeOut = _FadeOut;
            return _Page;
        end

        Page.SetFaderAlpha = function(_Page, _FaderAlpha)
            _Page.FaderAlpha = _FaderAlpha;
            return _Page;
        end

        Page.SetAngle = function(_Page, _Angle)
            _Page.Angle = _Angle;
            return _Page;
        end

        Page.SetRotation = function(_Page, _Rotation)
            _Page.Rotation = _Rotation;
            return _Page;
        end

        Page.SetZoom = function(_Page, _Zoom)
            _Page.Distance = _Zoom;
            if _Page.Distance ~= nil then
                _Page.DialogCamera = false;
            end
            return _Page;
        end

        Page.SetPosition = function(_Page, _Position)
            _Page.Position = _Position;
            return _Page;
        end

        Page.SetTarget = function(_Page, _Target)
            _Page.Target = _Target;
            return _Page;
        end

        Page.UseCloseUp = function(_Page, _CloseUp)
            _Page.DialogCamera = _CloseUp == true;
            if _Page.DialogCamera ~= nil then
                _Page.Zoom = nil;
            end
            return _Page;
        end

        Page.BeginChoice = function(_Page)
            _Page.MC = {};
            _Page.AutoSkip = false;

            _Page.MC.Option = function(_Option, ...)
                local args = {...};
                local Index = #_Page.MC +1;
                local ID = Index;
                if type(args[1]) == "number" then
                    ID = table.remove(args, 1);
                end
                _Page.MC[Index] = {ID = ID, Localize(args[1]), args[2], args[3]};
                return _Option;
            end

            _Page.MC.EndChoice = function(_Choice)
                assert(#_Page.MC > 0);
                return _Page;
            end
            return _Page.MC;
        end

        Page.EndPage = function(_Page)
            return Dialog;
        end

        table.insert(_self, Page);
        return Page;
    end

    Dialog.Redirect = Dialog.Redirect or function(_self, _Target)
        _self.Length = (_self.Length or 0) +1;
        local Page = (_Target == nil and -1) or _Target;
        table.insert(_self, Page);
        return Dialog;
    end
end

-- Does not really start the dialog. It is pushed inside the global queue for
-- all informational stuff and executed later by a job.
function Lib.DialogSystem.Global:StartDialog(_Name, _PlayerID, _Data)
    self.DialogQueue[_PlayerID] = self.DialogQueue[_PlayerID] or {};
    Lib.Information.Global:PushCinematicEventToQueue(
        _PlayerID,
        CinematicEventTypes.Dialog,
        _Name,
        _Data
    );
end

function Lib.DialogSystem.Global:EndDialog(_PlayerID)
    Logic.SetGlobalInvulnerability(0);
    ExecuteLocal(
        [[Lib.DialogSystem.Local:ResetTimerButtons(%d);
          Camera.RTS_FollowEntity(0);]],
        _PlayerID
    );

    local Dialog = self.Dialog[_PlayerID];
    SendReport(Report.DialogEnded, _PlayerID, Dialog.Name);
    SendReportToLocal(Report.DialogEnded, _PlayerID, Dialog.Name, Dialog);
    if Dialog.Finished then
        Dialog:Finished();
    end
    FinishCinematicEvent(Dialog.Name, _PlayerID);
    self.Dialog[_PlayerID] = nil;
end

function Lib.DialogSystem.Global:NextDialog(_PlayerID)
    if self:CanStartDialog(_PlayerID) then
        local DialogData = Lib.Information.Global:PopCinematicEventFromQueue(_PlayerID);
        assert(DialogData[1] == CinematicEventTypes.Dialog);
        StartCinematicEvent(DialogData[2], _PlayerID);

        local Dialog = DialogData[3];
        Dialog.Name = DialogData[2];
        Dialog.PlayerID = _PlayerID;
        Dialog.LastSkipButtonPressed = 0;
        Dialog.CurrentPage = 0;
        self.Dialog[_PlayerID] = Dialog;
        self:SetDefaultAttributes(_PlayerID);

        if Dialog.EnableGlobalImmortality then
            Logic.SetGlobalInvulnerability(1);
        end
        if self.Dialog[_PlayerID].Starting then
            self.Dialog[_PlayerID]:Starting();
        end

        SendReportToLocal(Report.DialogStarted, Dialog.PlayerID, Dialog.Name, Dialog);
        SendReport(Report.DialogStarted, Dialog.PlayerID, Dialog.Name);
    end
end

function Lib.DialogSystem.Global:SetDefaultAttributes(_PlayerID)
    for i= 1, #self.Dialog[_PlayerID] do
        local Page = self.Dialog[_PlayerID][i];
        if type(Page) == "table" then
            -- Skip page
            Page.AutoSkip = false;
            if Page.Duration then
                if Page.Duration == -1 then
                    Page.Duration = string.len(Page.Text or "") * CONST_DIALOG.TIMER_PER_CHAR;
                    Page.AutoSkip = (Page.Duration < 6 and 6) or Page.Duration < 6;
                end
                Page.AutoSkip = Page.Duration > 0 and Page.MC == nil;
            end

            -- Default camera rotation
            if not Page.Rotation then
                Page.Rotation = CONST_DIALOG.CAMERA_ROTATIONDEFAULT;
                if Page.DialogCamera then
                    Page.Rotation = CONST_DIALOG.DLGCAMERA_ROTATIONDEFAULT;
                end
                if Page.Position and type(Page.Position) ~= "table" then
                    local ID = GetID(Page.Position);
                    local Orientation = Logic.GetEntityOrientation(ID) +90;
                    Page.Rotation = Orientation;
                elseif Page.Target then
                    local ID = GetID(Page.Target);
                    local Orientation = Logic.GetEntityOrientation(ID) +90;
                    Page.Rotation = Orientation;
                end
            end
            -- Default camera distance
            if not Page.Distance then
                Page.Distance = CONST_DIALOG.CAMERA_ZOOMDEFAULT;
                if Page.DialogCamera then
                    Page.Distance = CONST_DIALOG.DLGCAMERA_ZOOMDEFAULT;
                end
            end
            -- Default camera angle
            if not Page.Angle then
                Page.Angle = CONST_DIALOG.CAMERA_ANGLEDEFAULT;
                if Page.DialogCamera then
                    Page.Angle = CONST_DIALOG.DLGCAMERA_ANGLEDEFAULT;
                end
            end

            self.Dialog[_PlayerID][i] = Page;
        end
    end
end

function Lib.DialogSystem.Global:NextPage(_PlayerID)
    if self.Dialog[_PlayerID] == nil then
        return;
    end

    self.Dialog[_PlayerID].CurrentPage = self.Dialog[_PlayerID].CurrentPage +1;
    local PageID = self.Dialog[_PlayerID].CurrentPage;
    if PageID == -1 or PageID == 0 then
        self:EndDialog(_PlayerID);
        return;
    end

    local Page = self.Dialog[_PlayerID][PageID];
    if type(Page) == "table" then
        if PageID <= #self.Dialog[_PlayerID] then
            self.Dialog[_PlayerID][PageID].Started = Logic.GetTime();
            self.Dialog[_PlayerID][PageID].Duration = Page.Duration or -1;
            if self.Dialog[_PlayerID][PageID].Action then
                self.Dialog[_PlayerID][PageID]:Action();
            end
            self:DisplayPage(_PlayerID, PageID);
        else
            self:EndDialog(_PlayerID);
        end
    elseif type(Page) == "number" or type(Page) == "string" then
        local Target = self:GetPageIDByName(_PlayerID, self.Dialog[_PlayerID][PageID]);
        self.Dialog[_PlayerID].CurrentPage = Target -1;
        self:NextPage(_PlayerID);
    else
        self:EndDialog(_PlayerID);
    end
end

function Lib.DialogSystem.Global:DisplayPage(_PlayerID, _PageID)
    if self.Dialog[_PlayerID] == nil then
        return;
    end

    local Page = self.Dialog[_PlayerID][_PageID];
    if type(Page) == "table" then
        local PageID = self.Dialog[_PlayerID].CurrentPage;
        if Page.MC then
            for i= 1, #Page.MC, 1 do
                if type(Page.MC[i][3]) == "function" then
                    self.Dialog[_PlayerID][PageID].MC[i].Visible = Page.MC[i][3](_PlayerID, PageID, i);
                end
            end
        end
    end

    SendReport(Report.DialogPageShown, _PlayerID, _PageID);
    SendReportToLocal(Report.DialogPageShown, _PlayerID, _PageID, Page);
end

-- There is no skip button but I want to keep the original names to make
-- comparisons easier for other authors who might want to implement yet
-- another information system.
function Lib.DialogSystem.Global:SkipButtonPressed(_PlayerID, _PageID)
    if not self.Dialog[_PlayerID] then
        return;
    end
    if (self.Dialog[_PlayerID].LastSkipButtonPressed + 500) > Logic.GetTimeMs() then
        return;
    end
    local PageID = self.Dialog[_PlayerID].CurrentPage;
    if self.Dialog[_PlayerID][PageID].AutoSkip
    or self.Dialog[_PlayerID][PageID].MC then
        return;
    end
    if self.Dialog[_PlayerID][PageID].OnForward then
        self.Dialog[_PlayerID][PageID]:OnForward();
    end
    self.Dialog[_PlayerID].LastSkipButtonPressed = Logic.GetTimeMs();
    self:NextPage(_PlayerID);
end

function Lib.DialogSystem.Global:OnOptionSelected(_PlayerID, _OptionID)
    if self.Dialog[_PlayerID] == nil then
        return;
    end
    local PageID = self.Dialog[_PlayerID].CurrentPage;
    if type(self.Dialog[_PlayerID][PageID]) ~= "table" then
        return;
    end
    local Page = self.Dialog[_PlayerID][PageID];
    if Page.MC then
        local Option;
        for i= 1, #Page.MC, 1 do
            if Page.MC[i].ID == _OptionID then
                Option = Page.MC[i];
            end
        end
        if Option ~= nil then
            local Target = Option[2];
            if type(Option[2]) == "function" then
                Target = Option[2](_PlayerID, PageID, _OptionID);
            end
            self.Dialog[_PlayerID][PageID].MC.Selected = Option.ID;
            self.Dialog[_PlayerID].CurrentPage = self:GetPageIDByName(_PlayerID, Target) -1;
            self:NextPage(_PlayerID);
        end
    end
end

function Lib.DialogSystem.Global:GetCurrentDialog(_PlayerID)
    return self.Dialog[_PlayerID];
end

function Lib.DialogSystem.Global:GetCurrentDialogPage(_PlayerID)
    if self.Dialog[_PlayerID] then
        local PageID = self.Dialog[_PlayerID].CurrentPage;
        return self.Dialog[_PlayerID][PageID];
    end
end

function Lib.DialogSystem.Global:GetPageIDByName(_PlayerID, _Name)
    if type(_Name) == "string" then
        if self.Dialog[_PlayerID] ~= nil then
            for i= 1, #self.Dialog[_PlayerID], 1 do
                if type(self.Dialog[_PlayerID][i]) == "table" and self.Dialog[_PlayerID][i].Name == _Name then
                    return i;
                end
            end
        end
        return 0;
    end
    return _Name;
end

function Lib.DialogSystem.Global:CanStartDialog(_PlayerID)
    return self.Dialog[_PlayerID] == nil
           and not IsCinematicEventActive(_PlayerID)
           and self.LoadscreenClosed;
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.DialogSystem.Local:Initialize()
    if not self.IsInstalled then
        Report.DialogStarted = CreateReport("Event_DialogStarted");
        Report.DialogEnded = CreateReport("Event_DialogEnded");
        Report.DialogPageShown = CreateReport("Event_DialogPageShown");
        Report.DialogOptionSelected = CreateReport("Event_DialogOptionSelected");

        self:OverrideThroneRoomFunctions();

        -- Garbage collection
        Lib.DialogSystem.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.DialogSystem.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.DialogSystem.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.EscapePressed then
        -- Nothing to do?
    elseif _ID == Report.DialogStarted then
        self:StartDialog(arg[1], arg[2], arg[3]);
    elseif _ID == Report.DialogEnded then
        self:EndDialog(arg[1], arg[2], arg[3]);
    elseif _ID == Report.DialogPageShown then
        self:DisplayPage(arg[1], arg[2], arg[3]);
    end
end

function Lib.DialogSystem.Local:StartDialog(_PlayerID, _DialogName, _Dialog)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.Dialog[_PlayerID] = _Dialog;
    self.Dialog[_PlayerID].CurrentPage = 0;
    local PosX, PosY = Camera.RTS_GetLookAtPosition();
    local Rotation = Camera.RTS_GetRotationAngle();
    local ZoomFactor = Camera.RTS_GetZoomFactor();
    local SpeedFactor = Game.GameTimeGetFactor(_PlayerID);
    local SubX, SubY = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/AlignBottomLeft/SubTitles");
    self.Dialog[_PlayerID].Backup = {
        SubTitles = {SubX, SubY},
        Camera    = {PosX, PosY, Rotation, ZoomFactor},
        Speed     = SpeedFactor,
    };

    DeactivateNormalInterface(_PlayerID);
    DeactivateBorderScroll(_PlayerID);

    if not Framework.IsNetworkGame() then
        Game.GameTimeSetFactor(_PlayerID, 1);
    end
    self:ActivateCinematicMode(_PlayerID);
end

function Lib.DialogSystem.Local:EndDialog(_PlayerID, _DialogName, _Dialog)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end

    if self.Dialog[_PlayerID].RestoreGameSpeed and not Framework.IsNetworkGame() then
        Game.GameTimeSetFactor(_PlayerID, self.Dialog[_PlayerID].Backup.Speed);
    end
    if self.Dialog[_PlayerID].RestoreCamera then
        Camera.RTS_SetLookAtPosition(self.Dialog[_PlayerID].Backup.Camera[1], self.Dialog[_PlayerID].Backup.Camera[2]);
        Camera.RTS_SetRotationAngle(self.Dialog[_PlayerID].Backup.Camera[3]);
        Camera.RTS_SetZoomFactor(self.Dialog[_PlayerID].Backup.Camera[4]);
    end
    StopVoice("DialogSpeech");

    self:DeactivateCinematicMode(_PlayerID);
    ActivateNormalInterface(_PlayerID);
    ActivateBorderScroll(_PlayerID);
    Lib.UITools.Widget:UpdateHiddenWidgets();

    self.Dialog[_PlayerID] = nil;
    Display.SetRenderFogOfWar(1);
    Display.SetRenderBorderPins(1);
    Display.SetRenderSky(0);
end

function Lib.DialogSystem.Local:DisplayPage(_PlayerID, _PageID, _PageData)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.Dialog[_PlayerID][_PageID] = _PageData;
    self.Dialog[_PlayerID].CurrentPage = _PageID;

    if type(self.Dialog[_PlayerID][_PageID]) == "table" then
        self.Dialog[_PlayerID][_PageID].Started = Logic.GetTime();
        self:DisplayPageFader(_PlayerID, _PageID);
        self:DisplayPagePosition(_PlayerID, _PageID);
        self:DisplayPageActor(_PlayerID, _PageID);
        self:DisplayPageTitle(_PlayerID, _PageID);
        self:DisplayPageText(_PlayerID, _PageID);
        if self.Dialog[_PlayerID][_PageID].MC then
            self:DisplayPageOptionsDialog(_PlayerID, _PageID);
        end
    end
end

function Lib.DialogSystem.Local:DisplayPagePosition(_PlayerID, _PageID)
    local Page = self.Dialog[_PlayerID][_PageID];
    -- Camera
    Camera.RTS_FollowEntity(0);
    if Page.Position then
        local Position = Page.Position;
        if type(Position) ~= "table" then
            Position = GetPosition(Page.Position);
        end
        Camera.RTS_SetLookAtPosition(Position.X, Position.Y);
    elseif Page.Target then
        Camera.RTS_FollowEntity(GetID(Page.Target));
    else
        assert(false);
    end
    Camera.RTS_SetRotationAngle(Page.Rotation);
    Camera.RTS_SetZoomFactor(Page.Distance / 18000);
    -- FIXME: This does not work?
    Camera.RTS_SetZoomAngle(Page.Angle);
end

function Lib.DialogSystem.Local:DisplayPageFader(_PlayerID, _PageID)
    local Page = self.Dialog[_PlayerID][_PageID];
    g_Fade.To = Page.FaderAlpha or 0;

    local PageFadeIn = Page.FadeIn;
    if PageFadeIn then
        FadeIn(PageFadeIn);
    end

    local PageFadeOut = Page.FadeOut;
    if PageFadeOut then
        self.Dialog[_PlayerID].FaderJob = RequestHiResJob(function(_Time, _FadeOut)
            if Logic.GetTimeMs() > _Time - (_FadeOut * 1000) then
                FadeOut(_FadeOut);
                return true;
            end
        end, Logic.GetTimeMs() + ((Page.Duration or 0) * 1000), PageFadeOut);
    end
end

function Lib.DialogSystem.Local:DisplayPageActor(_PlayerID, _PageID)
    local PortraitWidget = "/InGame/Root/Normal/AlignBottomLeft/Message";
    XGUIEng.ShowWidget(PortraitWidget, 1);
    XGUIEng.ShowAllSubWidgets(PortraitWidget, 1);
    XGUIEng.ShowWidget(PortraitWidget.. "/QuestLog", 0);
    XGUIEng.ShowWidget(PortraitWidget.. "/Update", 0);
    local Page = self.Dialog[_PlayerID][_PageID];
    if not Page.Actor or Page.Actor == -1 then
        XGUIEng.ShowWidget(PortraitWidget, 0);
        return;
    end
    local Actor = self:GetPageActor(_PlayerID, _PageID);
    self:DisplayActorPortrait(_PlayerID, Actor);
end

function Lib.DialogSystem.Local:GetPageActor(_PlayerID, _PageID)
    local Actor = g_PlayerPortrait[_PlayerID];
    local Page = self.Dialog[_PlayerID][_PageID];
    if type(Page.Actor) == "string" then
        Actor = Page.Actor;
    elseif type(Page.Actor) == "number" then
        Actor = g_PlayerPortrait[Page.Actor];
    end
    -- If someone doesn't read the fucking manual...
    if not Models["Heads_" .. tostring(Actor)] then
        Actor = "H_NPC_Generic_Trader";
    end
    return Actor;
end

function Lib.DialogSystem.Local:DisplayPageTitle(_PlayerID, _PageID)
    local PortraitWidget = "/InGame/Root/Normal/AlignBottomLeft/Message";
    local Page = self.Dialog[_PlayerID][_PageID];
    if Page.Title then
        local Title = ConvertPlaceholders(Localize(Page.Title));
        if Title:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
            Title = XGUIEng.GetStringTableText(Title);
        end
        if Title:sub(1, 1) ~= "{" then
            Title = "{center}" ..Title;
        end
        XGUIEng.SetText(PortraitWidget.. "/MessagePortrait/PlayerName", Title);
        XGUIEng.ShowWidget(PortraitWidget.. "/MessagePortrait/PlayerName", 1);
    else
        XGUIEng.ShowWidget(PortraitWidget.. "/MessagePortrait/PlayerName", 0);
    end
end

function Lib.DialogSystem.Local:DisplayPageText(_PlayerID, _PageID)
    self:ResetSubtitlesPosition(_PlayerID);
    local Page = self.Dialog[_PlayerID][_PageID];
    local SubtitlesWidget = "/InGame/Root/Normal/AlignBottomLeft/SubTitles";
    if not Page or not Page.Text or Page.Text == "" then
        XGUIEng.SetText(SubtitlesWidget.. "/VoiceText1", " ");
        XGUIEng.ShowWidget(SubtitlesWidget, 0);
        return;
    end
    XGUIEng.ShowWidget(SubtitlesWidget, 1);
    XGUIEng.ShowWidget(SubtitlesWidget.. "/Update", 0);
    XGUIEng.ShowWidget(SubtitlesWidget.. "/VoiceText1", 1);
    XGUIEng.ShowWidget(SubtitlesWidget.. "/BG", 1);

    local Text = ConvertPlaceholders(Localize(Page.Text));
    local Extension = "";
    if not Page.AutoSkip and not Page.MC then
        Extension = ConvertPlaceholders(Localize(Lib.DialogSystem.Text.Continue));
    end
    XGUIEng.SetText(SubtitlesWidget.. "/VoiceText1", Text .. Extension);
    self:SetSubtitlesPosition(_PlayerID, _PageID);

    StopVoice("DialogSpeech");
    if Page and Page.Speech then
        PlayVoice(Page.Speech, "DialogSpeech");
    end
end

function Lib.DialogSystem.Local:SetSubtitlesPosition(_PlayerID, _PageID)
    local Page = self.Dialog[_PlayerID][_PageID];
    local MotherWidget = "/InGame/Root/Normal/AlignBottomLeft/SubTitles";
    local Height = XGUIEng.GetTextHeight(MotherWidget.. "/VoiceText1", true);
    local W, H = XGUIEng.GetWidgetSize(MotherWidget.. "/VoiceText1");
    local X,Y = XGUIEng.GetWidgetLocalPosition(MotherWidget);
    if Page.Actor then
        XGUIEng.SetWidgetSize(MotherWidget.. "/BG", W + 10, Height + 120);
        Y = 675 - Height;
        XGUIEng.SetWidgetLocalPosition(MotherWidget, X, Y);
    else
        XGUIEng.SetWidgetSize(MotherWidget.. "/BG", W + 10, Height + 35);
        Y = 1115 - Height;
        XGUIEng.SetWidgetLocalPosition(MotherWidget, 46, Y);
    end
end

function Lib.DialogSystem.Local:ResetSubtitlesPosition(_PlayerID)
    local Position = self.Dialog[_PlayerID].Backup.SubTitles;
    local SubtitleWidget = "/InGame/Root/Normal/AlignBottomLeft/SubTitles";
    XGUIEng.SetWidgetLocalPosition(SubtitleWidget, Position[1], Position[2]);
end

-- This is needed to reset the timer buttons after the portrait widget has been
-- abused to show the actor in the dialog.
function Lib.DialogSystem.Local:ResetTimerButtons(_PlayerID)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    if not g_Interaction.TimerQuests then
        return;
    end
    local MainWidget = "/InGame/Root/Normal/AlignTopLeft/QuestTimers/";
    for i= 1,6 do
        local ButtonWidget = MainWidget ..i.. "/TimerButton";
        local QuestIndex = g_Interaction.TimerQuests[i];
        if QuestIndex ~= nil then
            local Quest = Quests[QuestIndex];
            if g_Interaction.CurrentMessageQuestIndex == QuestIndex and not QuestLog.IsQuestLogShown() then
                g_Interaction.CurrentMessageQuestIndex = nil;
                g_VoiceMessageIsRunning = false;
                g_VoiceMessageEndTime = nil;
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait", 0);
                XGUIEng.ShowWidget(QuestLog.Widget.Main, 0);
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles", 0);
                XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0);
                XGUIEng.HighLightButton(ButtonWidget, 0);
            end
            if Quest then
                self:DisplayActorPortrait(Quest.SendingPlayer);
            end
        end
    end
end

function Lib.DialogSystem.Local:DisplayActorPortrait(_PlayerID, _HeadModel)
    local PortraitWidget = "/InGame/Root/Normal/AlignBottomLeft/Message";
    local Actor = g_PlayerPortrait[_PlayerID];
    if _HeadModel then
        -- Just because I am paranoid... Should never happen.
        if not Models["Heads_" .. tostring(_HeadModel)] then
            _HeadModel = "H_NPC_Generic_Trader";
        end
        Actor = _HeadModel;
    end
    XGUIEng.ShowWidget(PortraitWidget.. "/MessagePortrait", 1);
    XGUIEng.ShowWidget(PortraitWidget.. "/QuestObjectives", 0);
    -- FIXME
    SetPortraitWithCameraSettings(PortraitWidget.. "/MessagePortrait/3DPortraitFaceFX", Actor);
    GUI.PortraitWidgetSetRegister(PortraitWidget.. "/MessagePortrait/3DPortraitFaceFX", "Mood_Friendly", 1,2,0);
    GUI.PortraitWidgetSetRegister(PortraitWidget.. "/MessagePortrait/3DPortraitFaceFX", "Mood_Angry", 1,2,0);
end

function Lib.DialogSystem.Local:DisplayPageOptionsDialog(_PlayerID, _PageID)
    local Widget = "/InGame/SoundOptionsMain/RightContainer/SoundProviderComboBoxContainer";
    local Screen = {GUI.GetScreenSize()};
    local Page = self.Dialog[_PlayerID][_PageID];
    local Listbox = XGUIEng.GetWidgetID(Widget .. "/ListBox");

    -- Save original coordinates of sound provider selection
    self.Dialog[_PlayerID].MCSelectionBoxPosition = {
        XGUIEng.GetWidgetScreenPosition(Widget)
    };

    -- Fill sound provider selection with options
    XGUIEng.ListBoxPopAll(Listbox);
    self.Dialog[_PlayerID].MCSelectionOptionsMap = {};
    for i=1, #Page.MC, 1 do
        if Page.MC[i].Visible ~= false then
            XGUIEng.ListBoxPushItem(Listbox, Page.MC[i][1]);
            table.insert(self.Dialog[_PlayerID].MCSelectionOptionsMap, Page.MC[i].ID);
        end
    end
    XGUIEng.ListBoxSetSelectedIndex(Listbox, 0);

    -- Set choice position
    local ChoiceSize = {XGUIEng.GetWidgetScreenSize(Widget)};
    local CX = math.ceil((Screen[1] * 0.05) + (ChoiceSize[1] /2));
    local CY = math.ceil(Screen[2] - (ChoiceSize[2] + 60 * (Screen[2]/540)));
    if not Page.Actor then
        CX = 15 * (Screen[1]/960);
        CY = math.ceil(Screen[2] - (ChoiceSize[2] + 0 * (Screen[2]/540)));
    end
    XGUIEng.SetWidgetScreenPosition(Widget, CX, CY);
    XGUIEng.PushPage(Widget, false);
    XGUIEng.ShowWidget(Widget, 1);

    -- Set text position
    if not Page.Actor then
        local TextWidget = "/InGame/Root/Normal/AlignBottomLeft/SubTitles";
        local DX,DY = XGUIEng.GetWidgetLocalPosition(TextWidget);
        XGUIEng.SetWidgetLocalPosition(TextWidget, DX, DY-220);
    end

    self.Dialog[_PlayerID].MCSelectionIsShown = true;
end

function Lib.DialogSystem.Local:OnOptionSelected(_PlayerID)
    local Widget = "/InGame/SoundOptionsMain/RightContainer/SoundProviderComboBoxContainer";
    local Position = self.Dialog[_PlayerID].MCSelectionBoxPosition;
    XGUIEng.SetWidgetScreenPosition(Widget, Position[1], Position[2]);
    XGUIEng.ShowWidget(Widget, 0);
    XGUIEng.PopPage();

    local Selected = XGUIEng.ListBoxGetSelectedIndex(Widget .. "/ListBox")+1;
    local AnswerID = self.Dialog[_PlayerID].MCSelectionOptionsMap[Selected];

    SendReport(Report.DialogOptionSelected, _PlayerID, AnswerID);
    SendReportToGlobal(Report.DialogOptionSelected, _PlayerID, AnswerID);
end

function Lib.DialogSystem.Local:ThroneRoomCameraControl(_PlayerID, _Page)
    if _Page then
        if self.Dialog[_PlayerID].MCSelectionIsShown then
            local Widget = "/InGame/SoundOptionsMain/RightContainer/SoundProviderComboBoxContainer";
            if XGUIEng.IsWidgetShown(Widget) == 0 then
                self.Dialog[_PlayerID].MCSelectionIsShown = false;
                self:OnOptionSelected(_PlayerID);
            end
        end
    end
end

function Lib.DialogSystem.Local:ConvertPosition(_Table)
    local Position = _Table;
    if type(Position) ~= "table" then
        Position = GetPosition(_Table);
    end
    return Position.X, Position.Y, Position.Z;
end

function Lib.DialogSystem.Local:GetCurrentDialog(_PlayerID)
    return self.Dialog[_PlayerID];
end

function Lib.DialogSystem.Local:GetCurrentDialogPage(_PlayerID)
    if self.Dialog[_PlayerID] then
        local PageID = self.Dialog[_PlayerID].CurrentPage;
        return self.Dialog[_PlayerID][PageID];
    end
end

function Lib.DialogSystem.Local:GetPageIDByName(_PlayerID, _Name)
    if type(_Name) == "string" then
        if self.Dialog[_PlayerID] ~= nil then
            for i= 1, #self.Dialog[_PlayerID], 1 do
                if type(self.Dialog[_PlayerID][i]) == "table" and self.Dialog[_PlayerID][i].Name == _Name then
                    return i;
                end
            end
        end
        return 0;
    end
    return _Name;
end

function Lib.DialogSystem.Local:IsAnyCinematicEventActive(_PlayerID)
    for k, v in pairs(Lib.Information.Local.CinematicEventStatus[_PlayerID]) do
        if v == 1 then
            return true;
        end
    end
    return false;
end

function Lib.DialogSystem.Local:OverrideThroneRoomFunctions()
    -- We only need this to update the sound provider list box for the multiple
    -- choice options. We do not even use the throneroom camera.
    self.Orig_GameCallback_Lib_Camera_ThroneroomCameraControl = GameCallback_Lib_Camera_ThroneroomCameraControl;
    GameCallback_Lib_Camera_ThroneroomCameraControl = function(_PlayerID)
        Lib.DialogSystem.Local.Orig_GameCallback_Lib_Camera_ThroneroomCameraControl(_PlayerID);
        if _PlayerID == GUI.GetPlayerID() then
            local Dialog = Lib.DialogSystem.Local:GetCurrentDialog(_PlayerID);
            if Dialog ~= nil then
                Lib.DialogSystem.Local:ThroneRoomCameraControl(
                    _PlayerID,
                    Lib.DialogSystem.Local:GetCurrentDialogPage(_PlayerID)
                );
            end
        end
    end
end

function Lib.DialogSystem.Local:ActivateCinematicMode(_PlayerID)
    -- Check for cinematic mode running and UI player
    if self.CinematicActive or GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.CinematicActive = true;

    -- Pop loadscreen if visible
    if not self.LoadscreenClosed then
        XGUIEng.PopPage();
    end

    -- Show throneroom updater
    XGUIEng.ShowWidget("/InGame/ThroneRoom", 1);
    XGUIEng.PushPage("/InGame/ThroneRoom/Main", false);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_Dodge", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2_Dodge", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/KnightInfo", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main", 1);
    XGUIEng.ShowAllSubWidgets("/InGame/ThroneRoom/Main", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/updater", 1);

    -- Show message stuff
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechButtons/SpeechStartAgainOrStop", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/Update", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles/Update", 0);
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionDialog/Text", " ");
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionDialog/Title", " ");
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionDialog/Objectives", " ");

    if self.Dialog[_PlayerID].HideNotes then
        XGUIEng.ShowWidget("/InGame/Root/Normal/NotesWindow", 0);
    end

    -- Change ui state for cinematic
    self.SelectionBackup = {GUI.GetSelectedEntities()};
    GUI.ClearSelection();
    GUI.ClearNotes();
    GUI.ForbidContextSensitiveCommandsInSelectionState();
    GUI.ActivateCutSceneState();
    GUI.SetFeedbackSoundOutputState(0);
    GUI.EnableBattleSignals(false);
    Input.CutsceneMode();
    if not self.Dialog[_PlayerID].EnableFoW then
        Display.SetRenderFogOfWar(0);
    end
    if self.Dialog[_PlayerID].EnableSky then
        Display.SetRenderSky(1);
    end
    if not self.Dialog[_PlayerID].EnableBorderPins then
        Display.SetRenderBorderPins(0);
    end
    Display.SetUserOptionOcclusionEffect(0);
    Camera.SwitchCameraBehaviour(0);

    -- Prepare the fader
    InitializeFader();
    g_Fade.To = 0;
    SetFaderAlpha(0);

    if not self.LoadscreenClosed then
        XGUIEng.PushPage("/LoadScreen/LoadScreen", false);
    end
end

function Lib.DialogSystem.Local:DeactivateCinematicMode(_PlayerID)
    -- Check for cinematic mode running and UI player
    if not self.CinematicActive or GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.CinematicActive = false;

    -- Reset ui state
    g_Fade.To = 0;
    SetFaderAlpha(0);
    XGUIEng.PopPage();
    Camera.SwitchCameraBehaviour(0);
    Display.UseStandardSettings();
    Input.GameMode();
    GUI.EnableBattleSignals(true);
    GUI.SetFeedbackSoundOutputState(1);
    GUI.ActivateSelectionState();
    GUI.PermitContextSensitiveCommandsInSelectionState();
    for k, v in pairs(self.SelectionBackup) do
        GUI.SelectEntity(v);
    end
    Display.SetRenderSky(0);
    Display.SetRenderBorderPins(1);
    Display.SetRenderFogOfWar(1);
    if  Options.GetIntValue("Display", "Occlusion", 0) > 0 then
        Display.SetUserOptionOcclusionEffect(1);
    end

    -- Hide the message stuff
    XGUIEng.SetText("/InGame/Root/Normal/AlignBottomLeft/SubTitles/VoiceText1", " ");
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechButtons/SpeechStartAgainOrStop", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/SpeechStartAgainOrStop", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/Update", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles/Update", 1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait", 0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/SubTitles", 0);

    -- Reset the throneroom
    XGUIEng.PopPage();
    XGUIEng.ShowWidget("/InGame/ThroneRoom", 0);

    if self.Dialog[_PlayerID].HideNotes then
        XGUIEng.ShowWidget("/InGame/Root/Normal/NotesWindow", 1);
    end

    ResetRenderDistance();
    self:ResetSubtitlesPosition(_PlayerID);
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.DialogSystem.Name);

