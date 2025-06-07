--- Functionality provided by the base module.
--- 
--- #### Bug Fixes:
--- <li>Luxury goods can be stored in village storehouses</li>
--- <li>Soldier respawning for ME barracks is active</li>
--- <li>Add castle and storehouse as delivery checkpoints</li>
--- <li>IO interaction checks for both goods if they available</li>
--- <li>The destroy all units now dosen't count sites and special entities</li>
--- <li>The big cathedral has the right name displayed in the selection</li>
--- <li>House menu is fixed for buildings of other climate zones</li>
--- <li>Ability hints only trigger if player has knight and storehouse</li>
--- <li>Deleted camp fires don't crash the game anymore</li>
--- 
--- #### Scripting values:
--- * `CONST_SCRIPTING_VALUES.Destination.X`: <b>integer</b> X coordinate of movement target
--- * `CONST_SCRIPTING_VALUES.Destination.Y`: <b>integer</b> Y coordinate of movement target
--- * `CONST_SCRIPTING_VALUES.Health`: <b>integer</b> Health of entity
--- * `CONST_SCRIPTING_VALUES.Player`: <b>integer</b> Player ID of entity
--- * `CONST_SCRIPTING_VALUES.Size`: <b>integer</b> Scaling of entity
--- * `CONST_SCRIPTING_VALUES.Visible`: <b>integer</b> Is entity visible (= 801280)
--- * `CONST_SCRIPTING_VALUES.NPC`: <b>integer</b> Type of npc (> 0)

--- Open the chat console.
--- 
--- @param _PlayerID number    ID of player
--- @param _AllowDebug boolean Debug codes allowed
function ShowTextInput(_PlayerID, _AllowDebug)
end
API.ShowTextInput = ShowTextInput;

--- Activates the debug mode of the game.
--- @param _DisplayScriptErrors boolean Show script errors
--- @param _CheckAtRun boolean          Check custom behavior on/off
--- @param _DevelopingCheats boolean    Cheats on/off
--- @param _DevelopingShell boolean     Input commands on/off
--- @param _TraceQuests boolean         Trace quests on/off
function ActivateDebugMode(_DisplayScriptErrors, _CheckAtRun, _DevelopingCheats, _DevelopingShell, _TraceQuests)
end
API.ActivateDebugMode = ActivateDebugMode;

--- Requests a job of the passed event type.
--- @param _EventType integer Type of job
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestJobByEventType(_EventType, _Function, ...)
    return 0;
end
API.RequestJobByEventType = RequestJobByEventType;
API.StartJobByEventType = RequestJobByEventType;

--- Requests a job that triggers each second.
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestJob(_Function, ...)
    return 0;
end
API.RequestJob = RequestJob;
API.StartJob = RequestJob;
StartSimpleJob = RequestJob;
StartSimpleJobEx = RequestJob;

--- Requests a job that triggers each turn.
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestHiResJob(_Function, ...)
    return 0;
end
API.RequestHiResJob = RequestHiResJob;
API.StartHiResJob = RequestHiResJob;
StartSimpleHiResJob = RequestHiResJob;
StartSimpleHiResJobEx = RequestHiResJob;

--- Requests a delayed action delayed by seconds.
--- @param _Waittime integer Seconds
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestDelay(_Waittime, _Function, ...)
    return 0;
end
API.RequestDelay = RequestDelay;
API.StartDelay = RequestDelay;

--- Requests a delayed action delayed by turns
--- @param _Waittime integer Turns
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestHiResDelay(_Waittime, _Function, ...)
    return 0;
end
API.RequestHiResDelay = RequestHiResDelay;
API.StartHiResDelay = RequestHiResDelay;

--- Requests a delayed action delayed by realtime seconds.
--- @param _Waittime integer Seconds
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestRealTimeDelay(_Waittime, _Function, ...)
    return 0;
end
API.RequestRealTimeDelay = RequestRealTimeDelay;
API.StartRealTimeDelay = RequestRealTimeDelay;

--- Ends a job. The job can not be reactivated.
--- @param _JobID integer ID of job
function StopJob(_JobID)
end
API.StopJob = StopJob;
API.EndJob = StopJob;

--- Returns if the job is running.
--- @param _JobID integer ID of job
--- @return boolean Running Job is runnung
function IsJobRunning(_JobID)
    return true;
end
API.IsJobRunning = IsJobRunning;
API.JobIsRunning = IsJobRunning;

--- Resumes a paused job.
--- @param _JobID integer ID of job
function ResumeJob(_JobID)
end
API.ResumeJob = ResumeJob;

--- Pauses a runnung job.
--- @param _JobID integer ID of job
function YieldJob(_JobID)
end
API.YieldJob = YieldJob;

--- Returns the real time seconds passed since game start.
--- @return integer Seconds Amount of seconds
function GetSecondsRealTime()
    return 0;
end
API.RealTimeGetSecondsPassedSinceGameStart = GetSecondsRealTime;
API.GetSecondsRealTime = GetSecondsRealTime;

--- Returns the name of the territory.
--- @param _TerritoryID number ID of territory
--- @return string Name Name of territory
function GetTerritoryName(_TerritoryID)
    return "";
end
API.GetTerritoryName = GetTerritoryName;

--- Returns the name of the player.
--- @param _PlayerID number ID of player
--- @return string Name Name of player
function GetPlayerName(_PlayerID)
    return "";
end
API.GetPlayerName = GetPlayerName;

---Changes the name of a player.
---@param _PlayerID number ID of player
---@param _Name string Player name
function SetPlayerName(_PlayerID, _Name)
end
API.SetPlayerName = SetPlayerName;

--- Changes the color of a player.
--- @param _PlayerID number ID of player
--- @param _Color any Name or ID of color
--- @param _Logo? number ID of logo
--- @param _Pattern? number ID of pattern
function SetPlayerColor(_PlayerID, _Color, _Logo, _Pattern)
end
API.SetPlayerColor = SetPlayerColor;

--- Changes the portrait of a player.
---
--- #### Example:
--- ```lua
--- -- Example #1: Set model by player hero
--- SetPlayerPortrait(2);
--- -- Example #2: Set model by type of entity
--- SetPlayerPortrait(2, "amma");
--- -- Example #3: Set model name directly
--- SetPlayerPortrait(2, "H_NPC_Monk_AS");
--- ```
--- 
--- @param _PlayerID number  ID of player
--- @param _Portrait? string Name of model
function SetPlayerPortrait(_PlayerID, _Portrait)
end
API.SetPlayerPortrait = SetPlayerPortrait;

--- Sets the amount of resources in a mine and optional refill amount.
--- @param _Entity any Entity to change
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

--- Creates a new report type.
--- @param _Name string Name of report
--- @return integer
function CreateReport(_Name)
    return 0;
end
API.CreateScriptEvent = CreateReport;

--- Sends a report with optional parameter.
--- @param _ID integer Report ID
--- @param ... unknown Parameters
function SendReport(_ID, ...)
end
API.SendScriptEvent = SendReport;

--- Returns the player who has send the report.
--- 
--- If this function is called out of report context or if another error has
--- occured, it will return 0 instead.
--- 
--- @return integer PlayerID ID of source player
function GetReportSender()
    return 0;
end
API.GetReportSender = GetReportSender;
API.GetReportSourcePlayerID = GetReportSender;

--- Sends a report with optional parameter to the global script.
---
--- This will always be a broadcast!
--- @param _ID integer Report ID
--- @param ... unknown Parameters
function SendReportToGlobal(_ID, ...)
end
API.SendScriptEventToGlobal = SendReportToGlobal;

--- Sends a report with optional parameter to the local script.
--- @param _ID integer Report ID
--- @param ... unknown Parameters
function SendReportToLocal(_ID, ...)
end
API.SendScriptEventToLocal = SendReportToLocal;

--- Creates a report listener for the report type.
--- @param _EventID integer ID of report
--- @param _Function function Listener function
--- @return integer
function CreateReportReceiver(_EventID, _Function)
    return 0;
end
API.CreateScriptEventReceiver = CreateReportReceiver;

--- Deletes a report listener for the report type.
--- @param _EventID integer ID of report
--- @param _ID integer ID of listener
function RemoveReportReceiver(_EventID, _ID)
end
API.RemoveScriptEventReceiver = RemoveReportReceiver;

--- Deactivates the autosave of the History Edition.
--- @param _Flag boolean Auto save is disabled
function DisableAutoSave(_Flag)
end
API.DisableAutoSave = DisableAutoSave;

--- Deactivates saving the game.
--- @param _Flag boolean Saving is disabled
function DisableSaving(_Flag)
end
API.DisableSaving = DisableSaving;

--- Deactivates loading of savegames.
--- @param _Flag boolean Loading is disabled
function DisableLoading(_Flag)
end
API.DisableLoading = DisableLoading;

--- Returns the current movement destination of the entity.
--- @param _Entity any ID or script name
--- @return table Position movement destination of the entity
function GetEntityDestination(_Entity)
    return {};
end
API.GetEntityDestination = GetEntityDestination;

--- Returns the health of the entity.
--- @param _Entity any ID or script name
--- @return integer Health health of the entity
function GetEntityHealth(_Entity)
    return 0;
end
API.GetEntityHealth = GetEntityHealth;

--- Sets the health of the entity, without checking plausibility.
--- @param _Entity any ID or script name
--- @param _Health integer health of the entity
function SetEntityHealth(_Entity, _Health)
end
API.SetEntityHealth = SetEntityHealth;

--- Returns whether the entity is an NPC.
--- @param _Entity any ID or script name
--- @return boolean Active entity is NPC
function GetEntityNpc(_Entity)
    return true;
end
API.GetEntityNpc = GetEntityNpc;

--- Returns the owner of the entity.
--- @param _Entity any ID or script name
--- @return integer Player ID of the player
function GetEntityPlayer(_Entity)
    return 0;
end
API.GetEntityPlayer = GetEntityPlayer;

--- Sets the owner of the entity, without checking plausibility.
--- @param _Entity any ID or script name
--- @param _Player integer Player ID of the player
function SetEntityPlayer(_Entity, _Player)
end
API.SetEntityPlayer = SetEntityPlayer;

--- Returns the scaling of the entity.
--- @param _Entity any
--- @return number Scaling scaling of the entity
function GetEntityScaling(_Entity)
    return 0;
end
API.GetEntityScaling = GetEntityScaling;

--- Sets the scaling of the entity.
--- @param _Entity any ID or script name
--- @param _Scaling number scaling of the entity
function SetEntityScaling(_Entity, _Scaling)
end
API.SetEntityScaling = SetEntityScaling;

--- Returns the model used by the entity.
--- @param _Entity any ID or script name
--- @return integer Model Model of entity
function GetEntityModel(_Entity)
    return 0;
end
API.GetEntityModel = GetEntityModel;

--- Returns whether the entity is invisible.
--- @param _Entity any ID or script name
--- @return boolean Visible entity is invisible
function IsEntityInvisible(_Entity)
    return true;
end
API.IsEntityInvisible = IsEntityInvisible;

--- Returns whether the entity is not selectable.
--- @param _Entity any ID or script name
--- @return boolean Visible Entity is inaccessible
function IsEntityInaccessible(_Entity)
    return true;
end
API.IsEntityInaccessible = IsEntityInaccessible;

--- Returns the value of the index as integer.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @return integer Value Value at index
function GetInteger(_Entity, _SV)
    return 0;
end
API.GetInteger = GetInteger;

--- Returns the value of the index as double.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @return number Value Value at index
function GetFloat(_Entity, _SV)
    return 0;
end
API.GetFloat = GetFloat;

--- Sets an integer value at the index.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @param _Value integer Value to set
function SetInteger(_Entity, _SV, _Value)
end
API.SetInteger = SetInteger;

--- Sets a double value at the index.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @param _Value number Value to set
function SetFloat(_Entity, _SV, _Value)
end
API.SetFloat = SetFloat;

--- Converts the double value into integer representation.
--- @param _Value number Integer value
--- @return number Value Double value
function ConvertIntegerToFloat(_Value)
    return 0;
end
API.ConvertIntegerToFloat = ConvertIntegerToFloat;

--- Converts the integer value into double representation.
--- @param _Value number Double value
--- @return integer Value Integer value
function ConvertFloatToInteger(_Value)
    return 0;
end
API.ConvertFloatToInteger = ConvertFloatToInteger;

--- Localizes the passed text or table. 
--- @param _Text any Text to localize
--- @return any Localized Localized text
function Localize(_Text)
    return "";
end
API.Localize = Localize;

--- Replaces all placeholders inside the string with their respective values.
---
--- * `{n:xyz}` Replaces a scriptname with a predefined value
--- * `{t:xyz}` Replaces a type with a predefined value
--- * `{v:xyz}` Replaces a variable in _G with it's value.
--- * `{color}` Replaces the name of the color with it's color code.
--- 
--- <p>Colors: 
--- red, blue, yellow, green, white, black, grey, azure, orange, amber, violet,
--- pink, scarlet, magenta, olive, tooltip, none
---
--- @param _Text string Text to format
--- @return string Formatted Formatted text
function ConvertPlaceholders(_Text)
    return "";
end
API.ConvertPlaceholders = ConvertPlaceholders;

--- Prints a message into the debug text window.
--- @param _Text any Text as string or table
function AddNote(_Text)
end
API.Note = AddNote;

--- Prints a message into the debug text window. The messages stays until it
--- is actively removed.
--- @param _Text any Text as string or table
function AddStaticNote(_Text)
end
API.StaticNote = AddStaticNote;

--- Prints a message into the message window.
--- @param _Text any Text as string or table
--- @param _Sound? string Sound to play
function AddMessage(_Text, _Sound)
end
API.Message = AddMessage;

---Removes all text from the debug text window.
function ClearNotes()
end
API.ClearNotes = ClearNotes;

--- Replaces a name with the given text.
--- @param _Name string Name to replace
--- @param _Replacement any Replacement value
function AddNamePlaceholder(_Name, _Replacement)
end
API.AddNamePlaceholder = AddNamePlaceholder;

--- Replaces a entity type witht the given text.
--- @param _Type integer Entity type to replace
--- @param _Replacement any Replacement value
function AddEntityTypePlaceholder(_Type, _Replacement)
end
API.AddEntityTypePlaceholder = AddEntityTypePlaceholder;

--- Saves a string text overwrite at the key.
--- @param _Key string Key of entry
--- @param _Text any Text or localized Table
function AddStringText(_Key, _Text)
end
API.AddStringText = AddStringText;

--- Deletes the string text overwrite at the key.
--- @param _Key string Key of entry
function DeleteStringText(_Key)
end
API.DeleteStringText = DeleteStringText;

--- Returns the String text at the key.
--- @param _Key string Key of entry
--- @return string Text String text
function GetStringText(_Key)
    return "";
end
API.GetStringText = GetStringText;

--- Adds a new language to the list.
--- @param _Shortcut string Language shortcut
--- @param _Name string     Display name of language
--- @param _Fallback string Fallback language shortcut
--- @param _Index? integer  List position
function DefineLanguage(_Shortcut, _Name, _Fallback, _Index)
end

--- Returns the estimated amount of lines required to print the text.
--- 
--- #### Categories:
--- <li>Length 4: `ABCDEFGHKLMNOPQRSTUVWXYZÄÖÜÁÂÃÅÇÈÉÊËÐÐÑÒÓÔÕÖØÙÚÛÜÝ`</li>
--- <li>Length 3: `abcdeghkmnopqsuvwxyzäöüßIJÆÌÍÎÏÞàáâãåæçèéêëìíîïðñòóôõ÷øùúûüýþÿ`</li>
--- <li>Length 2: `\"#+*~_\\§$%&=?@fijlft`</li>
--- <li>Length 1: `!-/()?',.|[]{}`</li>
--- 
--- All not defined characters will have a estimate of 2.
--- 
--- @param _Text string Text
--- @param _LineLength integer Line length
--- @return integer Amount Amount of lines
function CountTextLines(_Text, _LineLength)
    return 0;
end

