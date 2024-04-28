--- Adds features for entity selection.
---
--- Features:
--- * Fire soldiers
--- * Fire war machines
--- * Fire thieves
--- * Obtain selection from global script
--- * Fixes trebuchet selection
---
--- #### Reports
--- * `Report.ExpelSettler` - A unit has been expelled.
--- * `Report.SelectionChanged` - Die Auswahl von Einheiten eines Spielers hat sich geändert.
--- * `Report.ForceTrebuchetTasklis`t - Ein Trebuchet wird zum Anhalten gezwungen.
--- * `Report.ErectTrebuche`t - Ein Trebuchet wird aus einem Belagerungsmaschinenwagen gebaut.
--- * `Report.DisambleTrebuchet` -Ein Trebuchet wird zu einem Belagerungsmaschinenwagen abgebaut.
---
Lib.Selection = Lib.Selection or {};



--- Deacivates (and reactivates) firing thieves.
--- @param _Flag boolean Deactivate release thieves
function DisableReleaseThieves(_Flag)
end
API.DisableReleaseThieves = DisableReleaseThieves;

--- Deacivates (and reactivates) firing war machines.
--- @param _Flag boolean Deactivate release war machines
function DisableReleaseSiegeEngines(_Flag)
end
API.DisableReleaseSiegeEngines = DisableReleaseSiegeEngines;

--- Deacivates (and reactivates) firing soldiers.
--- @param _Flag boolean Deactivate release soldiers
function DisableReleaseSoldiers(_Flag)
end
API.DisableReleaseSoldiers = DisableReleaseSoldiers;

--- Returns true if the entity is currently selected.
--- @param _Entity any        Entity to check
--- @param _PlayerID integer? PlayerID to check
--- @return boolean Selected Entity is selectec
function IsEntitySelected(_Entity, _PlayerID)
    return false;
end
API.IsEntityInSelection = IsEntitySelected;

--- Returns the first selected entity.
--- @param _PlayerID integer ID of player
--- @return integer Entity First selected entity
function GetSelectedEntity(_PlayerID)
    return 0;
end
API.GetSelectedEntity = GetSelectedEntity;

--- Returns all selected entities of the player.
--- @param _PlayerID integer ID of player
--- @return table List Entities selected by the player
function GetSelectedEntities(_PlayerID)
    return {};
end
API.GetSelectedEntities = GetSelectedEntities;



--- A entity has been expelled.
---
--- #### Parameters
--- * `EntityID` - ID of entity
Report.ExpelSettler = anyInteger;

--- The selection of entities of a player has changed.
---
--- #### Parameters
--- * `PlayerID` - ID of player
--- * `...`      - List of entities
Report.SelectionChanged = anyInteger;

--- A trebuchet is forced to stop.
---
--- #### Parameters
--- * `EntityID` - ID of entity
--- * `TaskList` - ID of Tasklist
Report.ForceTrebuchetTasklist = anyInteger;

--- A trebuchet is build from a siege engine cart.
--- (Currently not used)
---
--- #### Parameters
--- * `EntityID` - ID of entity
Report.ErectTrebuchet = anyInteger;

--- A trebuchet is broken down to a siege engine cart.
--- (Currently not used)
---
--- #### Parameters
--- * `EntityID` - ID of entity
Report.DisambleTrebuchet = anyInteger;

