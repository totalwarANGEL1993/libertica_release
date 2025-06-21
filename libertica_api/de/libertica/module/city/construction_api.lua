--- Ermöglicht die Beschränkung des Baus und Abbruchs von Gebäuden.
---
--- #### Besondere Regeln
--- Die folgenden Regeln sind immer aktiv und können nicht deaktiviert werden:
---
--- <li>Ballisten können nicht direkt nebeneinander platziert werden und 
--- benötigen immer ein vollständiges Mauersegment zwischen ihnen (oder 
--- mehrere, die gleich lang sind).</li>
---



--- Aktiviert oder deaktiviert die erzwungene Distanz zwischen Mauerkatapulten.
--- @param _Flag boolean Beschränkung ist aktiv
function UseForceBallistaDistance(_Flag)
end
API.UseForceBallistaDistance = UseForceBallistaDistance;

--- Definiert eine benutzerdefinierte Regel für den Bau von Gebäuden.
---
--- Die Funktion muss im <b>globalen Skript</b> platziert sein!
---
--- #### Custom Function:
--- ```lua
--- function MyCustomBuildRestriction(_PlayerID, _Type, _x, _y, ...)
---     return CanBeBuild;
--- end
--- ```
--- @param _PlayerID integer ID des Spielers
--- @param _FunctionName string Name der Funktion (globales Skript)
--- @param ... any Parameterliste
--- @return integer ID ID der Bau-Einschränkung
function CustomRuleConstructBuilding(_PlayerID, _FunctionName, ...)
    return 0;
end
API.CustomRuleConstructBuilding = CustomRuleConstructBuilding;

--- Definiert eine benutzerdefinierte Regel für den Bau von Straßen.
---
--- Die Funktion muss im <b>lokalen Skript</b> platziert sein!
---
--- #### Custom Function:
--- ```lua
--- function MyCustomRoadRestriction(_PlayerID, _IsStreet, _x, _y, ...)
---     return CanBeBuild;
--- end
--- ```
--- @param _PlayerID integer ID des Spielers
--- @param _FunctionName string Name der Funktion (lokales Skript)
--- @param ... any Parameterliste
--- @return integer ID ID der Bau-Einschränkung
function CustomRuleConstructRoad(_PlayerID, _FunctionName, ...)
    return 0;
end
API.CustomRuleConstructRoad = CustomRuleConstructRoad;

--- Definiert eine benutzerdefinierte Regel für den Bau von Mauern.
---
--- Die Funktion muss im <b>lokalen Skript</b> platziert sein!
---
--- #### Custom Function:
--- ```lua
--- function MyCustomWallRestriction(_PlayerID, _IsWall, _x, _y, ...)
---     return CanBeBuild;
--- end
--- ```
--- @param _PlayerID integer ID des Spielers
--- @param _FunctionName string Name der Funktion (lokales Skript)
--- @param ... any Parameterliste
--- @return integer ID ID der Bau-Einschränkung
function CustomRuleConstructWall(_PlayerID, _FunctionName, ...)
    return 0;
end
API.CustomRuleConstructWall = CustomRuleConstructWall;

--- Definiert eine benutzerdefinierte Regel für den Abriss von Gebäuden.
---
--- Die Funktion muss im <b>lokalen Skript</b> platziert sein!
---
--- #### Custom Function:
--- ```lua
--- function MyCustomKnockdownRestriction(_PlayerID, _EntityID, _x, _y, ...)
---     return CanBeDemolished;
--- end
--- ```
--- @param _PlayerID integer ID des Spielers
--- @param _FunctionName string Name der Funktion (lokales Skript)
--- @param ... any Parameterliste
--- @return integer ID ID der Bau-Einschränkung
function CustomRuleKnockdownBuilding(_PlayerID, _FunctionName, ...)
    return 0;
end
API.CustomRuleKnockdownBuilding = CustomRuleKnockdownBuilding;

--- Erlaubt den Bau eines Gebäudetyps nur in diesem Bereich.
--- @param _PlayerID integer ID des Spielers
--- @param _Type integer ID des Typs
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Bau-Einschränkung
function WhitelistConstructTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    return 0;
end
API.WhitelistConstructTypeInArea = WhitelistConstructTypeInArea;

--- Erlaubt den Bau einer Gebäudekategorie nur in diesem Bereich.
--- @param _PlayerID integer ID des Spielers
--- @param _Category integer Zu überprüfende Kategorie
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Bau-Einschränkung
function WhitelistConstructCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    return 0;
end
API.WhitelistConstructCategoryInArea = WhitelistConstructCategoryInArea;

--- Erlaubt den Bau eines Gebäudetyps nur auf diesem Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _Type integer ID des Typs
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Bau-Einschränkung
function WhitelistConstructTypeInTerritory(_PlayerID, _Type, _Territory)
    return 0;
end
API.WhitelistConstructTypeInTerritory = WhitelistConstructTypeInTerritory;

--- Erlaubt den Bau einer Gebäudekategorie nur auf diesem Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _Category integer Zu überprüfende Kategorie
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Bau-Einschränkung
function WhitelistConstructCategoryInTerritory(_PlayerID, _Category, _Territory)
    return 0;
end
API.WhitelistConstructCategoryInTerritory = WhitelistConstructCategoryInTerritory;

--- Verhindert den Bau eines Gebäudetyps in diesem Bereich.
--- @param _PlayerID integer ID des Spielers
--- @param _Type integer ID des Typs
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Bau-Einschränkung
function BlacklistConstructTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    return 0;
end
API.BlacklistConstructTypeInArea = BlacklistConstructTypeInArea;

--- Verhindert den Bau einer Gebäudekategorie in diesem Bereich.
--- @param _PlayerID integer ID des Spielers
--- @param _Category integer Zu überprüfende Kategorie
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Bau-Einschränkung
function BlacklistConstructCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    return 0;
end
API.BlacklistConstructCategoryInArea = BlacklistConstructCategoryInArea;

--- Verhindert den Bau eines Gebäudetyps auf diesem Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _Type integer ID des Typs
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Bau-Einschränkung
function BlacklistConstructTypeInTerritory(_PlayerID, _Type, _Territory)
    return 0;
end
API.BlacklistConstructTypeInTerritory = BlacklistConstructTypeInTerritory;

--- Verhindert den Bau einer Gebäudekategorie auf diesem Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _Category integer Zu überprüfende Kategorie
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Bau-Einschränkung
function BlacklistConstructCategoryInTerritory(_PlayerID, _Category, _Territory)
    return 0;
end
API.BlacklistConstructCategoryInTerritory = BlacklistConstructCategoryInTerritory;

--- Erlaubt den Bau von Wegen nur in diesem Bereich.
--- @param _PlayerID integer ID des Spielers
--- @param _IsRoad boolean Weg ist Straße
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Bau-Einschränkung
function WhitelistConstructRoadInArea(_PlayerID, _IsRoad, _X, _Y, _Area)
    return 0;
end
API.WhitelistConstructRoadInArea = WhitelistConstructRoadInArea;

--- Erlaubt den Bau von Rampen nur in diesem Bereich.
--- @param _PlayerID integer ID des Spielers
--- @param _IsWall boolean Rampe ist Mauer
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Bau-Einschränkung
function WhitelistConstructWallInArea(_PlayerID, _IsWall, _X, _Y, _Area)
    return 0;
end
API.WhitelistConstructWallInArea = WhitelistConstructWallInArea;

--- Erlaubt den Bau von Wegen nur auf diesem Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _IsRoad boolean Weg ist Straße
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Bau-Einschränkung
function WhitelistConstructRoadInTerritory(_PlayerID, _IsRoad, _Territory)
    return 0;
end
API.WhitelistConstructRoadInTerritory = WhitelistConstructRoadInTerritory;

--- Erlaubt den Bau von Rampen nur auf diesem Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _IsWall boolean Rampe ist Mauer
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Bau-Einschränkung
function WhitelistConstructWallInTerritory(_PlayerID, _IsWall, _Territory)
    return 0;
end
API.WhitelistConstructWallInTerritory = WhitelistConstructWallInTerritory;

--- Verbietet den Bau von Wegen in diesem Bereich.
--- @param _PlayerID integer ID des Spielers
--- @param _IsRoad boolean Weg ist Straße
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Bau-Einschränkung
function BlacklistConstructRoadInArea(_PlayerID, _IsRoad, _X, _Y, _Area)
    return 0;
end
API.BlacklistConstructRoadInArea = BlacklistConstructRoadInArea;

--- Verbietet den Bau von Rampen in diesem Bereich.
--- @param _PlayerID integer ID des Spielers
--- @param _IsWall boolean Rampe ist Mauer
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Bau-Einschränkung
function BlacklistConstructWallInArea(_PlayerID, _IsWall, _X, _Y, _Area)
    return 0;
end
API.BlacklistConstructWallInArea = BlacklistConstructWallInArea;

--- Verbietet den Bau von Wegen auf diesem Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _IsRoad boolean Weg ist Straße
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Bau-Einschränkung
function BlacklistConstructRoadInTerritory(_PlayerID, _IsRoad, _Territory)
    return 0;
end
API.BlacklistConstructRoadInTerritory = BlacklistConstructRoadInTerritory;

--- Verbietet den Bau von Rampen auf diesem Territorium.
--- @param _PlayerID integer ID des Spielers
--- @param _IsWall boolean Rampe ist Mauer
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Bau-Einschränkung
function BlacklistConstructWallInTerritory(_PlayerID, _IsWall, _Territory)
    return 0;
end
API.BlacklistConstructWallInTerritory = BlacklistConstructWallInTerritory;

--- Erlaubt, den Gebäudetyp im Bereich abzureißen.
--- @param _PlayerID integer ID des Spielers
--- @param _Type integer ID des Typs
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Abrissbeschränkung
function WhitelistKnockdownTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    return 0;
end
API.WhitelistKnockdownTypeInArea = WhitelistKnockdownTypeInArea;

--- Erlaubt, die Gebäudekategorie im Bereich abzureißen.
--- @param _PlayerID integer ID des Spielers
--- @param _Category integer Zu überprüfende Kategorie
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Abrissbeschränkung
function WhitelistKnockdownCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    return 0;
end
API.WhitelistKnockdownCategoryInArea = WhitelistKnockdownCategoryInArea;

--- Erlaubt, den Gebäudetyp im Territorium abzureißen.
--- @param _PlayerID integer ID des Spielers
--- @param _Type integer ID des Typs
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Abrissbeschränkung
function WhitelistKnockdownTypeInTerritory(_PlayerID, _Type, _Territory)
    return 0;
end
API.WhitelistKnockdownTypeInTerritory = WhitelistKnockdownTypeInTerritory;

--- Erlaubt, die Gebäudekategorie im Territorium abzureißen.
--- @param _PlayerID integer ID des Spielers
--- @param _Category integer Zu überprüfende Kategorie
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Abrissbeschränkung
function WhitelistKnockdownCategoryInTerritory(_PlayerID, _Category, _Territory)
    return 0;
end
API.WhitelistKnockdownCategoryInTerritory = WhitelistKnockdownCategoryInTerritory;

--- Verhindert, dass der Gebäudetyp im Bereich abgerissen wird.
--- @param _PlayerID integer ID des Spielers
--- @param _Type integer ID des Typs
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Abrissbeschränkung
function BlacklistKnockdownTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    return 0;
end
API.BlacklistKnockdownTypeInArea = BlacklistKnockdownTypeInArea;

--- Verhindert, dass die Gebäudekategorie im Bereich abgerissen wird.
--- @param _PlayerID integer ID des Spielers
--- @param _Category integer Zu überprüfende Kategorie
--- @param _X number X-Position
--- @param _Y number Y-Position
--- @param _Area integer Größe des Bereichs
--- @return integer ID ID der Abrissbeschränkung
function BlacklistKnockdownCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    return 0;
end
API.BlacklistKnockdownCategoryInArea = BlacklistKnockdownCategoryInArea;

--- Verhindert, dass der Gebäudetyp im Territorium abgerissen wird.
--- @param _PlayerID integer ID des Spielers
--- @param _Type integer ID des Typs
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Abrissbeschränkung
function BlacklistKnockdownTypeInTerritory(_PlayerID, _Type, _Territory)
    return 0;
end
API.BlacklistKnockdownTypeInTerritory = BlacklistKnockdownTypeInTerritory;

--- Verhindert, dass die Gebäudekategorie im Territorium abgerissen wird.
--- @param _PlayerID integer ID des Spielers
--- @param _Category integer Zu überprüfende Kategorie
--- @param _Territory integer ID des Territoriums
--- @return integer ID ID der Abrissbeschränkung
function BlacklistKnockdownCategoryInTerritory(_PlayerID, _Category, _Territory)
    return 0;
end
API.BlacklistKnockdownCategoryInTerritory = BlacklistKnockdownCategoryInTerritory;

--- Entfernt eine beliebige Protektion anhand der ID.
--- @param _ID integer ID der Protektion
function DeleteFromProtectionList(_ID)
end
API.DeleteFromProtectionList = DeleteFromProtectionList;

--- Entfernt eine beliebige Restriktion anhand der ID.
--- @param _ID integer ID der Restriktion
function DeleteFromRestrictionList(_ID)
end
API.DeleteFromRestrictionList = DeleteFromRestrictionList;

