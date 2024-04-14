--- Ermöglicht die Verwendung verschiedener Debug-Optionen des Spiels.
Lib.Core.Debug = {}

--- Aktiviert den Debug-Modus des Spiels.
--- @param _DisplayScriptErrors boolean Fehlermeldungen anzeigen
--- @param _CheckAtRun boolean          Benutzerdefiniertes Verhalten überprüfen an/aus
--- @param _DevelopingCheats boolean    Cheats an/aus
--- @param _DevelopingShell boolean     Eingabebefehle an/aus
--- @param _TraceQuests boolean         Quests verfolgen an/aus
function ActivateDebugMode(_DisplayScriptErrors, _CheckAtRun, _DevelopingCheats, _DevelopingShell, _TraceQuests)
end
API.ActivateDebugMode = ActivateDebugMode;

