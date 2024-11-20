Lib.Require("comfort/IsLocalScript");
Lib.Register("module/quest/QuestJornal_API");

function ShowJournalForQuest(_Quest, _Flag)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Quest = Quests[GetQuestID(_Quest)];
    if Quest then
        Quest.QuestNotes = _Flag == true;
    end
end

function AllowNotesForQuest(_Quest, _Flag)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Quest = Quests[GetQuestID(_Quest)];
    if Quest then
        Lib.QuestJornal.Global.CustomInputAllowed[_Quest] = _Flag == true;
    end
end

function CreateJournalEntry(_Text)
    assert(not IsLocalScript(), "Can not be used in local script!");
    _Text = _Text:gsub("{@[A-Za-z0-9:,]+}", "");
    _Text = _Text:gsub("{[A-Za-z0-9_]+}", "");
    return Lib.QuestJornal.Global:CreateJournalEntry(_Text, 0, false);
end

function AlterJournalEntry(_ID, _Text)
    assert(not IsLocalScript(), "Can not be used in local script!");
    _Text = _Text:gsub("{@[A-Za-z0-9:,]+}", "");
    _Text = _Text:gsub("{[A-Za-z0-9_]+}", "");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:UpdateJournalEntry(
            _ID,
            _Text,
            Entry.Rank,
            Entry.AlwaysVisible,
            Entry.Deleted
        );
    end
end

function HighlightJournalEntry(_ID, _Important)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:UpdateJournalEntry(
            _ID,
            Entry[1],
            (_Important == true and 1) or 0,
            Entry.AlwaysVisible,
            Entry.Deleted
        );
    end
end

function DeleteJournalEntry(_ID)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:UpdateJournalEntry(
            _ID,
            Entry[1],
            Entry.Rank,
            Entry.AlwaysVisible,
            true
        );
    end
end

function RestoreJournalEntry(_ID)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:UpdateJournalEntry(
            _ID,
            Entry[1],
            Entry.Rank,
            Entry.AlwaysVisible,
            false
        );
    end
end

function AddJournalEntryToQuest(_ID, _Quest)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:AssociateJournalEntryWithQuest(_ID, _Quest, true);
    end
end

function RemoveJournalEntryFromQuest(_ID, _Quest)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:AssociateJournalEntryWithQuest(_ID, _Quest, false);
    end
end

