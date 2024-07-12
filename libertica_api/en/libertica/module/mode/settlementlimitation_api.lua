--- Implements stricter building restrictions in the game.
---
--- When the mode is activated, the predefined standard rules apply. These
--- can be customized to a limited extent.
---
--- Standard rules:
--- * The number of buildings in the home territory is not limited
--- * City buildings can only be built in the home territory
--- * In territories, only 3 buildings can be built.
--- * When a outpost is upgraded the max amount of buildings is permemently
---   increased  to 4.
--- * Each building type can only be built once per territory.
--- * Territories can be developed once by paying costs. Developing a territory
---   enables the construction of two buildings of the same type.
--- * Beehives, beautifications and fields do not count as buildings.
---
Lib.SettlementLimitation = Lib.SettlementLimitation or {};

--- Activates or deactivates the mode.
--- @param _Flag boolean Indicates whether the mode is active
function ActivateSettlementLimitation(_Flag)
end

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