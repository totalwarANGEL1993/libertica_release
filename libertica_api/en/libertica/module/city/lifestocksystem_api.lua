--- Allows to breed lifestock.
---
--- Breeding cows and sheeps is bound to technologies. Those technologies can
--- also be added to the promotion system.
---
--- In addition there is the possivility to let farm animals starve if they
--- aren't fed.
---
--- #### Adds pseudo technologies:
--- * `Technologies.R_Cattle` - Allows to breed cows
--- * `Technologies.R_Sheep`  - Allows to breed sheeps
--- 



--- Changes the parameters for raising cows.
---
--- If the feeding timer is set to 0 animals don't need to be fed at all. All
--- fields left out in the table will be reset to the default.
---
--- #### Fields
--- * `BasePrice`    - Base price at regular merchants (Default: 300)
--- * `GrainCost`    - Costs to buy a single animal (Default: 10)
--- * `GrainUpkeep`  - Costs to upkeep the animals (Default: 1)
--- * `FeedingTimer` - Frequency the upkeep is checked (Default: 0)
--- * `StarveChance` - Chance a animal starves if hungry (Default: 35)
---
--- @param _Data table Breeding configuration
function SetCattleBreedingParameters(_Data)
end
API.SetCattleBreedingParameters = SetCattleBreedingParameters;

--- Changes the parameters for raising sheeps.
---
--- If the feeding timer is set to 0 animals don't need to be fed at all. All
--- fields left out in the table will be reset to the default.
---
--- #### Fields
--- * `BasePrice`    - Base price at regular merchants (Default: 300)
--- * `GrainCost`    - Costs to buy a single animal (Default: 10)
--- * `GrainUpkeep`  - Costs to upkeep the animals (Default: 1)
--- * `FeedingTimer` - Frequency the upkeep is checked (Default: 0)
--- * `StarveChance` - Chance a animal starves if hungry (Default: 35)
---
--- @param _Data table Breeding configuration
function SetSheepBreedingParameters(_Data)
end
API.SetSheepBreedingParameters = SetSheepBreedingParameters;

--- Sets the required title to breed cows.
---
--- Per default breeding cows is allowed from the start.
--- @param _Title integer Required title
function RequireTitleToBreedCattle(_Title)
end
API.RequireTitleToBreedCattle = RequireTitleToBreedCattle;

--- Sets the required title to breed sheeps.
---
--- Per default breeding sheeps is allowed from the start.
--- @param _Title integer Required title
function RequireTitleToBreedSheep(_Title)
end
API.RequireTitleToBreedSheep = RequireTitleToBreedSheep;



--- The player has clicked the buy animal button.
--- 
--- #### Parameters:
--- * `Index`:      <b>integer</b> "Cattle" or "Sheep"
--- * `PlayerID`:   <b>integer</b> ID of player
--- * `EntityID`:   <b>integer</b> ID of pasture
Report.BreedAnimalClicked = anyInteger;

--- The player has bought a cow.
--- 
--- #### Parameters:
--- * `PlayerID`:   <b>integer</b> ID of player
--- * `EntityID`:   <b>integer</b> ID of created cow
--- * `BuildingID`: <b>integer</b> ID of pasture
Report.CattleBought = anyInteger;

--- The player has bought a sheep.
--- 
--- #### Parameters:
--- * `PlayerID`:   <b>integer</b> ID of player
--- * `EntityID`:   <b>integer</b> ID of created sheep
--- * `BuildingID`: <b>integer</b> ID of pasture
Report.SheepBought = anyInteger;

--- A cow has starved.
--- 
--- #### Parameters:
--- * `PlayerID`:   <b>integer</b> ID of player
--- * `EntityID`:   <b>integer</b> ID of created cow
Report.CattleStarved = anyInteger;

--- A sheep has starved.
--- 
--- #### Parameters:
--- * `PlayerID`:   <b>integer</b> ID of player
--- * `EntityID`:   <b>integer</b> ID of created cow
Report.SheepStarved = anyInteger;

