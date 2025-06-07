--- Implements settlement survival aspects in the game.
---
--- Settlers (and farm animals) can now become sick from different causes and
--- might die permamently. If a settler dies, they will still be attached to
--- the building so that no other settler can replace them. After some time a
--- new settler will arrive. In addition the need for clothing is also active
--- for gatherers.
---
--- Things that ignite buildings:
--- <li>Hot temperature</li>
---
--- Things that makes settlers sick:
--- <li>Having not enough hygiene</li>
--- <li>Having not enough entertainment</li>
--- <li>Having not enough firewood</li>
---
--- Things that kills settlers:
--- <li>being sick (5% chance each period)</li>
--- <li>being hungry (5% chance each period)</li>
---
--- Things that kills animals:
--- <li>being sick (5% chance each period)</li>



--- Activates or deactivates the mode.
--- @param _Flag boolean Indicates whether the mode is active
function SettlementSurvivalActivate(_Flag)
end
API.SettlementSurvivalActivate = SettlementSurvivalActivate;

--- Enables or disables animals dying from disease.
--- @param _Flag boolean Feature is active
function AnimalPlagueActivate(_Flag)
end
API.AnimalPlagueActivate = AnimalPlagueActivate;

--- Enables or disables animals dying from disease for AI players.
--- @param _Flag boolean Feature is active
function AnimalPlagueActivateForAI(_Flag)
end
API.AnimalPlagueActivateForAI = AnimalPlagueActivateForAI;

--- Changes the interval between deaths of sick animals.
--- @param _Interval integer New interval time
function AnimalPlagueSetDeathInterval(_Interval)
end
API.AnimalPlagueSetDeathInterval = AnimalPlagueSetDeathInterval;

--- Changes the chance of death for sick animals.
--- @param _Chance integer Chance (between 1 and 100)
function AnimalPlagueSetDeathChance(_Chance)
end
API.AnimalPlagueSetDeathChance = AnimalPlagueSetDeathChance;

--- Changes the interval between infections for animals.
--- @param _Interval integer New interval time
function AnimalPlagueSetInfectionInterval(_Interval)
end
API.AnimalPlagueSetInfectionInterval = AnimalPlagueSetInfectionInterval;

--- Changes the chance of infection for animals.
--- @param _Chance integer Chance (between 1 and 100)
function AnimalPlagueSetInfectionChance(_Chance)
end
API.AnimalPlagueSetInfectionChance = AnimalPlagueSetInfectionChance;

--- nables or disables city fires.
--- @param _Flag boolean Feature is active
function HotWeatherActivate(_Flag)
end
API.HotWeatherActivate = HotWeatherActivate;

--- Enables or disables city fires for AI players.
--- @param _Flag boolean Feature is active
function HotWeatherActivateForAI(_Flag)
end
API.HotWeatherActivateForAI = HotWeatherActivateForAI;

--- Sets the temperature at which buildings catch fire.
--- @param _Temperature integer Start of cold temperatures 
function HotWeatherSetTemperature(_Temperature)
end
API.HotWeatherSetTemperature = HotWeatherSetTemperature;

--- Changes the chance of buildings catching fire.
--- @param _Chance integer Chance (between 1 and 100)
function HotWeatherSetIgnitionChance(_Chance)
end
API.HotWeatherSetIgnitionChance = HotWeatherSetIgnitionChance;

--- Enables or disables need for firewood.
--- @param _Flag boolean Feature is active
function ColdWeatherActivate(_Flag)
end
API.ColdWeatherActivate = ColdWeatherActivate;

--- Enables or disables need for firewood for AI players.
--- @param _Flag boolean Feature is active
function ColdWeatherActivateForAI(_Flag)
end
API.ColdWeatherActivateForAI = ColdWeatherActivateForAI;

--- Sets the temperature at which the weather is considered uncomfortable.
--- @param _Temperature integer Start of cold temperatures 
function ColdWeatherSetTemperature(_Temperature)
end
API.ColdWeatherSetTemperature = ColdWeatherSetTemperature;

--- Changes the interval between two consumtions of firewood.
--- @param _Interval integer New interval time
function ColdWeatherSetConsumptionInterval(_Interval)
end
API.ColdWeatherSetConsumptionInterval = ColdWeatherSetConsumptionInterval;

--- Changes the chance of infection because of cold weather.
--- @param _Chance integer Chance (between 1 and 100)
function ColdWeatherSetInfectionChance(_Chance)
end
API.ColdWeatherSetInfectionChance = ColdWeatherSetInfectionChance;

--- Enables or disables starvation of settlers.
--- @param _Flag boolean Feature is active
function FamineActivate(_Flag)
end
API.FamineActivate = FamineActivate;

--- Enables or disables starvation of settlers for AI players.
--- @param _Flag boolean Feature is active
function FamineActivateForAI(_Flag)
end
API.FamineActivateForAI = FamineActivateForAI;

--- Changes the interval between deaths because of starvation.
--- @param _Interval integer New interval time
function FamineSetDeathInterval(_Interval)
end
API.FamineSetDeathInterval = FamineSetDeathInterval;

--- Changes the chance of death for starving settlers.
--- @param _Chance integer Chance (between 1 and 100)
function FamineSetDeathChance(_Chance)
end
API.FamineSetDeathChance = FamineSetDeathChance;

--- Enables or disables settlers becoming ill due to neglect.
--- @param _Flag boolean Feature is active
function NegligenceActivate(_Flag)
end
API.NegligenceActivate = NegligenceActivate;

--- Enables or disables settlers becoming ill due to neglect for AI players.
--- @param _Flag boolean Feature is active
function NegligenceActivateForAI(_Flag)
end
API.NegligenceActivateForAI = NegligenceActivateForAI;

--- Changes the interval between infections due to neglect.
--- @param _Interval integer New interval time
function NegligenceSetInfectionInterval(_Interval)
end
API.NegligenceSetInfectionInterval = NegligenceSetInfectionInterval;

--- Changes the chance of infection due to neglect.
--- @param _Chance integer Chance (between 1 and 100)
function NegligenceSetInfectionChance(_Chance)
end
API.NegligenceSetInfectionChance = NegligenceSetInfectionChance;

--- Enables or disables settlers dying from disease.
--- @param _Flag boolean Feature is active
function PlagueActivate(_Flag)
end
API.PlagueActivate = PlagueActivate;

--- Enables or disables settlers dying from disease for AI players.
--- @param _Flag boolean Feature is active
function PlagueActivateForAI(_Flag)
end
API.PlagueActivateForAI = PlagueActivateForAI;

--- Changes the interval between deaths of sick settlers.
--- @param _Interval integer New interval time
function PlagueSetDeathInterval(_Interval)
end
API.PlagueSetDeathInterval = PlagueSetDeathInterval;

--- Changes the chance of death for sick settlers.
--- @param _Chance integer Chance (between 1 and 100)
function PlagueSetDeathChance(_Chance)
end
API.PlagueSetDeathChance = PlagueSetDeathChance;

--- Enables or disables the check for hostile predators in a territory.
--- @param _Flag boolean Condition active
function PredatorBlockClaimActivate(_Flag)
end
API.PredatorBlockClaimActivate = PredatorBlockClaimActivate;

--- Enables or disables the check for hostile bandits in a territory.
--- @param _Flag boolean Condition active
function BanditsBlockClaimActivate(_Flag)
end
API.BanditsBlockClaimActivate = BanditsBlockClaimActivate;

--- Enables or disables clothes need for outer rim buildings.
--- @param _Flag boolean Need active
function ClothesForOuterRimActivate(_Flag)
end
API.ClothesForOuterRimActivate = ClothesForOuterRimActivate;

--- Enables or disables if buildings have a base consumltion.
--- @param _Flag boolean Consumption active
function BaseConsumptionActivate(_Flag)
end
API.BaseConsumptionActivate = BaseConsumptionActivate;

--- Enables or disables if buildings of the AI also have base consumption.
--- @param _Flag boolean Consumption active
function BaseConsumptionActivateForAI(_Flag)
end
API.BaseConsumptionActivateForAI = BaseConsumptionActivateForAI;



--- An animal has died from illness.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of animal
Report.AnimalDiedFromIllness = anyInteger;

--- A settler has starved to death.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of settler
Report.SettlerDiedFromStarvation = anyInteger;

--- A settler has died from illness.
---
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of settler
Report.SettlerDiedFromIllness = anyInteger;

