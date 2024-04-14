--- Ermöglicht die Erstellung von Lagern.
---
--- Lager sind modifizierte Handelsposten, an denen der Spieler Waren ohne
--- Beteiligung eines KI-Spielers kaufen kann. Es können jedoch keine Waren an das Lager verkauft werden. Die Bezahlung
--- kann auf jeden beliebigen Ressourcentyp eingestellt werden.
---
Lib.Warehouse = Lib.Warehouse or {};



--- Definiert eine Baustelle für einen Handelsposten als Lager.
---
--- #### Konfigurationsparameter
--- * `ScriptName` - Skriptname der Baustelle
--- * `Offers`     - Liste der Angebote (max. 6 sichtbare Angebote)
---
--- #### Beispiele
--- ```lua
--- CreateWarehouse {
---     ScriptName       = "TP3",
---     Offers           = {
---         -- Ressourcenangebot
---         {Amount      = 3,
---          GoodType    = Goods.G_Iron,
---          BasePrice   = 80},
---         -- Produktangebot
---         {Amount      = 3,
---          GoodType    = Goods.G_Sausage,
---          BasePrice   = 150},
---         -- Luxusangebot
---         {Amount      = 3,
---          GoodType    = Goods.G_Gems,
---          GoodAmount  = 27,
---          BasePrice   = 300},
---         -- Unterhaltungsangebot
---         {GoodType    = Entities.U_Entertainer_NA_FireEater,
---          BasePrice   = 250,
---          Refresh     = 500},
---         -- Söldnerangebot
---         {Amount      = 3,
---          GoodType    = Entities.U_MilitaryBandit_Melee_ME,
---          PaymentType = Goods.G_Iron,
---          BasePrice   = 3},
---         -- Söldnerangebot
---         {Amount      = 3,
---          GoodType    = Entities.U_CatapultCart,
---          BasePrice   = 1000},
---     },
--- };
--- ```
---
--- @param _Data table Konfiguration des Lagers
function CreateWarehouse(_Data)
end
API.CreateWarehouse = CreateWarehouse;

--- Erstellt ein Angebot für das Lager.
--- @param _Name string                     Skriptname des Lagers
--- @param _Amount integer                  Anzahl der Angebote
--- @param _GoodOrEntityType integer        Typ des angebotenen Guts oder der Entität
--- @param __GoodOrEntityTypeAmount integer Menge der verkauften Ware (nur Güter)
--- @param _Payment integer                 Art des Zahlungsguts (nur Ressource)
--- @param _BasePrice integer               Grundpreis ohne Inflation
--- @param _Refresh integer                 Zeit, bis das Angebot wieder erscheint (0 = kein Wiederauftauchen)
--- @return integer ID ID des Angebots oder 0 bei Fehler
function CreateWarehouseOffer(_Name, _Amount, _GoodOrEntityType, __GoodOrEntityTypeAmount, _Payment, _BasePrice, _Refresh)
    return 0;
end
API.CreateWarehouseOffer = CreateWarehouseOffer;

--- Entfernt das Angebot aus dem Lager.
--- @param _Name string Skriptname des Lagers
--- @param _ID integer ID des Angebots
function RemoveWarehouseOffer(_Name, _ID)
end
API.RemoveWarehouseOffer = RemoveWarehouseOffer;

--- Deaktiviert das Angebot im Lager.
--- @param _Name string Skriptname des Lagers
--- @param _ID integer ID des Angebots
--- @param _Deactivate boolean Angebot ist deaktiviert
function DeactivateWarehouseOffer(_Name, _ID, _Deactivate)
end
API.DeactivateWarehouseOffer = DeactivateWarehouseOffer;

--- Gibt die globale Inflation für den Güter- oder Entitätstyp zurück.
--- @param _PlayerID integer Spieler-ID
--- @param _GoodOrEntityType integer Angebotstyp
--- @return number Inflation Inflationsfaktor
function GetWarehouseInflation(_PlayerID, _GoodOrEntityType)
    return 0;
end
API.GetWarehouseInflation = GetWarehouseInflation;

--- Ändert die globale Inflation für den Güter- oder Entitätstyp.
--- @param _PlayerID integer Spieler-ID
--- @param _GoodOrEntityType integer Angebotstyp
--- @param _Inflation number Inflationsfaktor
function SetWarehouseInflation(_PlayerID, _GoodOrEntityType, _Inflation)
end
API.SetWarehouseInflation = SetWarehouseInflation;

--- Gibt Daten des Angebots und den Index im Angebots-Array des Angebots zurück.
--- @param _Name string Skriptname des Lagers
--- @param _ID integer ID des Angebots
--- @return table Offer Daten des Angebots
--- @return integer Index Index im Array
function GetWarehouseOfferByID(_Name, _ID)
    return 0;
end
API.GetWarehouseOfferByID = GetWarehouseOfferByID;

--- Gibt alle aktiven Angebote des Lagers zurück.
--- @param _Name string Skriptname des Lagers
--- @param _VisibleOnly boolean Nur die sichtbaren Angebote
--- @return table Offers Liste der aktiven Angebote
function GetActivWarehouseOffers(_Name, _VisibleOnly)
    return {};
end
API.GetActivWarehouseOffers = GetActivWarehouseOffers;



--- Der Spieler hat auf ein Angebot geklickt.
---
--- #### Parameter
--- * `PlayerID`      - ID des Spielers
--- * `ScriptName`    - Skriptname des Lagers
--- * `Inflation`     - Berechnete Inflation
--- * `OfferIndex`    - Index des Angebots
--- * `OfferGood`     - Gekauftes Gut oder Entitätstyp
--- * `GoodAmount`    - Menge der Güter
--- * `PaymentType`   - Zahlungsgut
--- * `BasePrice`     - Grundpreis
Report.WarehouseOfferClicked = anyInteger;

--- Der Spieler hat ein Angebot gekauft.
---
--- #### Parameter
--- * `PlayerID`      - ID des Spielers
--- * `ScriptName`    - Skriptname des Lagers
--- * `OfferGood`     - Gekaufter Gut- oder Entitätstyp
--- * `GoodAmount`    - Menge der Güter
--- * `PaymentGood`   - Zahlungsgut
--- * `PaymentAmount` - Menge der Zahlung
Report.WarehouseOfferBought = anyInteger;

