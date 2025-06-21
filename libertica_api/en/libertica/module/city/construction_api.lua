--- Allows to restrict construction and knockdown of buildings.
---
--- #### Special rules
--- The following rules are always active and can not be deactivated:
---
--- <li>Ballistas can not be placed right beside each other and always need
--- a fulllength wall segment between them (or multiple that are equally
--- long).</li>
---



--- Activates or deactivates the forced distance between ballistas.
--- @param _Flag boolean Limitation is active
function UseForceBallistaDistance(_Flag)
end
API.UseForceBallistaDistance = UseForceBallistaDistance;

--- Defines a custom rule for construction buildings.
---
--- The function must be located in the <b>global script</b>!
---
--- #### Custom Function
--- ```lua
--- function MyCustomBuildRestriction(_PlayerID, _Type, _x, _y, ...)
---     return CanBeBuild;
--- end
--- ```
--- @param _PlayerID integer ID of player
--- @param _FunctionName string Name of function (global script)
--- @param ... any Parameter list
--- @return integer ID ID of construction restriction
function CustomRuleConstructBuilding(_PlayerID, _FunctionName, ...)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:CustomRuleConstructBuilding(_PlayerID, _FunctionName, unpack(arg));
end
API.CustomRuleConstructBuilding = CustomRuleConstructBuilding;

--- Defines a custom rule for construction roads.
---
--- The function must be located in the <b>local script</b>!
---
--- #### Custom Function
--- ```lua
--- function MyCustomRoadRestriction(_PlayerID, _IsStreet, _x, _y, ...)
---     return CanBeBuild;
--- end
--- ```
--- @param _PlayerID integer ID of player
--- @param _FunctionName string Name of function (local script)
--- @param ... any Parameter list
--- @return integer ID ID of construction restriction
function CustomRuleConstructRoad(_PlayerID, _FunctionName, ...)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:CustomRuleConstructRoad(_PlayerID, _FunctionName, unpack(arg));
end
API.CustomRuleConstructRoad = CustomRuleConstructRoad;

--- Defines a custom rule for construction ramparts.
---
--- The function must be located in the <b>local script</b>!
---
--- #### Custom Function
--- ```lua
--- function MyCustomWallRestriction(_PlayerID, _IsWall, _x, _y, ...)
---     return CanBeBuild;
--- end
--- ```
--- @param _PlayerID integer ID of player
--- @param _FunctionName string Name of function (local script)
--- @param ... any Parameter list
--- @return integer ID ID of construction restriction
function CustomRuleConstructWall(_PlayerID, _FunctionName, ...)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:CustomRuleConstructWall(_PlayerID, _FunctionName, unpack(arg));
end
API.CustomRuleConstructWall = CustomRuleConstructWall;

--- Defines a custom rule for demolishing buildings.
---
--- The function must be located in the <b>local script</b>!
---
--- #### Custom Function
--- ```lua
--- function MyCustomKnockdownRestriction(_PlayerID, _EntityID, _x, _y, ...)
---     return CanBeDemolished;
--- end
--- ```
--- @param _PlayerID integer ID of player
--- @param _FunctionName string Name of function (local script)
--- @param ... any Parameter list
--- @return integer ID ID of construction restriction
function CustomRuleKnockdownBuilding(_PlayerID, _FunctionName, ...)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:CustomRuleKnockdownBuilding(_PlayerID, _FunctionName, unpack(arg));
end
API.CustomRuleKnockdownBuilding = CustomRuleKnockdownBuilding;

--- Allow construction of a building type only in this area.
--- @param _PlayerID integer ID of player
--- @param _Type integer ID of type
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of construction restriction
function WhitelistConstructTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistConstructTypeInArea(_PlayerID, _Type, _X, _Y, _Area);
end
API.WhitelistConstructTypeInArea = WhitelistConstructTypeInArea;

--- Allow construction of a building category only in this area.
--- @param _PlayerID integer ID of player
--- @param _Category integer Category to check
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of construction restriction
function WhitelistConstructCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistConstructCategoryInArea(_PlayerID, _Category, _X, _Y, _Area);
end
API.WhitelistConstructCategoryInArea = WhitelistConstructCategoryInArea;

--- Allow construction of a building type only on this territory.
--- @param _PlayerID integer ID of player
--- @param _Type integer ID of type
--- @param _Territory integer ID of territory
--- @return integer ID ID of construction restriction
function WhitelistConstructTypeInTerritory(_PlayerID, _Type, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistConstructTypeInTerritory(_PlayerID, _Type, _Territory);
end
API.WhitelistConstructTypeInTerritory = WhitelistConstructTypeInTerritory;

--- Allow construction of a building category only on this territory.
--- @param _PlayerID integer ID of player
--- @param _Category integer Category to check
--- @param _Territory integer ID of territory
--- @return integer ID ID of construction restriction
function WhitelistConstructCategoryInTerritory(_PlayerID, _Category, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistConstructCategoryInTerritory(_PlayerID, _Category, _Territory);
end
API.WhitelistConstructCategoryInTerritory = WhitelistConstructCategoryInTerritory;

--- Forbid construction of a building type in this area.
--- @param _PlayerID integer ID of player
--- @param _Type integer ID of type
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of construction restriction
function BlacklistConstructTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistConstructTypeInArea(_PlayerID, _Type, _X, _Y, _Area);
end
API.BlacklistConstructTypeInArea = BlacklistConstructTypeInArea;

--- Forbid construction of a building category in this area.
--- @param _PlayerID integer ID of player
--- @param _Category integer Category to check
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of construction restriction
function BlacklistConstructCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistConstructCategoryInArea(_PlayerID, _Category, _X, _Y, _Area);
end
API.BlacklistConstructCategoryInArea = BlacklistConstructCategoryInArea;

--- Forbid construction of a building type on this territory.
--- @param _PlayerID integer ID of player
--- @param _Type integer ID of type
--- @param _Territory integer ID of territory
--- @return integer ID ID of construction restriction
function BlacklistConstructTypeInTerritory(_PlayerID, _Type, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistConstructTypeInTerritory(_PlayerID, _Type, _Territory);
end
API.BlacklistConstructTypeInTerritory = BlacklistConstructTypeInTerritory;

--- Forbid construction of a building category on this territory.
--- @param _PlayerID integer ID of player
--- @param _Category integer Category to check
--- @param _Territory integer ID of territory
--- @return integer ID ID of construction restriction
function BlacklistConstructCategoryInTerritory(_PlayerID, _Category, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistConstructCategoryInTerritory(_PlayerID, _Category, _Territory);
end
API.BlacklistConstructCategoryInTerritory = BlacklistConstructCategoryInTerritory;

--- Allow to build paths only in this area.
--- @param _PlayerID integer ID of player
--- @param _IsRoad boolean Path is road
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of construction restriction
function WhitelistConstructRoadInArea(_PlayerID, _IsRoad, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistConstructRoadInArea(_PlayerID, _IsRoad, _X, _Y, _Area);
end
API.WhitelistConstructRoadInArea = WhitelistConstructRoadInArea;

--- Allow to build ramparts only in this area.
--- @param _PlayerID integer ID of player
--- @param _IsWall boolean Rampart is wall
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of construction restriction
function WhitelistConstructWallInArea(_PlayerID, _IsWall, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistConstructWallInArea(_PlayerID, _IsWall, _X, _Y, _Area);
end
API.WhitelistConstructWallInArea = WhitelistConstructWallInArea;

--- Allow to build paths only on this territory.
--- @param _PlayerID integer ID of player
--- @param _IsRoad boolean Path is road
--- @param _Territory integer ID of territory
--- @return integer ID ID of construction restriction
function WhitelistConstructRoadInTerritory(_PlayerID, _IsRoad, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistConstructRoadInTerritory(_PlayerID, _IsRoad, _Territory);
end
API.WhitelistConstructRoadInTerritory = WhitelistConstructRoadInTerritory;

--- Allow to build ramparts only on this territory.
--- @param _PlayerID integer ID of player
--- @param _IsWall boolean Rampart is wall
--- @param _Territory integer ID of territory
--- @return integer ID ID of construction restriction
function WhitelistConstructWallInTerritory(_PlayerID, _IsWall, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistConstructWallInTerritory(_PlayerID, _IsWall, _Territory);
end
API.WhitelistConstructWallInTerritory = WhitelistConstructWallInTerritory;

--- Forbid to build paths in this area.
--- @param _PlayerID integer ID of player
--- @param _IsRoad boolean Path is road
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of construction restriction
function BlacklistConstructRoadInArea(_PlayerID, _IsRoad, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistConstructRoadInArea(_PlayerID, _IsRoad, _X, _Y, _Area);
end
API.BlacklistConstructRoadInArea = BlacklistConstructRoadInArea;

--- Forbid to build ramparts in this area.
--- @param _PlayerID integer ID of player
--- @param _IsWall boolean Rampart is wall
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of construction restriction
function BlacklistConstructWallInArea(_PlayerID, _IsWall, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistConstructWallInArea(_PlayerID, _IsWall, _X, _Y, _Area);
end
API.BlacklistConstructWallInArea = BlacklistConstructWallInArea;

--- Forbid to build paths on this territory.
--- @param _PlayerID integer ID of player
--- @param _IsRoad boolean Path is road
--- @param _Territory integer ID of territory
--- @return integer ID ID of construction restriction
function BlacklistConstructRoadInTerritory(_PlayerID, _IsRoad, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistConstructRoadInTerritory(_PlayerID, _IsRoad, _Territory);
end
API.BlacklistConstructRoadInTerritory = BlacklistConstructRoadInTerritory;

--- Forbid to build ramparts on this territory.
--- @param _PlayerID integer ID of player
--- @param _IsWall boolean Rampart is wall
--- @param _Territory integer ID of territory
--- @return integer ID ID of construction restriction
function BlacklistConstructWallInTerritory(_PlayerID, _IsWall, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistConstructWallInTerritory(_PlayerID, _IsWall, _Territory);
end
API.BlacklistConstructWallInTerritory = BlacklistConstructWallInTerritory;

--- Allows to knockdown the building type in the area.
--- @param _PlayerID integer ID of player
--- @param _Type integer ID of type
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of knockdown restriction
function WhitelistKnockdownTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistKnockdownTypeInArea(_PlayerID, _Type, _X, _Y, _Area);
end
API.WhitelistKnockdownTypeInArea = WhitelistKnockdownTypeInArea;

--- Allows to knockdown the building category in the area.
--- @param _PlayerID integer ID of player
--- @param _Category integer Category to check
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of knockdown restriction
function WhitelistKnockdownCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistKnockdownCategoryInArea(_PlayerID, _Category, _X, _Y, _Area);
end
API.WhitelistKnockdownCategoryInArea = WhitelistKnockdownCategoryInArea;

--- Allows to knockdown the building type on the territory.
--- @param _PlayerID integer ID of player
--- @param _Type integer ID of type
--- @param _Territory integer ID of territory
--- @return integer ID ID of knockdown restriction
function WhitelistKnockdownTypeInTerritory(_PlayerID, _Type, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistKnockdownTypeInTerritory(_PlayerID, _Type, _Territory);
end
API.WhitelistKnockdownTypeInTerritory = WhitelistKnockdownTypeInTerritory;

--- Allows to knockdown the building category on the territory.
--- @param _PlayerID integer ID of player
--- @param _Category integer Category to check
--- @param _Territory integer ID of territory
--- @return integer ID ID of knockdown restriction
function WhitelistKnockdownCategoryInTerritory(_PlayerID, _Category, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:WhitelistKnockdownCategoryInTerritory(_PlayerID, _Category, _Territory);
end
API.WhitelistKnockdownCategoryInTerritory = WhitelistKnockdownCategoryInTerritory;

--- Forbid to knockdown the building type in the area.
--- @param _PlayerID integer ID of player
--- @param _Type integer ID of type
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of knockdown restriction
function BlacklistKnockdownTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistKnockdownTypeInArea(_PlayerID, _Type, _X, _Y, _Area);
end
API.BlacklistKnockdownTypeInArea = BlacklistKnockdownTypeInArea;

--- Forbid to knockdown the building category in the area.
--- @param _PlayerID integer ID of player
--- @param _Category integer Category to check
--- @param _X number X Position
--- @param _Y number Y Position
--- @param _Area integer Size of area
--- @return integer ID ID of knockdown restriction
function BlacklistKnockdownCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistKnockdownCategoryInArea(_PlayerID, _Category, _X, _Y, _Area);
end
API.BlacklistKnockdownCategoryInArea = BlacklistKnockdownCategoryInArea;

--- Forbid to knockdown the building type on the territory.
--- @param _PlayerID integer ID of player
--- @param _Type integer ID of type
--- @param _Territory integer ID of territory
--- @return integer ID ID of knockdown restriction
function BlacklistKnockdownTypeInTerritory(_PlayerID, _Type, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistKnockdownTypeInTerritory(_PlayerID, _Type, _Territory);
end
API.BlacklistKnockdownTypeInTerritory = BlacklistKnockdownTypeInTerritory;

--- Forbid to knockdown the building category on the territory.
--- @param _PlayerID integer ID of player
--- @param _Category integer Category to check
--- @param _Territory integer ID of territory
--- @return integer ID ID of knockdown restriction
function BlacklistKnockdownCategoryInTerritory(_PlayerID, _Category, _Territory)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Construction.Global:BlacklistKnockdownCategoryInTerritory(_PlayerID, _Category, _Territory);
end
API.BlacklistKnockdownCategoryInTerritory = BlacklistKnockdownCategoryInTerritory;

--- Removes any protection by ID.
--- @param _ID integer ID of Protection
function DeleteFromProtectionList(_ID)
end
API.DeleteFromProtectionList = DeleteFromProtectionList;

--- Removes any restriction by ID.
--- @param _ID integer ID of Restriction
function DeleteFromRestrictionList(_ID)
end
API.DeleteFromRestrictionList = DeleteFromRestrictionList;

