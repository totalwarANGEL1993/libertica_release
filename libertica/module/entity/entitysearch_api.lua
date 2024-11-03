Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntitySearch_API");

function SearchEntities(_PlayerID, _WithoutDefeatResistant)
    return Lib.EntitySearch.Shared:SearchEntities(_PlayerID, _WithoutDefeatResistant);
end
API.SearchEntities = SearchEntities;

function SearchEntitiesOfTypeInArea(_Area, _Position, _Type, _PlayerID)
    return Lib.EntitySearch.Shared:SearchEntitiesInArea(_Area, _Position, _PlayerID, _Type, nil);
end
API.SearchEntitiesOfTypeInArea = SearchEntitiesOfTypeInArea;

function SearchEntitiesOfCategoryInArea(_Area, _Position, _Category, _PlayerID)
    return Lib.EntitySearch.Shared:SearchEntitiesInArea(_Area, _Position, _PlayerID, nil, _Category);
end
API.SearchEntitiesOfCategoryInArea = SearchEntitiesOfCategoryInArea;

function SearchEntitiesOfTypeInTerritory(_Territory, _Type, _PlayerID)
    return Lib.EntitySearch.Shared:SearchEntitiesInTerritory(_Territory, _PlayerID, _Type, nil);
end
API.SearchEntitiesOfTypeInTerritory = SearchEntitiesOfTypeInTerritory;

function SearchEntitiesOfCategoryInTerritory(_Territory, _Category, _PlayerID)
    return Lib.EntitySearch.Shared:SearchEntitiesInTerritory(_Territory, _PlayerID, nil, _Category);
end
API.SearchEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;
API.GetEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;

function SearchEntitiesByScriptname(_Pattern)
    return Lib.EntitySearch.Shared:SearchEntitiesByScriptname(_Pattern);
end
API.SearchEntitiesByScriptname = SearchEntitiesByScriptname;

function CreateSearchFilter(_Identifier, _Function)
    Lib.EntitySearch.Shared:CreateFilter(_Identifier, _Function);
end
API.CreateSearchFilter = CreateSearchFilter;

function DropSearchFilter(_Identifier)
    Lib.EntitySearch.Shared:DropFilter(_Identifier);
end
API.DropSearchFilter = DropSearchFilter;

function CommenceEntitySearch(_Filter)
    return Lib.EntitySearch.Shared:IterateOverEntities(_Filter);
end
API.CommenceEntitySearch = CommenceEntitySearch;

-- Compatibility option
function GetEntitiesOfCategoriesInTerritories(_PlayerID, _Category, _Territory)
    local p = (type(_PlayerID) == "table" and _PlayerID) or {_PlayerID};
    local c = (type(_Category) == "table" and _Category) or {_Category};
    local t = (type(_Territory) == "table" and _Territory) or {_Territory};
    local PlayerEntities = {};
    for i=1, #p, 1 do
        for j=1, #c, 1 do
            for k=1, #t, 1 do
                local Units = SearchEntitiesOfCategoryInTerritory(t[k], c[j], p[i]);
                PlayerEntities = Array_Append(PlayerEntities, Units);
            end
        end
    end
    return PlayerEntities;
end
API.GetEntitiesOfCategoriesInTerritories = GetEntitiesOfCategoriesInTerritories;

