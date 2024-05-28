Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntityEvent_API");

function SearchEntities(_PlayerID, _WithoutDefeatResistant)
    if _WithoutDefeatResistant == nil then
        _WithoutDefeatResistant = false;
    end
    local Filter = function(_ID)
        if _PlayerID and Logic.EntityGetPlayer(_ID) ~= _PlayerID then
            return false;
        end
        if _WithoutDefeatResistant then
            if (Logic.IsBuilding(_ID) or Logic.IsWall(_ID)) and Logic.IsConstructionComplete(_ID) == 0 then
                return false;
            end
            local Type = Logic.GetEntityType(_ID);
            local TypeName = Logic.GetEntityType(Type);
            if TypeName and (string.find(TypeName, "^S_") or string.find(TypeName, "^XD_")) then
                return false;
            end
        end
        return true;
    end
    return CommenceEntitySearch(Filter);
end
API.SearchEntities = SearchEntities;

function SearchEntitiesOfTypeInArea(_Area, _Position, _Type, _PlayerID)
    return SearchEntitiesInArea(_Area, _Position, _PlayerID, _Type, nil);
end
API.SearchEntitiesOfTypeInArea = SearchEntitiesOfTypeInArea;

function SearchEntitiesOfCategoryInArea(_Area, _Position, _Category, _PlayerID)
    return SearchEntitiesInArea(_Area, _Position, _PlayerID, nil, _Category);
end
API.SearchEntitiesOfCategoryInArea = SearchEntitiesOfCategoryInArea;

function SearchEntitiesOfTypeInTerritory(_Territory, _Type, _PlayerID)
    return SearchEntitiesInTerritory(_Territory, _PlayerID, _Type, nil);
end
API.SearchEntitiesOfTypeInTerritory = SearchEntitiesOfTypeInTerritory;

function SearchEntitiesOfCategoryInTerritory(_Territory, _Category, _PlayerID)
    return SearchEntitiesInTerritory(_Territory, _PlayerID, nil, _Category);
end
API.SearchEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;
API.GetEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;

function SearchEntitiesByScriptname(_Pattern)
    local Filter = function(_ID)
        local ScriptName = Logic.GetEntityName(_ID);
        if not string.find(ScriptName, _Pattern) then
            return false;
        end
        return true;
    end
    return Lib.EntityEvent.Shared:IterateOverEntities(Filter);
end
API.SearchEntitiesByScriptname = SearchEntitiesByScriptname;

function CommenceEntitySearch(_Filter)
    _Filter = _Filter or function(_ID)
        return true;
    end
    return Lib.EntityEvent.Shared:IterateOverEntities(_Filter);
end
API.CommenceEntitySearch = CommenceEntitySearch;

function ThiefDisableStorehouseEffect(_Flag)
    Lib.EntityEvent.Global.DisableThiefStorehouseHeist = _Flag == true;
end
API.ThiefDisableStorehouseEffect = ThiefDisableStorehouseEffect;

function ThiefDisableCathedralEffect(_Flag)
    Lib.EntityEvent.Global.DisableThiefCathedralSabotage = _Flag == true;
end
API.ThiefDisableCathedralEffect = ThiefDisableCathedralEffect;

function ThiefDisableCisternEffect(_Flag)
    Lib.EntityEvent.Global.DisableThiefCisternSabotage = _Flag == true;
end
API.ThiefDisableCisternEffect = ThiefDisableCisternEffect;

-- -------------------------------------------------------------------------- --

-- Not supposed to be used directly!
function SearchEntitiesInArea(_Area, _Position, _PlayerID, _Type, _Category)
    local Position = _Position;
    if type(Position) ~= "table" then
        Position = GetPosition(Position);
    end
    local Filter = function(_ID)
        if _PlayerID and Logic.EntityGetPlayer(_ID) ~= _PlayerID then
            return false;
        end
        if _Type and Logic.GetEntityType(_ID) ~= _Type then
            return false;
        end
        if _Category and Logic.IsEntityInCategory(_ID, _Category) == 0 then
            return false;
        end
        if GetDistance(_ID, Position) > _Area then
            return false;
        end
        return true;
    end
    return CommenceEntitySearch(Filter);
end
API.SearchEntitiesInArea = SearchEntitiesInArea;

-- Not supposed to be used directly!
function SearchEntitiesInTerritory(_Territory, _PlayerID, _Type, _Category)
    local Filter = function(_ID)
        if _PlayerID and Logic.EntityGetPlayer(_ID) ~= _PlayerID then
            return false;
        end
        if _Type and Logic.GetEntityType(_ID) ~= _Type then
            return false;
        end
        if _Category and Logic.IsEntityInCategory(_ID, _Category) == 0 then
            return false;
        end
        if _Territory and GetTerritoryUnderEntity(_ID) ~= _Territory then
            return false;
        end
        return true;
    end
    return CommenceEntitySearch(Filter);
end
API.SearchEntitiesInTerritory = SearchEntitiesInTerritory;

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

