
Lib.Core = Lib.Core or {};

Lib.Core.ModuleList = {};
Lib.Core.Global = {
    IsInstalled = false,
};
Lib.Core.Local = {
    IsInstalled = false;
};

Lib.Require("comfort/IsHistoryEdition");
Lib.Require("comfort/IsMultiplayer");
Lib.Require("comfort/IsLocalScript");

Lib.Require("core/feature/Core_Chat");
Lib.Require("core/feature/Core_Debug");
Lib.Require("core/feature/Core_LuaExtension");
Lib.Require("core/feature/Core_Bugfix");
Lib.Require("core/feature/Core_Report");
Lib.Require("core/feature/Core_ScriptingValue");
Lib.Require("core/feature/Core_Text");
Lib.Require("core/feature/Core_Job");
Lib.Require("core/feature/Core_Save");
Lib.Require("core/feature/Core_Quest");

Lib.Register("core/Core");

---@diagnostic disable: deprecated

-- -------------------------------------------------------------------------- --

function log(_Text, ...)
    local Text = _Text;
    if #arg > 0 then
        Text = string.format(Text, unpack(arg));
    end
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
            Logic.DEBUG_Addnote(Text);
        end
        return Text;
    end
end

function error(_Condition, _Text, ...)
    if not _Condition then
        local Text = log(_Text, unpack(arg));
        return assert(_Condition, Text);
    end
end

function debug(_Condition, _Text, ...)
    if not _Condition then
        local Text = log(_Text, unpack(arg));
        if GUI then
            GUI.AddNote(Text);
        else
            Logic.DEBUG_Addnote(Text);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Global

function Lib.Core.Global:Initialize()
    if not self.IsInstalled then
        g_GameExtraNo = Framework.GetGameExtraNo();

        -- Init base features
        Lib.Core.LuaExtension:Initialize();
        Lib.Core.Report:Initialize();
        Lib.Core.Text:Initialize();
        Lib.Core.Job:Initialize();
        Lib.Core.ScriptingValue:Initialize();
        Lib.Core.Save:Initialize();
        Lib.Core.Quest:Initialize();
        Lib.Core.Chat:Initialize();
        Lib.Core.Debug:Initialize();
        Lib.Core.Bugfix:Initialize();

        -- Load user files
        if Mission_LoadFiles then
            GameCallback_Lib_GetExternFilesToLoad = Mission_LoadFiles;
        end
        if GameCallback_Lib_GetExternFilesToLoad then
            local Files = GameCallback_Lib_GetExternFilesToLoad();
            for i= 1, #Files do
                Script.Load(Files[i]);
            end
        end

        -- Initialize modules
        for i= 1, #Lib.Core.ModuleList do
            local Module = Lib[Lib.Core.ModuleList[i]];
            if Module.Global and Module.Global.Initialize then
                Module.Global:Initialize();
            end
        end

        self:OverrideOnSaveGameLoaded();
        self:InitReportListener();
        self:InitEscapeHandler();
        self:InitLoadscreenHandler();
        LoadBehaviors();

        -- Cleanup (garbage collection)
        Lib.Core.Local = nil;
    end
    self.IsInstalled = true;
end

function Lib.Core.Global:OnSaveGameLoaded()
    Lib.Core.LuaExtension:OnSaveGameLoaded();
    Lib.Core.Report:OnSaveGameLoaded();
    Lib.Core.Text:OnSaveGameLoaded();
    Lib.Core.Job:OnSaveGameLoaded();
    Lib.Core.ScriptingValue:OnSaveGameLoaded();
    Lib.Core.Save:OnSaveGameLoaded();
    Lib.Core.Quest:OnSaveGameLoaded();
    Lib.Core.Chat:OnSaveGameLoaded();
    Lib.Core.Debug:OnSaveGameLoaded();
    Lib.Core.Bugfix:OnSaveGameLoaded();

    -- Restore modules
    for i= 1, #Lib.Core.ModuleList do
        local Module = Lib[Lib.Core.ModuleList[i]];
        if Module.Global and Module.Global.OnSaveGameLoaded then
            Module.Global:OnSaveGameLoaded();
        end
    end
end

function Lib.Core.Global:OverrideOnSaveGameLoaded()
    Mission_OnSaveGameLoaded_Orig_Libertica = Mission_OnSaveGameLoaded;
    Mission_OnSaveGameLoaded = function()
        Lib.Core.Global:ExecuteLocal("Lib.Core.Local:OnSaveGameLoaded()");
        Lib.Core.Global:OnSaveGameLoaded();
    end
end

function Lib.Core.Global:InitReportListener()
    GameCallback_Lib_OnEventReceived = function(_ID, ...)
        Lib.Core.LuaExtension:OnReportReceived(_ID, ...);
        Lib.Core.Report:OnReportReceived(_ID, ...);
        Lib.Core.Text:OnReportReceived(_ID, ...);
        Lib.Core.Job:OnReportReceived(_ID, ...);
        Lib.Core.ScriptingValue:OnReportReceived(_ID, ...);
        Lib.Core.Save:OnReportReceived(_ID, ...);
        Lib.Core.Quest:OnReportReceived(_ID, ...);
        Lib.Core.Chat:OnReportReceived(_ID, ...);
        Lib.Core.Debug:OnReportReceived(_ID, ...);
        Lib.Core.Bugfix:OnReportReceived(_ID, ...);

        -- Loadscreen
        if _ID == Report.LoadingFinished then
            SendReportToLocal(Report.LoadingFinished, ...);
        end
        -- Escape
        if _ID == Report.EscapePressed then
            SendReportToLocal(Report.EscapePressed, ...);
        end

        for i= 1, #Lib.Core.ModuleList do
            local Module = Lib[Lib.Core.ModuleList[i]];
            if Module.Global and Module.Global.OnReportReceived then
                Module.Global:OnReportReceived(_ID, ...);
            end
        end

        -- Loading finished callback
        if _ID == Report.LoadingFinished then
            if GameCallback_Lib_LoadingFinished then
                GameCallback_Lib_LoadingFinished();
            end
        end
    end
end

function Lib.Core.Global:ExecuteLocal(_Command, ...)
    local CommandString = _Command;
    if arg and #arg > 0 then
        CommandString = CommandString:format(unpack(arg));
    end
    Logic.ExecuteInLuaLocalState(CommandString);
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Global:InitEscapeHandler()
    Report.EscapePressed = CreateReport("Event_EscapePressed");
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Global:InitLoadscreenHandler()
    Report.LoadingFinished = CreateReport("Event_LoadingFinished");
end

-- -------------------------------------------------------------------------- --
-- Local

function Lib.Core.Local:Initialize()
    if not self.IsInstalled then
        g_GameExtraNo = Framework.GetGameExtraNo();

        -- Init base features
        Lib.Core.LuaExtension:Initialize();
        Lib.Core.Report:Initialize();
        Lib.Core.Text:Initialize();
        Lib.Core.Job:Initialize();
        Lib.Core.ScriptingValue:Initialize();
        Lib.Core.Save:Initialize();
        Lib.Core.Quest:Initialize();
        Lib.Core.Chat:Initialize();
        Lib.Core.Debug:Initialize();
        Lib.Core.Bugfix:Initialize();

        -- Load user files
        if Mission_LoadFiles then
            GameCallback_Lib_GetExternFilesToLoad = Mission_LoadFiles;
        end
        if GameCallback_Lib_GetExternFilesToLoad then
            local Files = GameCallback_Lib_GetExternFilesToLoad();
            for i= 1, #Files do
                Script.Load(Files[i]);
            end
        end

        -- Initialize modules
        for i= 1, #Lib.Core.ModuleList do
            local Module = Lib[Lib.Core.ModuleList[i]];
            if Module.Local and Module.Local.Initialize then
                Module.Local:Initialize();
            end
        end

        self:InitReportListener();
        self:InitEscapeHandler();
        self:InitLoadscreenHandler();

        -- Cleanup (garbage collection)
        Lib.Core.Global = nil;
    end
    self.IsInstalled = true;
end

function Lib.Core.Local:OnSaveGameLoaded()
    Lib.Core.LuaExtension:OnSaveGameLoaded();
    Lib.Core.Report:OnSaveGameLoaded();
    Lib.Core.Text:OnSaveGameLoaded();
    Lib.Core.Job:OnSaveGameLoaded();
    Lib.Core.ScriptingValue:OnSaveGameLoaded();
    Lib.Core.Save:OnSaveGameLoaded();
    Lib.Core.Quest:OnSaveGameLoaded();
    Lib.Core.Chat:OnSaveGameLoaded();
    Lib.Core.Debug:OnSaveGameLoaded();
    Lib.Core.Bugfix:OnSaveGameLoaded();

    -- Restore modules
    for i= 1, #Lib.Core.ModuleList do
        local Module = Lib[Lib.Core.ModuleList[i]];
        if Module.Local and Module.Local.OnSaveGameLoaded then
            Module.Local:OnSaveGameLoaded();
        end
    end

    self:SetEscapeKeyTrigger();

    SendReport(Report.SaveGameLoaded);
end

function Lib.Core.Local:InitReportListener()
    GameCallback_Lib_OnEventReceived = function(_ID, ...)
        Lib.Core.LuaExtension:OnReportReceived(_ID, ...);
        Lib.Core.Report:OnReportReceived(_ID, ...);
        Lib.Core.Text:OnReportReceived(_ID, ...);
        Lib.Core.Job:OnReportReceived(_ID, ...);
        Lib.Core.ScriptingValue:OnReportReceived(_ID, ...);
        Lib.Core.Save:OnReportReceived(_ID, ...);
        Lib.Core.Quest:OnReportReceived(_ID, ...);
        Lib.Core.Chat:OnReportReceived(_ID, ...);
        Lib.Core.Debug:OnReportReceived(_ID, ...);
        Lib.Core.Bugfix:OnReportReceived(_ID, ...);

        -- Loadscreen
        if _ID == Report.LoadingFinished then
            XGUIEng.PopPage();
        end

        for i= 1, #Lib.Core.ModuleList do
            local Module = Lib[Lib.Core.ModuleList[i]];
            if Module.Local and Module.Local.OnReportReceived then
                Module.Local:OnReportReceived(_ID, ...);
            end
        end

        -- Loading finished callback
        if _ID == Report.LoadingFinished then
            if GameCallback_Lib_LoadingFinished then
                GameCallback_Lib_LoadingFinished();
            end
        end
    end
end

function Lib.Core.Local:ExecuteGlobal(_Command, ...)
    local CommandString = _Command;
    assert(
        not (IsHistoryEdition() and IsMultiplayer()),
        "Script command is not allowed in history edition multiplayer."
    );
    if arg and #arg > 0 then
        CommandString = CommandString:format(unpack(arg));
    end
    GUI.SendScriptCommand(CommandString);
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Local:InitEscapeHandler()
    Report.EscapePressed = CreateReport("Event_EscapePressed");
    self:SetEscapeKeyTrigger();
end

function Lib.Core.Local:SetEscapeKeyTrigger()
    Input.KeyBindDown(
        Keys.Escape,
        "SendReportToGlobal(Report.EscapePressed, GUI.GetPlayerID())",
        30,
        false
    );
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Local:InitLoadscreenHandler()
    Report.LoadingFinished = CreateReport("Event_LoadingFinished");

    self.LoadscreenWatchJobID = RequestHiResJob(function()
        if XGUIEng.IsWidgetShownEx("/LoadScreen/LoadScreen") == 0 then
            SendReportToGlobal(Report.LoadingFinished, GUI.GetPlayerID());
            return true;
        end
    end);

    HideLoadScreen_Orig_Core = HideLoadScreen;
    HideLoadScreen = function()
        HideLoadScreen_Orig_Core();
        XGUIEng.PushPage("/LoadScreen/LoadScreen", true);
        XGUIEng.ShowWidget("/LoadScreen/LoadScreen/ButtonStart", 0);
        EndJob(Lib.Core.Local.LoadscreenWatchJobID);
        SendReportToGlobal(Report.LoadingFinished, GUI.GetPlayerID());
    end
end

-- -------------------------------------------------------------------------- --

function PrepareLibrary()
    assert(not IsLocalScript(), "Must be called from global script!");
    Lib.Core.Global:Initialize();
    ExecuteLocal("Lib.Core.Local:Initialize()");
end

function RegisterModule(_Name)
    assert(Lib[_Name], "Module '" .._Name.. "' does not exist!");
    table.insert(Lib.Core.ModuleList, _Name);
end

function ExecuteLocal(_Command, ...)
    assert(not IsLocalScript(), "Can not be used in local script.");
    Lib.Core.Global:ExecuteLocal(_Command, ...);
end

function ExecuteGlobal(_Command, ...)
    assert(IsLocalScript(), "Can not be used in global script.");
    Lib.Core.Local:ExecuteGlobal(_Command, ...);
end

