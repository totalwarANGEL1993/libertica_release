--- Fügt Funktionen zur Auswahl von Einheiten hinzu.
---
--- Funktionen:
--- <li>Soldaten entlassen</li>
--- <li>Kriegsmaschinen entlassen</li>
--- <li>Diebe entlassen</li>
--- <li>Auswahl von globalen Skripten abrufen</li>
--- <li>Behebt die Auswahl von Triböcken</li>



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
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID der Einheit
Report.ExpelSettler = anyInteger;

--- Ein Trebuchet wird zum Anhalten gezwungen.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID der Einheit
--- * `TaskList`: <b>integer</b> ID der Taskliste
Report.ForceTrebuchetTasklist = anyInteger;

--- Ein Trebuchet wird aus einem Belagerungsmaschinenwagen gebaut.
--- (Derzeit nicht verwendet)
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID der Einheit
Report.ErectTrebuchet = anyInteger;

--- Ein Trebuchet wird zu einem Belagerungsmaschinenwagen abgebaut.
--- (Derzeit nicht verwendet)
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID der Einheit
Report.DisambleTrebuchet = anyInteger;

