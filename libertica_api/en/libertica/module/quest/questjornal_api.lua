--- Allows to add notes to a quest.
--- 
Lib.QuestJornal = Lib.QuestJornal or {};



--- Activates or deactivates the jornal or a spezific quest.
--- @param _Quest string Name of quest
--- @param _Flag boolean Activate/deactivate
function ShowJournalForQuest(_Quest, _Flag)
end

--- Allows the player to make notes in the jornal.
--- @param _Quest string Name of quest
--- @param _Flag boolean Activate/deactivate
function AllowNotesForQuest(_Quest, _Flag)
end

--- Creates a new journal entry and returns the ID.
---
--- The entry can be added to any jornal of any quest.
--- @param _Text string Text of entry
--- @return integer ID ID of entry
function CreateJournalEntry(_Text)
    return 0;
end

--- Updates the journal entry with the ID.
--- @param _ID integer ID of entry
--- @param _Text string Text of entry
function AlterJournalEntry(_ID, _Text)
end

--- Marks an journal entry as important and highlights it.
--- @param _ID integer ID of entry
--- @param _Important boolean Highlight entry
function HighlightJournalEntry(_ID, _Important)
end

--- Deletes an entry. The entry will be deleted from all journals it is
--- attached to.
--- @param _ID integer ID of entry
function DeleteJournalEntry(_ID)
end

--- Restores an deleted entry. The entry will reappear in all journals it
--- is attached to.
--- @param _ID integer ID of entry
function RestoreJournalEntry(_ID)
end

--- Adds a entry to the jornal of the quest.
--- @param _ID integer ID of entry
--- @param _Quest string Name of quest
function AddJournalEntryToQuest(_ID, _Quest)
end

--- Removes a entry from the journal of the quest.
--- @param _ID integer ID of entry
--- @param _Quest string Name of quest
function RemoveJournalEntryFromQuest(_ID, _Quest)
end

