Lib.Core = Lib.Core or {};
Lib.Core.Quest = {
    QuestCounter = 0,
    Text = {
        ActivateBuff = {
            Pattern = {
                de = "BONUS AKTIVIEREN{cr}{cr}%s",
                en = "ACTIVATE BUFF{cr}{cr}%s",
                fr = "ACTIVER BONUS{cr}{cr}%s",
            },
            BuffsVanilla = {
                ["Buff_Spice"]                  = {de = "Salz", en = "Salt", fr = "Sel"},
                ["Buff_Colour"]                 = {de = "Farben", en = "Color", fr = "Couleurs"},
                ["Buff_Entertainers"]           = {de = "Entertainer", en = "Entertainer", fr = "Artistes"},
                ["Buff_FoodDiversity"]          = {de = "Vielfältige Nahrung", en = "Food diversity", fr = "Diversité alimentaire"},
                ["Buff_ClothesDiversity"]       = {de = "Vielfältige Kleidung", en = "Clothes diversity", fr = "Diversité vestimentaire"},
                ["Buff_HygieneDiversity"]       = {de = "Vielfältige Reinigung", en = "Hygiene diversity", fr = "Diversité hygiénique"},
                ["Buff_EntertainmentDiversity"] = {de = "Vielfältige Unterhaltung", en = "Entertainment diversity", fr = "Diversité des dievertissements"},
                ["Buff_Sermon"]                 = {de = "Predigt", en = "Sermon", fr = "Sermon"},
                ["Buff_Festival"]               = {de = "Fest", en = "Festival", fr = "Festival"},
                ["Buff_ExtraPayment"]           = {de = "Sonderzahlung", en = "Extra payment", fr = "Paiement supplémentaire"},
                ["Buff_HighTaxes"]              = {de = "Hohe Steuern", en = "High taxes", fr = "Hautes taxes"},
                ["Buff_NoPayment"]              = {de = "Kein Sold", en = "No payment", fr = "Aucun paiement"},
                ["Buff_NoTaxes"]                = {de = "Keine Steuern", en = "No taxes", fr = "Aucune taxes"},
            },
            BuffsEx1 = {
                ["Buff_Gems"]              = {de = "Edelsteine", en = "Gems", fr = "Gemmes"},
                ["Buff_MusicalInstrument"] = {de = "Musikinstrumente", en = "Musical instruments", fr = "Instruments musicaux"},
                ["Buff_Olibanum"]          = {de = "Weihrauch", en = "Olibanum", fr = "Encens"},
            }
        },
        SoldierCount = {
            Pattern = {
                de = "SOLDATENANZAHL {cr}Partei: %s{cr}{cr}%s %d",
                en = "SOLDIER COUNT {cr}Faction: %s{cr}{cr}%s %d",
                fr = "NOMBRE DE SOLDATS {cr}Faction: %s{cr}{cr}%s %d",
            },
            Relation = {
                ["true"]  = {de = "Weniger als ", en = "Less than ", fr = "Moins de"},
                ["false"] = {de = "Mindestens ", en = "At least ", fr = "Au moins"},
            }
        },
        Festivals = {
            Pattern = {
                de = "FESTE FEIERN {cr}{cr}Partei: %s{cr}{cr}Anzahl: %d",
                en = "HOLD PARTIES {cr}{cr}Faction: %s{cr}{cr}Amount: %d",
                fr = "FESTIVITÉS {cr}{cr}Faction: %s{cr}{cr}Nombre : %d",
            },
        }
    }
}

CONST_EFFECT_NAME_TO_ID = {};
CONST_INITIALIZED_OBJECTS = {};
CONST_REFILL_AMOUNT = {};

Lib.Require("comfort/IsLocalScript");
Lib.Require("comfort/ToBoolean");
Lib.Require("comfort/GetHealth");
Lib.Require("comfort/CopyTable");
Lib.Require("comfort/GetQuestID");
Lib.Require("comfort/IsValidQuest");
Lib.Require("comfort/SendCart");
Lib.Require("comfort/SetResourceAmount");
Lib.Require("core/feature/Core_Report");
Lib.Register("core/feature/Core_Quest");

-- -------------------------------------------------------------------------- --

function SaveCustomVariable(_Name, _Value)
    Lib.Core.Quest:SetCustomVariable(_Name, _Value);
end
API.SaveCustomVariable = SaveCustomVariable;

function ObtainCustomVariable(_Name, _Default)
    local Value = Lib.CustomVariable[_Name];
    if not Value and _Default then
        Value = _Default;
    end
    return Value;
end
API.ObtainCustomVariable = ObtainCustomVariable;

-- -------------------------------------------------------------------------- --

function Lib.Core.Quest:Initialize()
    Report.CustomValueChanged = CreateReport("Event_CustomValueChanged");

    Report.QuestFailure = CreateReport("Event_QuestFailure");
    Report.QuestInterrupt = CreateReport("Event_QuestInterrupt");
    Report.QuestReset = CreateReport("Event_QuestReset");
    Report.QuestSuccess = CreateReport("Event_QuestSuccess");
    Report.QuestTrigger = CreateReport("Event_QuestTrigger");

    if not IsLocalScript() then
        self:OverrideQuestSystemGlobal();
        self:OverrideQuestMarkers();
        self:OverwriteGeologistRefill();
    end
    if IsLocalScript() then
        self:OverrideDisplayQuestObjective();
    end
end

function Lib.Core.Quest:OnSaveGameLoaded()
end

function Lib.Core.Quest:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Quest:OverrideQuestMarkers()
    QuestTemplate.RemoveQuestMarkers = function(self)
        for i=1, self.Objectives[0] do
            if self.Objectives[i].Type == Objective.Distance then
                if self.Objectives[i].Data[4] then
                    DestroyQuestMarker(self.Objectives[i].Data[2]);
                end
            end
        end
    end
    QuestTemplate.ShowQuestMarkers = function(self)
        for i=1, self.Objectives[0] do
            if self.Objectives[i].Type == Objective.Distance then
                if self.Objectives[i].Data[4] then
                    ShowQuestMarker(self.Objectives[i].Data[2]);
                end
            end
        end
    end

    function ShowQuestMarker(_Entity)
        local eID = GetID(_Entity);
        local x,y = Logic.GetEntityPosition(eID);
        local Marker = EGL_Effects.E_Questmarker_low;
        if Logic.IsBuilding(eID) == 1 then
            Marker = EGL_Effects.E_Questmarker;
        end
        DestroyQuestMarker(_Entity);
        Questmarkers[eID] = Logic.CreateEffect(Marker, x, y, 0);
    end
    function DestroyQuestMarker(_Entity)
        local eID = GetID(_Entity);
        if Questmarkers[eID] ~= nil then
            Logic.DestroyEffect(Questmarkers[eID]);
            Questmarkers[eID] = nil;
        end
    end
end

function Lib.Core.Quest:OverrideDisplayQuestObjective()
    GUI_Interaction.DisplayQuestObjective_Orig_Lib_Core = GUI_Interaction.DisplayQuestObjective
    GUI_Interaction.DisplayQuestObjective = function(_QuestIndex, _MessageKey)
        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex);
        if QuestType == Objective.Distance then
            if Quest.Objectives[1].Data[1] == -65566 then
                Quest.Objectives[1].Data[1] = Logic.GetKnightID(Quest.ReceivingPlayer);
            end
        end
        GUI_Interaction.DisplayQuestObjective_Orig_Lib_Core(_QuestIndex, _MessageKey);
    end
end

function Lib.Core.Quest:IsQuestPositionReached(_Quest, _Objective)
    local IDdata2 = GetID(_Objective.Data[1]);
    if IDdata2 == -65566 then
        _Objective.Data[1] = Logic.GetKnightID(_Quest.ReceivingPlayer);
        IDdata2 = _Objective.Data[1];
    end
    local IDdata3 = GetID(_Objective.Data[2]);
    _Objective.Data[3] = _Objective.Data[3] or 2500;
    if not (Logic.IsEntityDestroyed(IDdata2) or Logic.IsEntityDestroyed(IDdata3)) then
        if Logic.GetDistanceBetweenEntities(IDdata2,IDdata3) <= _Objective.Data[3] then
            DestroyQuestMarker(IDdata3);
            return true;
        end
    else
        DestroyQuestMarker(IDdata3);
        return false;
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Quest:OverwriteGeologistRefill()
    if Framework.GetGameExtraNo() >= 1 then
        self.Orig_SetResourceAmount = SetResourceAmount;
        SetResourceAmount = function(_Entity, _StartAmount, _RefillAmount)
            if Lib.Core.Quest.Orig_SetResourceAmount(_Entity, _StartAmount, _RefillAmount) then
                local EntityID = GetID(_Entity);
                CONST_REFILL_AMOUNT[EntityID] = _RefillAmount;
            end
        end
        API.SetResourceAmount = SetResourceAmount;

        GameCallback_OnGeologistRefill_Orig_Lib_Core = GameCallback_OnGeologistRefill;
        GameCallback_OnGeologistRefill = function(_PlayerID, _TargetID, _GeologistID)
            GameCallback_OnGeologistRefill_Orig_Lib_Core(_PlayerID, _TargetID, _GeologistID);
            if CONST_REFILL_AMOUNT[_TargetID] then
                local RefillAmount = CONST_REFILL_AMOUNT[_TargetID];
                local RefillRandom = RefillAmount + math.random(1, math.floor((RefillAmount * 0.2) + 0.5));
                Logic.SetResourceDoodadGoodAmount(_TargetID, RefillRandom);
                if RefillRandom > 0 then
                    if Logic.GetResourceDoodadGoodType(_TargetID) == Goods.G_Iron then
                        Logic.SetModel(_TargetID, Models.Doodads_D_SE_ResourceIron);
                    else
                        Logic.SetModel(_TargetID, Models.R_ResorceStone_Scaffold);
                    end
                end
            end
        end
    end
end

function Lib.Core.Quest:TriggerEntityKilledCallbacks(_Entity, _Attacker)
    local DefenderID = GetID(_Entity);
    local AttackerID = GetID(_Attacker or 0);
    if AttackerID == 0 or DefenderID == 0 or Logic.GetEntityHealth(DefenderID) > 0 then
        return;
    end
    local x, y, z     = Logic.EntityGetPos(DefenderID);
    local DefPlayerID = Logic.EntityGetPlayer(DefenderID);
    local DefType     = Logic.GetEntityType(DefenderID);
    local AttPlayerID = Logic.EntityGetPlayer(AttackerID);
    local AttType     = Logic.GetEntityType(AttackerID);

    GameCallback_EntityKilled(DefenderID, DefPlayerID, AttackerID, AttPlayerID, DefType, AttType);
    Logic.ExecuteInLuaLocalState(string.format(
        "GameCallback_Feedback_EntityKilled(%d, %d, %d, %d,%d, %d, %f, %f)",
        DefenderID, DefPlayerID, AttackerID, AttPlayerID, DefType, AttType, x, y
    ));
end

function Lib.Core.Quest:GetCustomVariable(_Name)
    return Lib.CustomVariable[_Name];
end

function Lib.Core.Quest:SetCustomVariable(_Name, _Value)
    self:UpdateCustomVariable(_Name, _Value);
    local Value = tostring(_Value);
    if type(_Value) ~= "number" then
        Value = [["]] ..Value.. [["]];
    end
    if not GUI then
        ExecuteLocal([[Lib.Core.Quest:UpdateCustomVariable("%s", %s)]], _Name, Value);
    end
end

function Lib.Core.Quest:UpdateCustomVariable(_Name, _Value)
    if Lib.CustomVariable[_Name] then
        local Old = Lib.CustomVariable[_Name];
        Lib.CustomVariable[_Name] = _Value;
        SendReport(Report.CustomValueChanged, _Name, Old, _Value);
    else
        Lib.CustomVariable[_Name] = _Value;
        SendReport(Report.CustomValueChanged, _Name, nil, _Value);
    end
end

-- -------------------------------------------------------------------------- --

function InteractiveObjectActivate(_ScriptName, _State)
    _State = _State or 0;
    if GUI or not IsExisting(_ScriptName) then
        return;
    end
    for i= 1, 8 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), i, _State);
    end
end
API.ActivateIO = InteractiveObjectActivate;
API.InteractiveObjectActivate = InteractiveObjectActivate;

function InteractiveObjectDeactivate(_ScriptName)
    if GUI or not IsExisting(_ScriptName) then
        return;
    end
    for i= 1, 8 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), i, 2);
    end
end
API.DeactivateIO = InteractiveObjectDeactivate;
API.InteractiveObjectDeactivate = InteractiveObjectDeactivate;

-- -------------------------------------------------------------------------- --

function Lib.Core.Quest:OverrideQuestSystemGlobal()
    QuestTemplate.Trigger_Orig_QSB_Core = QuestTemplate.Trigger
    QuestTemplate.Trigger = function(this)
        QuestTemplate.Trigger_Orig_QSB_Core(this);
        local QuestID = GetQuestID(this.Identifier);
        for i=1,this.Objectives[0] do
            if this.Objectives[i].Type == Objective.Custom2 and this.Objectives[i].Data[1].SetDescriptionOverwrite then
                local Desc = this.Objectives[i].Data[1]:SetDescriptionOverwrite(this);
                Lib.Core.Quest:ChangeCustomQuestCaptionText(Desc, this);
                break;
            end
        end
        SendReport(Report.QuestTrigger, QuestID);
        SendReportToLocal(Report.QuestTrigger, QuestID);
    end

    QuestTemplate.Interrupt_Orig_QSB_Core = QuestTemplate.Interrupt;
    QuestTemplate.Interrupt = function(this)
        this.State = QuestState.Over;
        this.Result = QuestResult.Interrupted;
        this:RemoveQuestMarkers();
        Logic.ExecuteInLuaLocalState("LocalScriptCallback_OnQuestStatusChanged("..this.Index..")");

        local QuestID = GetQuestID(this.Identifier);
        for i=1, this.Objectives[0] do
            if this.Objectives[i].Type == Objective.Custom2 and this.Objectives[i].Data[1].Interrupt then
                this.Objectives[i].Data[1]:Interrupt(this, i);
            end
        end
        for i=1, this.Triggers[0] do
            if this.Triggers[i].Type == Triggers.Custom2 and this.Triggers[i].Data[1].Interrupt then
                this.Triggers[i].Data[1]:Interrupt(this, i);
            end
        end
        SendReport(Report.QuestInterrupt, QuestID);
        SendReportToLocal(Report.QuestInterrupt, QuestID);
    end

    QuestTemplate.Fail_Orig_QSB_Core = QuestTemplate.Fail;
    QuestTemplate.Fail = function(this)
        this.State = QuestState.Over;
        this.Result = QuestResult.Failure;
        this:RemoveQuestMarkers();
        Logic.ExecuteInLuaLocalState("LocalScriptCallback_OnQuestStatusChanged("..this.Index..")");

        local QuestID = GetQuestID(this.Identifier);
        SendReport(Report.QuestFailure, QuestID);
        SendReportToLocal(Report.QuestFailure, QuestID);
    end

    QuestTemplate.Success = function(this)
        this.State = QuestState.Over;
        this.Result = QuestResult.Success;
        this:RemoveQuestMarkers();
        Logic.ExecuteInLuaLocalState("LocalScriptCallback_OnQuestStatusChanged("..this.Index..")");

        local QuestID = GetQuestID(this.Identifier);
        SendReport(Report.QuestSuccess, QuestID);
        SendReportToLocal(Report.QuestSuccess, QuestID);
    end
end

function Lib.Core.Quest:ChangeCustomQuestCaptionText(_Text, _Quest)
    if _Quest and _Quest.Visible then
        _Quest.QuestDescription = _Text;
        ExecuteLocal([[
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives/Custom/BGDeco",0)
            local identifier = "%s"
            for i=1, Quests[0] do
                if Quests[i].Identifier == identifier then
                    local text = Quests[i].QuestDescription
                    XGUIEng.SetText("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives/Custom/Text", "%s")
                    break
                end
            end
        ]], _Quest.Identifier, _Text);
    end
end

-- -------------------------------------------------------------------------- --

function SetResourceAmount(_Entity, _StartAmount, _RefillAmount)
    if GUI or not IsExisting(_Entity) then
        return;
    end
    assert(type(_StartAmount) == "number");
    assert(type(_RefillAmount) == "number");

    local EntityID = GetID(_Entity);
    if IsExisting(EntityID) and Logic.GetResourceDoodadGoodType(EntityID) ~= 0 then
        if Logic.GetResourceDoodadGoodAmount(EntityID) == 0 then
            EntityID = ReplaceEntity(EntityID, Logic.GetEntityType(EntityID));
        end
        Logic.SetResourceDoodadGoodAmount(EntityID, _StartAmount);
        CONST_REFILL_AMOUNT[EntityID] = _RefillAmount;
    end
end

function SetCustomBehaviorText(_QuestName, _Text)
    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    assert(Quest ~= nil, "Quest '" .._QuestName.. "' not found!");
    Lib.Core.Quest:ChangeCustomQuestCaptionText(_Text, Quest);
end
API.SetCustomBehaviorText = SetCustomBehaviorText;

function RestartQuest(_QuestName, _NoMessage)
    -- All changes on default behavior must be considered in this function.
    -- When a default behavior is changed in a module this function must be
    -- changed as well.

    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("restart quest " .._QuestName);
        end

        if Quest.Objectives then
            local questObjectives = Quest.Objectives;
            for i = 1, questObjectives[0] do
                local objective = questObjectives[i];
                objective.Completed = nil
                local objectiveType = objective.Type;

                if objectiveType == Objective.Deliver then
                    local data = objective.Data;
                    data[3] = nil;
                    data[4] = nil;
                    data[5] = nil;
                    data[9] = nil;

                elseif g_GameExtraNo and g_GameExtraNo >= 1 and objectiveType == Objective.Refill then
                    objective.Data[2] = nil;

                elseif objectiveType == Objective.Protect or objectiveType == Objective.Object then
                    local data = objective.Data;
                    for j=1, data[0], 1 do
                        data[-j] = nil;
                    end

                elseif objectiveType == Objective.DestroyEntities and objective.Data[1] == 2 and objective.DestroyTypeAmount then
                    objective.Data[3] = objective.DestroyTypeAmount;
                elseif objectiveType == Objective.DestroyEntities and objective.Data[1] == 3 then
                    objective.Data[4] = nil;
                    objective.Data[5] = nil;

                elseif objectiveType == Objective.Distance then
                    if objective.Data[1] == -65565 then
                        objective.Data[4].NpcInstance = nil;
                    end

                elseif objectiveType == Objective.Custom2 and objective.Data[1].Reset then
                    objective.Data[1]:Reset(Quest, i);
                end
            end
        end

        local function resetCustom(_type, _customType)
            local Quest = Quest;
            local behaviors = Quest[_type];
            if behaviors then
                for i = 1, behaviors[0] do
                    local behavior = behaviors[i];
                    if behavior.Type == _customType then
                        local behaviorDef = behavior.Data[1];
                        if behaviorDef and behaviorDef.Reset then
                            behaviorDef:Reset(Quest, i);
                        end
                    end
                end
            end
        end

        resetCustom("Triggers", Triggers.Custom2);
        resetCustom("Rewards", Reward.Custom);
        resetCustom("Reprisals", Reprisal.Custom);

        Quest.Result = nil;
        local OldQuestState = Quest.State;
        Quest.State = QuestState.NotTriggered;
        ExecuteLocal("LocalScriptCallback_OnQuestStatusChanged(%d)", Quest.Index);
        if OldQuestState == QuestState.Over then
            Quest.Job = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "Quest_Loop", 1, 0, {Quest.QueueID});
        end

        SendReport(Report.QuestReset, QuestID);
        SendReportToLocal(Report.QuestReset, QuestID);
    end
    return QuestID, Quest;
end
API.RestartQuest = RestartQuest;

function FailQuest(_QuestName, _NoMessage)
    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("fail quest " .._QuestName);
        end
        Quest:RemoveQuestMarkers();
        Quest:Fail();
    end
end
API.FailQuest = FailQuest;

function StartQuest(_QuestName, _NoMessage)
    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("start quest " .._QuestName);
        end
        Quest:SetMsgKeyOverride();
        Quest:SetIconOverride();
        Quest:Trigger();
    end
end
API.StartQuest = StartQuest;

function StopQuest(_QuestName, _NoMessage)
    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("interrupt quest " .._QuestName);
        end
        Quest:RemoveQuestMarkers();
        Quest:Interrupt(-1);
    end
end
API.StopQuest = StopQuest;

function WinQuest(_QuestName, _NoMessage)
    local QuestID = GetQuestID(_QuestName);
    local Quest = Quests[QuestID];
    if Quest then
        if not _NoMessage then
            Logic.DEBUG_AddNote("win quest " .._QuestName);
        end
        Quest:RemoveQuestMarkers();
        Quest:Success();
    end
end
API.WinQuest = WinQuest;

