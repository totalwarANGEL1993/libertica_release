--- Offers tools for different modifications of the 2D interface.
---
--- The following player related can be changed:
--- * Player color
--- * Player name
--- * Player portrait
--- * Territory name
---
--- The following menu related can be changed:
--- * Show/Hide minimap
--- * Show/Hide toggle minimap
--- * Show/Hide Diplomacy menu
--- * Show/Hide Production menu
--- * Show/Hide Weather menu
--- * Show/Hide Construction menu
--- * Show/Hide Claim territory button
--- * Show/Hide Hero ability button
--- * Show/Hide Select hero button
--- * Show/Hide Select units button
---
--- #### Reports
--- `Report.BuildingPlaced` - A human player has placed a building.
---
Lib.UITools = Lib.UITools or {};



--- Sets an icon from an icon matrix.
---
--- It is possible to use a custom icon matrix. Files must be copied to gui_768,
--- gui_920 and gui_1200 and scaled to the appropiate size. Files must be packed
--- to graphics/textures inside the map archive.
---
--- There are 3 different icon sizes. For each size the game enginge searches
--- for a different file:
--- * 44:  [filename].png
--- * 64:  [filename]big.png
--- * 128: [filename]verybig.png
---
--- #### Examples
--- ```lua
--- -- Example #1: Use a ingame graphic
--- ChangeIcon(AnyWidgetID, {1, 1, 1});
---
--- -- Example #2: use a user defined graphic
--- -- (meinetolleniconsbig.png is searched)
--- ChangeIcon(AnyWidgetID, {8, 5}, nil, "meinetollenicons");
---
--- -- Example #3: use large user defined graphic
--- -- (meinetolleniconsverybig.png is searched)
--- ChangeIcon(AnyWidgetID, {8, 5}, 128, "meinetollenicons");
--- ```
---
--- @param _WidgetID any Path or ID of widget
--- @param _Coordinates table Table with coordinates
--- @param _Size? number Optional icon size
--- @param _Name? string Optional icon file
function ChangeIcon(_WidgetID, _Coordinates, _Size, _Name)
end
API.SetIcon = ChangeIcon;

--- Changes the description of a button or icon.
--- @param _Title any Title text or localized table
--- @param _Text any Text or localized table
--- @param _DisabledText any? Text or localized table
function SetTooltipNormal(_Title, _Text, _DisabledText)
end
API.SetTooltipNormal = SetTooltipNormal;

--- Changes the description of a button or icon with additional costs.
--- @param _Title any Title text or localized table
--- @param _Text any Text or localized table
--- @param _DisabledText any? Text or localized table
--- @param _Costs table? Table with costs
--- @param _InSettlement boolean? Check all sources in settlement
function SetTooltipCosts(_Title, _Text, _DisabledText, _Costs, _InSettlement)
end
API.SetTooltipCosts = SetTooltipCosts;

--- Changes the visibility of the minimap.
--- @param _Flag boolean Widget is hidden
function HideMinimap(_Flag)
end
API.HideMinimap = HideMinimap;

--- Changes the visibility of the minimap button.
--- @param _Flag boolean Widget is hidden
function HideToggleMinimap(_Flag)
end
API.HideToggleMinimap = HideToggleMinimap;

--- Changes the visibility of the diplomacy menu button.
--- @param _Flag boolean Widget is hidden
function HideDiplomacyMenu(_Flag)
end
API.HideDiplomacyMenu = HideDiplomacyMenu;

--- Changes the visibility of the produktion menu button.
--- @param _Flag boolean Widget is hidden
function HideProductionMenu(_Flag)
end
API.HideProductionMenu = HideProductionMenu;

--- Changes the visibility of the weather menu button.
--- @param _Flag boolean Widget is hidden
function HideWeatherMenu(_Flag)
end
API.HideWeatherMenu = HideWeatherMenu;

--- Changes the visibility of the territory button.
--- @param _Flag boolean Widget is hidden
function HideBuyTerritory(_Flag)
end
API.HideBuyTerritory = HideBuyTerritory;

--- Changes the visibility of the knight ability button.
--- @param _Flag boolean Widget is hidden
function HideKnightAbility(_Flag)
end
API.HideKnightAbility = HideKnightAbility;

--- Changes the visibility of the knight selection button.
--- @param _Flag boolean Widget is hidden
function HideKnightButton(_Flag)
end
API.HideKnightButton = HideKnightButton;

--- Changes the visibility of the select military button.
--- @param _Flag boolean Widget is hidden
function HideSelectionButton(_Flag)
end
API.HideSelectionButton = HideSelectionButton;

--- Changes the visibility of the build menu.
--- @param _Flag boolean Widget is hidden
function HideBuildMenu(_Flag)
end
API.HideBuildMenu = HideBuildMenu;

--- Adds a new shortcut description.
--- @param _Key string Key of shortcut
--- @param _Description any Text or localized table
--- @return integer ID ID of description
function AddShortcutDescription(_Key, _Description)
    return 0;
end
API.AddShortcutDescription = AddShortcutDescription;

--- Removes the shortcut description with the ID.
--- @param _ID number ID of shortcut
function RemoveShortcutDescription(_ID)
end
API.RemoveShortcutDescription = RemoveShortcutDescription;

--- Activates or deactivates the forced speed 1.
--- @param _Flag boolean Is active
function SpeedLimitActivate(_Flag)
end
API.SpeedLimitActivate = SpeedLimitActivate;

--- Returns the name of the territory.
--- @param _TerritoryID number ID of territory
--- @return string Name Name of territory
function GetTerritoryName(_TerritoryID)
    return "";
end
API.GetTerritoryName = GetTerritoryName;

--- Returns the name of the player.
--- @param _PlayerID number ID of player
--- @return string Name Name of player
function GetPlayerName(_PlayerID)
    return "";
end
API.GetPlayerName = GetPlayerName;

---Changes the name of a player.
---@param _PlayerID number ID of player
---@param _Name string Player name
function SetPlayerName(_PlayerID, _Name)
end
API.SetPlayerName = SetPlayerName;

--- Changes the color of a player.
--- @param _PlayerID number ID of player
--- @param _Color any Name or ID of color
--- @param _Logo? number ID of logo
--- @param _Pattern? number ID of pattern
function SetPlayerColor(_PlayerID, _Color, _Logo, _Pattern)
end
API.SetPlayerColor = SetPlayerColor;

--- Changes the portrait of a player.
---
--- #### Examples
--- ```lua
--- -- Example #1: Set model by player hero
--- SetPlayerPortrait(2);
--- -- Example #2: Set model by type of entity
--- SetPlayerPortrait(2, "amma");
--- -- Example #3: Set model name directly
--- SetPlayerPortrait(2, "H_NPC_Monk_AS");
--- ```
--- @param _PlayerID number  ID of player
--- @param _Portrait? string Name of model
function SetPlayerPortrait(_PlayerID, _Portrait)
end
API.SetPlayerPortrait = SetPlayerPortrait;


--- A human player has placed a building.
--- 
--- #### Parameter
--- * `PlayerID` - ID of player
--- * `EntityID` - ID of eneity
Report.BuildingPlaced = anyInteger;

