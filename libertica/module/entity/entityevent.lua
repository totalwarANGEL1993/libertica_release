Lib.EntityEvent = Lib.EntityEvent or {};
Lib.EntityEvent.Name = "EntityEvent";
Lib.EntityEvent.Global = {
    JobID = {},
    RegisteredEntities = {},
    MineAmounts = {},
    AttackedEntities = {},
    DisableThiefStorehouseHeist = false,
    DisableThiefCathedralSabotage = false,
    DisableThiefCisternSabotage = false,

    -- TODO: Add predators?
    StaticSpawnerTypes = {
        "B_NPC_BanditsHQ_ME",
        "B_NPC_BanditsHQ_NA",
        "B_NPC_BanditsHQ_NE",
        "B_NPC_BanditsHQ_SE",
        "B_NPC_BanditsHutBig_ME",
        "B_NPC_BanditsHutBig_NA",
        "B_NPC_BanditsHutBig_NE",
        "B_NPC_BanditsHutBig_SE",
        "B_NPC_BanditsHutSmall_ME",
        "B_NPC_BanditsHutSmall_NA",
        "B_NPC_BanditsHutSmall_NE",
        "B_NPC_BanditsHutSmall_SE",
        "B_NPC_Barracks_ME",
        "B_NPC_Barracks_NA",
        "B_NPC_Barracks_NE",
        "B_NPC_Barracks_SE",
        "B_NPC_BanditsHQ_AS",
        "B_NPC_BanditsHutBig_AS",
        "B_NPC_BanditsHutSmall_AS",
        "B_NPC_Barracks_AS",
    },

    -- Those are "fluctuating" spawner entities that are keep appearing
    -- and disappearing depending of if they have resources spawned. They
    -- will be created anew each time the resource respanws without their
    -- old script name. So scriptnames are a nono.
    DynamicSpawnerTypes = {
        "S_AxisDeer_AS",
        "S_Deer_ME",
        "S_FallowDeer_SE",
        "S_Gazelle_NA",
        "S_Herbs",
        "S_Moose_NE",
        "S_RawFish",
        "S_Reindeer_NE",
        "S_WildBoar",
        "S_Zebra_NA",
    },
};
Lib.EntityEvent.Local  = {};

Lib.Require("comfort/GetDistance");
Lib.Require("core/Core");
Lib.Require("module/entity/EntityEvent_API");
Lib.Register("module/entity/EntityEvent");

-- Global ------------------------------------------------------------------- --

function Lib.EntityEvent.Global:Initialize()
    Report.SettlerAttracted = CreateReport("Event_SettlerAttracted");
    Report.EntitySpawned = CreateReport("Event_EntitySpawned");
    Report.EntityDestroyed = CreateReport("Event_EntityDestroyed");
    Report.EntityHurt = CreateReport("Event_EntityHurt");
    Report.EntityKilled = CreateReport("Event_EntityKilled");
    Report.EntityOwnerChanged = CreateReport("Event_EntityOwnerChanged");
    Report.EntityResourceChanged = CreateReport("Event_EntityResourceChanged");

    Report.ThiefInfiltratedBuilding = CreateReport("Event_ThiefInfiltratedBuilding");
    Report.ThiefDeliverEarnings = CreateReport("Event_ThiefDeliverEarnings");
    Report.BuildingConstructed = CreateReport("Event_BuildingConstructed");
    Report.BuildingUpgradeCollapsed = CreateReport("Event_BuildingUpgradeCollapsed");
    Report.BuildingUpgraded = CreateReport("Event_BuildingUpgraded");

    self:StartTriggers();
    self:OverrideCallback();
    self:OverrideLogic();
end

function Lib.EntityEvent.Global:OnSaveGameLoaded()
    self:OverrideLogic();
end

function Lib.EntityEvent.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadscreenClosed then
        self.LoadscreenClosed = true;
    elseif _ID == Report.EntityHurt then
        self.AttackedEntities[arg[3]] = {arg[1], 300};
    end
end

function Lib.EntityEvent.Global:CleanTaggedAndDeadEntities()
    -- check if entity should no longer be considered attacked
    for k,v in pairs(self.AttackedEntities) do
        self.AttackedEntities[k][2] = v[2] - 1;
        if v[2] <= 0 then
            self.AttackedEntities[k] = nil;
        else
            -- Send killed event for knights
            if IsExisting(k) and IsExisting(v[1]) and Logic.IsKnight(k) then
                if Logic.KnightGetResurrectionProgress(k) ~= 1 then
                    local PlayerID1 = Logic.EntityGetPlayer(k);
                    local PlayerID2 = Logic.EntityGetPlayer(v[1]);
                    self:TriggerEntityKilledEvent(k, PlayerID1, v[1], PlayerID2);
                    self.AttackedEntities[k] = nil;
                end
            end
        end
    end
end

function Lib.EntityEvent.Global:OverrideCallback()
    GameCallback_SettlerSpawned_Orig_QSB_EntityCore = GameCallback_SettlerSpawned;
    GameCallback_SettlerSpawned = function(_PlayerID, _EntityID)
        GameCallback_SettlerSpawned_Orig_QSB_EntityCore(_PlayerID, _EntityID);
        Lib.EntityEvent.Global:TriggerSettlerArrivedEvent(_PlayerID, _EntityID);
    end

    GameCallback_OnBuildingConstructionComplete_Orig_QSB_EntityCore = GameCallback_OnBuildingConstructionComplete;
    GameCallback_OnBuildingConstructionComplete = function(_PlayerID, _EntityID)
        GameCallback_OnBuildingConstructionComplete_Orig_QSB_EntityCore(_PlayerID, _EntityID);
        Lib.EntityEvent.Global:TriggerConstructionCompleteEvent(_PlayerID, _EntityID);
    end

    GameCallback_FarmAnimalChangedPlayerID_Orig_QSB_EntityCore = GameCallback_FarmAnimalChangedPlayerID;
    GameCallback_FarmAnimalChangedPlayerID = function(_PlayerID, _NewEntityID, _OldEntityID)
        GameCallback_FarmAnimalChangedPlayerID_Orig_QSB_EntityCore(_PlayerID, _NewEntityID, _OldEntityID);
        local OldPlayerID = Logic.EntityGetPlayer(_OldEntityID);
        local NewPlayerID = Logic.EntityGetPlayer(_NewEntityID);
        Lib.EntityEvent.Global:TriggerEntityOnwershipChangedEvent(_OldEntityID, OldPlayerID, _NewEntityID, NewPlayerID);
    end

    GameCallback_EntityCaptured_Orig_QSB_EntityCore = GameCallback_EntityCaptured;
    GameCallback_EntityCaptured = function(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID)
        GameCallback_EntityCaptured_Orig_QSB_EntityCore(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID)
        Lib.EntityEvent.Global:TriggerEntityOnwershipChangedEvent(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID);
    end

    GameCallback_CartFreed_Orig_QSB_EntityCore = GameCallback_CartFreed;
    GameCallback_CartFreed = function(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID)
        GameCallback_CartFreed_Orig_QSB_EntityCore(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID);
        Lib.EntityEvent.Global:TriggerEntityOnwershipChangedEvent(_OldEntityID, _OldEntityPlayerID, _NewEntityID, _NewEntityPlayerID);
    end

    GameCallback_OnThiefDeliverEarnings_Orig_QSB_EntityCore = GameCallback_OnThiefDeliverEarnings;
    GameCallback_OnThiefDeliverEarnings = function(_ThiefPlayerID, _ThiefID, _BuildingID, _GoodAmount)
        GameCallback_OnThiefDeliverEarnings_Orig_QSB_EntityCore(_ThiefPlayerID, _ThiefID, _BuildingID, _GoodAmount);
        local BuildingPlayerID = Logic.EntityGetPlayer(_BuildingID);
        Lib.EntityEvent.Global:TriggerThiefDeliverEarningsEvent(_ThiefID, _ThiefPlayerID, _BuildingID, BuildingPlayerID, _GoodAmount);
    end

    GameCallback_OnThiefStealBuilding_Orig_QSB_EntityCore = GameCallback_OnThiefStealBuilding;
    GameCallback_OnThiefStealBuilding = function(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)
        Lib.EntityEvent.Global:TriggerThiefStealFromBuildingEvent(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
    end

    GameCallback_OnBuildingUpgraded_Orig_QSB_EntityCore = GameCallback_OnBuildingUpgradeFinished;
	GameCallback_OnBuildingUpgradeFinished = function(_PlayerID, _EntityID, _NewUpgradeLevel)
		GameCallback_OnBuildingUpgraded_Orig_QSB_EntityCore(_PlayerID, _EntityID, _NewUpgradeLevel);
        Lib.EntityEvent.Global:TriggerUpgradeCompleteEvent(_PlayerID, _EntityID, _NewUpgradeLevel);
    end

    GameCallback_OnUpgradeLevelCollapsed_Orig_QSB_EntityCore = GameCallback_OnUpgradeLevelCollapsed;
    GameCallback_OnUpgradeLevelCollapsed = function(_PlayerID, _BuildingID, _NewUpgradeLevel)
        GameCallback_OnUpgradeLevelCollapsed_Orig_QSB_EntityCore(_PlayerID, _BuildingID, _NewUpgradeLevel);
        Lib.EntityEvent.Global:TriggerUpgradeCollapsedEvent(_PlayerID, _BuildingID, _NewUpgradeLevel);
    end
end

function Lib.EntityEvent.Global:OverrideLogic()
    self.Logic_ChangeEntityPlayerID = Logic.ChangeEntityPlayerID;
    Logic.ChangeEntityPlayerID = function(...)
        local OldID = {arg[1]};
        local OldPlayerID = Logic.EntityGetPlayer(arg[1]);
        local NewID = {self.Logic_ChangeEntityPlayerID(unpack(arg))};
        local NewPlayerID = Logic.EntityGetPlayer(NewID[1]);
        Lib.EntityEvent.Global:TriggerEntityOnwershipChangedEvent(
            OldID,
            OldPlayerID,
            NewID,
            NewPlayerID
        );
        return NewID;
    end

    self.Logic_ChangeSettlerPlayerID = Logic.ChangeSettlerPlayerID;
    Logic.ChangeSettlerPlayerID = function(...)
        local OldID = {arg[1]};
        local OldPlayerID = Logic.EntityGetPlayer(arg[1]);
        local OldSoldierTable = {Logic.GetSoldiersAttachedToLeader(arg[1])};
        if OldSoldierTable[1] and OldSoldierTable[1] > 0 then
            for i=2, OldSoldierTable[1]+1 do
                table.insert(OldID, OldSoldierTable[i]);
            end
        end
        local NewID = {self.Logic_ChangeSettlerPlayerID(unpack(arg))};
        local NewSoldierTable = {Logic.GetSoldiersAttachedToLeader(NewID[1])};
        if NewSoldierTable[1] and NewSoldierTable[1] > 0 then
            for i=2, NewSoldierTable[1]+1 do
                table.insert(NewID, NewSoldierTable[i]);
            end
        end
        local NewPlayerID = Logic.EntityGetPlayer(NewID[1]);
        Lib.EntityEvent.Global:TriggerEntityOnwershipChangedEvent(OldID, OldPlayerID, NewID, NewPlayerID);
        return NewID[1];
    end
end

function Lib.EntityEvent.Global:StartTriggers()
    self.JobID.EveryTurn = RequestJobByEventType(
        Events.LOGIC_EVENT_EVERY_TURN,
        function()
            if Logic.GetCurrentTurn() > 0 then
                Lib.EntityEvent.Global:CleanTaggedAndDeadEntities();
                Lib.EntityEvent.Global:CheckOnSpawnerEntities();
            end
        end
    );

    self.JobID.EverySecond = RequestJobByEventType(
        Events.LOGIC_EVENT_EVERY_SECOND,
        function()
            local MineEntityTypes = {
                Entities.R_IronMine,
                Entities.R_StoneMine
            };
            for i= 1, #MineEntityTypes do
                local Mines = Logic.GetEntitiesOfType(MineEntityTypes[i]);
                for j= 1, #Mines do
                    local Old = self.MineAmounts[Mines[j]];
                    local New = Logic.GetResourceDoodadGoodAmount(Mines[j]);
                    if Old and New and Old ~= New then
                        local Type = Logic.GetResourceDoodadGoodType(Mines[j]);
                        SendReport(Report.EntityResourceChanged, Mines[j], Type, Old, New);
                        SendReportToLocal(Report.EntityResourceChanged, Mines[j], Type, Old, New);
                    end
                    self.MineAmounts[Mines[j]] = New;
                end
            end
        end
    );

    self.JobID.EntityDestroyed = RequestJobByEventType(
        Events.LOGIC_EVENT_ENTITY_DESTROYED,
        function()
            local EntityID1 = Event.GetEntityID();
            local PlayerID1 = Logic.EntityGetPlayer(EntityID1);
            Lib.EntityEvent.Global:TriggerEntityDestroyedEvent(EntityID1, PlayerID1);
            if Lib.EntityEvent.Global.AttackedEntities[EntityID1] ~= nil then
                local EntityID2 = Lib.EntityEvent.Global.AttackedEntities[EntityID1][1];
                local PlayerID2 = Logic.EntityGetPlayer(EntityID2);
                Lib.EntityEvent.Global.AttackedEntities[EntityID1] = nil;
                Lib.EntityEvent.Global:TriggerEntityKilledEvent(EntityID1, PlayerID1, EntityID2, PlayerID2);
            end
        end
    );

    self.JobID.EveryHurn = RequestJobByEventType(
        Events.LOGIC_EVENT_ENTITY_HURT_ENTITY,
        function()
            local EntityID1 = Event.GetEntityID1();
            local PlayerID1 = Logic.EntityGetPlayer(EntityID1);
            local EntityID2 = Event.GetEntityID2();
            local PlayerID2 = Logic.EntityGetPlayer(EntityID2);
            SendReport(Report.EntityHurt, EntityID1, PlayerID1, EntityID2, PlayerID2);
            SendReportToLocal(Report.EntityHurt, EntityID1, PlayerID1, EntityID2, PlayerID2);
        end
    );
end

function Lib.EntityEvent.Global:CheckOnSpawnerEntities()
    -- Get spawners
    local SpawnerEntities = {};
    for i= 1, #self.DynamicSpawnerTypes do
        if Entities[self.DynamicSpawnerTypes[i]] then
            if Logic.GetCurrentTurn() % 10 == i then
                for k, v in pairs(Logic.GetEntitiesOfType(Entities[self.DynamicSpawnerTypes[i]])) do
                    table.insert(SpawnerEntities, v);
                end
            end
        end
    end
    for i= 1, #self.StaticSpawnerTypes do
        if Entities[self.StaticSpawnerTypes[i]] then
            if Logic.GetCurrentTurn() % 10 == i then
                for k, v in pairs(Logic.GetEntitiesOfType(Entities[self.StaticSpawnerTypes[i]])) do
                    table.insert(SpawnerEntities, v);
                end
            end
        end
    end
    -- Check spawned entities
    for i= 1, #SpawnerEntities do
        for k, v in pairs{Logic.GetSpawnedEntities(SpawnerEntities[i])} do
            -- On Spawner entity spawned
            if not self.RegisteredEntities[v] then
                self:TriggerEntitySpawnedEvent(v, SpawnerEntities[i]);
                self.RegisteredEntities[v] = SpawnerEntities[i];
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

function Lib.EntityEvent.Global:TriggerEntityOnwershipChangedEvent(_OldID, _OldOwnerID, _NewID, _NewOwnerID)
    _OldID = (type(_OldID) ~= "table" and {_OldID}) or _OldID;
    _NewID = (type(_NewID) ~= "table" and {_NewID}) or _NewID;
    assert(#_OldID == #_NewID, "Sums of entities with changed owner does not add up!");
    for i=1, #_OldID do
        SendReport(Report.EntityOwnerChanged, _OldID[i], _OldOwnerID, _NewID[i], _NewOwnerID);
        SendReportToLocal(Report.EntityOwnerChanged, _OldID[i], _OldOwnerID, _NewID[i], _NewOwnerID);
    end
end

function Lib.EntityEvent.Global:TriggerThiefDeliverEarningsEvent(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID, _GoodAmount)
    SendReport(Report.ThiefDeliverEarnings, _ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID, _GoodAmount);
    SendReportToLocal(Report.ThiefDeliverEarnings, _ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID, _GoodAmount);
end

function Lib.EntityEvent.Global:TriggerThiefStealFromBuildingEvent(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID)
    local HeadquartersID = Logic.GetHeadquarters(_BuildingPlayerID);
    local CathedralID = Logic.GetCathedral(_BuildingPlayerID);
    local StorehouseID = Logic.GetStoreHouse(_BuildingPlayerID);
    local IsVillageStorehouse = Logic.IsEntityInCategory(StorehouseID, EntityCategories.VillageStorehouse) == 1;
    local BuildingType = Logic.GetEntityType(_BuildingID);

    -- Aus Lagerhaus stehlen
    if StorehouseID == _BuildingID and (not IsVillageStorehouse or HeadquartersID == 0) then
        if not self.DisableThiefStorehouseHeist then
            GameCallback_OnThiefStealBuilding_Orig_QSB_EntityCore(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
        end
    end
    -- Kirche sabotieren
    if CathedralID == _BuildingID then
        if not self.DisableThiefCathedralSabotage then
            GameCallback_OnThiefStealBuilding_Orig_QSB_EntityCore(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
        end
    end
    -- Brunnen sabotieren
    if Framework.GetGameExtraNo() > 0 and BuildingType == Entities.B_Cistern then
        if not self.DisableThiefCisternSabotage then
            GameCallback_OnThiefStealBuilding_Orig_QSB_EntityCore(_ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
        end
    end

    -- Send event
    SendReport(Report.ThiefInfiltratedBuilding, _ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
    SendReportToLocal(Report.ThiefInfiltratedBuilding, _ThiefID, _ThiefPlayerID, _BuildingID, _BuildingPlayerID);
end

function Lib.EntityEvent.Global:TriggerEntitySpawnedEvent(_EntityID, _SpawnerID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    SendReport(Report.EntitySpawned, _EntityID, PlayerID, _SpawnerID);
    SendReportToLocal(Report.EntitySpawned, _EntityID, PlayerID, _SpawnerID);
end

function Lib.EntityEvent.Global:TriggerSettlerArrivedEvent(_PlayerID, _EntityID)
    SendReport(Report.SettlerAttracted, _EntityID, _PlayerID);
    SendReportToLocal(Report.SettlerAttracted, _EntityID, _PlayerID);
end

function Lib.EntityEvent.Global:TriggerEntityDestroyedEvent(_EntityID, _PlayerID)
    SendReport(Report.EntityDestroyed, _EntityID, _PlayerID);
    SendReportToLocal(Report.EntityDestroyed, _EntityID, _PlayerID);
end

function Lib.EntityEvent.Global:TriggerEntityKilledEvent(_EntityID1, _PlayerID1, _EntityID2, _PlayerID2)
    SendReport(Report.EntityKilled, _EntityID1, _PlayerID1, _EntityID2, _PlayerID2);
    SendReportToLocal(Report.EntityKilled, _EntityID1, _PlayerID1, _EntityID2, _PlayerID2);
end

function Lib.EntityEvent.Global:TriggerConstructionCompleteEvent(_PlayerID, _EntityID)
    SendReport(Report.BuildingConstructed, _EntityID, _PlayerID);
    SendReportToLocal(Report.BuildingConstructed, _EntityID, _PlayerID);
end

function Lib.EntityEvent.Global:TriggerUpgradeCompleteEvent(_PlayerID, _EntityID, _NewUpgradeLevel)
    SendReport(Report.BuildingUpgraded, _EntityID, _PlayerID, _NewUpgradeLevel);
    SendReportToLocal(Report.BuildingUpgraded, _EntityID, _PlayerID, _NewUpgradeLevel);
end

function Lib.EntityEvent.Global:TriggerUpgradeCollapsedEvent(_PlayerID, _EntityID, _NewUpgradeLevel)
    SendReport(Report.BuildingUpgradeCollapsed, _EntityID, _PlayerID, _NewUpgradeLevel);
    SendReportToLocal(Report.BuildingUpgradeCollapsed, _EntityID, _PlayerID, _NewUpgradeLevel);
end

-- Local -------------------------------------------------------------------- --

function Lib.EntityEvent.Local:Initialize()
    Report.SettlerAttracted = CreateReport("Event_SettlerAttracted");
    Report.EntitySpawned = CreateReport("Event_EntitySpawned");
    Report.EntityDestroyed = CreateReport("Event_EntityDestroyed");
    Report.EntityHurt = CreateReport("Event_EntityHurt");
    Report.EntityKilled = CreateReport("Event_EntityKilled");
    Report.EntityOwnerChanged = CreateReport("Event_EntityOwnerChanged");
    Report.EntityResourceChanged = CreateReport("Event_EntityResourceChanged");

    Report.ThiefInfiltratedBuilding = CreateReport("Event_ThiefInfiltratedBuilding");
    Report.ThiefDeliverEarnings = CreateReport("Event_ThiefDeliverEarnings");
    Report.BuildingConstructed = CreateReport("Event_BuildingConstructed");
    Report.BuildingUpgradeCollapsed = CreateReport("Event_BuildingUpgradeCollapsed");
    Report.BuildingUpgraded = CreateReport("Event_BuildingUpgraded");
end

function Lib.EntityEvent.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.EntityEvent.Name);

