Lib.Register("comfort/GetPosition");

function GetPosition(_Entity)
    if not _Entity then
        return {X= 0, Y= 0, Z= 0};
    end
    if type(_Entity) == "table" and _Entity.X and _Entity.Y then
        _Entity.Z = _Entity.Z or 0;
        return _Entity;
    end
    assert(IsExisting(_Entity), "Entity does not exist.");
    local x, y, z = Logic.EntityGetPos(GetID(_Entity));
    return {X= x, Y= y, Z= z};
end
API.GetPosition = GetPosition;

