--- Ermöglicht die Einrichtung eines KI-Spielers als Hafen realistischer.
--- 
--- #### Was ein Hafen tut
--- <li>Schiffe fahren zum Hafen und liefern Waren von einer Handelsroute (Schiffe bewegen sich schneller als gewöhnlich)</li>
--- <li>Ein Hafen kann von mehreren Handelswegen bedient werden</li>
--- <li>Bei der Ankunft fügt das Schiff seine Waren zu den bestehenden Angeboten hinzu</li>
--- <li>Wenn die Angebotsmenge 4 übersteigt, werden die ältesten Angebote entfernt (Wenn Angebote ausverkauft sind, werden sie entfernt)</li>
--- <li>Wenn die KI zerstört wird, werden alle Schiffe und Routen gelöscht</li>
--- 
--- #### Was ein Hafen nicht tut
--- <li>Keine automatischen Diplomatieänderungen, wenn ein Schiff ankommt</li>
--- <li>Spamming des Spielers mit Informationsnachrichten</li>



--- Initialisiert das Lagerhaus des Spielers als Handelshafen.
--- @param _PlayerID integer ID des Spielers
--- @param ... table Liste der Routen
function InitHarbor(_PlayerID, ...)
end
API.InitHarbor = InitHarbor;

--- Entfernt den Handelshafen aus dem Lagerhaus des Spielers. Auch Schiffe,
--- die sich derzeit auf der Karte befinden, werden gelöscht.
--- @param _PlayerID integer ID des Spielers
function DisposeHarbor(_PlayerID)
end
API.DisposeHarbor = DisposeHarbor;

--- Fügt einem Handelshafen eine Handelsroute hinzu.
--- 
--- #### Felder der Handelsroute:
--- * `Name` - Eindeutiger Name für die Route
--- * `Path` - Liste der Wegpunkte
--- * `Offers` - Liste der Angebote (Format: {_Type, _Amount})
--- * `Amount` - Anzahl der Angebote, die bei der Ankunft ausgewählt werden sollen
--- * `Duration` - Ankerzeit des Schiffes in Sekunden
--- * `Interval` - Zeit zwischen Schiffsbesuchen
--- 
--- #### Example:
--- ```lua
--- AddTradeRoute(
---     2,
---     {
---         Name       = "Route3",
---         -- Wegpunkte (der letzte sollte sich im Hafen befinden, sonst wird es seltsam ;) )
---         Path       = {"Spawn3", "Arrived3"},
---         -- 10 Minuten vergehen zwischen den Besuchen
---         Interval   = 10*60,
---         -- Das Schiff bleibt **2** Minuten im Hafen
---         Duration   = 2*60,
---         -- **2** Angebote werden bei der Ankunft ausgewählt
---         Amount     = 2,
---         -- Liste der Angebote, aus denen ausgewählt werden soll
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
--- @param _PlayerID integer ID des Spielers
--- @param _Route table Beschreibung der Handelsroute
function AddTradeRoute(_PlayerID, _Route)
end
API.AddTradeRoute = AddTradeRoute;

--- Ändert die Angebote einer bestehenden Handelsroute.
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
--- @param _PlayerID integer ID des Spielers
--- @param _RouteName string Kennung der Route
--- @param _RouteOffers table Angebote
function ChangeTradeRouteGoods(_PlayerID, _RouteName, _RouteOffers)
end
API.ChangeTradeRouteGoods = ChangeTradeRouteGoods;

--- Löscht eine Handelsroute, nachdem ihr Zyklus beendet ist.
--- @param _PlayerID integer ID des Spielers
--- @param _RouteName string Kennung der Route
--- @return integer JobID ID des Verzögerungsauftrags
function RemoveTradeRoute(_PlayerID, _RouteName)
    return 0;
end
API.RemoveTradeRoute = RemoveTradeRoute;

--- Initialisiert einen Spieler als klassichen fahrenden Händler.
--- 
--- Diese Variante legt ein anderes verhalten an den Tag. Die Diplomatie WIRD
--- sich verändern, abhängig davon, ob das Schiff im Hafen ist (Handelspartner) 
--- oder nicht (Bekannt). Außerdem kann der fahrende Händler nur eine Route
--- haben und wird Standardnachrichten zum verbleib des Schiffs senden.
--- 
--- #### Aufbau Handelsroute:
--- * `PlayerID` - ID des Spielers
--- * `Path` - Liste der Wegpunkte
--- * `Offers` - Liste der Angebote (Format: {_Type, _Amount})
--- * `Amount` - Anzahl der Angebote, die bei der Ankunft ausgewählt werden sollen
--- * `Duration` - Ankerzeit des Schiffes in Sekunden
--- * `Interval` - Zeit zwischen Schiffsbesuchen
--- * `Message` - Benachrichtungungen über Schiff ein-/ausschalten
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
--- @param _Route table Beschreibung des fahrenden Händlers
function InitTravelingSalesman(_PlayerID, _Route)
end
API.InitTravelingSalesman = InitTravelingSalesman;

--- Entfernt den fahrenden Händler aus dem Lagerhaus des Spielers. Auch Schiffe,
--- die sich derzeit auf der Karte befinden, werden gelöscht.
--- @param _PlayerID integer ID des Spielers
function DisposeTravelingSalesman(_PlayerID)
end
API.DisposeTravelingSalesman = DisposeTravelingSalesman;

--- Ändert die Angebote einer bestehenden Handelsroute.
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
--- @param _PlayerID integer ID des Spielers
--- @param _Offers table Angebote
function ChangeTravelingSalesmanGoods(_PlayerID, _Offers)
end
API.ChangeTravelingSalesmanGoods = ChangeTravelingSalesmanGoods;



--- Ein Schiff wurde am Anfang des Weges der Handelsroute erzeugt.
---
--- #### Parameters:
--- * `_PlayerID`:  <b>integer</b> PlayerID des Hafens
--- * `_RouteName`: <b>string</b> Kennung der Route
--- * `_ShipID`:    <b>integer</b> ID des Schiffes
Report.TradeShipSpawned = anyInteger;

--- Ein Schiff ist in einem Hafen angekommen.
---
--- #### Parameters:
--- * `_PlayerID`:  <b>integer</b> PlayerID des Hafens
--- * `_RouteName`: <b>string</b> Kennung der Route
--- * `_ShipID`:    <b>integer</b> ID des Schiffes
Report.TradeShipArrived = anyInteger;

--- Ein Schiff hat einen Hafen verlassen.
---
--- #### Parameters:
--- * `_PlayerID`:  <b>integer</b> PlayerID des Hafens
--- * `_RouteName`: <b>string</b> Kennung der Route
--- * `_ShipID`:    <b>integer</b> ID des Schiffes
Report.TradeShipLeft = anyInteger;

--- Ein Schiff wurde am Ende des Weges der Handelsroute entfernt.
---
--- #### Parameters:
--- * `_PlayerID`:  <b>integer</b> PlayerID des Hafens
--- * `_RouteName`: <b>string</b> Kennung der Route
--- * `_ShipID`:    <b>integer</b> ID des Schiffes
Report.TradeShipDespawned = anyInteger;

