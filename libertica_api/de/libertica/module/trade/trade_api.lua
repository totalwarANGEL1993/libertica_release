--- Es kann in den Ablauf von Kauf und Verkauf eingegriffen werden.
---
--- #### Berichte
--- * `Report.GoodsPurchased` - Waren wurden von einem Spieler eingekauft
--- * `Report.GoodsSold` - Waren wurden an einen Spieler verkauft
Lib.Trade = Lib.Trade or {};



--- Fügt einem Spieler ein reguläres Angebot hinzu.
--- @param _VendorID integer ID des Spielers
--- @param _OfferType integer Art des Angebots
--- @param _OfferAmount integer Betrag des Angebots
--- @param _RefreshRate integer Aktualisierungsrate
--- @return integer ID ID des Angebots
function CreateGoodOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    return 0;
end
API.AddGoodOffer = CreateGoodOffer;

--- Fügt einem Spieler ein Söldnerangebot hinzu.
--- @param _VendorID integer ID des Spielers
--- @param _OfferType integer Art des Angebots
--- @param _OfferAmount integer Betrag des Angebots
--- @param _RefreshRate integer Aktualisierungsrate
--- @return integer ID ID des Angebots
function CreateMercenaryOffer(_VendorID, _OfferType, _OfferAmount, _RefreshRate)
    return 0;
end
API.AddMercenaryOffer = CreateMercenaryOffer;

--- Fügt einem Spieler ein Entertainer-Angebot hinzu.
--- @param _VendorID integer ID des Spielers
--- @param _OfferType integer Art des Angebots
function CreateEntertainerOffer(_VendorID, _OfferType)
    return 0;
end
API.AddEntertainerOffer = CreateEntertainerOffer;

--- Ändert die Berechnung des Helden-Kaufpreisfaktors für den Spieler.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_BasePrice` - Grundpreis
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _PlayerID integer ID des Spielers
--- @param _Function function Berechnungsfunktion
function PurchaseSetTraderAbilityForPlayer(_PlayerID, _Function)
end
API.PurchaseSetTraderAbilityForPlayer = PurchaseSetTraderAbilityForPlayer;

--- Ändert die Berechnung des Helden-Kaufpreisfaktors.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_BasePrice` - Grundpreis
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _Function function Berechnungsfunktion
function PurchaseSetDefaultTraderAbility(_Function)
end
API.PurchaseSetDefaultTraderAbility = PurchaseSetDefaultTraderAbility;

--- Ändert die Berechnung des Kauf-Grundpreises für den Spieler.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _PlayerID integer ID des Spielers
--- @param _Function function Berechnungsfunktion
function PurchaseSetBasePriceForPlayer(_PlayerID, _Function)
end
API.PurchaseSetBasePriceForPlayer = PurchaseSetBasePriceForPlayer;

--- Ändert die Berechnung des Kauf-Grundpreises.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _Function function Berechnungsfunktion
function PurchaseSetDefaultBasePrice(_Function)
end
API.PurchaseSetDefaultBasePrice = PurchaseSetDefaultBasePrice;

--- Ändert die Berechnung der Inflation für den Spieler.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_Amount` - Bereits gekaufter Betrag
--- * `_Price` - Kaufpreis
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _PlayerID integer ID des Spielers
--- @param _Function function Berechnungsfunktion
function PurchaseSetInflationForPlayer(_PlayerID, _Function)
end
API.PurchaseSetInflationForPlayer = PurchaseSetInflationForPlayer;

--- Ändert die Berechnung der Inflation.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_Amount` - Bereits gekaufter Betrag
--- * `_Price` - Kaufpreis
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _Function function Berechnungsfunktion
function PurchaseSetDefaultInflation(_Function)
end
API.PurchaseSetDefaultInflation = PurchaseSetDefaultInflation;

--- Setzt spezielle Kaufbedingungen für den Spieler.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_Amount` - Bereits gekaufter Betrag
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _PlayerID integer ID des Spielers
--- @param _Function function Berechnungsfunktion
function PurchaseSetConditionForPlayer(_PlayerID, _Function)
end
API.PurchaseSetConditionForPlayer = PurchaseSetConditionForPlayer;

--- Setzt spezielle Kaufbedingungen.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_Amount` - Bereits gekaufter Betrag
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _Function function Berechnungsfunktion
function PurchaseSetDefaultCondition(_Function)
end
API.PurchaseSetDefaultCondition = PurchaseSetDefaultCondition;

--- Ändert die Berechnung des Helden-Verkaufspreisfaktors für den Spieler.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_BasePrice` - Grundpreis
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _PlayerID integer ID des Spielers
--- @param _Function function Berechnungsfunktion
function SaleSetTraderAbilityForPlayer(_PlayerID, _Function)
end
API.SaleSetTraderAbilityForPlayer = SaleSetTraderAbilityForPlayer;

--- Ändert die Berechnung des Helden-Verkaufspreisfaktors.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_BasePrice` - Grundpreis
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _Function function Berechnungsfunktion
function SaleSetDefaultTraderAbility(_Function)
end
API.SaleSetDefaultTraderAbility = SaleSetDefaultTraderAbility;

--- Ändert die Berechnung des Verkaufs-Grundpreises für den Spieler.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _PlayerID integer ID des Spielers
--- @param _Function function Berechnungsfunktion
function SaleSetBasePriceForPlayer(_PlayerID, _Function)
end
API.SaleSetBasePriceForPlayer = SaleSetBasePriceForPlayer;

--- Ändert die Berechnung des Verkaufs-Grundpreises.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _Function function Berechnungsfunktion
function SaleSetDefaultBasePrice(_Function)
end
API.SaleSetDefaultBasePrice = SaleSetDefaultBasePrice;

--- Ändert die Berechnung der Deflation für den Spieler.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_SaleCount` - Bereits verkaufter Betrag
--- * `_Price` - Verkaufspreis
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _PlayerID integer ID des Spielers
--- @param _Function function Berechnungsfunktion
function SaleSetDeflationForPlayer(_PlayerID, _Function)
end
API.SaleSetDeflationForPlayer = SaleSetDeflationForPlayer;

--- Ändert die Berechnung der Deflation.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_SaleCount` - Bereits verkaufter Betrag
--- * `_Price` - Verkaufspreis
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _Function function Berechnungsfunktion
function SaleSetDefaultDeflation(_Function)
end
API.SaleSetDefaultDeflation = SaleSetDefaultDeflation;

--- Setzt spezielle Verkaufsbedingungen für den Spieler.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_Amount` - Verkaufter Betrag
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _PlayerID integer ID des Spielers
--- @param _Function function Berechnungsfunktion
function SaleSetConditionForPlayer(_PlayerID, _Function)
end
API.SaleSetConditionForPlayer = SaleSetConditionForPlayer;

--- Setzt spezielle Verkaufsbedingungen.
--- 
--- Parameter der Funktion:
--- * `_Type` - Art des Händlers
--- * `_Good` - Art des Angebots
--- * `_Amount` - Verkaufter Betrag
--- * `_PlayerID1` - ID des kaufenden Spielers
--- * `_PlayerID2` - ID des verkaufenden Spielers
--- 
--- @param _Function function Berechnungsfunktion
function SaleSetDefaultCondition(_Function)
end
API.SaleSetDefaultCondition = SaleSetDefaultCondition;

--- Gibt Informationen über die Angebote des Spielers zurück.
--- @param _PlayerID integer ID des Spielers
--- @return table Info Angebotsinformationen für den Spieler
function GetOfferInformation(_PlayerID)
    return {};
end
API.GetOfferInformation = GetOfferInformation;

--- Gibt die Anzahl der Angebote des Spielers zurück.
--- @param _PlayerID integer ID des Spielers
--- @return integer Amount Anzahl der Angebotsplätze
function GetOfferCount(_PlayerID)
    return 0;
end
API.GetOfferCount = GetOfferCount;

--- Gibt zurück, ob das Gut oder die Einheit vom Spieler angeboten wird.
--- @param _PlayerID integer ID des Spielers
--- @param _GoodOrEntityType integer 
--- @return boolean Offered Gut oder Einheit wird angeboten
function IsGoodOrUnitOffered(_PlayerID, _GoodOrEntityType)
    return true;
end
API.IsGoodOrUnitOffered = IsGoodOrUnitOffered;

--- Gibt die Anzahl der verfügbaren Wagenladungen des Angebots zurück.
--- @param _PlayerID integer ID des Spielers
--- @param _GoodOrEntityType integer Gut- oder Einheitstyp
--- @return integer Amount Anzahl der angebotenen Wagen
function GetTradeOfferWaggonAmount(_PlayerID, _GoodOrEntityType)
    return 0;
end
API.GetTradeOfferWaggonAmount = GetTradeOfferWaggonAmount;

--- Löscht ein bestimmtes Handelsangebot des Spielers.
--- @param _PlayerID integer ID des Spielers
--- @param _GoodOrEntityType integer Gut- oder Einheitstyp
function RemoveTradeOffer(_PlayerID, _GoodOrEntityType)
end
API.RemoveTradeOffer = RemoveTradeOffer;

--- Ändert die maximale Anzahl der Wagenladungen des Angebots.
--- @param _PlayerID integer ID des Spielers
--- @param _GoodOrEntityType integer Gut- oder Einheitstyp
--- @param _NewAmount integer Neuer maximaler Betrag
function ModifyTradeOffer(_PlayerID, _GoodOrEntityType, _NewAmount)
end
API.ModifyTradeOffer = ModifyTradeOffer;



--- Ein Spieler hat ein Angebot in einem Lagerhaus gekauft
---
--- #### Parameter
--- * `_OfferIndex` - Index des Angebot
--- * `_MerchantType` - Typ des Händlers
--- * `_Type` - Typ des Angebot
--- * `_Amount` - Gekaufte Menge
--- * `_Price` - Bezahlter Preis
--- * `_PlayerID` - ID des Spielers
--- * `_PartnerID` - ID des Partners
Report.Purchased = anyInteger;

--- A player has sold goods to another player.
---
--- #### Parameter
--- * `_MerchantType` - Typ des Händlers
--- * `_GoodType` - Typ des Angebot
--- * `_GoodAmount` - Verkaufte Menge
--- * `_Price` - Erhaltenes Geld
--- * `_PlayerID` - ID des Spielers
--- * `_PartnerID` - ID des Partners
Report.GoodsSold = anyInteger;

