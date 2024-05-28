Lib.Register("comfort/GetSoldiersOfGroup");

function GetSoldiersOfGroup(_Leader)
    local SoldierList = {};
    local EntityID = GetID(_Leader);
    assert(EntityID ~= 0, "Entity does not exist.");
    if Logic.IsLeader(EntityID) == 1 then
        local SoldierTable = {Logic.GetSoldiersAttachedToLeader(EntityID)};
        for i= 2, SoldierTable[1]+1 do
            table.insert(SoldierList, SoldierTable[i]);
        end
    end
    return SoldierList;
end
API.GetSoldiersOfGroup = GetSoldiersOfGroup;

