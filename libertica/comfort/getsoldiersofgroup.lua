Lib.Register("comfort/GetSoldiersOfGroup");

function GetSoldiersOfGroup(_Leader)
    local SoldierList = {};
    local EntityID = GetID(_Leader);
    assert(EntityID ~= 0, "Entity does not exist.");
    if Logic.IsLeader(EntityID) == 1 then
        local SoldierTable = {Logic.GetSoldiersAttachedToLeader(EntityID)};
        table.remove(SoldierTable, 1);
        SoldierList = SoldierTable;
    end
    return SoldierList;
end
API.GetSoldiersOfGroup = GetSoldiersOfGroup;

