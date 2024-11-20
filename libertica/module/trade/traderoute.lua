Lib.TradeRoute = Lib.TradeRoute or {};
Lib.TradeRoute.Name = "TradeRoute";
Lib.TradeRoute.CinematicEvents = {};
Lib.TradeRoute.Global = {
    Harbors = {},
};
Lib.TradeRoute.Local = {};
Lib.TradeRoute.Text = {};

ShipTraderState = {
    Waiting = 1,
    MovingIn = 2,
    Anchored = 3,
    MovingOut = 4,
}

Lib.Require("core/Core");
Lib.Require("module/trade/Trade");
Lib.Require("module/trade/TradeRoute_API");
Lib.Register("module/trade/TradeRoute");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.TradeRoute.Global:Initialize()
    if not self.IsInstalled then
        Report.TradeShipSpawned = CreateReport("Event_TradeShipSpawned");
        Report.TradeShipArrived = CreateReport("Event_TradeShipArrived");
        Report.TradeShipLeft = CreateReport("Event_TradeShipLeft");
        Report.TradeShipDespawned = CreateReport("Event_TradeShipDespawned");

        RequestJob(function()
            Lib.TradeRoute.Global:ControlHarbors();
        end);

        -- Garbage collection
        Lib.TradeRoute.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.TradeRoute.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.TradeRoute.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.TradeShipSpawned then
        self:OnTravelingSalesmanShipSpawned(arg[1], arg[2], arg[3]);
    elseif _ID == Report.TradeShipArrived then
        self:OnTravelingSalesmanShipArrived(arg[1], arg[2], arg[3]);
    elseif _ID == Report.TradeShipLeft then
        self:OnTravelingSalesmanShipLeft(arg[1], arg[2], arg[3]);
    end
end

function Lib.TradeRoute.Global:CreateHarbor(_PlayerID, _IsRetro)
    if self.Harbors[_PlayerID] then
        self:DisposeHarbor(_PlayerID);
    end
    self.Harbors[_PlayerID] = {
        IsRetro = _IsRetro == true,
        AddedOffers  = {},
        Routes = {},
    };
end

function Lib.TradeRoute.Global:DisposeHarbor(_PlayerID)
    local StoreHouseID = Logic.GetStoreHouse(_PlayerID)
    for k, v in pairs(self.Harbors[_PlayerID].Routes) do
        self:PurgeTradeRoute(_PlayerID, v.Name);
    end
    if IsExisting(StoreHouseID) then
        Logic.RemoveAllOffers(StoreHouseID);
    end
end

function Lib.TradeRoute.Global:IsRetroHarbor(_PlayerID)
    if self.Harbors[_PlayerID] then
        return self.Harbors[_PlayerID].IsRetro == true;
    end
    return false;
end

function Lib.TradeRoute.Global:IsSendingMessage(_PlayerID)
    return self.Harbors[_PlayerID] and
           self.Harbors[_PlayerID].Routes[1] and
           self.Harbors[_PlayerID].Routes[1].Message;
end

function Lib.TradeRoute.Global:CountTradeRoutes(_PlayerID)
    if self.Harbors[_PlayerID] then
        return #self.Harbors[_PlayerID].Routes;
    end
    return false;
end

function Lib.TradeRoute.Global:AddTradeRoute(_PlayerID, _Data)
    if not self.Harbors[_PlayerID] then
        return;
    end
    for i= #self.Harbors[_PlayerID].Routes, 1, -1 do
        if self.Harbors[_PlayerID].Routes[i].Name == _Data.Name then
            return;
        end
    end
    _Data.Interval = _Data.Interval or 300;
    _Data.Duration = _Data.Duration or 120;
    _Data.Timer = 0;
    _Data.State = ShipTraderState.Waiting;
    table.insert(self.Harbors[_PlayerID].Routes, _Data);
end

function Lib.TradeRoute.Global:AlterTradeRouteOffers(_PlayerID, _Name, _Offers)
    if not self.Harbors[_PlayerID] then
        return;
    end
    for i= #self.Harbors[_PlayerID].Routes, 1, -1 do
        if self.Harbors[_PlayerID].Routes[i].Name == _Name then
            _Offers.Message = self.Harbors[_PlayerID].Routes[i].Message == true;
            self.Harbors[_PlayerID].Routes[i].Offers = _Offers;
            return;
        end
    end
end

function Lib.TradeRoute.Global:PurgeAllTradeRoutes(_PlayerID)
    if not self.Harbors[_PlayerID] then
        return;
    end
    for i= #self.Harbors[_PlayerID].Routes, 1, -1 do
        local Data = table.remove(self.Harbors[_PlayerID].Routes, i);
        if IsExisting(Data.ShipID) then
            DestroyEntity(Data.ShipID);
        end
        if JobIsRunning(Data.ShipID) then
            EndJob(Data.ShipJob);
        end
    end
end

function Lib.TradeRoute.Global:PurgeTradeRoute(_PlayerID, _Name)
    if not self.Harbors[_PlayerID] then
        return;
    end
    for i= #self.Harbors[_PlayerID].Routes, 1, -1 do
        if self.Harbors[_PlayerID].Routes[i].Name == _Name then
            local Data = table.remove(self.Harbors[_PlayerID].Routes, i);
            if IsExisting(Data.ShipID) then
                DestroyEntity(Data.ShipID);
            end
            if JobIsRunning(Data.ShipID) then
                EndJob(Data.ShipJob);
            end
            break;
        end
    end
end

function Lib.TradeRoute.Global:ShutdownTradeRoute(_PlayerID, _Name)
    if self.Harbors[_PlayerID] then
        for i= #self.Harbors[_PlayerID].Routes, 1, -1 do
            if self.Harbors[_PlayerID].Routes[i].Name == _Name then
                return RequestJob(function (_PlayerID, _Index)
                    if self.Harbors[_PlayerID].Routes[_Index].State == ShipTraderState.Waiting then
                        local Name = self.Harbors[_PlayerID].Routes[_Index].Name;
                        Lib.TradeRoute.Global:PurgeTradeRoute(_PlayerID, Name);
                        return true;
                    end
                end, _PlayerID, i);
            end
        end
    end
    return 0;
end

function Lib.TradeRoute.Global:SpawnShip(_PlayerID, _Index)
    local Route = self.Harbors[_PlayerID].Routes[_Index];
    local SpawnPointID = GetID(Route.Path[1]);
    local x, y, z = Logic.EntityGetPos(SpawnPointID);
    local Orientation = Logic.GetEntityOrientation(SpawnPointID);
    local ID = Logic.CreateEntity(Entities.D_X_TradeShip, x, y, Orientation, 0);
    self.Harbors[_PlayerID].Routes[_Index].ShipID = ID;
    self:SendShipSpawnedEvent(_PlayerID, Route, ID);
    Logic.SetSpeedFactor(ID, 3.0);
    return ID;
end

function Lib.TradeRoute.Global:DespawnShip(_PlayerID, _Index)
    local ID = self.Harbors[_PlayerID].Routes[_Index].ShipID;
    local Route = self.Harbors[_PlayerID].Routes[_Index];
    self:SendShipDespawnedEvent(_PlayerID, Route, ID);
    DestroyEntity(ID);
end

function Lib.TradeRoute.Global:MoveShipIn(_PlayerID, _Index)
    local Route = self.Harbors[_PlayerID].Routes[_Index];
    local ID = self.Harbors[_PlayerID].Routes[_Index].ShipID;
    local Waypoints = {};
    for i= 1, #Route.Path do
        table.insert(Waypoints, GetID(Route.Path[i]));
    end
    local Instance = Path:new(ID, Waypoints, nil, nil, nil, nil, true, nil, nil, 300);
    self.Harbors[_PlayerID].Routes[_Index].ShipJob = Instance.Job;
    return ID;
end

function Lib.TradeRoute.Global:MoveShipOut(_PlayerID, _Index)
    local Route = self.Harbors[_PlayerID].Routes[_Index];
    local ID = self.Harbors[_PlayerID].Routes[_Index].ShipID;
    local Waypoints = {};
    for i= 1, #Route.Path do
        table.insert(Waypoints, GetID(Route.Path[i]));
    end
    local Instance = Path:new(ID, table.invert(Waypoints), nil, nil, nil, nil, true, nil, nil, 300);
    self.Harbors[_PlayerID].Routes[_Index].ShipJob = Instance.Job;
    return ID;
end

function Lib.TradeRoute.Global:SendShipSpawnedEvent(_PlayerID, _Route, _ShipID)
    SendReport(Report.TradeShipSpawned, _PlayerID, _Route.Name, _ShipID);
    SendReportToLocal(
        Report.TradeShipSpawned,
        _PlayerID,
        _Route.Name,
        _ShipID
    );
end

function Lib.TradeRoute.Global:SendShipDespawnedEvent(_PlayerID, _Route, _ShipID)
    SendReport(Report.TradeShipDespawned, _PlayerID, _Route.Name, _ShipID);
    SendReportToLocal(
        Report.TradeShipDespawned,
        _PlayerID,
        _Route.Name,
        _ShipID
    );
end

function Lib.TradeRoute.Global:SendShipArrivedEvent(_PlayerID, _Route, _ShipID)
    SendReport(Report.TradeShipArrived, _PlayerID, _Route.Name, _ShipID);
    SendReportToLocal(
        Report.TradeShipArrived,
        _PlayerID,
        _Route.Name,
        _ShipID
    );
end

function Lib.TradeRoute.Global:SendShipLeftEvent(_PlayerID, _Route, _ShipID)
    SendReport(Report.TradeShipLeft, _PlayerID, _Route.Name, _ShipID);
    SendReportToLocal(
        Report.TradeShipLeft,
        _PlayerID,
        _Route.Name,
        _ShipID
    );
end

function Lib.TradeRoute.Global:AddTradeOffers(_PlayerID, _Index)
    local Harbor = self.Harbors[_PlayerID];
    local Route = Harbor.Routes[_Index];

    -- select offers
    local Offers = {};
    if Route.Amount == #Route.Offers then
        Offers = table.copy(Route.Offers);
    else
        local Indices = {};
        while (#Indices < Route.Amount) do
            local Index = math.random(1, #Route.Offers);
            if not table.contains(Indices, Index) then
                table.insert(Indices, Index);
            end
        end
        for i= 1, #Indices do
            table.insert(Offers, table.copy(Route.Offers[Indices[i]]));
        end
    end

    -- add selected offers
    local StoreData;
    for i= 1, #Offers do
        -- set offer type
        local IsGoodType = true;
        local IsMilitary = false;
        local OfferType = Goods[Offers[i][1]];
        if not OfferType then
            IsGoodType = false;
            OfferType = Entities[Offers[i][1]];
            if Logic.IsEntityTypeInCategory(Entities[Offers[i][1]], EntityCategories.Military) == 1 then
                IsMilitary = true;
            end
        end
        -- remove oldest offer if needed
        StoreData = GetOfferInformation(_PlayerID);
        if  not self:IsRetroHarbor(_PlayerID)
        and StoreData.OfferCount >= 4 then
            local LastOffer = table.remove(self.Harbors[_PlayerID].AddedOffers, 1);
            RemoveTradeOffer(_PlayerID, LastOffer);
        end
        StoreData = GetOfferInformation(_PlayerID);
        -- add new offer
        RemoveTradeOffer(_PlayerID, OfferType);
        if IsGoodType then
            CreateGoodOffer(_PlayerID, OfferType, Offers[i][2], 60*60*24*7);
        else
            if not IsMilitary then
                CreateEntertainerOffer(_PlayerID, OfferType);
            else
                CreateMercenaryOffer(_PlayerID, OfferType, Offers[i][2], 60*60*24*7);
            end
        end
        table.insert(self.Harbors[_PlayerID].AddedOffers, OfferType);
        StoreData = GetOfferInformation(_PlayerID);
    end

    -- update visuals
    ExecuteLocal(
        [[GameCallback_CloseNPCInteraction(GUI.GetPlayerID(), %d)]],
        StoreData.Storehouse
    );
end

function Lib.TradeRoute.Global:RemoveTradeOffers(_PlayerID, _Index)
    if self:IsRetroHarbor(_PlayerID) then
        local StoreHouseID = Logic.GetStoreHouse(_PlayerID)
        Logic.RemoveAllOffers(StoreHouseID);
    end
end

function Lib.TradeRoute.Global:ControlHarbors()
    for k,v in pairs(self.Harbors) do
        if Logic.GetStoreHouse(k) == 0 then
            self:DisposeHarbor(k);
        else
            if #v.Routes > 0 then
                -- remove sold out offers
                local StoreData = GetOfferInformation(k);
                for i= 1, #StoreData[1] do
                    if StoreData[1][i][5] == 0 then
                        Lib.Trade.Global:RemoveTradeOfferByData(StoreData, i);
                        for j= #v.AddedOffers, 1, -1 do
                            if v.AddedOffers[j] == StoreData[1][i][3] then
                                table.remove(self.Harbors[k].AddedOffers, j);
                            end
                        end
                    end
                end

                -- control trade routes
                for i= 1, #v.Routes do
                    if v.Routes[i].State == ShipTraderState.Waiting then
                        self.Harbors[k].Routes[i].Timer = v.Routes[i].Timer +1;
                        if v.Routes[i].Timer >= v.Routes[i].Interval then
                            self.Harbors[k].Routes[i].State = ShipTraderState.MovingIn;
                            self.Harbors[k].Routes[i].Timer = 0;
                            self:SpawnShip(k, i);
                            self:MoveShipIn(k, i);
                        end

                    elseif v.Routes[i].State == ShipTraderState.MovingIn then
                        local AnchorPoint = v.Routes[i].Path[#v.Routes[i].Path];
                        local ShipID = v.Routes[i].ShipID;
                        if IsNear(ShipID, AnchorPoint, 300) then
                            self.Harbors[k].Routes[i].State = ShipTraderState.Anchored;
                            self:SendShipArrivedEvent(k, v.Routes[i], ShipID);
                            self:AddTradeOffers(k, i);
                        end

                    elseif v.Routes[i].State == ShipTraderState.Anchored then
                        local ShipID = v.Routes[i].ShipID;
                        self.Harbors[k].Routes[i].Timer = v.Routes[i].Timer +1;
                        if v.Routes[i].Timer >= v.Routes[i].Duration then
                            self.Harbors[k].Routes[i].State = ShipTraderState.MovingOut;
                            self.Harbors[k].Routes[i].Timer = 0;
                            self:SendShipLeftEvent(k, v.Routes[i], ShipID);
                            self:RemoveTradeOffers(k, i);
                            self:MoveShipOut(k, i);
                        end

                    elseif v.Routes[i].State == ShipTraderState.MovingOut then
                        local SpawnPoint = v.Routes[i].Path[1];
                        local ShipID = v.Routes[i].ShipID;
                        if IsNear(ShipID, SpawnPoint, 300) then
                            self.Harbors[k].Routes[i].State = ShipTraderState.Waiting;
                            self:DespawnShip(k, i);
                        end
                    end
                end
            end
        end
    end
end

function Lib.TradeRoute.Global:OnTravelingSalesmanInitalized(_PlayerID)
    if self:IsRetroHarbor(_PlayerID) then
        -- Change diplomacy
        for PlayerID = 1, 8 do
            if _PlayerID ~= PlayerID and Logic.PlayerGetIsHumanFlag(PlayerID) then
                SetDiplomacyState(PlayerID, _PlayerID, 0);
            end
        end
    end
end

function Lib.TradeRoute.Global:OnTravelingSalesmanShipSpawned(_PlayerID, _RouteName, _ShipID)
    if self:IsRetroHarbor(_PlayerID) then
        -- Send "voice" message
        if self:IsSendingMessage(_PlayerID) then
            ExecuteLocal("LocalScriptCallback_QueueVoiceMessage(".. _PlayerID ..", 'TravelingSalesmanSpotted')");
        end
    end
end

function Lib.TradeRoute.Global:OnTravelingSalesmanShipArrived(_PlayerID, _RouteName, _ShipID)
    if self:IsRetroHarbor(_PlayerID) then
        -- Send "voice" message
        if self:IsSendingMessage(_PlayerID) then
            ExecuteLocal("LocalScriptCallback_QueueVoiceMessage(".. _PlayerID ..", 'TravelingSalesman')");
        end
        -- Change diplomacy
        for PlayerID = 1, 8 do
            if _PlayerID ~= PlayerID and Logic.PlayerGetIsHumanFlag(PlayerID) then
                SetDiplomacyState(PlayerID, _PlayerID, 1);
            end
        end
    end
end

function Lib.TradeRoute.Global:OnTravelingSalesmanShipLeft(_PlayerID, _RouteName, _ShipID)
    if self:IsRetroHarbor(_PlayerID) then
        -- Send "voice" message
        if self:IsSendingMessage(_PlayerID) then
            ExecuteLocal("LocalScriptCallback_QueueVoiceMessage(".. _PlayerID ..", 'TravelingSalesman_Failure')");
        end
        -- Change diplomacy
        for PlayerID = 1, 8 do
            if _PlayerID ~= PlayerID and Logic.PlayerGetIsHumanFlag(PlayerID) then
                SetDiplomacyState(PlayerID, _PlayerID, 0);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.TradeRoute.Local:Initialize()
    if not self.IsInstalled then
        Report.TradeShipSpawned = CreateReport("Event_TradeShipSpawned");
        Report.TradeShipArrived = CreateReport("Event_TradeShipArrived");
        Report.TradeShipLeft = CreateReport("Event_TradeShipLeft");
        Report.TradeShipDespawned = CreateReport("Event_TradeShipDespawned");

        -- Garbage collection
        Lib.TradeRoute.Local = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.TradeRoute.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.TradeRoute.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.TradeRoute.Name);


