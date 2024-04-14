--- Fügt Funktionen zur Auswahl von Einheiten hinzu.
---
--- Funktionen:
--- * Soldaten entlassen
--- * Kriegsmaschinen entlassen
--- * Diebe entlassen
--- * Auswahl von globalen Skripten abrufen
--- * Behebt die Auswahl von Triböcken
---
Lib.Selection = Lib.Selection or {};



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

--- Gibt zurück, ob die Einheit derzeit ausgewählt ist.
--- @param _Entity any        Zu prüfende Einheit
--- @param _PlayerID integer? Spieler-ID zur Überprüfung
--- @return boolean Ausgewählte Einheit ist ausgewählt
function IsEntitySelected(_Entity, _PlayerID)
    return false;
end
API.IsEntityInSelection = IsEntitySelected;

--- Gibt die erste ausgewählte Einheit zurück.
--- @param _PlayerID integer ID des Spielers
--- @return integer Einheit Erste ausgewählte Einheit
function GetSelectedEntity(_PlayerID)
    return 0;
end
API.GetSelectedEntity = GetSelectedEntity;

--- Gibt alle ausgewählten Einheiten des Spielers zurück.
--- @param _PlayerID integer ID des Spielers
--- @return table Liste Ausgewählte Einheiten des Spielers
function GetSelectedEntities(_PlayerID)
    return {};
end
API.GetSelectedEntities = GetSelectedEntities;



--- Eine Einheit wurde vertrieben.
---
--- #### Parameter
--- * `EntityID` - ID der Einheit
Report.ExpelSettler = anyInteger;

--- Die Auswahl von Einheiten eines Spielers hat sich geändert.
---
--- #### Parameter
--- * `PlayerID` - ID des Spielers
--- * `...`      - Liste von Einheiten
Report.SelectionChanged = anyInteger;

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

