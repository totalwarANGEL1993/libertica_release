--- Adds usefull reports reguarding entities.
--- 
--- Additionally the scripted default action for thieves can be deactivated
--- and overwritten.



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
--- #### Parameters:
--- * `EntityID`:  <b>integer</b> ID of entity
--- * `PlayerID`:  <b>integer</b> ID of player
--- * `SpawnerID`: <b>integer</b> ID of Spawner
Report.EntitySpawned = anyInteger;

--- A settler joined the settlement.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of entity
--- * `PlayerID`: <b>integer</b> ID of player
Report.SettlerAttracted = anyInteger;

--- An entity has been destroyed by any means.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of entity
--- * `PlayerID`: <b>integer</b> ID of player
Report.EntityDestroyed = anyInteger;

--- An entity has been hurt.
---
--- #### Parameters:
--- * `AttackingEntityID`: <b>integer</b> ID of attacking entity
--- * `AttackingPlayerID`: <b>integer</b> Owner of attacking entity
--- * `AttackedEntityID`:  <b>integer</b> ID of attacked entity
--- * `AttackedPlayerID`:  <b>integer</b> Owner of attacked entity
Report.EntityHurt = anyInteger;

--- An entity has been killed.
---
--- #### Parameters:
--- * `KilledEntityID`: <b>integer</b> ID of killed entity
--- * `KilledPlayerID`: <b>integer</b> Owner of killed entity
--- * `KillerEntityID`: <b>integer</b> ID of killing entity
--- * `KillerPlayerID`: <b>integer</b> Owner of killing entity
Report.EntityKilled = anyInteger;

--- The ownership of an entity has changed.
---
--- #### Parameters:
--- * `OldIDList`: <b>integer</b> Old ID
--- * `OldPlayer`: <b>integer</b> Previous owner
--- * `NewIDList`: <b>integer</b> New ID
--- * `NewPlayer`: <b>integer</b> New owner
Report.EntityOwnerChanged = anyInteger;

--- The amound of resourced changed in the entity.
---
--- #### Parameters:
--- * `EntityID`:  <b>integer</b> ID of entity
--- * `GoodType`:  <b>integer</b> Type of resource
--- * `OldAmount`: <b>integer</b> Old amount
--- * `NewAmount`: <b>integer</b> New amount
Report.EntityResourceChanged = anyInteger;

--- A building construction has finished.
---
--- #### Parameters:
--- * `BuildingID`: <b>integer</b> ID of building
--- * `PlayerID`:   <b>integer</b> ID of player
Report.BuildingConstructed = anyInteger;

--- A building upgrade has finished.
---
--- #### Parameters:
--- * `BuildingID`:      <b>integer</b> ID of building
--- * `PlayerID`:        <b>integer</b> ID of player
--- * `NewUpgradeLevel`: <b>integer</b> Upgrade level
Report.BuildingUpgraded = anyInteger;

--- An upgrade level has collapsed.
---
--- #### Parameters:
--- * `BuildingID`:      <b>integer</b> ID of building
--- * `PlayerID`:        <b>integer</b> ID of player
--- * `NewUpgradeLevel`: <b>integer</b> Upgrade level
Report.BuildingUpgradeCollapsed = anyInteger;

--- A building was infiltrated by a thief.
---
--- #### Parameters:
--- * `ThiefID`:          <b>integer</b> ID of thief
--- * `PlayerID`:         <b>integer</b> ID of player
--- * `BuildingID`:       <b>integer</b> ID of building
--- * `BuildingPlayerID`: <b>integer</b> ID of player
Report.ThiefInfiltratedBuilding = anyInteger;

--- A thef has delivered earnings.
---
--- #### Parameters:
--- * `ThiefID`:          <b>integer</b> ID of thief
--- * `PlayerID`:         <b>integer</b> ID of player
--- * `BuildingID`:       <b>integer</b> ID of building
--- * `BuildingPlayerID`: <b>integer</b> ID of player
--- * `GoldAmount`:       <b>integer</b> Amount of gold
Report.ThiefDeliverEarnings = anyInteger;

