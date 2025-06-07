--- Adds features for entity selection.
---
--- Features:
--- <li>Fire soldiers</li>
--- <li>Fire war machines</li>
--- <li>Fire thieves</li>
--- <li>Obtain selection from global script</li>
--- <li>Fixes trebuchet selection</li>
---



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
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of entity
Report.ExpelSettler = anyInteger;

--- A trebuchet is forced to stop.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of entity
--- * `TaskList`: <b>integer</b> ID of Tasklist
Report.ForceTrebuchetTasklist = anyInteger;

--- A trebuchet is build from a siege engine cart.
--- (Currently not used)
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of entity
Report.ErectTrebuchet = anyInteger;

--- A trebuchet is broken down to a siege engine cart.
--- (Currently not used)
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of entity
Report.DisambleTrebuchet = anyInteger;

