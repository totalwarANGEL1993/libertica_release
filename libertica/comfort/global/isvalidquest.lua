Lib.Require("comfort/global/GetQuestID");
Lib.Register("comfort/global/IsValidQuest");

function IsValidQuest(_QuestID)
    return Quests[_QuestID] ~= nil or Quests[GetQuestID(_QuestID)] ~= nil;
end
API.IsValidQuest = IsValidQuest;

