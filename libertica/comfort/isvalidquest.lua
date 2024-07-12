Lib.Require("comfort/GetQuestID");
Lib.Register("comfort/IsValidQuest");

function IsValidQuest(_QuestID)
    return Quests[_QuestID] ~= nil or Quests[GetQuestID(_QuestID)] ~= nil;
end
API.IsValidQuest = IsValidQuest;

