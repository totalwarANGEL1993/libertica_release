Lib.Register("module/city/Promotion_Helper");

Lib.Promotion = Lib.Promotion or {};
Lib.Promotion.Helper = {};

-- This is needed to overwrite the helper functions after the loadscreen has
-- been clicked away.
Lib.Promotion.Helper.OverwritePromotionHelper = function()
    DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist = Lib.Promotion.Helper.DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist;
    DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist = Lib.Promotion.Helper.DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist;
    DoesNeededNumberOfGoodTypesForKnightTitleExist = Lib.Promotion.Helper.DoesNeededNumberOfGoodTypesForKnightTitleExist;
    DoNeededNumberOfConsumedGoodsForKnightTitleExist = Lib.Promotion.Helper.DoNeededNumberOfConsumedGoodsForKnightTitleExist;
    DoNumberOfProductsInCategoryExist = Lib.Promotion.Helper.DoNumberOfProductsInCategoryExist;
    DoNeededDiversityBuffForKnightTitleExist = Lib.Promotion.Helper.DoNeededDiversityBuffForKnightTitleExist;
    DoCustomFunctionForKnightTitleSucceed = Lib.Promotion.Helper.DoCustomFunctionForKnightTitleSucceed;
    DoNeededNumberOfDecoratedBuildingsForKnightTitleExist = Lib.Promotion.Helper.DoNeededNumberOfDecoratedBuildingsForKnightTitleExist;
    DoNeededSpecialBuildingUpgradeForKnightTitleExist = Lib.Promotion.Helper.DoNeededSpecialBuildingUpgradeForKnightTitleExist;
    DoesNeededCityReputationForKnightTitleExist = Lib.Promotion.Helper.DoesNeededCityReputationForKnightTitleExist;
    DoNeededNumberOfFullDecoratedBuildingsForKnightTitleExist = Lib.Promotion.Helper.DoNeededNumberOfFullDecoratedBuildingsForKnightTitleExist;
    DoNeededNumberOfRichBuildingsForKnightTitleExist = Lib.Promotion.Helper.DoNeededNumberOfRichBuildingsForKnightTitleExist;
    DoNeededNumberOfGoodsForKnightTitleExist = Lib.Promotion.Helper.DoNeededNumberOfGoodsForKnightTitleExist;
    DoesNeededNumberOfSettlersForKnightTitleExist = Lib.Promotion.Helper.DoesNeededNumberOfSettlersForKnightTitleExist;
    CanKnightBePromoted = Lib.Promotion.Helper.CanKnightBePromoted;
    VictroryBecauseOfTitle = Lib.Promotion.Helper.VictroryBecauseOfTitle;
end

Lib.Promotion.Helper.DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Category == nil then
        return;
    end
    if _i then
        local EntityCategory = KnightTitleRequirements[_KnightTitle].Category[_i][1];
        local NeededAmount = KnightTitleRequirements[_KnightTitle].Category[_i][2];

        local ReachedAmount = 0;
        if EntityCategory == EntityCategories.Spouse then
            ReachedAmount = Logic.GetNumberOfSpouses(_PlayerID);
        else
            local Buildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategory)};
            for i=1, #Buildings do
                if Logic.IsBuilding(Buildings[i]) == 1 then
                    if Logic.IsConstructionComplete(Buildings[i]) == 1 then
                        ReachedAmount = ReachedAmount +1;
                    end
                else
                    ReachedAmount = ReachedAmount +1;
                end
            end
        end

        if ReachedAmount >= NeededAmount then
            return true, ReachedAmount, NeededAmount;
        end
        return false, ReachedAmount, NeededAmount;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Category do
            bool, reach, need = Lib.Promotion.Helper.DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

Lib.Promotion.Helper.DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Entities == nil then
        return;
    end
    if _i then
        local EntityType = KnightTitleRequirements[_KnightTitle].Entities[_i][1];
        local NeededAmount = KnightTitleRequirements[_KnightTitle].Entities[_i][2];
        local Buildings = GetPlayerEntities(_PlayerID, EntityType);

        local ReachedAmount = 0;
        for i=1, #Buildings do
            if Logic.IsBuilding(Buildings[i]) == 1 then
                if Logic.IsConstructionComplete(Buildings[i]) == 1 then
                    ReachedAmount = ReachedAmount +1;
                end
            else
                ReachedAmount = ReachedAmount +1;
            end
        end

        if ReachedAmount >= NeededAmount then
            return true, ReachedAmount, NeededAmount;
        end
        return false, ReachedAmount, NeededAmount;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Entities do
            bool, reach, need = Lib.Promotion.Helper.DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

Lib.Promotion.Helper.DoesNeededNumberOfGoodTypesForKnightTitleExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Goods == nil then
        return;
    end
    if _i then
        local GoodType = KnightTitleRequirements[_KnightTitle].Goods[_i][1];
        local NeededAmount = KnightTitleRequirements[_KnightTitle].Goods[_i][2];
        local ReachedAmount = GetPlayerGoodsInSettlement(GoodType, _PlayerID, true);

        if ReachedAmount >= NeededAmount then
            return true, ReachedAmount, NeededAmount;
        end
        return false, ReachedAmount, NeededAmount;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Goods do
            bool, reach, need = Lib.Promotion.Helper.DoesNeededNumberOfGoodTypesForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

Lib.Promotion.Helper.DoNeededNumberOfConsumedGoodsForKnightTitleExist = function( _PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Consume == nil then
        return;
    end
    if _i then
        CONST_CONSUMED_GOODS_COUNTER[_PlayerID] = CONST_CONSUMED_GOODS_COUNTER[_PlayerID] or {};

        local GoodType = KnightTitleRequirements[_KnightTitle].Consume[_i][1];
        local GoodAmount = CONST_CONSUMED_GOODS_COUNTER[_PlayerID][GoodType] or 0;
        local NeededGoodAmount = KnightTitleRequirements[_KnightTitle].Consume[_i][2];
        if GoodAmount >= NeededGoodAmount then
            return true, GoodAmount, NeededGoodAmount;
        else
            return false, GoodAmount, NeededGoodAmount;
        end
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Consume do
            bool, reach, need = Lib.Promotion.Helper.DoNeededNumberOfConsumedGoodsForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return false, reach, need
            end
        end
        return true, reach, need;
    end
end

Lib.Promotion.Helper.DoNumberOfProductsInCategoryExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Products == nil then
        return;
    end
    if _i then
        local GoodAmount = 0;
        local NeedAmount = KnightTitleRequirements[_KnightTitle].Products[_i][2];
        local GoodCategory = KnightTitleRequirements[_KnightTitle].Products[_i][1];
        local GoodsInCategory = {Logic.GetGoodTypesInGoodCategory(GoodCategory)};

        for i=1, #GoodsInCategory do
            GoodAmount = GoodAmount + GetPlayerGoodsInSettlement(GoodsInCategory[i], _PlayerID, true);
        end
        return (GoodAmount >= NeedAmount), GoodAmount, NeedAmount;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Products do
            bool, reach, need = Lib.Promotion.Helper.DoNumberOfProductsInCategoryExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

Lib.Promotion.Helper.DoNeededDiversityBuffForKnightTitleExist = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Buff == nil then
        return;
    end
    if _i then
        local buff = KnightTitleRequirements[_KnightTitle].Buff[_i];
        if Logic.GetBuff(_PlayerID,buff) and Logic.GetBuff(_PlayerID,buff) ~= 0 then
            return true;
        end
        return false;
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Buff do
            bool, reach, need = Lib.Promotion.Helper.DoNeededDiversityBuffForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

Lib.Promotion.Helper.DoCustomFunctionForKnightTitleSucceed = function(_PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].Custom == nil then
        return;
    end
    if _i then
        return KnightTitleRequirements[_KnightTitle].Custom[_i][1](_PlayerID, _KnightTitle, _i);
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].Custom do
            bool, reach, need = Lib.Promotion.Helper.DoCustomFunctionForKnightTitleSucceed(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

Lib.Promotion.Helper.DoNeededNumberOfDecoratedBuildingsForKnightTitleExist = function( _PlayerID, _KnightTitle, _i)
    if KnightTitleRequirements[_KnightTitle].DecoratedBuildings == nil then
        return
    end

    if _i then
        local CityBuildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding)}
        local DecorationGoodType = KnightTitleRequirements[_KnightTitle].DecoratedBuildings[_i][1]
        local NeededBuildingsWithDecoration = KnightTitleRequirements[_KnightTitle].DecoratedBuildings[_i][2]
        local BuildingsWithDecoration = 0

        for i=1, #CityBuildings do
            local BuildingID = CityBuildings[i]
            local GoodState = Logic.GetBuildingWealthGoodState(BuildingID, DecorationGoodType)
            if GoodState > 0 then
                BuildingsWithDecoration = BuildingsWithDecoration + 1
            end
        end

        if BuildingsWithDecoration >= NeededBuildingsWithDecoration then
            return true, BuildingsWithDecoration, NeededBuildingsWithDecoration
        else
            return false, BuildingsWithDecoration, NeededBuildingsWithDecoration
        end
    else
        local bool, reach, need;
        for i=1,#KnightTitleRequirements[_KnightTitle].DecoratedBuildings do
            bool, reach, need = Lib.Promotion.Helper.DoNeededNumberOfDecoratedBuildingsForKnightTitleExist(_PlayerID, _KnightTitle, i);
            if bool == false then
                return bool, reach, need
            end
        end
        return bool;
    end
end

Lib.Promotion.Helper.DoNeededSpecialBuildingUpgradeForKnightTitleExist = function( _PlayerID, _KnightTitle, _EntityCategory)
    local SpecialBuilding
    local SpecialBuildingName
    if _EntityCategory == EntityCategories.Headquarters then
        SpecialBuilding = Logic.GetHeadquarters(_PlayerID)
        SpecialBuildingName = "Headquarters"
    elseif _EntityCategory == EntityCategories.Storehouse then
        SpecialBuilding = Logic.GetStoreHouse(_PlayerID)
        SpecialBuildingName = "Storehouse"
    elseif _EntityCategory == EntityCategories.Cathedrals then
        SpecialBuilding = Logic.GetCathedral(_PlayerID)
        SpecialBuildingName = "Cathedrals"
    else
        return
    end
    if KnightTitleRequirements[_KnightTitle][SpecialBuildingName] == nil then
        return
    end
    local NeededUpgradeLevel = KnightTitleRequirements[_KnightTitle][SpecialBuildingName]
    if SpecialBuilding ~= nil then
        local SpecialBuildingUpgradeLevel = Logic.GetUpgradeLevel(SpecialBuilding)
        if SpecialBuildingUpgradeLevel >= NeededUpgradeLevel then
            return true, SpecialBuildingUpgradeLevel, NeededUpgradeLevel
        else
            return false, SpecialBuildingUpgradeLevel, NeededUpgradeLevel
        end
    else
        return false, 0, NeededUpgradeLevel
    end
end

Lib.Promotion.Helper.DoesNeededCityReputationForKnightTitleExist = function(_PlayerID, _KnightTitle)
    if KnightTitleRequirements[_KnightTitle].Reputation == nil then
        return;
    end
    local NeededAmount = KnightTitleRequirements[_KnightTitle].Reputation;
    if not NeededAmount then
        return;
    end
    local ReachedAmount = math.floor((Logic.GetCityReputation(_PlayerID) * 100) + 0.5);
    if ReachedAmount >= NeededAmount then
        return true, ReachedAmount, NeededAmount;
    end
    return false, ReachedAmount, NeededAmount;
end

Lib.Promotion.Helper.DoNeededNumberOfFullDecoratedBuildingsForKnightTitleExist = function( _PlayerID, _KnightTitle)
    if KnightTitleRequirements[_KnightTitle].FullDecoratedBuildings == nil then
        return
    end
    local CityBuildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding)}
    local NeededBuildingsWithDecoration = KnightTitleRequirements[_KnightTitle].FullDecoratedBuildings
    local BuildingsWithDecoration = 0

    for i=1, #CityBuildings do
        local BuildingID = CityBuildings[i]
        local AmountOfWealthGoodsAtBuilding = 0

        if Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Banner ) > 0 then
            AmountOfWealthGoodsAtBuilding = AmountOfWealthGoodsAtBuilding  + 1
        end
        if Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Sign  ) > 0 then
            AmountOfWealthGoodsAtBuilding = AmountOfWealthGoodsAtBuilding  + 1
        end
        if Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Candle) > 0 then
            AmountOfWealthGoodsAtBuilding = AmountOfWealthGoodsAtBuilding  + 1
        end
        if Logic.GetBuildingWealthGoodState(BuildingID, Goods.G_Ornament  ) > 0 then
            AmountOfWealthGoodsAtBuilding = AmountOfWealthGoodsAtBuilding  + 1
        end
        if AmountOfWealthGoodsAtBuilding >= 4 then
            BuildingsWithDecoration = BuildingsWithDecoration + 1
        end
    end

    if BuildingsWithDecoration >= NeededBuildingsWithDecoration then
        return true, BuildingsWithDecoration, NeededBuildingsWithDecoration
    else
        return false, BuildingsWithDecoration, NeededBuildingsWithDecoration
    end
end

Lib.Promotion.Helper.DoNeededNumberOfRichBuildingsForKnightTitleExist = function( _PlayerID, _KnightTitle)
    if KnightTitleRequirements[_KnightTitle].RichBuildings == nil then
        return
    end
    local NumberOfRichBuildings = Logic.GetNumberOfProsperBuildings(_PlayerID, 1)
    local NeededNumberOfRichBuildings = KnightTitleRequirements[_KnightTitle].RichBuildings

    if NeededNumberOfRichBuildings == -1 then
        NeededNumberOfRichBuildings = Logic.GetNumberOfPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding)
        NeededNumberOfRichBuildings = NeededNumberOfRichBuildings
            - Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.B_Barracks)
            - Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.B_BarracksArchers)
            - Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.B_SiegeEngineWorkshop)
    end

    if NumberOfRichBuildings >= NeededNumberOfRichBuildings then
        return true, NumberOfRichBuildings, NeededNumberOfRichBuildings
    else
        return false, NumberOfRichBuildings, NeededNumberOfRichBuildings
    end
end

Lib.Promotion.Helper.DoNeededNumberOfGoodsForKnightTitleExist = function( _PlayerID, _KnightTitle)
    if KnightTitleRequirements[_KnightTitle].Good == nil then
        return
    end
    local EntityCategory = KnightTitleRequirements[_KnightTitle].Good[1]
    local EntitiesInCategory = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategory)}
    local GoodAmount = 0

    for i = 1, #EntitiesInCategory do
        local EntityID = EntitiesInCategory[i]
        local EntityType = Logic.GetEntityType(EntityID)
        if  EntityType ~= Entities.B_TableBeer
        and EntityType ~= Entities.B_Marketslot
        and Logic.IsEntityTypeInCategory(EntityType, EntityCategories.Marketplace) == 0
        and Logic.IsKnight(EntityID) == false then
            local GoodAmountInEntity = Logic.GetAmountOnOutStockByIndex(EntityID,0)
            GoodAmount = GoodAmount + GoodAmountInEntity
        end
    end

    local NeededGoodAmount = KnightTitleRequirements[_KnightTitle].Good[2]
    if GoodAmount >= NeededGoodAmount then
        return true, GoodAmount, NeededGoodAmount
    else
        return false, GoodAmount, NeededGoodAmount
    end
end

Lib.Promotion.Helper.DoesNeededNumberOfSettlersForKnightTitleExist = function( _PlayerID, _KnightTitle)
    if KnightTitleRequirements[_KnightTitle].Settlers == nil then
        return
    end
    local NeededSettlers = KnightTitleRequirements[_KnightTitle].Settlers
    if NeededSettlers ~= nil then
        local Settlers = Logic.GetNumberOfEmployedWorkers(_PlayerID)
        if Settlers >= NeededSettlers then
            return true, Settlers, NeededSettlers
        else
            return false, Settlers, NeededSettlers
        end
    end
end

Lib.Promotion.Helper.CanKnightBePromoted = function(_PlayerID, _KnightTitle)
    if _KnightTitle == nil then
        _KnightTitle = Logic.GetKnightTitle(_PlayerID) + 1;
    end

    if Logic.CanStartFestival(_PlayerID, 1) == true then
        if  KnightTitleRequirements[_KnightTitle] ~= nil
        and DoesNeededNumberOfSettlersForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoNeededNumberOfGoodsForKnightTitleExist(_PlayerID, _KnightTitle)  ~= false
        and DoNeededSpecialBuildingUpgradeForKnightTitleExist(_PlayerID, _KnightTitle, EntityCategories.Headquarters) ~= false
        and DoNeededSpecialBuildingUpgradeForKnightTitleExist(_PlayerID, _KnightTitle, EntityCategories.Storehouse) ~= false
        and DoNeededSpecialBuildingUpgradeForKnightTitleExist(_PlayerID, _KnightTitle, EntityCategories.Cathedrals)  ~= false
        and DoNeededNumberOfRichBuildingsForKnightTitleExist(_PlayerID, _KnightTitle)  ~= false
        and DoNeededNumberOfFullDecoratedBuildingsForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoNeededNumberOfDecoratedBuildingsForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoesNeededCityReputationForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoesNeededNumberOfGoodTypesForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoNeededDiversityBuffForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoCustomFunctionForKnightTitleSucceed(_PlayerID, _KnightTitle) ~= false
        and DoNeededNumberOfConsumedGoodsForKnightTitleExist(_PlayerID, _KnightTitle) ~= false
        and DoNumberOfProductsInCategoryExist(_PlayerID, _KnightTitle) ~= false then
            return true;
        end
    end
    return false;
end

Lib.Promotion.Helper.VictroryBecauseOfTitle = function()
    QuestTemplate:TerminateEventsAndStuff();
    Victory(g_VictoryAndDefeatType.VictoryMissionComplete);
end

