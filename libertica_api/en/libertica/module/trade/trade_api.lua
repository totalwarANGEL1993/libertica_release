--- This module allows manipulation of buying and selling.
---
--- The structure of offers can be inspected and modified. You can delete
--- individual offers or adjust their quantities.
---
--- The calculation of buying and selling prices can be customized.
--- This allows you to strengthen or weaken Elias' ability as well.



--- Adds a regular offer to a player.
--- @param _VendorID integer ID of the player
--- @param _OfferType integer Type of the offer
--- @param _OfferAmount integer Amount of the offer
--- @param _RefreshRate integer Refresh rate
--- @return integer ID ID of the offer
function CreateGoodOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    return 0;
end
API.AddGoodOffer = CreateGoodOffer;

--- Adds a mercenary offer to a player.
--- @param _VendorID integer ID of the player
--- @param _OfferType integer Type of the offer
--- @param _OfferAmount integer Amount of the offer
--- @param _RefreshRate integer Refresh rate
--- @return integer ID ID of the offer
function CreateMercenaryOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    return 0;
end
API.AddMercenaryOffer = CreateMercenaryOffer;

--- Adds an entertainer offer to a player.
--- @param _VendorID integer ID of the player
--- @param _OfferType integer Type of the offer
function CreateEntertainerOffer(_VendorID, _OfferType)
    return 0;
end
API.AddEntertainerOffer = CreateEntertainerOffer;

--- Changes the calculation of the trader price factor for the player.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_BasePrice`: <b>integer</b> Base price
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _PlayerID integer Player ID
--- @param _Function function Calculation function
function PurchaseSetTraderAbilityForPlayer(_PlayerID, _Function)
end
API.PurchaseSetTraderAbilityForPlayer = PurchaseSetTraderAbilityForPlayer;

--- Changes the calculation of the trader price factor.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_BasePrice`: <b>integer</b> Base price
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _Function function Calculation function
function PurchaseSetDefaultTraderAbility(_Function)
end
API.PurchaseSetDefaultTraderAbility = PurchaseSetDefaultTraderAbility;

--- Changes the calculation of the base purchase price for the player.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _PlayerID integer Player ID
--- @param _Function function Calculation function
function PurchaseSetBasePriceForPlayer(_PlayerID, _Function)
end
API.PurchaseSetBasePriceForPlayer = PurchaseSetBasePriceForPlayer;

--- Changes the calculation of the base purchase price.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _Function function Calculation function
function PurchaseSetDefaultBasePrice(_Function)
end
API.PurchaseSetDefaultBasePrice = PurchaseSetDefaultBasePrice;

--- Changes the calculation of inflation for the player.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_Amount`: <b>integer</b> Amount already bought
--- * `_Price`: <b>integer</b> Purchase price
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _PlayerID integer Player ID
--- @param _Function function Calculation function
function PurchaseSetInflationForPlayer(_PlayerID, _Function)
end
API.PurchaseSetInflationForPlayer = PurchaseSetInflationForPlayer;

--- Changes the calculation of inflation.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_Amount`: <b>integer</b> Amount already bought
--- * `_Price`: <b>integer</b> Purchase price
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _Function function Calculation function
function PurchaseSetDefaultInflation(_Function)
end
API.PurchaseSetDefaultInflation = PurchaseSetDefaultInflation;

--- Sets special purchase conditions for the player.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_Amount`: <b>integer</b> Amount already bought
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _PlayerID integer Player ID
--- @param _Function function Calculation function
function PurchaseSetConditionForPlayer(_PlayerID, _Function)
end
API.PurchaseSetConditionForPlayer = PurchaseSetConditionForPlayer;

--- Sets special purchase conditions.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_Amount`: <b>integer</b> Amount already bought
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _Function function Calculation function
function PurchaseSetDefaultCondition(_Function)
end
API.PurchaseSetDefaultCondition = PurchaseSetDefaultCondition;

--- Changes the calculation of the sale price factor for the player.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_BasePrice`: <b>integer</b> Base price
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _PlayerID integer Player ID
--- @param _Function function Calculation function
function SaleSetTraderAbilityForPlayer(_PlayerID, _Function)
end
API.SaleSetTraderAbilityForPlayer = SaleSetTraderAbilityForPlayer;

--- Changes the calculation of the sale price factor.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_BasePrice`: <b>integer</b> Base price
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _Function function Calculation function
function SaleSetDefaultTraderAbility(_Function)
end
API.SaleSetDefaultTraderAbility = SaleSetDefaultTraderAbility;

--- Changes the calculation of the base selling price for the player.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _PlayerID integer Player ID
--- @param _Function function Calculation function
function SaleSetBasePriceForPlayer(_PlayerID, _Function)
end
API.SaleSetBasePriceForPlayer = SaleSetBasePriceForPlayer;

--- Changes the calculation of the base selling price.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _Function function Calculation function
function SaleSetDefaultBasePrice(_Function)
end
API.SaleSetDefaultBasePrice = SaleSetDefaultBasePrice;

--- Changes the calculation of deflation for the player.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_SaleCount`: <b>integer</b> Amount already sold
--- * `_Price`: <b>integer</b> Selling price
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _PlayerID integer Player ID
--- @param _Function function Calculation function
function SaleSetDeflationForPlayer(_PlayerID, _Function)
end
API.SaleSetDeflationForPlayer = SaleSetDeflationForPlayer;

--- Changes the calculation of deflation.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_SaleCount`: <b>integer</b> Amount already sold
--- * `_Price`: <b>integer</b> Selling price
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _Function function Calculation function
function SaleSetDefaultDeflation(_Function)
end
API.SaleSetDefaultDeflation = SaleSetDefaultDeflation;

--- Sets special selling conditions for the player.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_Amount`: <b>integer</b> Amount sold
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _PlayerID integer Player ID
--- @param _Function function Calculation function
function SaleSetConditionForPlayer(_PlayerID, _Function)
end
API.SaleSetConditionForPlayer = SaleSetConditionForPlayer;

--- Sets special selling conditions.
---
--- #### Parameters `_Function`:
--- * `_Type`: <b>integer</b> Type of vendor
--- * `_Good`: <b>integer</b> Type of offer
--- * `_Amount`: <b>integer</b> Amount sold
--- * `_PlayerID1`: <b>integer</b> Buying player ID
--- * `_PlayerID2`: <b>integer</b> Selling player ID
---
--- @param _Function function Calculation function
function SaleSetDefaultCondition(_Function)
end
API.SaleSetDefaultCondition = SaleSetDefaultCondition;

--- Returns information about the player's offers.
--- @param _PlayerID integer Player ID
--- @return table Info Offer information for the player
function GetOfferInformation(_PlayerID)
    return {};
end
API.GetOfferInformation = GetOfferInformation;

--- Returns the number of offers the player has.
--- @param _PlayerID integer Player ID
--- @return integer Amount Number of offer slots
function GetOfferCount(_PlayerID)
    return 0;
end
API.GetOfferCount = GetOfferCount;

--- Returns whether the good or unit is offered by the player.
--- @param _PlayerID integer Player ID
--- @param _GoodOrEntityType integer 
--- @return boolean Offered Good or unit is offered
function IsGoodOrUnitOffered(_PlayerID, _GoodOrEntityType)
    return true;
end
API.IsGoodOrUnitOffered = IsGoodOrUnitOffered;

--- Returns the number of available wagon loads of the offer.
--- @param _PlayerID integer Player ID
--- @param _GoodOrEntityType integer Type of good or unit
--- @return integer Amount Number of offered wagons
function GetTradeOfferWaggonAmount(_PlayerID, _GoodOrEntityType)
    return 0;
end
API.GetTradeOfferWaggonAmount = GetTradeOfferWaggonAmount;

--- Removes a specific trade offer from the player.
--- @param _PlayerID integer Player ID
--- @param _GoodOrEntityType integer Type of good or unit
function RemoveTradeOffer(_PlayerID, _GoodOrEntityType)
end
API.RemoveTradeOffer = RemoveTradeOffer;

--- Changes the maximum number of wagon loads for the offer.
--- @param _PlayerID integer Player ID
--- @param _GoodOrEntityType integer Type of good or unit
--- @param _NewAmount integer New maximum amount
function ModifyTradeOffer(_PlayerID, _GoodOrEntityType, _NewAmount)
end
API.ModifyTradeOffer = ModifyTradeOffer;

--- A player has purchased an offer at a warehouse.
---
--- #### Parameters:
--- * `_OfferIndex`: <b>integer</b> Offer index
--- * `_MerchantType`: <b>integer</b> Type of vendor
--- * `_Type`: <b>integer</b> Type of offer
--- * `_Amount`: <b>integer</b> Quantity purchased
--- * `_Price`: <b>integer</b> Price paid
--- * `_PlayerID`: <b>integer</b> Player ID
--- * `_PartnerID`: <b>integer</b> Partner ID
Report.Purchased = anyInteger;

--- A player has sold goods to another player.
---
--- #### Parameters:
--- * `_MerchantType`: <b>integer</b> Type of vendor
--- * `_GoodType`: <b>integer</b> Type of offer
--- * `_GoodAmount`: <b>integer</b> Quantity sold
--- * `_Price`: <b>integer</b> Money received
--- * `_PlayerID`: <b>integer</b> Player ID
--- * `_PartnerID`: <b>integer</b> Partner ID
Report.GoodsSold = anyInteger;

