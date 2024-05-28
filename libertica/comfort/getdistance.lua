Lib.Require("comfort/GetPosition");
Lib.Register("comfort/GetDistance");

function GetDistance(_Pos1, _Pos2, _NoSqrt)
    if (type(_Pos1) == "string") or (type(_Pos1) == "number") then
        _Pos1 = GetPosition(_Pos1);
    end
    if (type(_Pos2) == "string") or (type(_Pos2) == "number") then
        _Pos2 = GetPosition(_Pos2);
    end
    assert(type(_Pos1) == "table", "Invalid frist position.");
    assert(type(_Pos2) == "table", "Invalid second position.");
    local xDistance = (_Pos1.X - _Pos2.X);
    local yDistance = (_Pos1.Y - _Pos2.Y);
    if _NoSqrt then
        return (xDistance^2) + (yDistance^2);
    end
    return math.sqrt((xDistance^2) + (yDistance^2));
end
API.GetDistance = GetDistance;

