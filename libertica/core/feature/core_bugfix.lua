---@diagnostic disable: duplicate-set-field

Lib.Core = Lib.Core or {};
Lib.Core.Bugfix = {
    ForceDeselectEntities = {
        ["U_Entertainer_NA_FireEater"] = true,
        ["U_Entertainer_NA_PerformingFireeater"] = true,
        ["U_Entertainer_NA_PerformingStiltWalker"] = true,
        ["U_Entertainer_NA_StiltWalker"] = true,
        ["U_Entertainer_NE_PerformingStrongestMan_Barrel"] = true,
        ["U_Entertainer_NE_PerformingStrongestMan_Stone"] = true,
        ["U_Entertainer_NE_StrongestMan_Barrel"] = true,
        ["U_Entertainer_NE_StrongestMan_Stone"] = true,
        ["U_FireEater"] = true,
    },
};

Lib.Require("comfort/IsLocalScript");
Lib.Require("comfort/GetDistance");
Lib.Require("core/feature/Core_Text");
Lib.Register("core/feature/Core_Bugfix");

function Lib.Core.Bugfix:Initialize()
    if not IsLocalScript() then
        self:FixResourceSlotsInStorehouses();
        self:FixMiddleEuropeNpcBarracks();
        self:FixMerchantArrivedCheckpoints();
        self:FixDestroyAllPlayerUnits();
        self:FixBanditCampFireplace();
    end
    if IsLocalScript() then
        self:OverrideSelection();
        self:FixInteractiveObjectClicked();
        self:FixBigCathedralName();
        self:FixClimateZoneForHouseMenu();
        self:FixAbilityInfoWhenHomeless();
    end
end

function Lib.Core.Bugfix:OnSaveGameLoaded()
end

function Lib.Core.Bugfix:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --
-- Luxury for NPCs

function Lib.Core.Bugfix:FixResourceSlotsInStorehouses()
    for i= 1, 8 do
        local StorehouseID = Logic.GetStoreHouse(i);
        if StorehouseID ~= 0 then
            Logic.AddGoodToStock(StorehouseID, Goods.G_Salt, 0, true, true);
            Logic.AddGoodToStock(StorehouseID, Goods.G_Dye, 0, true, true);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Respawning for ME barracks

function Lib.Core.Bugfix:FixMiddleEuropeNpcBarracks()
    GameCallback_OnBuildingConstructionComplete_Orig_Core_Bugfix = GameCallback_OnBuildingConstructionComplete;
    GameCallback_OnBuildingConstructionComplete = function(_PlayerID, _EntityID)
        GameCallback_OnBuildingConstructionComplete_Orig_Core_Bugfix(_PlayerID, _EntityID);
        local EntityType = Logic.GetEntityType(_EntityID);
        if EntityType == Entities.B_NPC_Barracks_ME then
            Logic.RespawnResourceSetMaxSpawn(_EntityID, 0.01);
            Logic.RespawnResourceSetMinSpawn(_EntityID, 0.01);
        end
    end

    for k, v in pairs(Logic.GetEntitiesOfType(Entities.B_NPC_Barracks_ME)) do
        Logic.RespawnResourceSetMaxSpawn(v, 0.01);
        Logic.RespawnResourceSetMinSpawn(v, 0.01);
    end
end

-- -------------------------------------------------------------------------- --
-- Delivery checkpoint

function Lib.Core.Bugfix:FixMerchantArrivedCheckpoints()
    QuestTemplate.IsMerchantArrived = function(this, objective)
        if objective.Data[3] ~= nil then
            if objective.Data[3] == 1 then
                local newID = objective.Data[5].ID;
                if newID ~= nil then
                    objective.Data[3] = newID;
                    DeleteQuestMerchantWithID(newID);
                    if MapCallback_DeliverCartSpawned then
                        MapCallback_DeliverCartSpawned(this, newID, objective.Data[1]);
                    end
                end
            elseif Logic.IsEntityDestroyed(objective.Data[3]) then
                DeleteQuestMerchantWithID(objective.Data[3]);
                objective.Data[3] = nil;
                objective.Data[5].ID = nil;
            else
                local isNearEntrance = function(_ID)
                    if _ID == 0 then
                        return false;
                    end
                    local x, y = Logic.GetBuildingApproachPosition(_ID)
                    return GetDistance(objective.Data[3], {X = x, Y = y}) <= 1000;
                end

                local playerID = objective.Data[6] or this.SendingPlayer;
                return isNearEntrance(Logic.GetHeadquarters(playerID)) or
                       isNearEntrance(Logic.GetMarketplace(playerID)) or
                       isNearEntrance(Logic.GetStoreHouse(playerID));
            end
        end
        return false;
    end
end

-- -------------------------------------------------------------------------- --
-- IO costs

function Lib.Core.Bugfix:FixInteractiveObjectClicked()
    GUI_Interaction.InteractiveObjectClicked = function()
        local widgetID = XGUIEng.GetCurrentWidgetID();
        local widgetName = XGUIEng.GetWidgetNameByID(widgetID);
        local buttonID = tonumber(widgetName);
        local objectID = g_Interaction.ActiveObjectsOnScreen[buttonID];

        if objectID == nil then
            return;
        end
        if not Logic.InteractiveObjectGetAvailability(objectID) then
            return;
        end

        local playerID = GUI.GetPlayerID();
        local costs = {Logic.InteractiveObjectGetEffectiveCosts(objectID, playerID)};
        local canNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_Resources");

        local isAffordable = function(costType, amount)
            if  Logic.GetGoodCategoryForGoodType(costType) ~= GoodCategories.GC_Resource
            and Logic.GetGoodCategoryForGoodType(costType) ~= GoodCategories.GC_Gold then
                error("Only resources can be used as costs for objects!");
                return false;
            end
            if costType == Goods.G_Gold then
                canNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_G_Gold");
            end
            return GetPlayerGoodsInSettlement(costType, playerID, false) >= amount;
        end

        local affordable = true;
        if costs[1] and costs[2] then
            affordable = isAffordable(costs[1], costs[2]);
        end
        if affordable and costs[3] and costs[4] then
            affordable = isAffordable(costs[3], costs[4]);
        end
        if not affordable then
            Message(canNotBuyString);
            return;
        end

        if not GUI_Interaction.InteractionClickOverride 
        or not GUI_Interaction.InteractionClickOverride(objectID) then
            Sound.FXPlay2DSound("ui\\menu_click");
        end

        if not GUI_Interaction.InteractionSpeechFeedbackOverride 
        or not GUI_Interaction.InteractionSpeechFeedbackOverride(objectID) then
            GUI_FeedbackSpeech.Add(
                "SpeechOnly_CartsSent", 
                g_FeedbackSpeech.Categories.CartsUnderway,
                nil,
                nil
            );
        end

        if not Mission_Callback_OverrideObjectInteraction
        or not Mission_Callback_OverrideObjectInteraction(objectID, playerID, costs) then
            GUI.ExecuteObjectInteraction(objectID, playerID);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Destroy all units

function Lib.Core.Bugfix:FixDestroyAllPlayerUnits()
    QuestTemplate.IsObjectiveCompleted_Orig_Core_Bugfix = QuestTemplate.IsObjectiveCompleted;
    QuestTemplate.IsObjectiveCompleted = function(this, objective)
        if objective.Completed ~= nil then
            return objective.Completed;
        end

        local objectiveType = objective.Type;
        local data = objective.Data;

        -- Solves the problem that special entities and construction sites
        -- let the script believe that the player is still alive.
        if objectiveType == Objective.DestroyAllPlayerUnits then
            local playerEntities = GetPlayerEntities(data, 0);
            local illegalEntities = {};
            local indestructableEntities = {
                Entities.XD_ScriptEntity,
                Entities.S_AIHomePosition,
                Entities.S_AIAreaDefinition
            };

            for i = #playerEntities, 1, -1 do
                local entityID = playerEntities[i];
                local entityType = Logic.GetEntityType(entityID);

                local notReady = Logic.IsConstructionComplete(entityID) == 0;
                local notIsBuilding = Logic.IsEntityInCategory(entityID, EntityCategories.AttackableBuilding) == 0;
                local notIsWall = Logic.IsEntityInCategory(entityID, EntityCategories.Wall) == 0;
                if  (notIsBuilding or notIsWall) and notReady then
                    table.insert(illegalEntities, entityID);
                end

                if table.contains(indestructableEntities, entityType) then
                    table.insert(illegalEntities, entityID);
                end
            end

            if #playerEntities == 0 or #playerEntities == #illegalEntities then
                objective.Completed = true;
            end
        elseif objectiveType == Objective.Distance then
            objective.Completed = Lib.Core.Quest:IsQuestPositionReached(this, objective);
        else
            return this:IsObjectiveCompleted_Orig_Core_Bugfix(objective);
        end
        return objective.Completed;
    end
end

-- -------------------------------------------------------------------------- --
-- Cathedral name

function Lib.Core.Bugfix:FixBigCathedralName()
    AddStringText(
        "Names/B_Cathedral_Big",
        {de = "Kathedrale", en = "Cathedral", fr = "Cathédrale"}
    );
end

-- -------------------------------------------------------------------------- --
-- House menu

function Lib.Core.Bugfix:FixClimateZoneForHouseMenu()
    HouseMenuGetNextBuildingID = function(WidgetName)
        local playerID = GUI.GetPlayerID();
        local buildingsList = {Logic.GetBuildingsByPlayer(playerID)};

        WidgetName = GetClimateEntityName(WidgetName);
        local TrimedWidgetName = string.gsub(WidgetName, "_%w%w?%w?$", "");
        if HouseMenu.Widget.CurrentBuilding ~= WidgetName then
            HouseMenu.Widget.CurrentBuilding = WidgetName;
            HouseMenu.Widget.CurrentBuildingNumber = 0;
        end

        local foundNumber = 0;
        local higherBuildingFound = false;
        for i = 1, #buildingsList do
            local entityType = Logic.GetEntityType(buildingsList[i]);
            local entityName = Logic.GetEntityTypeName(entityType);
            local trimedEntityName = string.gsub(entityName, "_%w%w?%w?$", "");
            if trimedEntityName == TrimedWidgetName then
                foundNumber = i;
                if foundNumber > HouseMenu.Widget.CurrentBuildingNumber then
                    HouseMenu.Widget.CurrentBuildingNumber = foundNumber;
                    higherBuildingFound = true;
                    break;
                end
            end
        end

        if foundNumber == 0 then
            return nil;
        end
        if not higherBuildingFound then
            for i = 1, #buildingsList do
                local entityType = Logic.GetEntityType(buildingsList[i]);
                local entityName = Logic.GetEntityTypeName(entityType);
                if entityName == WidgetName then
                    HouseMenu.Widget.CurrentBuildingNumber = i;
                    break;
                end
            end
        end
        return buildingsList[HouseMenu.Widget.CurrentBuildingNumber];
    end

    HouseMenuSetIconsPart = function(_Part, _HighlightBool)
        local playerID = GUI.GetPlayerID();
        local houseMenuButtons = {XGUIEng.ListSubWidgets(_Part)};
        local buildings = {Logic.GetBuildingsByPlayer(playerID)};

        for i = 1, #houseMenuButtons do
            local widgetName = XGUIEng.GetWidgetNameByID(houseMenuButtons[i]);
            local trimedWidgetName = string.gsub(widgetName, "_%w%w?%w?$", "");
            local button = _Part .. "/" .. widgetName .. "/Button";
            SetIcon(button, g_TexturePositions.Entities[Entities[widgetName]]);

            local count = 0;
            for j = 1, #buildings do
                local entityType = Logic.GetEntityType(buildings[j]);
                local entityName = Logic.GetEntityTypeName(entityType);
                local trimedEntityName = string.gsub(entityName, "_%w%w?%w?$", "");
                if trimedWidgetName == trimedEntityName then
                    count = count + 1;
                end
            end

            XGUIEng.DisableButton(button, (count == 0 and 1) or 0);
            XGUIEng.SetText(_Part .. "/" .. widgetName .. "/Amount", "{center}" .. count);
            UpdateStopOverlay(_Part .. "/" .. widgetName .. "/Stop", widgetName, count);

            if widgetName == HouseMenu.Widget.CurrentBuilding then
                UpdateStopOverlay(
                    HouseMenu.Widget.CurrentStop,
                    HouseMenu.Widget.CurrentBuilding,
                    count
                );
            end
        end

        HouseMenu.Counter = HouseMenu.Counter + 1;
        if _HighlightBool or HouseMenu.Counter % 20 == 0 then
            for j = 1, #houseMenuButtons do
                local building = HouseMenu.Widget.CurrentBuilding;
                local highligtedName = XGUIEng.GetWidgetNameByID(houseMenuButtons[j]);
                local button = _Part .. "/" .. highligtedName .. "/Button";
                highligtedName = GetClimateEntityName(highligtedName);
                local highlightFlag = (highligtedName == building and 1) or 0;
                XGUIEng.HighLightButton(button, highlightFlag);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Ability info

function Lib.Core.Bugfix:FixAbilityInfoWhenHomeless()
    StartKnightVoiceForActionSpecialAbility = function(_KnightType, _NoPriority)
        local playerID = GUI.GetPlayerID();
        local storehouseID = Logic.GetStoreHouse(playerID);
        local knightType = Logic.GetEntityType(Logic.GetKnightID(playerID));
        if  _KnightType == knightType
        and storehouseID ~= 0
        and ActionAbilityIsExplained == nil then
            LocalScriptCallback_StartVoiceMessage(
                playerID,
                "Hint_SpecialAbilityAction",
                false,
                playerID,
                _NoPriority
            );
            ActionAbilityIsExplained = true;
        end
    end

    StartKnightVoiceForPermanentSpecialAbility = function(_KnightType)
        local playerID = GUI.GetPlayerID();
        local storehouseID = Logic.GetStoreHouse(playerID);
        local knightType = Logic.GetEntityType(Logic.GetKnightID(playerID));
        if  _KnightType == knightType
        and storehouseID ~= 0
        and PermanentAbilityIsExplained == nil then
            LocalScriptCallback_StartVoiceMessage(
                playerID,
                "Hint_SpecialAbilityPermanetly",
                false,
                playerID
            );
            PermanentAbilityIsExplained = true;
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Bandit fireplace

function Lib.Core.Bugfix:FixBanditCampFireplace()
    g_Outlaws.ReplaceCampType = {};
    g_Outlaws.ReplaceCampType[Entities.D_X_Fireplace01] = Entities.D_X_Fireplace01_Expired;
    g_Outlaws.ReplaceCampType[Entities.D_X_Fireplace02] = Entities.D_X_Fireplace02_Expired;

    ActivateFireplaceforBanditPack = function(_CaMarketplaceID)
        local playerID = Logic.EntityGetPlayer(_CaMarketplaceID);
        if g_Outlaws.Players[playerID][_CaMarketplaceID].CampFire == nil then
            local ApX, ApY = Logic.GetBuildingApproachPosition(_CaMarketplaceID);
            local PosX, PosY = Logic.GetEntityPosition(_CaMarketplaceID);
            local x = (ApX - PosX) * 1.3 + ApX;
            local y = (ApY - PosY) * 1.3 + ApY;

            local FireplaceType = Entities.D_X_Fireplace01;
            if Logic.IsEntityInCategory(_CaMarketplaceID, EntityCategories.Storehouse) == 1 then
                FireplaceType = Entities.D_X_Fireplace02;
            end

            g_Outlaws.Players[playerID][_CaMarketplaceID].CampFireType = FireplaceType;
            local OldID = g_Outlaws.Players[playerID][_CaMarketplaceID].ExtinguishedFire;
            Logic.DestroyEntity(OldID);
            local NewID = Logic.CreateEntityOnUnblockedLand(FireplaceType, x, y, 0, 0);
            g_Outlaws.Players[playerID][_CaMarketplaceID].CampFire = NewID
            g_Outlaws.Players[playerID][_CaMarketplaceID].CampFirePos = {X= x, Y= y};
            return true;
        end
        return false;
    end

    DisableFireplaceforBanditPack = function(_CaMarketplaceID)
        local playerID = Logic.EntityGetPlayer(_CaMarketplaceID);
        if g_Outlaws.Players[playerID][_CaMarketplaceID].CampFire ~= nil then
            local x = g_Outlaws.Players[playerID][_CaMarketplaceID].CampFirePos.X;
            local y = g_Outlaws.Players[playerID][_CaMarketplaceID].CampFirePos.Y;

            local OldID = g_Outlaws.Players[playerID][_CaMarketplaceID].CampFire;
            Logic.DestroyEntity(OldID);

            local CampfireType = g_Outlaws.Players[playerID][_CaMarketplaceID].CampFireType;
            local FireplaceType = g_Outlaws.ReplaceCampType[CampfireType];
            local NewID = Logic.CreateEntityOnUnblockedLand(FireplaceType, x, y, 0, 0);
            g_Outlaws.Players[playerID][_CaMarketplaceID].ExtinguishedFire = NewID;
            g_Outlaws.Players[playerID][_CaMarketplaceID].CampFire = nil;
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Force deselect

function Lib.Core.Bugfix:OnSelectionCanged(_Source)
    local Selected = {GUI.GetSelectedEntities()};
    for i= #Selected, 1, -1 do
        local TypeName = self:GetSelectedTypeName(Selected[i]);
        if TypeName and self.ForceDeselectEntities[TypeName] then
            GUI.DeselectEntity(Selected[i]);
        end
    end
end

function Lib.Core.Bugfix:GetSelectedTypeName(_ID)
    local ID = _ID;
    local TypeName;
    if Logic.IsLeader(_ID) == 1 then
        local _, FirstID = Logic.GetSoldiersAttachedToLeader(ID);
        ID = FirstID or 0;
    end
    if ID > 0 then
        local Type = Logic.GetEntityType(ID);
        TypeName = Logic.GetEntityTypeName(Type);
    end
    return TypeName;
end

function Lib.Core.Bugfix:OverrideSelection()
    self.Orig_GameCallback_GUI_SelectionChanged = GameCallback_GUI_SelectionChanged;
    GameCallback_GUI_SelectionChanged = function(_Source)
        Lib.Core.Bugfix.Orig_GameCallback_GUI_SelectionChanged(_Source);
        Lib.Core.Bugfix:OnSelectionCanged(_Source);
    end
end

