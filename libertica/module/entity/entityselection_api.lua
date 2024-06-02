Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntitySelection_API");

function DisableReleaseThieves(_Flag)
    if not GUI then
        ExecuteLocal([[DisableReleaseThieves(%s)]], tostring(_Flag));
        return;
    end
    Lib.EntitySelection.AquireContext();
    this.ThiefRelease = not _Flag;
    Lib.EntitySelection.ReleaseContext();
end
API.DisableReleaseThieves = DisableReleaseThieves;

function DisableReleaseSiegeEngines(_Flag)
    if not GUI then
        ExecuteLocal([[DisableReleaseSiegeEngines(%s)]], tostring(_Flag));
        return;
    end
    Lib.EntitySelection.AquireContext();
    this.SiegeEngineRelease = not _Flag;
    Lib.EntitySelection.ReleaseContext();
end
API.DisableReleaseSiegeEngines = DisableReleaseSiegeEngines;

function DisableReleaseSoldiers(_Flag)
    if not GUI then
        ExecuteLocal([[DisableReleaseSoldiers(%s)]], tostring(_Flag));
        return;
    end
    Lib.EntitySelection.AquireContext();
    this.MilitaryRelease = not _Flag;
    Lib.EntitySelection.ReleaseContext();
end
API.DisableReleaseSoldiers = DisableReleaseSoldiers;

function IsEntitySelected(_Entity, _PlayerID)
    local Existing = false;
    local EntityID = GetID(_Entity);
    if IsExisting(EntityID) then
        Lib.EntitySelection.AquireContext();
        for i= 1, #this.SelectedEntities[_PlayerID], 1 do
            if this.SelectedEntities[_PlayerID][i] == EntityID then
                Existing = true;
                break;
            end
        end
        Lib.EntitySelection.ReleaseContext();
    end
    return Existing;
end
API.IsEntityInSelection = IsEntitySelected;

function GetSelectedEntity(_PlayerID)
    local SelectedEntity = 0;
    Lib.EntitySelection.AquireContext();
    SelectedEntities = this.SelectedEntities[_PlayerID][1];
    Lib.EntitySelection.ReleaseContext();
    return SelectedEntity;
end
API.GetSelectedEntity = GetSelectedEntity;

function GetSelectedEntities(_PlayerID)
    local SelectedEntities = {};
    Lib.EntitySelection.AquireContext();
    SelectedEntities = this.SelectedEntities[_PlayerID];
    Lib.EntitySelection.ReleaseContext();
    return SelectedEntities;
end
API.GetSelectedEntities = GetSelectedEntities;

