Lib.Typewriter = Lib.Typewriter or {};
Lib.Typewriter.Name = "Typewriter";
Lib.Typewriter.CinematicEvents = {};
Lib.Typewriter.Global = {
    TypewriterEventData = {},
    TypewriterEventCounter = 0,
};
Lib.Typewriter.Local = {};

CinematicEventTypes.Typewriter = 1;

Lib.Require("comfort/IsMultiplayer");
Lib.Require("core/Core");
Lib.Require("module/information/Information");
Lib.Require("module/information/Typewriter_API");
Lib.Register("module/information/Typewriter");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Typewriter.Global:Initialize()
    if not self.IsInstalled then
        Report.TypewriterStarted = CreateReport("Event_TypewriterStarted");
        Report.TypewriterEnded = CreateReport("Event_TypewriterEnded");

        RequestHiResJob(function()
            Lib.Typewriter.Global:ControlTypewriter();
        end);

        -- Garbage collection
        Lib.Typewriter.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Typewriter.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Typewriter.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Typewriter.Global:StartTypewriter(_Data)
    self.TypewriterEventCounter = self.TypewriterEventCounter +1;
    local EventName = "CinematicEvent_Typewriter" ..self.TypewriterEventCounter;
    _Data.Name = EventName;
    if not self.LoadscreenClosed or IsCinematicEventActive(_Data.PlayerID) then
        Lib.Typewriter.Global:PushCinematicEventToQueue(
            _Data.PlayerID,
            CinematicEventTypes.Typewriter,
            EventName,
            _Data
        );
        return _Data.Name;
    end
    return self:PlayTypewriter(_Data);
end

function Lib.Typewriter.Global:PlayTypewriter(_Data)
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

function Lib.Typewriter.Global:FinishTypewriter(_PlayerID)
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

function Lib.Typewriter.Global:TokenizeText(_Data)
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

function Lib.Typewriter.Global:ControlTypewriter()
    -- Check queue for next event
    for i= 1, 8 do
        if self.LoadscreenClosed and not IsCinematicEventActive(i) then
            local Next = Lib.Information.Global:LookUpCinematicInQueue(i);
            if Next and Next[1] == CinematicEventTypes.Typewriter then
                local Data = Lib.Typewriter.Global:PopCinematicEventFromQueue(i);
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
function Lib.Typewriter.Local:Initialize()
    if not self.IsInstalled then
        Report.TypewriterStarted = CreateReport("Event_TypewriterStarted");
        Report.TypewriterEnded = CreateReport("Event_TypewriterEnded");

        -- Garbage collection
        Lib.Typewriter.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Typewriter.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.Typewriter.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Typewriter.Name);

