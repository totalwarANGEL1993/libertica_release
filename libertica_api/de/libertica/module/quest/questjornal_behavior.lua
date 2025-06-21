--- Fügt Behavior zur Steuerung von Notizen hinzu.

--- Zeigt das Tagebuch für einen Quest an oder versteckt es.
--- 
--- @param _QuestName string Name des Quest
--- @param _Active boolean Tagebuch ist aktiv
function Reprisal_JournalEnable(_QuestName, _Active)
end

--- Zeigt das Tagebuch für einen Quest an oder versteckt es.
--- 
--- @param _QuestName string Name des Quest
--- @param _Active boolean Tagebuch ist aktiv
function Reward_JournalEnable(_QuestName, _Active)
end

--- Schreibt einen Tagebucheintrag zu dem angegebenen Quest.
--- 
--- @param _QuestName string Name des Quest
--- @param _EntryName string Name des Eintrag
--- @param _EntryText string Text des Eintrag
function Reprisal_JournalWrite(_QuestName, _EntryName, _EntryText)
end

--- Schreibt einen Tagebucheintrag zu dem angegebenen Quest.
--- 
--- @param _QuestName string Name des Quest
--- @param _EntryName string Name des Eintrag
--- @param _EntryText string Text des Eintrag
function Reward_JournalWrite(_QuestName, _EntryName, _EntryText)
end

--- Entfernt einen Tagebucheintrag von einem Quest.
--- 
--- @param _QuestName string Name des Quest
--- @param _EntryName string Name des Eintrag
function Reprisal_JournalRemove(_QuestName, _EntryName)
end

--- Entfernt einen Tagebucheintrag von einem Quest.
--- 
--- @param _QuestName string Name des Quest
--- @param _EntryName string Name des Eintrag
function Reward_JournalRemove(_QuestName, _EntryName)
end

--- Hebt einen Eintrag im Tagebuch hervor oder setzt ihn auf normal zurück.
--- 
--- @param _QuestName string Name des Quest
--- @param _EntryName string Name des Eintrag
--- @param _Highlighted boolean Eintrag ist hervorgehoben
function Reprisal_JournaHighlight(_QuestName, _EntryName, _Highlighted)
end

--- Hebt einen Eintrag im Tagebuch hervor oder setzt ihn auf normal zurück.
--- 
--- @param _QuestName string Name des Quest
--- @param _EntryName string Name des Eintrag
--- @param _Highlighted boolean Eintrag ist hervorgehoben
function Reward_JournaHighlight(_QuestName, _EntryName, _Highlighted)
end

