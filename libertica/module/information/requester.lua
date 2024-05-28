Lib.Requester = Lib.Requester or {};
Lib.Requester.Name = "Requester";
Lib.Requester.Global = {};
Lib.Requester.Local = {
    Chat = {
        Data = {},
        History = {},
        Visible = {},
        Widgets = {}
    },
    Requester = {
        ActionFunction = nil,
        ActionRequester = nil,
        Next = nil,
        Queue = {},
    },
};
Lib.Requester.Shared = {
    Text = {
        ChooseLanguage = {
            Title = {
                de = "Wählt die Sprache",
                en = "Chose your Tongue",
                fr = "Sélectionnez la langue",
            },
            Text = {
                de = "Wählt aus der Liste die Sprache aus, in die Handlungstexte übersetzt werden sollen.",
                en = "Choose from the list below which language story texts shall be presented to you.",
                fr = "Sélectionne dans la liste la langue dans laquelle les textes narratifs doivent être traduits.",
            }
        }
    },
};

Lib.Require("core/core");
Lib.Require("module/information/Requester_API");
Lib.Register("module/information/Requester");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Requester.Global:Initialize()
    if not self.IsInstalled then
        Report.RequesterClosed = CreateReport("Event_RequesterClosed");
        Report.LanguageSelectionClosed = CreateReport("Event_LanguageSelectionClosed");

        -- Garbage collection
        Lib.Requester.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Requester.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Requester.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.LanguageSelectionClosed then
        Lib.Core.Text:ChangeSystemLanguage(arg[1], arg[2], arg[3]);
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Requester.Local:Initialize()
    if not self.IsInstalled then
        Report.RequesterClosed = CreateReport("Event_RequesterClosed");
        Report.LanguageSelectionClosed = CreateReport("Event_LanguageSelectionClosed");

        for i= 1, 8 do
            self.Chat.Data[i] = {};
            self.Chat.History[i] = {};
            self.Chat.Visible[i] = false;
            self.Chat.Widgets[i] = {};
        end

        self:OverrideChatLog();
        self:DialogOverwriteOriginal();
        self:DialogAltF4Hotkey();

        -- Garbage collection
        Lib.Requester.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Requester.Local:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Requester.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.SaveGameLoaded then
        self:DialogAltF4Hotkey();
    end
end

-- ---------
-- Requester

function Lib.Requester.Local:DialogAltF4Hotkey()
    StartSimpleJobEx(function ()
        if Lib.Requester.Local.LoadscreenClosed then
            Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "Lib.Requester.Local:DialogAltF4Action()", 2, false);
            return true;
        end
    end);
end

function Lib.Requester.Local:DialogAltF4Action()
    Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "", 30, false);
    self:OpenRequesterDialog(
        GUI.GetPlayerID(),
        XGUIEng.GetStringTableText("UI_Texts/MainMenuExitGame_center"),
        XGUIEng.GetStringTableText("UI_Texts/ConfirmQuitCurrentGame"),
        function (_Yes)
            if _Yes then
                Framework.ExitGame();
            end
            if not Framework.IsNetworkGame() then
                Game.GameTimeSetFactor(GUI.GetPlayerID(), 1);
            end
            Lib.Requester.Local:DialogAltF4Hotkey();
        end
    );
end

function Lib.Requester.Local:Callback(_PlayerID)
    if self.Requester.ActionFunction then
        self.Requester.ActionFunction(CustomGame.Knight + 1, _PlayerID);
    end
    self:OnDialogClosed();
end

function Lib.Requester.Local:CallbackRequester(_yes, _PlayerID)
    if self.Requester.ActionRequester then
        self.Requester.ActionRequester(_yes, _PlayerID);
    end
    self:OnDialogClosed();
end

function Lib.Requester.Local:OnDialogClosed()
    if not self.SavingWasDisabled then
        DisableSaving(false);
    end
    if not IsMultiplayer() then
        Game.GameTimeSetFactor(GUI.GetPlayerID(), 1);
    end
    self.SavingWasDisabled = false;
    self.DialogWindowShown = false;
    self:DialogQueueStartNext();
end

function Lib.Requester.Local:DialogQueueStartNext()
    self.Requester.Next = table.remove(self.Requester.Queue, 1);

    RequestHiResJob(function()
        local Entry = Lib.Requester.Local.Requester.Next;
        if Entry and Entry[1] and Entry[2] then
            local Methode = Entry[1];
            Lib.Requester.Local[Methode](Lib.Requester.Local, unpack(Entry[2]));
            Lib.Requester.Local.Requester.Next = nil;
        end
        return true;
    end);
end

function Lib.Requester.Local:DialogQueuePush(_Methode, _Args)
    local Entry = {_Methode, _Args};
    table.insert(self.Requester.Queue, Entry);
end

function Lib.Requester.Local:OpenDialog(_PlayerID, _Title, _Text, _Action)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
        assert(type(_Title) == "string");
        assert(type(_Text) == "string");

        if not IsMultiplayer() then
            Game.GameTimeSetFactor(GUI.GetPlayerID(), 0.0000001);
        end

        _Title = "{center}" .. Lib.Core.Text:ConvertPlaceholders(_Title);
        _Text  = Lib.Core.Text:ConvertPlaceholders(_Text);
        if string.len(_Text) < 35 then
            _Text = _Text .. "{cr}";
        end

        g_MapAndHeroPreview.SelectKnight = function(_Knight)
        end

        XGUIEng.ShowAllSubWidgets("/InGame/Dialog/BG",1);
        XGUIEng.ShowWidget("/InGame/Dialog/Backdrop",0);
        XGUIEng.ShowWidget(RequesterDialog,1);
        XGUIEng.ShowWidget(RequesterDialog_Yes,0);
        XGUIEng.ShowWidget(RequesterDialog_No,0);
        XGUIEng.ShowWidget(RequesterDialog_Ok,1);

        if type(_Action) == "function" then
            self.Requester.ActionFunction = _Action;
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
            Action = Action .. "; XGUIEng.PopPage()";
            Action = Action .. "; Lib.Requester.Local.Callback(Lib.Requester.Local, GUI.GetPlayerID())";
            XGUIEng.SetActionFunction(RequesterDialog_Ok, Action);
        else
            self.Requester.ActionFunction = nil;
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
            Action = Action .. "; XGUIEng.PopPage()";
            Action = Action .. "; Lib.Requester.Local.Callback(Lib.Requester.Local, GUI.GetPlayerID())";
            XGUIEng.SetActionFunction(RequesterDialog_Ok, Action);
        end

        XGUIEng.SetText(RequesterDialog_Message, "{center}" .. _Text);
        XGUIEng.SetText(RequesterDialog_Title, _Title);
        XGUIEng.SetText(RequesterDialog_Title.."White", _Title);
        XGUIEng.PushPage(RequesterDialog,false);

        if Lib.Core.Save.SavingDisabled then
            self.SavingWasDisabled = true;
        end
        DisableSaving(true);
        self.DialogWindowShown = true;
    else
        self:DialogQueuePush("OpenDialog", {_PlayerID, _Title, _Text, _Action});
    end
end

function Lib.Requester.Local:OpenRequesterDialog(_PlayerID, _Title, _Text, _Action, _OkCancel)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
        assert(type(_Title) == "string");
        assert(type(_Text) == "string");
        _Title = "{center}" .. _Title;

        self:OpenDialog(_PlayerID, _Title, _Text, _Action);
        XGUIEng.ShowWidget(RequesterDialog_Yes,1);
        XGUIEng.ShowWidget(RequesterDialog_No,1);
        XGUIEng.ShowWidget(RequesterDialog_Ok,0);

        if _OkCancel then
            XGUIEng.SetText(RequesterDialog_Yes, XGUIEng.GetStringTableText("UI_Texts/Ok_center"));
            XGUIEng.SetText(RequesterDialog_No, XGUIEng.GetStringTableText("UI_Texts/Cancel_center"));
        else
            XGUIEng.SetText(RequesterDialog_Yes, XGUIEng.GetStringTableText("UI_Texts/Yes_center"));
            XGUIEng.SetText(RequesterDialog_No, XGUIEng.GetStringTableText("UI_Texts/No_center"));
        end

        self.Requester.ActionRequester = nil;
        if _Action then
            assert(type(_Action) == "function");
            self.Requester.ActionRequester = _Action;
        end
        local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
        Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; Lib.Requester.Local.CallbackRequester(Lib.Requester.Local, true, GUI.GetPlayerID())"
        XGUIEng.SetActionFunction(RequesterDialog_Yes, Action);
        local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)"
        Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; Lib.Requester.Local.CallbackRequester(Lib.Requester.Local, false, GUI.GetPlayerID())"
        XGUIEng.SetActionFunction(RequesterDialog_No, Action);
    else
        self:DialogQueuePush("OpenRequesterDialog", {_PlayerID, _Title, _Text, _Action, _OkCancel});
    end
end

function Lib.Requester.Local:OpenSelectionDialog(_PlayerID, _Title, _Text, _Action, _List)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
        self:OpenDialog(_PlayerID, _Title, _Text, _Action);

        local HeroComboBoxID = XGUIEng.GetWidgetID(CustomGame.Widget.KnightsList);
        XGUIEng.ListBoxPopAll(HeroComboBoxID);
        for i=1,#_List do
            XGUIEng.ListBoxPushItem(HeroComboBoxID, _List[i] );
        end
        XGUIEng.ListBoxSetSelectedIndex(HeroComboBoxID, 0);
        CustomGame.Knight = 0;

        local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)"
        Action = Action .. "; if not Framework.IsNetworkGame() then Game.GameTimeSetFactor(GUI.GetPlayerID(), 1) end";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; XGUIEng.PopPage()";
        Action = Action .. "; Lib.Requester.Local.Callback(Lib.Requester.Local, GUI.GetPlayerID())";
        XGUIEng.SetActionFunction(RequesterDialog_Ok, Action);

        local Container = "/InGame/Singleplayer/CustomGame/ContainerSelection/";
        XGUIEng.SetText(Container .. "HeroComboBoxMain/HeroComboBox", "");
        if _List[1] then
            XGUIEng.SetText(Container .. "HeroComboBoxMain/HeroComboBox", _List[1]);
        end
        XGUIEng.PushPage(Container .. "HeroComboBoxContainer", false);
        XGUIEng.PushPage(Container .. "HeroComboBoxMain",false);
        XGUIEng.ShowWidget(Container .. "HeroComboBoxContainer", 0);
        local screen = {GUI.GetScreenSize()};
        local x1, y1 = XGUIEng.GetWidgetScreenPosition(RequesterDialog_Ok);
        XGUIEng.SetWidgetScreenPosition(Container .. "HeroComboBoxMain", x1-25, y1-(90*(screen[2]/1080)));
        XGUIEng.SetWidgetScreenPosition(Container .. "HeroComboBoxContainer", x1-25, y1-(20*(screen[2]/1080)));
    else
        self:DialogQueuePush("OpenSelectionDialog", {_PlayerID, _Title, _Text, _Action, _List});
    end
end

function Lib.Requester.Local:DialogOverwriteOriginal()
    OpenDialog_Orig_Windows = OpenDialog;
    OpenDialog = function(_Message, _Title, _IsMPError)
        if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; XGUIEng.PopPage()";
            OpenDialog_Orig_Windows(_Title, _Message);
        end
    end

    OpenRequesterDialog_Orig_Windows = OpenRequesterDialog;
    OpenRequesterDialog = function(_Message, _Title, action, _OkCancel, no_action)
        if XGUIEng.IsWidgetShown(RequesterDialog) == 0 then
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; XGUIEng.PopPage()";
            XGUIEng.SetActionFunction(RequesterDialog_Yes, Action);
            local Action = "XGUIEng.ShowWidget(RequesterDialog, 0)";
            Action = Action .. "; XGUIEng.PopPage()";
            XGUIEng.SetActionFunction(RequesterDialog_No, Action);
            OpenRequesterDialog_Orig_Windows(_Message, _Title, action, _OkCancel, no_action);
        end
    end
end

-- --------
-- Chat Log

function Lib.Requester.Local:ShowTextWindow(_Data)
    _Data.PlayerID = _Data.PlayerID or 1;
    _Data.Button = _Data.Button or {};
    local PlayerID = GUI.GetPlayerID();
    if _Data.PlayerID ~= PlayerID then
        return;
    end
    if XGUIEng.IsWidgetShown("/InGame/Root/Normal/ChatOptions") == 1 then
        self:UpdateChatLogText(_Data);
        return;
    end
    self.Chat.Data[PlayerID] = _Data;
    self:CloseTextWindow(PlayerID);
    self:AlterChatLog();

    XGUIEng.SetText("/InGame/Root/Normal/ChatOptions/ChatLog", _Data.Content);
    XGUIEng.SetText("/InGame/Root/Normal/MessageLog/Name","{center}" .._Data.Caption);
    if _Data.DisableClose then
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions/Exit",0);
    end
    self:ShouldShowSlider(_Data.Content);
    XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions",1);
end

function Lib.Requester.Local:CloseTextWindow(_PlayerID)
    assert(_PlayerID ~= nil);
    local PlayerID = GUI.GetPlayerID();
    if _PlayerID ~= PlayerID then
        return;
    end
    GUI_Chat.CloseChatMenu();
end

function Lib.Requester.Local:UpdateChatLogText(_Data)
    XGUIEng.SetText("/InGame/Root/Normal/ChatOptions/ChatLog", _Data.Content);
end

function Lib.Requester.Local:AlterChatLog()
    local PlayerID = GUI.GetPlayerID();
    if self.Chat.Visible[PlayerID] then
        return;
    end
    self.Chat.Visible[PlayerID] = true;
    self.Chat.History[PlayerID] = table.copy(g_Chat.ChatHistory);
    g_Chat.ChatHistory = {};
    self:AlterChatLogDisplay();
end

function Lib.Requester.Local:RestoreChatLog()
    local PlayerID = GUI.GetPlayerID();
    if not self.Chat.Visible[PlayerID] then
        return;
    end
    self.Chat.Visible[PlayerID] = false;
    g_Chat.ChatHistory = {};
    for i= 1, #self.Chat.History[PlayerID] do
        GUI_Chat.ChatlogAddMessage(self.Chat.History[PlayerID][i]);
    end
    self:RestoreChatLogDisplay();
    self.Chat.History[PlayerID] = {};
    self.Chat.Widgets[PlayerID] = {};
    self.Chat.Data[PlayerID] = {};
end

function Lib.Requester.Local:UpdateToggleWhisperTarget()
    local PlayerID = GUI.GetPlayerID();
    local MotherWidget = "/InGame/Root/Normal/ChatOptions/";
    if not self.Chat.Data[PlayerID] or not self.Chat.Data[PlayerID].Button
    or not self.Chat.Data[PlayerID].Button.Action then
        XGUIEng.ShowWidget(MotherWidget.. "ToggleWhisperTarget",0);
        return;
    end
    local ButtonText = self.Chat.Data[PlayerID].Button.Text;
    XGUIEng.SetText(MotherWidget.. "ToggleWhisperTarget","{center}" ..ButtonText);
end

function Lib.Requester.Local:ShouldShowSlider(_Text)
    local stringlen = string.len(_Text);
    local iterator  = 1;
    local carreturn = 0;
    while (true)
    do
        local s,e = string.find(_Text, "{cr}", iterator);
        if not e then
            break;
        end
        if e-iterator <= 58 then
            stringlen = stringlen + 58-(e-iterator);
        end
        iterator = e+1;
    end
    if (stringlen + (carreturn*55)) > 1000 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions/ChatLogSlider",1);
    end
end

function Lib.Requester.Local:OverrideChatLog()
    GUI_Chat.ChatlogAddMessage_Orig_Requester = GUI_Chat.ChatlogAddMessage;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Chat.ChatlogAddMessage = function(_Message)
        local PlayerID = GUI.GetPlayerID();
        if not Lib.Requester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.ChatlogAddMessage_Orig_Requester(_Message);
            return;
        end
        table.insert(Lib.Requester.Local.Chat.History[PlayerID], _Message);
    end

    GUI_Chat.DisplayChatLog_Orig_Requester = GUI_Chat.DisplayChatLog;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Chat.DisplayChatLog = function()
        local PlayerID = GUI.GetPlayerID();
        if not Lib.Requester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.DisplayChatLog_Orig_Requester();
        end
    end

    GUI_Chat.CloseChatMenu_Orig_Requester = GUI_Chat.CloseChatMenu;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Chat.CloseChatMenu = function()
        local PlayerID = GUI.GetPlayerID();
        if not Lib.Requester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.CloseChatMenu_Orig_Requester();
            return;
        end
        Lib.Requester.Local:RestoreChatLog();
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatOptions",0);
    end

    GUI_Chat.ToggleWhisperTargetUpdate_Orig_Requester = GUI_Chat.ToggleWhisperTargetUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Chat.ToggleWhisperTargetUpdate = function()
        local PlayerID = GUI.GetPlayerID();
        if not Lib.Requester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.ToggleWhisperTargetUpdate_Orig_Requester();
            return;
        end
        Lib.Requester.Local:UpdateToggleWhisperTarget();
    end

    GUI_Chat.CheckboxMessageTypeWhisperUpdate_Orig_Requester = GUI_Chat.CheckboxMessageTypeWhisperUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Chat.CheckboxMessageTypeWhisperUpdate = function()
        local PlayerID = GUI.GetPlayerID();
        if not Lib.Requester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.CheckboxMessageTypeWhisperUpdate_Orig_Requester();
            return;
        end
    end

    GUI_Chat.ToggleWhisperTarget_Orig_Requester = GUI_Chat.ToggleWhisperTarget;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Chat.ToggleWhisperTarget = function()
        local PlayerID = GUI.GetPlayerID();
        if not Lib.Requester.Local.Chat.Visible[PlayerID] then
            GUI_Chat.ToggleWhisperTarget_Orig_Requester();
            return;
        end
        if Lib.Requester.Local.Chat.Data[PlayerID].Button.Action then
            local Data = Lib.Requester.Local.Chat.Data[PlayerID];
            Lib.Requester.Local.Chat.Data[PlayerID].Button.Action(Data);
        end
    end
end

function Lib.Requester.Local:AlterChatLogDisplay()
    local PlayerID = GUI.GetPlayerID();

    local w,h,x,y;
    local Widget;
    local MotherWidget = "/InGame/Root/Normal/ChatOptions/";
    x,y = XGUIEng.GetWidgetLocalPosition(MotherWidget.. "ToggleWhisperTarget");
    w,h = XGUIEng.GetWidgetSize(MotherWidget.. "ToggleWhisperTarget");
    self.Chat.Widgets[PlayerID]["ToggleWhisperTarget"] = {X= x, Y= y, W= w, H= h};
    Widget = self.Chat.Widgets[PlayerID]["ToggleWhisperTarget"];

    x,y = XGUIEng.GetWidgetLocalPosition(MotherWidget.. "ChatLog");
    w,h = XGUIEng.GetWidgetSize(MotherWidget.. "ChatLog");
    self.Chat.Widgets[PlayerID]["ChatLog"] = {X= x, Y= y, W= w, H= h};
    Widget = self.Chat.Widgets[PlayerID]["ChatLog"];

    x,y = XGUIEng.GetWidgetLocalPosition(MotherWidget.. "ChatLogSlider");
    w,h = XGUIEng.GetWidgetSize(MotherWidget.. "ChatLogSlider");
    self.Chat.Widgets[PlayerID]["ChatLogSlider"] = {X= x, Y= y, W= w, H= h};
    Widget = self.Chat.Widgets[PlayerID]["ChatLogSlider"];

    XGUIEng.ShowWidget(MotherWidget.. "ChatModeAllPlayers",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatModeTeam",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatModeWhisper",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatChooseModeCaption",0);
    XGUIEng.ShowWidget(MotherWidget.. "Background/TitleBig",1);
    XGUIEng.ShowWidget(MotherWidget.. "Background/TitleBig/Info",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatLogCaption",0);
    XGUIEng.ShowWidget(MotherWidget.. "BGChoose",0);
    XGUIEng.ShowWidget(MotherWidget.. "BGChatLog",0);
    XGUIEng.ShowWidget(MotherWidget.. "ChatLogSlider",0);

    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog",1);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog/BG",0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog/Close",0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog/Slider",0);
    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog/Text",0);
    XGUIEng.SetText("/InGame/Root/Normal/MessageLog/Name","{center}Test");
    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/MessageLog",15,90);
    XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/MessageLog/Name",0,0);
    XGUIEng.SetTextColor("/InGame/Root/Normal/MessageLog/Name",51,51,121,255);

    XGUIEng.SetWidgetSize(MotherWidget.. "ChatLogSlider",46,600);
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ChatLogSlider",780,130);
    XGUIEng.SetWidgetSize(MotherWidget.. "Background/DialogBG/1 (2)/2",150,400);
    XGUIEng.SetWidgetPositionAndSize(MotherWidget.. "Background/DialogBG/1 (2)/3",400,500,350,400);
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ToggleWhisperTarget",280,760);
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ChatLog",140,150);
    XGUIEng.SetWidgetSize(MotherWidget.. "ChatLog",640,560);
end

function Lib.Requester.Local:RestoreChatLogDisplay()
    local PlayerID = GUI.GetPlayerID();

    local Widget;
    local MotherWidget = "/InGame/Root/Normal/ChatOptions/";
    Widget = self.Chat.Widgets[PlayerID]["ToggleWhisperTarget"];
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ToggleWhisperTarget", Widget.X, Widget.Y);
    XGUIEng.SetWidgetSize(MotherWidget.. "ToggleWhisperTarget", Widget.W, Widget.H);
    Widget = self.Chat.Widgets[PlayerID]["ChatLog"];
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ChatLog", Widget.X, Widget.Y);
    XGUIEng.SetWidgetSize(MotherWidget.. "ChatLog", Widget.W, Widget.H);
    Widget = self.Chat.Widgets[PlayerID]["ChatLogSlider"];
    XGUIEng.SetWidgetLocalPosition(MotherWidget.. "ChatLogSlider", Widget.X, Widget.Y);
    XGUIEng.SetWidgetSize(MotherWidget.. "ChatLogSlider", Widget.W, Widget.H);

    XGUIEng.ShowWidget(MotherWidget.. "ChatModeAllPlayers",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatModeTeam",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatModeWhisper",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatChooseModeCaption",1);
    XGUIEng.ShowWidget(MotherWidget.. "Background/TitleBig",1);
    XGUIEng.ShowWidget(MotherWidget.. "Background/TitleBig/Info",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatLogCaption",1);
    XGUIEng.ShowWidget(MotherWidget.. "BGChoose",1);
    XGUIEng.ShowWidget(MotherWidget.. "BGChatLog",1);
    XGUIEng.ShowWidget(MotherWidget.. "ChatLogSlider",1);
    XGUIEng.ShowWidget(MotherWidget.. "ToggleWhisperTarget",1);

    XGUIEng.ShowWidget("/InGame/Root/Normal/MessageLog",0);
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Requester.Name);

