--- Allows to manipulate buying and selling of goods and units.



--- Adds a regular good offer to a player.
--- @param _VendorID integer ID of player
--- @param _OfferType integer Type of offer
--- @param _OfferAmount integer Amount of offer
--- @param _RefreshRate integer Refresh rate
--- @return integer ID ID of offer
function CreateGoodOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    return 0;
end
API.AddGoodOffer = CreateGoodOffer;

--- Adds a mercenary offer to a player.
--- @param _VendorID integer ID of player
--- @param _OfferType integer Type of offer
--- @param _OfferAmount integer Amount of offer
--- @param _RefreshRate integer Refresh rate
--- @return integer ID ID of offer
function CreateMercenaryOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    return 0;
end
API.AddMercenaryOffer = CreateMercenaryOffer;

--- Adds a entertainer offer to a player.
--- @param _VendorID integer ID of player
--- @param _OfferType integer Type of offer
function CreateEntertainerOffer(_VendorID, _OfferType)
    return 0;
end
API.AddEntertainerOffer = CreateEntertainerOffer;

--- Changes the calculation of the hero purchase price factor for the player.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_BasePrice` - Base price
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _PlayerID integer ID of player
--- @param _Function function Calculation function
function PurchaseSetTraderAbilityForPlayer(_PlayerID, _Function)
end
API.PurchaseSetTraderAbilityForPlayer = PurchaseSetTraderAbilityForPlayer;

--- Changes the calculation of the hero purchase price factor.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_BasePrice` - Base price
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _Function function Calculation function
function PurchaseSetDefaultTraderAbility(_Function)
end
API.PurchaseSetDefaultTraderAbility = PurchaseSetDefaultTraderAbility;

--- Changes the calculation of the purchase base price for the player.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _PlayerID integer ID of player
--- @param _Function function Calculation function
function PurchaseSetBasePriceForPlayer(_PlayerID, _Function)
end
API.PurchaseSetBasePriceForPlayer = PurchaseSetBasePriceForPlayer;

--- Changes the calculation of the purchase base price.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _Function function Calculation function
function PurchaseSetDefaultBasePrice(_Function)
end
API.PurchaseSetDefaultBasePrice = PurchaseSetDefaultBasePrice;

--- Changes the calculation of the inflation for the player.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_Amount` - Already purchased amount
--- * `_Price` - Purchase price
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _PlayerID integer ID of player
--- @param _Function function Calculation function
function PurchaseSetInflationForPlayer(_PlayerID, _Function)
end
API.PurchaseSetInflationForPlayer = PurchaseSetInflationForPlayer;

--- Changes the calculation of the inflation.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_Amount` - Already purchased amount
--- * `_Price` - Purchase price
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _Function function Calculation function
function PurchaseSetDefaultInflation(_Function)
end
API.PurchaseSetDefaultInflation = PurchaseSetDefaultInflation;

--- Sets special purchase conditions for the player.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_Amount` - Already purchased amount
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _PlayerID integer ID of player
--- @param _Function function Calculation function
function PurchaseSetConditionForPlayer(_PlayerID, _Function)
end
API.PurchaseSetConditionForPlayer = PurchaseSetConditionForPlayer;

--- Sets special purchase conditions.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_Amount` - Already purchased amount
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _Function function Calculation function
function PurchaseSetDefaultCondition(_Function)
end
API.PurchaseSetDefaultCondition = PurchaseSetDefaultCondition;

--- Changes the calculation of the hero selling price factor for the player.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_BasePrice` - Base price
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _PlayerID integer ID of player
--- @param _Function function Calculation function
function SaleSetTraderAbilityForPlayer(_PlayerID, _Function)
end
API.SaleSetTraderAbilityForPlayer = SaleSetTraderAbilityForPlayer;

--- Changes the calculation of the hero selling price factor.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_BasePrice` - Base price
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _Function function Calculation function
function SaleSetDefaultTraderAbility(_Function)
end
API.SaleSetDefaultTraderAbility = SaleSetDefaultTraderAbility;

--- Changes the calculation of the selling base price for the player.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _PlayerID integer ID of player
--- @param _Function function Calculation function
function SaleSetBasePriceForPlayer(_PlayerID, _Function)
end
API.SaleSetBasePriceForPlayer = SaleSetBasePriceForPlayer;

--- Changes the calculation of the selling base price.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _Function function Calculation function
function SaleSetDefaultBasePrice(_Function)
end
API.SaleSetDefaultBasePrice = SaleSetDefaultBasePrice;

--- Changes the calculation of the deflation for the player.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_SaleCount` - Already sold amount
--- * `_Price` - Selling price
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _PlayerID integer ID of player
--- @param _Function function Calculation function
function SaleSetDeflationForPlayer(_PlayerID, _Function)
end
API.SaleSetDeflationForPlayer = SaleSetDeflationForPlayer;

--- Changes the calculation of the deflation.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_SaleCount` - Already sold amount
--- * `_Price` - Selling price
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _Function function Calculation function
function SaleSetDefaultDeflation(_Function)
end
API.SaleSetDefaultDeflation = SaleSetDefaultDeflation;

--- Sets special sale conditions for the player.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_Amount` - Sold amount
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _PlayerID integer ID of player
--- @param _Function function Calculation function
function SaleSetConditionForPlayer(_PlayerID, _Function)
end
API.SaleSetConditionForPlayer = SaleSetConditionForPlayer;

--- Sets special sale conditions.
--- 
--- Parameter of the function:
--- * `_Type` - Type of trader
--- * `_Good` - Type of offer
--- * `_Amount` - Sold amount
--- * `_PlayerID1` - ID pf purchasing player
--- * `_PlayerID2` - ID of selling player
--- 
--- @param _Function function Calculation function
function SaleSetDefaultCondition(_Function)
end
API.SaleSetDefaultCondition = SaleSetDefaultCondition;

--- Returns informations about the offers of the player.
--- @param _PlayerID integer ID of player
--- @return table Info Offer information for player
function GetOfferInformation(_PlayerID)
    return {};
end
API.GetOfferInformation = GetOfferInformation;

--- Returns the amount of offers of the player.
--- @param _PlayerID integer ID of player
--- @return integer Amount Amount of offer slots
function GetOfferCount(_PlayerID)
    return 0;
end
API.GetOfferCount = GetOfferCount;

--- Returns if the good or the unit is offered by the player.
--- @param _PlayerID integer ID of player
--- @param _GoodOrEntityType integer 
--- @return boolean Offered Good or entity is offered
function IsGoodOrUnitOffered(_PlayerID, _GoodOrEntityType)
    return true;
end
API.IsGoodOrUnitOffered = IsGoodOrUnitOffered;

--- Returns the amound of available waggon loads of the offer.
--- @param _PlayerID integer ID of player
--- @param _GoodOrEntityType integer Good or entity type
--- @return integer Amount Amount of waggons offered
function GetTradeOfferWaggonAmount(_PlayerID, _GoodOrEntityType)
    return 0;
end
API.GetTradeOfferWaggonAmount = GetTradeOfferWaggonAmount;

--- Deletes a specific trade offer of the player.
--- @param _PlayerID integer ID of player
--- @param _GoodOrEntityType integer Good or entity type
function RemoveTradeOffer(_PlayerID, _GoodOrEntityType)
end
API.RemoveTradeOffer = RemoveTradeOffer;

--- Changes the max amount of waggon loads of the offer.
--- @param _PlayerID integer ID of player
--- @param _GoodOrEntityType integer Good or entity type
--- @param _NewAmount integer New max amount
function ModifyTradeOffer(_PlayerID, _GoodOrEntityType, _NewAmount)
end
API.ModifyTradeOffer = ModifyTradeOffer;



--- A player purchased an offer from a storehouse.
---
--- #### Parameters:
--- * `_OfferIndex` - Index of offer
--- * `_MerchantType` - Type of merchant
--- * `_Type` - Type of offer
--- * `_Amount` - Amount of offer
--- * `_Price` - price payed
--- * `_PlayerID` - PlayerID des Hafens
--- * `_PartnerID` - ID of partner
Report.Purchased = anyInteger;

--- A player has sold goods to another player.
---
--- #### Parameters:
--- * `_MerchantType` - Type of merchant
--- * `_GoodType` - Type of good
--- * `_GoodAmount` - Amount of good
--- * `_Price` - selling price
--- * `_PlayerID` - ID of player
--- * `_TargetID` - ID of partner
Report.GoodsSold = anyInteger;

