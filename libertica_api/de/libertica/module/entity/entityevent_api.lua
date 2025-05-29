--- Fügt nützliche Berichte zu Entitäten hinzu.



--- Aktiviert/Deaktiviert die Sabotage eines Lagerhauses durch Diebe.
--- @param _Flag boolean Aktivieren/Deaktivieren
function ThiefDisableStorehouseEffect(_Flag)
end
API.ThiefDisableStorehouseEffect = ThiefDisableStorehouseEffect;

--- Aktiviert/Deaktiviert Die Sabotage einer Kirche durch Diebe.
--- @param _Flag boolean Aktivieren/Deaktivieren
function ThiefDisableCathedralEffect(_Flag)
end
API.ThiefDisableCathedralEffect = ThiefDisableCathedralEffect;

--- Aktiviert/Deaktiviert Die Sabotage von Brunnen durch Diebe.
---
--- (Benötigt das Addon "Reich des Ostens")
---
--- @param _Flag boolean Aktivieren/Deaktivieren
function ThiefDisableCisternEffect(_Flag)
end
API.ThiefDisableCisternEffect = ThiefDisableCisternEffect;



--- Eine Entität wurde erschaffen.
---
--- #### Parameters:
--- * `EntityID` - ID der Entität
--- * `PlayerID` - ID des Spielers
--- * `SpawnerID` - ID des Spawners
Report.EntitySpawned = anyInteger;

--- Ein Siedler ist der Siedlung beigetreten.
---
--- #### Parameters:
--- * `EntityID` - ID der Entität
--- * `PlayerID` - ID des Spielers
Report.SettlerAttracted = anyInteger;

--- Eine Entität wurde auf irgendeine Weise zerstört.
---
--- #### Parameters:
--- * `EntityID` - ID der Entität
--- * `PlayerID` - ID des Spielers
Report.EntityDestroyed = anyInteger;

--- Eine Entität wurde verletzt.
---
--- #### Parameters:
--- * `AttackingEntityID` - ID der angreifenden Entität
--- * `AttackingPlayerID` - Besitzer der angreifenden Entität
--- * `AttackedEntityID` - ID der angegriffenen Entität
--- * `AttackedPlayerID` - Besitzer der angegriffenen Entität
Report.EntityHurt = anyInteger;

--- Eine Entität wurde getötet.
---
--- #### Parameters:
--- * `KilledEntityID` - ID der getöteten Entität
--- * `KilledPlayerID` - Besitzer der getöteten Entität
--- * `KillerEntityID` - ID der tötenden Entität
--- * `KillerPlayerID` - Besitzer der tötenden Entität
Report.EntityKilled = anyInteger;

--- Der Besitz einer Entität hat sich geändert.
---
--- #### Parameters:
--- * `OldIDList` - Liste der alten Entitäts-IDs
--- * `OldPlayer` - Vorheriger Besitzer
--- * `NewIDList` - Liste der neuen Entitäts-IDs
--- * `NewPlayer` - Neuer Besitzer
Report.EntityOwnerChanged = anyInteger;

--- Die Menge an Ressourcen in der Entität hat sich geändert.
---
--- #### Parameters:
--- * `EntityID` - ID der Entität
--- * `GoodType` - Art der Ressource
--- * `OldAmount` - Alte Menge
--- * `NewAmount` - Neue Menge
Report.EntityResourceChanged = anyInteger;

--- Der Bau eines Gebäudes wurde abgeschlossen.
---
--- #### Parameters:
--- * `BuildingID` - ID des Gebäudes
--- * `PlayerID` - ID des Spielers
Report.BuildingConstructed = anyInteger;

--- Ein Gebäudeupgrade wurde abgeschlossen.
---
--- #### Parameters:
--- * `BuildingID` - ID des Gebäudes
--- * `PlayerID` - ID des Spielers
--- * `NewUpgradeLevel` - Neues Upgrade-Level
Report.BuildingUpgraded = anyInteger;

--- Ein Upgrade-Level ist zusammengebrochen.
---
--- #### Parameters:
--- * `BuildingID` - ID des Gebäudes
--- * `PlayerID` - ID des Spielers
--- * `NewUpgradeLevel` - Neues Upgrade-Level
Report.BuildingUpgradeCollapsed = anyInteger;

--- Ein Gebäude wurde von einem Dieb infiltriert.
---
--- #### Parameters:
--- * `ThiefID` - ID des Diebes
--- * `PlayerID` - ID des Spielers
--- * `BuildingID` - ID des Gebäudes
--- * `BuildingPlayerID` - ID des Spielers des Gebäudes
Report.ThiefInfiltratedBuilding = anyInteger;

--- Ein Dieb hat Einnahmen geliefert.
---
--- #### Parameters:
--- * `ThiefID` - ID des Diebes
--- * `PlayerID` - ID des Spielers
--- * `BuildingID` - ID des Gebäudes
--- * `BuildingPlayerID` - ID des Spielers des Gebäudes
--- * `GoldAmount` - Menge an Gold
Report.ThiefDeliverEarnings = anyInteger;

