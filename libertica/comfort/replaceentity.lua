Lib.Register("comfort/ReplaceEntity");

function ReplaceEntity(_Entity, _Type, _NewOwner)
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    local ID1 = GetID(_Entity);
    if ID1 == 0 then
        return 0;
    end
    local pos = GetPosition(ID1);
    local player = _NewOwner or Logic.EntityGetPlayer(ID1);
    local orientation = Logic.GetEntityOrientation(ID1);
    local name = Logic.GetEntityName(ID1);
    DestroyEntity(ID1);
    local ID2 = Logic.CreateEntity(_Type, pos.X, pos.Y, orientation, player);
    Logic.SetEntityName(ID2, name);
    if Logic.IsSettler(ID2) == 1 then
        Logic.SetTaskList(ID2, TaskLists.TL_NPC_IDLE);
    end
    return ID2;
end
API.ReplaceEntity = ReplaceEntity;

