Lib.Require("comfort/GetSoldiersOfGroup");
Lib.Require("comfort/GetPosition");
Lib.Require("comfort/IsValidPosition");
Lib.Register("comfort/SetPositionAndLookAt");

function SetPositionAndLookAt(_Entity, _Target, _LookAt)
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    local ID = GetID(_Entity);
    if not ID then
        return;
    end
    local Target = GetPosition(_Target);
    assert(IsValidPosition(Target), "Invalid position.");
    for _, SoldierID in pairs(GetSoldiersOfGroup(ID)) do
        SetPosition(SoldierID, _Target);
        LookAt(SoldierID, _LookAt);
    end
    Logic.DEBUG_SetSettlerPosition(ID, Target.X, Target.Y);
    LookAt(ID, _LookAt);
end
API.PlaceEntityAndLookAt = SetPositionAndLookAt;
API.SetPositionAndLookAt = SetPositionAndLookAt;

