--- Allows to setup a AI player as a harbor more realisticly.
--- 
--- #### What a harbor does
--- <li>Ships will cycle to the port and deliver goods from a trade route (Ships move faster than usual)</li>
--- <li>A harbor can be served by multiple trade routs</li>
--- <li>On arrival the ship will add its goods to the existing offers</li>
--- <li>If the offer amount is exeeding 4 the oldest offers are removed (If offers are sold out they will be removed)</li>
--- <li>If the AI is destroyed all ships and routes will be deleted</li>
--- 
--- #### What a harbor does not
--- <li>No automatic diplomacy changes when a ship arrives</li>
--- <li>Spaming the player with info messages</li>



--- Initalizes the storehouse of the player as trade harbor.
--- @param _PlayerID integer ID of player
--- @param ... table List of routes
function InitHarbor(_PlayerID, ...)
end
API.InitHarbor = InitHarbor;

--- Removes the trade harbor from the players storehouse. Also ships
--- currently on the map will be deleted.
--- @param _PlayerID integer ID of player
function DisposeHarbor(_PlayerID)
end
API.DisposeHarbor = DisposeHarbor;

--- Adds a trade route to a trade harbor.
--- 
--- #### Trade route fields:
--- * `Name` - Unique name for the route
--- * `Path` - List of waypoint names
--- * `Offers` - List of offers (Format: {_Type, _Amount})
--- * `Amount` - Amount of offers to select on arrival
--- * `Duration` - Anchor time of the ship in seconds
--- * `Interval` - Time between ship visits
--- 
--- #### Example:
--- ```lua
--- AddTradeRoute(
---     2,
---     {
---         Name       = "Route3",
---         -- Waypoints (last should be at the harbor or it will be strange ;) )
---         Path       = {"Spawn3", "Arrived3"},
---         -- 10 minutes pass between visits
---         Interval   = 10*60,
---         -- The ship remains at the harbor for 2 minutes
---         Duration   = 2*60,
---         -- 2 Offers will be selected at arrival
---         Amount     = 2,
---         -- List of offers to select from
---         Offers     = {
---             {"G_Wool", 5},
---             {"U_CatapultCart", 1},
---             {"G_Beer", 2},
---             {"G_Herb", 5},
---             {"U_Entertainer_NA_StiltWalker", 1},
---         }
---     }
--- );
--- ```
--- 
--- @param _PlayerID integer ID of player
--- @param _Route table Trade route description
function AddTradeRoute(_PlayerID, _Route)
end
API.AddTradeRoute = AddTradeRoute;

--- Changes the offers of an existing trade route.
--- 
--- #### Example:
--- ```lua
--- ChangeTradeRouteGoods(
---     2,
---     "Route3",
---     {{"G_Wool", 3},
---      {"U_CatapultCart", 5},
---      {"G_Beer", 2},
---      {"G_Herb", 3},
---      {"U_Entertainer_NA_StiltWalker", 1}}
--- );
--- ```
--- 
--- @param _PlayerID integer ID of player
--- @param _RouteName string Identifier of route
--- @param _RouteOffers table Offers
function ChangeTradeRouteGoods(_PlayerID, _RouteName, _RouteOffers)
end
API.ChangeTradeRouteGoods = ChangeTradeRouteGoods;

--- Deletes a trade route after it's cycle ends.
--- @param _PlayerID integer ID of player
--- @param _RouteName string Identifier of route
--- @return integer JobID ID of delay job
function RemoveTradeRoute(_PlayerID, _RouteName)
    return 0;
end
API.RemoveTradeRoute = RemoveTradeRoute;

--- Creates a classic traveling salesman.
--- 
--- This variant is different in their behavior. It WILL change it's diplomacy
--- depending on if the ship is at the port (trade partner) or not (established
--- contact). Also the traveling salesman can only have 1 route and they will
--- send standard messages about the ships whereabouts.
--- 
--- #### Trade route fields:
--- * `PlayerID` - ID of player
--- * `Path` - List of waypoint names
--- * `Offers` - List of offers (Format: {_Type, _Amount})
--- * `Amount` - Amount of offers to select on arrival
--- * `Duration` - Anchor time of the ship in seconds
--- * `Interval` - Time between ship visits
--- * `Message` - Activate/Deactivate ship status messages
--- 
--- #### Example:
--- ```lua
--- InitTravelingSalesman{
---     PlayerID   = 2,
---     Path       = {"Spawn3", "Arrived3"},
---     Interval   = 10*60,
---     Duration   = 2*60,
---     Amount     = 2,
---     Offers     = {
---         {"G_Wool", 5},
---         {"U_CatapultCart", 1},
---         {"G_Beer", 2},
---         {"G_Herb", 5},
---         {"U_Entertainer_NA_StiltWalker", 1},
---     }
--- };
--- ```
--- 
--- @param _Route table Traveling salesman description
function InitTravelingSalesman(_Route)
end
API.InitTravelingSalesman = InitTravelingSalesman;

--- Removes the traveling salesman from the players storehouse. Also ships
--- currently on the map will be deleted.
--- @param _PlayerID integer ID of player
function DisposeTravelingSalesman(_PlayerID)
end
API.DisposeTravelingSalesman = DisposeTravelingSalesman;

--- Changes the offers of an traveling salesman.
--- 
--- #### Example:
--- ```lua
--- ChangeTravelingSalesmanGoods(
---     2,
---     {{"G_Wool", 3},
---      {"U_CatapultCart", 5},
---      {"G_Beer", 2},
---      {"G_Herb", 3},
---      {"U_Entertainer_NA_StiltWalker", 1}}
--- );
--- ```
--- 
--- @param _PlayerID integer ID of player
--- @param _Offers table Offers
function ChangeTravelingSalesmanGoods(_PlayerID, _Offers)
end
API.ChangeTravelingSalesmanGoods = ChangeTravelingSalesmanGoods;



--- A ship has spawned at the start of the trade route path.
---
--- #### Parameters:
--- * `_PlayerID`:  <b>integer</b> PlayerID of harbor
--- * `_RouteName`: <b>string</b> Identifier of the route
--- * `_ShipID`:    <b>integer</b> ID of the ship
Report.TradeShipSpawned = anyInteger;

--- A ship has arrived at a harbor.
---
--- #### Parameters:
--- * `_PlayerID`:  <b>integer</b> PlayerID of harbor
--- * `_RouteName`: <b>string</b> Identifier of the route
--- * `_ShipID`:    <b>integer</b> ID of the ship
Report.TradeShipArrived = anyInteger;

--- A ship has left a harbor.
---
--- #### Parameters:
--- * `_PlayerID`:  <b>integer</b> PlayerID of harbor
--- * `_RouteName`: <b>string</b> Identifier of the route
--- * `_ShipID`:    <b>integer</b> ID of the ship
Report.TradeShipLeft = anyInteger;

--- A ship has despawned at the end of the trade route path.
---
--- #### Parameters:
--- * `_PlayerID`:  <b>integer</b> PlayerID of harbor
--- * `_RouteName`: <b>string</b> Identifier of the route
--- * `_ShipID`:    <b>integer</b> ID of the ship
Report.TradeShipDespawned = anyInteger;


