Lib.Require("comfort/GetAngleBetween");
Lib.Register("comfort/IsInSight");

function IsInSight(_Target, _Viewer, _Length, _Width)
    _Width = _Width or 60;
    local TargetID = GetID(_Target);
    local ViewerID = GetID(_Viewer);
    local Rotation = Logic.GetEntityOrientation(ViewerID) - 90;
    if Logic.CheckEntitiesDistance(TargetID, ViewerID, _Length) == 0 then
        return false;
    end
    local a = GetAngleBetween(ViewerID, TargetID);
    local lb = Rotation - _Width;
    local hb = Rotation + _Width;
    return a >= lb and a <= hb;
end

