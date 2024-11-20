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
Lib.EntitySelection = Lib.EntitySelection or {};



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



--- A entity has been expelled.
---
--- #### Parameters
--- * `EntityID` - ID of entity
Report.ExpelSettler = anyInteger;

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

