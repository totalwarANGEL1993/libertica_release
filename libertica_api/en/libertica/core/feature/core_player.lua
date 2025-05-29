--- Allows to change names, portraits and colors for players.
---
--- The functionality includes:
--- <li>Player color</li>
--- <li>Player name</li>
--- <li>Player portrait</li>
--- <li>Territory name</li>

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
--- #### Example:
--- ```lua
--- -- Example #1: Set model by player hero
--- SetPlayerPortrait(2);
--- -- Example #2: Set model by type of entity
--- SetPlayerPortrait(2, "amma");
--- -- Example #3: Set model name directly
--- SetPlayerPortrait(2, "H_NPC_Monk_AS");
--- ```
--- 
--- @param _PlayerID number  ID of player
--- @param _Portrait? string Name of model
function SetPlayerPortrait(_PlayerID, _Portrait)
end
API.SetPlayerPortrait = SetPlayerPortrait;

