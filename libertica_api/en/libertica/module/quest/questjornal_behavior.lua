--- Adds behavior to control notes.

--- Shows or hides the journal for a quest.
--- 
--- @param _QuestName string Name of the quest
--- @param _Active boolean Journal is active
function Reprisal_JournalEnable(_QuestName, _Active)
end

--- Shows or hides the journal for a quest.
--- 
--- @param _QuestName string Name of the quest
--- @param _Active boolean Journal is active
function Reward_JournalEnable(_QuestName, _Active)
end

--- Writes a journal entry for the specified quest.
--- 
--- @param _QuestName string Name of the quest
--- @param _EntryName string Name of the entry
--- @param _EntryText string Text of the entry
function Reprisal_JournalWrite(_QuestName, _EntryName, _EntryText)
end

--- Writes a journal entry for the specified quest.
--- 
--- @param _QuestName string Name of the quest
--- @param _EntryName string Name of the entry
--- @param _EntryText string Text of the entry
function Reward_JournalWrite(_QuestName, _EntryName, _EntryText)
end

--- Removes a journal entry from a quest.
--- 
--- @param _QuestName string Name of the quest
--- @param _EntryName string Name of the entry
function Reprisal_JournalRemove(_QuestName, _EntryName)
end

--- Removes a journal entry from a quest.
--- 
--- @param _QuestName string Name of the quest
--- @param _EntryName string Name of the entry
function Reward_JournalRemove(_QuestName, _EntryName)
end

--- Highlights a journal entry or resets it to normal.
--- 
--- @param _QuestName string Name of the quest
--- @param _EntryName string Name of the entry
--- @param _Highlighted boolean Entry is highlighted
function Reprisal_JournaHighlight(_QuestName, _EntryName, _Highlighted)
end

--- Highlights a journal entry or resets it to normal.
--- 
--- @param _QuestName string Name of the quest
--- @param _EntryName string Name of the entry
--- @param _Highlighted boolean Entry is highlighted
function Reward_JournaHighlight(_QuestName, _EntryName, _Highlighted)
end

