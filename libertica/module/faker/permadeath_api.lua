Lib.Require("comfort/IsLocalScript");
Lib.Register("module/faker/Permadeath_API");

function ResumeSettler(_Entity)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Permadeath.Global:ResumeSettler(_Entity);
end
API.ResumeSettler = ResumeSettler;

function SuspendSettler(_Entity, _SuspendtionTime)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Permadeath.Global:SuspendSettler(_Entity, _SuspendtionTime);
end
API.SuspendSettler = SuspendSettler;

function IsSettlerSuspended(_Entity)
    if IsLocalScript() then
        return Lib.Permadeath.Local:IsSettlerSuspended(_Entity);
    end
    return Lib.Permadeath.Global:IsSettlerSuspended(_Entity);
end
API.SuspendSettler = SuspendSettler;

function HasBuildingSuspendedInhabitants(_Entity)
    if IsLocalScript() then
        return Lib.Permadeath.Local:HasSuspendedInhabitants(_Entity);
    end
    return Lib.Permadeath.Global:HasSuspendedInhabitants(_Entity);
end
API.HasBuildingSuspendedInhabitants = HasBuildingSuspendedInhabitants;

function CountWorkerInBuilding(_Entity)
    if IsLocalScript() then
        return Lib.Permadeath.Local:CountWorkerInBuilding(_Entity);
    end
    return Lib.Permadeath.Global:CountWorkerInBuilding(_Entity);
end
API.CountWorkerInBuilding = CountWorkerInBuilding;

function CountInhabitantsInBuilding(_Entity)
    if IsLocalScript() then
        return Lib.Permadeath.Local:CountInhabitantsInBuilding(_Entity);
    end
    return Lib.Permadeath.Global:CountInhabitantsInBuilding(_Entity);
end
API.CountInhabitantsInBuilding = CountInhabitantsInBuilding;

