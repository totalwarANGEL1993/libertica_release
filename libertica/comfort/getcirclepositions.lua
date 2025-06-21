Lib.Require("comfort/GetCirclePosition");
Lib.Require("comfort/Round");
Lib.Register("comfort/GetCirclePositions");

function GetCirclePositions(_Target, _Distance, _Periode, _Offset)
    local Periode = Round(360 / _Periode);
    local PositionList = {};
    for i= (Periode + _Offset), (360 + _Offset) do
        local Section = GetCirclePosition(_Target, _Distance, i);
        table.insert(PositionList, Section);
    end
    return PositionList;
end
API.GetCirclePositions = GetCirclePositions;

