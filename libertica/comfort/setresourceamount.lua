Lib.Register("comfort/SetResourceAmount");

function SetResourceAmount(_Entity, _StartAmount, _RefillAmount)
    assert(GUI == nil, "Can not be used in local script!");
    assert(type(_StartAmount) == "number");
    assert(type(_RefillAmount) == "number");

    local EntityID = GetID(_Entity);
    if EntityID == nil or EntityID == 0 or Logic.GetResourceDoodadGoodType(EntityID) == 0 then
        return;
    end
    if Logic.GetResourceDoodadGoodAmount(EntityID) == 0 then
        EntityID = ReplaceEntity(EntityID, Logic.GetEntityType(EntityID));
    end
    Logic.SetResourceDoodadGoodAmount(EntityID, _StartAmount);
    return true;
end
API.SetResourceAmount = SetResourceAmount;

