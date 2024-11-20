Lib.Warehouse = Lib.Warehouse or {};
Lib.Warehouse.Name = "Warehouse";
Lib.Warehouse.CinematicEvents = {};
Lib.Warehouse.Global = {
    OfferSequence = 0,
    Warehouses = {Job = 0},
    Inflation = {
        Players = {},
        Inc = 0.12,
        Min = 0.50,
        Max = 1.75,
    },
};
Lib.Warehouse.Local = {
    Warehouses = {},
    Inflation = {
        Players = {},
        Inc = 0.12,
        Min = 0.50,
        Max = 1.75,
    },
};
Lib.Warehouse.Text = {
    OfferTitle = {
        {de = "Keine Angebote", en = "No Offers",},
        {de = "%d %s kaufen%s", en = "Purchase %d %s%s",},
        {de = "%s anheuern", en = "Hire %s",},
        {de = "%s anheuern%s", en = "Hire %s%s",},
        {de = "%s kaufen%s", en = "Purchase %s%s",},
    },
};

WarehouseOfferType = {
    Entertainer = 1,
    Mercenary = 2,
    Lifestock = 3,
    HeavyWeapon = 4,
};

Lib.Require("comfort/GetSiegeengineTypeByCartType");
Lib.Require("comfort/GetBattalionSizeBySoldierType");
Lib.Require("comfort/IsMultiplayer");
Lib.Require("comfort/KeyOf");
Lib.Require("comfort/ReplaceEntity");
Lib.Require("comfort/SendCart");
Lib.Require("core/Core");
Lib.Require("module/ui/UITools");
Lib.Require("module/io/IO");
Lib.Require("module/ui/UIBuilding");
Lib.Require("module/trade/Warehouse_API");
Lib.Require("module/trade/Warehouse_Behavior");
Lib.Register("module/trade/Warehouse");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Warehouse.Global:Initialize()
    if not self.IsInstalled then
        --- The player clicked an offer.
        ---
        --- #### Parameter
        --- * `PlayerID`      - ID of player
        --- * `ScriptName`    - Scriptname of warehouse
        --- * `Inflation`     - Calculated inflation
        --- * `OfferIndex`    - Index of offer
        --- * `OfferGood`     - Good or entity type purchased
        --- * `GoodAmount`    - Amount of goods
        --- * `PaymentType`   - Money good
        --- * `BasePrice`     - Base price
        Report.WarehouseOfferClicked = CreateReport("Event_WarehouseOfferClicked");

        --- The player bought an offer.
        ---
        --- #### Parameter
        --- * `PlayerID`      - ID of player
        --- * `ScriptName`    - Scriptname of warehouse
        --- * `OfferGood`     - Good or entity type purchased
        --- * `GoodAmount`    - Amount of goods
        --- * `PaymentGood`   - Good of payment
        --- * `PaymentAmount` - Amount of payment
        Report.WarehouseOfferBought = CreateReport("Event_WarehouseOfferBought");

        self:OverwriteGameCallbacks();

        for i= 1, 8 do
            self.Inflation.Players[i] = {};
        end
        self.Warehouses.Job = RequestJob(function()
            Lib.Warehouse.Global:ControlWarehouse();
        end);

        -- Garbage collection
        Lib.Warehouse.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Warehouse.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Warehouse.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.WarehouseOfferClicked then
        self:PerformTrade(unpack(arg));
        SendReportToLocal(_ID, unpack(arg));
    end
end

function Lib.Warehouse.Global:CreateWarehouse(_Data)
    local Warehouse = {
        ScriptName      = _Data.ScriptName,
        BuildingName    = _Data.ScriptName.. "_Post",
        Spawnpoint      = _Data.ScriptName.. "_Spawn",
        Costs           = _Data.Costs,
        Offers          = {};
    }
    table.insert(self.Warehouses, Warehouse);

    local ID = GetID(_Data.ScriptName);
    local x,y,z = Logic.EntityGetPos(ID);
    local Orientation = Logic.GetEntityOrientation(ID);
    local PlayerID = Logic.EntityGetPlayer(ID);
    local Type = Logic.GetEntityType(ID);
    DestroyEntity(Warehouse.ScriptName);
    local SiteID = Logic.CreateEntity(Entities.I_X_TradePostConstructionSite, x, y, Orientation, PlayerID);
    Logic.SetEntityName(SiteID, Warehouse.ScriptName);
    if Type == Entities.B_TradePost then
        SiteID = ReplaceEntity(SiteID, Entities.XD_ScriptEntity);
        local BuildingID = Logic.CreateEntity(Entities.B_TradePost, x, y, Orientation, PlayerID);
        Logic.SetEntityName(BuildingID, Warehouse.BuildingName);
    end

    if _Data.Costs then
        Logic.InteractiveObjectClearCosts(GetID(Warehouse.ScriptName));
        if _Data.Costs[1] then
            Logic.InteractiveObjectAddCosts(GetID(Warehouse.ScriptName), _Data.Costs[1], _Data.Costs[2]);
        end
        if _Data.Costs[3] then
            Logic.InteractiveObjectAddCosts(GetID(Warehouse.ScriptName), _Data.Costs[3], _Data.Costs[4]);
        end
    end

    for i= 1, #_Data.Offers do
        if _Data.Offers[i] then
            self:CreateOffer(
                Warehouse.ScriptName,
                _Data.Offers[i].Amount,
                _Data.Offers[i].GoodType,
                _Data.Offers[i].GoodAmount,
                _Data.Offers[i].PaymentType,
                _Data.Offers[i].BasePrice,
                _Data.Offers[i].Refresh
            );
        end
    end
    ExecuteLocal([[Lib.Warehouse.Local:InitTradeButtons("%s")]], Warehouse.BuildingName);
end

function Lib.Warehouse.Global:GetIndex(_Name)
    for i= 1, #self.Warehouses do
        if self.Warehouses[i].ScriptName == _Name then
            return i;
        end
    end
    return 0;
end

function Lib.Warehouse.Global:CreateOffer(_Name, _Amount, _GoodType, _GoodAmount, _Payment, _BasePrice, _Refresh)
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        -- Get amount
        local Amount = _Amount or 1;
        if  KeyOf(_GoodType, Goods) == nil and KeyOf(_GoodType, Entities) ~= nil
        and Logic.IsEntityTypeInCategory(_GoodType, EntityCategories.Military) == 0 then
            Amount = 1;
        end
        -- Get type
        local OfferType = self:GetOfferType(_GoodType);
        -- Insert offer
        self.OfferSequence = self.OfferSequence + 1;
        local ID = self.OfferSequence;
        table.insert(self.Warehouses[Index].Offers, {
            ID = ID,
            OfferType = OfferType,
            BuyLock = false,
            Active = true,
            Current = Amount,
            Amount = Amount,
            Timer = _Refresh or (3*60),
            Refresh = _Refresh or (3*60),
            GoodType = _GoodType,
            GoodAmount = _GoodAmount or 9,
            PaymentType = _Payment or Goods.G_Gold,
            BasePrice = _BasePrice or 3,
        });
        return ID;
    end
    return 0;
end

function Lib.Warehouse.Global:RemoveOffer(_Name, _ID)
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= #self.Warehouses[Index].Offers, 1, -1 do
            if self.Warehouses[Index].Offers[i].ID == _ID then
                table.remove(self.Warehouses[Index].Offers, i);
                break;
            end
        end
    end
end

function Lib.Warehouse.Global:ActivateOffer(_Name, _ID, _Active)
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= #self.Warehouses[Index].Offers, 1, -1 do
            if self.Warehouses[Index].Offers[i].ID == _ID then
                self.Warehouses[Index].Offers[i].Active = _Active == true;
                break;
            end
        end
    end
end

function Lib.Warehouse.Global:GetOfferByID(_Name, _ID)
    local Offer, OfferIndex
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= #self.Warehouses[Index].Offers, 1, -1 do
            if self.Warehouses[Index].Offers[i].ID == _ID then
                Offer = self.Warehouses[Index].Offers[i];
                OfferIndex = i;
            end
        end
    end
    return Offer, OfferIndex;
end

function Lib.Warehouse.Global:GetActivOffers(_Name, _VisibleOnly)
    local Offers = {};
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= 1, #self.Warehouses[Index].Offers do
            if (not _VisibleOnly or #Offers < 6) and self.Warehouses[Index].Offers[i].Active then
                table.insert(Offers, self.Warehouses[Index].Offers[i].ID);
            end
        end
    end
    return Offers;
end

function Lib.Warehouse.Global:ChangeOfferAmount(_Name, _ID, _Amount)
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= #self.Warehouses[Index].Offers, 1, -1 do
            if self.Warehouses[Index].Offers[i].ID == _ID then
                local Max = self.Warehouses[Index].Offers[_ID].Amount;
                self.Warehouses[Index].Offers[_ID].Current = math.min(_Amount, Max);
                break;
            end
        end
    end
end

function Lib.Warehouse.Global:GetInflation(_PlayerID, _GoodType)
    return self.Inflation.Players[_PlayerID][_GoodType] or 1.0;
end

function Lib.Warehouse.Global:SetInflation(_PlayerID, _GoodType, _Inflation)
    self.Inflation.Players[_PlayerID][_GoodType] = _Inflation or 1.0;
    ExecuteLocal(
        [[Lib.Warehouse.Local.Inflation.Players[%d][%d] = %f]],
        _PlayerID,
        _GoodType,
        _Inflation or 1.0
    )
end

function Lib.Warehouse.Global:CalculateInflation(_PlayerID, _GoodType)
    local Factor = (self.Inflation.Players[_PlayerID][_GoodType] or 1.0) + self.Inflation.Inc;
    Factor = math.max(self.Inflation.Min, Factor);
    Factor = math.min(Factor, self.Inflation.Max);
    return Factor;
end

function Lib.Warehouse.Global:GetOfferType(_Offer)
    local OfferType = WarehouseOfferType.Entertainer;
    if Logic.IsEntityTypeInCategory(_Offer, EntityCategories.Soldier) == 1 then
        OfferType = WarehouseOfferType.Mercenary;
    elseif Logic.IsEntityTypeInCategory(_Offer, EntityCategories.CattlePasture) == 1 then
        OfferType = WarehouseOfferType.Lifestock;
    elseif Logic.IsEntityTypeInCategory(_Offer, EntityCategories.SheepPasture) == 1 then
        OfferType = WarehouseOfferType.Lifestock;
    elseif Logic.IsEntityTypeInCategory(_Offer, EntityCategories.HeavyWeapon) == 1 then
        OfferType = WarehouseOfferType.HeavyWeapon;
    end
    return OfferType;
end

function Lib.Warehouse.Global:PerformTrade(_PlayerID, _ScriptName, _Inflation, _OfferIndex, _OfferGood, _GoodAmount, _PaymentGood, _BasePrice)
    local BuildingID = GetID(_ScriptName.. "_Post");
    local Amount = _GoodAmount or 1;
    -- Get spawn position
    local SpawnPoint = _ScriptName.. "_Spawn";
    if not IsExisting(SpawnPoint) then
        SpawnPoint = _ScriptName.. "_Post";
    end
    local SpawnPointID = GetID(SpawnPoint);
    local x,y,z = Logic.EntityGetPos(SpawnPointID);
    if Logic.IsBuilding(SpawnPointID) == 1 then
        x,y = Logic.GetBuildingApproachPosition(SpawnPointID);
    end
    -- Send good type
    if KeyOf(_OfferGood, Goods) ~= nil then
        SendCart(SpawnPoint, _PlayerID, _OfferGood, Amount);
    -- Create units
    elseif KeyOf(_OfferGood, Entities) ~= nil then
        if  Logic.IsEntityTypeInCategory(_OfferGood, EntityCategories.HeavyWeapon) == 0
        and Logic.IsEntityTypeInCategory(_OfferGood, EntityCategories.Military) == 1 then
            local MilitaryLimit = Logic.GetCurrentSoldierLimit(_PlayerID);
            local MilitaryUsage = Logic.GetCurrentSoldierCount(_PlayerID);
            if GetBattalionSizeBySoldierType(_OfferGood) <= MilitaryLimit - MilitaryUsage then
                local Orientation = Logic.GetEntityOrientation(SpawnPointID) - 90;
                local ID  = Logic.CreateBattalionOnUnblockedLand(_OfferGood, x, y, Orientation, _PlayerID);
                x,y = Logic.GetBuildingApproachPosition(BuildingID);
                Logic.MoveSettler(ID, x, y, -1);
            end
        else
            if Logic.IsEntityTypeInCategory(_OfferGood, EntityCategories.CattlePasture) == 1
            or Logic.IsEntityTypeInCategory(_OfferGood, EntityCategories.SheepPasture) == 1 then
                Amount = 5;
            end
            for i= 1, Amount do
                local ID = Logic.CreateEntityOnUnblockedLand(
                    _OfferGood,
                    math.random(x -200, x +200),
                    math.random(y -200, y +200),
                    Logic.GetEntityOrientation(SpawnPointID) - 90,
                    _PlayerID
                );
                x,y = Logic.GetBuildingApproachPosition(BuildingID);
                Logic.MoveSettler(ID, x, y, -1);
            end
        end
    end
    -- Pay offer
    local PaymentAmount = math.floor((_BasePrice * _Inflation) + 0.5);
    AddGood(_PaymentGood, (-1) * PaymentAmount, _PlayerID);
    ExecuteLocal([[GUI_FeedbackWidgets.GoldAdd(%d, nil, {3, 1, 1}, g_TexturePositions.Goods[%d])]], (-1) * PaymentAmount, _PaymentGood);
    -- Uodate offer
    self:UpdateOnPurchase(_PlayerID, _ScriptName, _OfferIndex);
    -- Send reports
    SendReport(Report.WarehouseOfferBought, _PlayerID, _ScriptName, _OfferGood, _GoodAmount, _PaymentGood, PaymentAmount);
    SendReportToLocal(Report.WarehouseOfferBought, _PlayerID, _ScriptName, _OfferGood, _GoodAmount, _PaymentGood, PaymentAmount);
end

function Lib.Warehouse.Global:UpdateOnPurchase(_PlayerID, _ScriptName, _OfferIndex)
    local Index = self:GetIndex(_ScriptName);
    if Index ~= 0 then
        local Offer = self.Warehouses[Index].Offers[_OfferIndex];
        -- Update offer amount
        self.Warehouses[Index].Offers[_OfferIndex].Current = Offer.Current - 1;
        -- Update inflation
        local Inflation = self:CalculateInflation(_PlayerID, Offer.GoodType);
        self:SetInflation(_PlayerID, Offer.GoodType, Inflation);
    end
end

function Lib.Warehouse.Global:OverwriteGameCallbacks()
    self.Orig_GameCallback_OnBuildingConstructionComplete = GameCallback_OnBuildingConstructionComplete;
    GameCallback_OnBuildingConstructionComplete = function(_PlayerID, _EntityID)
        Lib.Warehouse.Global.Orig_GameCallback_OnBuildingConstructionComplete(_PlayerID, _EntityID);
        if Logic.GetEntityType(_EntityID) == Entities.B_TradePost then
            Lib.Warehouse.Global:OnTradepostConstructed(_EntityID);
        end
    end

    self.Orig_GameCallback_BuildingDestroyed = GameCallback_BuildingDestroyed;
    GameCallback_BuildingDestroyed = function(_EntityID, _PlayerID, _KnockedDown)
        Lib.Warehouse.Global.Orig_GameCallback_BuildingDestroyed(_EntityID, _PlayerID, _KnockedDown);
        if Logic.GetEntityType(_EntityID) == Entities.B_TradePost then
            Lib.Warehouse.Global:OnTradepostDestroyed(_PlayerID, _EntityID);
        end
    end
end

-- When a tradepost is constructed from a site and the site is a warehouse then
-- the created building becomes a script name.
function Lib.Warehouse.Global:OnTradepostConstructed(_EntityID)
    local x,y,z = Logic.EntityGetPos(_EntityID);
    local n, SiteID = Logic.GetEntitiesInArea(Entities.I_X_TradePostConstructionSite, x, y, 100, 1);
    if SiteID ~= 0 then
        local ScriptName = Logic.GetEntityName(SiteID);
        local Index = self:GetIndex(ScriptName);
        if Index ~= 0 then
            Logic.SetEntityName(_EntityID, self.Warehouses[Index].BuildingName);
        end
    end
end

-- When a tradepost is destroyed that was a warehouse an new construction site
-- is created if it don't exist anymore.
function Lib.Warehouse.Global:OnTradepostDestroyed(_PlayerID, _EntityID)
    local x,y,z = Logic.EntityGetPos(_EntityID);
    local Orientation = Logic.GetEntityOrientation(_EntityID);
    local ScriptName = Logic.GetEntityName(_EntityID);
    local Index = (ScriptName and self:GetIndex(ScriptName:sub(1, ScriptName:len() -5))) or 0;
    if Index ~= 0 then
        local Data = self.Warehouses[Index];
        local ID = ReplaceEntity(Data.ScriptName, Entities.I_X_TradePostConstructionSite);
        for i= 1, 8 do
            Logic.InteractiveObjectSetPlayerState(ID, i, 1);
        end
    end
end

function Lib.Warehouse.Global:ControlWarehouse()
    -- Refresh goods
    for i= 1, #self.Warehouses do
        if self.Warehouses[i] then
            for j= 1, #self.Warehouses[i].Offers do
                local Offer = self.Warehouses[i].Offers[j];
                if Offer.Active and Offer.Refresh > 0 then
                    if self.Warehouses[i].Offers[j].Current < Offer.Amount then
                        self.Warehouses[i].Offers[j].Timer = Offer.Timer - 1;
                        if Offer.Timer == 0 then
                            self.Warehouses[i].Offers[j].Current = Offer.Current + 1;
                            self.Warehouses[i].Offers[j].Timer = Offer.Refresh;
                        end
                    end
                end
            end
        end
    end
    -- Mirror in local script
    local Table = table.tostring(self.Warehouses);
    ExecuteLocal([[Lib.Warehouse.Local.Warehouses = %s]], Table);
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Warehouse.Local:Initialize()
    if not self.IsInstalled then
        Report.WarehouseOfferClicked = CreateReport("Event_WarehouseOfferClicked");
        Report.WarehouseOfferBought = CreateReport("Event_WarehouseOfferBought");

        for i= 1, 8 do
            self.Inflation.Players[i] = {};
        end

        -- Garbage collection
        Lib.Warehouse.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Warehouse.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.Warehouse.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.WarehouseOfferClicked then
        if GUI.GetPlayerID() == arg[2] then
            local Index = self:GetIndex(arg[2]);
            if self.Warehouses[Index] then
                self.Warehouses[Index].Offers[arg[4]].BuyLock = false;
            end
        end
    end
end

function Lib.Warehouse.Local:GetIndex(_Name)
    for i= 1, #self.Warehouses do
        if self.Warehouses[i].ScriptName == _Name then
            return i;
        end
    end
    return 0;
end

function Lib.Warehouse.Local:GetPrice(_PlayerID, _GoodType, _BasePrice)
    return math.floor(((self.Inflation.Players[_PlayerID][_GoodType] or 1.0) * _BasePrice) + 0.5);
end

function Lib.Warehouse.Local:GetInflation(_PlayerID, _GoodType)
    return self.Inflation.Players[_PlayerID][_GoodType] or 1.0;
end

function Lib.Warehouse.Local:GetOfferByID(_Name, _ID)
    local Offer, OfferIndex
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= #self.Warehouses[Index].Offers, 1, -1 do
            if self.Warehouses[Index].Offers[i].ID == _ID then
                Offer = self.Warehouses[Index].Offers[i];
                OfferIndex = i;
            end
        end
    end
    return Offer, OfferIndex;
end

function Lib.Warehouse.Local:GetActivOffers(_Name, _VisibleOnly)
    local Offers = {};
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= 1, #self.Warehouses[Index].Offers do
            if (not _VisibleOnly or #Offers < 6) and self.Warehouses[Index].Offers[i].Active then
                table.insert(Offers, self.Warehouses[Index].Offers[i].ID);
            end
        end
    end
    return Offers;
end

function Lib.Warehouse.Local:GetOfferType(_Offer)
    local OfferType = WarehouseOfferType.Entertainer;
    if Logic.IsEntityTypeInCategory(_Offer, EntityCategories.Soldier) == 1 then
        OfferType = WarehouseOfferType.Mercenary;
    elseif Logic.IsEntityTypeInCategory(_Offer, EntityCategories.CattlePasture) == 1 then
        OfferType = WarehouseOfferType.Lifestock;
    elseif Logic.IsEntityTypeInCategory(_Offer, EntityCategories.SheepPasture) == 1 then
        OfferType = WarehouseOfferType.Lifestock;
    elseif Logic.IsEntityTypeInCategory(_Offer, EntityCategories.HeavyWeapon) == 1 then
        OfferType = WarehouseOfferType.HeavyWeapon;
    end
    return OfferType;
end

-- -------------------------------------------------------------------------- --

function Lib.Warehouse.Local:InitTradeButtons(_ScriptName)
    -- Button 1
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonAction(1, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonTooltip(1, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonUpdate(1, _WidgetID, _EntityID) end
    );
    -- Button 2
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonAction(2, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonTooltip(2, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonUpdate(2, _WidgetID, _EntityID) end
    );
    -- Button 3
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonAction(3, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonTooltip(3, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonUpdate(3, _WidgetID, _EntityID) end
    );
    -- Button 4
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonAction(4, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonTooltip(4, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonUpdate(4, _WidgetID, _EntityID) end
    );
    -- Button 5
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonAction(5, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonTooltip(5, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonUpdate(5, _WidgetID, _EntityID) end
    );
    -- Button 6
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonAction(6, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonTooltip(6, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Warehouse.Local:WarehouseButtonUpdate(6, _WidgetID, _EntityID) end
    );
end

function Lib.Warehouse.Local:WarehouseButtonAction(_ButtonIndex, _WidgetID, _EntityID)
    local PlayerID = GUI.GetPlayerID();
    local ScriptName = Logic.GetEntityName(_EntityID);
    local s,e = string.find(ScriptName, "_Post");
    ScriptName = string.sub(ScriptName, 1, s-1);
    local Index = self:GetIndex(ScriptName);
    if Index == 0 then
        return;
    end

    local Offers = self:GetActivOffers(ScriptName);
    local Data, OfferIndex = self:GetOfferByID(ScriptName, Offers[_ButtonIndex]);
    if not Data then
        return;
    end
    if Data.BuyLock then
        return;
    end

    -- Get price
    local Price = self:GetPrice(PlayerID, Data.GoodType, Data.BasePrice);
    local Inflation = self:GetInflation(PlayerID, Data.GoodType);
    if GetPlayerGoodsInSettlement(Data.PaymentType, PlayerID) < Price then
        return;
    end
    -- Check limit
    if Data.OfferType == WarehouseOfferType.Mercenary then
        local MilitaryLimit = Logic.GetCurrentSoldierLimit(PlayerID);
        local MilitaryUsage = Logic.GetCurrentSoldierCount(PlayerID);
        if GetBattalionSizeBySoldierType(Data.GoodType) > MilitaryLimit - MilitaryUsage then
            AddMessage("Feedback_TextLines/TextLine_SoldierLimitReached");
            return;
        end
    end
    -- Prevent click spam
    self.Warehouses[Index].Offers[OfferIndex].BuyLock = true;
    -- Send repot to global
    SendReportToGlobal(
        Report.WarehouseOfferClicked,
        PlayerID,
        ScriptName,
        Inflation,
        OfferIndex,
        Data.GoodType,
        Data.GoodAmount,
        Data.PaymentType,
        Data.BasePrice
    );
end

function Lib.Warehouse.Local:WarehouseButtonTooltip(_ButtonIndex, _WidgetID, _EntityID)
    local PlayerID = GUI.GetPlayerID();
    local ScriptName = Logic.GetEntityName(_EntityID);
    local s,e = string.find(ScriptName, "_Post");
    ScriptName = string.sub(ScriptName, 1, s-1);
    if XGUIEng.IsButtonDisabled(_WidgetID) == 1 then
        SetTooltipCosts(ConvertPlaceholders(Localize(Lib.Warehouse.Text.OfferTitle[1])), "");
        return;
    end
    local Index = self:GetIndex(ScriptName);
    if Index == 0 then
        return;
    end

    local Offers = self:GetActivOffers(ScriptName);
    local Data, OfferIndex = self:GetOfferByID(ScriptName, Offers[_ButtonIndex]);
    if not Data then
        return;
    end

    -- Get price
    local Price = self:GetPrice(PlayerID, Data.GoodType, Data.BasePrice);
    local InSettlement = true;
    -- Get name and description
    local OfferName = "";
    local OfferDescription = "";
    local GoodTypeName = Logic.GetGoodTypeName(Data.GoodType);
    local EntityTypeName = Logic.GetEntityTypeName(Data.GoodType);
    if GoodTypeName ~= nil and GoodTypeName ~= "" then
        OfferName = GetStringText("UI_ObjectNames/" ..GoodTypeName);
        OfferDescription = GetStringText("UI_ObjectDescription/" ..GoodTypeName);
    else
        OfferName = GetStringText("UI_ObjectNames/HireEntertainer");
        OfferDescription = GetStringText("UI_ObjectDescription/HireEntertainer");
        if Data.OfferType == WarehouseOfferType.Mercenary then
            OfferName = GetStringText("UI_ObjectNames/HireMercenaries");
            OfferDescription = GetStringText("UI_ObjectDescription/HireMercenaries");
        elseif Data.OfferType == WarehouseOfferType.Lifestock then
            OfferName = GetStringText("UI_ObjectNames/G_Cow");
            OfferDescription = GetStringText("UI_ObjectDescription/G_Cow");
        elseif Data.OfferType == WarehouseOfferType.Lifestock then
            OfferName = GetStringText("UI_ObjectNames/G_Sheep");
            OfferDescription = GetStringText("UI_ObjectDescription/G_Sheep");
        elseif Data.OfferType == WarehouseOfferType.HeavyWeapon then
            OfferName = GetStringText("Names/" ..EntityTypeName);
            local EngineType = GetSiegeengineTypeByCartType(Data.GoodType);
            local EngineTypeName = Logic.GetEntityTypeName(EngineType);
            OfferDescription = GetStringText("UI_ObjectDescription/Abilities_" ..EngineTypeName);
        end
    end

    -- Format quantity text
    local Quantity = "";
    if Data.Amount > 1 then
        Quantity = string.format(" (%d/%d)", Data.Current, Data.Amount);
    end
    -- Format tooltip text
    local OfferTitle = "";
    if KeyOf(Data.GoodType, Goods) ~= nil then
        OfferTitle = string.format(Localize(Lib.Warehouse.Text.OfferTitle[2]), Data.GoodAmount, OfferName, Quantity);
    elseif KeyOf(Data.GoodType, Entities) ~= nil then
        if Logic.IsEntityTypeInCategory(Data.GoodType, EntityCategories.Military) == 1 then
            OfferTitle = string.format(Localize(Lib.Warehouse.Text.OfferTitle[4]), OfferName, Quantity);
        elseif Logic.IsEntityTypeInCategory(Data.GoodType, EntityCategories.SiegeEngine) == 1 then
            OfferTitle = string.format(Localize(Lib.Warehouse.Text.OfferTitle[5]), OfferName, Quantity);
        elseif Logic.IsEntityTypeInCategory(Data.GoodType, EntityCategories.CattlePasture) == 1
            or Logic.IsEntityTypeInCategory(Data.GoodType, EntityCategories.SheepPasture) == 1 then
            OfferTitle = string.format(Localize(Lib.Warehouse.Text.OfferTitle[5]), OfferName, Quantity);
        else
            OfferTitle = string.format(Localize(Lib.Warehouse.Text.OfferTitle[3]), OfferName);
        end
    end
    -- Set text
    SetTooltipCosts(
        OfferTitle,
        OfferDescription,
        nil,
        {Data.PaymentType, Price},
        InSettlement
    );
end

function Lib.Warehouse.Local:WarehouseButtonUpdate(_ButtonIndex, _WidgetID, _EntityID)
    local ScriptName = Logic.GetEntityName(_EntityID);
    local s,e = string.find(ScriptName, "_Post");
    ScriptName = string.sub(ScriptName, 1, s-1);
    -- Hide if tradepost is no warehouse
    local Index = self:GetIndex(ScriptName);
    if Index == 0 then
        XGUIEng.ShowWidget(_WidgetID, 0);
        return;
    end
    -- Hide if offer is invalid
    local Offers = self:GetActivOffers(ScriptName);
    local Data, OfferIndex = self:GetOfferByID(ScriptName, Offers[_ButtonIndex]);
    if not Data or not Data.Active then
        XGUIEng.ShowWidget(_WidgetID, 0);
        return;
    end
    -- Disable button if locked or sold out
    if not Data.BuyLock and Data.Current > 0 then
        XGUIEng.DisableButton(_WidgetID, 0);
    else
        XGUIEng.DisableButton(_WidgetID, 1);
    end
    -- Set icon
    local Good = Data.GoodType;
    local Icon = g_TexturePositions.Goods[Good] or g_TexturePositions.Entities[Good];
    ChangeIcon(_WidgetID, Icon);
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Warehouse.Name);

