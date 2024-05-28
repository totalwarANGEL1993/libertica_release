Lib.Core = Lib.Core or {};
Lib.Core.Chat = {
    DebugInput = {};
};

Lib.Require("comfort/IsLocalScript");
Lib.Require("core/feature/Core_Report");
Lib.Require("core/feature/Core_Job");
Lib.Register("core/feature/Core_Chat");

-- -------------------------------------------------------------------------- --

function Lib.Core.Chat:Initialize()
    Report.ChatOpened = CreateReport("Event_ChatOpened");
    Report.ChatClosed = CreateReport("Event_ChatClosed");
    for i= 1, 8 do
        self.DebugInput[i] = {};
    end
end

function Lib.Core.Chat:OnSaveGameLoaded()
end

function Lib.Core.Chat:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Chat:ShowTextInput(_PlayerID, _AllowDebug)
    if Lib.IsHistoryEdition and Framework.IsNetworkGame() then
        return;
    end
    if not GUI then
        ExecuteLocal([[Lib.Core.Chat:ShowTextInput(%d, %s)]], _PlayerID,tostring(_AllowDebug == true));
        return;
    end
    _PlayerID = _PlayerID or GUI.GetPlayerID();
    self:PrepareInputVariable(_PlayerID);
    self:ShowInputBox(_PlayerID, _AllowDebug == true);
end

function Lib.Core.Chat:ShowInputBox(_PlayerID, _Debug)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.DebugInput[_PlayerID] = _Debug == true;

    RequestJobByEventType(
        Events.LOGIC_EVENT_EVERY_TURN,
        function ()
            -- Open chat
            Input.ChatMode();
            XGUIEng.SetText("/InGame/Root/Normal/ChatInput/ChatInput", "");
            XGUIEng.ShowWidget("/InGame/Root/Normal/ChatInput", 1);
            XGUIEng.SetFocus("/InGame/Root/Normal/ChatInput/ChatInput");
            -- Send events
            SendReportToGlobal(Report.ChatOpened, _PlayerID);
            SendReport(Report.ChatOpened,_PlayerID);

            -- Slow down game time. We can not set the game time to 0 because
            -- then Logic.ExecuteInLuaLocalState and GUI.SendScriptCommand do
            -- not work anymore.
            if not Framework.IsNetworkGame() then
                Game.GameTimeSetFactor(GUI.GetPlayerID(), 0.0000001);
            end
            return true;
        end
    )
end

function Lib.Core.Chat:PrepareInputVariable(_PlayerID)
    if not IsLocalScript() then
        return;
    end

    GUI_Chat.Abort_Orig_Core = GUI_Chat.Abort_Orig_Core or GUI_Chat.Abort;
    GUI_Chat.Confirm_Orig_Core = GUI_Chat.Confirm_Orig_Core or GUI_Chat.Confirm;

    GUI_Chat.Confirm = function()
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatInput", 0);
        local ChatMessage = XGUIEng.GetText("/InGame/Root/Normal/ChatInput/ChatInput");
        local IsDebug = Lib.Core.Chat.DebugInput[_PlayerID];
        Lib.Core.Chat.ChatBoxInput = ChatMessage;
        Lib.Core.Chat:SendInputAsEvent(ChatMessage, IsDebug);
        g_Chat.JustClosed = 1;
        if not Framework.IsNetworkGame() then
            Game.GameTimeSetFactor(_PlayerID, 1);
        end
        Input.GameMode();
        if  ChatMessage:len() > 0
        and Framework.IsNetworkGame()
        and not IsDebug then
            GUI.SendChatMessage(
                ChatMessage,
                _PlayerID,
                g_Chat.CurrentMessageType,
                g_Chat.CurrentWhisperTarget
            );
        end
    end

    if not Framework.IsNetworkGame() then
        GUI_Chat.Abort = function()
        end
    end
end

function Lib.Core.Chat:SendInputAsEvent(_Text, _Debug)
    _Text = (_Text == nil and "") or _Text;
    local PlayerID = GUI.GetPlayerID();
    -- Send chat input to global script
    SendReportToGlobal(
        Report.ChatClosed,
        (_Text or "<<<ES>>>"),
        GUI.GetPlayerID(),
        _Debug == true
    );
    -- Send chat input to local script
    SendReport(
        Report.ChatClosed,
        (_Text or "<<<ES>>>"),
        GUI.GetPlayerID(),
        _Debug == true
    );
    -- Reset debug flag
    self.DebugInput[PlayerID] = false;
end

-- -------------------------------------------------------------------------- --

function ShowTextInput(_PlayerID, _AllowDebug)
    Lib.Core.Chat:ShowTextInput(_PlayerID, _AllowDebug);
end
API.ShowTextInput = ShowTextInput;

