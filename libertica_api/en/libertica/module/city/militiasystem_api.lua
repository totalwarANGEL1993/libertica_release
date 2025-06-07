--- A system that enables the conscription of workers for military service.
---
--- #### Recruiting Militia
---
--- Militia units are recruited from the population. In order for workers
--- to become available as recruits, their building must be halted.
--- The workers then become soldiers.
---
--- When the unit is dismissed, the workers return to their building.
---
--- If soldiers are killed, a new worker will arrive in the settlement.
--- If the recruit was married, the wife will leave the city.
---
--- #### Special Abilities
---
--- Special abilities can be enabled for militia units. Each type has different
--- special units. These are shown in the tooltip. Additionally, the icon color
--- changes to distinguish militia units with special abilities from normal 
--- mercenaries.



--- Activates the conscription of workers into the military.
function ActivateMilitia()
end
API.ActivateMilitia = ActivateMilitia;

--- Deactivates the conscription of workers into the military.
function DeactivateMilitia()
end
API.DeactivateMilitia = DeactivateMilitia;

--- Adds special abilities to militia units.
--- 
--- If skills are activated, militia units will be colored differently in the
--- ui and effects are displayed in tooltips.
function ActivateMilitiaSkills()
end
API.ActivateMilitiaSkills = ActivateMilitiaSkills;

--- Removes special abilities from militia units.
function DeactivateMilitiaSkills()
end
API.DeactivateMilitiaSkills = DeactivateMilitiaSkills;

--- Sets the militia types for the climate zone for the player.
--- @param _PlayerID integer ID of player
function UseDefaultMilitiaTypes(_PlayerID)
end
API.UseDefaultMilitiaTypes = UseDefaultMilitiaTypes;

--- Sets the militia types for the climate zone.
function UseDefaultMilitiaTypesForAllPlayers()
end
API.UseDefaultMilitiaTypesForAllPlayers = UseDefaultMilitiaTypesForAllPlayers;

--- Sets new random militia types for the player.
--- @param _PlayerID integer ID of player
function UseRandomMilitiaTypes(_PlayerID)
end
API.UseRandomMilitiaTypes = UseRandomMilitiaTypes;

--- Sets new random militia types.
function UseRandomMilitiaTypesForAllPlayers()
end
API.UseRandomMilitiaTypesForAllPlayers = UseRandomMilitiaTypesForAllPlayers;

--- Allows only to enlist inactive workers for conscription.
function UseOnlyIdlingWorkersForMilitia()
end
API.UseOnlyIdlingWorkersForMilitia = UseOnlyIdlingWorkersForMilitia;

--- Allows to enlist all workers for conscription.
function UseAllWorkersForMilitia()
end
API.UseAllWorkersForMilitia = UseAllWorkersForMilitia;

--- Sets the required title for melee militia.
--- @param _Title integer Required title
function RequireTitleForMeleeMilitia(_Title)
end
API.RequireTitleForMeleeMilitia = RequireTitleForMeleeMilitia;

--- Sets the required title for ranged militia.
--- @param _Title integer Required title
function RequireTitleForRangedMilitia(_Title)
end
API.RequireTitleForRangedMilitia = RequireTitleForRangedMilitia;

