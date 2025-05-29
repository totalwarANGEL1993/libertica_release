--- Stellt Behavior für Dialoge bereit.

--- Ruft eine Mapscript-Funktion auf und geht davon aus, dass es sich um einen Dialog handelt.
---
--- Jedes Briefing benötigt einen eindeutigen Namen!
--- @param _Name string     Name des Briefings
--- @param _Dialog string Name der Funktion, die das Briefing enthält
function Reprisal_Dialog(_Name, _Dialog)
end

--- Ruft eine Mapscript-Funktion auf und geht davon aus, dass es sich um einen Dialog handelt.
---
--- Jedes Briefing benötigt einen eindeutigen Namen!
--- @param _Name string     Name des Briefings
--- @param _Dialog string Name der Funktion, die das Briefing enthält
function Reward_Dialog(_Name, _Dialog)
end

--- Überprüft, ob ein Dialog abgeschlossen ist, und startet dann eine Quest.
--- @param _Name string      Name des Briefings
--- @param _PlayerID integer Empfangender Spieler
--- @param _Waittime integer Zeit, die nach Abschluss des Dialogs gewartet werden soll
function Trigger_Dialog(_Name, _PlayerID, _Waittime)
end

