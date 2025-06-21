Lib.Core = Lib.Core or {};
Lib.Core.Debug = {
    DisplayScriptErrors = false;
    CheckAtRun = false;
    TraceQuests = false;
    DevelopingCheats = false;
    DevelopingShell = false;
    LoadscreenClosed = false;
}

Lib.Require("comfort/IsLocalScript");
Lib.Require("core/feature/Core_Report");
Lib.Require("core/feature/Core_Chat");
Lib.Register("core/feature/Core_Debug");

function Lib.Core.Debug:Initialize()
    Report.DebugChatConfirmed = CreateReport("Event_DebugChatConfirmed");
    Report.DebugConfigChanged = CreateReport("Event_DebugConfigChanged");
    Report.DebugCallGlobal = CreateReport("Event_DebugCallGlobal");

    if IsLocalScript() then
        self:InitializeQsbDebugHotkeys();
    end
end

function Lib.Core.Debug:OnSaveGameLoaded()
    if IsLocalScript() then
        self:InitializeDebugWidgets();
        self:InitializeQsbDebugHotkeys();
    end
end

function Lib.Core.Debug:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.ChatClosed then
        if IsLocalScript() then
            Lib.Core.Debug:ProcessDebugInput(...);
        end
    elseif _ID == Report.DebugCallGlobal then
        if not IsLocalScript() then
            self:CallFunctionFromString(...);
        end
    end
end

function Lib.Core.Debug:Test(_Text)
    AddNote(_Text)
end

function Lib.Core.Debug:ActivateDebugMode(_DisplayScriptErrors, _CheckAtRun, _DevelopingCheats, _DevelopingShell, _TraceQuests)
    if IsLocalScript() then
        return;
    end

    self.DisplayScriptErrors = _DisplayScriptErrors == true;
    self.CheckAtRun          = _CheckAtRun == true;
    self.DevelopingCheats    = _DevelopingCheats == true;
    self.DevelopingShell     = _DevelopingShell == true;
    self.TraceQuests         = _TraceQuests == true;

    g_DisplayScriptErrors = _DisplayScriptErrors == true;

    SendReport(
        Report.DebugConfigChanged,
        self.DisplayScriptErrors,
        self.CheckAtRun,
        self.DevelopingCheats,
        self.DevelopingShell,
        self.TraceQuests
    );

    ExecuteLocal(
        [[
            Lib.Core.Debug.DisplayScriptErrors = %s;
            Lib.Core.Debug.CheckAtRun          = %s;
            Lib.Core.Debug.DevelopingCheats    = %s;
            Lib.Core.Debug.DevelopingShell     = %s;
            Lib.Core.Debug.TraceQuests         = %s;

            SendReport(
                Report.DebugConfigChanged,
                Lib.Core.Debug.DisplayScriptErrors,
                Lib.Core.Debug.CheckAtRun,
                Lib.Core.Debug.DevelopingCheats,
                Lib.Core.Debug.DevelopingShell,
                Lib.Core.Debug.TraceQuests
            );
            Lib.Core.Debug:InitializeDebugWidgets();

            g_DisplayScriptErrors = Lib.Core.Debug.DisplayScriptErrors;
        ]],
        tostring(self.DisplayScriptErrors),
        tostring(self.CheckAtRun),
        tostring(self.DevelopingCheats),
        tostring(self.DevelopingShell),
        tostring(self.TraceQuests)
    );
end

function Lib.Core.Debug:LegacyToggleDisplayScriptErrors(_Active)
    self:ActivateDebugMode(
        _Active == true,
        self.CheckAtRun,
        self.DevelopingCheats,
        self.DevelopingShell,
        self.TraceQuests
    );
end

function Lib.Core.Debug:InitializeDebugWidgets()
    if Network.IsNATReady ~= nil and Framework.IsNetworkGame() then
        return;
    end
    if self.DevelopingCheats then
        KeyBindings_EnableDebugMode(1);
        KeyBindings_EnableDebugMode(2);
        KeyBindings_EnableDebugMode(3);
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 1);
        self.GameClock = true;
    else
        KeyBindings_EnableDebugMode(0);
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 0);
        self.GameClock = false;
    end
end

function Lib.Core.Debug:InitializeQsbDebugHotkeys()
    if Framework.IsNetworkGame() then
        return;
    end
    -- Restart map
    Input.KeyBindDown(
        Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.R,
        "Lib.Core.Debug:ProcessDebugShortcut('RestartMap')",
        30,
        false
    );
    -- Open chat
    Input.KeyBindDown(
        Keys.ModifierShift + Keys.OemPipe,
        "Lib.Core.Debug:ProcessDebugShortcut('Terminal')",
        30,
        false
    );
end

function Lib.Core.Debug:CallFunctionFromString(...)
    local FunctionRef = nil;
    local FunctionNameParts = string.slice(table.remove(arg, 1), "%.");
    for i= 1, #FunctionNameParts do
        local FunctionName = string.slice(FunctionNameParts[i], ":");
        if #FunctionName > 1 then
            if FunctionRef == nil then
                FunctionRef = _G[FunctionName[1]][FunctionName[2]];
                if FunctionRef then
                    FunctionRef(_G[FunctionName[1]], unpack(arg));
                end
            else
                FunctionRef = FunctionRef[FunctionName[1]][FunctionName[2]];
                if FunctionRef then
                    FunctionRef(_G[FunctionName[1]], unpack(arg));
                end
            end
            return;
        else
            if FunctionRef == nil then
                FunctionRef = _G[FunctionName[1]];
            else
                FunctionRef = FunctionRef[FunctionName[1]];
            end
        end
    end
    if FunctionRef then
        FunctionRef(unpack(arg));
    end
end

function Lib.Core.Debug:ProcessDebugShortcut(_Type, _Params)
    if self.DevelopingCheats then
        if _Type == "RestartMap" then
            Framework.RestartMap();
        end
    end
    if self.DevelopingShell then
        if _Type == "Terminal" then
            ShowTextInput(GUI.GetPlayerID(), true);
        end
    end
end

function Lib.Core.Debug:ProcessDebugInput(_Input, _PlayerID, _DebugAllowed)
    if _DebugAllowed then
        if _Input:lower():find("^restartmap") then
            self:ProcessDebugShortcut("RestartMap");
        elseif _Input:lower():find("^clear") then
            GUI.ClearNotes();
        elseif _Input:lower():find("^version") then
            GUI.AddStaticNote("Version: " ..Lib.Loader.Version);
        elseif _Input:find("^> ") then
            GUI.SendScriptCommand(_Input:sub(3), true);
        elseif _Input:find("^>> ") then
            GUI.SendScriptCommand(string.format(
                "Logic.ExecuteInLuaLocalState(\"%s\")",
                _Input:sub(4)
            ), true);
        elseif _Input:find("^< ") then
            GUI.SendScriptCommand(string.format(
                [[Script.Load("%s")]],
                _Input:sub(3)
            ));
        elseif _Input:find("^<< ") then
            Script.Load(_Input:sub(4));
        end
    end
end

function Lib.Core.Debug:CommandTokenizer(_Input)
    local Commands = {};
    if _Input == nil then
        return Commands;
    end
    local DAmberCommands = {_Input};
    local AmberCommands = {};

    -- parse & delimiter
    local s, e = string.find(_Input, "%s+&&%s+");
    if s then
        DAmberCommands = {};
        while (s) do
            local tmp = string.sub(_Input, 1, s-1);
            table.insert(DAmberCommands, tmp);
            _Input = string.sub(_Input, e+1);
            s, e = string.find(_Input, "%s+&&%s+");
        end
        if string.len(_Input) > 0 then 
            table.insert(DAmberCommands, _Input);
        end
    end

    -- parse & delimiter
    for i= 1, #DAmberCommands, 1 do
        s, e = string.find(DAmberCommands[i], "%s+&%s+");
        if s then
            local LastCommand = "";
            while (s) do
                local tmp = string.sub(DAmberCommands[i], 1, s-1);
                table.insert(AmberCommands, LastCommand .. tmp);
                if string.find(tmp, " ") then
                    LastCommand = string.sub(tmp, 1, string.find(tmp, " ")-1) .. " ";
                end
                DAmberCommands[i] = string.sub(DAmberCommands[i], e+1);
                s, e = string.find(DAmberCommands[i], "%s+&%s+");
            end
            if string.len(DAmberCommands[i]) > 0 then 
                table.insert(AmberCommands, LastCommand .. DAmberCommands[i]);
            end
        else
            table.insert(AmberCommands, DAmberCommands[i]);
        end
    end

    -- parse spaces
    for i= 1, #AmberCommands, 1 do
        local CommandLine = {};
        s, e = string.find(AmberCommands[i], "%s+");
        if s then
            while (s) do
                local tmp = string.sub(AmberCommands[i], 1, s-1);
                table.insert(CommandLine, tmp);
                AmberCommands[i] = string.sub(AmberCommands[i], e+1);
                s, e = string.find(AmberCommands[i], "%s+");
            end
            table.insert(CommandLine, AmberCommands[i]);
        else
            table.insert(CommandLine, AmberCommands[i]);
        end
        table.insert(Commands, CommandLine);
    end

    return Commands;
end

-- -------------------------------------------------------------------------- --

function log(_Text, ...)
    local Text = _Text;
    if #arg > 0 then
        Text = string.format(Text, unpack(arg));
    end
    Text = string.gsub(Text, "{cr}", "\n");
    Framework.WriteToLog(Text);
    return Text;
end

function warn(_Condition, _Text, ...)
    if not _Condition then
        local Color = "{@color:255,0,0,255}";
        local Text = Color .. log(_Text, unpack(arg));
        if GUI then
            GUI.AddNote(Text);
        else
            Logic.DEBUG_AddNote(Text);
        end
        return Text;
    end
end

function error(_Condition, _Text, ...)
    if not _Condition then
        local Text = log(_Text, unpack(arg));
        return assert(false, Text);
    end
end

function debug(_Condition, _Text, ...)
    if not _Condition then
        local Text = log(_Text, unpack(arg));
        if GUI then
            GUI.AddNote(Text);
        else
            Logic.DEBUG_AddNote(Text);
        end
    end
end

-- -------------------------------------------------------------------------- --

function ActivateDebugMode(_DisplayScriptErrors, _CheckAtRun, _DevelopingCheats, _DevelopingShell, _TraceQuests)
    Lib.Core.Debug:ActivateDebugMode(_DisplayScriptErrors, _CheckAtRun, _DevelopingCheats, _DevelopingShell, _TraceQuests);
end
API.ActivateDebugMode = ActivateDebugMode;

function ToggleDisplayScriptErrors(_active)
    Lib.Core.Debug:LegacyToggleDisplayScriptErrors(_active);
end
API.ToggleDisplayScriptErrors = ToggleDisplayScriptErrors;

