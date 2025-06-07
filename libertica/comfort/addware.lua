Lib.Register("comfort/AddWare");

function AddWare(_GoodType, _Amount, _PlayerID)
    local GoodCategory = Logic.GetGoodCategoryForGoodType(_GoodType);
    assert(GoodCategory ~= nil and GoodCategory ~= 0);
    assert(_Amount ~= nil and _Amount ~= 0);
    assert(_PlayerID ~= nil and _PlayerID >= 1 and _PlayerID <= 8);

    -- Dont execute for these good categories
    if GoodCategory == GoodCategories.GC_Ammunition
    or GoodCategory == GoodCategories.GC_Animal
    or GoodCategory == GoodCategories.GC_Document
    or GoodCategory == GoodCategories.GC_None
    or GoodCategory == GoodCategories.GC_RawFood
    or GoodCategory == GoodCategories.GC_RawMedicine
    or GoodCategory == GoodCategories.GC_Research
    or GoodCategory == GoodCategories.GC_Tools
    or GoodCategory == GoodCategories.GC_Water then
        return;
    end

    -- Add resources buy using AddGood
    if GoodCategory == GoodCategories.GC_Resource
    or GoodCategory == GoodCategories.GC_Luxury
    or GoodCategory == GoodCategories.GC_Gold then
        AddGood(_GoodType, _Amount, _PlayerID);
        return;
    end

    if _Amount > 0 then
        AddWare_Internal_AddGood(_GoodType, _Amount, _PlayerID);
    elseif _Amount < 0 then
        AddWare_Internal_SubGood(_GoodType, (-1) * _Amount, _PlayerID);
    end
end
API.AddWare = AddWare;

function AddWare_Internal_AddGood(_GoodType, _Amount, _PlayerID)
    local Amount = _Amount;
    local Buildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding)};
    for i= 1, #Buildings do
        if Amount <= 0 then break; end
        if Logic.GetEntityType(Buildings[i]) ~= Entities.B_Marketslot then
            local StockSize = Logic.GetMaxAmountOnStock(Buildings[i]);
            local GoodType = Logic.GetGoodTypeOnOutStockByIndex(Buildings[i], 0);
            local GoodAmount = Logic.GetAmountOnOutStockByIndex(Buildings[i], 0);
            local FillAmount = math.min(Amount, math.max(0, StockSize - GoodAmount));
            if _GoodType == GoodType and FillAmount > 0 then
                Amount = Amount - FillAmount;
                Logic.AddGoodToStock(Buildings[i], _GoodType, FillAmount);
            end
        end
    end
end

function AddWare_Internal_SubGood(_GoodType, _Amount, _PlayerID)
    local Amount = _Amount;
    local Buildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding)};
    for i= 1, #Buildings do
        if Amount <= 0 then break; end
        if Logic.GetEntityType(Buildings[i]) ~= Entities.B_Marketslot then
            local GoodType = Logic.GetGoodTypeOnOutStockByIndex(Buildings[i], 0);
            local GoodAmount = Logic.GetAmountOnOutStockByIndex(Buildings[i], 0);
            local ClearAmount = math.min(Amount, GoodAmount);
            if _GoodType == GoodType and ClearAmount > 0 then
                Amount = Amount - ClearAmount;
                Logic.RemoveGoodFromStock(Buildings[i], _GoodType, ClearAmount);
            end
        end
    end
end

