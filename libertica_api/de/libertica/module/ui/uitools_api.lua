--- Bietet Werkzeuge für verschiedene Modifikationen der 2D-Benutzeroberfläche.
---
--- Die folgenden Spieler-bezogenen Elemente können geändert werden:
--- * Spielerfarbe
--- * Spielername
--- * Spielerporträt
--- * Territoriumsname
---
--- Die folgenden menübezogenen Elemente können geändert werden:
--- * Anzeigen/Verstecken der Minikarte
--- * Anzeigen/Verstecken der Umschalt-Minikarte
--- * Anzeigen/Verstecken des Diplomatiemenüs
--- * Anzeigen/Verstecken des Produktionsmenüs
--- * Anzeigen/Verstecken des Wettermenüs
--- * Anzeigen/Verstecken des Baumenüs
--- * Anzeigen/Verstecken des Gebietsbeanspruchungsbuttons
--- * Anzeigen/Verstecken des Heldenfähigkeitenbuttons
--- * Anzeigen/Verstecken des Helden auswählen-Buttons
--- * Anzeigen/Verstecken des Einheiten auswählen-Buttons
---
Lib.UITools = Lib.UITools or {};



--- Setzt ein Symbol aus einer Symbolmatrix.
---
--- Es ist möglich, eine benutzerdefinierte Symbolmatrix zu verwenden. Die Dateien müssen in gui_768,
--- gui_920 und gui_1200 kopiert und auf die entsprechende Größe skaliert werden. Dateien müssen im
--- Kartenarchiv unter graphics/textures gepackt werden.
---
--- Es gibt 3 verschiedene Symbolgrößen. Für jede Größe sucht die Spiel-Engine nach einer anderen Datei:
--- * 44:  [filename].png
--- * 64:  [filename]big.png
--- * 128: [filename]verybig.png
---
--- #### Beispiele
--- ```lua
--- -- Beispiel #1: Verwendung einer Ingame-Grafik
--- ChangeIcon(AnyWidgetID, {1, 1, 1});
---
--- -- Beispiel #2: Verwendung einer benutzerdefinierten Grafik
--- -- (meinetolleniconsbig.png wird gesucht)
--- ChangeIcon(AnyWidgetID, {8, 5}, nil, "meinetollenicons");
---
--- -- Beispiel #3: Verwendung großer benutzerdefinierter Grafik
--- -- (meinetolleniconsverybig.png wird gesucht)
--- ChangeIcon(AnyWidgetID, {8, 5}, 128, "meinetollenicons");
--- ```
---
--- @param _WidgetID any Pfad oder ID des Widgets
--- @param _Coordinates table Tabelle mit Koordinaten
--- @param _Size? number Optionale Symbolgröße
--- @param _Name? string Optionale Symboldatei
function ChangeIcon(_WidgetID, _Coordinates, _Size, _Name)
end
API.SetIcon = ChangeIcon;

--- Ändert die Beschreibung eines Buttons oder Symbols.
--- @param _Title any Titeltext oder lokalisierte Tabelle
--- @param _Text any Text oder lokalisierte Tabelle
--- @param _DisabledText any? Text oder lokalisierte Tabelle
function SetTooltipNormal(_Title, _Text, _DisabledText)
end
API.SetTooltipNormal = SetTooltipNormal;

--- Ändert die Beschreibung eines Buttons oder Symbols mit zusätzlichen Kosten.
--- @param _Title any Titeltext oder lokalisierte Tabelle
--- @param _Text any Text oder lokalisierte Tabelle
--- @param _DisabledText any? Text oder lokalisierte Tabelle
--- @param _Costs table? Tabelle mit Kosten
--- @param _InSettlement boolean? Prüft alle Quellen in der Siedlung
function SetTooltipCosts(_Title, _Text, _DisabledText, _Costs, _InSettlement)
end
API.SetTooltipCosts = SetTooltipCosts;

--- Ändert die Sichtbarkeit der Minikarte.
--- @param _Flag boolean Widget ist versteckt
function HideMinimap(_Flag)
end
API.HideMinimap = HideMinimap;

--- Ändert die Sichtbarkeit des Minikarten-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideToggleMinimap(_Flag)
end
API.HideToggleMinimap = HideToggleMinimap;

--- Ändert die Sichtbarkeit des Diplomatiemenü-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideDiplomacyMenu(_Flag)
end
API.HideDiplomacyMenu = HideDiplomacyMenu;

--- Ändert die Sichtbarkeit des Produktionsmenü-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideProductionMenu(_Flag)
end
API.HideProductionMenu = HideProductionMenu;

--- Ändert die Sichtbarkeit des Wettermenü-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideWeatherMenu(_Flag)
end
API.HideWeatherMenu = HideWeatherMenu;

--- Ändert die Sichtbarkeit des Gebietsbeanspruchungsbuttons.
--- @param _Flag boolean Widget ist versteckt
function HideBuyTerritory(_Flag)
end
API.HideBuyTerritory = HideBuyTerritory;

--- Ändert die Sichtbarkeit des Ritterfähigkeiten-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideKnightAbility(_Flag)
end
API.HideKnightAbility = HideKnightAbility;

--- Ändert die Sichtbarkeit des Ritterauswahl-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideKnightButton(_Flag)
end
API.HideKnightButton = HideKnightButton;

--- Ändert die Sichtbarkeit des militärische Auswahl-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideSelectionButton(_Flag)
end
API.HideSelectionButton = HideSelectionButton;

--- Ändert die Sichtbarkeit des Baumenu.
--- @param _Flag boolean Widget ist versteckt
function HideBuildMenu(_Flag)
end
API.HideBuildMenu = HideBuildMenu;

--- Fügt eine neue Tastaturkürzel-Beschreibung hinzu.
--- @param _Key string Schlüssel des Tastenkürzels
--- @param _Description any Text oder lokalisierte Tabelle
--- @return integer ID ID der Beschreibung
function AddShortcutDescription(_Key, _Description)
    return 0;
end
API.AddShortcutDescription = AddShortcutDescription;

--- Entfernt die Tastaturkürzel-Beschreibung mit der ID.
--- @param _ID number ID des Tastenkürzels
function RemoveShortcutDescription(_ID)
end
API.RemoveShortcutDescription = RemoveShortcutDescription;

--- Aktiviert oder deaktiviert die Zwangsgeschwindigkeit 1.
--- @param _Flag boolean Zwangsgeschwindigkeit aktiv
function SpeedLimitActivate(_Flag)
end
API.SpeedLimitActivate = SpeedLimitActivate;

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
--- #### Beispiele
--- ```lua
--- -- Beispiel #1: Modell nach Spielerheld setzen
--- SetPlayerPortrait(2);
--- -- Beispiel #2: Modell nach Art der Entität setzen
--- SetPlayerPortrait(2, "amma");
--- -- Beispiel #3: Modellname direkt setzen
--- SetPlayerPortrait(2, "H_NPC_Monk_AS");
--- ```
--- @param _PlayerID number  ID des Spielers
--- @param _Portrait? string Name des Modells
function SetPlayerPortrait(_PlayerID, _Portrait)
end
API.SetPlayerPortrait = SetPlayerPortrait;

