
Lib.Core = Lib.Core or {};
Lib.Core.Report = {
    ScriptEventRegister = {},
    ScriptEventListener = {},

    ScriptCommandRegister = {},
    ScriptCommandSequence = 2,

    OriginPlayer = 0,
};

Report = Report or {};
Command = Command or {};

Lib.Require("comfort/IsLocalScript");
Lib.Require("comfort/IsMultiplayer");
Lib.Require("comfort/IsHistoryEdition");
Lib.Require("core/feature/Core_LuaExtension");
Lib.Register("core/feature/Core_Report");

-- -------------------------------------------------------------------------- --

function Lib.Core.Report:Initialize()
    if not IsLocalScript() then
        self:OverrideSoldierPaymentGlobal();
        self:CreateScriptCommand("Cmd_SendReportToGlobal", function(_Params)
            local ID = table.remove(_Params, 1);
            if ID then
                SendReport(ID, unpack(_Params));
            end
        end);
    else
        self:OverrideSoldierPaymentLocal();
    end
end

function Lib.Core.Report:OnSaveGameLoaded()
end

function Lib.Core.Report:OnReportReceived(_ID, ...)
end

function Lib.Core.Report:OverrideSoldierPaymentGlobal()
    self.Orig_GameCallback_SetSoldierPaymentLevel = GameCallback_SetSoldierPaymentLevel;
    GameCallback_SetSoldierPaymentLevel = function(_PlayerID, _Level)
        -- Unofficial Patch: If entity is passed as level, call original.
        if _Level <= 2 or IsExisting(_Level) then
            return Lib.Core.Report.Orig_GameCallback_SetSoldierPaymentLevel(_PlayerID, _Level);
        end
        Lib.Core.Report:ProcessScriptCommand(_PlayerID, _Level);
    end
end

function Lib.Core.Report:OverrideSoldierPaymentLocal()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingInfo.PaymentLevelSliderChanged = function()
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local PlayerID = GUI.GetPlayerID();
        local PaymentLevel = PlayerSoldierPaymentLevel[PlayerID];
        local PaymentSliderLevel = XGUIEng.SliderGetValueAbs(CurrentWidgetID);
        if PaymentSliderLevel <= 2 and PaymentLevel ~= PaymentSliderLevel then
            GUI.SetSoldierPaymentLevel(PaymentSliderLevel);
        end
    end

    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingInfo.PaymentLevelSliderUpdate = function()
        local WidgetPath = "/InGame/Root/Normal/AlignBottomRight/Selection/Castle/Treasury/Payment/PaymentSlider";
        local WidgetID = XGUIEng.GetWidgetID(WidgetPath);
        local PlayerID = GUI.GetPlayerID();
        local PaymentLevel = PlayerSoldierPaymentLevel[PlayerID];
        local PaymentSliderLevel = XGUIEng.SliderGetValueAbs(WidgetID);
        if PaymentSliderLevel <= 2 and PaymentLevel ~= PaymentSliderLevel then
            XGUIEng.SliderSetValueAbs(WidgetID, PaymentLevel);
        end
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Report:ProcessScriptCommand(_PlayerID, _ID)
    assert(_ID and self.ScriptCommandRegister[_ID], "Commands is invalid.");
    local PlayerName = Logic.GetPlayerName(_PlayerID +4);
    local Parameters = self:DecodeScriptCommandParameters(PlayerName);
    self.OriginPlayer = _PlayerID;
    self.ScriptCommandRegister[_ID][2](Parameters);
    self.OriginPlayer = 0;
end

function Lib.Core.Report:GetReportSourcePlayerID()
    return self.OriginPlayer;
end

function Lib.Core.Report:CreateScriptCommand(_Name, _Function)
    assert(not IsLocalScript(), "Commands must be created in global script.");
    self.ScriptCommandSequence = self.ScriptCommandSequence +1;
    local ID = self.ScriptCommandSequence;
    local Name = _Name;
    if string.find(_Name, "^Cmd_") then
        Name = string.sub(_Name, 5);
    end
    self.ScriptCommandRegister[ID] = {Name, _Function};
    ExecuteLocal([[
        local ID, Name = %d, "%s"
        Lib.Core.Report.ScriptCommandRegister[ID] = Name
        Command[Name] = ID
    ]], ID, Name);
end

function Lib.Core.Report:DecodeScriptCommandParameters(_Query)
    local Parameters = {};
    for k, v in pairs(string.slice(_Query, "#")) do
        local Value = v;
        Value = Value:replaceAll("<<<HT>>>", '#');
        Value = Value:replaceAll("<<<QT>>>", '"');
        Value = Value:replaceAll("<<<ES>>>", '');
        if Value == nil then
            Value = nil;
        elseif Value == "true" or Value == "false" then
            Value = Value == "true";
        elseif string.indexOf(Value, "{") == 1 then
            ---@diagnostic disable-next-line: param-type-mismatch
            local ValueTable = string.slice(string.sub(Value, 2, string.len(Value)-1), ",");
            Value = {};
            for i= 1, #ValueTable do
                Value[i] = (tonumber(ValueTable[i]) ~= nil and tonumber(ValueTable[i]) or ValueTable);
            end
        elseif tonumber(Value) ~= nil then
            Value = tonumber(Value);
        end
        table.insert(Parameters, Value);
    end
    return Parameters;
end

function Lib.Core.Report:SendScriptCommand(_ID, ...)
    assert(IsLocalScript(), "Commands must be send in local script.");
    assert(_ID and self.ScriptCommandRegister[_ID], "Command is invalid.");
    local PlayerID = GUI.GetPlayerID();
    local NamePlayerID = PlayerID +4;
    local PlayerName = Logic.GetPlayerName(NamePlayerID);
    local Parameters = self:EncodeScriptCommandParameters(...);
    GUI.SetPlayerName(NamePlayerID, Parameters);
    if IsHistoryEdition() and IsMultiplayer() then
        GUI.SetSoldierPaymentLevel(_ID);
    else
        ExecuteGlobal([[Lib.Core.Report:ProcessScriptCommand(%d, %d)]], PlayerID, _ID);
    end
    GUI.SetPlayerName(NamePlayerID, PlayerName);
end

function Lib.Core.Report:EncodeScriptCommandParameters(...)
    local Query = "";
    for i= 1, #arg do
        local Parameter = arg[i];
        if type(Parameter) == "string" then
            Parameter = Parameter:gsub('#', "<<<HT>>>");
            Parameter = Parameter:gsub('"', "<<<QT>>>");
            if Parameter:len() == 0 then
                Parameter = "<<<ES>>>";
            end
        elseif type(Parameter) == "table" then
            Parameter = "{" ..table.concat(Parameter, ",") .."}";
        end
        if string.len(Query) > 0 then
            Query = Query .. "#";
        end
        Query = Query .. tostring(Parameter);
    end
    return Query;
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Report:CreateReport(_Name)
    assert(type(_Name) == "string", "Report name must be a string.");
    for i= 1, #self.ScriptEventRegister, 1 do
        if self.ScriptEventRegister[i] == _Name then
            assert(false, "Report already exists");
            return 0;
        end
    end
    local ID = #self.ScriptEventRegister +1;
    self.ScriptEventRegister[ID] = _Name;
    self.ScriptEventListener[ID] = {SequenceID = 0};
    return ID;
end

function Lib.Core.Report:SendReport(_ID, ...)
    local arg = {...};
    assert(self.ScriptEventRegister[_ID] ~= nil, "Report type does not exist.");
    ---@diagnostic disable-next-line: undefined-global
    if GameCallback_Lib_OnReportReceived then
        GameCallback_Lib_OnReportReceived(_ID, unpack(arg));
    end
    if self.ScriptEventListener[_ID] then
        for k, v in pairs(self.ScriptEventListener[_ID]) do
            if tonumber(k) then
                v(unpack(arg));
            end
        end
    end
end

function Lib.Core.Report:CreateReportReceiver(_EventID, _Function)
    assert(type(_Function) == "function", "Listener must be a function.");
    assert(self.ScriptEventRegister[_EventID] ~= nil, "Event does not exist.");
    local Data = self.ScriptEventListener[_EventID];
    self.ScriptEventListener[_EventID].SequenceID = Data.SequenceID +1;
    self.ScriptEventListener[_EventID][Data.SequenceID] = _Function;
    return Data.SequenceID;
end

function Lib.Core.Report:RemoveReportReceiver(_EventID, _ID)
    assert(self.ScriptEventRegister[_EventID] ~= nil, "Event does not exist.");
    self.ScriptEventListener[_EventID][_ID] = nil;
end

-- -------------------------------------------------------------------------- --

function CreateReport(_Name)
    return Lib.Core.Report:CreateReport(_Name);
end
API.CreateScriptEvent = CreateReport;
API.RegisterScriptEvent = CreateReport;
API.CreateReport = CreateReport;

function SendReport(_ID, ...)
    local arg = {...};
    Lib.Core.Report:SendReport(_ID, unpack(arg));
end
API.SendScriptEvent = SendReport;
API.SendReport = SendReport;

function GetReportSender()
    return Lib.Core.Report:GetReportSourcePlayerID();
end
API.GetReportSender = GetReportSender;
API.GetReportSourcePlayerID = GetReportSender;

function SendReportToGlobal(_ID, ...)
    assert(IsLocalScript(), "Was called from global script.");
    Lib.Core.Report:SendScriptCommand(Command.SendReportToGlobal, _ID, ...);
end
API.SendReportToGlobal = SendReportToGlobal;
API.SendScriptEventToGlobal = SendReportToGlobal;

function SendReportToLocal(_ID, ...)
    assert(not IsLocalScript(), "Was called from local script.");
    local arg = {...};
    if #arg > 0 then
        local Parameter = "";
        for i= 1, #arg do
            if i > 1 then
                Parameter = Parameter.. ",";
            end
            if type(arg[i]) == "string" then
                Parameter = Parameter.. "\"" ..arg[i].. "\"";
            elseif type(arg[i]) == "table" then
                Parameter = Parameter.. table.tostring(arg[i]);
            else
                Parameter = Parameter.. tostring(arg[i]);
            end
        end
        ExecuteLocal([[SendReport(%d, %s)]], _ID, Parameter);
    else
        ExecuteLocal([[SendReport(%d)]], _ID);
    end
end
API.SendReportToLocal = SendReportToLocal;
API.SendScriptEventToLocal = SendReportToLocal;

function CreateReportReceiver(_EventID, _Function)
    return Lib.Core.Report:CreateReportReceiver(_EventID, _Function);
end
API.AddScriptEventListener = CreateReportReceiver;
API.CreateReportReceiver = CreateReportReceiver;

function RemoveReportReceiver(_EventID, _ID)
    Lib.Core.Report:RemoveReportReceiver(_EventID, _ID);
end
API.RemoveScriptEventListener = RemoveReportReceiver;
API.RemoveReportReceiver = RemoveReportReceiver;

