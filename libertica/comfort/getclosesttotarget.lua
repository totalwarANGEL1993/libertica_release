Lib.Require("comfort/GetDistance");
Lib.Register("comfort/GetClosestToTarget");

function GetClosestToTarget(_Target, _List)
    local ClosestToTarget = 0;
    local ClosestToTargetDistance = Logic.WorldGetSize() ^ 2;
    for i= 1, #_List, 1 do
        assert(type(_List[i]) ~= "table", "Invalid entity.");
        local DistanceBetween = GetDistance(_List[i], _Target, true);
        if DistanceBetween < ClosestToTargetDistance then
            ClosestToTargetDistance = DistanceBetween;
            ClosestToTarget = _List[i];
        end
    end
    return ClosestToTarget;
end
API.GetClosestToTarget = GetClosestToTarget;

