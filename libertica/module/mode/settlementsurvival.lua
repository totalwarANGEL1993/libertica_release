Lib.SettlementSurvival = Lib.SettlementSurvival or {};
Lib.SettlementSurvival.Name = "SettlementSurvival";
Lib.SettlementSurvival.Global = {
    AnimalPlague = {
        AnimalsBecomeSick = false,
        IsActive = false,
        AffectAI = false,
    },
    Famine = {
        IsActive = false,
        AffectAI = false,
    },
    ColdWeather = {
        IsActive = false,
        AffectAI = false,
    },
    HotWeather = {
        IsActive = false,
        AffectAI = false,
    },
    Negligence = {
        IsActive = false,
        AffectAI = false,
    },
    Plague = {
        IsActive = false,
        AffectAI = false,
    },
    SuspendedSettlers = {},
};
Lib.SettlementSurvival.Local  = {
    SuspendedSettlers = {},
};
Lib.SettlementSurvival.Shared = {
    AnimalPlague = {
        InfectionChance = 6,
        InfectionTimer = 60,
        DeathChance = 12,
        DeathTimer = 30,
    },
    ColdWeather = {
        ConsumptionFactor = 0.01,
        ConsumptionTimer = 30,
        Temperature = 5,
        InfectionChance = 12,
    },
    HotWeather = {
        IgnitionChance = 5,
        IgnitionTimer = 30,
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
        DeathChance = 12,
        DeathTimer = 30,
    },
    SuspendedSettlers = {
        MourningTime = 5*60,
    },
};

Lib.Require("comfort/global/SetHealth");
Lib.Require("core/Core");
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
        Report.FireAlarmDeactivated_Internal = CreateReport("Event_FireAlarmDeactivated_Internal");
        Report.FireAlarmActivated_Internal = CreateReport("Event_FireAlarmActivated_Internal");
        Report.RepairAlarmDeactivated_Internal = CreateReport("Event_RepairAlarmFeactivated");
        Report.ReRepairAlarmActivated_Internal = CreateReport("Event_ReRepairAlarmActivated_Internal");

        --- An animal has died from illness.
        ---
        --- #### Parameters
        --- `EntityID` - ID of animal
        Report.AnimalDiedFromIllness = CreateReport("Event_AnimalDiedFromIllness");

        --- A settler has starved to death.
        ---
        --- #### Parameters
        --- `EntityID` - ID of settler
        Report.SettlerDiedFromStarvation = CreateReport("Event_SettlerDiedFromStarvation");

        --- A settler has died from illness.
        ---
        --- #### Parameters
        --- `EntityID` - ID of settler
        Report.SettlerDiedFromIllness = CreateReport("Event_SettlerDiedFromIllness");

        for PlayerID= 1,8 do
            self.AnimalPlague[PlayerID] = {};
            self.ColdWeather[PlayerID] = {Consumption = 0};
            self.Famine[PlayerID] = {};
            self.Negligence[PlayerID] = {};
            self.Plague[PlayerID] = {};
            self.SuspendedSettlers[PlayerID] = {};
        end

        RequestJobByEventType(
            Events.LOGIC_EVENT_EVERY_TURN,
            function()
                local Turn = Logic.GetCurrentTurn();
                Lib.SettlementSurvival.Global:ResumeSettlersAfterMourning(Turn);
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

-- Makes infected animals succum to their sickness if not treated. As an
-- intended exploit only animals in a pasture can die.
function Lib.SettlementSurvival.Global:ControlAnimalsSuccumToPlague(_Turn)
    local CurrentTime = math.floor(Logic.GetTime());
    local PlayerID = _Turn % 10;
    if self.AnimalPlague.IsActive and PlayerID >= 1 and PlayerID <= 8 then
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
                    if GetPlayerResources(Goods.G_Herb, PlayerID) > 10 then
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
    if self.AnimalPlague.AnimalsBecomeSick then
        if self.AnimalPlague.IsActive and PlayerID >= 1 and PlayerID <= 8 then
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
end

-- -------------------------------------------------------------------------- --

-- When it is hot outside (usually 30°C ore more), buildings might catch fire
-- and water will be needed to extinguish them.
function Lib.SettlementSurvival.Global:ControlBuildingsDuringHotWeather(_Turn)
    local CurrentTime = math.floor(Logic.GetTime());
    local PlayerID = _Turn % 10;
    if self.HotWeather.IsActive and PlayerID >= 1 and PlayerID <= 8 then
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
                        and not Logic.IsBurning(BuildingList[i]) then
                            local IgnitionChance = Lib.SettlementSurvival.Shared.HotWeather.IgnitionChance;
                            if math.random(1, 100) <= IgnitionChance then
                                Logic.DEBUG_SetBuildingOnFire(BuildingList[i], 50);
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

-- -------------------------------------------------------------------------- --

-- When it is cold outside (usually 5°C or less), wood will be consumed by all
-- buildings according to the amount of settlers. If there is not enough
-- firewood available, settlers will start to become sick.
function Lib.SettlementSurvival.Global:ControlBuildingsDuringColdWeather(_Turn)
    local CurrentTime = math.floor(Logic.GetTime());
    local PlayerID = _Turn % 10;
    if self.ColdWeather.IsActive and PlayerID >= 1 and PlayerID <= 8 then
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
                            local AttachedSettlersAmount = 0;
                            for _, SettlerID in pairs({Logic.GetWorkersAndSpousesForBuilding(BuildingList[i])}) do
                                if not self:IsSettlerSuspended(SettlerID) then
                                    AttachedSettlersAmount = AttachedSettlersAmount +1
                                end
                            end
                            if  Logic.IsNeedActive(BuildingList[i], Needs.Clothes)
                            and Logic.GetNeedState(BuildingList[i], Needs.Clothes) > 0.5 then
                                AttachedSettlersAmount = AttachedSettlersAmount * 0.5;
                            end
                            EmployedSettlers = EmployedSettlers + AttachedSettlersAmount;
                        end
                    end
                    -- Subtract firewood
                    local WoodCost = Lib.SettlementSurvival.Shared.ColdWeather.ConsumptionFactor * EmployedSettlers;
                    local WoodAmount = GetPlayerResources(Goods.G_Wood, PlayerID);
                    self.ColdWeather[PlayerID].Consumption = self.ColdWeather[PlayerID].Consumption + WoodCost;
                    if self.ColdWeather[PlayerID].Consumption > 1 then
                        local WoodCostFloored = math.floor(WoodCost);
                        AddGood(Goods.G_Wood, (-1) * math.min(WoodCostFloored, WoodAmount), PlayerID);
                        self.ColdWeather[PlayerID].Consumption = self.ColdWeather[PlayerID].Consumption - WoodCostFloored;
                    end
                    -- Enforce punishment
                    if WoodCost > WoodAmount then
                        local InfectionChance = Lib.SettlementSurvival.Shared.ColdWeather.InfectionChance;
                        for i= 1, #BuildingList do
                            if math.random(1, 100) <= InfectionChance then
                                Logic.MakeBuildingIll(BuildingList[i]);
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
    if  self.Negligence.IsActive and PlayerID >= 1 and PlayerID <= 8 then
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
                and not self:IsSettlerSuspended(WorkerList[i])
                and not Logic.IsIll(WorkerList[i]) then
                    self.Negligence[PlayerID][WorkerList[i]] = {CurrentTime};
                end
            end
            -- Unregister settlers
            for SettlerID,v in pairs(self.Negligence[PlayerID]) do
                if  not self:IsSettlerBored(SettlerID) and not self:IsSettlerDirty(SettlerID) then
                    self.Negligence[PlayerID][SettlerID] = nil;
                end
            end
            -- Check who becomes ill
            local InfectionTimer = Lib.SettlementSurvival.Shared.Negligence.InfectionTimer;
            local ShowMessage = false;
            if CurrentTime % InfectionTimer == 0 then
                for SettlerID,v in pairs(self.Negligence[PlayerID]) do
                    if v[1] + InfectionTimer < CurrentTime then
                        local Chance = Lib.SettlementSurvival.Shared.AnimalPlague.InfectionChance;
                        if math.random(1, 100) <= Chance then
                            if  not self:IsSettlerCarryingHygiene(SettlerID)
                            and not self:IsSettlerCarryingBeer(SettlerID)
                            and not self:IsSettlerSuspended(SettlerID)  then
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
    if  self.Famine.IsActive and PlayerID >= 1 and PlayerID <= 8 then
        if self.Famine.AffectAI or Logic.PlayerGetIsHumanFlag(PlayerID) then
            -- Get settlers
            local SpouseList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Spouse)};
            local WorkerList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.Worker)};
            WorkerList = Array_Append(SpouseList, WorkerList);
            -- Register ill settlers
            for i= 1, #WorkerList do
                if  not self.Famine[PlayerID][WorkerList[i]]
                and self:IsSettlerHungry(WorkerList[i])
                and not self:IsSettlerSuspended(WorkerList[i]) then
                    self.Famine[PlayerID][WorkerList[i]] = {CurrentTime};
                end
            end
            -- Unregister settlers who recovered
            for SettlerID,v in pairs(self.Famine[PlayerID]) do
                if not IsExisting(SettlerID) or not self:IsSettlerHungry(SettlerID) then
                    self.Famine[PlayerID][SettlerID] = nil;
                end
            end
            -- Check who has to die
            local DeathTime = Lib.SettlementSurvival.Shared.Famine.DeathTimer;
            local ShowMessage = false;
            if CurrentTime % DeathTime == 0 then
                for SettlerID,v in pairs(self.Famine[PlayerID]) do
                    if  not self:IsSettlerCarryingFood(SettlerID)
                    and not self:IsSettlerSuspended(SettlerID) then
                        local Chance = Lib.SettlementSurvival.Shared.Famine.DeathChance;
                        if Chance >= 1 and math.random(1, 100) <= math.ceil(Chance) then
                            SendReport(Report.SettlerDiedFromStarvation, SettlerID);
                            SendReportToLocal(Report.SettlerDiedFromStarvation, SettlerID);
                            self:SuspendSettler(SettlerID, true);
                            ShowMessage = true;
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
    if  self.Plague.IsActive and PlayerID >= 1 and PlayerID <= 8 then
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
                and not self:IsSettlerSuspended(WorkerList[i]) then
                    self.Plague[PlayerID][WorkerList[i]] = {CurrentTime};
                end
            end
            -- Unregister settlers who recovered
            for SettlerID,v in pairs(self.Plague[PlayerID]) do
                if not IsExisting(SettlerID) or not Logic.IsIll(SettlerID) then
                    self.Plague[PlayerID][SettlerID] = nil;
                end
            end
            -- Check who has to die
            local DeathTime = Lib.SettlementSurvival.Shared.Plague.DeathTimer;
            local ShowMessage = false;
            if CurrentTime % DeathTime == 0 then
                for SettlerID,v in pairs(self.Plague[PlayerID]) do
                    if  not self:IsSettlerCarryingMedicine(SettlerID)
                    and not self:IsSettlerSuspended(SettlerID) then
                        local Chance = Lib.SettlementSurvival.Shared.Plague.DeathChance;
                        if GetPlayerResources(Goods.G_Herb, PlayerID) > 10 then
                            AddGood(Goods.G_Herb, -1, PlayerID);
                            Chance = Chance / 2;
                        end
                        if Chance >= 1 and math.random(1, 100) <= math.ceil(Chance) then
                            SendReport(Report.SettlerDiedFromIllness, SettlerID);
                            SendReportToLocal(Report.SettlerDiedFromIllness, SettlerID);
                            self:SuspendSettler(SettlerID, true);
                            ShowMessage = true;
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

-- Resumes a settler.
function Lib.SettlementSurvival.Global:ResumeSettler(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local StoreHouseID = Logic.GetStoreHouse(PlayerID);
    if StoreHouseID ~= 0 then
        -- Resume settler
        Logic.SetTaskList(EntityID, TaskLists.TL_WAIT_THEN_WALK);
        Logic.SetVisible(EntityID, true);
        -- Remove from suspension list
        if self.SuspendedSettlers[PlayerID][EntityID] then
            ExecuteLocal("Lib.SettlementSurvival.Local.SuspendedSettlers[%d][%d] = nil", PlayerID, EntityID);
            self.SuspendedSettlers[PlayerID][EntityID] = nil;
        end
    end
end

-- Suspend a settler.
function Lib.SettlementSurvival.Global:SuspendSettler(_Entity, _Mourn)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local StoreHouseID = Logic.GetStoreHouse(PlayerID);
    if StoreHouseID ~= 0 then
        -- Reset needs if building empty
        local BuildingID = Logic.GetSettlersWorkBuilding(EntityID);
        local AttachedSettlers = {Logic.GetWorkersAndSpousesForBuilding(BuildingID)};
        local AnyNotSuspended = false;
        for i= 1, #AttachedSettlers do
            if not self:IsSettlerSuspended(_Entity) then
                AnyNotSuspended = true;
                break;
            end
        end
        if AnyNotSuspended == false then
            Logic.SetNeedState(EntityID, Needs.Nutrition, 1.0);
            Logic.SetNeedState(EntityID, Needs.Entertainment, 1.0);
            Logic.SetNeedState(EntityID, Needs.Clothes, 1.0);
            Logic.SetNeedState(EntityID, Needs.Hygiene, 1.0);
            Logic.SetNeedState(EntityID, Needs.Medicine, 1.0);
        end
        -- Relocate inside storehouse and make invisible
        local x,y,z = Logic.EntityGetPos(StoreHouseID);
        Logic.DEBUG_SetSettlerPosition(EntityID, x, y);
        Logic.SetVisible(EntityID, false);
        Logic.SetTaskList(EntityID, TaskLists.TL_NPC_IDLE);
        -- Add to suspended settler map
        if not self.SuspendedSettlers[PlayerID][EntityID] then
            local Time = (_Mourn and Logic.GetTime()) or -1;
            ExecuteLocal("Lib.SettlementSurvival.Local.SuspendedSettlers[%d][%d] = {%d}", PlayerID, EntityID, Time);
            self.SuspendedSettlers[PlayerID][EntityID] = {Time};
        end
    end
end

function Lib.SettlementSurvival.Global:IsSettlerSuspended(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    return self.SuspendedSettlers[PlayerID] and self.SuspendedSettlers[PlayerID][EntityID] ~= nil;
end

function Lib.SettlementSurvival.Global:HasSuspendedInhabitants(_Entity)
    local BuildingID = GetID(_Entity)
    local AttachedSettlers = {Logic.GetWorkersAndSpousesForBuilding(BuildingID)};
    for i= 1, #AttachedSettlers do
        if self:IsSettlerSuspended(AttachedSettlers[i]) then
            return true;
        end
    end
    return false;
end

-- Restores tasklist and position of fake dead settlers.
function Lib.SettlementSurvival.Global:RestoreSettlerSuspension()
    for PlayerID = 1, 8 do
        for k,v in pairs(self.SuspendedSettlers[PlayerID]) do
            if not IsExisting(k) then
                ExecuteLocal("Lib.SettlementSurvival.Local.SuspendedSettlers[%d][%d] = nil", PlayerID, k);
                self.SuspendedSettlers[PlayerID][k] = nil;
            else
                self:SuspendSettler(k);
            end
        end
    end
end

-- Removes the suspended settler after the mourning time is over.
function Lib.SettlementSurvival.Global:ResumeSettlersAfterMourning(_Turn)
    local MournTime = Lib.SettlementSurvival.Shared.SuspendedSettlers.MourningTime;
    local CurrentTime = Logic.GetTime();
    local PlayerID = _Turn % 10;
    if PlayerID >= 1 and PlayerID <= 8 then
        for k,v in pairs(self.SuspendedSettlers[PlayerID]) do
            if v[1] > -1 and v[1] + MournTime <= CurrentTime then
                self:ResumeSettler(k);
                DestroyEntity(k);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

function Lib.SettlementSurvival.Global:OverwriteNeeds()
    ActivateNeedsForBuilding = function(_PlayerID, _EntityID)
        for Need, _ in pairs (PlayerActiveNeeds[_PlayerID]) do
            if Logic.IsEntityInCategory(_EntityID, EntityCategories.OuterRimBuilding) == 1 then
                if Need == Needs.Nutrition
                or Need == Needs.Clothes
                or Need == Needs.Medicine then
                    Logic.SetNeedActive(_EntityID, Need, true);
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
        for k =1, #_NeedTable do
            local Need = _NeedTable[k];
            PlayerActiveNeeds[_PlayerID][Need] = true;
            local Buildings = {Logic.GetPlayerEntitiesInCategory(_PlayerID,EntityCategories.CityBuilding)};
            if Need == Needs.Nutrition
            or Need == Needs.Clothes
            or Need == Needs.Medicine then
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
        Report.FireAlarmDeactivated_Internal = CreateReport("Event_FireAlarmDeactivated_Internal");
        Report.FireAlarmActivated_Internal = CreateReport("Event_FireAlarmActivated_Internal");
        Report.RepairAlarmDeactivated_Internal = CreateReport("Event_RepairAlarmFeactivated");
        Report.ReRepairAlarmActivated_Internal = CreateReport("Event_ReRepairAlarmActivated_Internal");
        Report.AnimalDiedFromIllness = CreateReport("Event_AnimalDiedFromIllness");
        Report.SettlerDiedFromStarvation = CreateReport("Event_SettlerDiedFromStarvation");
        Report.SettlerDiedFromIllness = CreateReport("Event_SettlerDiedFromIllness");

        self:OverrideSelectionChanged();
        self:OverwriteAlarmButtons();
        self:OverwriteGameCallbacks();
        self:OverwriteJumpToWorker();
        self:OverwriteUpgradeButton();

        for PlayerID = 1,8 do
            self.SuspendedSettlers[PlayerID] = {};
        end

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
    end
end

function Lib.SettlementSurvival.Local:OverwriteJumpToWorker()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingInfo.JumpToWorkerClicked = function()
        Sound.FXPlay2DSound( "ui\\menu_click");
        local PlayerID = GUI.GetPlayerID();
        local SelectedEntityID = GUI.GetSelectedEntity();
        local InhabitantsBuildingID = 0;
        local IsSettlerSelected;
        if Logic.IsBuilding(SelectedEntityID) == 1 then
            InhabitantsBuildingID = SelectedEntityID;
            IsSettlerSelected = false;
        else
            if Logic.IsWorker(SelectedEntityID) == 1
            or Logic.IsSpouse(SelectedEntityID) == true
            or Logic.GetEntityType(SelectedEntityID) == Entities.U_Priest then
                InhabitantsBuildingID = Logic.GetSettlersWorkBuilding(SelectedEntityID);
                IsSettlerSelected = true;
            end
        end
        if InhabitantsBuildingID ~= 0 then
            local WorkersAndSpousesInBuilding = {Logic.GetWorkersAndSpousesForBuilding(InhabitantsBuildingID)}

            -- To pretend settlers of the building have died, we need to remove
            -- them from the intabitants list.
            for i = #WorkersAndSpousesInBuilding, 1, -1 do
                local SettlerID = WorkersAndSpousesInBuilding[i];
                if Lib.SettlementSurvival.Local.SuspendedSettlers[PlayerID] then
                    if Lib.SettlementSurvival.Local.SuspendedSettlers[PlayerID][SettlerID] then
                        table.remove(WorkersAndSpousesInBuilding, i);
                    end
                end
            end

            local InhabitantID
            if g_CloseUpView.Active == false and IsSettlerSelected == true then
                InhabitantID = SelectedEntityID;
            else
                local InhabitantPosition = 1;
                for i = 1, #WorkersAndSpousesInBuilding do
                    if WorkersAndSpousesInBuilding[i] == g_LastSelectedInhabitant then
                        InhabitantPosition = i + 1;
                        break;
                    end
                end
                InhabitantID = WorkersAndSpousesInBuilding[InhabitantPosition];
                if InhabitantID == 0 then
                    InhabitantID = WorkersAndSpousesInBuilding[InhabitantPosition + 1];
                end
            end
            if InhabitantID == nil then
                local x,y = Logic.GetEntityPosition(InhabitantsBuildingID);
                g_LastSelectedInhabitant = nil;
                ShowCloseUpView(0, x, y);
                GUI.SetSelectedEntity(InhabitantsBuildingID);
            else
                GUI.SetSelectedEntity(InhabitantID);
                ShowCloseUpView(InhabitantID);
                g_LastSelectedInhabitant = InhabitantID;
            end
        end
    end
end

function Lib.SettlementSurvival.Local:IsSettlerSuspended(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    return self.SuspendedSettlers[PlayerID] and self.SuspendedSettlers[PlayerID][EntityID] ~= nil;
end

function Lib.SettlementSurvival.Local:HasSuspendedInhabitants(_Entity)
    local BuildingID = GetID(_Entity);
    local AttachedSettlers = {Logic.GetWorkersAndSpousesForBuilding(BuildingID)};
    for i= 1, #AttachedSettlers do
        if self:IsSettlerSuspended(AttachedSettlers[i]) then
            return true;
        end
    end
    return false;
end

function Lib.SettlementSurvival.Local:OverwriteGameCallbacks()
    self.Orig_GameCallback_Feedback_OnBuildingBurning = GameCallback_Feedback_OnBuildingBurning;
    GameCallback_Feedback_OnBuildingBurning = function(_PlayerID, _EntityID)
        Lib.SettlementSurvival.Local.Orig_GameCallback_Feedback_OnBuildingBurning(_PlayerID, _EntityID);
        SendReportToGlobal(Report.FireAlarmActivated_Internal, _EntityID);
    end

    self.Orig_GameCallback_GUI_DeleteEntityStateBuilding = GameCallback_GUI_DeleteEntityStateBuilding;
    GameCallback_GUI_DeleteEntityStateBuilding = function(_BuildingID, _State)
        if Lib.SettlementSurvival.Local:HasSuspendedInhabitants(_BuildingID) then
            Message(Localize(Lib.SettlementSurvival.Text.Messages.BuildingMourning));
            GUI.CancelBuildingKnockDown(_BuildingID);
            return;
        end
        Lib.Construction.Local.Orig_GameCallback_GUI_DeleteEntityStateBuilding(_BuildingID, _State);
    end
end

function Lib.SettlementSurvival.Local:OverwriteAlarmButtons()
    GUI_BuildingButtons.StartStopFireAlarmClicked_Orig_SettlementSurvival = GUI_BuildingButtons.StartStopFireAlarmClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartStopFireAlarmClicked = function()
        GUI_BuildingButtons.StartStopFireAlarmClicked_Orig_SettlementSurvival();
        local EntityID = GUI.GetSelectedEntity()
        if Logic.IsFireAlarmActiveAtBuilding(EntityID) == true then
            SendReportToGlobal(Report.FireAlarmActivated_Internal, EntityID);
        else
            SendReportToGlobal(Report.FireAlarmDeactivated_Internal, EntityID);
        end
    end

    GUI_BuildingButtons.StartStopRepairAlarmClicked_Orig_SettlementSurvival = GUI_BuildingButtons.StartStopRepairAlarmClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartStopRepairAlarmClicked = function()
        GUI_BuildingButtons.StartStopRepairAlarmClicked_Orig_SettlementSurvival();
        local EntityID = GUI.GetSelectedEntity()
        if Logic.IsRepairAlarmActiveAtBuilding(EntityID) == true then
            SendReportToGlobal(Report.ReRepairAlarmActivated_Internal, EntityID);
        else
            SendReportToGlobal(Report.RepairAlarmDeactivated_Internal, EntityID);
        end
    end
end

function Lib.SettlementSurvival.Local:OverwriteUpgradeButton()
    -- This creates a dependency to module/ui/uibuilding
    GUI_BuildingButtons.UpgradeClicked_Orig_SettlementSurvival = GUI_BuildingButtons.UpgradeClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.UpgradeClicked = function()
        local BuildingID = GUI.GetSelectedEntity();
        if Lib.SettlementSurvival.Local:HasSuspendedInhabitants(BuildingID) then
            Message(Localize(Lib.SettlementSurvival.Text.Messages.BuildingMourning));
            GUI.CancelBuildingKnockDown(BuildingID);
            return;
        end
        GUI_BuildingButtons.UpgradeClicked_Orig_SettlementSurvival();
    end
end

function Lib.SettlementSurvival.Local:OverrideSelectionChanged()
    self.Orig_GameCallback_GUI_SelectionChanged = GameCallback_GUI_SelectionChanged;
    GameCallback_GUI_SelectionChanged = function(_Source)
        Lib.SettlementSurvival.Local.Orig_GameCallback_GUI_SelectionChanged(_Source);
        Lib.SettlementSurvival.Local:OnBuildingSelected();
    end
end

function Lib.SettlementSurvival.Local:OnBuildingSelected()
    local EntityID = GUI.GetSelectedEntity();
    if Logic.IsEntityInCategory(EntityID, EntityCategories.OuterRimBuilding) == 1 then
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Clothes", 1);
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.SettlementSurvival.Name);

