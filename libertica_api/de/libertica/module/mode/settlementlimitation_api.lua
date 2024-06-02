--- Implementiert härtere Baubeschwänkungen im Spiel.
---
--- Wird der Modus aktiviert, gelden die voreingestellten Standardregeln. Diese
--- können im begrenzten Ausmaß individualisiert werden.
---
--- Standardregeln:
--- * Die Gebäudeanzahl im Heimatgebiet ist nicht beschränkt
--- * Stadtgebäude können nur auf dem Heimatgebiet gebaut werden
--- * In Territorien können nur 3 Gebäude gebaut werden. Dabei zählen Felder
---   und Bienenstöcke nicht als Gebäude.
--- * Jeder Gebäudetyp kann nur 1 mal pro Territorium gebaut werden.
--- * Territorien können einmalig für Gold verbessert werden. Verbessern eines
---   Territorium gewährt einen weiteren Gebäudeplatz.
---
Lib.SettlementLimitation = Lib.SettlementLimitation or {};

--- Aktiviert/deaktiviert den Modus.
--- @param _Flag boolean Modus ist aktiv
function ActivateSettlementLimitation(_Flag)
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

