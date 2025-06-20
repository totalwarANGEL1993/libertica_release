
Lib.Core = Lib.Core or {};

Lib.Core.ModuleList = {};
Lib.Core.Global = {
    IsInstalled = false,
};
Lib.Core.Local = {
    IsInstalled = false;
};

CONST_CURRENT_MODULE_CONTEXT = {};

Lib.Require("comfort/IsHistoryEdition");
Lib.Require("comfort/IsMultiplayer");
Lib.Require("comfort/IsLocalScript");
Lib.Require("comfort/IsUnofficialPatch");
Lib.Require("comfort/HexToColorString");

Lib.Require("core/QSB");

Lib.Require("core/feature/Core_Chat");
Lib.Require("core/feature/Core_Debug");
Lib.Require("core/feature/Core_LuaExtension");
Lib.Require("core/feature/Core_Report");
Lib.Require("core/feature/Core_ScriptingValue");
Lib.Require("core/feature/Core_Placeholder");
Lib.Require("core/feature/Core_Job");
Lib.Require("core/feature/Core_Save");
Lib.Require("core/feature/Core_Quest");
Lib.Require("core/feature/Core_Player");

Lib.Require("core/Core_Behavior");
Lib.Require("core/Core_Text");
Lib.Register("core/Core");

---@diagnostic disable: deprecated

-- -------------------------------------------------------------------------- --
-- Global

function Lib.Core.Global:Initialize()
    if not self.IsInstalled then
        g_GameExtraNo = Framework.GetGameExtraNo();

        -- Init base features
        Lib.Core.LuaExtension:Initialize();
        Lib.Core.Report:Initialize();
        Lib.Core.Placeholder:Initialize();
        Lib.Core.Job:Initialize();
        Lib.Core.ScriptingValue:Initialize();
        Lib.Core.Save:Initialize();
        Lib.Core.Quest:Initialize();
        Lib.Core.Chat:Initialize();
        Lib.Core.Debug:Initialize();
        Lib.Core.Player:Initialize();

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
            local Name = Lib.Core.ModuleList[i];
            Lib[Name].Global.Name = Name;

            Lib[Name].AquireContext = function()
                return Lib.Core.Global:AquireContext(Lib[Name].Global);
            end
            Lib[Name].ReleaseContext = function()
                return Lib.Core.Global:ReleaseContext(Lib[Name].Global);
            end

            if Lib[Name].Global and Lib[Name].Global.Initialize then
                Lib[Name].Global:Initialize();
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
    Lib.Core.Placeholder:OnSaveGameLoaded();
    Lib.Core.Job:OnSaveGameLoaded();
    Lib.Core.ScriptingValue:OnSaveGameLoaded();
    Lib.Core.Save:OnSaveGameLoaded();
    Lib.Core.Quest:OnSaveGameLoaded();
    Lib.Core.Chat:OnSaveGameLoaded();
    Lib.Core.Debug:OnSaveGameLoaded();
    Lib.Core.Player:OnSaveGameLoaded();

    -- Restore modules
    for i= 1, #Lib.Core.ModuleList do
        local Name = Lib.Core.ModuleList[i];

        Lib[Name].AquireContext = function()
            return Lib.Core.Global:AquireContext(Lib[Name].Global);
        end
        Lib[Name].ReleaseContext = function()
            return Lib.Core.Global:ReleaseContext(Lib[Name].Global);
        end

        if Lib[Name].Global and Lib[Name].Global.OnSaveGameLoaded then
            Lib[Name].Global:OnSaveGameLoaded();
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
    GameCallback_Lib_OnReportReceived = function(_ID, ...)
        local arg = {...};

        Lib.Core.LuaExtension:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Report:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Placeholder:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Job:OnReportReceived(_ID, unpack(arg));
        Lib.Core.ScriptingValue:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Save:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Quest:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Chat:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Debug:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Player:OnReportReceived(_ID, unpack(arg));

        -- Loadscreen
        if _ID == Report.LoadingFinished then
            SendReportToLocal(Report.LoadingFinished, unpack(arg));
        end
        -- Escape
        if _ID == Report.EscapePressed then
            SendReportToLocal(Report.EscapePressed, unpack(arg));
        end

        for i= 1, #Lib.Core.ModuleList do
            local Name = Lib.Core.ModuleList[i];
            if Lib[Name].Global and Lib[Name].Global.OnReportReceived then
                Lib[Name].Global:OnReportReceived(_ID, unpack(arg));
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

function Lib.Core.Global:AquireContext(_Module)
    local Name = (type(_Module) == "table" and _Module.Name) or _Module;
    assert(Lib[Name] ~= nil);
    table.insert(CONST_CURRENT_MODULE_CONTEXT, Lib[Name].Global);
    local Frame = #CONST_CURRENT_MODULE_CONTEXT;
    this = CONST_CURRENT_MODULE_CONTEXT[Frame];
end

function Lib.Core.Global:ReleaseContext(_Module)
    local Name = (type(_Module) == "table" and _Module.Name) or _Module;
    assert(Lib[Name] ~= nil);
    local Frame = #CONST_CURRENT_MODULE_CONTEXT;
    Lib[Name].Global = CONST_CURRENT_MODULE_CONTEXT[Frame];
    table.remove(CONST_CURRENT_MODULE_CONTEXT);
    Frame = #CONST_CURRENT_MODULE_CONTEXT;
    this = CONST_CURRENT_MODULE_CONTEXT[Frame];
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
        Lib.Core.Placeholder:Initialize();
        Lib.Core.Job:Initialize();
        Lib.Core.ScriptingValue:Initialize();
        Lib.Core.Save:Initialize();
        Lib.Core.Quest:Initialize();
        Lib.Core.Chat:Initialize();
        Lib.Core.Debug:Initialize();
        Lib.Core.Player:Initialize();

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
            local Name = Lib.Core.ModuleList[i];
            Lib[Name].Local.Name = Name;

            Lib[Name].AquireContext = function()
                return Lib.Core.Local:AquireContext(Lib[Name].Local);
            end
            Lib[Name].ReleaseContext = function()
                return Lib.Core.Local:ReleaseContext(Lib[Name].Local);
            end

            if Lib[Name].Local and Lib[Name].Local.Initialize then
                Lib[Name].Local:Initialize();
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
    Lib.Core.Placeholder:OnSaveGameLoaded();
    Lib.Core.Job:OnSaveGameLoaded();
    Lib.Core.ScriptingValue:OnSaveGameLoaded();
    Lib.Core.Save:OnSaveGameLoaded();
    Lib.Core.Quest:OnSaveGameLoaded();
    Lib.Core.Chat:OnSaveGameLoaded();
    Lib.Core.Debug:OnSaveGameLoaded();
    Lib.Core.Player:OnSaveGameLoaded();

    -- Restore modules
    for i= 1, #Lib.Core.ModuleList do
        local Name = Lib.Core.ModuleList[i];

        Lib[Name].AquireContext = function()
            return Lib.Core.Local:AquireContext(Lib[Name].Local);
        end
        Lib[Name].ReleaseContext = function()
            return Lib.Core.Local:ReleaseContext(Lib[Name].Local);
        end

        if Lib[Name].Local and Lib[Name].Local.OnSaveGameLoaded then
            Lib[Name].Local:OnSaveGameLoaded();
        end
    end

    self:SetEscapeKeyTrigger();

    SendReport(Report.SaveGameLoaded);
end

function Lib.Core.Local:InitReportListener()
    GameCallback_Lib_OnReportReceived = function(_ID, ...)
        local arg = {...};
        Lib.Core.LuaExtension:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Report:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Placeholder:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Job:OnReportReceived(_ID, unpack(arg));
        Lib.Core.ScriptingValue:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Save:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Quest:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Chat:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Debug:OnReportReceived(_ID, unpack(arg));
        Lib.Core.Player:OnReportReceived(_ID, unpack(arg));

        -- Loadscreen
        if _ID == Report.LoadingFinished then
            XGUIEng.PopPage();
        end

        for i= 1, #Lib.Core.ModuleList do
            local Name = Lib.Core.ModuleList[i];
            if Lib[Name].Local and Lib[Name].Local.OnReportReceived then
                Lib[Name].Local:OnReportReceived(_ID, unpack(arg));
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
    if IsHistoryEdition() and IsMultiplayer() then
        warn(false, "Script command is not allowed in history edition multiplayer.");
        return;
    end
    if arg and #arg > 0 then
        CommandString = CommandString:format(unpack(arg));
    end
    GUI.SendScriptCommand(CommandString);
end

function Lib.Core.Local:AquireContext(_Module)
    local Name = (type(_Module) == "table" and _Module.Name) or _Module;
    assert(Lib[Name] ~= nil);
    table.insert(CONST_CURRENT_MODULE_CONTEXT, Lib[Name].Local);
    local Frame = #CONST_CURRENT_MODULE_CONTEXT;
    this = CONST_CURRENT_MODULE_CONTEXT[Frame];
end

function Lib.Core.Local:ReleaseContext(_Module)
    local Name = (type(_Module) == "table" and _Module.Name) or _Module;
    assert(Lib[Name] ~= nil);
    local Frame = #CONST_CURRENT_MODULE_CONTEXT;
    Lib[Name].Local = CONST_CURRENT_MODULE_CONTEXT[Frame];
    table.remove(CONST_CURRENT_MODULE_CONTEXT);
    Frame = #CONST_CURRENT_MODULE_CONTEXT;
    this = CONST_CURRENT_MODULE_CONTEXT[Frame];
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

function Lib.Core.Local:Preload_ViewWholeMap()
    local WorldX, WorldY = Logic.WorldGetSize();
    Display.SetFarClipPlaneMinAndMax(0, 0);
    Camera.SwitchCameraBehaviour(0);
    Camera.RTS_ToggleMapMode(1);
    Camera.RTS_SetMapModeFOV(90);
    Camera.RTS_SetMapModeZoomDistance(100000);
    Camera.RTS_SetMapModeZoomAngle(90);
    Camera.RTS_SetLookAtPosition(WorldX * 0.5, WorldY * 0.5);
    Display.SetRenderFogOfWar(0);
end

function Lib.Core.Local:Preload_ResetView()
    Camera.RTS_ToggleMapMode(0);
    Display.SetRenderFogOfWar(1);
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Local:CloseGameIfNotPatched(_Version)
    local Required = _Version;
    local Current = g_UnofficialPatchVersion;
    Required = (Required:find("^UP") == nil and "UP " ..Required) or Required;
    Current = (Current:find("^UP") == nil and "UP " ..Current) or Current;

    if not IsMultiplayer() then
        -- Check patch version
        local Title = Localize(Lib.Core.Text.PatchRequired.Title);
        local Text = Localize(Lib.Core.Text.PatchRequired.Text);
        if IsUnofficialPatch() then
            local Pattern = "^([a-zA-Z]+) (%d+)%.(%d+)%.(%d+)";
            local _, mj1,mo1,bf1, _ = string.match(Required, Pattern);
            local _, mj2,mo2,bf2, _ = string.match(Current, Pattern);
            if mj1 == nil or mo1 == nil or bf1 == nil then
                error(false, "Malformed version number: %s", Required);
                Framework.CloseGame();
            end
            Text = Localize(Lib.Core.Text.PatchVersionRequired.Text);
            Text = Text:format(Required, "UP "..mj2.."."..mo2.."."..bf2);
            if Required == "UP 0.0.0" then
                return;
            else
                if tonumber(mj1) >= tonumber(mj2) then
                    if tonumber(mo1) >= tonumber(mo2) then
                        if tonumber(bf1) >= tonumber(bf2) then
                            return;
                        end
                    end
                end
            end
        end

        -- Kick player out of map
        local PlayerID = GUI.GetPlayerID();
        XGUIEng.ShowWidget("/InGame/Root/3dOnScreenDisplay", 0);
        XGUIEng.ShowWidget("/InGame/Root/3dWorldView", 0);
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
        OpenDialog(Text, "{center}" ..Title, false);
        local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; Framework.CloseGame()";
        XGUIEng.SetActionFunction(RequesterDialog_Ok, Action);
        Game.GameTimeSetFactor(PlayerID, 0.0000001);
    end
end

-- -------------------------------------------------------------------------- --

function API.SetLogLevel(_ScreenLogLevel, _FileLogLevel)
    -- Legacy support...
    -- This is just for lazy as fuck people who never change their scripts.
    -- Log levels do not exist anymore.
end
API.SetLoggingLevel = API.SetLogLevel

function PrepareLibrary()
    assert(not IsLocalScript(), "Must be called from global script!");
    Lib.Core.Global:Initialize();
    ExecuteLocal("Lib.Core.Local:Initialize()");
end
API.Install = PrepareLibrary;
API.PrepareLibrary = PrepareLibrary;

function RegisterModule(_Name)
    assert(Lib[_Name], "Module '" .._Name.. "' does not exist!");
    table.insert(Lib.Core.ModuleList, _Name);
end
API.RegisterModule = RegisterModule;

function ExecuteLocal(_Command, ...)
    if not IsLocalScript() then
        Lib.Core.Global:ExecuteLocal(_Command, ...);
    end
end
API.ExecuteLocal = ExecuteLocal;

function ExecuteGlobal(_Command, ...)
    if IsLocalScript() then
        Lib.Core.Local:ExecuteGlobal(_Command, ...);
    end
end
API.ExecuteGlobal = ExecuteGlobal;

function SetUnofficialPatchRequired(_Version)
    if not IsLocalScript() then
        local Version = (_Version ~= nil and "\"" .._Version.. "\"") or "UP 0.0.0";
        ExecuteLocal([[SetUnofficialPatchRequired(%s)]], Version);
        return;
    end
    Lib.Core.Local:CloseGameIfNotPatched(_Version);
end
API.SetUnofficialPatchRequired = SetUnofficialPatchRequired;

