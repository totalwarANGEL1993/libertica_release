--- Allows to make inhabitants of buildings "die" permamently.
--- 
--- The game usually replaces a dead worker. With this module you will be able
--- to remove a worker (or a spouse) permamently. This also means that the 
--- building will be less effective.



--- Resumes a suspended settler.
--- <p>
--- <b>Attention:</b> The origininal worker will be deleted and replaced with
--- a new one. This will change the entity ID and erase the scriptname.
--- @param _Entity any Scriptname or ID
function ResumeSettler(_Entity)
end
API.ResumeSettler = ResumeSettler;

--- Suspends a settler momentarily or forever.
--- <p>
--- <b>Attention:</b> Buildings with suspended inhabitants are less effective.
--- The suspended settler still counts for the population limit.
--- @param _Entity any Scriptname or ID
--- @param _SuspendtionTime? integer Duration of suspension
function SuspendSettler(_Entity, _SuspendtionTime)
end
API.SuspendSettler = SuspendSettler;

--- Returns if the settler is suspended.
--- @param _Entity any Scriptname or ID
--- @return boolean Suspended The settler is suspended
function IsSettlerSuspended(_Entity)
    return true;
end
API.SuspendSettler = SuspendSettler;

--- Returns if the building has suspended inhabitants.
--- @param _Entity any Scriptname or ID
--- @return boolean HasSuspended Building has suspended inhabitants
function HasBuildingSuspendedInhabitants(_Entity)
    return true;
end
API.HasBuildingSuspendedInhabitants = HasBuildingSuspendedInhabitants;

--- Returns the amount of workers in the building.
--- @param _Entity any Scriptname or ID
--- @return integer Workers Amount of workers
function CountWorkerInBuilding(_Entity)
    return 0;
end
API.CountWorkerInBuilding = CountWorkerInBuilding;

--- Returns the amount of settlers in the building.
--- @param _Entity any Scriptname or ID
--- @return integer Inhabitants Amount of settlers
function CountInhabitantsInBuilding(_Entity)
    return 0;
end
API.CountInhabitantsInBuilding = CountInhabitantsInBuilding;



--- The suspension of a settler ended automatically.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of Settler
Report.SettlerSuspensionElapsed = anyInteger;

