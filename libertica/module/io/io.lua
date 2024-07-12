Lib.IO = Lib.IO or {};
Lib.IO.Name = "IO";
Lib.IO.Global = {
    SlaveSequence = 0,
};
Lib.IO.Local  = {
    Data = {},
};
Lib.IO.Shared = {
    TechnologyConfig = {
        -- Tech name, Description, Icon, Extra Number
        {"R_CallGeologist", {de = "Geologen rufen", en = "Order geologist", fr = "Ordre géologue"}, {8, 1, 1}, 1},
        {"R_RefillIronMine", {de = "Eisenmine auffüllen", en = "Refill mine", fr = "Recharger le mien"}, {8, 2, 1}, 1},
        {"R_RefillStoneMine", {de = "Steinbruch auffüllen", en = "Refill quarry", fr = "Carrière de recharge"}, {8, 3, 1}, 1},
        {"R_RefillCistern", {de = "Brunnen auffüllen", en = "Refill well", fr = "Bien remplir"}, {8, 4, 1}, 1},
        {"R_Tradepost", {de = "Handelsposten bauen", en = "Build Tradepost", fr = "Route commerciale"}, {3, 1, 1}, 1},
    }
};

CONST_IO = {};
CONST_IO_SLAVE_TO_MASTER = {};
CONST_IO_SLAVE_STATE = {};

CONST_IO_LAST_OBJECT = 0;
CONST_IO_LAST_HERO = 0;

Lib.Require("comfort/GetClosestToTarget");
Lib.Require("comfort/IsLocalScript");
Lib.Require("comfort/IsHistoryEdition");
Lib.Require("comfort/ReplaceEntity");
Lib.Require("core/Core");
Lib.Require("module/ui/UITools");
Lib.Require("module/faker/Technology");
Lib.Require("module/io/IO_API");
Lib.Require("module/io/IO_Behavior");
Lib.Register("module/io/IO");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.IO.Global:Initialize()
    if not self.IsInstalled then
        --- The player clicked the interaction button.
        --- 
        --- #### Parameters
        --- * `ScriptName` - Scriptname of entity
        --- * `KnightID`   - ID of activating hero
        --- * `PlayerID`   - ID of activating player
        Report.ObjectClicked = CreateReport("Event_ObjectClicked");

        --- The interaction of the object was successfull.
        --- If the object has costs the activation concludes when the costs arrive.
        --- 
        --- #### Parameters
        --- * `ScriptName` - Scriptname of entity
        --- * `KnightID`   - ID of activating hero
        --- * `PlayerID`   - ID of activating player
        Report.ObjectInteraction = CreateReport("Event_ObjectInteraction");

        --- The interaction is deleted from the object.
        ---
        --- #### Parameters
        --- * `ScriptName` - Scriptname of entity
        Report.ObjectReset = CreateReport("Event_ObjectReset");

        --- The state of an object has been reset.
        ---
        --- #### Parameters
        --- * `ScriptName` - Scriptname of entity
        Report.ObjectDelete = CreateReport("Event_ObjectDelete");

        Report.Internal_DebugEnableObject = CreateReport("Event_Internal_DebugEnableObject");
        Report.Internal_DebugDisableObject = CreateReport("Event_Internal_DebugDisableObject");
        Report.Internal_DebugInitObject = CreateReport("Event_Internal_DebugInitObject");

        Lib.IO.Shared:CreateTechnologies();

        self:OverrideObjectInteraction();
        self:StartObjectDestructionController();
        self:StartObjectConditionController();

        -- Garbage collection
        Lib.IO.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.IO.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.IO.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.ObjectInteraction then
        self:OnObjectInteraction(arg[1], arg[2], arg[3]);
    elseif _ID == Report.ChatClosed then
        if arg[3] then
            self:ProcessChatInput(arg[1]);
        end
    elseif _ID == Report.Internal_DebugEnableObject then
        error(IsExisting(arg[1]), "object " ..arg[1].. " does not exist!");
        InteractiveObjectActivate(arg[1], arg[2], arg[3]);
    elseif _ID == Report.Internal_DebugDeableObject then
        error(IsExisting(arg[1]), "object " ..arg[1].. " does not exist!");
        InteractiveObjectDeactivate(arg[1], arg[2], arg[3]);
    elseif _ID == Report.Internal_DebugInitObject then
        error(IsExisting(arg[1]), "object " ..arg[1].. " does not exist!");
        local Reward = (arg[2] ~= nil and {arg[2], arg[3]});
        local Costs = (arg[4] ~= nil and {arg[4], arg[5], arg[6], arg[7]});
        API.SetupObject({
            Name = arg[1],
            Costs = Costs,
            Reward = Reward,
            Waittime = 0,
            State = 0
        });
    end
end

function Lib.IO.Global:OnObjectInteraction(_ScriptName, _KnightID, _PlayerID)
    CONST_IO_LAST_OBJECT = GetID(_ScriptName);
    CONST_IO_LAST_HERO = _KnightID;

    if CONST_IO_SLAVE_TO_MASTER[_ScriptName] then
        _ScriptName = CONST_IO_SLAVE_TO_MASTER[_ScriptName];
    end
    if CONST_IO[_ScriptName] then
        CONST_IO[_ScriptName].IsUsed = true;
        ExecuteLocal([[
            local ScriptName = "%s"
            if CONST_IO[ScriptName] then
                CONST_IO[ScriptName].IsUsed = true
            end
        ]], _ScriptName);
        if CONST_IO[_ScriptName].Replacement then
            ReplaceEntity(_ScriptName, CONST_IO[_ScriptName].Replacement);
        end
        if CONST_IO[_ScriptName].Action then
            CONST_IO[_ScriptName]:Action(_PlayerID, _KnightID);
        end
    end
end

function Lib.IO.Global:CreateObject(_Description)
    local ID = GetID(_Description.Name);
    if ID == 0 then
        return;
    end
    self:DestroyObject(_Description.Name);

    local TypeName = Logic.GetEntityTypeName(Logic.GetEntityType(ID));
    if TypeName and not TypeName:find("^I_X_") then
        self:CreateSlaveObject(_Description);
    end

    _Description.IsActive = true;
    _Description.IsUsed = false;
    _Description.Player = _Description.Player or {1, 2, 3, 4, 5, 6, 7, 8};
    _Description.State = _Description.State or 0;
    _Description.Waittime = _Description.Waittime or 5;
    _Description.Distance = _Description.Distance or 1000;
    CONST_IO[_Description.Name] = _Description;
    ExecuteLocal(
        [[CONST_IO["%s"] = %s]],
        _Description.Name,
        table.tostring(CONST_IO[_Description.Name])
    );
    self:SetupObject(_Description);
    return _Description;
end

function Lib.IO.Global:DestroyObject(_ScriptName)
    if not CONST_IO[_ScriptName] then
        return;
    end
    if CONST_IO[_ScriptName].Slave then
        CONST_IO_SLAVE_TO_MASTER[CONST_IO[_ScriptName].Slave] = nil;
        ExecuteLocal(
            [[CONST_IO_SLAVE_TO_MASTER["%s"] = nil]],
            CONST_IO[_ScriptName].Slave
        );
        CONST_IO_SLAVE_STATE[CONST_IO[_ScriptName].Slave] = nil;
        DestroyEntity(CONST_IO[_ScriptName].Slave);
    end
    self:SetObjectState(_ScriptName, 2);
    SendReport(Report.ObjectDelete, _ScriptName);
    SendReportToLocal(Report.ObjectDelete, _ScriptName);
    ExecuteLocal([[CONST_IO["%s"] = nil]], _ScriptName);
    CONST_IO[_ScriptName] = nil;
end

function Lib.IO.Global:CreateSlaveObject(_Object)
    local Name;
    for k, v in pairs(CONST_IO_SLAVE_TO_MASTER) do
        if v == _Object.Name and IsExisting(k) then
            Name = k;
        end
    end
    if Name == nil then
        self.SlaveSequence = self.SlaveSequence +1;
        Name = "LIB_IO_SlaveObject_" ..self.SlaveSequence;
    end

    local SlaveID = GetID(Name);
    if not IsExisting(Name) then
        local x,y,z = Logic.EntityGetPos(GetID(_Object.Name));
        SlaveID = Logic.CreateEntity(Entities.I_X_DragonBoatWreckage, x, y, 0, 0);
        Logic.SetModel(SlaveID, Models.Effects_E_Mosquitos);
        Logic.SetEntityName(SlaveID, Name);
        CONST_IO_SLAVE_TO_MASTER[Name] = _Object.Name;
        ExecuteLocal([[CONST_IO_SLAVE_TO_MASTER["%s"] = "%s"]], Name, _Object.Name);
        _Object.Slave = Name;
    end
    CONST_IO_SLAVE_STATE[Name] = 1;
    return SlaveID;
end

function Lib.IO.Global:SetupObject(_Object)
    local ID = GetID((_Object.Slave and _Object.Slave) or _Object.Name);
    Logic.InteractiveObjectClearCosts(ID);
    Logic.InteractiveObjectClearRewards(ID);
    Logic.InteractiveObjectSetInteractionDistance(ID, _Object.Distance);
    Logic.InteractiveObjectSetTimeToOpen(ID, _Object.Waittime);

    local RewardResourceCart = _Object.RewardResourceCartType or Entities.U_ResourceMerchant;
    Logic.InteractiveObjectSetRewardResourceCartType(ID, RewardResourceCart);
    local RewardGoldCart = _Object.RewardGoldCartType or Entities.U_GoldCart;
    Logic.InteractiveObjectSetRewardGoldCartType(ID, RewardGoldCart);
    local CostResourceCart = _Object.CostResourceCartType or Entities.U_ResourceMerchant;
    Logic.InteractiveObjectSetCostResourceCartType(ID, CostResourceCart);
    local CostGoldCart = _Object.CostGoldCartType or Entities.U_GoldCart;
    Logic.InteractiveObjectSetCostGoldCartType(ID, CostGoldCart);

    if _Object.Reward then
        Logic.InteractiveObjectAddRewards(ID, _Object.Reward[1], _Object.Reward[2]);
    end
    if _Object.Costs and _Object.Costs[1] then
        Logic.InteractiveObjectAddCosts(ID, _Object.Costs[1], _Object.Costs[2]);
    end
    if _Object.Costs and _Object.Costs[3] then
        Logic.InteractiveObjectAddCosts(ID, _Object.Costs[3], _Object.Costs[4]);
    end
    table.insert(HiddenTreasures, ID);
    InteractiveObjectActivate(Logic.GetEntityName(ID), _Object.State or 0);
end

function Lib.IO.Global:ResetObject(_ScriptName)
    local ID = GetID((CONST_IO[_ScriptName].Slave and CONST_IO[_ScriptName].Slave) or _ScriptName);
    RemoveInteractiveObjectFromOpenedList(ID);
    table.insert(HiddenTreasures, ID);
    Logic.InteractiveObjectSetAvailability(ID, true);
    self:SetObjectState(ID, CONST_IO[_ScriptName].State or 0);
    CONST_IO[_ScriptName].IsUsed = false;
    CONST_IO[_ScriptName].IsActive = true;

    SendReport(Report.ObjectReset, _ScriptName);
    SendReportToLocal(Report.ObjectReset, _ScriptName);
end

function Lib.IO.Global:SetObjectState(_ScriptName, _State, ...)
    arg = ((not arg or #arg == 0) and {1, 2, 3, 4, 5, 6, 7, 8}) or arg;
    for i= 1, 8 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), i, 2);
    end
    for i= 1, #arg, 1 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), arg[i], _State);
    end
    Logic.InteractiveObjectSetAvailability(GetID(_ScriptName), _State ~= 2);
end

function Lib.IO.Global:OverrideObjectInteraction()
    GameCallback_OnObjectInteraction = function(_EntityID, _PlayerID)
        OnInteractiveObjectOpened(_EntityID, _PlayerID);
        OnTreasureFound(_EntityID, _PlayerID);

        local ScriptName = Logic.GetEntityName(_EntityID);
        if CONST_IO_SLAVE_TO_MASTER[ScriptName] then
            ScriptName = CONST_IO_SLAVE_TO_MASTER[ScriptName];
        end
        local KnightIDs = {};
        Logic.GetKnights(_PlayerID, KnightIDs);
        local KnightID = GetClosestToTarget(_EntityID, KnightIDs);
        SendReport(Report.ObjectInteraction, ScriptName, KnightID, _PlayerID);
        SendReportToLocal(Report.ObjectInteraction, ScriptName, KnightID, _PlayerID);
    end

    --- @diagnostic disable-next-line: duplicate-set-field
    QuestTemplate.AreObjectsActivated = function(self, _ObjectList)
        for i=1, _ObjectList[0] do
            if not _ObjectList[-i] then
                _ObjectList[-i] = GetID(_ObjectList[i]);
            end
            local EntityName = Logic.GetEntityName(_ObjectList[-i]);
            if CONST_IO_SLAVE_TO_MASTER[EntityName] then
                EntityName = CONST_IO_SLAVE_TO_MASTER[EntityName];
            end

            if CONST_IO[EntityName] then
                if CONST_IO[EntityName].IsUsed ~= true then
                    return false;
                end
            elseif Logic.IsInteractiveObject(_ObjectList[-i]) then
                if not IsInteractiveObjectOpen(_ObjectList[-i]) then
                    return false;
                end
            end
        end
        return true;
    end
end

function Lib.IO.Global:ProcessChatInput(_Text)
    if IsHistoryEdition() then
        local Commands = Lib.Core.Debug:CommandTokenizer(_Text);
        for i= 1, #Commands, 1 do
            if Commands[i][1] == "enableobject" then
                local State = (Commands[i][3] and tonumber(Commands[i][3])) or nil;
                local PlayerID = (Commands[i][4] and tonumber(Commands[i][4])) or nil;
                error(IsExisting(Commands[i][2]), "object " ..Commands[i][2].. " does not exist!");
                ---@diagnostic disable-next-line: param-type-mismatch
                InteractiveObjectActivate(Commands[i][2], State, PlayerID);
                log("activated object " ..Commands[i][2].. ".");
            elseif Commands[i][1] == "disableobject" then
                local PlayerID = (Commands[i][3] and tonumber(Commands[i][3])) or nil;
                error(IsExisting(Commands[i][2]), "object " ..Commands[i][2].. " does not exist!");
                InteractiveObjectDeactivate(Commands[i][2], PlayerID);
                log("deactivated object " ..Commands[i][2].. ".");
            elseif Commands[i][1] == "initobject" then
                error(IsExisting(Commands[i][2]), "object " ..Commands[i][2].. " does not exist!");
                API.SetupObject({
                    Name     = Commands[i][2],
                    Waittime = 0,
                    State    = 0
                });
                log("quick initalization of object " ..Commands[i][2].. ".");
            end
        end
    end
end

function Lib.IO.Global:StartObjectDestructionController()
    RequestJobByEventType(Events.LOGIC_EVENT_ENTITY_DESTROYED, function()
        local DestryoedEntityID = Event.GetEntityID();
        local SlaveName  = Logic.GetEntityName(DestryoedEntityID);
        local MasterName = CONST_IO_SLAVE_TO_MASTER[SlaveName];
        if SlaveName and MasterName then
            local Object = CONST_IO[MasterName];
            if not Object then
                return;
            end
            log("slave " ..SlaveName.. " of master " ..MasterName.. " has been deleted!");
            log("try to create new slave...");
            CONST_IO_SLAVE_TO_MASTER[SlaveName] = nil;
            ExecuteLocal([[CONST_IO_SLAVE_TO_MASTER["%s"] = nil]], SlaveName);
            local SlaveID = Lib.IO.Global:CreateSlaveObject(Object);
            error(IsExisting(SlaveID), "failed to create slave!");
            Lib.IO.Global:SetupObject(Object);
            if Object.IsUsed == true or (CONST_IO_SLAVE_STATE[SlaveName] and CONST_IO_SLAVE_STATE[SlaveName] == 0) then
                InteractiveObjectDeactivate(Object.Slave);
            end
            log("new slave created for master " ..MasterName.. ".");
        end
    end);
end

function Lib.IO.Global:StartObjectConditionController()
    RequestHiResJob(function()
        for k, v in pairs(CONST_IO) do
            if v and not v.IsUsed and v.IsActive then
                CONST_IO[k].IsFullfilled = true;
                if CONST_IO[k].Condition then
                    local IsFulfulled = v:Condition();
                    CONST_IO[k].IsFullfilled = IsFulfulled;
                end
                ExecuteLocal([[
                    local ScriptName = "%s"
                    if CONST_IO[ScriptName] then
                        CONST_IO[ScriptName].IsFullfilled = %s
                    end
                ]], k, tostring(CONST_IO[k].IsFullfilled));
            end
        end
    end);
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.IO.Local:Initialize()
    if not self.IsInstalled then
        Report.ObjectClicked = CreateReport("Event_ObjectClicked");
        Report.ObjectInteraction = CreateReport("Event_ObjectInteraction");
        Report.ObjectReset = CreateReport("Event_ObjectReset");
        Report.ObjectDelete = CreateReport("Event_ObjectDelete");

        Report.Internal_DebugEnableObject = CreateReport("Event_Internal_DebugEnableObject");
        Report.Internal_DebugDisableObject = CreateReport("Event_Internal_DebugDisableObject");
        Report.Internal_DebugInitObject = CreateReport("Event_Internal_DebugInitObject");

        Lib.IO.Shared:CreateTechnologies();

        self:OverrideGameFunctions();

        -- Garbage collection
        Lib.IO.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.IO.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.IO.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.ObjectReset then
        if CONST_IO[arg[1]] then
            CONST_IO[arg[1]].IsUsed = false;
        end
    elseif _ID == Report.ObjectInteraction then
        CONST_IO_LAST_OBJECT = GetID(arg[1]);
        CONST_IO_LAST_HERO = arg[2];
    end
end

function Lib.IO.Local:OverrideGameFunctions()
    g_CurrentDisplayedQuestID = 0;

    GUI_Interaction.InteractiveObjectClicked_Orig_Lib_IO = GUI_Interaction.InteractiveObjectClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Interaction.InteractiveObjectClicked = function()
        local i = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetCurrentWidgetID()));
        local EntityID = g_Interaction.ActiveObjectsOnScreen[i];
        local PlayerID = GUI.GetPlayerID();
        if not EntityID then
            return;
        end
        local ScriptName = Logic.GetEntityName(EntityID);
        if CONST_IO_SLAVE_TO_MASTER[ScriptName] then
            ScriptName = CONST_IO_SLAVE_TO_MASTER[ScriptName];
        end
        if CONST_IO[ScriptName] then
            if not CONST_IO[ScriptName].IsFullfilled then
                local Text = XGUIEng.GetStringTableText("UI_ButtonDisabled/PromoteKnight");
                if CONST_IO[ScriptName].ConditionInfo then
                    Text = ConvertPlaceholders(Localize(CONST_IO[ScriptName].ConditionInfo));
                end
                Message(Text);
                return;
            end
            if type(CONST_IO[ScriptName].Costs) == "table" and #CONST_IO[ScriptName].Costs ~= 0 then
                local StoreHouseID = Logic.GetStoreHouse(PlayerID);
                local CastleID     = Logic.GetHeadquarters(PlayerID);
                if StoreHouseID == nil or StoreHouseID == 0 or CastleID == nil or CastleID == 0 then
                    GUI.AddNote("DEBUG: Player needs special buildings when using activation costs!");
                    return;
                end
            end
        end
        GUI_Interaction.InteractiveObjectClicked_Orig_Lib_IO();

        -- Send additional click event
        -- This is supposed to be used in singleplayer only!
        if not Framework.IsNetworkGame() then
            local KnightIDs = {};
            Logic.GetKnights(PlayerID, KnightIDs);
            local KnightID = GetClosestToTarget(EntityID, KnightIDs);
            SendReportToGlobal(Report.ObjectClicked, ScriptName, KnightID, PlayerID);
            SendReport(Report.ObjectClicked, ScriptName, KnightID, PlayerID);
        end
    end

    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Interaction.InteractiveObjectUpdate = function()
        if g_Interaction.ActiveObjects == nil then
            return;
        end

        local PlayerID = GUI.GetPlayerID();
        for i = 1, #g_Interaction.ActiveObjects do
            local ObjectID = g_Interaction.ActiveObjects[i];
            local MasterObjectID = ObjectID;
            local ScriptName = Logic.GetEntityName(ObjectID);
            if CONST_IO_SLAVE_TO_MASTER[ScriptName] then
                MasterObjectID = GetID(CONST_IO_SLAVE_TO_MASTER[ScriptName]);
            end
            local X, Y = GUI.GetEntityInfoScreenPosition(MasterObjectID);
            local ScreenSizeX, ScreenSizeY = GUI.GetScreenSize();
            if X ~= 0 and Y ~= 0 and X > -50 and Y > -50 and X < (ScreenSizeX + 50) and Y < (ScreenSizeY + 50) then
                if not table.contains(g_Interaction.ActiveObjectsOnScreen, ObjectID) then
                    table.insert(g_Interaction.ActiveObjectsOnScreen, ObjectID);
                end
            else
                for i = 1, #g_Interaction.ActiveObjectsOnScreen do
                    if g_Interaction.ActiveObjectsOnScreen[i] == ObjectID then
                        table.remove(g_Interaction.ActiveObjectsOnScreen, i);
                    end
                end
            end
        end

        for i = 1, #g_Interaction.ActiveObjectsOnScreen do
            local Widget = "/InGame/Root/Normal/InteractiveObjects/" ..i;
            if XGUIEng.IsWidgetExisting(Widget) == 1 then
                local ObjectID       = g_Interaction.ActiveObjectsOnScreen[i];
                local MasterObjectID = ObjectID;
                local ScriptName     = Logic.GetEntityName(ObjectID);
                if CONST_IO_SLAVE_TO_MASTER[ScriptName] then
                    MasterObjectID = GetID(CONST_IO_SLAVE_TO_MASTER[ScriptName]);
                    ScriptName = Logic.GetEntityName(MasterObjectID);
                end
                local EntityType = Logic.GetEntityType(ObjectID);
                local EntityTypeName = Logic.GetEntityTypeName(EntityType);
                local X, Y = GUI.GetEntityInfoScreenPosition(MasterObjectID);
                local WidgetSize = {XGUIEng.GetWidgetScreenSize(Widget)};
                XGUIEng.SetWidgetScreenPosition(Widget, X - (WidgetSize[1]/2), Y - (WidgetSize[2]/2));
                local BaseCosts = {Logic.InteractiveObjectGetCosts(ObjectID)};
                local EffectiveCosts = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)};
                local IsAvailable = Logic.InteractiveObjectGetAvailability(ObjectID);
                local HasSpace = Logic.InteractiveObjectHasPlayerEnoughSpaceForRewards(ObjectID, PlayerID);
                local Disable = false;

                if BaseCosts[1] ~= nil and EffectiveCosts[1] == nil and IsAvailable == true then
                    Disable = true;
                end
                if HasSpace == false then
                    Disable = true
                end

                if Logic.GetTime() > 1 and g_GameExtraNo > 0 then
                    if Disable == false and string.find(EntityTypeName, "R_StoneMine") then
                        if Logic.TechnologyGetState(PlayerID, Technologies.R_RefillStoneMine) ~= TechnologyStates.Researched
                        or Logic.TechnologyGetState(PlayerID, Technologies.R_CallGeologist) ~= TechnologyStates.Researched then
                            Disable = true;
                        end
                    end
                    if Disable == false and string.find(EntityTypeName, "R_IronMine") then
                        if Logic.TechnologyGetState(PlayerID, Technologies.R_RefillIronMine) ~= TechnologyStates.Researched
                        or Logic.TechnologyGetState(PlayerID, Technologies.R_CallGeologist) ~= TechnologyStates.Researched then
                            Disable = true;
                        end
                    end
                    if Disable == false and (string.find(EntityTypeName, "B_Cistern") or string.find(EntityTypeName, "B_Well")) then
                        if Logic.TechnologyGetState(PlayerID, Technologies.R_RefillCistern) ~= TechnologyStates.Researched
                        or Logic.TechnologyGetState(PlayerID, Technologies.R_CallGeologist) ~= TechnologyStates.Researched then
                            Disable = true;
                        end
                    end
                    if Disable == false and string.find(EntityTypeName, "I_X_TradePostConstructionSite") then
                        if Logic.TechnologyGetState(PlayerID, Technologies.R_Tradepost) ~= TechnologyStates.Researched then
                            Disable = true;
                        end
                    end
                end

                if Disable == false then
                    if CONST_IO[ScriptName] and type(CONST_IO[ScriptName].Player) == "table" then
                        Disable = not self:IsAvailableForGuiPlayer(ScriptName);
                    elseif CONST_IO[ScriptName] and type(CONST_IO[ScriptName].Player) == "number" then
                        Disable = CONST_IO[ScriptName].Player ~= PlayerID;
                    end
                end

                if Disable == true then
                    XGUIEng.DisableButton(Widget, 1);
                else
                    XGUIEng.DisableButton(Widget, 0);
                end
                if GUI_Interaction.InteractiveObjectUpdateEx1 ~= nil then
                    GUI_Interaction.InteractiveObjectUpdateEx1(Widget, EntityType);
                end
                XGUIEng.ShowWidget(Widget, 1);
            end
        end

        for i = #g_Interaction.ActiveObjectsOnScreen + 1, 2 do
            local Widget = "/InGame/Root/Normal/InteractiveObjects/" .. i;
            XGUIEng.ShowWidget(Widget, 0);
        end

        for i = 1, #g_Interaction.ActiveObjectsOnScreen do
            local Widget     = "/InGame/Root/Normal/InteractiveObjects/" ..i;
            local ObjectID   = g_Interaction.ActiveObjectsOnScreen[i];
            local ScriptName = Logic.GetEntityName(ObjectID);
            if CONST_IO_SLAVE_TO_MASTER[ScriptName] then
                ScriptName = CONST_IO_SLAVE_TO_MASTER[ScriptName];
            end
            if CONST_IO[ScriptName] and CONST_IO[ScriptName].Texture then
                local FileBaseName;
                local a = (CONST_IO[ScriptName].Texture[1]) or 14;
                local b = (CONST_IO[ScriptName].Texture[2]) or 10;
                local c = (CONST_IO[ScriptName].Texture[3]) or 0;
                if type(c) == "string" then
                    FileBaseName = c;
                    c = 0;
                end
                ChangeIcon(Widget, {a, b, c}, nil, FileBaseName);
            end
        end
    end

    GUI_Interaction.InteractiveObjectMouseOver_Orig_Lib_IO = GUI_Interaction.InteractiveObjectMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Interaction.InteractiveObjectMouseOver = function()
        local PlayerID = GUI.GetPlayerID();
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local ButtonNumber = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetCurrentWidgetID()));
        local ObjectID = g_Interaction.ActiveObjectsOnScreen[ButtonNumber];
        local EntityType = Logic.GetEntityType(ObjectID);
        local EntityTypeName = Logic.GetEntityTypeName(EntityType);

        -- Call original for gold ruins
        if  tonumber(Logic.GetEntityName(ObjectID)) ~= nil
        and string.find(EntityTypeName, "^I_X_") then
            GUI_Interaction.InteractiveObjectMouseOver_Orig_Lib_IO();
            return;
        end

        -- addon special objects
        local IsGeologistTarget = false;
        local IsTradepost = false;
        if g_GameExtraNo > 0 then
            IsGeologistTarget = string.find(EntityTypeName, "^R_Stone") ~= nil or
                                string.find(EntityTypeName, "^R_Iron") ~= nil or
                                string.find(EntityTypeName, "^B_Cistern") ~= nil or
                                string.find(EntityTypeName, "^B_Well") ~= nil;
            IsTradepost = string.find(EntityTypeName, "^I_X_Trade") ~= nil;
        end

        -- Get default text keys
        local DisabledKey;
        local Key = "InteractiveObjectAvailable";
        if Logic.InteractiveObjectGetAvailability(ObjectID) == false then
            Key = "InteractiveObjectNotAvailable";
        elseif Logic.InteractiveObjectHasPlayerEnoughSpaceForRewards(ObjectID, PlayerID) == false then
            DisabledKey = "InteractiveObjectAvailableReward";
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            DisabledKey = "UpgradeOutpost";
            if g_GameExtraNo > 0 then
                if string.find(EntityTypeName, "R_StoneMine") then
                    if Logic.TechnologyGetState(PlayerID, Technologies.R_RefillStoneMine) ~= TechnologyStates.Researched
                    or Logic.TechnologyGetState(PlayerID, Technologies.R_CallGeologist) ~= TechnologyStates.Researched then
                        DisabledKey = GUI_Tooltip.GetDisabledKeyForTechnologyType(Technologies.R_RefillStoneMine) or DisabledKey;
                    end
                end
                if string.find(EntityTypeName, "R_IronMine") then
                    if Logic.TechnologyGetState(PlayerID, Technologies.R_RefillIronMine) ~= TechnologyStates.Researched
                    or Logic.TechnologyGetState(PlayerID, Technologies.R_CallGeologist) ~= TechnologyStates.Researched then
                        DisabledKey = GUI_Tooltip.GetDisabledKeyForTechnologyType(Technologies.R_RefillIronMine) or DisabledKey;
                    end
                end
                if (string.find(EntityTypeName, "B_Cistern") or string.find(EntityTypeName, "B_Well")) then
                    if Logic.TechnologyGetState(PlayerID, Technologies.R_RefillCistern) ~= TechnologyStates.Researched
                    or Logic.TechnologyGetState(PlayerID, Technologies.R_CallGeologist) ~= TechnologyStates.Researched then
                        DisabledKey = GUI_Tooltip.GetDisabledKeyForTechnologyType(Technologies.R_RefillCistern) or DisabledKey;
                    end
                end
                if string.find(EntityTypeName, "I_X_TradePostConstructionSite") then
                    if Logic.TechnologyGetState(PlayerID, Technologies.R_Tradepost) ~= TechnologyStates.Researched then
                        DisabledKey = GUI_Tooltip.GetDisabledKeyForTechnologyType(Technologies.R_Tradepost) or DisabledKey;
                    end
                end
            end
        end
        local Title = "UI_ObjectNames/" ..Key;
        local Text = "UI_ObjectDescription/" ..Key;
        local Disabled = (DisabledKey ~= nil and "UI_ButtonDisabled/" ..DisabledKey) or nil;
        if IsGeologistTarget then
            Title = "UI_ObjectNames/InteractiveObjectGeologist";
        end
        if IsTradepost then
            Title = "UI_ObjectNames/InteractiveObjectTradepost";
        end

        -- Get default costs
        local CheckSettlement = false;
        local Costs = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)};
        if Costs and Costs[1] and Costs[1] ~= Goods.G_Gold and Logic.GetGoodCategoryForGoodType(Costs[1]) ~= GoodCategories.GC_Resource then
            CheckSettlement = true;
        end

        -- Handle initalized lib objects
        local ScriptName = Logic.GetEntityName(ObjectID);
        if CONST_IO_SLAVE_TO_MASTER[ScriptName] then
            ScriptName = CONST_IO_SLAVE_TO_MASTER[ScriptName];
        end
        if CONST_IO[ScriptName] and CONST_IO[ScriptName].IsUsed ~= true then
            Key = "InteractiveObjectAvailable";
            if (CONST_IO[ScriptName] and type(CONST_IO[ScriptName].Player) == "table" and not self:IsAvailableForGuiPlayer(ScriptName))
            or (CONST_IO[ScriptName] and type(CONST_IO[ScriptName].Player) == "number" and CONST_IO[ScriptName].Player ~= PlayerID)
            or Logic.InteractiveObjectGetAvailability(ObjectID) == false then
                Key = "InteractiveObjectNotAvailable";
            end
            Title = ConvertPlaceholders(Localize(CONST_IO[ScriptName].Title or Title));
            if Title and Title:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
                Title = XGUIEng.GetStringTableText(Title);
            end
            Text = ConvertPlaceholders(Localize(CONST_IO[ScriptName].Text or Text));
            if Text and Text:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
                Text = XGUIEng.GetStringTableText(Text);
            end
            Disabled = CONST_IO[ScriptName].DisabledText or Disabled;
            if Disabled then
                Disabled = ConvertPlaceholders(Localize(Disabled));
                if Disabled and Disabled:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
                    Disabled = XGUIEng.GetStringTableText(Disabled);
                end
            end
            Costs = CONST_IO[ScriptName].Costs;
            if Costs and Costs[1] and Costs[1] ~= Goods.G_Gold and Logic.GetGoodCategoryForGoodType(Costs[1]) ~= GoodCategories.GC_Resource then
                CheckSettlement = true;
            end
        end
        SetTooltipCosts(Title, Text, Disabled, Costs, CheckSettlement);
    end

    GUI_Interaction.DisplayQuestObjective_Orig_Lib_IO = GUI_Interaction.DisplayQuestObjective
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

        if QuestType == Objective.Object then
            QuestObjectiveContainer = QuestObjectivesPath .. "/List";
            QuestTypeCaption = Wrapped_GetStringTableText(_QuestIndex, "UI_Texts/QuestInteraction");
            local ObjectList = {};

            assert(Quest ~= nil);
            for i = 1, Quest.Objectives[1].Data[0] do
                local ObjectType;
                if Logic.IsEntityDestroyed(Quest.Objectives[1].Data[i]) then
                    ObjectType = g_Interaction.SavedQuestEntityTypes[_QuestIndex][i];
                else
                    ObjectType = Logic.GetEntityType(GetID(Quest.Objectives[1].Data[i]));
                end
                local ObjectEntityName = Logic.GetEntityName(Quest.Objectives[1].Data[i]);
                local ObjectName = "";
                if ObjectType ~= nil and ObjectType ~= 0 then
                    local ObjectTypeName = Logic.GetEntityTypeName(ObjectType)
                    ObjectName = Wrapped_GetStringTableText(_QuestIndex, "Names/" .. ObjectTypeName)
                                 or GetStringText("Names/" .. ObjectTypeName);
                    if ObjectName == "" then
                        ObjectName = Wrapped_GetStringTableText(_QuestIndex, "UI_ObjectNames/" .. ObjectTypeName)
                                     or GetStringText("UI_ObjectNames/" .. ObjectTypeName);
                    end
                    if ObjectName == nil then
                        ObjectName = "Debug: ObjectName missing for " .. ObjectTypeName;
                    end
                end
                table.insert(ObjectList, Localize(ConvertPlaceholders(ObjectName)));
            end
            for i = 1, 4 do
                local String = ObjectList[i];
                if String == nil then
                    String = "";
                end
                XGUIEng.SetText(QuestObjectiveContainer .. "/Entry" .. i, "{center}" .. String);
            end

            SetIcon(QuestObjectiveContainer .. "/QuestTypeIcon",{14, 10});
            XGUIEng.SetText(QuestObjectiveContainer.."/Caption","{center}"..QuestTypeCaption);
            XGUIEng.ShowWidget(QuestObjectiveContainer, 1);
        else
            GUI_Interaction.DisplayQuestObjective_Orig_Lib_IO(_QuestIndex, _MessageKey);
        end
    end
end

function Lib.IO.Local:IsAvailableForGuiPlayer(_ScriptName)
    local PlayerID = GUI.GetPlayerID();
    if CONST_IO[_ScriptName] and type(CONST_IO[_ScriptName].Player) == "table" then
        for i= 1, 8 do
            if CONST_IO[_ScriptName].Player[i] and CONST_IO[_ScriptName].Player[i] == PlayerID then
                return true;
            end
        end
        return false;
    end
    return true;
end

-- -------------------------------------------------------------------------- --
-- Shared

function Lib.IO.Shared:CreateTechnologies()
    for i= 1, #self.TechnologyConfig do
        if g_GameExtraNo >= self.TechnologyConfig[i][4] then
            if not Technologies[self.TechnologyConfig[i][1]] then
                AddCustomTechnology(self.TechnologyConfig[i][1], self.TechnologyConfig[i][2], self.TechnologyConfig[i][3]);
                if not IsLocalScript() then
                    for j= 1, 8 do
                        Logic.TechnologySetState(j, Technologies[self.TechnologyConfig[i][1]], 3);
                    end
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.IO.Name);

