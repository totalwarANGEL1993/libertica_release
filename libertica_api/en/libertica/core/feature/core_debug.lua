--- Allows to use differend debug options of the game.
Lib.Core.Debug = {}

--- Activates the debug mode of the game.
--- @param _DisplayScriptErrors boolean Show script errors
--- @param _CheckAtRun boolean          Check custom behavior on/off
--- @param _DevelopingCheats boolean    Cheats on/off
--- @param _DevelopingShell boolean     Input commands on/off
--- @param _TraceQuests boolean         Trace quests on/off
function ActivateDebugMode(_DisplayScriptErrors, _CheckAtRun, _DevelopingCheats, _DevelopingShell, _TraceQuests)
end
API.ActivateDebugMode = ActivateDebugMode;

