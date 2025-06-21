Lib.Require("comfort/GetLinePosition");
Lib.Register("comfort/GetLinePositions");

function GetLinePositions(_Pos1, _Pos2, _Periode)
    local PositionList = {};
    for i= 0, 100, (1/_Periode)*100 do
        local Section = GetLinePosition(_Pos1, _Pos2, i);
        table.insert(PositionList, Section);
    end
    return PositionList;
end
API.GetLinePositions = GetLinePositions;

