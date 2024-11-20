Lib.Require("comfort/GetCirclePosition");
Lib.Require("comfort/IsValidPosition");
Lib.Register("comfort/MoveToPosition");

function MoveToPosition(_Entity, _Target, _Distance, _Angle, _IgnoreBlocking)
    local ID = GetID(_Entity);
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    assert(ID ~= 0, "Moving entity does not exist!");

    local Target = GetCirclePosition(_Target, _Distance, _Angle);
    if not IsValidPosition(Target) then
        return;
    end

    if _IgnoreBlocking then
        Logic.MoveEntity(ID, Target.X, Target.Y);
        if Logic.IsSettler(ID) == 1 then
            Logic.SetTaskList(ID, TaskLists.TL_NPC_WALK);
        end
    else
        Logic.MoveSettler(ID, Target.X, Target.Y);
    end

    StartSimpleJobEx(function(_ID)
        if not IsExisting(_ID) then
            return true;
        end
        if Logic.IsEntityMoving(_ID) == false then
            if Logic.IsSettler(_ID) == 1 then
                Logic.SetTaskList(_ID, TaskLists.TL_NPC_IDLE);
            end
            return true;
        end
    end, ID);
end
API.MoveEntityToPosition = MoveToPosition;
API.MoveToPosition = MoveToPosition;

