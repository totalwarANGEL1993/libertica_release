Lib.Require("comfort/GetSoldiersOfGroup");
Lib.Require("comfort/GetPosition");
Lib.Require("comfort/IsValidPosition");
Lib.Register("comfort/SetPosition");

function SetPosition(_Entity, _Target)
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    local ID = GetID(_Entity);
    if not ID then
        return;
    end
    local Target = GetPosition(_Target);
    assert(IsValidPosition(Target), "Invalid position.");
    for k,v in pairs(GetSoldiersOfGroup(ID)) do
        SetPosition(v, _Target);
    end
    Logic.DEBUG_SetSettlerPosition(ID, Target.X, Target.Y);
end
API.SetPosition = SetPosition;

