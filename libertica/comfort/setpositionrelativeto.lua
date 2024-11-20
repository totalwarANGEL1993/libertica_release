Lib.Require("comfort/GetCirclePosition");
Lib.Require("comfort/IsValidPosition");
Lib.Register("comfort/SetPositionRelativeTo");

function SetPositionRelativeTo(_Entity, _Target, _Distance, _Angle)
    local ID = GetID(_Entity);
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    assert(ID ~= 0, "Entity does not exist!");

    local Target = GetCirclePosition(_Target, _Distance, _Angle);
    if not IsValidPosition(Target) then
        return;
    end
    for _, SoldierID in pairs(GetSoldiersOfGroup(ID)) do
        SetPositionRelativeTo(SoldierID, _Target);
    end
    Logic.DEBUG_SetSettlerPosition(ID, Target.X, Target.Y);
end
API.PlaceEntityToPosition = SetPositionRelativeTo;
API.SetPositionRelativeTo = SetPositionRelativeTo;

