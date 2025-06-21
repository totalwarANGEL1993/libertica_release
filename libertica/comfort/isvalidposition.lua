Lib.Register("comfort/IsValidPosition");

function IsValidPosition(_Pos)
    local world = {Logic.WorldGetSize()};
    if  type(_Pos) == "table"
    and (_Pos.X ~= nil and type(_Pos.X) == "number")
    and _Pos.X < world[1] and _Pos.X > 0
    and (_Pos.Y ~= nil and type(_Pos.Y) == "number")
    and _Pos.Y < world[2] and _Pos.Y > 0
    and (not _Pos.Z or _Pos.Z >= 0) then
        return true;
    end
    return false;
end
API.ValidatePosition = IsValidPosition;
API.IsValidPosition = IsValidPosition;

