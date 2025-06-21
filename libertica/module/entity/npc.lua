Lib.NPC = Lib.NPC or {};
Lib.NPC.Name = "NPC";
Lib.NPC.Global = {
    Interactions = {},
    NPC = {},
    UseMarker = true,
};
Lib.NPC.Local  = {};
Lib.NPC.Text = {
    StartConversation = {
        de = "Gespräch beginnen",
        en = "Start conversation",
        fr = "Conversation",
    }
};

CONST_LAST_NPC_INTERACTED = 0;
CONST_LAST_HERO_INTERACTED = 0;

Lib.Require("comfort/GetDistance");
Lib.Require("comfort/GetClosestToTarget");
Lib.Require("comfort/LookAt");
Lib.Require("comfort/Move");
Lib.Require("core/Core");
Lib.Require("module/entity/NPC_API");
Lib.Require("module/entity/NPC_Behavior");
Lib.Register("module/entity/NPC");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.NPC.Global:Initialize()
    if not self.IsInstalled then
        Report.NpcInteraction = CreateReport("Event_NpcInteraction");

        self:OverrideQuestFunctions();

        RequestHiResJob(function()
            if Logic.GetTime() > 1 then
                Lib.NPC.Global:InteractionTriggerController();
            end
        end);
        RequestJob(function()
            Lib.NPC.Global:InteractableMarkerController();
            Lib.NPC.Global:NpcFollowHeroController();
        end);

        -- Garbage collection
        Lib.NPC.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.NPC.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.NPC.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.NpcInteraction then
        CONST_LAST_NPC_INTERACTED = arg[1];
        CONST_LAST_HERO_INTERACTED = arg[2];
        self.Interactions[arg[1]] = self.Interactions[arg[1]] or {};
        if self.Interactions[arg[1]][arg[2]] then
            if Logic.GetCurrentTurn() <= self.Interactions[arg[1]][arg[2]] + 5 then
                return;
            end
        end
        self.Interactions[arg[1]][arg[2]] = Logic.GetCurrentTurn();
        self:PerformNpcInteraction(arg[3]);
    end
end

function Lib.NPC.Global:CreateNpc(_Data)
    self.NPC[_Data.ScriptName] = {
        ScriptName        = _Data.ScriptName,
        Active            = true,
        Arrived           = false,
        Type              = _Data.Type or 1,
        Player            = _Data.Player or {1, 2, 3, 4, 5, 6, 7, 8},
        WrongPlayerAction = _Data.WrongPlayerAction,
        Hero              = _Data.Hero,
        WrongHeroAction   = _Data.WrongHeroAction,
        Distance          = _Data.Distance or 350,
        Condition         = _Data.Condition,
        Callback          = _Data.Callback,
        Follow            = _Data.Follow == true,
        FollowHero        = _Data.FollowHero,
        FollowCallback    = _Data.FollowCallback,
        FollowDestination = _Data.FollowDestination,
        FollowDistance    = _Data.FollowDistance or 2000,
        FollowArriveArea  = _Data.FollowArriveArea or 500,
        FollowSpeed       = _Data.FollowSpeed or 1.0,
        UseMarker         = self.UseMarker == true,
        MarkerID          = 0
    }
    self:UpdateNpc(_Data);
    return self.NPC[_Data.ScriptName];
end

function Lib.NPC.Global:DestroyNpc(_Data)
    _Data.Active = false;
    self:UpdateNpc(_Data);
    self:DestroyMarker(_Data.ScriptName);
    self.NPC[_Data.ScriptName] = nil;
end

function Lib.NPC.Global:GetNpc(_ScriptName)
    return self.NPC[_ScriptName];
end

function Lib.NPC.Global:UpdateNpc(_Data)
    if not IsExisting(_Data.ScriptName) then
        return;
    end
    if not self.NPC[_Data.ScriptName] then
        local EntityID = GetID(_Data.ScriptName);
        Logic.SetOnScreenInformation(EntityID, 0);
        return;
    end
    for k, v in pairs(_Data) do
        self.NPC[_Data.ScriptName][k] = v;
    end
    self:CreateMarker(_Data.ScriptName);
    if self.NPC[_Data.ScriptName].Active then
        local EntityID = GetID(_Data.ScriptName);
        Logic.SetOnScreenInformation(EntityID, self.NPC[_Data.ScriptName].Type);
    else
        local EntityID = GetID(_Data.ScriptName);
        Logic.SetOnScreenInformation(EntityID, 0);
    end
end

function Lib.NPC.Global:PerformNpcInteraction(_PlayerID)
    local ScriptName = Logic.GetEntityName(CONST_LAST_NPC_INTERACTED);
    if self.NPC[ScriptName] then
        local Data = self.NPC[ScriptName];
        self:RotateActorsToEachother(_PlayerID);
        self:AdjustHeroTalkingDistance(Data.Distance);

        if not self:InteractionIsAppropriatePlayer(ScriptName, _PlayerID, CONST_LAST_HERO_INTERACTED) then
            return;
        end
        Data.TalkedTo = CONST_LAST_HERO_INTERACTED;

        if not self:InteractionIsAppropriateHero(ScriptName) then
            return;
        end

        if Data.Condition == nil or Data:Condition(_PlayerID, CONST_LAST_HERO_INTERACTED) then
            if not Data.Follow then
                Data.Active = false;
                if Data.Callback then
                    Data:Callback(_PlayerID, CONST_LAST_HERO_INTERACTED);
                end
            else
                if Data.FollowCallback then
                    Data:FollowCallback(_PlayerID, CONST_LAST_HERO_INTERACTED, false);
                end
            end

        else
            Data.TalkedTo = 0;
        end

        self:UpdateNpc(Data);
    end
end

function Lib.NPC.Global:InteractionIsAppropriatePlayer(_ScriptName, _PlayerID, _HeroID)
    local Appropriate = true;
    if self.NPC[_ScriptName] then
        local Data = self.NPC[_ScriptName];
        if Data.Player ~= nil then
            if type(Data.Player) == "table" then
                Appropriate = table.contains(Data.Player, _PlayerID);
            else
                Appropriate = Data.Player == _PlayerID;
            end

            if not Appropriate then
                local LastTime = (Data.WrongHeroTick or 0) +1;
                local CurrentTime = Logic.GetTime();
                if Data.WrongPlayerAction and LastTime < CurrentTime then
                    self.NPC[_ScriptName].LastWongPlayerTick = CurrentTime;
                    Data:WrongPlayerAction(_PlayerID);
                end
            end
        end
    end
    return Appropriate;
end

function Lib.NPC.Global:InteractionIsAppropriateHero(_ScriptName)
    local Appropriate = true;
    if self.NPC[_ScriptName] then
        local Data = self.NPC[_ScriptName];
        if Data.Hero ~= nil then
            if type(Data.Hero) == "table" then
                Appropriate = table.contains(Data.Hero, Logic.GetEntityName(CONST_LAST_HERO_INTERACTED));
            end
            Appropriate = Data.Hero == Logic.GetEntityName(CONST_LAST_HERO_INTERACTED);

            if not Appropriate then
                local LastTime = (Data.WrongHeroTick or 0) +1;
                local CurrentTime = Logic.GetTime();
                if Data.WrongHeroAction and LastTime < CurrentTime then
                    self.NPC[_ScriptName].WrongHeroTick = CurrentTime;
                    Data:WrongHeroAction(CONST_LAST_HERO_INTERACTED);
                end
            end
        end
    end
    return Appropriate;
end

function Lib.NPC.Global:GetEntityMovementTarget(_EntityID)
    local X = GetFloat(_EntityID, CONST_SCRIPTING_VALUES.Destination.X);
    local Y = GetFloat(_EntityID, CONST_SCRIPTING_VALUES.Destination.Y);
    return {X= X, Y= Y};
end

function Lib.NPC.Global:RotateActorsToEachother(_PlayerID)
    local PlayerKnights = {};
    Logic.GetKnights(_PlayerID, PlayerKnights);
    for k, v in pairs(PlayerKnights) do
        local Target = self:GetEntityMovementTarget(v);
        local x, y, z = Logic.EntityGetPos(CONST_LAST_NPC_INTERACTED);
        if math.floor(Target.X) == math.floor(x) and math.floor(Target.Y) == math.floor(y) then
            x, y, z = Logic.EntityGetPos(v);
            Logic.MoveEntity(v, x, y);
            LookAt(v, CONST_LAST_NPC_INTERACTED);
        end
    end
    LookAt(CONST_LAST_HERO_INTERACTED, CONST_LAST_NPC_INTERACTED);
    LookAt(CONST_LAST_NPC_INTERACTED, CONST_LAST_HERO_INTERACTED);
end

function Lib.NPC.Global:AdjustHeroTalkingDistance(_Distance)
    local Distance = _Distance * GetFloat(CONST_LAST_NPC_INTERACTED, CONST_SCRIPTING_VALUES.Size);
    if GetDistance(CONST_LAST_HERO_INTERACTED, CONST_LAST_NPC_INTERACTED) <= Distance * 0.7 then
        local Orientation = Logic.GetEntityOrientation(CONST_LAST_NPC_INTERACTED);
        local x1, y1, z1 = Logic.EntityGetPos(CONST_LAST_HERO_INTERACTED);
        local x2 = x1 + ((Distance * 0.5) * math.cos(math.rad(Orientation)));
        local y2 = y1 + ((Distance * 0.5) * math.sin(math.rad(Orientation)));
        local ID = Logic.CreateEntityOnUnblockedLand(Entities.XD_ScriptEntity, x2, y2, 0, 0);
        local x3, y3, z3 = Logic.EntityGetPos(ID);
        Logic.MoveSettler(CONST_LAST_HERO_INTERACTED, x3, y3);
        RequestHiResJob( function(_HeroID, _NPCID, _Time)
            if Logic.GetTime() > _Time +0.5 and Logic.IsEntityMoving(_HeroID) == false then
                LookAt(_HeroID, _NPCID);
                LookAt(_NPCID, _HeroID);
                return true;
            end
        end, CONST_LAST_HERO_INTERACTED, CONST_LAST_NPC_INTERACTED, Logic.GetTime());
    end
end

function Lib.NPC.Global:OverrideQuestFunctions()
    GameCallback_OnNPCInteraction_Orig_NPC = GameCallback_OnNPCInteraction;
    GameCallback_OnNPCInteraction = function(_EntityID, _PlayerID, _KnightID)
        GameCallback_OnNPCInteraction_Orig_NPC(_EntityID, _PlayerID, _KnightID);
        local ClosestKnightID = _KnightID or Lib.NPC.Global:GetClosestKnight(_EntityID, _PlayerID);
        SendReport(Report.NpcInteraction, _EntityID, ClosestKnightID, _PlayerID);
        SendReportToLocal(Report.NpcInteraction, _EntityID, ClosestKnightID, _PlayerID);
    end

    QuestTemplate.RemoveQuestMarkers_Orig_NPC = QuestTemplate.RemoveQuestMarkers;
    --- @diagnostic disable-next-line: duplicate-set-field
    QuestTemplate.RemoveQuestMarkers = function(this)
        for i=1, this.Objectives[0] do
            if this.Objectives[i].Type == Objective.Distance then
                if this.Objectives[i].Data[1] ~= -65565 then
                    QuestTemplate.RemoveQuestMarkers_Orig_NPC(this);
                else
                    if this.Objectives[i].Data[4].NpcInstance then
                        NpcDispose(this.Objectives[i].Data[4].NpcInstance);
                        this.Objectives[i].Data[4].NpcInstance = nil;
                    end
                end
            else
                QuestTemplate.RemoveQuestMarkers_Orig_NPC(this);
            end
        end
    end

    QuestTemplate.ShowQuestMarkers_Orig_NPC = QuestTemplate.ShowQuestMarkers;
    --- @diagnostic disable-next-line: duplicate-set-field
    QuestTemplate.ShowQuestMarkers = function(this)
        for i=1, this.Objectives[0] do
            if this.Objectives[i].Type == Objective.Distance then
                if this.Objectives[i].Data[1] ~= -65565 then
                    QuestTemplate.ShowQuestMarkers_Orig_NPC(this);
                else
                    local Hero = this.Objectives[i].Data[2];
                    local Npc = this.Objectives[i].Data[3];
                    if  this.Objectives[i].Data[4].NpcInstance
                    and this.Objectives[i].Data[4].NpcInstance.Active == false then
                        this.Objectives[i].Data[4].NpcInstance = nil;
                    end
                    if not this.Objectives[i].Data[4].NpcInstance then
                        this.Objectives[i].Data[4].NpcInstance = NpcCompose {
                            ScriptName = Npc,
                            Hero       = Hero,
                            Player     = this.ReceivingPlayer,
                        };
                    end
                end
            end
        end
    end

    QuestTemplate.IsObjectiveCompleted_Orig_NPC = QuestTemplate.IsObjectiveCompleted;
    --- @diagnostic disable-next-line: duplicate-set-field
    QuestTemplate.IsObjectiveCompleted = function(this, objective)
        local objectiveType = objective.Type;
        local data = objective.Data;
        if objective.Completed ~= nil then
            return objective.Completed;
        end

        if objectiveType ~= Objective.Distance then
            return this:IsObjectiveCompleted_Orig_NPC(objective);
        else
            if data[1] == -65565 then
                error(IsExisting(data[3]), data[3].. " is dead! :(");
                if data[4].NpcInstance and NpcTalkedTo(data[4].NpcInstance, data[2], this.ReceivingPlayer) then
                    objective.Completed = true;
                end
            else
                return this:IsObjectiveCompleted_Orig_NPC(objective);
            end
        end
    end
end

function Lib.NPC.Global:GetClosestKnight(_Entity, _PlayerID)
    local EntityID = GetID(_Entity);
    local KnightIDs = {};
    Logic.GetKnights(_PlayerID, KnightIDs);
    return GetClosestToTarget(EntityID, KnightIDs);
end

function Lib.NPC.Global:GetClosestKnightAllPlayer(_Entity)
    local ScriptName = Logic.GetEntityName(GetID(_Entity));
    if self.NPC[ScriptName] then
        local KnightIDs = {};
        for _, PlayerID in pairs(self.NPC[ScriptName].Player) do
            local PlayerKnightIDs = {};
            Logic.GetKnights(PlayerID, KnightIDs);
            KnightIDs = Array_Append(KnightIDs, PlayerKnightIDs);
        end
        return GetClosestToTarget(ScriptName, KnightIDs);
    end
end

function Lib.NPC.Global:ToggleMarkerUsage(_Flag)
    self.UseMarker = _Flag == true;
    for k, v in pairs(self.NPC) do
        self.NPC[k].UseMarker = _Flag == true;
        self:HideMarker(k);
    end
end

function Lib.NPC.Global:CreateMarker(_ScriptName)
    if self.NPC[_ScriptName] then
        local x,y,z = Logic.EntityGetPos(GetID(_ScriptName));
        local MarkerID = Logic.CreateEntity(Entities.XD_ScriptEntity, x, y, 0, 0);
        DestroyEntity(self.NPC[_ScriptName].MarkerID);
        self.NPC[_ScriptName].MarkerID = MarkerID;
        self:HideMarker(_ScriptName);
    end
end

function Lib.NPC.Global:DestroyMarker(_ScriptName)
    if self.NPC[_ScriptName] then
        DestroyEntity(self.NPC[_ScriptName].MarkerID);
        self.NPC[_ScriptName].MarkerID = 0;
    end
end

function Lib.NPC.Global:HideMarker(_ScriptName)
    if self.NPC[_ScriptName] then
        if IsExisting(self.NPC[_ScriptName].MarkerID) then
            Logic.SetModel(self.NPC[_ScriptName].MarkerID, Models.Effects_E_NullFX);
            Logic.SetVisible(self.NPC[_ScriptName].MarkerID, false);
        end
    end
end

function Lib.NPC.Global:ShowMarker(_ScriptName)
    if self.NPC[_ScriptName] then
        if self.NPC[_ScriptName].UseMarker == true and IsExisting(self.NPC[_ScriptName].MarkerID) then
            local Size = GetFloat(_ScriptName, CONST_SCRIPTING_VALUES.Size);
            SetFloat(self.NPC[_ScriptName].MarkerID, CONST_SCRIPTING_VALUES.Size, Size);
            Logic.SetModel(self.NPC[_ScriptName].MarkerID, Models.Effects_E_Wealth);
            Logic.SetVisible(self.NPC[_ScriptName].MarkerID, true);
        end
    end
end

function Lib.NPC.Global:GetEntityMovingTarget(_EntityID)
    local x = GetFloat(_EntityID, CONST_SCRIPTING_VALUES.Destination.X);
    local y = GetFloat(_EntityID, CONST_SCRIPTING_VALUES.Destination.Y);
    return {X= x, Y= y};
end

function Lib.NPC.Global:InteractionTriggerController()
    for PlayerID = 1, 8, 1 do
        local PlayersKnights = {};
        Logic.GetKnights(PlayerID, PlayersKnights);
        for i= 1, #PlayersKnights, 1 do
            if Logic.GetCurrentTaskList(PlayersKnights[i]) == "TL_NPC_INTERACTION" then
                for k, v in pairs(self.NPC) do
                    if v.Distance >= 350 then
                        local Target = self:GetEntityMovementTarget(PlayersKnights[i]);
                        local x2, y2 = Logic.EntityGetPos(GetID(k));
                        if math.floor(Target.X) == math.floor(x2) and math.floor(Target.Y) == math.floor(y2) then
                            if IsExisting(k) and IsNear(PlayersKnights[i], k, v.Distance) then
                                GameCallback_OnNPCInteraction(GetID(k), PlayerID, PlayersKnights[i]);
                                return;
                            end
                        end
                    end
                end
            end
        end
    end
end

function Lib.NPC.Global:InteractableMarkerController()
    for k, Data in pairs(self.NPC) do
        if Data.Active then
            if  Data.UseMarker and IsExisting(Data.MarkerID)
            and GetInteger(Data.MarkerID, CONST_SCRIPTING_VALUES.Visible) == 801280 then
                self:HideMarker(k);
            else
                self:ShowMarker(k);
            end
            local x1,y1,z1 = Logic.EntityGetPos(Data.MarkerID);
            local x2,y2,z2 = Logic.EntityGetPos(GetID(k));
            if math.abs(x1-x2) > 20 or math.abs(y1-y2) > 20 then
                Logic.DEBUG_SetPosition(Data.MarkerID, x2, y2);
            end
        end
    end
end

function Lib.NPC.Global:NpcFollowHeroController()
    for _, Data in pairs(self.NPC) do
        if Data.Active and Data.Follow and not Data.Arrived then
            local EntityID = GetID(Data.ScriptName);
            local LeadingEntity = GetID(Data.FollowHero);
            local FollowDistance = Data.FollowDistance;
            local FollowDestination = Data.FollowDestination;
            local FollowArriveArea = Data.FollowArriveArea;
            local FollowSpeed = Data.FollowSpeed;

            -- Get leader
            if not LeadingEntity then
                LeadingEntity = self:GetClosestKnightAllPlayer(EntityID);
            end
            -- Move NPC
            if LeadingEntity and not Logic.IsEntityMoving(EntityID) then
                if  GetDistance(EntityID, LeadingEntity) <= FollowDistance
                and GetDistance(EntityID, LeadingEntity) > FollowArriveArea / 2 then
                    Logic.SetSpeedFactor(EntityID, FollowSpeed);
                    Move(EntityID, LeadingEntity);
                end
            end
            -- Check arrival
            if LeadingEntity and GetDistance(EntityID, FollowDestination) <= FollowArriveArea then
                if not Logic.IsEntityMoving(EntityID) then
                    Move(EntityID, FollowDestination);
                    if Data.FollowCallback then
                        local PlayerID = Logic.EntityGetPlayer(LeadingEntity);
                        Data:FollowCallback(PlayerID, LeadingEntity, true);
                    end
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.NPC.Local:Initialize()
    if not self.IsInstalled then
        Report.NpcInteraction = CreateReport("Event_NpcInteraction");

        self:OverrideQuestFunctions();

        -- Garbage collection
        Lib.NPC.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.NPC.Local:OnSaveGameLoaded()
end

-- Global report listener
function Lib.NPC.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.NpcInteraction then
        CONST_LAST_NPC_INTERACTED = arg[1];
        CONST_LAST_HERO_INTERACTED = arg[2];
    end
end

function Lib.NPC.Local:OverrideQuestFunctions()
    GUI_Interaction.DisplayQuestObjective_Orig_NPC = GUI_Interaction.DisplayQuestObjective;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Interaction.DisplayQuestObjective = function(_QuestIndex, _MessageKey)
        local QuestIndexTemp = tonumber(_QuestIndex);
        if QuestIndexTemp then
            _QuestIndex = QuestIndexTemp;
        end

        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex);
        local QuestObjectivesPath = "/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives";
        XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives", 0);
        local QuestObjectiveContainer;
        local QuestTypeCaption;

        g_CurrentDisplayedQuestID = _QuestIndex;

        if QuestType == Objective.Distance then
            QuestObjectiveContainer = QuestObjectivesPath .. "/List";
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestInteraction");
            local ObjectList = {};

            assert(Quest ~= nil);
            if Quest.Objectives[1].Data[1] == -65565 then
                QuestObjectiveContainer = QuestObjectivesPath .. "/Distance";
                QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestMoveHere");
                SetIcon(QuestObjectiveContainer .. "/QuestTypeIcon",{7,10});

                local MoverEntityID = GetID(Quest.Objectives[1].Data[2]);
                local MoverEntityType = Logic.GetEntityType(MoverEntityID);
                local MoverIcon = g_TexturePositions.Entities[MoverEntityType];
                if not MoverIcon then
                    MoverIcon = {7, 9};
                end
                SetIcon(QuestObjectiveContainer .. "/IconMover", MoverIcon);

                local TargetEntityID = GetID(Quest.Objectives[1].Data[3]);
                local TargetEntityType = Logic.GetEntityType(TargetEntityID);
                local TargetIcon = g_TexturePositions.Entities[TargetEntityType];
                if not TargetIcon then
                    TargetIcon = {14, 10};
                end

                local IconWidget = QuestObjectiveContainer .. "/IconTarget";
                local ColorWidget = QuestObjectiveContainer .. "/TargetPlayerColor";

                SetIcon(IconWidget, TargetIcon);
                XGUIEng.SetMaterialColor(ColorWidget, 0, 255, 255, 255, 0);

                SetIcon(QuestObjectiveContainer .. "/QuestTypeIcon",{16,12});
                local caption = Lib.NPC.Text.StartConversation;
                QuestTypeCaption = Localize(caption);

                XGUIEng.SetText(QuestObjectiveContainer.."/Caption","{center}"..QuestTypeCaption);
                XGUIEng.ShowWidget(QuestObjectiveContainer, 1);
            else
                GUI_Interaction.DisplayQuestObjective_Orig_NPC(_QuestIndex, _MessageKey);
            end
        else
            GUI_Interaction.DisplayQuestObjective_Orig_NPC(_QuestIndex, _MessageKey);
        end
    end

    GUI_Interaction.GetEntitiesOrTerritoryListForQuest_Orig_NPC = GUI_Interaction.GetEntitiesOrTerritoryListForQuest
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Interaction.GetEntitiesOrTerritoryListForQuest = function( _Quest, _QuestType )
        local EntityOrTerritoryList = {}
        local IsEntity = true

        if _QuestType == Objective.Distance then
            if _Quest.Objectives[1].Data[1] == -65565 then
                local Entity = GetID(_Quest.Objectives[1].Data[3]);
                table.insert(EntityOrTerritoryList, Entity);
            else
                return GUI_Interaction.GetEntitiesOrTerritoryListForQuest_Orig_NPC(_Quest, _QuestType);
            end

        else
            return GUI_Interaction.GetEntitiesOrTerritoryListForQuest_Orig_NPC(_Quest, _QuestType);
        end
        return EntityOrTerritoryList, IsEntity
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.NPC.Name);

