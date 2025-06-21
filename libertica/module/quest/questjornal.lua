Lib.QuestJornal = Lib.QuestJornal or {};
Lib.QuestJornal.Name = "QuestJornal";
Lib.QuestJornal.Global = {
    Journal = {ID = 0},
    CustomInputAllowed = {},
    InputShown = {},
    TextColor  = "{tooltip}",
};
Lib.QuestJornal.Local = {
    NextButton = "/InGame/Root/Normal/AlignBottomLeft/Message/MessagePortrait/TutorialNextButton",
    NextButtonIcon = {16, 10},
};
Lib.QuestJornal.Text = {
    Next  = {de = "Tagebuch anzeigen", en = "Show Journal", fr = "Afficher le journal"},
    Title = {de = "Tagebuch",          en = "Journal",      fr = "Journal"},
    Note  = {de = "Notiz",             en = "Note",         fr = "Note"},
};

Lib.Require("core/core");
Lib.Require("module/information/Requester");
Lib.Require("module/quest/Quest");
Lib.Require("module/quest/QuestJornal_API");
Lib.Require("module/quest/QuestJornal_Behavior");
Lib.Register("module/quest/QuestJornal");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.QuestJornal.Global:Initialize()
    if not self.IsInstalled then
        Report.QuestJournalDisplayed = CreateReport("Event_QuestJournalDisplayed");
        Report.QuestJournalPlayerNote = CreateReport("Event_QuestJournalPlayerNote");
        Report.TutorialNextClicked = CreateReport("Event_TutorialNextClicked");

        -- Garbage collection
        Lib.QuestJornal.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.QuestJornal.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.QuestJornal.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.TutorialNextClicked then
        self:DisplayJournal(arg[1], arg[2]);
    elseif _ID == Report.ChatClosed then
        self:ProcessChatInput(arg[1], arg[2]);
    elseif _ID == Report.QuestJournalPlayerNote then
        self.InputShown[arg[1]] = arg[2];
        SendReportToLocal(Report.QuestJournalPlayerNote, arg[1], arg[2], arg[3] == true);
    elseif _ID == Report.QuestJournalDisplayed then
        SendReportToLocal(Report.QuestJournalDisplayed, arg[1], arg[2], arg[3], arg[4]);
    end
end

function Lib.QuestJornal.Global:DisplayJournal(_QuestName, _PlayerID)
    local CustomInput = self.CustomInputAllowed[_QuestName] == true;
    local FullText = self:FormatJournalEntry(_QuestName, _PlayerID);
    SendReport(
        Report.QuestJournalDisplayed,
        _PlayerID, _QuestName, FullText, CustomInput
    );
end

function Lib.QuestJornal.Global:CreateJournalEntry(_Text, _Rank, _AlwaysVisible)
    self.Journal.ID = self.Journal.ID +1;
    table.insert(self.Journal, {
        ID            = self.Journal.ID,
        AlwaysVisible = _AlwaysVisible == true,
        Quests        = {},
        Rank          = _Rank,
        _Text
    });
    return self.Journal.ID;
end

function Lib.QuestJornal.Global:GetJournalEntry(_ID)
    for i= 1, #self.Journal do
        if self.Journal[i].ID == _ID then
            return self.Journal[i];
        end
    end
end

function Lib.QuestJornal.Global:UpdateJournalEntry(_ID, _Text, _Rank, _AlwaysVisible, _Deleted)
    for i= 1, #self.Journal do
        if self.Journal[i].ID == _ID then
            self.Journal[i].AlwaysVisible = _AlwaysVisible == true;
            self.Journal[i].Deleted       = _Deleted == true;
            self.Journal[i].Rank          = _Rank;

            self.Journal[i][1] = self.Journal[i][1] or _Text;
        end
    end
end

function Lib.QuestJornal.Global:AssociateJournalEntryWithQuest(_ID, _Quest, _Flag)
    for i= 1, #self.Journal do
        if self.Journal[i].ID == _ID then
            self.Journal[i].Quests[_Quest] = _Flag == true;
        end
    end
end

function Lib.QuestJornal.Global:FormatJournalEntry(_QuestName, _PlayerID)
    local Quest = Quests[GetQuestID(_QuestName)];
    --- @diagnostic disable-next-line: undefined-field
    if Quest and Quest.QuestNotes and Quest.ReceivingPlayer == _PlayerID then
        local Journal = self:GetJournalEntriesSorted();
        local SeperateImportant = false;
        local SeperateNormal = false;
        local Info = "";
        local Color = "";
        for i= 1, #Journal, 1 do
            if Journal[i].AlwaysVisible or Journal[i].Quests[_QuestName] then
                if not Journal[i].Deleted then
                    local Text = ConvertPlaceholders(Localize(Journal[i][1]));

                    if Journal[i].Rank == 1 then
                        Text = "{scarlet}" .. Text .. self.TextColor;
                        SeperateImportant = true;
                    end
                    if Journal[i].Rank == 0 then
                        if SeperateImportant then
                            SeperateImportant = false;
                            Text = "{cr}----------{cr}{cr}" .. Text;
                        end
                        SeperateNormal = true;
                    end
                    if Journal[i].Rank == -1 then
                        if SeperateNormal then
                            SeperateNormal = false;
                            Color = "{violet}";
                            Text = "{cr}----------{cr}{cr}" .. Text;
                        end
                        Text = Color .. Text .. self.TextColor;
                    end

                    Info = Info .. ((Info ~= "" and "{cr}") or "") .. Text;
                end
            end
        end
        return Info;
    end
end

function Lib.QuestJornal.Global:GetJournalEntriesSorted()
    local Journal = {};
    for i= 1, #self.Journal, 1 do
        table.insert(Journal, self.Journal[i]);
    end
    table.sort(Journal, function(a, b)
        return a.Rank > b.Rank;
    end)
    return Journal;
end

function Lib.QuestJornal.Global:ProcessChatInput(_Text, _PlayerID)
    if self.InputShown[_PlayerID] then
        if _Text and _Text ~= "" then
            local QuestName = self.InputShown[_PlayerID];
            local CustomInput = self.CustomInputAllowed[QuestName] == true;
            local ID = self:CreateJournalEntry(_Text, -1, false)
            self:AssociateJournalEntryWithQuest(ID, QuestName, true);
            local FullText = self:FormatJournalEntry(QuestName, _PlayerID);

            SendReport(
                Report.QuestJournalDisplayed,
                _PlayerID, QuestName, FullText, CustomInput
            );
        end
        self.InputShown[_PlayerID] = nil;
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.QuestJornal.Local:Initialize()
    if not self.IsInstalled then
        Report.QuestJournalDisplayed = CreateReport("Event_QuestJournalDisplayed");
        Report.QuestJournalPlayerNote = CreateReport("Event_QuestJournalPlayerNote");
        Report.TutorialNextClicked = CreateReport("Event_TutorialNextClicked");

        self:OverrideUpdateVoiceMessage();
        self:OverrideTutorialNext();
        self:OverrideStringKeys();
        self:OverrideTimerButtons();

        -- Garbage collection
        Lib.QuestJornal.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.QuestJornal.Local:OnSaveGameLoaded()
end

-- Global report listener
function Lib.QuestJornal.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.QuestJournalPlayerNote then
        if arg[1] == GUI.GetPlayerID() and arg[3] then
            --- @diagnostic disable-next-line: param-type-mismatch
            ShowTextInput(arg[1], false);
        end
    elseif _ID == Report.QuestJournalDisplayed then
        if arg[1] == GUI.GetPlayerID() then
            self:DisplayQuestJournal(arg[2], arg[1], arg[3], arg[4]);
        end
    end
end

function Lib.QuestJornal.Local:DisplayQuestJournal(_QuestName, _PlayerID, _Info, _Input)
    if _Info and GUI.GetPlayerID() == _PlayerID then
        local Title = Localize(Lib.QuestJornal.Text.Title);
        local Data = {
            PlayerID  = _PlayerID,
            Caption   = Title,
            Content   = ConvertPlaceholders(_Info),
            QuestName = _QuestName
        }
        if _Input then
            Data.Button = {
                Text   = Localize{de = "Notiz", en = "Note", fr = "Note"},
                Action = function(_Data)
                    SendReportToGlobal(Report.QuestJournalPlayerNote, _Data.PlayerID, _Data.QuestName, _Input);
                end
            }
        end
        Lib.Requester.Local:ShowTextWindow(Data);
    end
end

function Lib.QuestJornal.Local:OverrideUpdateVoiceMessage()
    GUI_Interaction.UpdateVoiceMessage_Orig_QuestJornal = GUI_Interaction.UpdateVoiceMessage;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Interaction.UpdateVoiceMessage = function()
        GUI_Interaction.UpdateVoiceMessage_Orig_QuestJornal();
        if not QuestLog.IsQuestLogShown() then
            if Lib.QuestJornal.Local:IsShowingJournalButton(g_Interaction.CurrentMessageQuestIndex) then
                XGUIEng.ShowWidget(Lib.QuestJornal.Local.NextButton, 1);
                SetIcon(
                    Lib.QuestJornal.Local.NextButton,
                    Lib.QuestJornal.Local.NextButtonIcon
                );
            else
                XGUIEng.ShowWidget(Lib.QuestJornal.Local.NextButton, 0);
            end
        end
    end
end

function Lib.QuestJornal.Local:IsShowingJournalButton(_ID)
    if not g_Interaction.CurrentMessageQuestIndex then
        return false;
    end
    local Quest = Quests[_ID];
    if type(Quest) == "table" and Quest.QuestNotes then
        return true;
    end
    return false;
end

function Lib.QuestJornal.Local:OverrideTimerButtons()
    GUI_Interaction.TimerButtonClicked_Orig_QuestJornal = GUI_Interaction.TimerButtonClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Interaction.TimerButtonClicked = function()
        if  XGUIEng.IsWidgetShown("/InGame/Root/Normal/ChatOptions") == 1
        and XGUIEng.IsWidgetShown("/InGame/Root/Normal/ChatOptions/ToggleWhisperTarget") == 1 then
            return;
        end
        GUI_Interaction.TimerButtonClicked_Orig_QuestJornal();
    end
end

function Lib.QuestJornal.Local:OverrideTutorialNext()
    GUI_Interaction.TutorialNext_Orig_QuestJornal = GUI_Interaction.TutorialNext;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Interaction.TutorialNext = function()
        if g_Interaction.CurrentMessageQuestIndex then
            local QuestID = g_Interaction.CurrentMessageQuestIndex;
            local Quest = Quests[QuestID];
            --- @diagnostic disable-next-line: undefined-field
            SendReportToGlobal(Report.TutorialNextClicked, Quest.Identifier, GUI.GetPlayerID());
            --- @diagnostic disable-next-line: undefined-field
            SendReport(Report.TutorialNextClicked, Quest.Identifier, GUI.GetPlayerID());
        end
    end
end

function Lib.QuestJornal.Local:OverrideStringKeys()
    AddStringText("UI_ObjectNames/TutorialNextButton", Lib.QuestJornal.Text.Next);
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.QuestJornal.Name);

