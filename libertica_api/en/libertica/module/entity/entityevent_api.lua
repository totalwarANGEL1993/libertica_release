--- Adds usefull reports reguarding entities.
---



--- Enables od disables storehouse sabotage when thives infiltrate the building.
--- @param _Flag boolean Active or deactivate
function ThiefDisableStorehouseEffect(_Flag)
end
API.ThiefDisableStorehouseEffect = ThiefDisableStorehouseEffect;

--- Enables od disables cathedral sabotage when thives infiltrate the building.
--- @param _Flag boolean Active or deactivate
function ThiefDisableCathedralEffect(_Flag)
end
API.ThiefDisableCathedralEffect = ThiefDisableCathedralEffect;

--- Enables od disables the thiefs ability to sabotage the cistern.
---
--- (Requires the AddOn "Eastern Realm")
---
--- @param _Flag boolean Active or deactivate
function ThiefDisableCisternEffect(_Flag)
end
API.ThiefDisableCisternEffect = ThiefDisableCisternEffect;



--- An entity has been spawned.
---
--- #### Parameters:s
--- * `EntityID` - ID of entity
--- * `PlayerID` - ID of player
--- * `SpawnerID` - ID of Spawner
Report.EntitySpawned = anyInteger;

--- A settler joined the settlement.
---
--- #### Parameters:s
--- * `EntityID` - ID of entity
--- * `PlayerID` - ID of player
Report.SettlerAttracted = anyInteger;

--- An entity has been destroyed by any means.
---
--- #### Parameters:s
--- * `EntityID` - ID of entity
--- * `PlayerID` - ID of player
Report.EntityDestroyed = anyInteger;

--- An entity has been hurt.
---
--- #### Parameters:s
--- * `AttackingEntityID` - ID of attacking entity
--- * `AttackingPlayerID` - Owner of attacking entity
--- * `AttackedEntityID` - ID of attacked entity
--- * `AttackedPlayerID` - Owner of attacked entity
Report.EntityHurt = anyInteger;

--- An entity has been killed.
---
--- #### Parameters:s
--- * `KilledEntityID` - ID of killed entity
--- * `KilledPlayerID` - Owner of killed entity
--- * `KillerEntityID` - ID of killing entity
--- * `KillerPlayerID` - Owner of killing entity
Report.EntityKilled = anyInteger;

--- The ownership of an entity has changed.
---
--- #### Parameters:s
--- * `OldIDList` - List of old entity IDs
--- * `OldPlayer` - Previous owner
--- * `NewIDList` - List of new entity IDs
--- * `NewPlayer` - New owner
Report.EntityOwnerChanged = anyInteger;

--- The amound of resourced changed in the entity.
---
--- #### Parameters:s
--- * `EntityID` - ID of entity
--- * `GoodType` - Type of resource
--- * `OldAmount` - Old amount
--- * `NewAmount` - New amount
Report.EntityResourceChanged = anyInteger;

--- A building construction has finished.
---
--- #### Parameters:s
--- * `BuildingID` - ID of building
--- * `PlayerID` - ID of player
Report.BuildingConstructed = anyInteger;

--- A building upgrade has finished.
---
--- #### Parameters:s
--- * `BuildingID` - ID of building
--- * `PlayerID` - ID of player
--- * `NewUpgradeLevel` - 
Report.BuildingUpgraded = anyInteger;

--- An upgrade level has collapsed.
---
--- #### Parameters:s
--- * `BuildingID` - ID of building
--- * `PlayerID` - ID of player
--- * `NewUpgradeLevel` - 
Report.BuildingUpgradeCollapsed = anyInteger;

--- A building was infiltrated by a thief.
---
--- #### Parameters:s
--- * `ThiefID` - ID of thief
--- * `PlayerID` - ID of player
--- * `BuildingID` - ID of building
--- * `BuildingPlayerID` - ID of player
Report.ThiefInfiltratedBuilding = anyInteger;

--- A thef has delivered earnings.
---
--- #### Parameters:s
--- * `ThiefID` - ID of thief
--- * `PlayerID` - ID of player
--- * `BuildingID` - ID of building
--- * `BuildingPlayerID` - ID of player
--- * `GoldAmount` - Amount of gold
Report.ThiefDeliverEarnings = anyInteger;

