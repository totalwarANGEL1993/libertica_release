Lib.Require("comfort/IsValidPosition");
Lib.Register("comfort/GetLinePosition");

function GetLinePosition(_Pos1, _Pos2, _Percentage)
    if _Percentage > 1 then
        _Percentage = _Percentage / 100;
    end

    if not IsValidPosition(_Pos1) and not IsExisting(_Pos1) then
        error(false, "_Pos1 does not exist or is invalid position!");
        return;
    end
    local Pos1 = _Pos1;
    if type(Pos1) ~= "table" then
        Pos1 = API.GetPosition(Pos1);
    end

    if not IsValidPosition(_Pos2) and not IsExisting(_Pos2) then
        error(false, "_Pos1 does not exist or is invalid position!");
        return;
    end
    local Pos2 = _Pos2;
    if type(Pos2) ~= "table" then
        Pos2 = API.GetPosition(Pos2);
    end

	local dx = Pos2.X - Pos1.X;
	local dy = Pos2.Y - Pos1.Y;
    return {X= Pos1.X+(dx*_Percentage), Y= Pos1.Y+(dy*_Percentage)};
end
API.GetLinePosition = GetLinePosition;

