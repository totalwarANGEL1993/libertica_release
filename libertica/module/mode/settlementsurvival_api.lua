Lib.Require("comfort/IsLocalScript");
Lib.Register("module/mode/SettlementSurvival_API");

function SettlementSurvivalActivate(_Flag)
    local Flag = _Flag == true;
    Lib.SettlementSurvival.Global.IsActive = Flag;
    ExecuteLocal([[Lib.SettlementSurvival.Local.IsActive = %s]], tostring(Flag));
end
API.SettlementSurvivalActivate = SettlementSurvivalActivate;

function AnimalPlagueActivate(_Flag)
    Lib.SettlementSurvival.Global.AnimalPlague.IsActive = _Flag == true;
end
API.AnimalPlagueActivate = AnimalPlagueActivate;

function AnimalPlagueActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.AnimalPlague.AffectAI = _Flag == true;
end
API.AnimalPlagueActivateForAI = AnimalPlagueActivateForAI;

function AnimalPlagueSetDeathInterval(_Interval)
    Lib.SettlementSurvival.Shared.AnimalPlague.DeathTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.AnimalPlague.DeathTimer = %d]], _Interval);
end
API.AnimalPlagueSetDeathInterval = AnimalPlagueSetDeathInterval;

function AnimalPlagueSetDeathChance(_Chance)
    Lib.SettlementSurvival.Shared.AnimalPlague.DeathChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.AnimalPlague.DeathChance = %d]], _Chance);
end
API.AnimalPlagueSetDeathChance = AnimalPlagueSetDeathChance;

function AnimalPlagueSetInfectionInterval(_Interval)
    Lib.SettlementSurvival.Shared.AnimalPlague.InfectionTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.AnimalPlague.InfectionTimer = %d]], _Interval);
end
API.AnimalPlagueSetInfectionInterval = AnimalPlagueSetInfectionInterval;

function AnimalPlagueSetInfectionChance(_Chance)
    Lib.SettlementSurvival.Shared.AnimalPlague.InfectionChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.AnimalPlague.InfectionChance = %d]], _Chance);
end
API.AnimalPlagueSetInfectionChance = AnimalPlagueSetInfectionChance;

function HotWeatherActivate(_Flag)
    Lib.SettlementSurvival.Global.HotWeather.IsActive = _Flag == true;
end
API.HotWeatherActivate = HotWeatherActivate;

function HotWeatherActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.HotWeather.AffectAI = _Flag == true;
end
API.HotWeatherActivateForAI = HotWeatherActivateForAI;

function HotWeatherSetTemperature(_Temperature)
    Lib.SettlementSurvival.Shared.HotWeather.Temperature = _Temperature;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.HotWeather.Temperature = %d]], _Temperature);
end
API.HotWeatherSetTemperature = HotWeatherSetTemperature;

function HotWeatherSetIgnitionChance(_Chance)
    Lib.SettlementSurvival.Shared.HotWeather.IgnitionChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.HotWeather.IgnitionChance = %d]], _Chance);
end
API.HotWeatherSetIgnitionChance = HotWeatherSetIgnitionChance;

function ColdWeatherActivate(_Flag)
    Lib.SettlementSurvival.Global.ColdWeather.IsActive = _Flag == true;
end
API.ColdWeatherActivate = ColdWeatherActivate;

function ColdWeatherActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.ColdWeather.AffectAI = _Flag == true;
end
API.ColdWeatherActivateForAI = ColdWeatherActivateForAI;

function ColdWeatherSetTemperature(_Temperature)
    Lib.SettlementSurvival.Shared.ColdWeather.Temperature = _Temperature;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.ColdWeather.Temperature = %d]], _Temperature);
end
API.ColdWeatherSetTemperature = ColdWeatherSetTemperature;

function ColdWeatherSetConsumptionInterval(_Interval)
    Lib.SettlementSurvival.Shared.ColdWeather.ConsumptionTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.ColdWeather.ConsumptionTimer = %d]], _Interval);
end
API.ColdWeatherSetConsumptionInterval = ColdWeatherSetConsumptionInterval;

function ColdWeatherSetInfectionChance(_Chance)
    Lib.SettlementSurvival.Shared.ColdWeather.InfectionChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.ColdWeather.InfectionChance = %d]], _Chance);
end
API.ColdWeatherSetInfectionChance = ColdWeatherSetInfectionChance;

function FamineActivate(_Flag)
    Lib.SettlementSurvival.Global.Famine.IsActive = _Flag == true;
end
API.FamineActivate = FamineActivate;

function FamineActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.Famine.AffectAI = _Flag == true;
end
API.FamineActivateForAI = FamineActivateForAI;

function FamineSetDeathInterval(_Interval)
    Lib.SettlementSurvival.Shared.Famine.DeathTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Famine.DeathTimer = %d]], _Interval);
end
API.FamineSetDeathInterval = FamineSetDeathInterval;

function FamineSetDeathChance(_Chance)
    Lib.SettlementSurvival.Shared.Famine.DeathChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Famine.DeathChance = %d]], _Chance);
end
API.FamineSetDeathChance = FamineSetDeathChance;

function NegligenceActivate(_Flag)
    Lib.SettlementSurvival.Global.Negligence.IsActive = _Flag == true;
end
API.NegligenceActivate = NegligenceActivate;

function NegligenceActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.Negligence.AffectAI = _Flag == true;
end
API.NegligenceActivateForAI = NegligenceActivateForAI;

function NegligenceSetInfectionInterval(_Interval)
    Lib.SettlementSurvival.Shared.Negligence.InfectionTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Negligence.InfectionTimer = %d]], _Interval);
end
API.NegligenceSetInfectionInterval = NegligenceSetInfectionInterval;

function NegligenceSetInfectionChance(_Chance)
    Lib.SettlementSurvival.Shared.Negligence.InfectionChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Negligence.InfectionChance = %d]], _Chance);
end
API.NegligenceSetInfectionChance = NegligenceSetInfectionChance;

function PlagueActivate(_Flag)
    Lib.SettlementSurvival.Global.Plague.IsActive = _Flag == true;
end
API.PlagueActivate = PlagueActivate;

function PlagueActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.Plague.AffectAI = _Flag == true;
end
API.PlagueActivateForAI = PlagueActivateForAI;

function PlagueSetDeathInterval(_Interval)
    Lib.SettlementSurvival.Shared.Plague.DeathTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Plague.DeathTimer = %d]], _Interval);
end
API.PlagueSetDeathInterval = PlagueSetDeathInterval;

function PlagueSetDeathChance(_Chance)
    Lib.SettlementSurvival.Shared.Plague.DeathChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Plague.DeathChance = %d]], _Chance);
end
API.PlagueSetDeathChance = PlagueSetDeathChance;

function PredatorBlockClaimActivate(_Flag)
    Lib.SettlementSurvival.Global.Misc.PredatorBlockClaim = _Flag == true;
end
API.PredatorBlockClaimActivate = PredatorBlockClaimActivate;

function BanditsBlockClaimActivate(_Flag)
    Lib.SettlementSurvival.Global.Misc.BanditsBlockClaim = _Flag == true;
end
API.BanditsBlockClaimActivate = BanditsBlockClaimActivate;

function ClothesForOuterRimActivate(_Flag)
    Lib.SettlementSurvival.Global.Misc.ClothesForOuterRim = _Flag == true;
    ExecuteLocal(
        [[Lib.SettlementSurvival.Local.Misc.ClothesForOuterRim = %s]],
        tostring(_Flag == true)
    );
    Lib.SettlementSurvival.Global:UpdateClothesStateForOuterRim();
end
API.ClothesForOuterRimActivate = ClothesForOuterRimActivate;

function BaseConsumptionActivate(_Flag)
    local Flag = _Flag == true;
    Lib.SettlementSurvival.Global.Consume.IsActive = Flag;
    ExecuteLocal([[Lib.SettlementSurvival.Local.Consume.IsActive = %s]], tostring(Flag));
end
API.BaseConsumptionActivate = BaseConsumptionActivate;

function BaseConsumptionActivateForAI(_Flag)
    local Flag = _Flag == true;
    Lib.SettlementSurvival.Global.Consume.AffectAI = Flag;
    ExecuteLocal([[Lib.SettlementSurvival.Local.Consume.AffectAI = %s]], tostring(Flag));
end
API.BaseConsumptionActivateForAI = BaseConsumptionActivateForAI;

