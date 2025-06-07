--- Fügt Suchfunktionen zu Entitäten hinzu.
--- 
--- <b>Achtung</b>: Die in diesem Modul hinzugefügten Suchfunktionen iterieren
--- über alle(!) Entitäten und können resourcenintensiv sein. Vermeide also
--- sie in Jobs zu verwenden.



--- Sucht alle Entitäten des Spielers.
--- @param _PlayerID integer ID des Spielers
--- @param _WithoutDefeatResistant boolean Ignoriere niederlageirrelevant
--- @return table Results Liste mit Entitäten
function SearchEntities(_PlayerID, _WithoutDefeatResistant)
    return {};
end
API.SearchEntities = SearchEntities;

--- Searches player entities of a type in the area.
--- @param _Area integer Größe des Gebiet
--- @param _Position any Entität oder Position
--- @param _Type integer Gesuchter Typ
--- @param _PlayerID integer ID des Spielers
--- @return table Results Liste mit Entitäten
function SearchEntitiesOfTypeInArea(_Area, _Position, _Type, _PlayerID)
    return {};
end
API.SearchEntitiesOfTypeInArea = SearchEntitiesOfTypeInArea;

--- Searches player entities of a category in the area.
--- @param _Area integer Größe des Gebiet
--- @param _Position any Entität oder Position
--- @param _Category integer Gesuchte Kategorie
--- @param _PlayerID integer ID des Spielers
--- @return table Results Liste mit Entitäten
function SearchEntitiesOfCategoryInArea(_Area, _Position, _Category, _PlayerID)
    return {};
end
API.SearchEntitiesOfCategoryInArea = SearchEntitiesOfCategoryInArea;

--- Searches player entities of a type in the territory.
--- @param _Territory integer ID des Territorium
--- @param _Type integer Gesuchter Typ
--- @param _PlayerID integer ID des Spielers
--- @return table Results Liste mit Entitäten
function SearchEntitiesOfTypeInTerritory(_Territory, _Type, _PlayerID)
    return {};
end
API.SearchEntitiesOfTypeInTerritory = SearchEntitiesOfTypeInTerritory;

--- Searches player entities of a category in the territory.
--- @param _Territory integer ID des Territorium
--- @param _Category integer Gesuchte Kategorie
--- @param _PlayerID integer ID des Spielers
--- @return table Results Liste mit Entitäten
function SearchEntitiesOfCategoryInTerritory(_Territory, _Category, _PlayerID)
    return {};
end
API.SearchEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;
API.GetEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;

--- Sucht Entitäten mit einem Skriptnamen, der zu dem Muster passt.
---
--- **Hinweis**: Siehe dazu Pattern Matching in Lua 5.1 für mehr Infos!
--- @param _Pattern string Suchmuster
--- @return table Results Liste mit Entitäten
function SearchEntitiesByScriptname(_Pattern)
    return {};
end
API.SearchEntitiesByScriptname = SearchEntitiesByScriptname;

--- Erzeugt einen Suchfilter.
--- @param _Identifier string Name of filter
--- @param _Function function Filter function
function CreateSearchFilter(_Identifier, _Function)
end
API.CreateSearchFilter = CreateSearchFilter;

--- Löscht einen Suchfilter.
--- @param _Identifier string Name of filter
function DropSearchFilter(_Identifier)
end
API.DropSearchFilter = DropSearchFilter;

--- Sucht Entitäten anhand des übergebenen Filters.
---
--- Ein Filter ist eine Funktion, die für jede gefundene Entität prüft, ob sie
--- zur Ergebnismenge gehört oder nicht. Um die Filterung durchzuführen, wird
--- der Name angegeben unter dem die Funktion gespeichert wurde.
---
--- #### Example:
--- Dieser Filter akzeptiert alle Entitäten von Spieler 1.
--- ```lua
--- -- Filter erzeugen
--- CreateSearchFilter("MyFilter", function(_ID)
---     if Logic.EntityGetPlayer(_ID) ~= 1 then
---         return false;
---     end
---     return true;
--- end);
--- -- Filter ausführen
--- local Results = CommenceEntitySearch("MyFilter");
--- ```
--- 
--- @param _Filter any
--- @return table Results Liste mit Entitäten
function CommenceEntitySearch(_Filter)
    return {};
end
API.CommenceEntitySearch = CommenceEntitySearch;

