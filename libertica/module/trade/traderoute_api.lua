Lib.Require("comfort/IsLocalScript");
Lib.Register("module/trade/TradeRoute_API");

function InitHarbor(_PlayerID, ...)
    assert(not IsLocalScript(), "Can not be used in local script!");
    assert(Logic.GetStoreHouse(_PlayerID) ~= 0, "Player " .._PlayerID.. " is dead! :(");
    Lib.TradeRoute.Global:CreateHarbor(_PlayerID, false);
    for i= 1, #arg do
        AddTradeRoute(_PlayerID, arg[i]);
    end
end
API.TravelingSalesmanCreate = InitHarbor;
API.InitHarbor = InitHarbor;

function DisposeHarbor(_PlayerID)
    assert(not IsLocalScript(), "Can not be used in local script!");
    assert(Logic.GetStoreHouse(_PlayerID) ~= 0, "Player " .._PlayerID.. " is dead! :(");
    Lib.TradeRoute.Global:DisposeHarbor(_PlayerID);
end
API.TravelingSalesmanDelete = DisposeHarbor;
API.DisposeHarbor = DisposeHarbor;

function AddTradeRoute(_PlayerID, _Route)
    assert(not IsLocalScript(), "Can not be used in local script!");
    assert(Logic.GetStoreHouse(_PlayerID) ~= 0, "Player " .._PlayerID.. " is dead! :(");
    assert(type(_Route) == "table", "_Route must be a table!");
    assert(_Route.Name ~= nil, "Trade route must have a name!");
    assert(_Route.Path and #_Route.Path >= 2, "Path of route " .._Route.Name.. " has to few nodes!");
    assert(_Route.Offers and #_Route.Offers >= 1, "Route " .._Route.Name.. " has to few offers!");
    _Route.Amount = _Route.Amount or ((#_Route.Offers > 4 and 4) or #_Route.Offers);
    assert(_Route.Amount >= 1 and _Route.Amount <= 4, "Route " .._Route.Name.. " can only add up to 4 offers!");
    assert(_Route.Amount <= #_Route.Offers, "Route " .._Route.Name.. " has not enough offers to add!");
    if  Lib.TradeRoute.Global:CountTradeRoutes(_PlayerID) > 0
    and Lib.TradeRoute.Global:IsRetroHarbor(_PlayerID) then
        assert(false, "Can't add routes to traveling salesman!");
    end
    for i= 1, #_Route.Offers, 1 do
        local IsGoodType = Goods[_Route.Offers[i][1]] ~= nil;
        local IsUnitType = Entities[_Route.Offers[i][1]] ~= nil;
        assert(IsGoodType or IsUnitType, "Offers[" ..i.. "][1] is of invalid good or unit type!");
        local IsValidAmount = type(_Route.Offers[i][2]) == "number" and _Route.Offers[i][2] >= 1;
        assert(IsValidAmount, "Offers[" ..i.. "][2] amount must be at least 1!");
    end
    Lib.TradeRoute.Global:AddTradeRoute(_PlayerID, _Route);
end
API.AddTradeRoute = AddTradeRoute;

function ChangeTradeRouteGoods(_PlayerID, _RouteName, _RouteOffers)
    assert(not IsLocalScript(), "Can not be used in local script!");
    assert(Logic.GetStoreHouse(_PlayerID) ~= 0, "Player " .._PlayerID.. " is dead! :(");
    assert(type(_RouteOffers) == "table" and #_RouteOffers >= 1, "_RouteOffers must be a table with entries!");
    for i= 1, #_RouteOffers, 1 do
        local IsGoodType = Goods[_RouteOffers[i][1]] ~= nil;
        local IsUnitType = Entities[_RouteOffers[i][1]] ~= nil;
        assert(IsGoodType or IsUnitType, "Offers[" ..i.. "][1] is of invalid good or unit type!");
        local IsValidAmount = type(_RouteOffers[i][2]) == "number" and _RouteOffers[i][2] >= 1;
        assert(IsValidAmount, "Offers[" ..i.. "][2] amount must be at least 1!");
    end
    Lib.TradeRoute.Global:AlterTradeRouteOffers(_PlayerID, _RouteName, _RouteOffers);
end
API.ChangeTradeRouteGoods = ChangeTradeRouteGoods;

function RemoveTradeRoute(_PlayerID, _RouteName)
    assert(not IsLocalScript(), "Can not be used in local script!");
    assert(Logic.GetStoreHouse(_PlayerID) ~= 0, "Player " .._PlayerID.. " is dead! :(");
    assert(not Lib.TradeRoute.Global:IsRetroHarbor(_PlayerID), "Can't remove routes to traveling salesman!");
    return Lib.TradeRoute.Global:ShutdownTradeRoute(_PlayerID, _RouteName);
end
API.RemoveTradeRoute = RemoveTradeRoute;

function InitTravelingSalesman(_Route)
    assert(not IsLocalScript(), "Can not be used in local script!");
    assert(type(_Route) == "table", "_Route must be a table!");
    assert(_Route.PlayerID ~= nil, "_Route.PlayerID is invalid!");
    local PlayerID = _Route.PlayerID;
    _Route.PlayerID = nil;
    Lib.TradeRoute.Global:CreateHarbor(PlayerID, true);
    assert(Logic.GetStoreHouse(PlayerID) ~= 0, "Player " ..PlayerID.. " is dead! :(");
    _Route.Name = "Player" ..PlayerID.. "_Route";
    _Route.Message = _Route.Message ~= false;
    AddTradeRoute(PlayerID, _Route);
    Lib.TradeRoute.Global:OnTravelingSalesmanInitalized(PlayerID);
end
API.InitTravelingSalesman = InitTravelingSalesman;

function DisposeTravelingSalesman(_PlayerID)
    DisposeHarbor(_PlayerID);
end
API.DisposeTravelingSalesman = DisposeTravelingSalesman;

function ChangeTravelingSalesmanGoods(_PlayerID, _RouteOffers)
    assert(Lib.TradeRoute.Global:IsRetroHarbor(_PlayerID), "Not a traveling salesman!");
    ChangeTradeRouteGoods(_PlayerID, "Player" .._PlayerID.. "_Route", _RouteOffers);
end
API.ChangeTravelingSalesmanGoods = ChangeTravelingSalesmanGoods;

