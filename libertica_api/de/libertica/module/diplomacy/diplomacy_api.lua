--- Stellt einge Funktionen für Diplomatie bereit.
Lib.Diplomacy = Lib.Diplomacy or {};

--- Ändert die Diplomatie des Spielers zu den angegebenen Parteien.
---
--- Die aktuellen diplomatischen Beziehungen werden zwischengespeichert, sofern
--- kein Backup existiert.
---
--- @param _PlayerID integer Player ID
--- @param _State integer State ID
--- @param ... integer List of player IDs
function SetDiplomacyStateForPlayer(_PlayerID, _State, ...)
end

--- Ändert die Diplomatie aller angegebenen Parteien zueinander.
---
--- Die aktuellen diplomatischen Beziehungen werden zwischengespeichert, sofern
--- kein Backup existiert.
---
--- @param _State integer State ID
--- @param ... integer List of player IDs
function SetDiplomacyStateForPlayers(_State, ...)
end

--- Erstellt ein Backup der aktuellen diplomatischen Beziehungen aller Parteien,
--- wenn noch kein Backup existtiert.
function SaveDiplomacyStates()
end

--- Setzt die diplomatischen Beziehungen zurück, falls ein Backup existiert.
--- Danach wird das Backup invalidiert.
function ResetDiplomacyStates()
end



--- Die diplomatischen Beziehungen zwischen zwei Spielern haben sich geändert.
---
--- #### Parameters
--- * `PlayerID1` - Frist player ID
--- * `PlayerID2` - Second player ID
--- * `OldState`  - Previous diplomatic state
--- * `NewState`  - New diplomatic state
Report.DiplomacyChanged = anyInteger

