--- Stellt Behavior für Cutscenes bereit.

--- Ruft eine Mapscript-Funktion auf und geht davon aus, dass es sich um eine Zwischensequenz handelt.
---
--- Jede Zwischensequenz benötigt einen eindeutigen Namen!
--- @param _Name string     Name der Zwischensequenz
--- @param _Cutscene string Name der Funktion, die die Zwischensequenz enthält
function Reprisal_Cutscene(_Name, _Cutscene)
end

--- Ruft eine Mapscript-Funktion auf und geht davon aus, dass es sich um eine Zwischensequenz handelt.
---
--- Jede Zwischensequenz benötigt einen eindeutigen Namen!
--- @param _Name string     Name der Zwischensequenz
--- @param _Cutscene string Name der Funktion, die die Zwischensequenz enthält
function Reward_Cutscene(_Name, _Cutscene)
end

--- Überprüft, ob eine Zwischensequenz beendet wurde, und startet dann eine Quest.
--- @param _Name string      Name des Briefings
--- @param _PlayerID integer Empfangender Spieler
--- @param _Waittime integer Zeit zum Warten danach
function Trigger_Cutscene(_Name, _PlayerID, _Waittime)
end

