--- Verbessert interaktive Objekte.
---
--- Fast alle Entitäten können als interaktives Objekt verwendet werden, nicht 
--- nur die, die dafür vorgesehen sind. Ein Objekt wird durch eine Tabelle 
--- beschrieben und (fast) alle Schlüssel sind optional.
--- 
--- #### Console Commands:
--- In der Konsole können spezielle Komandos eingegeben werden. Eingeklammerte
--- Angaben sind dabei optional.
--- * `enableobject object (state (player))`: Ein interaktives Objekt wird aktiviert
--- * `disableobject object (player)`:        Ein interaktives Objekt wird deaktiviert
--- * `initobject object `:                   Eine Entität wird aktivierbar gemacht
--- 



--- Fügt einem Objekt eine Interaktion hinzu.
---
--- #### Fields `_Description`:
--- * `ScriptName`             - Skriptname des Objekts
--- * `Texture`                - (Optional) Tabelle mit Koordinaten
--- * `Title`                  - (Optional) Titel des Tooltipps
--- * `Text`                   - (Optional) Text des Tooltipps
--- * `Distance`               - (Optional) Aktivierungsabstand
--- * `Player`                 - (Optional) Liste der Spieler
--- * `Waittime`               - (Optional) Aktivierungs-Wartezeit
--- * `Replacement`            - (Optional) Typ, mit dem ersetzt wird
--- * `Costs`                  - (Optional) Aktivierungskosten-Tabelle
--- * `Reward`                 - (Optional) Aktivierungsbelohnungstabelle
--- * `State`                  - (Optional) Aktivierungsverhalten
--- * `Condition`              - (Optional) Aktivierungsbedingungsfunktion
--- * `ConditionInfo`          - (Optional) Text bei Bedingungsfehler
--- * `Action`                 - (Optional) Aktivierungs-Callback-Funktion
--- * `RewardResourceCartType` - (Optional) Typ des Belohnungsressourcenkarrens
--- * `RewardGoldCartType`     - (Optional) Typ des Belohnungsgoldkarrens
--- * `CostResourceCartType`   - (Optional) Typ des Kostenressourcenkarrens
--- * `CostGoldCartType`       - (Optional) Typ des Kostengoldkarrens
---
--- #### Example:
--- ```lua
--- -- Erstellt ein einfaches Objekt
--- SetupObject {
---     Name     = "hut",
---     Distance = 1500,
---     Reward   = {Goods.G_Gold, 1000},
--- };
--- ```
---
--- @param _Description table Objektbeschreibung
--- @return table? Data Objektbeschreibung
function SetupObject(_Description)
    return {};
end
API.CreateObject = SetupObject;

--- Entfernt die Interaktion vom Objekt.
--- @param _ScriptName string Skriptname der Entität
function DisposeObject(_ScriptName)
end
API.DisposeObject = DisposeObject;

--- Setzt das interaktive Objekt zurück. Muss separat aktiviert werden.
--- @param _ScriptName string Skriptname der Entität
function ResetObject(_ScriptName)
end
API.ResetObject = ResetObject;

--- Ändert den Namen des Objekts in der 2D-Oberfläche.
--- 
--- #### Example:
--- ```lua
--- InteractiveObjectAddCustomName("D_X_HabourCrane", {
---     de = "Hafenkran",
---     en = "Habour Crane"
--- });
--- ```
---
--- @param _Key string Schlüssel zum Hinzufügen
--- @param _Text any   Text oder Ersatztext
function InteractiveObjectAddCustomName(_Key, _Text)
end
API.InteractiveObjectSetQuestName = InteractiveObjectAddCustomName;

--- Entfernt die Änderungen am Objektnamen.
--- 
--- #### Example:
--- ```lua
--- InteractiveObjectDeleteCustomName("D_X_HabourCrane");
--- ```
---
--- @param _Key string Schlüssel zum Entfernen
function InteractiveObjectDeleteCustomName(_Key)
end
API.InteractiveObjectUnsetQuestName = InteractiveObjectDeleteCustomName;

--- Ermöglicht oder verbietet das Auffüllen von Eisenerzminen.
--- 
--- #### Erfordert Addon!
--- @param _PlayerID integer ID des Spielers
--- @param _Allowed boolean  Aktivierung ist erlaubt
function AllowActivateIronMines(_PlayerID, _Allowed)
end
API.AllowActivateIronMines = AllowActivateIronMines;

--- Legt den erforderlichen Titel zum Auffüllen von Eisenerzminen fest.
--- 
--- #### Erfordert Addon!
--- @param _Title integer  Rittertitel
function RequireTitleToRefilIronMines(_Title)
end
API.RequireTitleToRefilIronMines = RequireTitleToRefilIronMines;

--- Ermöglicht oder verbietet das Auffüllen von Steinbrüchen.
--- 
--- #### Erfordert Addon!
--- @param _PlayerID integer ID des Spielers
--- @param _Allowed boolean  Aktivierung ist erlaubt
function AllowActivateStoneMines(_PlayerID, _Allowed)
end
API.AllowActivateStoneMines = AllowActivateStoneMines;

--- Legt den erforderlichen Titel zum Auffüllen von Steinbrüchen fest.
--- 
--- #### Erfordert Addon!
--- @param _Title integer  Rittertitel
function RequireTitleToRefilStoneMines(_Title)
end
API.RequireTitleToRefilStoneMines = RequireTitleToRefilStoneMines;

--- Ermöglicht oder verbietet das Auffüllen von Zisternen.
--- 
--- #### Erfordert Addon!
--- @param _PlayerID integer ID des Spielers
--- @param _Allowed boolean  Aktivierung ist erlaubt
function AllowActivateCisterns(_PlayerID, _Allowed)
end
API.AllowActivateCisterns = AllowActivateCisterns;

--- Legt den erforderlichen Titel zum Auffüllen von Zisternen fest.
--- 
--- #### Erfordert Addon!
--- @param _Title integer  Rittertitel
function RequireTitleToRefilCisterns(_Title)
end
API.RequireTitleToRefilCisterns = RequireTitleToRefilCisterns;

--- Ermöglicht oder verbietet den Bau von Handelsposten.
--- 
--- #### Erfordert Addon!
--- @param _PlayerID integer ID des Spielers
--- @param _Allowed boolean  Aktivierung ist erlaubt
function AllowActivateTradepost(_PlayerID, _Allowed)
end
API.AllowActivateTradepost = AllowActivateTradepost;

--- Legt den erforderlichen Titel zum Bau von Handelsposten fest.
--- 
--- #### Erfordert Addon!
--- @param _Title integer  Rittertitel
function RequireTitleToBuildTradeposts(_Title)
end
API.RequireTitleToBuildTradeposts = RequireTitleToBuildTradeposts;

--- Aktiviert ein interaktives Objekt.
--- @param _ScriptName string Skriptname der Entität
--- @param _State? integer    Interaktionszustand
--- @param ... integer        Liste der Spieler-IDs
InteractiveObjectActivate = function(_ScriptName, _State, ...)
end
API.InteractiveObjectActivate = InteractiveObjectActivate;

--- Deaktiviert ein interaktives Objekt.
--- @param _ScriptName string Skriptname der Entität
--- @param ... integer        Liste der Spieler-IDs
InteractiveObjectDeactivate = function(_ScriptName, ...)
end
API.InteractiveObjectDeactivate = InteractiveObjectDeactivate;



--- Die Interaktion des Objekts war erfolgreich.
--- Wenn das Objekt Kosten hat, wird die Aktivierung abgeschlossen, wenn die Kosten ankommen.
--- 
--- #### Parameters:
--- * `ScriptName`: <b>string</b> Skriptname der Entität
--- * `KnightID`:   <b>integer</b> ID des aktivierenden Helden
--- * `PlayerID`:   <b>integer</b> ID des aktivierenden Spielers
Report.ObjectInteraction = anyInteger;

--- Die Interaktion wird vom Objekt gelöscht.
---
--- #### Parameters:
--- * `ScriptName`: <b>string</b> Skriptname der Entität
Report.ObjectReset = anyInteger;

--- Der Zustand eines Objekts wurde zurückgesetzt.
---
--- #### Parameters:
--- * `ScriptName`: <b>string</b> Skriptname der Entität
Report.ObjectDelete = anyInteger;

