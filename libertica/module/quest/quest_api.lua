---@diagnostic disable: missing-return-value
---@diagnostic disable: return-type-mismatch

Lib.Register("module/quest/Quest_API");

function SetupQuest(_Data)
    if GUI then
        return;
    end
    error(not _Data.Name or not Quests[GetQuestID(_Data.Name)], "SetupQuest: A quest named '%s' already exists!", tostring(_Data.Name));
    return Lib.Quest.Global:CreateSimpleQuest(_Data);
end
API.CreateQuest = SetupQuest;

function SetupNestedQuest(_Data)
    if GUI or type(_Data) ~= "table" then
        return;
    end
    error(_Data.Segments ~= nil and #_Data.Segments ~= 0, "SetupNestedQuest: Segmented quest '%s' is missing it's segments!", tostring(_Data.Name));
    return Lib.Quest.Global:CreateNestedQuest(_Data);
end
API.CreateNestedQuest = SetupNestedQuest;

function AddDisableTriggerCondition(_Function)
    if GUI then
        return;
    end
    table.insert(Lib.Quest.Global.ExternalTriggerConditions, _Function);
end
API.AddDisableTriggerCondition = AddDisableTriggerCondition;

function AddDisableTimerCondition(_Function)
    if GUI then
        return;
    end
    table.insert(Lib.Quest.Global.ExternalTimerConditions, _Function);
end
API.AddDisableTimerCondition = AddDisableTimerCondition;

function AddDisableDecisionCondition(_Function)
    if GUI then
        return;
    end
    table.insert(Lib.Quest.Global.ExternalDecisionConditions, _Function);
end
API.AddDisableDecisionCondition = AddDisableDecisionCondition;

