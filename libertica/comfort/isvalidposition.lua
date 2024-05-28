Lib.Register("comfort/IsValidPosition");

function IsValidPosition(_Pos)
    if type(_Pos) == "table" then
        if (_Pos.X ~= nil and type(_Pos.X) == "number") and (_Pos.Y ~= nil and type(_Pos.Y) == "number") then
            local world = {Logic.WorldGetSize()};
            if not _Pos.Z or _Pos.Z >= 0 then
                if _Pos.X < world[1] and _Pos.X > 0 and _Pos.Y < world[2] and _Pos.Y > 0 then
                    return true;
                end
            end
        end
    end
    return false;
end
API.IsValidPosition = IsValidPosition;

