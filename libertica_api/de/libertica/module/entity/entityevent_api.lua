--- Dieses Modul fügt Reports zu bestimmten Events bzgl. Entitäten hinzu.
--- 
--- Außerdem können die geskripteten Standardaktionen von Dieben deaktivert
--- und überschrieben werden.



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
--- * `EntityID`:  <b>integer</b> ID der Entität
--- * `PlayerID`:  <b>integer</b> ID des Spielers
--- * `SpawnerID`: <b>integer</b> ID des Spawners
Report.EntitySpawned = anyInteger;

--- Ein Siedler ist der Siedlung beigetreten.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID der Entität
--- * `PlayerID`: <b>integer</b> ID des Spielers
Report.SettlerAttracted = anyInteger;

--- Eine Entität wurde auf irgendeine Weise zerstört.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID der Entität
--- * `PlayerID`: <b>integer</b> ID des Spielers
Report.EntityDestroyed = anyInteger;

--- Eine Entität wurde verletzt.
---
--- #### Parameters:
--- * `AttackingEntityID`: <b>integer</b> ID der angreifenden Entität
--- * `AttackingPlayerID`: <b>integer</b> Besitzer der angreifenden Entität
--- * `AttackedEntityID`:  <b>integer</b> ID der angegriffenen Entität
--- * `AttackedPlayerID`:  <b>integer</b> Besitzer der angegriffenen Entität
Report.EntityHurt = anyInteger;

--- Eine Entität wurde getötet.
---
--- #### Parameters:
--- * `KilledEntityID`: <b>integer</b> ID der getöteten Entität
--- * `KilledPlayerID`: <b>integer</b> Besitzer der getöteten Entität
--- * `KillerEntityID`: <b>integer</b> ID der tötenden Entität
--- * `KillerPlayerID`: <b>integer</b> Besitzer der tötenden Entität
Report.EntityKilled = anyInteger;

--- Der Besitz einer Entität hat sich geändert.
---
--- #### Parameters:
--- * `OldID`:     <b>integer</b> Alte ID
--- * `OldPlayer`: <b>integer</b> Vorheriger Besitzer
--- * `NewID `:    <b>integer</b> Neue ID
--- * `NewPlayer`: <b>integer</b> Neuer Besitzer
Report.EntityOwnerChanged = anyInteger;

--- Die Menge an Ressourcen in der Entität hat sich geändert.
---
--- #### Parameters:
--- * `EntityID`:  <b>integer</b> ID der Entität
--- * `GoodType`:  <b>integer</b> Art der Ressource
--- * `OldAmount`: <b>integer</b> Alte Menge
--- * `NewAmount`: <b>integer</b> Neue Menge
Report.EntityResourceChanged = anyInteger;

--- Der Bau eines Gebäudes wurde abgeschlossen.
---
--- #### Parameters:
--- * `BuildingID`: <b>integer</b> ID des Gebäudes
--- * `PlayerID`:   <b>integer</b> ID des Spielers
Report.BuildingConstructed = anyInteger;

--- Ein Gebäudeupgrade wurde abgeschlossen.
---
--- #### Parameters:
--- * `BuildingID`:      <b>integer</b> ID des Gebäudes
--- * `PlayerID`:        <b>integer</b> ID des Spielers
--- * `NewUpgradeLevel`: <b>integer</b> Neues Upgrade-Level
Report.BuildingUpgraded = anyInteger;

--- Ein Upgrade-Level ist zusammengebrochen.
---
--- #### Parameters:
--- * `BuildingID`:      <b>integer</b> ID des Gebäudes
--- * `PlayerID`:        <b>integer</b> ID des Spielers
--- * `NewUpgradeLevel`: <b>integer</b> Neues Upgrade-Level
Report.BuildingUpgradeCollapsed = anyInteger;

--- Ein Gebäude wurde von einem Dieb infiltriert.
---
--- #### Parameters:
--- * `ThiefID`:          <b>integer</b> ID des Diebes
--- * `PlayerID`:         <b>integer</b> ID des Spielers
--- * `BuildingID`:       <b>integer</b> ID des Gebäudes
--- * `BuildingPlayerID`: <b>integer</b> ID des Spielers des Gebäudes
Report.ThiefInfiltratedBuilding = anyInteger;

--- Ein Dieb hat Einnahmen geliefert.
---
--- #### Parameters:
--- * `ThiefID`:          <b>integer</b> ID des Diebes
--- * `PlayerID`:         <b>integer</b> ID des Spielers
--- * `BuildingID`:       <b>integer</b> ID des Gebäudes
--- * `BuildingPlayerID`: <b>integer</b> ID des Spielers des Gebäudes
--- * `GoldAmount`:       <b>integer</b> Menge an Gold
Report.ThiefDeliverEarnings = anyInteger;

