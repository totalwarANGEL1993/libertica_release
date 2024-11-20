Lib.Require("comfort/IsLocalScript");
Lib.Register("module/trade/Trade_API");

function CreateGoodOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    _OfferType = (type(_OfferType) == "string" and Goods[_OfferType]) or _OfferType;
    local OfferID, TraderID = Lib.Trade.Global:GetOfferAndTrader(_VendorID, _OfferType);
    if OfferID ~= -1 and TraderID ~= -1 then
        local Msg = "Good offer for type %s already exists for player %d!";
        log(Msg,Logic.GetGoodTypeName(_OfferType),_VendorID);
        return;
    end

    local VendorStoreID = Logic.GetStoreHouse(_VendorID);
    AddGoodToTradeBlackList(_VendorID, _OfferType);

    -- Good cart type
    local MarketerType = Entities.U_Marketer;
    if _OfferType == Goods.G_Medicine then
        MarketerType = Entities.U_Medicus;
    end
    -- Refresh rate
    if _RefreshRate == nil then
        _RefreshRate = MerchantSystem.RefreshRates[_OfferType] or 0;
    end

    local LogicOfferID = Logic.AddGoodTraderOffer(
        VendorStoreID,
        _OfferAmount,
        Goods.G_Gold,
        0,
        _OfferType,
        MerchantSystem.Waggonload,
        1,
        _RefreshRate,
        MarketerType,
        Entities.U_ResourceMerchant
    );
    ExecuteLocal(
        "GameCallback_CloseNPCInteraction(GUI.GetPlayerID(), %d)",
        VendorStoreID
    );
    return LogicOfferID;
end
API.AddGoodOffer = CreateGoodOffer;

function CreateMercenaryOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    _OfferType = (type(_OfferType) == "string" and Entities[_OfferType]) or _OfferType;
    local OfferID, TraderID = Lib.Trade.Global:GetOfferAndTrader(_VendorID, _OfferType);
    if OfferID ~= -1 and TraderID ~= -1 then
        local Msg = "Mercenary offer for type %s already exists for player %d!";
        log(Msg,Logic.GetEntityTypeName(_OfferType),_VendorID);
        return;
    end

    local VendorStoreID = Logic.GetStoreHouse(_VendorID);

    -- Refresh rate
    if _RefreshRate == nil then
        _RefreshRate = MerchantSystem.RefreshRates[_OfferType] or 0;
    end
    -- Soldier count (Display hack for unusual mercenaries)
    local SoldierCount = 3;
    local TypeName = Logic.GetEntityTypeName(_OfferType);
    if string.find(TypeName, "MilitaryBow") or string.find(TypeName, "MilitarySword") then
        SoldierCount = 6;
    elseif string.find(TypeName,"Cart") then
        SoldierCount = 0;
    elseif string.find(TypeName,"Knight") then
        SoldierCount = 0;
    end

    local LogicOfferID = Logic.AddMercenaryTraderOffer(
        VendorStoreID,
        _OfferAmount,
        Goods.G_Gold,
        0,
        _OfferType,
        SoldierCount,
        1,
        _RefreshRate
    );
    ExecuteLocal(
        "GameCallback_CloseNPCInteraction(GUI.GetPlayerID(), %d)",
        VendorStoreID
    );
    return LogicOfferID;
end
API.AddMercenaryOffer = CreateMercenaryOffer;

function CreateEntertainerOffer(_VendorID, _OfferType)
    _OfferType = (type(_OfferType) == "string" and Entities[_OfferType]) or _OfferType;
    local OfferID, TraderID = Lib.Trade.Global:GetOfferAndTrader(_VendorID, _OfferType);
    if OfferID ~= -1 and TraderID ~= -1 then
        local Msg = "Entertainer offer for type %s already exists for player %d!";
        log(Msg,Logic.GetEntityTypeName(_OfferType),_VendorID);
        return;
    end

    local VendorStoreID = Logic.GetStoreHouse(_VendorID);
    local LogicOfferID = Logic.AddEntertainerTraderOffer(
        VendorStoreID,
        1,
        Goods.G_Gold,
        0,
        _OfferType,
        1,
        0
    );
    ExecuteLocal(
        "GameCallback_CloseNPCInteraction(GUI.GetPlayerID(), %d)",
        VendorStoreID
    );
    return LogicOfferID;
end
API.AddEntertainerOffer = CreateEntertainerOffer;

function PurchaseSetTraderAbilityForPlayer(_PlayerID, _Function)
    error(IsLocalScript(), "Can not be used in global script.");
    if _PlayerID then
        Lib.Trade.Local.PurchaseTraderAbility[_PlayerID] = _Function;
    else
        Lib.Trade.Local.PurchaseTraderAbility.Default = _Function;
    end
end
API.PurchaseSetTraderAbilityForPlayer = PurchaseSetTraderAbilityForPlayer;

function PurchaseSetDefaultTraderAbility(_Function)
    PurchaseSetTraderAbilityForPlayer(nil, _Function);
end
API.PurchaseSetDefaultTraderAbility = PurchaseSetDefaultTraderAbility;

function PurchaseSetBasePriceForPlayer(_PlayerID, _Function)
    error(IsLocalScript(), "Can not be used in global script.");
    if _PlayerID then
        Lib.Trade.Local.PurchaseBasePrice[_PlayerID] = _Function;
    else
        Lib.Trade.Local.PurchaseBasePrice.Default = _Function;
    end
end
API.PurchaseSetBasePriceForPlayer = PurchaseSetBasePriceForPlayer;

function PurchaseSetDefaultBasePrice(_Function)
    PurchaseSetBasePriceForPlayer(nil, _Function);
end
API.PurchaseSetDefaultBasePrice = PurchaseSetDefaultBasePrice;

function PurchaseSetInflationForPlayer(_PlayerID, _Function)
    error(IsLocalScript(), "Can not be used in global script.");
    if _PlayerID then
        Lib.Trade.Local.PurchaseInflation[_PlayerID] = _Function;
    else
        Lib.Trade.Local.PurchaseInflation.Default = _Function;
    end
end
API.PurchaseSetInflationForPlayer = PurchaseSetInflationForPlayer;

function PurchaseSetDefaultInflation(_Function)
    PurchaseSetInflationForPlayer(nil, _Function)
end
API.PurchaseSetDefaultInflation = PurchaseSetDefaultInflation;

function PurchaseSetConditionForPlayer(_PlayerID, _Function)
    error(IsLocalScript(), "Can not be used in global script.");
    if _PlayerID then
        Lib.Trade.Local.PurchaseAllowed[_PlayerID] = _Function;
    else
        Lib.Trade.Local.PurchaseAllowed.Default = _Function;
    end
end
API.PurchaseSetConditionForPlayer = PurchaseSetConditionForPlayer;

function PurchaseSetDefaultCondition(_Function)
    PurchaseSetConditionForPlayer(nil, _Function)
end
API.PurchaseSetDefaultCondition = PurchaseSetDefaultCondition;

function SaleSetTraderAbilityForPlayer(_PlayerID, _Function)
    error(IsLocalScript(), "Can not be used in global script.");
    if _PlayerID then
        Lib.Trade.Local.SaleTraderAbility[_PlayerID] = _Function;
    else
        Lib.Trade.Local.SaleTraderAbility.Default = _Function;
    end
end
API.SaleSetTraderAbilityForPlayer = SaleSetTraderAbilityForPlayer;

function SaleSetDefaultTraderAbility(_Function)
    SaleSetTraderAbilityForPlayer(nil, _Function);
end
API.SaleSetDefaultTraderAbility = SaleSetDefaultTraderAbility;

function SaleSetBasePriceForPlayer(_PlayerID, _Function)
    error(IsLocalScript(), "Can not be used in global script.");
    if _PlayerID then
        Lib.Trade.Local.SaleBasePrice[_PlayerID] = _Function;
    else
        Lib.Trade.Local.SaleBasePrice.Default = _Function;
    end
end
API.SaleSetBasePriceForPlayer = SaleSetBasePriceForPlayer;

function SaleSetDefaultBasePrice(_Function)
    SaleSetBasePriceForPlayer(nil, _Function);
end
API.SaleSetDefaultBasePrice = SaleSetDefaultBasePrice;

function SaleSetDeflationForPlayer(_PlayerID, _Function)
    error(IsLocalScript(), "Can not be used in global script.");
    if _PlayerID then
        Lib.Trade.Local.SaleDeflation[_PlayerID] = _Function;
    else
        Lib.Trade.Local.SaleDeflation.Default = _Function;
    end
end
API.SaleSetDeflationForPlayer = SaleSetDeflationForPlayer;

function SaleSetDefaultDeflation(_Function)
    SaleSetDeflationForPlayer(nil, _Function);
end
API.SaleSetDefaultDeflation = SaleSetDefaultDeflation;

function SaleSetConditionForPlayer(_PlayerID, _Function)
    error(IsLocalScript(), "Can not be used in global script.");
    if _PlayerID then
        Lib.Trade.Local.SaleAllowed[_PlayerID] = _Function;
    else
        Lib.Trade.Local.SaleAllowed.Default = _Function;
    end
end
API.SaleSetConditionForPlayer = SaleSetConditionForPlayer;

function SaleSetDefaultCondition(_Function)
    SaleSetConditionForPlayer(nil, _Function);
end
API.SaleSetDefaultCondition = SaleSetDefaultCondition;

function GetOfferInformation(_PlayerID)
    error(not IsLocalScript(), "Can not be used in local script.");
    return Lib.Trade.Global:GetStorehouseInformation(_PlayerID);
end
API.GetOfferInformation = GetOfferInformation;

function GetOfferCount(_PlayerID)
    error(not IsLocalScript(), "Can not be used in local script.");
    return Lib.Trade.Global:GetOfferCount(_PlayerID);
end
API.GetOfferCount = GetOfferCount;

function IsGoodOrUnitOffered(_PlayerID, _GoodOrEntityType)
    error(not IsLocalScript(), "Can not be used in local script.");
    local OfferID, TraderID = Lib.Trade.Global:GetOfferAndTrader(_PlayerID, _GoodOrEntityType);
    return OfferID ~= -1 and TraderID ~= -1;
end
API.IsGoodOrUnitOffered = IsGoodOrUnitOffered;

function GetTradeOfferWaggonAmount(_PlayerID, _GoodOrEntityType)
    error(not IsLocalScript(), "Can not be used in local script.");
    local Amount = -1;
    local OfferInfo = Lib.Trade.Global:GetStorehouseInformation(_PlayerID);
    for i= 1, #OfferInfo[1] do
        if OfferInfo[1][i][3] == _GoodOrEntityType and OfferInfo[1][i][5] > 0 then
            Amount = OfferInfo[1][i][5];
        end
    end
    return Amount;
end
API.GetTradeOfferWaggonAmount = GetTradeOfferWaggonAmount;

function RemoveTradeOffer(_PlayerID, _GoodOrEntityType)
    error(not IsLocalScript(), "Can not be used in local script.");
    return Lib.Trade.Global:RemoveTradeOffer(_PlayerID, _GoodOrEntityType);
end
API.RemoveTradeOffer = RemoveTradeOffer;

function ModifyTradeOffer(_PlayerID, _GoodOrEntityType, _NewAmount)
    error(not IsLocalScript(), "Can not be used in local script.");
    return Lib.Trade.Global:ModifyTradeOffer(_PlayerID, _GoodOrEntityType, _NewAmount);
end
API.ModifyTradeOffer = ModifyTradeOffer;

