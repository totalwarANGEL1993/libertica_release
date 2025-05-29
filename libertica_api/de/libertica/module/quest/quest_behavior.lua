--- Fügt Behavior für das Management von Quests hinzu.

--- Der Quest muss erfolgreich sein.
--- 
--- @param _QuestName string Name der Quest
function Goal_WinQuest(_QuestName)
end

--- Es müssen mindestens X von Y Spielern entdeckt werden.
--- 
--- @param _Amount integer Anzahl der Spieler (min. 1, max 5)
--- @param _Player1 integer ID des Spielers
--- @param _Player2 integer (Optional) ID des Spielers
--- @param _Player3 integer (Optional) ID des Spielers
--- @param _Player4 integer (Optional) ID des Spielers
--- @param _Player5 integer (Optional) ID des Spielers
function Goal_DiscoverPlayers(_Amount, _Player1, _Player2, _Player3, _Player4, _Player5)
end

--- Es müssen mindestens X von Y Territorien entdeckt werden.
--- 
--- @param _Amount integer Anzahl der Territorien (min. 1, max 5)
--- @param _Territory1 any Name oder ID des Territoriums
--- @param _Territory2 any (Optional) Name oder ID des Territoriums
--- @param _Territory3 any (Optional) Name oder ID des Territoriums
--- @param _Territory4 any (Optional) Name oder ID des Territoriums
--- @param _Territory5 any (Optional) Name oder ID des Territoriums
function Goal_DiscoverTerritories(_Amount, _Territory1, _Territory2, _Territory3, _Territory4, _Territory5)
end

--- Startet den Quest, nachdem mindestens x von y Quests erfolgreich waren.
---
--- @param _Required   integer Anzahl der Quests (min. 1, max 5)
--- @param _QuestAmount integer Anzahl der Quests (min. 1, max 5 und >= _Required)
--- @param _Quest1      string Name der 1. Quest
--- @param _Quest2      string (Optional) Name der 2. Quest
--- @param _Quest3      string (Optional) Name der 3. Quest
--- @param _Quest4      string (Optional) Name der 4. Quest
--- @param _Quest5      string (Optional) Name der 5. Quest
---
function Trigger_OnAtLeastXOfYQuestsSuccess(_Required, _QuestAmount, _Quest1, _Quest2, _Quest3, _Quest4, _Quest5)
end

--- Startet den Quest, nachdem mindestens x von y Quests gescheitert sind.
--- 
--- @param _Required integer Anzahl der Quests (min. 1, max 5)
--- @param _Amount integer Anzahl der Quests (min. 1, max 5 und >= _Required)
--- @param _Quest1 string Name der 1. Quest
--- @param _Quest2 string (Optional) Name der 2. Quest
--- @param _Quest3 string (Optional) Name der 3. Quest
--- @param _Quest4 string (Optional) Name der 4. Quest
--- @param _Quest5 string (Optional) Name der 5. Quest
function Trigger_OnAtLeastXOfYQuestsFailed(_Required, _Amount, _Quest1, _Quest2, _Quest3, _Quest4, _Quest5)
end

--- Genau einer der beiden Quests muss erfolgreich sein.
--- 
--- @param _QuestName1 string Name der Quest
--- @param _QuestName2 string Name der Quest
function Trigger_OnExactOneQuestIsWon(_QuestName1, _QuestName2)
end

--- Genau einer der beiden Quests muss scheitern.
--- 
--- @param _QuestName1 string Name der Quest
--- @param _QuestName2 string Name der Quest
function Trigger_OnExactOneQuestIsLost(_QuestName1, _QuestName2)
end

