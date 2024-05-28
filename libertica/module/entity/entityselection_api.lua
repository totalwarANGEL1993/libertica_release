Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntitySelection_API");

function DisableReleaseThieves(_Flag)
    if not GUI then
        ExecuteLocal([[DisableReleaseThieves(%s)]], tostring(_Flag));
        return;
    end
    Lib.EntitySelection.Local.ThiefRelease = not _Flag;
end
API.DisableReleaseThieves = DisableReleaseThieves;

function DisableReleaseSiegeEngines(_Flag)
    if not GUI then
        ExecuteLocal([[DisableReleaseSiegeEngines(%s)]], tostring(_Flag));
        return;
    end
    Lib.EntitySelection.Local.SiegeEngineRelease = not _Flag;
end
API.DisableReleaseSiegeEngines = DisableReleaseSiegeEngines;

function DisableReleaseSoldiers(_Flag)
    if not GUI then
        ExecuteLocal([[DisableReleaseSoldiers(%s)]], tostring(_Flag));
        return;
    end
    Lib.EntitySelection.Local.MilitaryRelease = not _Flag;
end
API.DisableReleaseSoldiers = DisableReleaseSoldiers;

function IsEntitySelected(_Entity, _PlayerID)
    if IsExisting(_Entity) then
        local EntityID = GetID(_Entity);
        local PlayerID = _PlayerID or Logic.EntityGetPlayer(EntityID);
        local SelectedEntities;
        if not GUI then
            SelectedEntities = Lib.EntitySelection.Global.SelectedEntities[PlayerID];
        else
            SelectedEntities = {GUI.GetSelectedEntities()};
        end
        for i= 1, #SelectedEntities, 1 do
            if SelectedEntities[i] == EntityID then
                return true;
            end
        end
    end
    return false;
end
API.IsEntityInSelection = IsEntitySelected;

function GetSelectedEntity(_PlayerID)
    local SelectedEntity;
    if not GUI then
        SelectedEntity = Lib.EntitySelection.Global.SelectedEntities[_PlayerID][1];
    else
        SelectedEntity = Lib.EntitySelection.Local.SelectedEntities[_PlayerID][1];
    end
    return SelectedEntity or 0;
end
API.GetSelectedEntity = GetSelectedEntity;

function GetSelectedEntities(_PlayerID)
    local SelectedEntities;
    if not GUI then
        SelectedEntities = Lib.EntitySelection.Global.SelectedEntities[_PlayerID];
    else
        SelectedEntities = Lib.EntitySelection.Local.SelectedEntities[_PlayerID];
    end
    return SelectedEntities;
end
API.GetSelectedEntities = GetSelectedEntities;

