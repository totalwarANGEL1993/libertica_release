--- Adds additional functionality to the quest system.
Lib.Core.Quest = {}

--- Sets the amount of resources in a mine and optional refill amount.
--- @param _Entity string|integer Entity to change
--- @param _StartAmount integer Initial amount
--- @param _RefillAmount integer? (optional) Refill amount
function SetResourceAmount(_Entity, _StartAmount, _RefillAmount)
end

--- Changes the displayed description of a custom behavior.
--- @param _QuestName string Name of quest
--- @param _Text string Quest text
function SetCustomBehaviorText(_QuestName, _Text)
end
API.SetCustomBehaviorText = SetCustomBehaviorText;

--- Restarts a quest.
---
--- Quests need to be over to be started again. Either all triggers must succeed
--- or the quest must be triggered manually.
--- @param _QuestName string Name of quest
--- @param _NoMessage boolean Disable debug message
--- @return integer ID new quest ID
--- @return table Data Quest instance
function RestartQuest(_QuestName, _NoMessage)
    return 0, {};
end
API.RestartQuest = RestartQuest;

--- Fails a quest.
--- @param _QuestName string Name of quest
--- @param _NoMessage boolean Disable debug message
function FailQuest(_QuestName, _NoMessage)
end
API.FailQuest = FailQuest;

--- Triggers a quest.
--- @param _QuestName string Name of quest
--- @param _NoMessage boolean Disable debug message
function StartQuest(_QuestName, _NoMessage)
end
API.StartQuest = StartQuest;

--- Interrupts a quest.
--- @param _QuestName string Name of quest
--- @param _NoMessage boolean Disable debug message
function StopQuest(_QuestName, _NoMessage)
end
API.StopQuest = StopQuest;

--- Wins a quest.
--- @param _QuestName string Name of quest
--- @param _NoMessage boolean Disable debug message
function WinQuest(_QuestName, _NoMessage)
end
API.WinQuest = WinQuest;

