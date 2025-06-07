--- Bietet Werkzeuge für verschiedene Modifikationen der 2D-Benutzeroberfläche.
---
--- Die folgenden menübezogenen Elemente können geändert werden:
--- <li>Anzeigen/Verstecken der Minikarte</li>
--- <li>Anzeigen/Verstecken der Umschalt-Minikarte</li>
--- <li>Anzeigen/Verstecken des Diplomatiemenüs</li>
--- <li>Anzeigen/Verstecken des Produktionsmenüs</li>
--- <li>Anzeigen/Verstecken des Wettermenüs</li>
--- <li>Anzeigen/Verstecken des Baumenüs</li>
--- <li>Anzeigen/Verstecken des Gebietsbeanspruchungsbuttons</li>
--- <li>Anzeigen/Verstecken des Heldenfähigkeitenbuttons</li>
--- <li>Anzeigen/Verstecken des Helden auswählen-Buttons</li>
--- <li>Anzeigen/Verstecken des Einheiten auswählen-Buttons</li>



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
--- #### Example:
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
API.InterfaceSetIcon = ChangeIcon;
API.SetIcon = ChangeIcon;

--- Ändert die Beschreibung eines Buttons oder Symbols.
--- @param _Title any Titeltext oder lokalisierte Tabelle
--- @param _Text any Text oder lokalisierte Tabelle
--- @param _DisabledText any? Text oder lokalisierte Tabelle
function SetTooltipNormal(_Title, _Text, _DisabledText)
end
API.InterfaceSetTooltipNormal = SetTooltipNormal;
API.SetTooltipNormal = SetTooltipNormal;

--- Ändert die Beschreibung eines Buttons oder Symbols mit zusätzlichen Kosten.
--- @param _Title any Titeltext oder lokalisierte Tabelle
--- @param _Text any Text oder lokalisierte Tabelle
--- @param _DisabledText any? Text oder lokalisierte Tabelle
--- @param _Costs table? Tabelle mit Kosten
--- @param _InSettlement boolean? Prüft alle Quellen in der Siedlung
function SetTooltipCosts(_Title, _Text, _DisabledText, _Costs, _InSettlement)
end
API.InterfaceSetTooltipCosts = SetTooltipCosts;
API.SetTooltipCosts = SetTooltipCosts;

--- Ändert die Sichtbarkeit der Minikarte.
--- @param _Flag boolean Widget ist versteckt
function HideMinimap(_Flag)
end
API.InterfaceHideMinimap = HideMinimap;
API.HideMinimap = HideMinimap;

--- Ändert die Sichtbarkeit des Minikarten-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideToggleMinimap(_Flag)
end
API.InterfaceHideToggleMinimap = HideToggleMinimap;
API.HideToggleMinimap = HideToggleMinimap;

--- Ändert die Sichtbarkeit des Diplomatiemenü-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideDiplomacyMenu(_Flag)
end
API.InterfaceHideDiplomacyMenu = HideDiplomacyMenu;
API.HideDiplomacyMenu = HideDiplomacyMenu;

--- Ändert die Sichtbarkeit des Produktionsmenü-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideProductionMenu(_Flag)
end
API.InterfaceHideProductionMenu = HideProductionMenu;
API.HideProductionMenu = HideProductionMenu;

--- Ändert die Sichtbarkeit des Wettermenü-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideWeatherMenu(_Flag)
end
API.InterfaceHideWeatherMenu = HideWeatherMenu;
API.HideWeatherMenu = HideWeatherMenu;

--- Ändert die Sichtbarkeit des Gebietsbeanspruchungsbuttons.
--- @param _Flag boolean Widget ist versteckt
function HideBuyTerritory(_Flag)
end
API.InterfaceHideBuyTerritory = HideBuyTerritory;
API.HideBuyTerritory = HideBuyTerritory;

--- Ändert die Sichtbarkeit des Ritterfähigkeiten-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideKnightAbility(_Flag)
end
API.InterfaceHideKnightAbility = HideKnightAbility;
API.HideKnightAbility = HideKnightAbility;

--- Ändert die Sichtbarkeit des Ritterauswahl-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideKnightButton(_Flag)
end
API.InterfaceHideKnightButton = HideKnightButton;
API.HideKnightButton = HideKnightButton;

--- Ändert die Sichtbarkeit des militärische Auswahl-Buttons.
--- @param _Flag boolean Widget ist versteckt
function HideSelectionButton(_Flag)
end
API.InterfaceHideSelectionButton = HideSelectionButton;
API.HideSelectionButton = HideSelectionButton;

--- Ändert die Sichtbarkeit des Baumenu.
--- @param _Flag boolean Widget ist versteckt
function HideBuildMenu(_Flag)
end
API.InterfaceHideBuildMenu = HideBuildMenu;
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
API.SetSpeedLimit = SpeedLimitSetLimit;
API.SpeedLimitActivate = SpeedLimitActivate;


--- Ein menschlicher Spieler hat ein Gebäude platziert.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID des Spielers
--- * `EntityID`: <b>integer</b> ID der Baustelle
Report.BuildingPlaced = anyInteger;

