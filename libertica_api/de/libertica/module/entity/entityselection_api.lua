--- Fügt Funktionen zur Auswahl von Einheiten hinzu.
---
--- Funktionen:
--- * Soldaten entlassen
--- * Kriegsmaschinen entlassen
--- * Diebe entlassen
--- * Auswahl von globalen Skripten abrufen
--- * Behebt die Auswahl von Triböcken
---
--- #### Reports
--- * `Report.ExpelSettler` - Eine Einheit wurde entlassen.
--- * `Report.SelectionChanged` - The selection has changed.
--- * `Report.ForceTrebuchetTasklis`t - A trebuchet was forced to stop.
--- * `Report.ErectTrebuche`t - A trebuchet has been erected.
--- * `Report.DisambleTrebuchet` - A trebuchet has been dismantled.
---
Lib.EntitySelection = Lib.EntitySelection or {};



--- Deaktiviert (und aktiviert wieder) das Entlassen von Dieben.
--- @param _Flag boolean Deaktiviere das Entlassen von Dieben
function DisableReleaseThieves(_Flag)
end
API.DisableReleaseThieves = DisableReleaseThieves;

--- Deaktiviert (und aktiviert wieder) das Entlassen von Kriegsmaschinen.
--- @param _Flag boolean Deaktiviere das Entlassen von Kriegsmaschinen
function DisableReleaseSiegeEngines(_Flag)
end
API.DisableReleaseSiegeEngines = DisableReleaseSiegeEngines;

--- Deaktiviert (und aktiviert wieder) das Entlassen von Soldaten.
--- @param _Flag boolean Deaktiviere das Entlassen von Soldaten
function DisableReleaseSoldiers(_Flag)
end
API.DisableReleaseSoldiers = DisableReleaseSoldiers;



--- Eine Einheit wurde entlassen.
---
--- #### Parameter
--- * `EntityID` - ID der Einheit
Report.ExpelSettler = anyInteger;

--- Ein Trebuchet wird zum Anhalten gezwungen.
---
--- #### Parameter
--- * `EntityID` - ID der Einheit
--- * `TaskList` - ID der Taskliste
Report.ForceTrebuchetTasklist = anyInteger;

--- Ein Trebuchet wird aus einem Belagerungsmaschinenwagen gebaut.
--- (Derzeit nicht verwendet)
---
--- #### Parameter
--- * `EntityID` - ID der Einheit
Report.ErectTrebuchet = anyInteger;

--- Ein Trebuchet wird zu einem Belagerungsmaschinenwagen abgebaut.
--- (Derzeit nicht verwendet)
---
--- #### Parameter
--- * `EntityID` - ID der Einheit
Report.DisambleTrebuchet = anyInteger;

