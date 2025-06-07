Lib.SettlementSurvival = Lib.SettlementSurvival or {};
Lib.SettlementSurvival.Name = "SettlementSurvival";
Lib.SettlementSurvival.Global = {
    IsActive = false,
    AnimalPlague = {
        IsActive = false,
        AffectAI = false,
    },
    Famine = {
        IsActive = true,
        AffectAI = false,
    },
    ColdWeather = {
        IsActive = true,
        AffectAI = false,
    },
    HotWeather = {
        IsActive = true,
        AffectAI = false,
    },
    Negligence = {
        IsActive = true,
        AffectAI = false,
    },
    Plague = {
        IsActive = true,
        AffectAI = false,
    },
    Consume = {
        BuildingData = {},
        IsActive = true,
        AffectAI = false,
    },
    Misc = {
        PredatorBlockClaim = false,
        BanditsBlockClaim = false,
        ClothesForOuterRim = false,
    },
};
Lib.SettlementSurvival.Local  = {
    IsActive = true,
    DeadSettlers = {},
    Consume = {
        IsActive = true,
        AffectAI = false,
    },
    Misc = {
        ClothesForOuterRim = false,
    },
};
Lib.SettlementSurvival.Shared = {
    AnimalPlague = {
        InfectionChance = 4,
        InfectionTimer = 90,
        DeathChance = 4,
        DeathTimer = 180,
    },
    ColdWeather = {
        ConsumptionFactor = 0.075,
        ConsumptionTimer = 30,
        Temperature = 5,
        InfectionChance = 12,
    },
    HotWeather = {
        IgnitionChance = 5,
        IgnitionTimer = 90,
        Temperature = 30,
    },
    Famine = {
        DeathChance = 6,
        DeathTimer = 30,
    },
    Negligence = {
        InfectionChance = 6,
        InfectionTimer = 90,
    },
    Plague = {
        DeathChance = 9,
        DeathTimer = 90,
    },
    Consume = {
        FoodFactor = 0.0012,
        ClothesFactor = 0.0006,
        BeerFactor = 0.0012,
        HygieneFactor = 0.0006,
        Progression = 35000,
    },
    SuspendedSettlers = {
        MourningTime = 5*60,
    },
};

Lib.Require("comfort/GetPredatorSpawnerTypes");
Lib.Require("comfort/GetHealth");
Lib.Require("comfort/SetHealth");
Lib.Require("core/Core");
Lib.Require("module/city/Construction");
Lib.Require("module/faker/Permadeath");
Lib.Require("module/ui/UIBuilding");
Lib.Require("module/ui/UITools");
Lib.Require("module/mode/SettlementSurvival_API");
Lib.Require("module/mode/SettlementSurvival_Text");
Lib.Register("module/mode/SettlementSurvival");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.SettlementSurvival.Global:Initialize()
    if not self.IsInstalled then
        Report.AnimalDiedFromIllness = CreateReport("Event_AnimalDiedFromIllness");
        Report.SettlerDiedFromStarvation = CreateReport("Event_SettlerDiedFromStarvation");
        Report.SettlerDiedFromIllness = CreateReport("Event_SettlerDiedFromIllness");

        for PlayerID= 1,8 do
            self.AnimalPlague[PlayerID] = {};
            self.ColdWeather[PlayerID] = {Consumption = 0};
            self.Famine[PlayerID] = {};
            self.Negligence[PlayerID] = {};
            self.Plague[PlayerID] = {};
            self.Consume[PlayerID] = {Buildings = {}};
        end

        RequestJobByEventType(
            Events.LOGIC_EVENT_EVERY_TURN,
            function()
                local Turn = Logic.GetCurrentTurn();
                Lib.SettlementSurvival.Global:ControlSettlersBaseConsumption(Turn);
                Lib.SettlementSurvival.Global:ControlSettlersBecomeIllDueToNegligence(Turn);
                Lib.SettlementSurvival.Global:ControlBuildingsDuringHotWeather(Turn);
                Lib.SettlementSurvival.Global:ControlBuildingsDuringColdWeather(Turn);
                Lib.SettlementSurvival.Global:ControlSettlersSuccumToFamine(Turn);
                Lib.SettlementSurvival.Global:ControlAnimalInfections(Turn);
                Lib.SettlementSurvival.Global:ControlAnimalCorpsesDecay(Turn);
                Lib.SettlementSurvival.Global:ControlAnimalsSuccumToPlague(Turn);
                Lib.SettlementSurvival.Global:ControlSettlersSuccumToPlague(Turn);
            end
        );

        self:OverwriteNeeds();
        self:InitLimitations();

        -- Garbage collection
        Lib.SettlementSurvival.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.SettlementSurvival.Global:OnSaveGameLoaded()
    self:RestoreSettlerSuspension();
end

-- Global report listener
function Lib.SettlementSurvival.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
        for PlayerID = 1, 8 do
            CustomRuleConstructBuilding(PlayerID, "SettlementSurvival_Global_ClaimTerritoryPredatorRule");
            CustomRuleConstructBuilding(PlayerID, "SettlementSurvival_Global_ClaimTerritoryBanditRule");
        end
    elseif _ID == Report.FireAlarmDeactivated_Internal then
        self:RestoreSettlerSuspension();
    elseif _ID == Report.FireAlarmActivated_Internal then
        self:RestoreSettlerSuspension();
    elseif _ID == Report.RepairAlarmDeactivated_Internal then
        self:RestoreSettlerSuspension();
    elseif _ID == Report.ReRepairAlarmActivated_Internal then
        self:RestoreSettlerSuspension();
    end
end

-- -------------------------------------------------------------------------- --

function Lib.SettlementSurvival.Global:InitLimitations()
    -- Check predators in territory
    SettlementSurvival_Global_ClaimTerritoryPredatorRule = function(_PlayerID, _Type, _X, _Y)
        if Lib.SettlementSurvival.Global.Misc.PredatorBlockClaim then
            if Logic.IsEntityTypeInCategory(_Type, EntityCategories.Outpost) == 1 then
                local TerritoryID1 = Logic.GetTerritoryAtPosition(_X, _Y);
                for _, SpawnerType in pairs(GetPredatorSpawnerTypes()) do
                    for _, SpawnerID in pairs(Logic.GetEntitiesOfType(SpawnerType)) do
                        local TerritoryID2 = GetTerritoryUnderEntity(SpawnerID);
                        if TerritoryID1 == TerritoryID2 then
                            for _, ID in pairs({Logic.GetSpawnedEntities(SpawnerID)}) do
                                local PlayerID = Logic.EntityGetPlayer(ID);
                                if PlayerID == 0 or (PlayerID ~= _PlayerID and GetDiplomacyState(PlayerID, _PlayerID) == -2) then
                                    return false;
                                end
                            end
                        end
                    end
                end
            end
        end
        return true;
    end

    -- Check bandits in territory
    SettlementSurvival_Global_ClaimTerritoryBanditRule = function(_PlayerID, _Type, _X, _Y)
        if Lib.SettlementSurvival.Global.Misc.BanditsBlockClaim then
            if Logic.IsEntityTypeInCategory(_Type, EntityCategories.Outpost) == 1 then
                local TerritoryID = Logic.GetTerritoryAtPosition(_X, _Y);
                for PlayerID = 1, 8 do
                    if PlayerID ~= _PlayerID and GetDiplomacyState(PlayerID, _PlayerID) == -2 then
                        local Bandits = {Logic.GetEntitiesOfCategoryInTerritory(TerritoryID, PlayerID, EntityCategories.BanditsCamp, 0)};
                        if #Bandits > 0 then
                            return false;
                        end
                    end
                end
            end
        end
        return true;
    end
end

-- -------------------------------------------------------------------------- --

-- Makes all buildings consume a base amount of their needed goods and resets
-- the state changes effects after end of work cycles. Satisfaction of a need
-- drops only if no other need is critical. This must be done due to settlers
-- are unable to fulfill more than one need at a time.
-- If buildings are far away from the players storehouse satisfaction will
-- decline slower so that they can work longer. This is to not punish the
-- player to hard for larger distances.
function Lib.SettlementSurvival.Global:ControlSettlersBaseConsumption(_Turn)
    local PlayerID = _Turn % 10;
    if self.IsActive and self.Consume.IsActive and PlayerID >= 1 and PlayerID <= 8 then
        if self.Consume.AffectAI or Logic.PlayerGetIsHumanFlag(PlayerID) then
            -- Get all buildings
            local OuterRim = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.OuterRimBuilding)};
            local City = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.CityBuilding)};
            local BuildingList = Array_Append(OuterRim, City);
            -- Calculate building consumption
            for i= 1, #BuildingList do
                local BuildingID = BuildingList[i];
                if not self.Consume[PlayerID].Buildings[BuildingID] then
                    self.Consume[PlayerID].Buildings[BuildingID] = {0.8, 0.8, 0.8, 0.8};
                end
                local IsStopped = Logic.IsBuildingStopped(BuildingID) == true;
                local IsOuterRim = Logic.IsEntityInCategory(BuildingID, EntityCategories.OuterRimBuilding) == 1;
                local AttachedSettlersAmount = CountWorkerInBuilding(BuildingID);
                local DistanceFactor = self:CalculateDistanceFactor(BuildingID);
                -- Consume food
                if Logic.IsNeedActive(BuildingID, Needs.Nutrition) then
                    local Factor = Lib.SettlementSurvival.Shared.Consume.FoodFactor;
                    Factor = (IsStopped and Factor * 0.50) or Factor;
                    Factor = (IsOuterRim and Factor * 0.50) or Factor;
                    Factor = Factor * DistanceFactor;
                    local Contentment = self.Consume[PlayerID].Buildings[BuildingID][1];
                    local ConsumeFactor = Factor * AttachedSettlersAmount;
                    if self:IsAnyOtherNeedCritical(BuildingID, Needs.Nutrition) then
                        ConsumeFactor = 0;
                    end
                    local Consume = math.max(Contentment - ConsumeFactor, 0);
                    local NeedState = Logic.GetNeedState(BuildingID, Needs.Nutrition);
                    if (NeedState - Consume > 0.1) then
                        Consume = (NeedState > 0.8 and NeedState) or 0.8;
                    end
                    self.Consume[PlayerID].Buildings[BuildingID][1] = Consume;
                    Logic.SetNeedState(BuildingID, Needs.Nutrition, Consume);
                end
                -- Consume clothes
                if Logic.IsNeedActive(BuildingID, Needs.Clothes) then
                    local Factor = Lib.SettlementSurvival.Shared.Consume.ClothesFactor;
                    Factor = (IsStopped and Factor * 0.50) or Factor;
                    Factor = (IsOuterRim and Factor * 0.25) or Factor;
                    Factor = Factor * DistanceFactor;
                    local Contentment = self.Consume[PlayerID].Buildings[BuildingID][2];
                    local ConsumeFactor = Factor * AttachedSettlersAmount;
                    if self:IsAnyOtherNeedCritical(BuildingID, Needs.Clothes) then
                        ConsumeFactor = 0;
                    end
                    local Consume = math.max(Contentment - ConsumeFactor, 0);
                    local NeedState = Logic.GetNeedState(BuildingID, Needs.Clothes);
                    if NeedState - Consume > 0.1 then
                        Consume = (NeedState > 0.8 and NeedState) or 0.8;
                    end
                    self.Consume[PlayerID].Buildings[BuildingID][2] = Consume;
                    Logic.SetNeedState(BuildingID, Needs.Clothes, Consume);
                end
                -- Consume hygiene
                if Logic.IsNeedActive(BuildingID, Needs.Hygiene) then
                    local Factor = Lib.SettlementSurvival.Shared.Consume.HygieneFactor;
                    Factor = (IsStopped and Factor * 0.50) or Factor;
                    Factor = (IsOuterRim and Factor * 0.25) or Factor;
                    Factor = Factor * DistanceFactor;
                    local Contentment = self.Consume[PlayerID].Buildings[BuildingID][3];
                    local ConsumeFactor = Factor * AttachedSettlersAmount;
                    if self:IsAnyOtherNeedCritical(BuildingID, Needs.Hygiene) then
                        ConsumeFactor = 0;
                    end
                    local Consume = math.max(Contentment - ConsumeFactor, 0);
                    local NeedState = Logic.GetNeedState(BuildingID, Needs.Hygiene);
                    if NeedState - Consume > 0.1 then
                        Consume = (NeedState > 0.8 and NeedState) or 0.8;
                    end
                    self.Consume[PlayerID].Buildings[BuildingID][3] = Consume;
                    Logic.SetNeedState(BuildingID, Needs.Hygiene, Consume);
                end
                -- Consume beer
                if Logic.IsNeedActive(BuildingID, Needs.Entertainment) then
                    local Factor = Lib.SettlementSurvival.Shared.Consume.BeerFactor;
                    Factor = (IsStopped and Factor * 0.50) or Factor;
                    Factor = (IsOuterRim and Factor * 0.25) or Factor;
                    Factor = Factor * DistanceFactor;
                    local Contentment = self.Consume[PlayerID].Buildings[BuildingID][4];
                    local ConsumeFactor = Factor * AttachedSettlersAmount;
                    if self:IsAnyOtherNeedCritical(BuildingID, Needs.Entertainment) then
                        ConsumeFactor = 0;
                    end
                    local Consume = math.max(Contentment - ConsumeFactor, 0);
                    local NeedState = Logic.GetNeedState(BuildingID, Needs.Entertainment);
                    if NeedState - Consume > 0.1 then
                        Consume = (NeedState > 0.8 and NeedState) or 0.8;
                    end
                    self.Consume[PlayerID].Buildings[BuildingID][4] = Consume;
                    Logic.SetNeedState(BuildingID, Needs.Entertainment, Consume);
                end
                -- Save distance
                if not self.Consume[PlayerID].Buildings[BuildingID].Factor then
                    self.Consume[PlayerID].Buildings[BuildingID].Factor = DistanceFactor;
                end
            end
        end
    end
end

-- Checks if any other need than the passed one is critical.
function Lib.SettlementSurvival.Global:IsAnyOtherNeedCritical(_BuildingID, _Need)
    local NeedState, NeedCritical;
    -- Check sickness
    NeedState = Logic.GetNeedState(_BuildingID, Needs.Medicine);
    NeedCritical = Logic.GetNeedCriticalThreshold(_BuildingID, Needs.Medicine);
    if _Need ~= Needs.Medicine and NeedState <= NeedCritical then
        return true;
    end
    -- Check food
    NeedState = Logic.GetNeedState(_BuildingID, Needs.Nutrition);
    NeedCritical = Logic.GetNeedCriticalThreshold(_BuildingID, Needs.Nutrition);
    if _Need ~= Needs.Nutrition and NeedState <= NeedCritical then
        return true;
    end
    -- Check clothes
    NeedState = Logic.GetNeedState(_BuildingID, Needs.Clothes);
    NeedCritical = Logic.GetNeedCriticalThreshold(_BuildingID, Needs.Clothes);
    if _Need ~= Needs.Clothes and NeedState <= NeedCritical then
        return true;
    end
    -- Check hygiene
    NeedState = Logic.GetNeedState(_BuildingID, Needs.Hygiene);
    NeedCritical = Logic.GetNeedCriticalThreshold(_BuildingID, Needs.Hygiene);
    if _Need ~= Needs.Hygiene and NeedState <= NeedCritical then
        return true;
    end
    -- Check entertainment
    NeedState = Logic.GetNeedState(_BuildingID, Needs.Entertainment);
    NeedCritical = Logic.GetNeedCriticalThreshold(_BuildingID, Needs.Entertainment);
    if _Need ~= Needs.Entertainment and NeedState <= NeedCritical then
        return true;
    end
    -- Nothing critical
    return false;
end

function Lib.SettlementSurvival.Global:CalculateDistanceFactor(_BuildingID)
    local PlayerID = Logic.EntityGetPlayer(_BuildingID);
    local StorehouseID = Logic.GetStoreHouse(PlayerID);
    if StorehouseID == 0 then
        return 1;
    end
    if  self.Consume[PlayerID].Buildings[_BuildingID]
    and self.Consume[PlayerID].Buildings[_BuildingID].Factor then
        return self.Consume[PlayerID].Buildings[_BuildingID].Factor;
    end
    local Distance = GetDistance(_BuildingID, StorehouseID);
    local Progression = Lib.SettlementSurvival.Shared.Consume.Progression;
    if Distance > Progression then
        return 2 ^ (((-1) * (Distance - Progression)) / Progression);
    end
    return 1;
end

-- -------------------------------------------------------------------------- --

-- Makes infected animals succum to their sickness if not treated. As an
-- intended exploit only animals in a pasture can die.
function Lib.SettlementSurvival.Global:ControlAnimalsSuccumToPlague(_Turn)
    local CurrentTime = math.floor(Logic.GetTime());
    local PlayerID = _Turn % 10;
    if self.IsActive and self.AnimalPlague.IsActive and PlayerID >= 1 and PlayerID <= 8 then
        if self.AnimalPlague.AffectAI or Logic.PlayerGetIsHumanFlag(PlayerID) then
            -- Get animals
            local SheepList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.SheepPasture)};
            local CowList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.CattlePasture)};
            local AnimalList = Array_Append(SheepList, CowList);
            -- Register ill animals
            for i= 1, #AnimalList do
                if  not self.AnimalPlague[PlayerID][AnimalList[i]]
                and Logic.IsFarmAnimalInPasture(AnimalList[i])
                and Logic.IsFarmAnimalIll(AnimalList[i]) then
                    self.AnimalPlague[PlayerID][AnimalList[i]] = {CurrentTime};
                end
            end
            -- Unregister animals who recovered
            for AnimalID,v in pairs(self.AnimalPlague[PlayerID]) do
                if not IsExisting(AnimalID)
                or not Logic.IsFarmAnimalInPasture(AnimalID)
                or not Logic.IsFarmAnimalIll(AnimalID) then
                    self.AnimalPlague[PlayerID][AnimalID] = nil;
                end
            end
            -- Check who has to die
            local DeathTime = Lib.SettlementSurvival.Shared.AnimalPlague.DeathTimer;
            local ShowMessage = false;
            if CurrentTime % DeathTime == 0 then
                for AnimalID,_ in pairs(self.AnimalPlague[PlayerID]) do
                    local Chance = Lib.SettlementSurvival.Shared.AnimalPlague.DeathChance;
                    if GetPlayerResources(Goods.G_Herb, PlayerID) > 0 then
                        AddGood(Goods.G_Herb, -1, PlayerID);
                        Chance = Chance / 2;
                    end
                    if Chance >= 1 and math.random(1, 100) <= math.min(Chance, 100) then
                        SendReport(Report.AnimalDiedFromIllness, AnimalID);
                        SendReportToLocal(Report.AnimalDiedFromIllness, AnimalID);
                        SetHealth(AnimalID, 0);
                        ShowMessage = true;
                    end
                end
            end
            -- Show info
            if ShowMessage then
                self:Print(PlayerID, Lib.SettlementSurvival.Text.Alarms.AnimalDiedFromIllness);
            end
        end
    end
end

-- Job that makes animal corpses inside pastures decay if the lifestock module
-- is not installed what would do that automatically.
function Lib.SettlementSurvival.Global:ControlAnimalCorpsesDecay(_Turn)
    if not Lib.LifestockSystem or not Lib.LifestockSystem.Global.IsInstalled then
        if Logic.GetTime() % 10 == 0 then
            -- Cattle
            local CattleCorpses = Logic.GetEntitiesOfType(Entities.R_DeadCow);
            for k,v in pairs(CattleCorpses) do
                local x,y,z = Logic.EntityGetPos(v);
                local _,PastureID = Logic.GetEntitiesInArea(Entities.B_CattlePasture, x, y, 900, 1);
                if IsExisting(PastureID) then
                    local GoodAmount = Logic.GetResourceDoodadGoodAmount(v);
                    Logic.SetResourceDoodadGoodAmount(v, GoodAmount -1);
                end
            end
            -- Sheep
            local SheepCorpses = Logic.GetEntitiesOfType(Entities.R_DeadSheep);
            for k,v in pairs(SheepCorpses) do
                local x,y,z = Logic.EntityGetPos(v);
                local _,PastureID = Logic.GetEntitiesInArea(Entities.B_SheepPasture, x, y, 900, 1);
                if IsExisting(PastureID) then
                    local GoodAmount = Logic.GetResourceDoodadGoodAmount(v);
                    Logic.SetResourceDoodadGoodAmount(v, GoodAmount -1);
                end
            end
        end
    end
end

-- Controls the automatic infection of animals if activated. Animals not in
-- a pasture can not become sick.
function Lib.SettlementSurvival.Global:ControlAnimalInfections(_Turn)
    local CurrentTime = math.floor(Logic.GetTime())
    local PlayerID = _Turn % 10;
    if self.IsActive and self.AnimalPlague.IsActive and PlayerID >= 1 and PlayerID <= 8 then
        if self.AnimalPlague.AffectAI or Logic.PlayerGetIsHumanFlag(PlayerID) then
            local InfectionTimer = Lib.SettlementSurvival.Shared.AnimalPlague.InfectionTimer;
            if CurrentTime % InfectionTimer == 0 then
                -- Get animals
                local SheepList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.SheepPasture)};
                local CowList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.CattlePasture)};
                local AnimalList = Array_Append(SheepList, CowList);
                -- Infect animals
                local Chance = Lib.SettlementSurvival.Shared.AnimalPlague.InfectionChance;
                for i= #AnimalList, 1, -1 do
                    if  Logic.IsFarmAnimalInPasture(AnimalList[i])
                    and Logic.TechnologyGetState(PlayerID, Technologies.R_Medicine) == 3
                    and not Logic.IsFarmAnimalIll(AnimalList[i]) then
                        if math.random(1, 100) <= Chance then
                            Logic.MakeFarmAnimalIll(AnimalList[i]);
                        end
                    end
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

-- When it is hot outside (usually 30°C ore more), buildings might catch fire
-- and water will be needed to extinguish them.
function Lib.SettlementSurvival.Global:ControlBuildingsDuringHotWeather(_Turn)
    local CurrentTime = math.floor(Logic.GetTime());
    local PlayerID = _Turn % 10;
    if self.IsActive and self.HotWeather.IsActive and PlayerID >= 1 and PlayerID <= 8 then
        if self.HotWeather.AffectAI or Logic.PlayerGetIsHumanFlag(PlayerID) then
            if Logic.GetCurrentTemperature() >= Lib.SettlementSurvival.Shared.HotWeather.Temperature then
                local FireFrequency = Lib.SettlementSurvival.Shared.HotWeather.IgnitionTimer;
                if CurrentTime % FireFrequency == 0 then
                    -- Get buildings
                    local OuterRim = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.OuterRimBuilding)};
                    local City = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.CityBuilding)};
                    local BuildingList = Array_Append(OuterRim, City);
                    local AnyIgnited = false;
                    for i= 1, #BuildingList do
                        if  Logic.IsConstructionComplete(BuildingList[i]) == 1
                        and GetHealth(BuildingList[i]) >= 100
                        and not Logic.IsBurning(BuildingList[i]) then
                            local IgnitionChance = Lib.SettlementSurvival.Shared.HotWeather.IgnitionChance * 10;
                            if self:IsWaterSupplierNear(PlayerID, BuildingList[i], 2500) then
                                IgnitionChance = 1;
                            end
                            if IgnitionChance > 0 and math.random(1, 1000) <= IgnitionChance then
                                Logic.DEBUG_SetBuildingOnFire(BuildingList[i], 10);
                                AnyIgnited = true;
                            end
                        end
                    end
                    if AnyIgnited then
                        self:Print(PlayerID, Lib.SettlementSurvival.Text.Alarms.BuildingBurning);
                    end
                end
            end
        end
    end
end

function Lib.SettlementSurvival.Global:IsWaterSupplierNear(_PlayerID, _BuildingID, _Area)
    local x, y, z = Logic.EntityGetPos(_BuildingID);
    if Logic.IsPlayerEntityOfCategoryInArea(_PlayerID, x, y, _Area, "G_Water_Supplier") == 1 then
        return true;
    end
    return false;
end

-- -------------------------------------------------------------------------- --

-- When it is cold outside (usually 5°C or less), wood will be consumed by all
-- buildings according to the amount of settlers. If there is not enough
-- firewood available, settlers will start to become sick.
function Lib.SettlementSurvival.Global:ControlBuildingsDuringColdWeather(_Turn)
    local CurrentTime = math.floor(Logic.GetTime());
    local PlayerID = _Turn % 10;
    if self.IsActive and self.ColdWeather.IsActive and PlayerID >= 1 and PlayerID <= 8 then
        if self.ColdWeather.AffectAI or Logic.PlayerGetIsHumanFlag(PlayerID) then
            if Logic.GetCurrentTemperature() <= Lib.SettlementSurvival.Shared.ColdWeather.Temperature then
                local FirewoodFrequency = Lib.SettlementSurvival.Shared.ColdWeather.ConsumptionTimer;
                if CurrentTime % FirewoodFrequency == 0 then
                    -- Get settler amount
                    local EmployedSettlers = 0;
                    local OuterRim = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.OuterRimBuilding)};
                    local City = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.CityBuilding)};
                    local BuildingList = Array_Append(OuterRim, City);
                    for i= 1, #BuildingList do
                        if Logic.IsConstructionComplete(BuildingList[i]) == 1 then
                            local AttachedSettlersAmount = CountWorkerInBuilding(BuildingList[i]);
                            if not Logic.IsNeedActive(BuildingList[i], Needs.Clothes)
                            or Logic.GetNeedState(BuildingList[i], Needs.Clothes) >= 0.4 then
                                AttachedSettlersAmount = AttachedSettlersAmount * 0.5;
                            end
                            EmployedSettlers = EmployedSettlers + AttachedSettlersAmount;
                        end
                    end
                    -- Subtract firewood
                    local WoodCost = Lib.SettlementSurvival.Shared.ColdWeather.ConsumptionFactor * EmployedSettlers;
                    local WoodCostPayed = 0;
                    local WoodAmount = GetPlayerResources(Goods.G_Wood, PlayerID);
                    self.ColdWeather[PlayerID].Consumption = self.ColdWeather[PlayerID].Consumption + WoodCost;
                    if self.ColdWeather[PlayerID].Consumption >= 1 then
                        local WoodCostFloored = math.floor(self.ColdWeather[PlayerID].Consumption);
                        AddGood(Goods.G_Wood, (-1) * math.min(WoodCostFloored, WoodAmount), PlayerID);
                        self.ColdWeather[PlayerID].Consumption = self.ColdWeather[PlayerID].Consumption - WoodCostFloored;
                        WoodCostPayed = WoodCostFloored;
                        ExecuteLocal(
                            [[if GUI.GetPlayerID() == %d then
                                  GUI_FeedbackWidgets.GoldAdd(%d, nil, {14, 5, 0}, {1, 9, 0})
                              end]],
                            PlayerID,
                            (-1) * WoodCostFloored
                        );
                    end
                    -- Enforce punishment
                    if WoodCostPayed > WoodAmount then
                        local InfectionChance = Lib.SettlementSurvival.Shared.ColdWeather.InfectionChance;
                        if Logic.TechnologyGetState(PlayerID, Technologies.R_Medicine) == 3 then
                            for i= 1, #BuildingList do
                                if math.random(1, 100) <= InfectionChance then
                                    Logic.MakeBuildingIll(BuildingList[i]);
                                end
                            end
                        end
                        self:Print(PlayerID, Lib.SettlementSurvival.Text.Alarms.SettlerTemperature);
                    end
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

-- When the need for hygiene or entertainment is not fulfilled, settlers will
-- become sick because of dirt or depression. Or maybe both...
function Lib.SettlementSurvival.Global:ControlSettlersBecomeIllDueToNegligence(_Turn)
    local CurrentTime = math.floor(Logic.GetTime());
    local PlayerID = _Turn % 10;
    if self.IsActive and self.Negligence.IsActive and PlayerID >= 1 and PlayerID <= 8 then
        if self.Negligence.AffectAI or Logic.PlayerGetIsHumanFlag(PlayerID) then
            -- Get settlers
            local SpouseList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Spouse)};
            local WorkerList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Worker)};
            WorkerList = Array_Append(SpouseList, WorkerList);
            -- Register settlers
            for i= 1, #WorkerList do
                if  not self.Negligence[PlayerID][WorkerList[i]]
                and Logic.GetEntityType(WorkerList[i]) ~= Entities.U_Pharmacist
                and (self:IsSettlerDirty(WorkerList[i]) or self:IsSettlerBored(WorkerList[i]))
                and not IsSettlerSuspended(WorkerList[i])
                and not Logic.IsIll(WorkerList[i]) then
                    self.Negligence[PlayerID][WorkerList[i]] = {CurrentTime};
                end
            end
            -- Unregister settlers
            --- @diagnostic disable-next-line: param-type-mismatch
            for SettlerID,v in pairs(self.Negligence[PlayerID]) do
                if  not self:IsSettlerBored(SettlerID) and not self:IsSettlerDirty(SettlerID) then
                    self.Negligence[PlayerID][SettlerID] = nil;
                end
            end
            -- Check who becomes ill
            local InfectionTimer = Lib.SettlementSurvival.Shared.Negligence.InfectionTimer;
            local ShowMessage = false;
            if CurrentTime % InfectionTimer == 0 then
                --- @diagnostic disable-next-line: param-type-mismatch
                for SettlerID,v in pairs(self.Negligence[PlayerID]) do
                    if v[1] + InfectionTimer < CurrentTime then
                        local Chance = Lib.SettlementSurvival.Shared.AnimalPlague.InfectionChance;
                        if math.random(1, 100) <= Chance then
                            if  Logic.TechnologyGetState(PlayerID, Technologies.R_Medicine) == 3
                            and not self:IsSettlerCarryingHygiene(SettlerID)
                            and not self:IsSettlerCarryingBeer(SettlerID)
                            and not IsSettlerSuspended(SettlerID)
                            and self:IsSettlerStriking(SettlerID) then
                                Logic.MakeSettlerIll(SettlerID);
                                ShowMessage = true;
                            end
                        end
                    end
                end
            end

            -- Show info
            if ShowMessage then
                self:Print(PlayerID, Lib.SettlementSurvival.Text.Alarms.SettlerNegligence);
            end
        end
    end
end

function Lib.SettlementSurvival.Global:IsSettlerDirty(_Entity)
    local EntityID = GetID(_Entity);
    local BuildingID = Logic.GetSettlersWorkBuilding(EntityID);
    return Logic.IsNeedCritical(BuildingID, Needs.Hygiene);
end

function Lib.SettlementSurvival.Global:IsSettlerBored(_Entity)
    local EntityID = GetID(_Entity);
    local BuildingID = Logic.GetSettlersWorkBuilding(EntityID);
    return Logic.IsNeedCritical(BuildingID, Needs.Entertainment);
end

function Lib.SettlementSurvival.Global:IsSettlerCarryingHygiene(_Entity)
    local EntityID = GetID(_Entity);
    local TaskList = Logic.GetCurrentTaskList(EntityID);
    return TaskList and TaskList:find("_HYGIENE");
end

function Lib.SettlementSurvival.Global:IsSettlerCarryingBeer(_Entity)
    local EntityID = GetID(_Entity);
    local TaskList = Logic.GetCurrentTaskList(EntityID);
    return TaskList and TaskList:find("_ENTERTAINMENT");
end

-- -------------------------------------------------------------------------- --

-- Controls if a settler starves to death.
function Lib.SettlementSurvival.Global:ControlSettlersSuccumToFamine(_Turn)
    local CurrentTime = math.floor(Logic.GetTime());
    local PlayerID = _Turn % 10;
    if self.IsActive and self.Famine.IsActive and PlayerID >= 1 and PlayerID <= 8 then
        if self.Famine.AffectAI or Logic.PlayerGetIsHumanFlag(PlayerID) then
            -- Get settlers
            local SpouseList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Spouse)};
            local WorkerList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Worker)};
            WorkerList = Array_Append(SpouseList, WorkerList);
            -- Register ill settlers
            for i= 1, #WorkerList do
                if  not self.Famine[PlayerID][WorkerList[i]]
                and self:IsSettlerHungry(WorkerList[i])
                and not IsSettlerSuspended(WorkerList[i]) then
                    self.Famine[PlayerID][WorkerList[i]] = {CurrentTime};
                end
            end
            -- Unregister settlers who recovered
            --- @diagnostic disable-next-line: param-type-mismatch
            for SettlerID,v in pairs(self.Famine[PlayerID]) do
                if not IsExisting(SettlerID) or not self:IsSettlerHungry(SettlerID) then
                    self.Famine[PlayerID][SettlerID] = nil;
                end
            end
            -- Check who has to die
            local DeathTime = Lib.SettlementSurvival.Shared.Famine.DeathTimer;
            local ShowMessage = false;
            if CurrentTime % DeathTime == 0 then
                --- @diagnostic disable-next-line: param-type-mismatch
                for SettlerID,v in pairs(self.Famine[PlayerID]) do
                    if  not self:IsSettlerCarryingFood(SettlerID)
                    and not IsSettlerSuspended(SettlerID)
                    and self:IsSettlerStriking(SettlerID) then
                        local Chance = Lib.SettlementSurvival.Shared.Famine.DeathChance;
                        if Chance >= 1 and math.random(1, 100) <= math.ceil(Chance) then
                            local Suspension = Lib.SettlementSurvival.Shared.SuspendedSettlers.MourningTime;
                            SuspendSettler(SettlerID, Suspension);
                            SendReport(Report.SettlerDiedFromStarvation, SettlerID);
                            SendReportToLocal(Report.SettlerDiedFromStarvation, SettlerID);
                            ShowMessage = true;
                            -- Save dead settler
                            ExecuteLocal("Lib.SettlementSurvival.Local.DeadSettlers[%d][%d] = true", PlayerID, SettlerID);
                        end
                    end
                end
            end
            -- Show info
            if ShowMessage then
                self:Print(PlayerID, Lib.SettlementSurvival.Text.Alarms.SettlerDiedFromHunger);
            end
        end
    end
end

function Lib.SettlementSurvival.Global:IsSettlerHungry(_Entity)
    local EntityID = GetID(_Entity);
    local BuildingID = Logic.GetSettlersWorkBuilding(EntityID);
    return Logic.IsNeedCritical(BuildingID, Needs.Nutrition);
end

function Lib.SettlementSurvival.Global:IsSettlerCarryingFood(_Entity)
    local EntityID = GetID(_Entity);
    local TaskList = Logic.GetCurrentTaskList(EntityID);
    return TaskList and (TaskList:find("_NUTRITION") or TaskList:find("_FOOD"));
end

-- -------------------------------------------------------------------------- --

-- Makes settler die from illness if not treated.
function Lib.SettlementSurvival.Global:ControlSettlersSuccumToPlague(_Turn)
    local CurrentTime = math.floor(Logic.GetTime());
    local PlayerID = _Turn % 10;
    if self.IsActive and self.Plague.IsActive and PlayerID >= 1 and PlayerID <= 8 then
        if self.Plague.AffectAI or Logic.PlayerGetIsHumanFlag(PlayerID) then
            -- Get settlers
            local SpouseList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Spouse)};
            local WorkerList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Worker)};
            WorkerList = Array_Append(SpouseList, WorkerList);
            -- Register ill settlers
            for i= 1, #WorkerList do
                if  not self.Plague[PlayerID][WorkerList[i]]
                and Logic.GetEntityType(WorkerList[i]) ~= Entities.U_Pharmacist
                and Logic.IsIll(WorkerList[i])
                and not IsSettlerSuspended(WorkerList[i]) then
                    self.Plague[PlayerID][WorkerList[i]] = {CurrentTime};
                end
            end
            -- Unregister settlers who recovered
            --- @diagnostic disable-next-line: param-type-mismatch
            for SettlerID,v in pairs(self.Plague[PlayerID]) do
                if not IsExisting(SettlerID) or not Logic.IsIll(SettlerID) then
                    self.Plague[PlayerID][SettlerID] = nil;
                end
            end
            -- Check who has to die
            local DeathTime = Lib.SettlementSurvival.Shared.Plague.DeathTimer;
            local ShowMessage = false;
            if CurrentTime % DeathTime == 0 then
                --- @diagnostic disable-next-line: param-type-mismatch
                for SettlerID,v in pairs(self.Plague[PlayerID]) do
                    if  not self:IsSettlerCarryingMedicine(SettlerID)
                    and not IsSettlerSuspended(SettlerID)
                    and self:IsSettlerStriking(SettlerID) then
                        local Chance = Lib.SettlementSurvival.Shared.Plague.DeathChance;
                        -- Deactivated: Makes it to easy
                        -- if GetPlayerResources(Goods.G_Herb, PlayerID) > 10 then
                        --     AddGood(Goods.G_Herb, -1, PlayerID);
                        --     Chance = Chance / 2;
                        -- end
                        if Chance >= 1 and math.random(1, 100) <= math.ceil(Chance) then
                            local Suspension = Lib.SettlementSurvival.Shared.SuspendedSettlers.MourningTime;
                            SuspendSettler(SettlerID, Suspension);
                            SendReport(Report.SettlerDiedFromIllness, SettlerID);
                            SendReportToLocal(Report.SettlerDiedFromIllness, SettlerID);
                            ShowMessage = true;
                            -- Save dead settler
                            ExecuteLocal("Lib.SettlementSurvival.Local.DeadSettlers[%d][%d] = true", PlayerID, SettlerID);
                        end
                    end
                end
            end
            -- Show info
            if ShowMessage then
                self:Print(PlayerID, Lib.SettlementSurvival.Text.Alarms.SettlerDiedFromIllness);
            end
        end
    end
end

function Lib.SettlementSurvival.Global:IsSettlerCarryingMedicine(_Entity)
    local EntityID = GetID(_Entity);
    local TaskList = Logic.GetCurrentTaskList(EntityID);
    return TaskList and TaskList:find("_MEDICINE");
end

-- -------------------------------------------------------------------------- --

function Lib.SettlementSurvival.Global:IsSettlerStriking(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local TaskList = Logic.GetCurrentTaskList(EntityID);
    local MarketID = Logic.GetMarketplace(PlayerID);
    if MarketID ~= 0 and TaskList == "TL_WORKER_IDLE_UNFIT" then
        if Logic.IsEntityMoving(EntityID) == false then
            return Logic.CheckEntitiesDistance(EntityID, MarketID, 1500) == true;
        end
    end
    return false;
end

-- -------------------------------------------------------------------------- --

function Lib.SettlementSurvival.Global:OverwriteNeeds()
    ActivateNeedsForBuilding = function(_PlayerID, _EntityID)
        for Need, _ in pairs (PlayerActiveNeeds[_PlayerID]) do
            if Logic.IsEntityInCategory(_EntityID, EntityCategories.OuterRimBuilding) == 1 then
                if Need == Needs.Nutrition
                or Need == Needs.Medicine then
                    Logic.SetNeedActive(_EntityID, Need, true);
                end
                if Need == Needs.Clothes then
                    local Active = Lib.SettlementSurvival.Global.Misc.ClothesForOuterRim;
                    Logic.SetNeedActive(_EntityID, Need, Active == true);
                end
            end
            if Logic.IsEntityInCategory(_EntityID, EntityCategories.CityBuilding) == 1 then
                Logic.SetNeedActive(_EntityID, Need, true);
            end
        end
        Logic.ExecuteInLuaLocalState("GUI_BuildingInfo.UpdateActiveNeedsGUI()");
    end

    ActivateNeedForPlayer = function(_PlayerID, _NeedTable)
        if _NeedTable == nil then
            return;
        end

        local OuterRimNeeds = {
            [Needs.Nutrition] = true,
            [Needs.Medicine] = true,
        };
        if Lib.SettlementSurvival.Global.Misc.ClothesForOuterRim then
            OuterRimNeeds[Needs.Clothes] = true;
        end

        for k =1, #_NeedTable do
            local Need = _NeedTable[k];
            PlayerActiveNeeds[_PlayerID][Need] = true;
            local Buildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID,EntityCategories.CityBuilding)};
            if OuterRimNeeds[Need] then
                local OuterRimBuildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID,EntityCategories.OuterRimBuilding)};
                for j=1, #OuterRimBuildings do
                    local BuildingID = OuterRimBuildings[j];
                    table.insert(Buildings, BuildingID);
                end
            end
            for i=1, #Buildings do
                local BuildingID = Buildings[i];
                Logic.SetNeedActive(BuildingID, Need, true);
            end
            Logic.ExecuteInLuaLocalState("GUI_BuildingInfo.UpdateActiveNeedsGUI()");
        end
    end
end

function Lib.SettlementSurvival.Global:UpdateClothesStateForOuterRim()
    for PlayerID = 1, 8 do
        local OuterRimBuildings = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.OuterRimBuilding)};
        for i=1, #OuterRimBuildings do
            local BuildingID = OuterRimBuildings[i];
            if  Lib.SettlementSurvival.Global.Misc.ClothesForOuterRim
            and PlayerActiveNeeds[PlayerID][Needs.Clothes] then
                Logic.SetNeedActive(BuildingID, Needs.Clothes, true);
            else
                Logic.SetNeedActive(BuildingID, Needs.Clothes, false);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

function Lib.SettlementSurvival.Global:Print(_PlayerID, _Text)
    local Text = ConvertPlaceholders(Localize(_Text));
    ExecuteLocal([[
        if GUI.GetPlayerID() == %d then
            GUI.ClearNotes()
            GUI.AddNote("%s")
        end
    ]], _PlayerID, Text);
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.SettlementSurvival.Local:Initialize()
    if not self.IsInstalled then
        Report.AnimalDiedFromIllness = CreateReport("Event_AnimalDiedFromIllness");
        Report.SettlerDiedFromStarvation = CreateReport("Event_SettlerDiedFromStarvation");
        Report.SettlerDiedFromIllness = CreateReport("Event_SettlerDiedFromIllness");

        for PlayerID = 1, 8 do
            self.DeadSettlers[PlayerID] = {};
        end

        self:OverrideGameCallbacks();
        self:OverwriteUpdateNeeds();
        self:OverwriteUpgradeButton();

        -- Garbage collection
        Lib.SettlementSurvival.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.SettlementSurvival.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.SettlementSurvival.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.SettlerSuspensionElapsed then
        -- Delete the dead settler
        local PlayerID = Logic.EntityGetPlayer(arg[1]);
        if self.DeadSettlers[PlayerID] then
            self.DeadSettlers[PlayerID][arg[1]] = nil;
        end
    end
end

function Lib.SettlementSurvival.Local:OverwriteUpdateNeeds()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingInfo.NeedUpdate = function()
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local CurrentWidgetName = XGUIEng.GetWidgetNameByID(CurrentWidgetID);
        local MotherWidgetID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID);
        local MotherWidgetName = XGUIEng.GetWidgetNameByID(MotherWidgetID);
        local NeedsName;
        if MotherWidgetName == "Decoration" then
            NeedsName = "Wealth";
        elseif MotherWidgetName == "Cleanliness" then
            NeedsName = "Hygiene";
        else
            NeedsName = MotherWidgetName;
        end
        local Need = Needs[NeedsName];
        local BuildingID = GetBuildingIDAlsoWhenWorkerIsSelected();
        if Logic.IsNeedActive(BuildingID, Need) == true then
            local IsNeedCritical = Logic.IsNeedCritical(BuildingID, Need);
            local IsNeedAttention = Logic.IsNeedAttention(BuildingID, Need);
            local HasFoundNoGoodForNeed = Logic.GetFoundNoGoodForNeed(BuildingID, Need);
            if IsNeedCritical == true and HasFoundNoGoodForNeed == true then
                XGUIEng.SetMaterialColor(CurrentWidgetID,0,240,10,10,255);
            elseif IsNeedAttention == true and HasFoundNoGoodForNeed == true then
                XGUIEng.SetMaterialColor(CurrentWidgetID,0,255,220,20,255);
            else
                XGUIEng.SetMaterialColor(CurrentWidgetID,0,255,255,255,255);
            end
            if CurrentWidgetName == "Bar" then
                local State = Logic.GetNeedState(BuildingID, Need);
                local AttentionThreshold   = Logic.GetNeedAttentionThreshold(BuildingID, Need);
                local CriticalThreshold = Logic.GetNeedCriticalThreshold(BuildingID, Need);
                local Maximum = 0.8;
                local CurrentState = State;
                if not Lib.SettlementSurvival.Local.IsActive
                or not Lib.SettlementSurvival.Local.Consume.IsActive then
                    if Logic.IsEntityInCategory(BuildingID, EntityCategories.OuterRimBuilding) == 1 then
                        Maximum = Maximum - CriticalThreshold;
                        CurrentState = CurrentState - CriticalThreshold;
                    end
                else
                    if Logic.IsEntityInCategory(BuildingID, EntityCategories.OuterRimBuilding) == 1 then
                        Maximum = Maximum - (CriticalThreshold * 0.65);
                        CurrentState = CurrentState - (CriticalThreshold * 0.65);
                    end
                end
                XGUIEng.SetProgressBarValues(CurrentWidgetID,CurrentState,Maximum);
                local ValueWidget = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(CurrentWidgetID)) .. "/Value";
                if Debug_EnableDebugOutput then
                    local Value = Round(State* 10);
                    local ThresholdValue = Round(AttentionThreshold*10);
                    local CriticalValue = Round(CriticalThreshold*10);
                    XGUIEng.SetText(ValueWidget, "{center}" .. Value .. "/" ..ThresholdValue .. "/" .. CriticalValue);
                else
                    XGUIEng.SetText(ValueWidget, "");
                end
            end
        else
            XGUIEng.SetMaterialColor(CurrentWidgetID,0,255,255,255,50);
        end
    end
end

function Lib.SettlementSurvival.Local:OverrideGameCallbacks()
    self.Orig_GameCallback_GUI_SelectionChanged = GameCallback_GUI_SelectionChanged;
    GameCallback_GUI_SelectionChanged = function(_Source)
        Lib.SettlementSurvival.Local.Orig_GameCallback_GUI_SelectionChanged(_Source);
        Lib.SettlementSurvival.Local:OnBuildingSelected();
    end

    self.Orig_GameCallback_GUI_DeleteEntityStateBuilding = GameCallback_GUI_DeleteEntityStateBuilding;
    GameCallback_GUI_DeleteEntityStateBuilding = function(_BuildingID, _State)
        if Lib.SettlementSurvival.Local:HasBuildingDeadSettlers(_BuildingID) then
            Message(Localize(Lib.Permadeath.Text.Messages.BuildingMourning));
            GUI.CancelBuildingKnockDown(_BuildingID);
            return;
        end
        Lib.SettlementSurvival.Local.Orig_GameCallback_GUI_DeleteEntityStateBuilding(_BuildingID, _State);
    end
end

function Lib.SettlementSurvival.Local:OverwriteUpgradeButton()
    -- This creates a dependency to module/ui/uibuilding
    self.Orig_GUI_BuildingButtons_UpgradeClicked = GUI_BuildingButtons.UpgradeClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.UpgradeClicked = function()
        local BuildingID = GUI.GetSelectedEntity();
        if Lib.SettlementSurvival.Local:HasBuildingDeadSettlers(BuildingID) then
            Message(Localize(Lib.SettlementSurvival.Text.Messages.BuildingMourning));
            GUI.CancelBuildingKnockDown(BuildingID);
            return;
        end
        Lib.SettlementSurvival.Local.Orig_GUI_BuildingButtons_UpgradeClicked();
    end
end

-- We can not just check for suspended settler. We must check if the settler
-- was "killed" by this module.
function Lib.SettlementSurvival.Local:HasBuildingDeadSettlers(_BuildingID)
    local PlayerID = Logic.EntityGetPlayer(_BuildingID);
    if self.DeadSettlers[PlayerID] then
        local AttachedSettlers = {Logic.GetWorkersAndSpousesForBuilding(_BuildingID)};
        for i= 1, #AttachedSettlers do
            if AttachedSettlers[i] > 0 and self.DeadSettlers[PlayerID][AttachedSettlers[i]] then
                return true;
            end
        end
    end
    return false;
end

function Lib.SettlementSurvival.Local:OnBuildingSelected()
    local EntityID = GUI.GetSelectedEntity();
    if self.IsActive then
        -- Buildings
        if Logic.IsEntityInCategory(EntityID, EntityCategories.OuterRimBuilding) == 1 then
            if self.Misc.ClothesForOuterRim then
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Clothes", 1);
            else
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Clothes", 0);
            end
        end
        -- Settlers
        if Logic.IsEntityInCategory(EntityID, EntityCategories.Spouse) == 1
        or Logic.IsEntityInCategory(EntityID, EntityCategories.Worker) == 1 then
            local BuildingID = Logic.GetSettlersWorkBuilding(EntityID);
            if Logic.IsEntityInCategory(BuildingID, EntityCategories.OuterRimBuilding) == 1 then
                if self.Misc.ClothesForOuterRim then
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Clothes", 1);
                else
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Clothes", 0);
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.SettlementSurvival.Name);

