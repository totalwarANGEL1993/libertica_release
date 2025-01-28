Lib.Trade = Lib.Trade or {};
Lib.Trade.Name = "Trade";
Lib.Trade.Global = {
    Data = {},
    PlayerOffersAmount = {};
};
Lib.Trade.Local = {
    Data = {},
    ShowKnightTraderAbility = true;

    PurchaseTraderAbility = {},
    PurchaseBasePrice     = {},
    PurchaseInflation     = {},
    PurchaseAllowed       = {},
    SaleTraderAbility     = {},
    SaleBasePrice         = {},
    SaleDeflation         = {},
    SaleAllowed           = {},
};
Lib.Trade.Shared = {};

TraderTypes = {
    GoodTrader        = 0,
    MercenaryTrader   = 1,
    EntertainerTrader = 2,
    Unknown           = 3,
};

Lib.Require("comfort/IsHistoryEdition");
Lib.Require("core/Core");
Lib.Require("module/trade/Trade_API");
Lib.Register("module/trade/Trade");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Trade.Global:Initialize()
    if not self.IsInstalled then
        Report.GoodsSold = CreateReport("Event_GoodsSold");
        Report.GoodsPurchased = CreateReport("Event_GoodsPurchased");

        Lib.Trade.Shared:OverwriteBasePricesAndRefreshRates();

        for PlayerID = 1, 8 do
            self.PlayerOffersAmount[PlayerID] = {};
        end

        self:OverwriteTradeFunctions();

        -- Garbage collection
        Lib.Trade.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Trade.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Trade.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.GoodsPurchased then
        SendReportToLocal(
            Report.GoodsPurchased,
            arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7]
        );
        self:PerformFakeTrade(arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7]);
    elseif _ID == Report.GoodsSold then
        SendReportToLocal(
            Report.GoodsSold,
            arg[1], arg[2], arg[3], arg[4], arg[5], arg[6]
        );
    end
end

function Lib.Trade.Global:PerformFakeTrade(_OfferID, _TraderType, _Good, _Amount, _Price, _P1, _P2)
    local StoreHouse1 = Logic.GetStoreHouse(_P1);
    local StoreHouse2 = Logic.GetStoreHouse(_P2);

    -- Perform transaction
    local Orientation = Logic.GetEntityOrientation(StoreHouse2) - 90;
    if _TraderType == 0 then
        if Logic.GetGoodCategoryForGoodType(_Good) ~= GoodCategories.GC_Animal then
            API.SendCart(StoreHouse2, _P1, _Good, _Amount, nil, false);
        else
            StartSimpleJobEx(function(_Time, _SHID, _Good, _PlayerID)
                if Logic.GetTime() > _Time+5 then
                    return true;
                end
                local x,y = Logic.GetBuildingApproachPosition(_SHID);
                local Type = (_Good ~= Goods.G_Cow and Entities.A_X_Sheep01) or Entities.A_X_Cow01;
                Logic.CreateEntityOnUnblockedLand(Type, x, y, 0, _PlayerID);
            end, Logic.GetTime(), StoreHouse2, _Good, _P1);
        end
    elseif _TraderType == 1 then
        local x,y = Logic.GetBuildingApproachPosition(StoreHouse2);
        local ID  = Logic.CreateBattalionOnUnblockedLand(_Good, x, y, Orientation, _P1);
        Logic.MoveSettler(ID, x, y, -1);
    else
        local x,y = Logic.GetBuildingApproachPosition(StoreHouse2);
        Logic.HireEntertainer(_Good, _P1, x, y);
    end
    API.SendCart(StoreHouse1, _P2, Goods.G_Gold, _Price, nil, false);
    AddGood(Goods.G_Gold, (-1) * _Price, _P1);

    -- Alter offer amount
    local NewAmount = 0;
    local OfferInfo = self:GetStorehouseInformation(_P2);
    for i= 1, #OfferInfo[1] do
        if OfferInfo[1][i][3] == _Good and OfferInfo[1][i][5] > 0 then
            NewAmount = OfferInfo[1][i][5] -1;
        end
    end
    self:ModifyTradeOffer(_P2, _Good, NewAmount);

    -- Update local
    ExecuteLocal(
        "GameCallback_MerchantInteraction(%d, %d, %d)",
        StoreHouse2,
        _P1,
        _OfferID
    );
end

function Lib.Trade.Global:GetStorehouseInformation(_PlayerID)
    local BuildingID = Logic.GetStoreHouse(_PlayerID);

    local StorehouseData = {
        Player      = _PlayerID,
        Storehouse  = BuildingID,
        OfferCount  = 0,
        {},
    };

    local NumberOfMerchants = Logic.GetNumberOfMerchants(Logic.GetStoreHouse(_PlayerID));
    local AmountOfOffers = 0;

    if BuildingID ~= 0 then
        for Index = 0, NumberOfMerchants, 1 do
            local Offers = {Logic.GetMerchantOfferIDs(BuildingID, Index, _PlayerID)};
            for i= 1, #Offers, 1 do
                local type, goodAmount, offerAmount, prices = 0, 0, 0, 0;
                if Logic.IsGoodTrader(BuildingID, Index) then
                    type, goodAmount, offerAmount, prices = Logic.GetGoodTraderOffer(BuildingID, Offers[i], _PlayerID);
                    if type == Goods.G_Sheep or type == Goods.G_Cow then
                        goodAmount = 5;
                    end
                elseif Logic.IsMercenaryTrader(BuildingID, Index) then
                    type, goodAmount, offerAmount, prices = Logic.GetMercenaryOffer(BuildingID, Offers[i], _PlayerID);
                elseif Logic.IsEntertainerTrader(BuildingID, Index) then
                    type, goodAmount, offerAmount, prices = Logic.GetEntertainerTraderOffer(BuildingID, Offers[i], _PlayerID);
                end

                AmountOfOffers = AmountOfOffers +1;
                local OfferData = {Index, Offers[i], type, goodAmount, offerAmount, prices};
                table.insert(StorehouseData[1], OfferData);
            end
        end
    end

    StorehouseData.OfferCount = AmountOfOffers;
    return StorehouseData;
end

function Lib.Trade.Global:GetOfferCount(_PlayerID)
    local Offers = self:GetStorehouseInformation(_PlayerID);
    if Offers then
        return Offers.OfferCount;
    end
    return 0;
end

function Lib.Trade.Global:GetOfferAndTrader(_PlayerID, _GoodOrEntityType)
    local Info = self:GetStorehouseInformation(_PlayerID);
    if Info then
        for j=1, #Info[1], 1 do
            if Info[1][j][3] == _GoodOrEntityType then
                return Info[1][j][2], Info[1][j][1], Info.Storehouse;
            end
        end
    end
    return -1, -1, -1;
end

function Lib.Trade.Global:GetTraderType(_BuildingID, _TraderID)
    if Logic.IsGoodTrader(_BuildingID, _TraderID) == true then
        return TraderTypes.GoodTrader;
    elseif Logic.IsMercenaryTrader(_BuildingID, _TraderID) == true then
        return TraderTypes.MercenaryTrader;
    elseif Logic.IsEntertainerTrader(_BuildingID, _TraderID) == true then
        return TraderTypes.EntertainerTrader;
    else
        return TraderTypes.Unknown;
    end
end

function Lib.Trade.Global:RemoveTradeOffer(_PlayerID, _GoodOrEntityType)
    local OfferID, TraderID, BuildingID = self:GetOfferAndTrader(_PlayerID, _GoodOrEntityType);
    if not IsExisting(BuildingID) then
        return;
    end
    -- Trader IDs are mixed up in Logic.RemoveOffer
    local MappedTraderID = (TraderID == 1 and 2) or (TraderID == 2 and 1) or 0;
    Logic.RemoveOffer(BuildingID, MappedTraderID, OfferID);
end

function Lib.Trade.Global:RemoveTradeOfferByData(_Data, _Index)
    local OfferID = _Data[1][_Index][2];
    local TraderID = _Data[1][_Index][1];
    local BuildingID = _Data.Storehouse;
    if not IsExisting(BuildingID) then
        return;
    end
    -- Trader IDs are mixed up in Logic.RemoveOffer
    local MappedTraderID = (TraderID == 1 and 2) or (TraderID == 2 and 1) or 0;
    Logic.RemoveOffer(BuildingID, MappedTraderID, OfferID);
end

function Lib.Trade.Global:ModifyTradeOffer(_PlayerID, _GoodOrEntityType, _NewAmount)
    local OfferID, TraderID, BuildingID = self:GetOfferAndTrader(_PlayerID, _GoodOrEntityType);
    if not IsExisting(BuildingID) then
        return;
    end

    -- Amount == -1 or amount == nil means maximum
    if _NewAmount == nil or _NewAmount == -1 then
        _NewAmount = self.PlayerOffersAmount[_PlayerID][_GoodOrEntityType];
    end
    -- Values greater than the maximum will not respawn!
    if  self.PlayerOffersAmount[_PlayerID][_GoodOrEntityType] 
    and self.PlayerOffersAmount[_PlayerID][_GoodOrEntityType] < _NewAmount then
        _NewAmount = self.PlayerOffersAmount[_PlayerID][_GoodOrEntityType];
    end
    Logic.ModifyTraderOffer(BuildingID, OfferID, _NewAmount, TraderID);
end

function Lib.Trade.Global:OverwriteTradeFunctions()
    AddOffer = function(_Merchant, _NumberOfOffers, _GoodType, _RefreshRate)
        local VendorID = Logic.EntityGetPlayer(GetID(_Merchant));
        return CreateGoodOffer(VendorID, _GoodType, _NumberOfOffers, _RefreshRate);
    end

    AddMercenaryOffer = function(_Mercenary, _Amount, _Type, _RefreshRate)
        local VendorID = Logic.EntityGetPlayer(GetID(_Mercenary));
        return CreateMercenaryOffer(VendorID, _Type, _Amount, _RefreshRate);
    end

    AddEntertainerOffer = function(_Merchant, _EntertainerType)
        local VendorID = Logic.EntityGetPlayer(GetID(_Merchant));
        return CreateEntertainerOffer(VendorID, _EntertainerType);
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Trade.Local:Initialize()
    if not self.IsInstalled then
        Report.GoodsSold = CreateReport("Event_GoodsSold");
        Report.GoodsPurchased = CreateReport("Event_GoodsPurchased");

        Lib.Trade.Shared:OverwriteBasePricesAndRefreshRates();

        g_Merchant.BuyFromPlayer = {};

        if IsHistoryEdition() and Framework.IsNetworkGame() then
            return;
        end
        self:OverrideMerchantComputePurchasePrice();
        self:OverrideMerchantComputeSellingPrice();
        self:OverrideMerchantSellGoodsClicked();
        self:OverrideMerchantPurchaseOfferUpdate();
        self:OverrideMerchantPurchaseOfferClicked();

        -- Garbage collection
        Lib.Trade.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Trade.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.Trade.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.Trade.Local:GetTraderType(_BuildingID, _TraderID)
    if Logic.IsGoodTrader(_BuildingID, _TraderID) == true then
        return TraderTypes.GoodTrader;
    elseif Logic.IsMercenaryTrader(_BuildingID, _TraderID) == true then
        return TraderTypes.MercenaryTrader;
    elseif Logic.IsEntertainerTrader(_BuildingID, _TraderID) == true then
        return TraderTypes.EntertainerTrader;
    else
        return TraderTypes.Unknown;
    end
end

function Lib.Trade.Local:OverrideMerchantPurchaseOfferUpdate()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Merchant.OfferUpdate = function(_ButtonIndex)
        local CurrentWidgetID   = XGUIEng.GetCurrentWidgetID();
        local CurrentWidgetMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID);
        local PlayerID          = GUI.GetPlayerID();
        local BuildingID        = g_Merchant.ActiveMerchantBuilding;
        if BuildingID == 0
        or Logic.IsEntityDestroyed(BuildingID) == true then
            return;
        end
        if g_Merchant.Offers[_ButtonIndex] == nil then
            XGUIEng.ShowWidget(CurrentWidgetMotherID,0);
            return;
        else
            XGUIEng.ShowWidget(CurrentWidgetMotherID,1);
        end
        local TraderType = g_Merchant.Offers[_ButtonIndex].TraderType;
        local OfferIndex = g_Merchant.Offers[_ButtonIndex].OfferIndex;
        local GoodType, OfferGoodAmount, OfferAmount, AmountPrices = 0,0,0,0;
        if TraderType == g_Merchant.GoodTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetGoodTraderOffer(BuildingID,OfferIndex,PlayerID);
            if GoodType == Goods.G_Sheep
            or GoodType == Goods.G_Cow then
                OfferGoodAmount = 5;
            end
            SetIcon(CurrentWidgetID, g_TexturePositions.Goods[GoodType]);
        elseif TraderType == g_Merchant.MercenaryTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetMercenaryOffer(BuildingID,OfferIndex,PlayerID);
            local TypeName = Logic.GetEntityTypeName(GoodType);
            if GoodType == Entities.U_Thief then
                OfferGoodAmount = 1;
            elseif string.find(TypeName, "U_MilitarySword")
            or     string.find(TypeName, "U_MilitaryBow") then
                OfferGoodAmount = 6;
            elseif string.find(TypeName, "Cart") then
                OfferGoodAmount = 1;
            else
                OfferGoodAmount = OfferGoodAmount;
            end
            SetIcon(CurrentWidgetID, g_TexturePositions.Entities[GoodType]);
        elseif TraderType == g_Merchant.EntertainerTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetEntertainerTraderOffer(BuildingID,OfferIndex,PlayerID);
            if not (Logic.CanHireEntertainer(PlayerID) == true
            and Logic.EntertainerIsOnTheMap(GoodType) == false) then
                OfferAmount = 0;
            end
            SetIcon(CurrentWidgetID, g_TexturePositions.Entities[GoodType]);
        end

        local OfferAmountWidget = XGUIEng.GetWidgetPathByID(CurrentWidgetMotherID) .. "/OfferAmount";
        XGUIEng.SetText(OfferAmountWidget, "{center}" .. OfferAmount);
        local OfferGoodAmountWidget = XGUIEng.GetWidgetPathByID(CurrentWidgetMotherID) .. "/OfferGoodAmount";
        XGUIEng.SetText(OfferGoodAmountWidget, "{center}" .. OfferGoodAmount);

        if OfferAmount == 0 then
            XGUIEng.DisableButton(CurrentWidgetID,1);
        else
            XGUIEng.DisableButton(CurrentWidgetID,0);
        end
    end
end

function Lib.Trade.Local:OverrideMerchantPurchaseOfferClicked()
    -- Set special conditions
    local PurchaseAllowedLambda = function(_Type, _Good, _Amount, _Price, _P1, _P2)
        return true;
    end
    self.PurchaseAllowed.Default = PurchaseAllowedLambda;

    local BuyLock = {Locked = false};

    GameCallback_MerchantInteraction = function(_BuildingID, _PlayerID, _OfferID)
        if _PlayerID == GUI.GetPlayerID() then
            BuyLock.Locked = false;
        end
    end

    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Merchant.OfferClicked = function(_ButtonIndex)
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local PlayerID   = GUI.GetPlayerID();
        local BuildingID = g_Merchant.ActiveMerchantBuilding;
        if BuildingID == 0 or BuyLock.Locked then
            return;
        end
        local PlayersMarketPlaceID  = Logic.GetMarketplace(PlayerID);
        local TraderPlayerID        = Logic.EntityGetPlayer(BuildingID);
        local TraderType            = g_Merchant.Offers[_ButtonIndex].TraderType;
        local OfferIndex            = g_Merchant.Offers[_ButtonIndex].OfferIndex;

        local CanBeBought = true;
        local GoodType, OfferGoodAmount, OfferAmount, AmountPrices = 0,0,0,0;
        if TraderType == g_Merchant.GoodTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetGoodTraderOffer(BuildingID, OfferIndex, PlayerID);
            if Logic.GetGoodCategoryForGoodType(GoodType) == GoodCategories.GC_Resource then
                if Logic.GetPlayerUnreservedStorehouseSpace(PlayerID) < OfferGoodAmount then
                    CanBeBought = false;
                    local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_MerchantStorehouseSpace");
                    Message(MessageText);
                end
            elseif Logic.GetGoodCategoryForGoodType(GoodType) == GoodCategories.GC_Animal then
                CanBeBought = true;
            else
                if Logic.CanFitAnotherMerchantOnMarketplace(PlayersMarketPlaceID) == false then
                    CanBeBought = false;
                    local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_MerchantMarketplaceFull");
                    Message(MessageText);
                end
            end
        elseif TraderType == g_Merchant.EntertainerTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetEntertainerTraderOffer(BuildingID, OfferIndex, BuildingID);
            if Logic.CanFitAnotherEntertainerOnMarketplace(PlayersMarketPlaceID) == false then
                CanBeBought = false;
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_MerchantMarketplaceFull");
                Message(MessageText);
            end
        elseif TraderType == g_Merchant.MercenaryTrader then
            GoodType, OfferGoodAmount, OfferAmount, AmountPrices = Logic.GetMercenaryOffer(BuildingID, OfferIndex, PlayerID);
            local GoodTypeName        = Logic.GetEntityTypeName(GoodType);
            local CurrentSoldierCount = Logic.GetCurrentSoldierCount(PlayerID);
            local CurrentSoldierLimit = Logic.GetCurrentSoldierLimit(PlayerID);
            local SoldierSize;
            if GoodType == Entities.U_Thief then
                SoldierSize = 1;
            elseif string.find(GoodTypeName, "U_MilitarySword")
            or     string.find(GoodTypeName, "U_MilitaryBow") then
                SoldierSize = 6;
            elseif string.find(GoodTypeName, "Cart") then
                SoldierSize = 0;
            else
                SoldierSize = OfferGoodAmount;
            end
            if (CurrentSoldierCount + SoldierSize) > CurrentSoldierLimit then
                CanBeBought = false;
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_SoldierLimitReached");
                Message(MessageText);
            end
        end

        -- Special sales conditions
        if CanBeBought then
            if Lib.Trade.Local.PurchaseAllowed[TraderPlayerID] then
                CanBeBought = Lib.Trade.Local.PurchaseAllowed[TraderPlayerID](TraderType, GoodType, OfferGoodAmount, PlayerID, TraderPlayerID);
            else
                CanBeBought = Lib.Trade.Local.PurchaseAllowed.Default(TraderType, GoodType, OfferGoodAmount, PlayerID, TraderPlayerID);
            end
            if not CanBeBought then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericNotReadyYet");
                Message(MessageText);
                return;
            end
        end

        if CanBeBought == true then
            local Price = ComputePrice( BuildingID, OfferIndex, PlayerID, TraderType);
            local GoldAmountInCastle = GetPlayerGoodsInSettlement(Goods.G_Gold, PlayerID);
            local PlayerSectorType = PlayerSectorTypes.Civil;
            local IsReachable = CanEntityReachTarget(PlayerID, Logic.GetStoreHouse(TraderPlayerID), Logic.GetStoreHouse(PlayerID), nil, PlayerSectorType);
            if IsReachable == false then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericUnreachable");
                Message(MessageText);
                return;
            end
            if Price <= GoldAmountInCastle then
                BuyLock.Locked = true;
                GUI.ChangeMerchantOffer(BuildingID, PlayerID, OfferIndex, Price);
                Sound.FXPlay2DSound("ui\\menu_click");
                if Lib.Trade.Local.ShowKnightTraderAbility then
                    StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightTrading);
                end

                -- Manually log in local state
                g_Merchant.BuyFromPlayer[TraderPlayerID] = g_Merchant.BuyFromPlayer[TraderPlayerID] or {};
                g_Merchant.BuyFromPlayer[TraderPlayerID][GoodType] = (g_Merchant.BuyFromPlayer[TraderPlayerID][GoodType] or 0) +1;

                SendReportToGlobal(
                    Report.GoodsPurchased,
                    OfferIndex,
                    TraderType,
                    GoodType,
                    OfferGoodAmount,
                    Price,
                    PlayerID,
                    TraderPlayerID
                );
            else
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_G_Gold");
                Message(MessageText);
            end
        end
    end
end

function Lib.Trade.Local:OverrideMerchantSellGoodsClicked()
    -- Set special conditions
    local SaleAllowedLambda = function(_Type, _Good, _Amount, _Price, _P1, _P2)
        return true;
    end
    self.SaleAllowed.Default = SaleAllowedLambda;

    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Trade.SellClicked = function()
        Sound.FXPlay2DSound( "ui\\menu_click");
        if g_Trade.GoodAmount == 0 then
            return;
        end
        local PlayerID = GUI.GetPlayerID();
        local ButtonIndex = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID())));
        local TargetID = g_Trade.TargetPlayers[ButtonIndex];
        local PlayerSectorType = PlayerSectorTypes.Civil;
        if g_Trade.GoodType == Goods.G_Gold then
            PlayerSectorType = PlayerSectorTypes.Thief;
        end
        local IsReachable = CanEntityReachTarget(TargetID, Logic.GetStoreHouse(PlayerID), Logic.GetStoreHouse(TargetID), nil, PlayerSectorType);
        if IsReachable == false then
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericUnreachable");
            Message(MessageText);
            return;
        end
        if g_Trade.GoodType == Goods.G_Gold then
            -- FIXME: check for treasury space in castle?
        elseif Logic.GetGoodCategoryForGoodType(g_Trade.GoodType) == GoodCategories.GC_Resource then
            local SpaceForNewGoods = Logic.GetPlayerUnreservedStorehouseSpace(TargetID);
            if SpaceForNewGoods < g_Trade.GoodAmount then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TargetFactionStorehouseSpace");
                Message(MessageText);
                return;
            end
        else
            if Logic.GetNumberOfTradeGatherers(PlayerID) >= 1 then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TradeGathererUnderway");
                Message(MessageText);
                return;
            end
            if Logic.CanFitAnotherMerchantOnMarketplace(Logic.GetMarketplace(TargetID)) == false then
                local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_TargetFactionMarketplaceFull");
                Message(MessageText);
                return;
            end
        end

        -- Special sales conditions
        local CanBeSold = true;
        if Lib.Trade.Local.SaleAllowed[TargetID] then
            CanBeSold = Lib.Trade.Local.SaleAllowed[TargetID](g_Merchant.GoodTrader, g_Trade.GoodType, g_Trade.GoodAmount, PlayerID, TargetID);
        else
            CanBeSold = Lib.Trade.Local.SaleAllowed.Default(g_Merchant.GoodTrader, g_Trade.GoodType, g_Trade.GoodAmount, PlayerID, TargetID);
        end
        if not CanBeSold then
            local MessageText = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_GenericNotReadyYet");
            Message(MessageText);
            return;
        end

        local Price;
        local PricePerUnit;
        if Logic.PlayerGetIsHumanFlag(TargetID) then
            Price = 0;
            PricePerUnit = 0;
        else
            Price = GUI_Trade.ComputeSellingPrice(TargetID, g_Trade.GoodType, g_Trade.GoodAmount);
            PricePerUnit = Price / g_Trade.GoodAmount;
        end

        GUI.StartTradeGoodGathering(PlayerID, TargetID, g_Trade.GoodType, g_Trade.GoodAmount, PricePerUnit);
        GUI_FeedbackSpeech.Add("SpeechOnly_CartsSent", g_FeedbackSpeech.Categories.CartsUnderway, nil, nil);
        StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightTrading);

        if PricePerUnit ~= 0 then
            if g_Trade.SellToPlayers[TargetID] == nil then
                g_Trade.SellToPlayers[TargetID] = {};
            end
            if g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] == nil then
                g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] = g_Trade.GoodAmount;
            else
                g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] = g_Trade.SellToPlayers[TargetID][g_Trade.GoodType] + g_Trade.GoodAmount;
            end
            SendReportToGlobal(
                Report.GoodsSold,
                g_Merchant.GoodTrader,
                g_Trade.GoodType,
                g_Trade.GoodAmount,
                Price,
                PlayerID,
                TargetID
            );
        end
    end
end

function Lib.Trade.Local:OverrideMerchantComputePurchasePrice()
    -- Override factor of hero ability
    local AbilityTraderLambda = function(_TraderType, _OfferType, _BasePrice, _PlayerID, _TraderPlayerID)
        local Modifier = Logic.GetKnightTraderAbilityModifier(_PlayerID);
        return math.ceil(_BasePrice / Modifier);
    end
    self.PurchaseTraderAbility.Default = AbilityTraderLambda;

    -- Override base price calculation
    local BasePriceLambda = function(_TraderType, _OfferType, _PlayerID, _TraderPlayerID)
        local BasePrice = MerchantSystem.BasePrices[_OfferType];
        return (BasePrice == nil and 3) or BasePrice;
    end
    self.PurchaseBasePrice.Default = BasePriceLambda;

    -- Override max inflation
    local InflationLambda = function(_TraderType, _GoodType, _OfferCount, _Price, _PlayerID, _TraderPlayerID)
        _OfferCount = (_OfferCount > 8 and 8) or _OfferCount;
        local Result = _Price + (math.ceil(_Price / 4) * _OfferCount);
        return (Result < _Price and _Price) or Result;
    end
    self.PurchaseInflation.Default = InflationLambda;

    -- Override function
    ComputePrice = function(BuildingID, OfferID, PlayerID, TraderType)
        local TraderPlayerID = Logic.EntityGetPlayer(BuildingID);
        local Type = Logic.GetGoodOfOffer(BuildingID, OfferID, PlayerID, TraderType);

        -- Calculate the base price
        local BasePrice;
        if Lib.Trade.Local.PurchaseBasePrice[TraderPlayerID] then
            BasePrice = Lib.Trade.Local.PurchaseBasePrice[TraderPlayerID](TraderType, Type, PlayerID, TraderPlayerID)
        else
            BasePrice = Lib.Trade.Local.PurchaseBasePrice.Default(TraderType, Type, PlayerID, TraderPlayerID)
        end

        -- Calculate price
        local Price
        if Lib.Trade.Local.PurchaseTraderAbility[TraderPlayerID] then
            Price = Lib.Trade.Local.PurchaseTraderAbility[TraderPlayerID](TraderType, Type, BasePrice, PlayerID, TraderPlayerID)
        else
            Price = Lib.Trade.Local.PurchaseTraderAbility.Default(TraderType, Type, BasePrice, PlayerID, TraderPlayerID)
        end

        -- Invoke price inflation
        local OfferCount = 0;
        if g_Merchant.BuyFromPlayer[TraderPlayerID] and g_Merchant.BuyFromPlayer[TraderPlayerID][Type] then
            OfferCount = g_Merchant.BuyFromPlayer[TraderPlayerID][Type];
        end
        local FinalPrice;
        if Lib.Trade.Local.PurchaseInflation[TraderPlayerID] then
            FinalPrice = Lib.Trade.Local.PurchaseInflation[TraderPlayerID](TraderType, Type, OfferCount, Price, PlayerID, TraderPlayerID);
        else
            FinalPrice = Lib.Trade.Local.PurchaseInflation.Default(TraderType, Type, OfferCount, Price, PlayerID, TraderPlayerID);
        end
        return FinalPrice;
    end
end

function Lib.Trade.Local:OverrideMerchantComputeSellingPrice()
    -- Override factor of hero ability
    local AbilityTraderLambda = function(_TraderType, _OfferType, _BasePrice, _PlayerID, _TraderPlayerID)
        -- No change by default
        return _BasePrice;
    end
    self.SaleTraderAbility.Default = AbilityTraderLambda;

    -- Override base price calculation
    local BasePriceLambda = function(_TraderType, _OfferType, _PlayerID, _TargetPlayerID)
        local BasePrice = MerchantSystem.BasePrices[_OfferType];
        return (BasePrice == nil and 3) or BasePrice;
    end
    self.SaleBasePrice.Default = BasePriceLambda;

    -- Override max deflation
    local DeflationLambda = function(_TraderType, _OfferType, _WagonsSold, _Price, _PlayerID, _TargetPlayerID)
        return _Price - math.ceil(_Price / 4);
    end
    self.SaleDeflation.Default = DeflationLambda;

    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Trade.ComputeSellingPrice = function(_TargetPlayerID, _GoodType, _GoodAmount)
        if _GoodType == Goods.G_Gold then
            return 0;
        end
        local PlayerID = GUI.GetPlayerID();
        local Waggonload = MerchantSystem.Waggonload;

        -- Calculate the base price
        local BasePrice;
        if Lib.Trade.Local.SaleBasePrice[_TargetPlayerID] then
            BasePrice = Lib.Trade.Local.SaleBasePrice[_TargetPlayerID](g_Merchant.GoodTrader, _GoodType, PlayerID, _TargetPlayerID);
        else
            BasePrice = Lib.Trade.Local.SaleBasePrice.Default(g_Merchant.GoodTrader, _GoodType, PlayerID, _TargetPlayerID);
        end

        -- Calculate price
        local Price = BasePrice;
        if Lib.Trade.Local.SaleTraderAbility[_TargetPlayerID] then
            Price = Lib.Trade.Local.SaleTraderAbility[_TargetPlayerID](g_Merchant.GoodTrader, _GoodType, BasePrice, PlayerID, _TargetPlayerID)
        else
            Price = Lib.Trade.Local.SaleTraderAbility.Default(g_Merchant.GoodTrader, _GoodType, BasePrice, PlayerID, _TargetPlayerID)
        end

        local GoodsSoldToTargetPlayer = 0
        if  g_Trade.SellToPlayers[_TargetPlayerID] ~= nil
        and g_Trade.SellToPlayers[_TargetPlayerID][_GoodType] ~= nil then
            GoodsSoldToTargetPlayer = g_Trade.SellToPlayers[_TargetPlayerID][_GoodType];
        end
        local Modifier = math.ceil(Price / 4);
        local WaggonsToSell = math.ceil(_GoodAmount / Waggonload);
        local WaggonsSold = math.ceil(GoodsSoldToTargetPlayer / Waggonload);

        -- Calculate the max deflation
        local MaxToSubstract
        if Lib.Trade.Local.SaleDeflation[_TargetPlayerID] then
            MaxToSubstract = Lib.Trade.Local.SaleDeflation[_TargetPlayerID](g_Merchant.GoodTrader, _GoodType, WaggonsSold, Price, PlayerID, _TargetPlayerID);
        else
            MaxToSubstract = Lib.Trade.Local.SaleDeflation.Default(g_Merchant.GoodTrader, _GoodType, WaggonsSold, Price, PlayerID, _TargetPlayerID);
        end

        local PriceToSubtract = 0;
        for i = 1, WaggonsToSell do
            PriceToSubtract = PriceToSubtract + math.min(WaggonsSold * Modifier, MaxToSubstract);
            WaggonsSold = WaggonsSold + 1;
        end

        return (WaggonsToSell * BasePrice) - PriceToSubtract;
    end
end

-- -------------------------------------------------------------------------- --
-- Shared

function Lib.Trade.Shared:OverwriteBasePricesAndRefreshRates()
    MerchantSystem.BasePrices[Entities.U_CatapultCart] = MerchantSystem.BasePrices[Entities.U_CatapultCart] or 1000;
    MerchantSystem.BasePrices[Entities.U_BatteringRamCart] = MerchantSystem.BasePrices[Entities.U_BatteringRamCart] or 450;
    MerchantSystem.BasePrices[Entities.U_SiegeTowerCart] = MerchantSystem.BasePrices[Entities.U_SiegeTowerCart] or 600;
    MerchantSystem.BasePrices[Entities.U_AmmunitionCart] = MerchantSystem.BasePrices[Entities.U_AmmunitionCart] or 150;
    MerchantSystem.BasePrices[Entities.U_MilitarySword_RedPrince] = MerchantSystem.BasePrices[Entities.U_MilitarySword_RedPrince] or 200;
    MerchantSystem.BasePrices[Entities.U_MilitarySword] = MerchantSystem.BasePrices[Entities.U_MilitarySword] or 200;
    MerchantSystem.BasePrices[Entities.U_MilitaryBow_RedPrince] = MerchantSystem.BasePrices[Entities.U_MilitaryBow_RedPrince] or 350;
    MerchantSystem.BasePrices[Entities.U_MilitaryBow] = MerchantSystem.BasePrices[Entities.U_MilitaryBow] or 350;

    MerchantSystem.RefreshRates[Entities.U_CatapultCart] = MerchantSystem.RefreshRates[Entities.U_CatapultCart] or 270;
    MerchantSystem.RefreshRates[Entities.U_BatteringRamCart] = MerchantSystem.RefreshRates[Entities.U_BatteringRamCart] or 190;
    MerchantSystem.RefreshRates[Entities.U_SiegeTowerCart] = MerchantSystem.RefreshRates[Entities.U_SiegeTowerCart] or 220;
    MerchantSystem.RefreshRates[Entities.U_AmmunitionCart] = MerchantSystem.RefreshRates[Entities.U_AmmunitionCart] or 150;
    MerchantSystem.RefreshRates[Entities.U_MilitaryBow_RedPrince] = MerchantSystem.RefreshRates[Entities.U_MilitarySword_RedPrince] or 150;
    MerchantSystem.RefreshRates[Entities.U_MilitarySword] = MerchantSystem.RefreshRates[Entities.U_MilitarySword] or 150;
    MerchantSystem.RefreshRates[Entities.U_MilitaryBow_RedPrince] = MerchantSystem.RefreshRates[Entities.U_MilitaryBow_RedPrince] or 150;
    MerchantSystem.RefreshRates[Entities.U_MilitaryBow] = MerchantSystem.RefreshRates[Entities.U_MilitaryBow] or 150;

    if g_GameExtraNo >= 1 then
        MerchantSystem.BasePrices[Entities.U_MilitaryBow_Khana] = MerchantSystem.BasePrices[Entities.U_MilitaryBow_Khana] or 350;
        MerchantSystem.BasePrices[Entities.U_MilitarySword_Khana] = MerchantSystem.BasePrices[Entities.U_MilitarySword_Khana] or 200;

        MerchantSystem.RefreshRates[Entities.U_MilitaryBow_Khana] = MerchantSystem.RefreshRates[Entities.U_MilitaryBow_Khana] or 150;
        MerchantSystem.RefreshRates[Entities.U_MilitaryBow_Khana] = MerchantSystem.RefreshRates[Entities.U_MilitarySword_Khana] or 150;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Trade.Name);

