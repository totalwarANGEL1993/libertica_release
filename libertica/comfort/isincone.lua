Lib.Require("comfort/GetAngleBetween");
Lib.Require("comfort/GetDistance");
Lib.Register("comfort/IsInCone");

function IsInCone(_Target, _Center, _Length, _Rotation, _Width)
    local Distance = GetDistance(_Center, _Target)
    if Distance > _Length then
        return false;
    end
    local a = GetAngleBetween(_Center, _Target);
    local lb = _Rotation - _Width;
    local hb = _Rotation + _Width;
    return a >= lb and a <= hb;
end
API.IsInCone = IsInCone;

