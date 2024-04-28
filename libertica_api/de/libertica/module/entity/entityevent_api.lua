--- Fügt Suchfunktionen und nützliche Berichte zu Entitäten hinzu.
---
--- #### Reports
--- * `Report.EntitySpawned` - Eine Entität wurde erschaffen.
--- * `Report.SettlerAttracted` - Ein Siedler ist der Siedlung beigetreten.
--- * `Report.EntityDestroyed` - Eine Entität wurde zerstört, auf irgendeine Weise.
--- * `Report.EntityHurt` - Eine Entität wurde verletzt.
--- * `Report.EntityKilled` - Eine Entität wurde getötet.
--- * `Report.EntityOwnerChanged` - Der Besitz einer Entität hat sich geändert.
--- * `Report.EntityResourceChanged` - Die Menge an Ressourcen in der Entität hat sich geändert.
--- * `Report.BuildingConstructed` - Ein Gebäude wurde fertiggestellt.
--- * `Report.BuildingUpgraded` - Ein Gebäudeupgrade wurde abgeschlossen.
--- * `Report.BuildingUpgradeCollapsed` - Ein Upgrade-Level ist zusammengebrochen.
--- * `Report.ThiefInfiltratedBuilding` - Ein Dieb hat ein Gebäude infiltriert.
--- * `Report.ThiefDeliverEarnings` - Ein Dieb hat Einnahmen geliefert.
---
Lib.Selection = Lib.Selection or {};



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

--- Sucht Entitäten anhand des übergebenen Filters.
---
--- Ein Filter ist eine Funktion, die für jede gefundene Entität prüft, ob sie
--- zur Ergebnismenge gehört oder nicht.
---
--- #### Beispiel:
--- Dieser Filter akzeptiert alle Entitäten von Spieler 1.
--- ```lua
--- local Filter = function(_ID)
---     if Logic.EntityGetPlayer(_ID) ~= 1 then
---         return false;
---     end
---     return true;
--- end
--- ```
--- @param _Filter any
--- @return table Results Liste mit Entitäten
function CommenceEntitySearch(_Filter)
    return {};
end
API.CommenceEntitySearch = CommenceEntitySearch;

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
--- #### Parameter
--- `EntityID` - ID der Entität
--- `PlayerID` - ID des Spielers
--- `SpawnerID` - ID des Spawners
Report.EntitySpawned = anyInteger;

--- Ein Siedler ist der Siedlung beigetreten.
---
--- #### Parameter
--- `EntityID` - ID der Entität
--- `PlayerID` - ID des Spielers
Report.SettlerAttracted = anyInteger;

--- Eine Entität wurde auf irgendeine Weise zerstört.
---
--- #### Parameter
--- `EntityID` - ID der Entität
--- `PlayerID` - ID des Spielers
Report.EntityDestroyed = anyInteger;

--- Eine Entität wurde verletzt.
---
--- #### Parameter
--- `AttackedEntityID` - ID der angegriffenen Entität
--- `AttackedPlayerID` - Besitzer der angegriffenen Entität
--- `AttackingEntityID` - ID der angreifenden Entität
--- `AttackingPlayerID` - Besitzer der angreifenden Entität
Report.EntityHurt = anyInteger;

--- Eine Entität wurde getötet.
---
--- #### Parameter
--- `KilledEntityID` - ID der getöteten Entität
--- `KilledPlayerID` - Besitzer der getöteten Entität
--- `KillerEntityID` - ID der tötenden Entität
--- `KillerPlayerID` - Besitzer der tötenden Entität
Report.EntityKilled = anyInteger;

--- Der Besitz einer Entität hat sich geändert.
---
--- #### Parameter
--- `OldIDList` - Liste der alten Entitäts-IDs
--- `OldPlayer` - Vorheriger Besitzer
--- `NewIDList` - Liste der neuen Entitäts-IDs
--- `NewPlayer` - Neuer Besitzer
Report.EntityOwnerChanged = anyInteger;

--- Die Menge an Ressourcen in der Entität hat sich geändert.
---
--- #### Parameter
--- `EntityID` - ID der Entität
--- `GoodType` - Art der Ressource
--- `OldAmount` - Alte Menge
--- `NewAmount` - Neue Menge
Report.EntityResourceChanged = anyInteger;

--- Der Bau eines Gebäudes wurde abgeschlossen.
---
--- #### Parameter
--- `BuildingID` - ID des Gebäudes
--- `PlayerID` - ID des Spielers
Report.BuildingConstructed = anyInteger;

--- Ein Gebäudeupgrade wurde abgeschlossen.
---
--- #### Parameter
--- `BuildingID` - ID des Gebäudes
--- `PlayerID` - ID des Spielers
--- `NewUpgradeLevel` - Neues Upgrade-Level
Report.BuildingUpgraded = anyInteger;

--- Ein Upgrade-Level ist zusammengebrochen.
---
--- #### Parameter
--- `BuildingID` - ID des Gebäudes
--- `PlayerID` - ID des Spielers
--- `NewUpgradeLevel` - Neues Upgrade-Level
Report.BuildingUpgradeCollapsed = anyInteger;

--- Ein Gebäude wurde von einem Dieb infiltriert.
---
--- #### Parameter
--- `ThiefID` - ID des Diebes
--- `PlayerID` - ID des Spielers
--- `BuildingID` - ID des Gebäudes
--- `BuildingPlayerID` - ID des Spielers des Gebäudes
Report.ThiefInfiltratedBuilding = anyInteger;

--- Ein Dieb hat Einnahmen geliefert.
---
--- #### Parameter
--- `ThiefID` - ID des Diebes
--- `PlayerID` - ID des Spielers
--- `BuildingID` - ID des Gebäudes
--- `BuildingPlayerID` - ID des Spielers des Gebäudes
--- `GoldAmount` - Menge an Gold
Report.ThiefDeliverEarnings = anyInteger;

