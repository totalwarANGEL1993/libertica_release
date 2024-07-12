--- Offers a more comfortable way to create quests.
---
--- Quests can be created as single quests or as nested quests. A nested quest
--- is a simplified notation for quests that are dependend on oneanother.
---
--- All texts inside a quest can be pulled out of string tables. The format for
--- those texts will be "FileName/StringName".
---
--- #### Debug Functions
--- * Debug_FailQuest(_Name) - Makes a quest fail
--- * Debug_WinQuest(_Name) - Makes a quest succeed
--- * Debug_StartQuest(_Name) - Starts a quest
--- * Debug_RestartQuest(_Name) - Resets and restarts a quest
--- * Debug_StopQuest(_Name) - Interrupts a quest
--- * Debug_FindQuests(_Name) - Searches quests like the pattern
--- * Debug_FailedQuests() - Lists quests that have failed
--- * Debug_StoppedQuests() - Lists quests that are interrupted
--- * Debug_ActiveQuests() - Lists quests that are active
--- * Debug_WonQuests() - Lists quests that have succeeded
--- * Debug_WaitingQuests() - Lists quests that are inactive
---
Lib.Quest = Lib.Quest or {};



--- Creates a normal quest.
---
--- #### Fields of table
--- * Name:        A unique name for the quest
--- * Sender:      Quest giver player ID
--- * Receiver:    Quest receiver player ID
--- * Suggestion:  Proposal quest of the text
--- * Success:     Success text of the quest
--- * Failure:     Failure text of the quest
--- * Description: Custom quest description
--- * Time:        Time until automatic failure
--- * Loop:        Loop function
--- * Callback:    Callback function
--- 
--- #### Examples
--- ```lua
--- -- Create a simple quest
--- SetupQuest {
---     Name        = "SomeQuestName",
---     Suggestion  = "We need to find the cloister.",
---     Success     = "They are the famous healer monks.",
---
---     Goal_DiscoverPlayer(4),
---     Reward_Diplomacy(1, 4, "EstablishedContact"),
---     Trigger_Time(0),
--- }
--- ```
--- @param _Data table Quest data
--- @return string Name Name of quest
--- @return number Amount Quest amount
function SetupQuest(_Data)
    return "", 0;
end
API.CreateQuest = SetupQuest;

--- Creates a nested quest.
---
--- #### What are nested quests?
--- Nested quest simplifying the notation of quests connected to each other. The
--- "main quest" is always invisible and contains segments as "sub quests". Each
--- segment of the quest is itself a quest that can contain more segments.
---
--- The name of a segment can be defined. If left empty a name is automatically
--- asigned. This name is build from the name of the main quest separated with
--- an @ followed by the segment name (e.g. "ExampleName@Segment1"). 
---
--- Segments have a expected result. Usually success. The expected result can
--- be changed to failure or completly ignored. A nested quest is finished when
--- all segments concluded with their expected result (success) or at least one
--- segment concluded with another result (failure).
---
--- Segments do not need a trigger because they are all automatically started.
--- Additional triggers can be added (e.g. triggering on other segment).
---
--- #### Examples
--- ```lua
--- -- Create a nested quest
--- SetupNestedQuest {
---     Name        = "MainQuest",
---     Segments    = {
---         {
---             Suggestion  = "We need a higher title!",
---
---             Goal_KnightTitle("Mayor"),
---         },
---         {
---             -- This ignores a failure
---             Result      = SegmentResult.Ignore,
---
---             Suggestion  = "We need mor bucks. And fast!",
---             Success     = "We done it!",
---             Failure     = "We have failed!",
---             Time        = 3 * 60,
---
---             Goal_Produce("G_Gold", 5000),
---
---             Trigger_OnQuestSuccess("MainQuest@Segment1", 1),
---             -- Segmented Quest wird gewonnen.
---             Reward_QuestSuccess("MainQuest"),
---         },
---         {
---             Suggestion  = "Okay, we can try iron instead...",
---             Success     = "We done it!",
---             Failure     = "We have failed!",
---             Time        = 3 * 60,
---
---             Trigger_OnQuestFailure("MainQuest@Segment2"),
---             Goal_Produce("G_Iron", 50),
---         }
---     },
---
---     -- Loose if one quest does not end properly
---     Reprisal_Defeat(),
---     -- Win the game when everything is done.
---     Reward_VictoryWithParty(),
--- };
--- ```
---
--- @param _Data table Quest data
--- @return string Name Name of quest
function SetupNestedQuest(_Data)
    return "";
end
API.CreateNestedQuest = SetupNestedQuest;

--- Adds a function to control if trigger are evaluated.
--- @param _Function function Condition
function AddDisableTriggerCondition(_Function)
end
API.AddDisableTriggerCondition = AddDisableTriggerCondition;

--- Adds a function to control if timer are evaluated.
--- @param _Function function Condition
function AddDisableTimerCondition(_Function)
end
API.AddDisableTimerCondition = AddDisableTimerCondition;

--- Adds a function to control if objectives are evaluated.
--- @param _Function function Condition
function AddDisableDecisionCondition(_Function)
end
API.AddDisableDecisionCondition = AddDisableDecisionCondition;

