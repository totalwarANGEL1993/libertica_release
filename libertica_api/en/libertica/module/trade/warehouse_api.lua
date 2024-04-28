--- Allows to create warehouses.
---
--- Warehouses are modified tradeposts where the player can buy goods without
--- an AI player involved. But goods can not be sold to the warehouse. Payment
--- can be set to any type of resource.
---
--- #### Reports
--- * `Report.WarehouseOfferClicked` - The player clicked an offer.
--- * `Report.WarehouseOfferBought` - The player bought an offer.
---
Lib.Warehouse = Lib.Warehouse or {};



--- Defines a tradepost construction site as warehouse.
---
--- #### Config parameters
--- * `ScriptName` - Script name of construction site
--- * `Offers`     - List of offers (max. 6 visible offers)
---
--- #### Examples
--- ```lua
--- CreateWarehouse {
---     ScriptName       = "TP3",
---     Offers           = {
---         -- Resource offer
---         {Amount      = 3,
---          GoodType    = Goods.G_Iron,
---          BasePrice   = 80},
---         -- Product offer
---         {Amount      = 3,
---          GoodType    = Goods.G_Sausage,
---          BasePrice   = 150},
---         -- Luxury offer
---         {Amount      = 3,
---          GoodType    = Goods.G_Gems,
---          GoodAmount  = 27,
---          BasePrice   = 300},
---         -- Entertainer offer
---         {GoodType    = Entities.U_Entertainer_NA_FireEater,
---          BasePrice   = 250,
---          Refresh     = 500},
---         -- Mercenary offer
---         {Amount      = 3,
---          GoodType    = Entities.U_MilitaryBandit_Melee_ME,
---          PaymentType = Goods.G_Iron,
---          BasePrice   = 3},
---         -- Mercenary offer
---         {Amount      = 3,
---          GoodType    = Entities.U_CatapultCart,
---          BasePrice   = 1000},
---     },
--- };
--- ```
---
--- @param _Data table Config of warehouse
function CreateWarehouse(_Data)
end
API.CreateWarehouse = CreateWarehouse;

--- Creates an offer for the warehouse.
--- @param _Name string                     Scriptname of warehouse
--- @param _Amount integer                  Amount of offers
--- @param _GoodOrEntityType integer        Type of offered good or entity
--- @param __GoodOrEntityTypeAmount integer Amount of sold (only goods)
--- @param _Payment integer                 Type of paymend good (resource only)
--- @param _BasePrice integer               Basic price without inflation
--- @param _Refresh integer                 Time until offer respawns (0 = no respawn)
--- @return integer ID ID of offer or 0 on error
function CreateWarehouseOffer(_Name, _Amount, _GoodOrEntityType, __GoodOrEntityTypeAmount, _Payment, _BasePrice, _Refresh)
    return 0;
end
API.CreateWarehouseOffer = CreateWarehouseOffer;

--- Removes the offer from the warehouse.
--- @param _Name string Scriptname of warehouse
--- @param _ID integer ID of offer
function RemoveWarehouseOffer(_Name, _ID)
end
API.RemoveWarehouseOffer = RemoveWarehouseOffer;

--- Removes the offer from the warehouse.
--- @param _Name string Scriptname of warehouse
--- @param _ID integer ID of offer
--- @param _Deactivate boolean Offer is deactivated
function DeactivateWarehouseOffer(_Name, _ID, _Deactivate)
end
API.DeactivateWarehouseOffer = DeactivateWarehouseOffer;

--- Returns the global inflation for the good or entity type.
--- @param _PlayerID integer ID of player
--- @param _GoodOrEntityType integer Offer type
--- @return number Inflation Inflation factor
function GetWarehouseInflation(_PlayerID, _GoodOrEntityType)
    return 0;
end
API.GetWarehouseInflation = GetWarehouseInflation;

--- Changes the global inflation for the good or entity type.
--- @param _PlayerID integer ID of player
--- @param _GoodOrEntityType integer Offer type
--- @param _Inflation number Inflation factor
function SetWarehouseInflation(_PlayerID, _GoodOrEntityType, _Inflation)
end
API.SetWarehouseInflation = SetWarehouseInflation;

--- Returns offer data and index in offer table of the offer.
--- @param _Name string Scriptname of warehouse
--- @param _ID integer ID of offer
--- @return table Offer Data of offer
--- @return integer Index Index in table
function GetWarehouseOfferByID(_Name, _ID)
    return 0;
end
API.GetWarehouseOfferByID = GetWarehouseOfferByID;

--- Returns all active offers of the warehouse.
--- @param _Name string Scriptname of warehouse
--- @param _VisibleOnly boolean Only the visible offers
--- @return table Offers List of active offers
function GetActivWarehouseOffers(_Name, _VisibleOnly)
    return {};
end
API.GetActivWarehouseOffers = GetActivWarehouseOffers;



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
Report.WarehouseOfferClicked = anyInteger;

--- The player bought an offer.
---
--- #### Parameter
--- * `PlayerID`      - ID of player
--- * `ScriptName`    - Scriptname of warehouse
--- * `OfferGood`     - Good or entity type purchased
--- * `GoodAmount`    - Amount of goods
--- * `PaymentGood`   - Good of payment
--- * `PaymentAmount` - Amount of payment
Report.WarehouseOfferBought = anyInteger;

