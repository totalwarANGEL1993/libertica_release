--- Ermöglicht es Arbeiter dauerhaft "sterben" zu lassen.
--- 
--- Das Spiel ersetzt einen Arbeiter normalerweise sofort. Mit diesem Modul
--- kannst du Arbeiter dauerhaft entfernen, ohne das er ersetzt wird. Das
--- bedeutet auch, dass sein gebäude weniger effektiv arbeitet.



--- Gibt einen beurlaubten Arbeiter wieder frei.
--- <p>
--- <b>Achtung:</b> Der ursprüngliche Arbeiter wird gelöscht und durch einen
--- neuen ersetzt. Dadurch ändert sich die ID und der Skriptname geht verloren.
--- @param _Entity any Skriptname oder ID
function ResumeSettler(_Entity)
end
API.ResumeSettler = ResumeSettler;

--- Beurlaubt einen Arbeiter für eine bestimmte Zeit oder dauerhaft.
--- <p>
--- <b>Achtung:</b> Gebäude mit beurlaubten Arbeitern arbeiten weniger effektiv.
--- Der beurlaubte Arbeiter zählt weiterhin auf das Bevölkerungslimit.
--- @param _Entity any Skriptname oder ID
--- @param _SuspendtionTime? integer Dauer der Beurlaubung
function SuspendSettler(_Entity, _SuspendtionTime)
end
API.SuspendSettler = SuspendSettler;

--- Gibt zurück, ob der Arbeiter beurlaubt ist.
--- @param _Entity any Skriptname oder ID
--- @return boolean Suspended Der Arbeiter ist beurlaubt
function IsSettlerSuspended(_Entity)
    return true;
end
API.SuspendSettler = SuspendSettler;

--- Gibt zurück, ob ein Gebäude beurlaubte Arbeiter hat.
--- @param _Entity any Skriptname oder ID
--- @return boolean HasSuspended Das Gebäude hat beurlaubte Arbeiter
function HasBuildingSuspendedInhabitants(_Entity)
    return true;
end
API.HasBuildingSuspendedInhabitants = HasBuildingSuspendedInhabitants;

--- Gibt die Anzahl der Arbeiter im Gebäude zurück.
--- @param _Entity any Skriptname oder ID
--- @return integer Workers Anzahl der Arbeiter
function CountWorkerInBuilding(_Entity)
    return 0;
end
API.CountWorkerInBuilding = CountWorkerInBuilding;

--- Gibt die Anzahl der Einwohner im Gebäude zurück.
--- @param _Entity any Skriptname oder ID
--- @return integer Workers Anzahl der Arbeiter
function CountInhabitantsInBuilding(_Entity)
    return 0;
end
API.CountInhabitantsInBuilding = CountInhabitantsInBuilding;



--- Die Suspendierung eines Siedlers wurde automatisch aufgehoben.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID des Siedlers
Report.SettlerSuspensionElapsed = anyInteger;

