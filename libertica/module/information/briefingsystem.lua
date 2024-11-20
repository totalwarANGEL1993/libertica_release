Lib.BriefingSystem = Lib.BriefingSystem or {};
Lib.BriefingSystem.Name = "BriefingSystem";
Lib.BriefingSystem.Global = {
    Briefing = {},
    BriefingQueue = {},
    BriefingCounter = 0,
};
Lib.BriefingSystem.Local = {
    Config = {
        DoAlternateGraphics = true,
    },
    ParallaxWidgets = {
        Pushed = {},
        -- Can not set UV coordinates for this... :(
        -- {"/EndScreen/EndScreen/BG", "/EndScreen/EndScreen"},
        {"/EndScreen/EndScreen/BackGround", "/EndScreen/EndScreen"},
        -- Can not set UV coordinates for this... :(
        -- {"/InGame/MissionStatistic/BG", "/InGame/MissionStatistic"},
        {"/InGame/Root/EndScreen/BlackBG", "/InGame/Root/EndScreen"},
        {"/InGame/Root/EndScreen/BG", "/InGame/Root/EndScreen"},
        {"/InGame/Root/BlackStartScreen/BG", "/InGame/Root/BlackStartScreen"},
        -- Can not set UV coordinates for this... :(
        -- {"/InGame/Root/PresentationLoadingScreen/BG", "/InGame/Root/PresentationLoadingScreen"},
    },
    Briefing = {},
};

CONST_BRIEFING = {
    TIMER_PER_CHAR = 0.175,
    CAMERA_ANGLEDEFAULT = 43,
    CAMERA_ROTATIONDEFAULT = -45,
    CAMERA_ZOOMDEFAULT = 9000,
    CAMERA_FOVDEFAULT = 42,
    DLGCAMERA_ANGLEDEFAULT = 36,
    DLGCAMERA_ROTATIONDEFAULT = -45,
    DLGCAMERA_ZOOMDEFAULT = 3500,
    DLGCAMERA_FOVDEFAULT = 25,
};

Lib.Require("comfort/IsMultiplayer");
Lib.Require("core/Core");
Lib.Require("module/settings/Sound");
Lib.Require("module/ui/UIEffects");
Lib.Require("module/ui/UITools");
Lib.Require("module/information/Requester");
Lib.Require("module/information/BriefingSystem_Text");
Lib.Require("module/information/BriefingSystem_API");
Lib.Require("module/information/BriefingSystem_Behavior");
Lib.Register("module/information/BriefingSystem");

CinematicEventTypes.Briefing = 2;

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.BriefingSystem.Global:Initialize()
    if not self.IsInstalled then
        Report.BriefingStarted = CreateReport("Event_BriefingStarted");
        Report.BriefingEnded = CreateReport("Event_BriefingEnded");
        Report.BriefingPageShown = CreateReport("Event_BriefingPageShown");
        Report.BriefingOptionSelected = CreateReport("Event_BriefingOptionSelected");
        Report.BriefingLeftClick = CreateReport("Event_BriefingLeftClick");
        Report.BriefingSkipButtonPressed = CreateReport("Event_BriefingSkipButtonPressed");

        for i= 1, 8 do
            self.BriefingQueue[i] = {};
        end
        -- Updates the dialog queue for all players
        RequestHiResJob(function()
            Lib.BriefingSystem.Global:UpdateQueue();
            Lib.BriefingSystem.Global:BriefingExecutionController();
        end);

        -- Garbage collection
        Lib.BriefingSystem.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.BriefingSystem.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.BriefingSystem.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.EscapePressed then
        -- TODO fix problem with throneroom
    elseif _ID == Report.BriefingStarted then
        self:NextPage(arg[1]);
    elseif _ID == Report.BriefingEnded then
        SendReportToLocal(Report.BriefingEnded, arg[1], arg[2]);
    elseif _ID == Report.BriefingPageShown then
        SendReportToLocal(Report.BriefingPageShown, arg[1], arg[2]);
    elseif _ID == Report.BriefingOptionSelected then
        self:OnOptionSelected(arg[1], arg[2]);
    elseif _ID == Report.BriefingSkipButtonPressed then
        self:SkipButtonPressed(arg[1]);
    end
end

function Lib.BriefingSystem.Global:UpdateQueue()
    for PlayerID = 1, 8 do
        if self:CanStartBriefing(PlayerID) then
            local Next = Lib.UIEffects.Global:LookUpCinematicInQueue(PlayerID);
            if Next and Next[1] == CinematicEventTypes.Briefing then
                self:NextBriefing(PlayerID);
            end
        end
    end
end

function Lib.BriefingSystem.Global:BriefingExecutionController()
    for PlayerID = 1, 8 do
        if self.Briefing[PlayerID] and not self.Briefing[PlayerID].DisplayIngameCutscene then
            local PageID = self.Briefing[PlayerID].CurrentPage;
            local Page = self.Briefing[PlayerID][PageID];

            -- Player selected option
            if self.Briefing[PlayerID].RequestOptionEvaluation then
                self.Briefing[PlayerID].RequestOptionEvaluation = nil;
                local OptionID = self.Briefing[PlayerID].RequestOptionEvaluation;
                if Page.MC then
                    local Option;
                    for i= 1, #Page.MC, 1 do
                        if Page.MC[i].ID == OptionID then
                            Option = Page.MC[i];
                        end
                    end
                    if Option ~= nil then
                        local Target = Option[2];
                        if type(Option[2]) == "function" then
                            Target = Option[2](PlayerID, PageID, OptionID);
                        end
                        self.Briefing[PlayerID][PageID].MC.Selected = Option.ID;
                        self.Briefing[PlayerID].CurrentPage = self:GetPageIDByName(PlayerID, Target) -1;
                        self:NextPage(PlayerID);
                    end
                end
            -- Player skips page
            elseif self.Briefing[PlayerID].RequestPageSkip then
                self.Briefing[PlayerID].RequestPageSkip = nil;
                if self.Briefing[PlayerID][PageID].OnForward then
                    self.Briefing[PlayerID][PageID]:OnForward();
                end
                self:NextPage(PlayerID);
            -- Auto Skip
            else
                if Page and not Page.MC and Page.Duration > 0 then
                    if (Page.Started + Page.Duration) < Logic.GetTime() then
                        self:NextPage(PlayerID);
                    end
                end
            end
        end
    end
end

function Lib.BriefingSystem.Global:CreateBriefingGetPage(_Briefing)
    _Briefing.GetPage = _Briefing.GetPage or function(this, _NameOrID)
        local ID = Lib.BriefingSystem.Global:GetPageIDByName(_Briefing.PlayerID, _NameOrID);
        return Lib.BriefingSystem.Global.Briefing[_Briefing.PlayerID][ID];
    end
end

function Lib.BriefingSystem.Global:CreateBriefingAddPage(_Briefing)
    _Briefing.AddPage = _Briefing.AddPage or function(this, _Page)
        -- Briefing length
        this.Length = (this.Length or 0) +1;
        -- Animations
        _Briefing.PageAnimation = _Briefing.PageAnimation or {};
        -- Parallaxes
        _Briefing.PageParallax = _Briefing.PageParallax or {};

        -- Set page name
        local Identifier = "Page" ..(#this +1);
        if _Page.Name then
            Identifier = _Page.Name;
        else
            _Page.Name = Identifier;
        end

        -- Make page legit
        _Page.__Legit = true;
        -- Language
        _Page.Title = Localize(_Page.Title or "");
        _Page.Text = Localize(_Page.Text or "");

        -- Bars
        if _Page.BigBars == nil then
            _Page.BigBars = true;
        end

        -- Simple camera animation
        if _Page.Position then
            -- Fill angle
            if not _Page.Angle then
                _Page.Angle = CONST_BRIEFING.CAMERA_ANGLEDEFAULT;
                if _Page.DialogCamera then
                    _Page.Angle = CONST_BRIEFING.DLGCAMERA_ANGLEDEFAULT;
                end
            end
            -- Fill rotation
            if not _Page.Rotation then
                _Page.Rotation = CONST_BRIEFING.CAMERA_ROTATIONDEFAULT;
                if _Page.DialogCamera then
                    _Page.Rotation = CONST_BRIEFING.DLGCAMERA_ROTATIONDEFAULT;
                end
            end
            -- Fill zoom
            if not _Page.Zoom then
                _Page.Zoom = CONST_BRIEFING.CAMERA_ZOOMDEFAULT;
                if _Page.DialogCamera then
                    _Page.Zoom = CONST_BRIEFING.DLGCAMERA_ZOOMDEFAULT;
                end
            end
            -- Optional fly to
            local Position2, Rotation2, Zoom2, Angle2;
            if _Page.FlyTo then
                Position2 = _Page.FlyTo.Position or _Page.Position;
                Rotation2 = _Page.FlyTo.Rotation or _Page.Rotation;
                Zoom2     = _Page.FlyTo.Zoom or _Page.Zoom;
                Angle2    = _Page.FlyTo.Angle or _Page.Angle;
            end
            -- Create the animation
            _Briefing.PageAnimation[Identifier] = {
                Clear = true,
                {math.abs(_Page.Duration or 1),
                 _Page.Position, _Page.Rotation, _Page.Zoom, _Page.Angle,
                 Position2, Rotation2, Zoom2, Angle2}
            };
        end

        -- Field of View
        if not _Page.FOV then
            if _Page.DialogCamera then
                _Page.FOV = CONST_BRIEFING.DLGCAMERA_FOVDEFAULT;
            else
                _Page.FOV = CONST_BRIEFING.CAMERA_FOVDEFAULT;
            end
        end

        -- Display time
        if not _Page.Duration then
            if not _Page.Position then
                _Page.DisableSkipping = false;
                _Page.Duration = -1;
            else
                if _Page.DisableSkipping == nil then
                    _Page.DisableSkipping = false;
                end
                _Page.Duration = _Page.Text:len() * CONST_BRIEFING.TIMER_PER_CHAR;
                _Page.Duration = (_Page.Duration < 6 and 6) or _Page.Duration;
            end
        end

        -- Multiple choice selection
        _Page.GetSelected = function(_Data)
            return 0;
        end
        -- Return page
        table.insert(this, _Page);
        return _Page;
    end
end

function Lib.BriefingSystem.Global:CreateBriefingAddMCPage(_Briefing)
    _Briefing.AddMCPage = _Briefing.AddMCPage or function(this, _Page)
        -- Create base page
        local Page = this:AddPage(_Page);

        -- Multiple choice selection
        Page.GetSelected = function(_Data)
            if _Data.MC then
                return _Data.MC.Selected;
            end
            return 0;
        end

        -- Multiple Choice
        if Page.MC then
            for i= 1, #Page.MC do
                Page.MC[i][1] = Localize(Page.MC[i][1]);
                Page.MC[i].ID = Page.MC[i].ID or i;
            end
            Page.BigBars = true;
            Page.DisableSkipping = true;
            Page.Duration = -1;
        end
        -- Return page
        return Page;
    end
end

function Lib.BriefingSystem.Global:CreateBriefingAddRedirect(_Briefing)
    _Briefing.AddRedirect = _Briefing.AddRedirect or function(this, _Target)
        -- Dialog length
        this.Length = (this.Length or 0) +1;
        -- Return page
        local Page = (_Target == nil and -1) or _Target;
        table.insert(this, Page);
        return Page;
    end
end

function Lib.BriefingSystem.Global:StartBriefing(_Name, _PlayerID, _Data)
    self.BriefingQueue[_PlayerID] = self.BriefingQueue[_PlayerID] or {};
    Lib.UIEffects.Global:PushCinematicEventToQueue(
        _PlayerID,
        CinematicEventTypes.Briefing,
        _Name,
        _Data
    );
end

function Lib.BriefingSystem.Global:EndBriefing(_PlayerID)
    collectgarbage("collect");
    Logic.SetGlobalInvulnerability(0);
    local Briefing = self.Briefing[_PlayerID];
    SendReport(Report.BriefingEnded, _PlayerID, Briefing.Name);
    if Briefing.Finished then
        Briefing:Finished();
    end
    FinishCinematicEvent(Briefing.Name, _PlayerID);
    self.Briefing[_PlayerID] = nil;
end

function Lib.BriefingSystem.Global:NextBriefing(_PlayerID)
    if self:CanStartBriefing(_PlayerID) then
        local BriefingData = Lib.UIEffects.Global:PopCinematicEventFromQueue(_PlayerID);
        assert(BriefingData[1] == CinematicEventTypes.Briefing);
        StartCinematicEvent(BriefingData[2], _PlayerID);

        local Briefing = BriefingData[3];
        Briefing.Name = BriefingData[2];
        Briefing.PlayerID = _PlayerID;
        Briefing.CurrentPage = 0;
        self.Briefing[_PlayerID] = Briefing;
        self:TransformAnimations(_PlayerID);
        self:TransformParallaxes(_PlayerID);

        if Briefing.EnableGlobalImmortality then
            Logic.SetGlobalInvulnerability(1);
        end
        if self.Briefing[_PlayerID].Starting then
            self.Briefing[_PlayerID]:Starting();
        end

        -- This is an exception from the rule that the global event is send
        -- before the local event! For timing reasons...
        SendReportToLocal(Report.BriefingStarted, _PlayerID, Briefing.Name, Briefing);
    end
end

function Lib.BriefingSystem.Global:TransformAnimations(_PlayerID)
    if self.Briefing[_PlayerID].PageAnimation then
        for Name, v in pairs(self.Briefing[_PlayerID].PageAnimation) do
            local PageID = self:GetPageIDByName(_PlayerID, Name);
            if PageID ~= 0 then
                self.Briefing[_PlayerID][PageID].Animations = {};
                self.Briefing[_PlayerID][PageID].Animations.Repeat = v.Repeat == true;
                self.Briefing[_PlayerID][PageID].Animations.Clear = v.Clear == true;
                for i= 1, #v, 1 do
                    local Entry = {};
                    Entry.Source = Name;
                    Entry.Local = v.Local == true;
                    Entry.Interpolation = v[i].Interpolation;
                    Entry.Duration = v[i][1] or (2 * 60);
                    if v[i][2] and type(v[i][4]) ~= "table" then
                        Entry.Start = {
                            Position = (type(v[i][2]) ~= "table" and {v[i][2],0}) or v[i][2],
                            Rotation = v[i][3] or CONST_BRIEFING.CAMERA_ROTATIONDEFAULT,
                            Zoom     = v[i][4] or CONST_BRIEFING.CAMERA_ZOOMDEFAULT,
                            Angle    = v[i][5] or CONST_BRIEFING.CAMERA_ANGLEDEFAULT,
                        };
                        local EndPosition = v[i][6] or Entry.Start.Position;
                        Entry.End = {
                            Position = (type(EndPosition) ~= "table" and {EndPosition,0}) or EndPosition,
                            Rotation = v[i][7] or Entry.Start.Rotation,
                            Zoom     = v[i][8] or Entry.Start.Zoom,
                            Angle    = v[i][9] or Entry.Start.Angle,
                        };
                        table.insert(self.Briefing[_PlayerID][PageID].Animations, Entry);
                    else
                       Entry.AnimFrames = {};
                       for j= 2, #v[i] do
                           table.insert(Entry.AnimFrames, v[i][j]);
                       end
                    end
                    table.insert(self.Briefing[_PlayerID][PageID].Animations, Entry);
                end
            end
        end
        self.Briefing[_PlayerID].PageAnimation = nil;
    end
end

function Lib.BriefingSystem.Global:TransformParallaxes(_PlayerID)
    if self.Briefing[_PlayerID].PageParallax then
        for Name, v in pairs(self.Briefing[_PlayerID].PageParallax) do
            local PageID = self:GetPageIDByName(_PlayerID, Name);
            if PageID ~= 0 then
                self.Briefing[_PlayerID][PageID].Parallax = {};
                self.Briefing[_PlayerID][PageID].Parallax.Repeat = v.Repeat == true;
                self.Briefing[_PlayerID][PageID].Parallax.Clear = v.Clear == true;
                for i= 1, 4, 1 do
                    if v[i] then
                        local Entry = {};
                        Entry.Source = Name;
                        Entry.Local = v.Local == true;
                        Entry.Image = v[i][1];
                        Entry.Interpolation = v[i].Interpolation;
                        Entry.Duration = v[i][2] or (2 * 60);
                        Entry.AnimData = {};
                        for j= 3, #v[i] do
                            table.insert(Entry.AnimData, v[i][j]);
                        end
                        self.Briefing[_PlayerID][PageID].Parallax[i] = Entry;
                    end
                end
            end
        end
        self.Briefing[_PlayerID].PageParallax = nil;
    end
end

function Lib.BriefingSystem.Global:NextPage(_PlayerID)
    if self.Briefing[_PlayerID] == nil then
        return;
    end

    self.Briefing[_PlayerID].CurrentPage = self.Briefing[_PlayerID].CurrentPage +1;
    local PageID = self.Briefing[_PlayerID].CurrentPage;
    if PageID == -1 or PageID == 0 then
        self:EndBriefing(_PlayerID);
        return;
    end

    local Page = self.Briefing[_PlayerID][PageID];
    if type(Page) == "table" then
        if PageID <= #self.Briefing[_PlayerID] then
            self.Briefing[_PlayerID][PageID].Started = Logic.GetTime();
            self.Briefing[_PlayerID][PageID].Duration = Page.Duration or -1;
            if self.Briefing[_PlayerID][PageID].Action then
                self.Briefing[_PlayerID][PageID]:Action();
            end
            self:DisplayPage(_PlayerID, PageID);
        else
            self:EndBriefing(_PlayerID);
        end
    elseif type(Page) == "number" or type(Page) == "string" then
        local Target = self:GetPageIDByName(_PlayerID, self.Briefing[_PlayerID][PageID]);
        self.Briefing[_PlayerID].CurrentPage = Target -1;
        self:NextPage(_PlayerID);
    else
        self:EndBriefing(_PlayerID);
    end
end

function Lib.BriefingSystem.Global:DisplayPage(_PlayerID, _PageID)
    if self.Briefing[_PlayerID] == nil then
        return;
    end

    local Page = self.Briefing[_PlayerID][_PageID];
    if type(Page) == "table" then
        local PageID = self.Briefing[_PlayerID].CurrentPage;
        if Page.MC then
            for i= 1, #Page.MC, 1 do
                if type(Page.MC[i][3]) == "function" then
                    self.Briefing[_PlayerID][PageID].MC[i].Visible = Page.MC[i][3](_PlayerID, PageID, i);
                end
            end
        end
    end

    SendReport(Report.BriefingPageShown, _PlayerID, _PageID);
end

function Lib.BriefingSystem.Global:SkipButtonPressed(_PlayerID, _PageID)
    if not self.Briefing[_PlayerID] then
        return;
    end
    self.Briefing[_PlayerID].RequestPageSkip = true;
end

function Lib.BriefingSystem.Global:OnOptionSelected(_PlayerID, _OptionID)
    if self.Briefing[_PlayerID] == nil then
        return;
    end
    local PageID = self.Briefing[_PlayerID].CurrentPage;
    if type(self.Briefing[_PlayerID][PageID]) ~= "table" then
        return;
    end
    self.Briefing[_PlayerID].RequestOptionEvaluation = _OptionID;

    local Page = self.Briefing[_PlayerID][PageID];
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
            self.Briefing[_PlayerID][PageID].MC.Selected = Option.ID;
            self.Briefing[_PlayerID].CurrentPage = self:GetPageIDByName(_PlayerID, Target) -1;
            self:NextPage(_PlayerID);
        end
    end
end

function Lib.BriefingSystem.Global:GetCurrentBriefing(_PlayerID)
    return self.Briefing[_PlayerID];
end

function Lib.BriefingSystem.Global:GetCurrentBriefingPage(_PlayerID)
    if self.Briefing[_PlayerID] then
        local PageID = self.Briefing[_PlayerID].CurrentPage;
        return self.Briefing[_PlayerID][PageID];
    end
end

function Lib.BriefingSystem.Global:GetPageIDByName(_PlayerID, _Name)
    if type(_Name) == "string" then
        if self.Briefing[_PlayerID] ~= nil then
            for i= 1, #self.Briefing[_PlayerID], 1 do
                if type(self.Briefing[_PlayerID][i]) == "table" and self.Briefing[_PlayerID][i].Name == _Name then
                    return i;
                end
            end
        end
        return 0;
    end
    return _Name;
end

function Lib.BriefingSystem.Global:CanStartBriefing(_PlayerID)
    return  self.Briefing[_PlayerID] == nil and
            not IsCinematicEventActive(_PlayerID) and
            self.LoadscreenClosed;
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.BriefingSystem.Local:Initialize()
    if not self.IsInstalled then
        Report.BriefingStarted = CreateReport("Event_BriefingStarted");
        Report.BriefingEnded = CreateReport("Event_BriefingEnded");
        Report.BriefingPageShown = CreateReport("Event_BriefingPageShown");
        Report.BriefingOptionSelected = CreateReport("Event_BriefingOptionSelected");
        Report.BriefingLeftClick = CreateReport("Event_BriefingLeftClick");
        Report.BriefingSkipButtonPressed = CreateReport("Event_BriefingSkipButtonPressed");

        self:OverrideThroneRoomFunctions();

        -- Garbage collection
        Lib.BriefingSystem.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.BriefingSystem.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.BriefingSystem.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.EscapePressed then
        -- TODO fix problem with throneroom
    elseif _ID == Report.BriefingStarted then
        self:StartBriefing(arg[1], arg[2], arg[3]);
    elseif _ID == Report.BriefingEnded then
        self:EndBriefing(arg[1], arg[2]);
    elseif _ID == Report.BriefingPageShown then
        self:DisplayPage(arg[1], arg[2]);
    end
end

function Lib.BriefingSystem.Local:StartBriefing(_PlayerID, _BriefingName, _Briefing)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.Briefing[_PlayerID] = _Briefing;
    self.Briefing[_PlayerID].LastSkipButtonPressed = 0;
    self.Briefing[_PlayerID].CurrentPage = 0;
    local PosX, PosY = Camera.RTS_GetLookAtPosition();
    local Rotation = Camera.RTS_GetRotationAngle();
    local ZoomFactor = Camera.RTS_GetZoomFactor();
    local SpeedFactor = Game.GameTimeGetFactor(_PlayerID);
    self.Briefing[_PlayerID].Backup = {
        Camera = {PosX, PosY, Rotation, ZoomFactor},
        Throneroom = {0, 0},
        Speed  = SpeedFactor,
    };

    DeactivateNormalInterface(_PlayerID);
    DeactivateBorderScroll(_PlayerID);

    if not Framework.IsNetworkGame() then
        Game.GameTimeSetFactor(_PlayerID, 1);
        if _Briefing.PreloadAssets then
            ActivateColoredScreen(_PlayerID, 0, 0, 0, 255);
            Lib.Core.Local:Preload_ViewWholeMap();
        end
    end

    SendReportToGlobal(Report.BriefingStarted, _PlayerID, _Briefing.Name);
    RequestHiResDelay(1, function()
        self:ActivateCinematicMode(_PlayerID);
    end);
end

function Lib.BriefingSystem.Local:EndBriefing(_PlayerID, _BriefingName)
    collectgarbage("collect");
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end

    local Briefing = self.Briefing[_PlayerID];

    if not Framework.IsNetworkGame() and Briefing.PreloadAssets then
        Lib.Core.Local:Preload_ResetView();
    end
    if Briefing.RestoreGameSpeed and not Framework.IsNetworkGame() then
        Game.GameTimeSetFactor(_PlayerID, Briefing.Backup.Speed);
    end
    if Briefing.RestoreCamera then
        Camera.RTS_SetLookAtPosition(Briefing.Backup.Camera[1], Briefing.Backup.Camera[2]);
        Camera.RTS_SetRotationAngle(Briefing.Backup.Camera[3]);
        Camera.RTS_SetZoomFactor(Briefing.Backup.Camera[4]);
    else
        Throneroom = self.Briefing[_PlayerID].Throneroom;
        Camera.RTS_SetLookAtPosition(Throneroom[1], Throneroom[2]);
    end
    StopVoice("BriefingSpeech");

    self:DeactivateCinematicMode(_PlayerID);
    ActivateNormalInterface(_PlayerID);
    ActivateBorderScroll(_PlayerID);
    Lib.UITools.Widget:UpdateHiddenWidgets();

    self.Briefing[_PlayerID] = nil;
    Display.SetRenderFogOfWar(1);
    Display.SetRenderBorderPins(1);
    Display.SetRenderSky(0);
end

function Lib.BriefingSystem.Local:DisplayPage(_PlayerID, _PageID)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.Briefing[_PlayerID].AnimationQueue = self.Briefing[_PlayerID].AnimationQueue or {};
    self.Briefing[_PlayerID].ParallaxLayers = self.Briefing[_PlayerID].ParallaxLayers or {};
    self.Briefing[_PlayerID].CurrentPage = _PageID;
    if type(self.Briefing[_PlayerID][_PageID]) == "table" then
        self.Briefing[_PlayerID][_PageID].Started = Logic.GetTime();
        self:SetPageFarClipPlane(_PlayerID, _PageID);
        self:SetRender(_PlayerID, _PageID);
        self:DisplayPageBars(_PlayerID, _PageID);
        self:DisplayPageTitle(_PlayerID, _PageID);
        self:DisplayPageText(_PlayerID, _PageID);
        self:DisplayPageControls(_PlayerID, _PageID);
        self:DisplayPageAnimation(_PlayerID, _PageID);
        self:DisplayPageFader(_PlayerID, _PageID);
        self:DisplayPageParallaxes(_PlayerID, _PageID);
        if self.Briefing[_PlayerID][_PageID].MC then
            self:DisplayPageOptionsDialog(_PlayerID, _PageID);
        end
    end
end

function Lib.BriefingSystem.Local:SetPageFarClipPlane(_PlayerID, _PageID)
    ResetRenderDistance();
    local Page = self.Briefing[_PlayerID][_PageID];
    if Page.FarClipPlane then
        SetRenderDistance(Page.FarClipPlane);
    end
end

function Lib.BriefingSystem.Local:SetRender(_PlayerID, _PageID)
    local Page = self.Briefing[_PlayerID][_PageID];
    if Page.Performance then
        self:SetPerformanceMode();
    else
        self:SetQualityMode();
    end
end

function Lib.BriefingSystem.Local:SetPerformanceMode()
    Display.SetUserOptionAnimationQuality(0);
    Display.SetUserOptionAnisotropy(0);
    Display.SetUserOptionReflections(0);
    Display.SetUserOptionTerrainQuality(0);
    Display.SetRenderObjectsAlphaBlendPass(0);
    Display.SetRenderUseBatching(0);
    Display.SetRenderUpdateMorphAnim(0);
    Display.SetEffectOption("DoNotUseRimLight", 1);
    Display.SetEffectOption("SimpleWater", 1);
end

function Lib.BriefingSystem.Local:SetQualityMode()
    local AnimationQuality = Display.GetUserOptionMaxAnimationQuality();
    local FilterQuality = Display.GetUserOptionMaxAnisotropy();
    local ReflectionQuality = Display.GetUserOptionMaxReflections();
    local TerrainQuality = Display.GetUserOptionMaxTerrainQuality();
    Display.SetUserOptionAnimationQuality(AnimationQuality);
    Display.SetUserOptionAnisotropy(FilterQuality);
    Display.SetUserOptionReflections(ReflectionQuality);
    Display.SetUserOptionTerrainQuality(TerrainQuality);
    Display.SetRenderObjectsAlphaBlendPass(1);
    Display.SetRenderUseBatching(1);
    Display.SetRenderUpdateMorphAnim(1);
    Display.SetEffectOption("DoNotUseRimLight", 0);
    Display.SetEffectOption("SimpleWater", 0);
end

function Lib.BriefingSystem.Local:DisplayPageBars(_PlayerID, _PageID)
    local Page = self.Briefing[_PlayerID][_PageID];
    local Opacity = (Page.BarOpacity ~= nil and Page.BarOpacity) or 1;
    local OpacityBig = (255 * Opacity);
    local OpacitySmall = (255 * Opacity);

    local BigVisibility = (Page.BigBars and 1) or 0;
    local SmallVisibility = (Page.BigBars and 0) or 1;
    if Opacity == 0 then
        BigVisibility = 0;
        SmallVisibility = 0;
    end

    XGUIEng.ShowWidget("/InGame/ThroneRoomBars", BigVisibility);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2", SmallVisibility);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_Dodge", BigVisibility);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2_Dodge", SmallVisibility);

    XGUIEng.SetMaterialAlpha("/InGame/ThroneRoomBars/BarBottom", 1, OpacityBig);
    XGUIEng.SetMaterialAlpha("/InGame/ThroneRoomBars/BarTop", 1, OpacityBig);
    XGUIEng.SetMaterialAlpha("/InGame/ThroneRoomBars_2/BarBottom", 1, OpacitySmall);
    XGUIEng.SetMaterialAlpha("/InGame/ThroneRoomBars_2/BarTop", 1, OpacitySmall);
end

function Lib.BriefingSystem.Local:DisplayPageTitle(_PlayerID, _PageID)
    local Page = self.Briefing[_PlayerID][_PageID];
    local TitleWidget = "/InGame/ThroneRoom/Main/DialogTopChooseKnight/ChooseYourKnight";
    XGUIEng.SetText(TitleWidget, "");
    if Page.Title then
        local Title = ConvertPlaceholders(Localize(Page.Title));
        if Title:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
            Title = XGUIEng.GetStringTableText(Title);
        end
        if Title:sub(1, 1) ~= "{" then
            Title = "{@color:255,250,0,255}{center}" ..Title;
        end
        XGUIEng.SetText(TitleWidget, Title);
    end
end

function Lib.BriefingSystem.Local:DisplayPageText(_PlayerID, _PageID)
    local Page = self.Briefing[_PlayerID][_PageID];
    local TextWidget = "/InGame/ThroneRoom/Main/MissionBriefing/Text";
    XGUIEng.SetText(TextWidget, "");
    if Page.Text then
        local Text = ConvertPlaceholders(Localize(Page.Text));
        if Text:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
            Text = XGUIEng.GetStringTableText(Text);
        end
        if Text:sub(1, 1) ~= "{" then
            Text = "{center}" ..Text;
        end
        if not Page.BigBars then
            Text = "{cr}{cr}{cr}" .. Text;
        end
        XGUIEng.SetText(TextWidget, Text);
    end
    StopVoice("BriefingSpeech");
    if Page.Speech then
        PlayVoice(Page.Speech, "BriefingSpeech");
    end
end

function Lib.BriefingSystem.Local:DisplayPageControls(_PlayerID, _PageID)
    local Page = self.Briefing[_PlayerID][_PageID];
    local SkipFlag = 1;

    SkipFlag = ((Page.Duration == nil or Page.Duration == -1) and 1) or 0;
    if Page.DisableSkipping ~= nil then
        SkipFlag = (Page.DisableSkipping and 0) or 1;
    end
    if Page.MC ~= nil then
        SkipFlag = 0;
    end
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Skip", SkipFlag);
end

function Lib.BriefingSystem.Local:DisplayPageAnimation(_PlayerID, _PageID)
    local Page = self.Briefing[_PlayerID][_PageID];
    if Page.Animations then
        local Postponed = {};
        -- Clear animations
        if Page.Animations.Clear then
            self.Briefing[_PlayerID].CurrentAnimation = nil;
            self.Briefing[_PlayerID].AnimationQueue = {};
        -- Postpone animations and clear
        elseif Page.Animations.Postpone then
            if self.Briefing[_PlayerID].CurrentAnimation then
                local Animation = table.copy(self.Briefing[_PlayerID].CurrentAnimation);
                local Factor = self:GetInterpolationFactor(_PlayerID, true);
                Animation.Completion = Factor;
                table.insert(Postponed, Animation);
            end
            for i= 1, #self.Briefing[_PlayerID].AnimationQueue do
                local Animation = table.copy(self.Briefing[_PlayerID].AnimationQueue[i]);
                table.insert(Postponed, Animation);
            end
            self.Briefing[_PlayerID].CurrentAnimation = nil;
            self.Briefing[_PlayerID].AnimationQueue = {};
        end
        -- Fill animation queue
        for i= 1, #Page.Animations do
            local Animation = table.copy(Page.Animations[i]);
            table.insert(self.Briefing[_PlayerID].AnimationQueue, Animation);
        end
        for i= 1, #Postponed do
            table.insert(self.Briefing[_PlayerID].AnimationQueue, Postponed[i]);
        end
        -- Remove page local animations
        if self.Briefing[_PlayerID].CurrentAnimation then
            local Animation = self.Briefing[_PlayerID].CurrentAnimation;
            if Animation.Local and Page.Name ~= Animation.Source then
                self.Briefing[_PlayerID].CurrentAnimation = nil;
            end
        end
        for i= #self.Briefing[_PlayerID].AnimationQueue, 1, -1 do
            local Animation = self.Briefing[_PlayerID].AnimationQueue[i];
            if Animation.Local and Page.Name ~= Animation.Source then
                table.remove(self.Briefing[_PlayerID].AnimationQueue, i);
            end
        end
    end
end

function Lib.BriefingSystem.Local:DisplayPageFader(_PlayerID, _PageID)
    local Page = self.Briefing[_PlayerID][_PageID];
    g_Fade.To = Page.FaderAlpha or 0;

    local PageFadeIn = Page.FadeIn;
    if PageFadeIn then
        FadeIn(PageFadeIn);
    end

    local PageFadeOut = Page.FadeOut;
    if PageFadeOut then
        self.Briefing[_PlayerID].FaderJob = RequestHiResJob(function(_Time, _FadeOut)
            if Logic.GetTimeMs() > _Time - (_FadeOut * 1000) then
                FadeOut(_FadeOut);
                return true;
            end
        end, Logic.GetTimeMs() + ((Page.Duration or 0) * 1000), PageFadeOut);
    end
end

function Lib.BriefingSystem.Local:DisplayPageParallaxes(_PlayerID, _PageID)
    local Page = self.Briefing[_PlayerID][_PageID];
    if Page.Parallax then
        if Page.Parallax.Clear then
            for i= 1, #self.ParallaxWidgets do
                XGUIEng.SetMaterialTexture(self.ParallaxWidgets[i][1], 1, "");
                XGUIEng.SetMaterialColor(self.ParallaxWidgets[i][1], 1, 255, 255, 255, 0);
            end
            self.Briefing[_PlayerID].ParallaxLayers = {};
        end
        for i= 1, 4, 1 do
            if Page.Parallax[i] then
                local Animation = table.copy(Page.Parallax[i]);
                Animation.Started = XGUIEng.GetSystemTime();
                self.Briefing[_PlayerID].ParallaxLayers[i] = Animation;
            end
        end
    end
end

function Lib.BriefingSystem.Local:ControlParallaxes(_PlayerID)
    if self.Briefing[_PlayerID].ParallaxLayers then
        local CurrentTime = XGUIEng.GetSystemTime();
        for Index, Data in pairs(self.Briefing[_PlayerID].ParallaxLayers) do
            local Widget = self.ParallaxWidgets[Index][1];
            local Size = {GUI.GetScreenSize()};

            local Factor = math.lerp(Data.Started, CurrentTime, Data.Duration);
            if Factor > 1 and Data.Repeat then
                self.Briefing[_PlayerID].ParallaxLayers[Index].Started = CurrentTime;
                Factor = math.lerp(Data.Started, CurrentTime, Data.Duration);
            end
            if Data.Interpolation then
                Factor = math.min(Data:Interpolation(CurrentTime), 1);
            end
            if type(Data.Modulation) == "function" then
                Factor = Data:Modulation(CurrentTime, Factor);
            end
            Factor = math.min(math.max(Factor, 0), 1);

            local Image = Data.Image;
            if type(Image) == "function" then
                Image = Data:Image(Factor, Data.Started, CurrentTime, Data.Duration);
            end
            if type(Image) == "table" then
                local CurrentImageIndex = math.min(math.ceil(#Image * Factor), #Image);
                Image = Image[CurrentImageIndex];
            end

            local u0,v0,u1,v1,Alpha = 0, 0, 1, 1, 255;
            if Data.AnimData then
                if Data.AnimData[3] and type(Data.AnimData[3]) ~= "table" then
                    u0,v0,u1,v1,Alpha = unpack(Data.AnimData);
                else
                    if #Data.AnimData >= 2 then
                        u0,v0,u1,v1,Alpha = self:BezierCurveParallax(
                            Factor,
                            unpack(Data.AnimData)
                        );
                    end
                end
            end
            if Size[1]/Size[2] < 1.6 then
                u0 = u0 + (u0 / 0.125);
                u1 = u1 - (u1 * 0.125);
            end

            XGUIEng.SetMaterialColor(Widget, 0, 255, 255, 255, Alpha or 255);
            XGUIEng.SetMaterialTexture(Widget, 0, Image);
            XGUIEng.SetMaterialUV(Widget, 0, u0, v0, u1, v1);
        end
    end
end

function Lib.BriefingSystem.Local:DisplayPageOptionsDialog(_PlayerID, _PageID)
    local Widget = "/InGame/SoundOptionsMain/RightContainer/SoundProviderComboBoxContainer";
    local Screen = {GUI.GetScreenSize()};
    local Page = self.Briefing[_PlayerID][_PageID];
    local Listbox = XGUIEng.GetWidgetID(Widget .. "/ListBox");

    self.Briefing[_PlayerID].MCSelectionBoxPosition = {
        XGUIEng.GetWidgetScreenPosition(Widget)
    };

    XGUIEng.ListBoxPopAll(Listbox);
    self.Briefing[_PlayerID].MCSelectionOptionsMap = {};
    for i=1, #Page.MC, 1 do
        if Page.MC[i].Visible ~= false then
            XGUIEng.ListBoxPushItem(Listbox, Page.MC[i][1]);
            table.insert(self.Briefing[_PlayerID].MCSelectionOptionsMap, Page.MC[i].ID);
        end
    end
    XGUIEng.ListBoxSetSelectedIndex(Listbox, 0);

    local wSize = {XGUIEng.GetWidgetScreenSize(Widget)};
    local xFix = math.ceil((Screen[1] /2) - (wSize[1] /2));
    local yFix = math.ceil(Screen[2] - (wSize[2] -10));
    if Page.Text and Page.Text ~= "" then
        yFix = math.ceil((Screen[2] /2) - (wSize[2] /2));
    end
    XGUIEng.SetWidgetScreenPosition(Widget, xFix, yFix);
    XGUIEng.PushPage(Widget, false);
    XGUIEng.ShowWidget(Widget, 1);
    self.Briefing[_PlayerID].MCSelectionIsShown = true;
end

function Lib.BriefingSystem.Local:OnOptionSelected(_PlayerID)
    local Widget = "/InGame/SoundOptionsMain/RightContainer/SoundProviderComboBoxContainer";
    local Position = self.Briefing[_PlayerID].MCSelectionBoxPosition;
    XGUIEng.SetWidgetScreenPosition(Widget, Position[1], Position[2]);
    XGUIEng.ShowWidget(Widget, 0);
    XGUIEng.PopPage();

    local Selected = XGUIEng.ListBoxGetSelectedIndex(Widget .. "/ListBox")+1;
    local AnswerID = self.Briefing[_PlayerID].MCSelectionOptionsMap[Selected];

    SendReport(Report.BriefingOptionSelected, _PlayerID, AnswerID);
    SendReportToGlobal(Report.BriefingOptionSelected, _PlayerID, AnswerID);
end

function Lib.BriefingSystem.Local:ThroneRoomCameraControl(_PlayerID, _Page)
    if _Page then
        -- Camera
        self:ControlCameraAnimation(_PlayerID);
        local FOV = (type(_Page) == "table" and _Page.FOV) or 42;
        local PX, PY, PZ, LX, LY, LZ = 0, 0, 0, 0, 0, 0;
        local CurrentAnimation = self.Briefing[_PlayerID].CurrentAnimation;
        if CurrentAnimation and CurrentAnimation.AnimFrames then
            if #CurrentAnimation.AnimFrames >= 2 then
                local Factor = self:GetInterpolationFactor(_PlayerID, true);
                if CurrentAnimation.Completion then
                    Factor = math.max(Factor, CurrentAnimation.Completion);
                end
                PX, PY, PZ, LX, LY, LZ = self:SplineCurve(
                    Factor,
                    unpack(CurrentAnimation.AnimFrames)
                );
            else
                PX, PY, PZ, LX, LY, LZ = unpack(CurrentAnimation.AnimFrames[1]);
            end
        else
            PX, PY, PZ = self:GetPagePosition(_PlayerID);
            LX, LY, LZ = self:GetPageLookAt(_PlayerID);
            if PX and not LX then
                LX, LY, LZ, PX, PY, PZ, FOV = self:GetCameraProperties(_PlayerID, FOV);
            end
        end
        Camera.ThroneRoom_SetPosition(PX, PY, PZ);
        Camera.ThroneRoom_SetLookAt(LX, LY, LZ);
        Camera.ThroneRoom_SetFOV(FOV);
        self.Briefing[_PlayerID].Throneroom = {LX, LY};

        -- Parallax
        self:ControlParallaxes(_PlayerID);

        -- Multiple Choice
        if self.Briefing[_PlayerID].MCSelectionIsShown then
            local Widget = "/InGame/SoundOptionsMain/RightContainer/SoundProviderComboBoxContainer";
            if XGUIEng.IsWidgetShown(Widget) == 0 then
                self.Briefing[_PlayerID].MCSelectionIsShown = false;
                self:OnOptionSelected(_PlayerID);
            end
        end

        -- Button texts
        local SkipText = Localize(Lib.BriefingSystem.Text.NextButton);
        local PageID = self.Briefing[_PlayerID].CurrentPage;
        if PageID == #self.Briefing[_PlayerID] or self.Briefing[_PlayerID][PageID+1] == -1 then
            SkipText = Localize(Lib.BriefingSystem.Text.EndButton);
        end
        XGUIEng.SetText("/InGame/ThroneRoom/Main/Skip", "{center}" ..SkipText);
    end
end

function Lib.BriefingSystem.Local:ControlCameraAnimation(_PlayerID)
    if self.Briefing[_PlayerID].CurrentAnimation then
        local CurrentTime = XGUIEng.GetSystemTime();
        local Animation = self.Briefing[_PlayerID].CurrentAnimation;
        if CurrentTime > Animation.Started + Animation.Duration then
            if #self.Briefing[_PlayerID].AnimationQueue > 0 then
                self.Briefing[_PlayerID].CurrentAnimation = nil;
            end
        end
    end
    if self.Briefing[_PlayerID].CurrentAnimation == nil then
        if self.Briefing[_PlayerID].AnimationQueue and #self.Briefing[_PlayerID].AnimationQueue > 0 then
            local PageID = self.Briefing[_PlayerID].CurrentPage;
            local Page = self.Briefing[_PlayerID][PageID];
            local Next = table.remove(self.Briefing[_PlayerID].AnimationQueue, 1);
            if Page and Page.Animations and Page.Animations.Repeat then
                table.insert(self.Briefing[_PlayerID].AnimationQueue, Next);
            end
            Next.Started = XGUIEng.GetSystemTime();
            self.Briefing[_PlayerID].CurrentAnimation = Next;
        end
    end
end

function Lib.BriefingSystem.Local:GetPagePosition(_PlayerID)
    local x, y, z = 0,0,0;
    local Position, FlyTo;
    if self.Briefing[_PlayerID].CurrentAnimation then
        Position = self.Briefing[_PlayerID].CurrentAnimation.Start.Position;
        FlyTo = self.Briefing[_PlayerID].CurrentAnimation.End;
        x, y, z = self:ConvertPosition(Position);
        if FlyTo then
            local lX, lY, lZ = self:ConvertPosition(FlyTo.Position);
            if lX and lY and lZ then
                x = x + (lX - x) * self:GetInterpolationFactor(_PlayerID);
                y = y + (lY - y) * self:GetInterpolationFactor(_PlayerID);
                z = z + (lZ - z) * self:GetInterpolationFactor(_PlayerID);
            end
        end
    end
    return x, y, z;
end

function Lib.BriefingSystem.Local:GetPageLookAt(_PlayerID)
    local LookAt, FlyTo;
    if self.Briefing[_PlayerID].CurrentAnimation then
        LookAt = self.Briefing[_PlayerID].CurrentAnimation.Start.LookAt;
        FlyTo = self.Briefing[_PlayerID].CurrentAnimation.End;
    end

    local x, y, z = self:ConvertPosition(LookAt);
    if FlyTo and x then
        local lX, lY, lZ = self:ConvertPosition(FlyTo.LookAt);
        if lX and lY and lZ then
            x = x + (lX - x) * self:GetInterpolationFactor(_PlayerID);
            y = y + (lY - y) * self:GetInterpolationFactor(_PlayerID);
            z = z + (lZ - z) * self:GetInterpolationFactor(_PlayerID);
        end
    end
    return x, y, z;
end

function Lib.BriefingSystem.Local:ConvertPosition(_Table)
    local x, y, z;
    if _Table and type(_Table) == "table" then
        if _Table.X then
            x = _Table.X;
            y = _Table.Y;
            z = _Table.Z;
        elseif _Table[3] then
            x = _Table[1];
            y = _Table[2];
            z = _Table[3];
        else
            x, y, z = Logic.EntityGetPos(GetID(_Table[1]));
            z = z + (_Table[2] or 0);
        end
    end
    return x, y, z;
end

function Lib.BriefingSystem.Local:GetInterpolationFactor(_PlayerID, _Modulate)
    if self.Briefing[_PlayerID].CurrentAnimation then
        local CurrentTime = XGUIEng.GetSystemTime();
        local Data = self.Briefing[_PlayerID].CurrentAnimation;
        local Factor = 1;
        if Data.Interpolation then
            Factor = Data:Interpolation(CurrentTime);
        else
            Factor = math.lerp(
                self.Briefing[_PlayerID].CurrentAnimation.Started,
                CurrentTime,
                self.Briefing[_PlayerID].CurrentAnimation.Duration
            );
        end
        if type(Data.Modulation) == "function" then
            Factor = Data:Modulation(CurrentTime, Factor);
        elseif _Modulate then
            Factor = self:ModulateInterpolationFactor(Factor);
        end
        return math.min(math.max(Factor, 0), 1);
    end
    return 1;
end

function Lib.BriefingSystem.Local:ModulateInterpolationFactor(_Factor)
    return (1 / (0.97 + math.exp(-8 * (_Factor - 0.5)))) - 0.01;
end

function Lib.BriefingSystem.Local:SplineCurve(_Factor, ...)
    local Points = {...};
    local n = #Points;
    _Factor = math.max(0, math.min(1, _Factor));

    -- Calculate camera position
    local posSegment = math.floor((n - 1) * _Factor) + 1;
    local localTPos = (_Factor * (n - 1)) % 1;

    local p0 = Points[math.max(1, posSegment - 1)];
    local p1 = Points[posSegment];
    local p2 = Points[math.min(posSegment + 1, n)];
    local p3 = Points[math.min(posSegment + 2, n)];

    local x1 = self:CatmullRom(localTPos, p0[1], p1[1], p2[1], p3[1]);
    local y1 = self:CatmullRom(localTPos, p0[2], p1[2], p2[2], p3[2]);
    local z1 = self:CatmullRom(localTPos, p0[3], p1[3], p2[3], p3[3]);

    -- Calculate camera target
    local lookSegment = math.floor((n - 1) * _Factor) + 1;
    local localTLook = (_Factor * (n - 1)) % 1;

    local l0 = Points[math.max(1, lookSegment - 1)];
    local l1 = Points[lookSegment];
    local l2 = Points[math.min(lookSegment + 1, n)];
    local l3 = Points[math.min(lookSegment + 2, n)];

    local x2 = self:CatmullRom(localTLook, l0[4], l1[4], l2[4], l3[4]);
    local y2 = self:CatmullRom(localTLook, l0[5], l1[5], l2[5], l3[5]);
    local z2 = self:CatmullRom(localTLook, l0[6], l1[6], l2[6], l3[6]);

    return x1, y1, z1, x2, y2, z2;
end

function Lib.BriefingSystem.Local:CatmullRom(t, p0, p1, p2, p3)
    local t2 = t * t;
    local t3 = t2 * t;

    local c0 = -0.5 * t3 + t2 - 0.5 * t;
    local c1 = 1.5 * t3 - 2.5 * t2 + 1;
    local c2 = -1.5 * t3 + 2 * t2 + 0.5 * t;
    local c3 = 0.5 * t3 - 0.5 * t2;

    return c0 * p0 + c1 * p1 + c2 * p2 + c3 * p3;
end

function Lib.BriefingSystem.Local:BezierCurveParallax(_Factor, ...)
    _Factor = math.max(0, math.min(1, _Factor));
    local Points = {...};
    local n = #Points;
    local U0, V0, U1, V1, A = 0, 0, 0, 0, 0;
    for i = 1, n do
        local f = self:BernsteinPolynome(n - 1, i - 1, _Factor);
        U0 = U0 + Points[i][1] * f;
        V0 = V0 + Points[i][2] * f;
        U1 = U1 + Points[i][3] * f;
        V1 = V1 + Points[i][4] * f;
        A  = A  + Points[i][5] * f;
    end
    return U0, V0, U1, V1, A;
end

function Lib.BriefingSystem.Local:BernsteinPolynome(n, i, t)
    return (math.factorial(n) / (math.factorial(i) * math.factorial(n - i))) * (t ^ i) * ((1 - t) ^ (n - i));
end

function Lib.BriefingSystem.Local:GetCameraProperties(_PlayerID, _FOV)
    local CurrPage, FlyTo;
    if self.Briefing[_PlayerID].CurrentAnimation then
        CurrPage = self.Briefing[_PlayerID].CurrentAnimation.Start;
        FlyTo = self.Briefing[_PlayerID].CurrentAnimation.End;
    end

    local startPosition = CurrPage.Position;
    local endPosition = (FlyTo and FlyTo.Position) or CurrPage.Position;
    local startRotation = CurrPage.Rotation;
    local endRotation = (FlyTo and FlyTo.Rotation) or CurrPage.Rotation;
    local startZoomAngle = CurrPage.Angle;
    local endZoomAngle = (FlyTo and FlyTo.Angle) or CurrPage.Angle;
    local startZoomDistance = CurrPage.Zoom;
    local endZoomDistance = (FlyTo and FlyTo.Zoom) or CurrPage.Zoom;

    local factor = self:GetInterpolationFactor(_PlayerID);

    local lPLX, lPLY, lPLZ = self:ConvertPosition(startPosition);
    local cPLX, cPLY, cPLZ = self:ConvertPosition(endPosition);
    local lookAtX = lPLX + (cPLX - lPLX) * factor;
    local lookAtY = lPLY + (cPLY - lPLY) * factor;
    local lookAtZ = lPLZ + (cPLZ - lPLZ) * factor;

    local zoomDistance = startZoomDistance + (endZoomDistance - startZoomDistance) * factor;
    local zoomAngle = startZoomAngle + (endZoomAngle - startZoomAngle) * factor;
    local rotation = startRotation + (endRotation - startRotation) * factor;
    local line = zoomDistance * math.cos(math.rad(zoomAngle));
    local positionX = lookAtX + math.cos(math.rad(rotation - 90)) * line;
    local positionY = lookAtY + math.sin(math.rad(rotation - 90)) * line;
    local positionZ = lookAtZ + (zoomDistance) * math.sin(math.rad(zoomAngle));

    return lookAtX, lookAtY, lookAtZ, positionX, positionY, positionZ, _FOV;
end

function Lib.BriefingSystem.Local:SkipButtonPressed(_PlayerID)
    if not self.Briefing[_PlayerID] then
        return;
    end
    if (self.Briefing[_PlayerID].LastSkipButtonPressed + 5) < Logic.GetCurrentTurn() then
        self.Briefing[_PlayerID].LastSkipButtonPressed = Logic.GetCurrentTurn();

        SendReportToGlobal(Report.BriefingSkipButtonPressed, _PlayerID);
        SendReport(Report.BriefingSkipButtonPressed, _PlayerID);
    end
end

function Lib.BriefingSystem.Local:GetCurrentBriefing(_PlayerID)
    return self.Briefing[_PlayerID];
end

function Lib.BriefingSystem.Local:GetCurrentBriefingPage(_PlayerID)
    if self.Briefing[_PlayerID] then
        local PageID = self.Briefing[_PlayerID].CurrentPage;
        return self.Briefing[_PlayerID][PageID];
    end
end

function Lib.BriefingSystem.Local:GetPageIDByName(_PlayerID, _Name)
    if type(_Name) == "string" then
        if self.Briefing[_PlayerID] ~= nil then
            for i= 1, #self.Briefing[_PlayerID], 1 do
                if type(self.Briefing[_PlayerID][i]) == "table" and self.Briefing[_PlayerID][i].Name == _Name then
                    return i;
                end
            end
        end
        return 0;
    end
    return _Name;
end

function Lib.BriefingSystem.Local:OverrideThroneRoomFunctions()
    self.Orig_GameCallback_Lib_Camera_ThroneRoomLeftClick = GameCallback_Lib_Camera_ThroneRoomLeftClick;
    GameCallback_Lib_Camera_ThroneRoomLeftClick = function(_PlayerID)
        Lib.BriefingSystem.Local.Orig_GameCallback_Lib_Camera_ThroneRoomLeftClick(_PlayerID);
        if _PlayerID == GUI.GetPlayerID() then
            SendReportToGlobal(Report.BriefingLeftClick, _PlayerID);
            SendReport(Report.BriefingLeftClick, _PlayerID);
        end
    end

    self.Orig_GameCallback_Lib_Camera_SkipButtonPressed = GameCallback_Lib_Camera_SkipButtonPressed;
    GameCallback_Lib_Camera_SkipButtonPressed = function(_PlayerID)
        Lib.BriefingSystem.Local.Orig_GameCallback_Lib_Camera_SkipButtonPressed(_PlayerID);
        if _PlayerID == GUI.GetPlayerID() then
            Lib.BriefingSystem.Local:SkipButtonPressed(_PlayerID);
        end
    end

    self.Orig_GameCallback_Lib_Camera_ThroneroomCameraControl = GameCallback_Lib_Camera_ThroneroomCameraControl;
    GameCallback_Lib_Camera_ThroneroomCameraControl = function(_PlayerID)
        Lib.BriefingSystem.Local.Orig_GameCallback_Lib_Camera_ThroneroomCameraControl(_PlayerID);
        if _PlayerID == GUI.GetPlayerID() then
            local Briefing = Lib.BriefingSystem.Local:GetCurrentBriefing(_PlayerID);
            if Briefing ~= nil then
                Lib.BriefingSystem.Local:ThroneRoomCameraControl(
                    _PlayerID,
                    Lib.BriefingSystem.Local:GetCurrentBriefingPage(_PlayerID)
                );
            end
        end
    end

    self.Orig_GameCallback_Escape = GameCallback_Escape;
    GameCallback_Escape = function()
        if Lib.BriefingSystem.Local.Briefing[GUI.GetPlayerID()] then
            return;
        end
        Lib.BriefingSystem.Local.Orig_GameCallback_Escape();
    end
end

function Lib.BriefingSystem.Local:ActivateCinematicMode(_PlayerID)
    if self.CinematicActive or GUI.GetPlayerID() ~= _PlayerID then
        return;
    end

    if not self.LoadscreenClosed then
        XGUIEng.PopPage();
    end
    local ScreenX, ScreenY = GUI.GetScreenSize();

    local ConsoleWasVisible = IsScriptConsoleShown();
    if ConsoleWasVisible then
        HideScriptConsole();
    end

    -- Parallax
    function EndScreen_ExitGame() end
    function MissionFadeInEndScreen() end
    for i= 1, #self.ParallaxWidgets do
        XGUIEng.ShowWidget(self.ParallaxWidgets[i][2], 1);
        if not self.ParallaxWidgets.Pushed[self.ParallaxWidgets[i][2]] then
            self.ParallaxWidgets.Pushed[self.ParallaxWidgets[i][2]] = true;
            XGUIEng.PushPage(self.ParallaxWidgets[i][2], false);
        end
        XGUIEng.ShowWidget(self.ParallaxWidgets[i][1], 1);

        XGUIEng.SetMaterialTexture(self.ParallaxWidgets[i][1], 0, "");
        XGUIEng.SetMaterialColor(self.ParallaxWidgets[i][1], 0, 255, 255, 255, 0);
        XGUIEng.SetMaterialUV(self.ParallaxWidgets[i][1], 0, 0, 0, 1, 1);
    end
    XGUIEng.ShowWidget("/EndScreen/EndScreen/BG", 0);
    XGUIEng.ShowWidget("/InGame/Root/PresentationLoadingScreen/Logo", 0);

    -- Throneroom Main
    XGUIEng.ShowWidget("/InGame/ThroneRoom", 1);
    XGUIEng.PushPage("/InGame/ThroneRoomBars", false);
    XGUIEng.PushPage("/InGame/ThroneRoomBars_2", false);
    XGUIEng.PushPage("/InGame/ThroneRoom/Main", false);
    XGUIEng.PushPage("/InGame/ThroneRoomBars_Dodge", false);
    XGUIEng.PushPage("/InGame/ThroneRoomBars_2_Dodge", false);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Skip", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/StartButton", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight/Frame", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight/DialogBG", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight/FrameEdges", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/KnightInfoButton", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogBottomRight3pcs", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/BackButton", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Briefing", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/TitleContainer", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/MissionBriefing/Text", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/MissionBriefing/Title", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/updater", 1);

    -- Text
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Text", " ");
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Title", " ");
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", " ");

    -- Title and back button
    local x,y = XGUIEng.GetWidgetScreenPosition("/InGame/ThroneRoom/Main/DialogTopChooseKnight/ChooseYourKnight");
    XGUIEng.SetWidgetScreenPosition("/InGame/ThroneRoom/Main/DialogTopChooseKnight/ChooseYourKnight", x, 65 * (ScreenY/1080));
    XGUIEng.SetWidgetPositionAndSize("/InGame/ThroneRoom/KnightInfo/Objectives", 2, 0, 2000, 20);

    if self.Briefing[_PlayerID].HideNotes then
        XGUIEng.ShowWidget("/InGame/Root/Normal/NotesWindow", 0);
    end

    self.SelectionBackup = {GUI.GetSelectedEntities()};
    GUI.ClearSelection();
    GUI.ClearNotes();
    GUI.ForbidContextSensitiveCommandsInSelectionState();
    GUI.ActivateCutSceneState();
    GUI.SetFeedbackSoundOutputState(0);
    GUI.EnableBattleSignals(false);
    Input.CutsceneMode();
    if not self.Briefing[_PlayerID].EnableFoW then
        Display.SetRenderFogOfWar(0);
    end
    if self.Briefing[_PlayerID].EnableSky then
        Display.SetRenderSky(1);
    end
    if not self.Briefing[_PlayerID].EnableBorderPins then
        Display.SetRenderBorderPins(0);
    end
    if self:IsChangingGraphicsPermited() then
        Display.SetUserOptionOcclusionEffect(0);
    end
    Camera.SwitchCameraBehaviour(5);

    InitializeFader();
    -- FIX: Push text widgets over the fader
    XGUIEng.PushPage("/InGame/ThroneRoom/Main/MissionBriefing", false);
    g_Fade.To = 0;
    SetFaderAlpha(0);

    if ConsoleWasVisible then
        ShowScriptConsole();
    end
    if not self.LoadscreenClosed then
        XGUIEng.PushPage("/LoadScreen/LoadScreen", false);
    end
    if self.Briefing[_PlayerID].PreloadAssets then
        DeactivateColoredScreen(_PlayerID);
    end
    self.CinematicActive = true;
end

function Lib.BriefingSystem.Local:DeactivateCinematicMode(_PlayerID)
    if not self.CinematicActive or GUI.GetPlayerID() ~= _PlayerID then
        return;
    end

    local ConsoleWasVisible = IsScriptConsoleShown();
    if ConsoleWasVisible then
        HideScriptConsole();
    end

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

    XGUIEng.ShowWidget("/EndScreen/EndScreen/BG", 1);
    XGUIEng.ShowWidget("/InGame/Root/PresentationLoadingScreen/Logo", 1);
    self.ParallaxWidgets.Pushed = {};
    for i= 1, #self.ParallaxWidgets do
        XGUIEng.ShowWidget(self.ParallaxWidgets[i][1], 0);
        XGUIEng.ShowWidget(self.ParallaxWidgets[i][2], 0);
        XGUIEng.PopPage();
    end
    XGUIEng.PopPage();
    XGUIEng.PopPage();
    XGUIEng.PopPage();
    XGUIEng.PopPage();
    XGUIEng.PopPage();
    XGUIEng.PopPage();
    XGUIEng.ShowWidget("/InGame/ThroneRoom", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_Dodge", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2_Dodge", 0);

    if self.Briefing[_PlayerID].HideNotes then
        XGUIEng.ShowWidget("/InGame/Root/Normal/NotesWindow", 1);
    end

    ResetRenderDistance();
    self:SetQualityMode();

    if ConsoleWasVisible then
        ShowScriptConsole();
    end
    self.CinematicActive = false;
end

-- -------------------------------------------------------------------------- --

function Lib.BriefingSystem.Local:IsChangingGraphicsPermited()
    return self.Config.DoAlternateGraphics == true;
end

function Lib.BriefingSystem.Local:RequestAlternateGraphics()
    if IsMultiplayer() then
        return;
    end
    DialogRequestBox(
        GUI.GetPlayerID(),
        Lib.BriefingSystem.Text.Request.Title,
        Lib.BriefingSystem.Text.Request.Text,
        function(_Yes)
            Lib.BriefingSystem.Local.Config.DoAlternateGraphics = _Yes == true;
        end,
        false
    );
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.BriefingSystem.Name);

