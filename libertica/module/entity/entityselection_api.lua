Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntitySelection_API");

function DisableReleaseThieves(_Flag)
    if not IsLocalScript() then
        ExecuteLocal([[DisableReleaseThieves(%s)]], tostring(_Flag));
        return;
    end
    Lib.EntitySelection.AquireContext();
    this.ThiefRelease = not _Flag;
    Lib.EntitySelection.ReleaseContext();
end
API.DisableReleaseThieves = DisableReleaseThieves;

function DisableReleaseSiegeEngines(_Flag)
    if not IsLocalScript() then
        ExecuteLocal([[DisableReleaseSiegeEngines(%s)]], tostring(_Flag));
        return;
    end
    Lib.EntitySelection.AquireContext();
    this.SiegeEngineRelease = not _Flag;
    Lib.EntitySelection.ReleaseContext();
end
API.DisableReleaseSiegeEngines = DisableReleaseSiegeEngines;

function DisableReleaseSoldiers(_Flag)
    if not IsLocalScript() then
        ExecuteLocal([[DisableReleaseSoldiers(%s)]], tostring(_Flag));
        return;
    end
    Lib.EntitySelection.AquireContext();
    this.MilitaryRelease = not _Flag;
    Lib.EntitySelection.ReleaseContext();
end
API.DisableReleaseSoldiers = DisableReleaseSoldiers;

