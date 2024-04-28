--- Adds search functions and usefull reports reguarding entities.
---
--- #### Reports
--- * `Report.EntitySpawned` - An entity has been spawned.
--- * `Report.SettlerAttracted` - A settler joined the settlement.
--- * `Report.EntityDestroyed` - An entity has been destroyed by any means.
--- * `Report.EntityHurt` - An entity has been hurt.
--- * `Report.EntityKilled` - An entity has been killed.
--- * `Report.EntityOwnerChanged` - The ownership of an entity has changed.
--- * `Report.EntityResourceChanged` - The amound of resourced changed in the entity.
--- * `Report.BuildingConstructed` - A building construction has finished.
--- * `Report.BuildingUpgraded` - A building upgrade has finished.
--- * `Report.BuildingUpgradeCollapsed` - An upgrade level has collapsed.
--- * `Report.ThiefInfiltratedBuilding` - A building was infiltrated by a thief.
--- * `Report.ThiefDeliverEarnings` - A thef has delivered earnings.
---
Lib.Selection = Lib.Selection or {};



--- Seaches all entities of the player.
--- @param _PlayerID integer ID of player
--- @param _WithoutDefeatResistant boolean Ignore not defeat relevant entities
--- @return table Results List of entities
function SearchEntities(_PlayerID, _WithoutDefeatResistant)
    return {};
end
API.SearchEntities = SearchEntities;

--- Searches player entities of a type in the area.
--- @param _Area integer Area size
--- @param _Position any Entity or position of location
--- @param _Type integer Type to search
--- @param _PlayerID integer ID of player
--- @return table Results List of entities
function SearchEntitiesOfTypeInArea(_Area, _Position, _Type, _PlayerID)
    return {};
end
API.SearchEntitiesOfTypeInArea = SearchEntitiesOfTypeInArea;

--- Searches player entities of a category in the area.
--- @param _Area integer Area size
--- @param _Position any Entity or position of location
--- @param _Category integer Category to search
--- @param _PlayerID integer ID of player
--- @return table Results List of entities
function SearchEntitiesOfCategoryInArea(_Area, _Position, _Category, _PlayerID)
    return {};
end
API.SearchEntitiesOfCategoryInArea = SearchEntitiesOfCategoryInArea;

--- Searches player entities of a type in the territory.
--- @param _Territory integer ID of territory
--- @param _Type integer Type to search
--- @param _PlayerID integer ID of player
--- @return table Results List of entities
function SearchEntitiesOfTypeInTerritory(_Territory, _Type, _PlayerID)
    return {};
end
API.SearchEntitiesOfTypeInTerritory = SearchEntitiesOfTypeInTerritory;

--- Searches player entities of a category in the territory.
--- @param _Territory integer ID of territory
--- @param _Category integer Category to search
--- @param _PlayerID integer ID of player
--- @return table Results List of entities
function SearchEntitiesOfCategoryInTerritory(_Territory, _Category, _PlayerID)
    return {};
end
API.SearchEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;
API.GetEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;

--- Searches entities with a scriptname matching the pattern.
---
--- **Note**: See pattern matchin in Lua 5.1 for more information!
--- @param _Pattern string Search pattern
--- @return table Results List of entities
function SearchEntitiesByScriptname(_Pattern)
    return {};
end
API.SearchEntitiesByScriptname = SearchEntitiesByScriptname;

--- Searches entities that are matching the filter.
---
--- #### Example:
--- This filter accepts all entities of player 1.
--- ```lua
--- local Filter = function(_ID)
---     if Logic.EntityGetPlayer(_ID) ~= 1 then
---         return false;
---     end
---     return true;
--- end
--- ```
--- @param _Filter any
--- @return table Results List of entities
function CommenceEntitySearch(_Filter)
    return {};
end
API.CommenceEntitySearch = CommenceEntitySearch;

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
--- #### Parameters
--- `EntityID` - ID of entity
--- `PlayerID` - ID of player
--- `SpawnerID` - ID of Spawner
Report.EntitySpawned = anyInteger;

--- A settler joined the settlement.
---
--- #### Parameters
--- `EntityID` - ID of entity
--- `PlayerID` - ID of player
Report.SettlerAttracted = anyInteger;

--- An entity has been destroyed by any means.
---
--- #### Parameters
--- `EntityID` - ID of entity
--- `PlayerID` - ID of player
Report.EntityDestroyed = anyInteger;

--- An entity has been hurt.
---
--- #### Parameters
--- `AttackedEntityID` - ID of attacked entity
--- `AttackedPlayerID` - Owner of attacked entity
--- `AttackingEntityID` - ID of attacking entity
--- `AttackingPlayerID` - Owner of attacking entity
Report.EntityHurt = anyInteger;

--- An entity has been killed.
---
--- #### Parameters
--- `KilledEntityID` - ID of killed entity
--- `KilledPlayerID` - Owner of killed entity
--- `KillerEntityID` - ID of killing entity
--- `KillerPlayerID` - Owner of killing entity
Report.EntityKilled = anyInteger;

--- The ownership of an entity has changed.
---
--- #### Parameters
--- `OldIDList` - List of old entity IDs
--- `OldPlayer` - Previous owner
--- `NewIDList` - List of new entity IDs
--- `NewPlayer` - New owner
Report.EntityOwnerChanged = anyInteger;

--- The amound of resourced changed in the entity.
---
--- #### Parameters
--- `EntityID` - ID of entity
--- `GoodType` - Type of resource
--- `OldAmount` - Old amount
--- `NewAmount` - New amount
Report.EntityResourceChanged = anyInteger;

--- A building construction has finished.
---
--- #### Parameters
--- `BuildingID` - ID of building
--- `PlayerID` - ID of player
Report.BuildingConstructed = anyInteger;

--- A building upgrade has finished.
---
--- #### Parameters
--- `BuildingID` - ID of building
--- `PlayerID` - ID of player
--- `NewUpgradeLevel` - 
Report.BuildingUpgraded = anyInteger;

--- An upgrade level has collapsed.
---
--- #### Parameters
--- `BuildingID` - ID of building
--- `PlayerID` - ID of player
--- `NewUpgradeLevel` - 
Report.BuildingUpgradeCollapsed = anyInteger;

--- A building was infiltrated by a thief.
---
--- #### Parameters
--- `ThiefID` - ID of thief
--- `PlayerID` - ID of player
--- `BuildingID` - ID of building
--- `BuildingPlayerID` - ID of player
Report.ThiefInfiltratedBuilding = anyInteger;

--- A thef has delivered earnings.
---
--- #### Parameters
--- `ThiefID` - ID of thief
--- `PlayerID` - ID of player
--- `BuildingID` - ID of building
--- `BuildingPlayerID` - ID of player
--- `GoldAmount` - Amount of gold
Report.ThiefDeliverEarnings = anyInteger;

