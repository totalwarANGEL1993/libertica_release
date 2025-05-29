--- Adds behavior for managing quests.

--- The quest must succeeed.
--- 
--- @param _QuestName string Name of quest
function Goal_WinQuest(_QuestName)
end

--- X out of Y players must be discovered.
--- 
--- @param _Amount integer Amount of players (min. 1, max 5)
--- @param _Player1 integer ID of Player
--- @param _Player2 integer (Optional) ID of Player
--- @param _Player3 integer (Optional) ID of Player
--- @param _Player4 integer (Optional) ID of Player
--- @param _Player5 integer (Optional) ID of Player
function Goal_DiscoverPlayers(_Amount, _Player1, _Player2, _Player3, _Player4, _Player5)
end

--- X of Y territories must be discovered.
--- 
--- @param _Amount integer Amount of territories (min. 1, max 5)
--- @param _Territory1 any Territory name or ID
--- @param _Territory2 any (Optional) Territory name or ID
--- @param _Territory3 any (Optional) Territory name or ID
--- @param _Territory4 any (Optional) Territory name or ID
--- @param _Territory5 any (Optional) Territory name or ID
function Goal_DiscoverTerritories(_Amount, _Territory1, _Territory2, _Territory3, _Territory4, _Territory5)
end

--- Starts the quest after at least x out of y quests have succeed.
---
--- @param _Required   integer Amount of quests (min. 1, max 5)
--- @param _QuestAmount integer Amount of quests (min. 1, max 5 and >= _Required)
--- @param _Quest1      string Name of 1. quest
--- @param _Quest2      string (Optional) Name of 2. quest
--- @param _Quest3      string (Optional) Name of 3. quest
--- @param _Quest4      string (Optional) Name of 4. quest
--- @param _Quest5      string (Optional) Name of 5. quest
---
function Trigger_OnAtLeastXOfYQuestsSuccess(_Required, _QuestAmount, _Quest1, _Quest2, _Quest3, _Quest4, _Quest5)
end

--- Starts the quest after at least x out of y quests have failed.
--- 
--- @param _Required integer Amount of quests (min. 1, max 5)
--- @param _Amount integer Amount of quests (min. 1, max 5 and >= _Required)
--- @param _Quest1 string Name of 1. quest
--- @param _Quest2 string (Optional) Name of 2. quest
--- @param _Quest3 string (Optional) Name of 3. quest
--- @param _Quest4 string (Optional) Name of 4. quest
--- @param _Quest5 string (Optional) Name of 5. quest
function Trigger_OnAtLeastXOfYQuestsFailed(_Required, _Amount, _Quest1, _Quest2, _Quest3, _Quest4, _Quest5)
end

--- Exactly one of the two quest needs to succeed.
--- 
--- @param _QuestName1 string Name of quest
--- @param _QuestName2 string Name of quest
function Trigger_OnExactOneQuestIsWon(_QuestName1, _QuestName2)
end

--- Exactly one of the two quest needs to fail.
--- 
--- @param _QuestName1 string Name of quest
--- @param _QuestName2 string Name of quest
function Trigger_OnExactOneQuestIsLost(_QuestName1, _QuestName2)
end

