--- Implements stricter building restrictions in the game.
---
--- When the mode is activated, the predefined standard rules apply. These
--- can be customized to a limited extent.
---
--- Standard rules:
--- <li>The number of buildings in the home territory is not limited</li>
--- <li>City buildings can only be built in the home territory</li>
--- <li>In territories, only 3 buildings can be built.</li>
--- <li>Each building type can only be built once per territory.</li>
--- <li>When a outpost is upgraded, one building type can be placed twice on the territory.</li>
--- <li>Beehives, beautifications and fields do not count as buildings.</li>



--- Activates or deactivates the mode.
--- @param _Flag boolean Indicates whether the mode is active
function ActivateSettlementLimitation(_Flag)
end

--- Activates or deactivates the upkeep for walls.
--- @param _Flag boolean Walls will cost money
function UseWallUpkeepCosts(_Flag)
end
API.UseWallUpkeepCosts = UseWallUpkeepCosts;

--- Activates or deactivates the deteriation of walls if upkeep is not payed.
--- Rampart upkeep must be active!
--- @param _Flag boolean Walls deteriate
function UseWallDeteriation(_Flag)
end
API.UseWallDeteriation = UseWallDeteriation;

--- Sets the title, required for developing territories.
--- @param _Title integer Knight title
function RequireTitleToDevelopTerritory(_Title)
end

--- Allows or forbids to develop territories.
--- @param _PlayerID integer ID of player
--- @param _Allowed boolean Developing allowed
function AllowDevelopTerritory(_PlayerID, _Allowed)
end

--- Sets the general building limit for the player in the territory.
--- @param _PlayerID integer ID of the player
--- @param _Territory any Name or ID of the territory
--- @param _Limit integer General limit
function SetTerritoryBuildingLimit(_PlayerID, _Territory, _Limit)
end

--- Sets the specific limit of the building type for the player in the territory.
--- @param _PlayerID integer ID of the player
--- @param _Territory any Name or ID of the territory
--- @param _Type integer Type of the building
--- @param _Limit integer Specific limit
function SetTerritoryBuildingTypeLimit(_PlayerID, _Territory, _Type, _Limit)
end

--- Clears the general building limit.
--- @param _PlayerID integer ID of the player
--- @param _Territory any Name or ID of the territory
function ClearTerritoryBuildingLimit(_PlayerID, _Territory)
end

--- Clears the specific limit of the building type.
--- @param _PlayerID integer ID of the player
--- @param _Territory any Name or ID of the territory
--- @param _Type integer Type of the building
function ClearTerritoryBuildingTypeLimit(_PlayerID, _Territory, _Type)
end

--- Modifies the costs for territory development.
--- @param _CostType1 integer Resource 1
--- @param _Amount1 integer Amount 1
--- @param _CostType2? integer (optional) Resource 2
--- @param _Amount2? integer (optional) Amount 2
function SetTerritoryDevelopmentCost(_CostType1, _Amount1, _CostType2, _Amount2)
end

--- Adds a territory to the build blacklist of the type.
--- @param _Type integer Building type
--- @param _Territory integer Territory ID
function AddToBuildingTerritoryBlacklist(_Type, _Territory)
end
API.AddToBuildingTerritoryBlacklist = AddToBuildingTerritoryBlacklist;

--- Adds a territory to the build whitelist of the type.
--- @param _Type integer Building type
--- @param _Territory integer Territory ID
function AddToBuildingTerritoryWhitelist(_Type, _Territory)
end
API.AddToBuildingTerritoryWhitelist = AddToBuildingTerritoryWhitelist;

--- Removes a territory from the build blacklist of the type.
--- @param _Type integer Building type
--- @param _Territory integer Territory ID
function RemoveFromBuildingTerritoryBlacklist(_Type, _Territory)
end
API.RemoveFromBuildingTerritoryBlacklist = RemoveFromBuildingTerritoryBlacklist;

--- Removes a territory from the build whitelist of the type.
--- @param _Type integer Building type
--- @param _Territory integer Territory ID
function RemoveFromBuildingTerritoryWhitelist(_Type, _Territory)
end
API.RemoveFromBuildingTerritoryWhitelist = RemoveFromBuildingTerritoryWhitelist;

--- Activates or deactivates the limitation of outpost a player can have.
--- @param _Flag boolean Outpost limit active
function ActivateOutpostLimit(_Flag)
end
API.ActivateOutpostLimit = ActivateOutpostLimit;

--- Changes the outpost limit for the castle upgrade level.
--- @param _UpgradeLevel integer Castle upgrade level
--- @param _Limit integer Limit of outposts
function SetOutpostLimit(_UpgradeLevel, _Limit)
end
API.SetOutpostLimit = SetOutpostLimit;

