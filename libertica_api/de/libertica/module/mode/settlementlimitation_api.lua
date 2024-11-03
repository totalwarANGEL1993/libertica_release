--- Implementiert härtere Baubeschwänkungen im Spiel.
---
--- Wird der Modus aktiviert, gelten die voreingestellten Standardregeln. Diese
--- können im begrenzten Ausmaß individualisiert werden.
---
--- Standardregeln:
--- * Die Gebäudeanzahl im Heimatgebiet ist nicht beschränkt.
--- * Stadtgebäude können nur auf dem Heimatgebiet gebaut werden.
--- * In Territorien können nur 3 Gebäude gebaut werden. 
--- * Jeder Gebäudetyp kann nur 1 mal pro Territorium gebaut werden.
--- * Wird der Außenposten ausgebaut, kann ein Gebäudetyp dauerhaft doppelt
---   im Territorium platziert werden.
--- * Bienenstöcke, Felder und Ziergebäude zählen nicht als Gebäude.
---
Lib.SettlementLimitation = Lib.SettlementLimitation or {};

--- Aktiviert/deaktiviert den Modus.
--- @param _Flag boolean Modus ist aktiv
function ActivateSettlementLimitation(_Flag)
end

--- Aktiviert oder deaktviert die Unterhaltskosten für Mauern.
--- @param _Flag boolean Mauern kosten Gold
function UseWallUpkeepCosts(_Flag)
end
API.UseWallUpkeepCosts = UseWallUpkeepCosts;

--- Aktiviert oder deaktviert den Verfall von Mauern bei nicht aufgebrachten
--- Unterhaltskosten. Unterhalt muss aktiv sein.
--- @param _Flag boolean Mauern verfallen
function UseWallDeteriation(_Flag)
end
API.UseWallDeteriation = UseWallDeteriation;

--- Setzt den Titel, ab dem Territorien entwickelt werden können.
--- @param _Title integer ID des Spielers
function RequireTitleToDevelopTerritory(_Title)
end

--- Erlaubt oder verbietet das Entwickeln von Territorien
--- @param _PlayerID integer ID des Spielers
--- @param _Allowed boolean Entwickeln erlaubt
function AllowDevelopTerritory(_PlayerID, _Allowed)
end

--- Setzt das allgemeine Gebäudelimit für den Spieler im Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _Territory any Name oder ID des Territoriums
--- @param _Limit integer Allgemeines Limit
function SetTerritoryBuildingLimit(_PlayerID, _Territory, _Limit)
end

--- Setzt das spezifische Limit des Gebäudetypen für den Spieler im Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _Territory any Name oder ID des Territoriums
--- @param _Type integer Typ des Gebäudes
--- @param _Limit integer Spezifisches Limit
function SetTerritoryBuildingTypeLimit(_PlayerID, _Territory, _Type, _Limit)
end

--- Setzt das allgemeine Gebäudelimit zurück.
--- @param _PlayerID integer ID des Spielers
--- @param _Territory any Name oder ID des Territoriums
function ClearTerritoryBuildingLimit(_PlayerID, _Territory)
end

--- Setzt das spezifische Limit des Gebäudetypen zurück.
--- @param _PlayerID integer ID des Spielers
--- @param _Territory any Name oder ID des Territoriums
--- @param _Type integer Typ des Gebäudes
function ClearTerritoryBuildingTypeLimit(_PlayerID, _Territory, _Type)
end

--- Ändert die Kosten für die Territoriumsentwicklung.
--- @param _CostType1 integer Rohstoff 1
--- @param _Amount1 integer Menge 1
--- @param _CostType2? integer (optional) Rohstoff 2
--- @param _Amount2? integer (optional) Menge 2
function SetTerritoryDevelopmentCost(_CostType1, _Amount1, _CostType2, _Amount2)
end

