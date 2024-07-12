Lib.Require("comfort/IsValidPosition");
Lib.Register("comfort/LookAt");

function LookAt(_Entity, _Target)
    local ID1 = GetID(_Entity);
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    assert(ID1 ~= 0, "Looking entity does not exist!");
    local x1,y1,z1 = Logic.EntityGetPos(ID1);
    local ID2;
    local x2, y2, z2;
    if type(_Target) == "table" then
        x2 = _Target.X;
        y2 = _Target.Y;
        z2 = _Target.Z;
    else
        ID2 = GetID(_Target);
        assert(ID2 ~= 0, "Target entity does not exist!");
        x2,y2,z2 = Logic.EntityGetPos(ID2);
    end

    assert(IsValidPosition({X= x1, Y= y1, Z= z1}), "Invalid looking position!");
    assert(IsValidPosition({X= x2, Y= y2, Z= z2}), "Invalid target position!");
    Angle = math.deg(math.atan2((y2 - y1), (x2 - x1)));
    Angle = (Angle < 0 and Angle + 360) or Angle;

    if Logic.IsLeader(ID1) == 1 then
        local Soldiers = {Logic.GetSoldiersAttachedToLeader(ID1)};
        for i= 2, Soldiers[1]+1 do
            Logic.SetOrientation(Soldiers[i], Angle);
        end
    end
    Logic.SetOrientation(ID1, Angle);
end
API.LookAt = LookAt;

