Lib.Register("comfort/CreateCartByGoodType");

function CreateCartByGoodType(_PlayerID, _Position, _GoodType, _Orientation, _CartOverlay)
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    _Orientation = _Orientation or 0;
    local ID = 0;
    local Position = GetID(_Position);
    assert(Position ~= 0, "Entity does not exist.");

    local x,y,z = Logic.EntityGetPos(Position);
    if Logic.IsBuilding(Position) == 1 then
        x,y = Logic.GetBuildingApproachPosition(Position);
        _Orientation = Logic.GetEntityOrientation(Position)-90;
    end

    local ResourceCategory = Logic.GetGoodCategoryForGoodType(_GoodType);
    if ResourceCategory == GoodCategories.GC_Resource then
        ID = Logic.CreateEntityOnUnblockedLand(Entities.U_ResourceMerchant, x, y, _Orientation, _PlayerID);
    elseif _GoodType == Goods.G_Medicine then
        ID = Logic.CreateEntityOnUnblockedLand(Entities.U_Medicus, x, y, _Orientation,_PlayerID);
    elseif _GoodType == Goods.G_Gold or _GoodType == Goods.G_None or _GoodType == Goods.G_Information then
        if _CartOverlay then
            ID = Logic.CreateEntityOnUnblockedLand(_CartOverlay, x, y, _Orientation, _PlayerID);
        else
            ID = Logic.CreateEntityOnUnblockedLand(Entities.U_GoldCart, x, y, _Orientation, _PlayerID);
        end
    else
        ID = Logic.CreateEntityOnUnblockedLand(Entities.U_Marketer, x, y, _Orientation, _PlayerID);
    end
    return ID;
end
API.CreateCartByGoodType = CreateCartByGoodType;

