--- Verbessert interaktive Objekte.
---
--- #### Debug-Befehle
--- * `enableobject <ScriptName>`  - Ein Objekt wird aktiviert
--- * `disableobject <ScriptName>` - Ein Objekt wird deaktiviert
--- * `initobject <ScriptName>`    - Das Objekt wird rudimentär aktiviert
---
Lib.IO = Lib.IO or {};



--- Fügt einem Objekt eine Interaktion hinzu.
---
--- Fast alle Entitäten können als interaktives Objekt verwendet werden, nicht nur die, die dafür vorgesehen sind.
--- Ein Objekt wird durch eine Tabelle beschrieben und (fast) alle Schlüssel sind optional.
---
--- #### Felder der Tabelle
--- * Name                   - Skriptname des Objekts
--- * Texture                - (Optional) Tabelle mit Koordinaten
---   - Spielicons: {x, y, ExtraNumber}
---   - Benutzerdefinierte Icons: {x, y, FileNamePrefix}
--- * Title                  - (Optional) Titel des Tooltipps
--- * Text                   - (Optional) Text des Tooltipps
--- * Distance               - (Optional) Aktivierungsabstand
--- * Player                 - (Optional) Liste der Spieler
--- * Waittime               - (Optional) Aktivierungs-Wartezeit
--- * Replacement            - (Optional) Typ, mit dem ersetzt wird
--- * Costs                  - (Optional) Aktivierungskosten-Tabelle
---   - Format: {Typ, Betrag, Typ, Betrag}
--- * Reward                 - (Optional) Aktivierungsbelohnungstabelle
---   - Format: {Typ, Betrag}
--- * State                  - (Optional) Aktivierungsverhalten
---   - 0: Nur Held
---   - 1: Automatisch
---   - 2: Niemals
--- * Condition              - (Optional) Aktivierungsbedingungsfunktion
--- * ConditionInfo          - (Optional) Text bei Bedingungsfehler
--- * Action                 - (Optional) Aktivierungs-Callback-Funktion
--- * RewardResourceCartType - (Optional) Typ des Belohnungsressourcenkarrens
--- * RewardGoldCartType     - (Optional) Typ des Belohnungsgoldkarrens
--- * CostResourceCartType   - (Optional) Typ des Kostenressourcenkarrens
--- * CostGoldCartType       - (Optional) Typ des Kostengoldkarrens
---
--- #### Beispiele
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
--- #### Beispiele
--- ```lua
--- InteractiveObjectAddCustomName("D_X_HabourCrane", {
---     de = "Hafenkran",
---     en = "Habour Crane"
--- });
--- ```
---
--- @param _Key string        Schlüssel zum Hinzufügen
--- @param _Text string|table Text oder Ersatztext
function InteractiveObjectAddCustomName(_Key, _Text)
end
API.InteractiveObjectSetQuestName = InteractiveObjectAddCustomName;

--- Entfernt die Änderungen am Objektnamen.
--- 
--- #### Beispiel
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
--- @param _State integer     Interaktionszustand
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



--- Der Spieler hat auf die Interaktions-Schaltfläche geklickt.
--- 
--- #### Parameter
--- * `ScriptName` - Skriptname der Entität
--- * `KnightID`   - ID des aktivierenden Helden
--- * `PlayerID`   - ID des aktivierenden Spielers
Report.ObjectClicked = anyInteger;

--- Die Interaktion des Objekts war erfolgreich.
--- Wenn das Objekt Kosten hat, wird die Aktivierung abgeschlossen, wenn die Kosten ankommen.
--- 
--- #### Parameter
--- * `ScriptName` - Skriptname der Entität
--- * `KnightID`   - ID des aktivierenden Helden
--- * `PlayerID`   - ID des aktivierenden Spielers
Report.ObjectInteraction = anyInteger;

--- Die Interaktion wird vom Objekt gelöscht.
---
--- #### Parameter
--- * `ScriptName` - Skriptname der Entität
Report.ObjectReset = anyInteger;

--- Der Zustand eines Objekts wurde zurückgesetzt.
---
--- #### Parameter
--- * `ScriptName` - Skriptname der Entität
Report.ObjectDelete = anyInteger;

