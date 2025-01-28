--- Ermöglicht das Hinzufügen von bis zu 6 zusätzlichen Schaltflächen in Gebäudemenüs.
---
--- #### Reports
--- * `Report.CancelUpgradeClicked` - Ein Ausbau wurde abgebrochen
--- * `Report.StartUpgradeClicked` - Ein Ausbau wurde gestartet
--- * `Report.FestivalClicked` - Der Button "Fest feiern" wurde geklickt
--- * `Report.SermonClicked` - Der Button "Predigt abhalten" wurde geklickt
--- * `Report.TheatrePlayClicked` - Der Button "Vorführung beginnen" wurde geklickt
---
Lib.UIBuilding = Lib.UIBuilding or {};



--- Erstellt eine Gebäudeschaltfläche an der Menüposition.
--- @param _X integer X-Position für Schaltfläche
--- @param _Y integer X-Position für Schaltfläche
--- @param _Action function Steuerung der Schaltflächenaktion
--- @param _Tooltip function Steuerung des Schaltflächentooltips
--- @param _Update function Steuerung des Schaltflächenupdates
--- @return integer ID ID der Schaltfläche
function AddBuildingButtonAtPosition(_X, _Y, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonAtPosition = AddBuildingButtonAtPosition;

--- Erstellt eine Gebäudeschaltfläche.
---
--- #### Beispiele
--- ```lua
--- -- Beispiel #1: Eine einfache Schaltfläche
--- SpecialButtonID = AddBuildingButton(
---     -- Aktion
---     function(_WidgetID, _BuildingID)
---         GUI.AddNote("Etwas passiert!");
---     end,
---     -- Tooltip
---     function(_WidgetID, _BuildingID)
---         -- Ein Kostentooltip MUSS verwendet werden.
---         SetTooltipCosts("Beschreibung", "Dies ist die Beschreibung!");
---     end,
---     -- Update
---     function(_WidgetID, _BuildingID)
---         -- Deaktivieren, wenn im Bau
---         if Logic.IsConstructionComplete(_BuildingID) == 0 then
---             XGUIEng.ShowWidget(_WidgetID, 0);
---             return;
---         end
---         -- Deaktivieren, wenn ein Upgrade durchgeführt wird
---         if Logic.IsBuildingBeingUpgraded(_BuildingID) then
---             XGUIEng.DisableButton(_WidgetID, 1);
---         end
---         SetIcon(_WidgetID, {1, 1});
---     end
--- );
--- ```
---
--- @param _Action function Steuerung der Schaltflächenaktion
--- @param _Tooltip function Steuerung des Schaltflächentooltips
--- @param _Update function Steuerung des Schaltflächenupdates
--- @return integer ID ID der Schaltfläche
function AddBuildingButton(_Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButton = AddBuildingButton;

--- Erstellt eine Gebäudeschaltfläche an der Menüposition für einen Entitätstyp.
--- @param _Type integer Typ der Entität
--- @param _X integer X-Position für Schaltfläche
--- @param _Y integer Y-Position für Schaltfläche
--- @param _Action function Steuerung der Schaltflächenaktion
--- @param _Tooltip function Steuerung des Schaltflächentooltips
--- @param _Update function Steuerung des Schaltflächenupdates
--- @return integer ID ID der Schaltfläche
function AddBuildingButtonByTypeAtPosition(_Type, _X, _Y, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonByTypeAtPosition = AddBuildingButtonByTypeAtPosition;

--- Erstellt eine Gebäudeschaltfläche für einen Entitätstyp.
--- @param _Type integer Typ der Entität
--- @param _Action function Steuerung der Schaltflächenaktion
--- @param _Tooltip function Steuerung des Schaltflächentooltips
--- @param _Update function Steuerung des Schaltflächenupdates
--- @return integer ID ID der Schaltfläche
function AddBuildingButtonByType(_Type, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonByType = AddBuildingButtonByType;

--- Erstellt eine Gebäudeschaltfläche an der Menüposition für eine bestimmte Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _X integer X-Position für Schaltfläche
--- @param _Y integer X-Position für Schaltfläche
--- @param _Action function Steuerung der Schaltflächenaktion
--- @param _Tooltip function Steuerung des Schaltflächentooltips
--- @param _Update function Steuerung des Schaltflächenupdates
--- @return integer ID ID der Schaltfläche
function AddBuildingButtonByEntityAtPosition(_ScriptName, _X, _Y, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonByEntityAtPosition = AddBuildingButtonByEntityAtPosition;

--- Erstellt eine Gebäudeschaltfläche für eine bestimmte Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _Action function Steuerung der Schaltflächenaktion
--- @param _Tooltip function Steuerung des Schaltflächentooltips
--- @param _Update function Steuerung des Schaltflächenupdates
--- @return integer ID ID der Schaltfläche
function AddBuildingButtonByEntity(_ScriptName, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonByEntity = AddBuildingButtonByEntity;

--- Entfernt eine Gebäudeschaltfläche.
--- @param _ID integer ID der Schaltfläche
function DropBuildingButton(_ID)
end
API.DropBuildingButton = DropBuildingButton;

--- Entfernt eine Gebäudeschaltfläche für den Entitätstyp.
--- @param _Type integer Typ der Entität
--- @param _ID integer ID der Schaltfläche
function DropBuildingButtonFromType(_Type, _ID)
end
API.DropBuildingButtonFromType = DropBuildingButtonFromType;

--- Entfernt eine Gebäudeschaltfläche für eine bestimmte Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _ID integer ID der Schaltfläche
function DropBuildingButtonFromEntity(_ScriptName, _ID)
end
API.DropBuildingButtonFromEntity = DropBuildingButtonFromEntity;

--- Aktiviert den Rückbau von Stadt- und Sammlergebäuden.
function ActivateDowngradeBuilding()
end
API.ActivateDowngradeBuilding = ActivateDowngradeBuilding;

--- Deaktiviert den Rückbau von Stadt- und Sammlergebäuden.
function DeactivateDowngradeBuilding()
end
API.DeactivateDowngradeBuilding = DeactivateDowngradeBuilding;

--- Setzt die Kosten für den Rückbau für alle Spieler.
--- @param _MoneyCost integer Rückbaukosten
function SetDowngradeBuildingCost(_MoneyCost)
end
API.SetDowngradeCosts = SetDowngradeBuildingCost;
API.SetDowngradeBuildingCost = SetDowngradeBuildingCost;

--- Aktiviert das Reservieren von Waren am Gebäude.
function ActivateSingleReserveBuilding()
end
API.ActivateSingleReserveBuilding = ActivateSingleReserveBuilding;

--- Deaktiviert das Reservieren von Waren am Gebäude.
function DeactivateSingleReserveBuilding()
end
API.DeactivateSingleReserveBuilding = DeactivateSingleReserveBuilding;

--- Aktiviert das Stoppen von einzelnen Gebäuden. 
function ActivateSingleStopBuilding()
end
API.ActivateSingleStopBuilding = ActivateSingleStopBuilding;

--- Deaktiviert das Stoppen von einzelnen Gebäuden.
function DeactivateSingleStopBuilding()
end
API.DeactivateSingleStopBuilding = DeactivateSingleStopBuilding;



--- Der Spieler hat ein Gebäude zurückgebaut.
--- 
--- #### Parameter
--- * `EntityID` - ID des Gebäudes
Report.DowngradeBuilding = anyInteger;

--- Der Spieler hat eine Ware gesperrt.
--- 
--- #### Parameter
--- * `PlayerID` - ID des Spielers
--- * `GoodType` - Typ der Ware
Report.LockGoodType = anyInteger;

--- Der Spieler hat eine Wahre freigegeben.
--- 
--- #### Parameter
--- * `PlayerID` - ID des Spielers
--- * `GoodType` - Typ der Ware
Report.UnlockGoodType = anyInteger;

--- Der Spieler hat die Produktion im Gebäude fortgeführt.
--- 
--- #### Parameter
--- * `EntityID` - ID des Gebäudes
Report.ResumeBuilding = anyInteger;

--- Der Spieler hat die Produktion im Gebäude angehalten.
--- 
--- #### Parameter
--- * `EntityID` - ID des Gebäudes
Report.YieldBuilding = anyInteger;

--- Der Spieler hat auf die Schaltfläche "Upgrade abbrechen" geklickt.
--- 
--- #### Parameter
--- * `EntityID` - ID des Gebäudes
--- * `PlayerID` - ID des Besitzers
Report.CancelUpgradeClicked = anyInteger;

--- Der Spieler hat auf die Schaltfläche "Upgrade starten" geklickt.
--- 
--- #### Parameter
--- * `EntityID` - ID des Gebäudes
--- * `PlayerID` - ID des Besitzers
Report.StartUpgradeClicked = anyInteger;

--- Der Spieler hat auf die Schaltfläche "Festival starten" geklickt.
--- 
--- #### Parameter
--- * `PlayerID` - ID des Spielers
--- * `Type`     - Festivaltyp
Report.FestivalClicked = anyInteger;

--- Der Spieler hat auf die Schaltfläche "Predigt starten" geklickt.
--- 
--- #### Parameter
--- * `PlayerID` - ID des Spielers
Report.SermonClicked = anyInteger;

--- Der Spieler hat auf die Schaltfläche "Theaterstück starten" geklickt.
--- 
--- #### Parameter
--- * `EntityID` - ID des Gebäudes
--- * `PlayerID` - ID des Besitzers
Report.TheatrePlayClicked = anyInteger;

