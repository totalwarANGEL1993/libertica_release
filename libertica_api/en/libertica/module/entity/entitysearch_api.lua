--- Adds search functions reguarding entities.
--- 
--- <b>Attention</b>: The search functions provided by this module iterate
--- over all(!) entities. It is highly adviced to not use them in jobs to
--- aviod performance problems.



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

--- Creates a new search filter.
--- @param _Identifier string Name of filter
--- @param _Function function Filter function
function CreateSearchFilter(_Identifier, _Function)
end
API.CreateSearchFilter = CreateSearchFilter;

--- Deletes a search filter.
--- @param _Identifier string Name of filter
function DropSearchFilter(_Identifier)
end
API.DropSearchFilter = DropSearchFilter;

--- Searches entities that are matching the filter.
--- 
--- A filter is a function, which is called for each found entity to check
--- if it belongs to the result set. The filtering is done by passing the
--- name under which the function was saved.
---
--- #### Example:
--- This filter accepts all entities of player 1.
--- ```lua
--- -- Create filter
--- CreateSearchFilter("MyFilter", function(_ID)
---     if Logic.EntityGetPlayer(_ID) ~= 1 then
---         return false;
---     end
---     return true;
--- end);
--- -- execute filter
--- local Results = CommenceEntitySearch("MyFilter");
--- ```
--- 
--- @param _Filter string Name of filter
--- @return table Results List of entities
function CommenceEntitySearch(_Filter)
    return {};
end
API.CommenceEntitySearch = CommenceEntitySearch;

