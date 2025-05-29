--- Erlaubt es Namen, Farben und Portraits von Spielern anzupassen.
---
--- Folgende Dinge können angepasst werden:
--- <li>Spielerfarbe</li>
--- <li>Spielername</li>
--- <li>Spielerporträt</li>
--- <li>Territoriumsname</li>

--- Gibt den Namen des Gebiets zurück.
--- @param _TerritoryID number ID des Gebiets
--- @return string Name Name des Gebiets
function GetTerritoryName(_TerritoryID)
    return "";
end
API.GetTerritoryName = GetTerritoryName;

--- Gibt den Namen des Spielers zurück.
--- @param _PlayerID number ID des Spielers
--- @return string Name Name des Spielers
function GetPlayerName(_PlayerID)
    return "";
end
API.GetPlayerName = GetPlayerName;

--- Ändert den Namen eines Spielers.
---@param _PlayerID number ID des Spielers
---@param _Name string Spielername
function SetPlayerName(_PlayerID, _Name)
end
API.SetPlayerName = SetPlayerName;

--- Ändert die Farbe eines Spielers.
--- @param _PlayerID number ID des Spielers
--- @param _Color any Name oder ID der Farbe
--- @param _Logo? number ID des Logos
--- @param _Pattern? number ID des Musters
function SetPlayerColor(_PlayerID, _Color, _Logo, _Pattern)
end
API.SetPlayerColor = SetPlayerColor;

--- Ändert das Porträt eines Spielers.
---
--- #### Example:
--- ```lua
--- -- Beispiel #1: Modell nach Spielerheld setzen
--- SetPlayerPortrait(2);
--- -- Beispiel #2: Modell nach Art der Entität setzen
--- SetPlayerPortrait(2, "amma");
--- -- Beispiel #3: Modellname direkt setzen
--- SetPlayerPortrait(2, "H_NPC_Monk_AS");
--- ```
--- 
--- @param _PlayerID number  ID des Spielers
--- @param _Portrait? string Name des Modells
function SetPlayerPortrait(_PlayerID, _Portrait)
end
API.SetPlayerPortrait = SetPlayerPortrait;

