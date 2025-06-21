Lib.MilitiaSystem = Lib.MilitiaSystem or {};
Lib.MilitiaSystem.Name = "MilitiaSystem";
Lib.MilitiaSystem.Global = {
    ConscriptMapping = {},
};
Lib.MilitiaSystem.Local  = {
    Buttons = {},
    ConscriptCount = {},
    MilitiaMapping = {},
};
Lib.MilitiaSystem.Shared = {
    ConscriptConfig = "Work",
    MilitiaAllocation = {},
    TypeSkills = {},
};

Lib.Require("comfort/AddWare");
Lib.Require("comfort/GetBattalionSizeBySoldierType");
Lib.Require("core/Core");
Lib.Require("module/fix/Damage");
Lib.Require("module/faker/Permadeath");
Lib.Require("module/faker/Technology");
Lib.Require("module/ui/UIBuilding");
Lib.Require("module/city/MilitiaSystem_API");
Lib.Require("module/city/MilitiaSystem_Config");
Lib.Require("module/city/MilitiaSystem_Text");
Lib.Register("module/city/MilitiaSystem");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.MilitiaSystem.Global:Initialize()
    if not self.IsInstalled then
        Report.BuyMilitia = CreateReport("Event_BuyMilitia");

        Lib.MilitiaSystem.Shared:CreateTechnologies();

        self:InitDamageCalculationCallback();
        self:InitUnitDestroyedCallback();

        for PlayerID = 1, 8 do
            self.ConscriptMapping[PlayerID] = {};
            Lib.MilitiaSystem.Shared:SetDefaultUnitTypeAllocation(PlayerID);
        end

        -- Garbage collection
        Lib.MilitiaSystem.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.MilitiaSystem.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.MilitiaSystem.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.BuyMilitia then
        self:BuyMilitia(arg[1], arg[2]);
    end
end

-- -------------------------------------------------------------------------- --

function Lib.MilitiaSystem.Global:BuyMilitia(_PlayerID, _Type)
    -- Check space
    local MilitaryUsage = Logic.GetCurrentSoldierCount(_PlayerID);
    local MilitaryLimit = Logic.GetCurrentSoldierLimit(_PlayerID);
    if GetBattalionSizeBySoldierType(_Type) >= MilitaryLimit - MilitaryUsage then
        return false;
    end
    -- Check costs
    local UnitTypeName = Logic.GetEntityTypeName(_Type);
    local Costs = Lib.MilitiaSystem.Config.UnitCosts[UnitTypeName];
    if (Costs[1] and GetPlayerGoodsInSettlement(Costs[1], _PlayerID, true) < Costs[2])
    or (Costs[3] and GetPlayerGoodsInSettlement(Costs[3], _PlayerID, true) < Costs[4]) then
        return false;
    end
    -- Check castle
    local CastleID = Logic.GetHeadquarters(_PlayerID);
    if CastleID == 0 then
        return false;
    end
    -- Check constrips
    local Conscripts = Lib.MilitiaSystem.Shared:GetConscripts(_PlayerID);
    if #Conscripts < GetBattalionSizeBySoldierType(_Type) then
        return;
    end
    -- Create unit
    local x1, y1 = Logic.GetBuildingApproachPosition(CastleID);
    local x2, y2, _ = Logic.EntityGetPos(CastleID);
    local Orientation = Logic.GetEntityOrientation(CastleID);
    local UnitID = Logic.CreateBattalionOnUnblockedLand(_Type, x2, y2, Orientation - 90, _PlayerID);
    local Soldiers = {Logic.GetSoldiersAttachedToLeader(UnitID)};
    if Costs[1] then
        AddWare(Costs[1], (-1) * Costs[2], _PlayerID);
    end
    if Costs[3] then
        AddWare(Costs[3], (-1) * Costs[4], _PlayerID);
    end
    Logic.MoveSettler(UnitID, x1, y1);
    -- Suspend settlers
    for i= 1, GetBattalionSizeBySoldierType(_Type) do
        local ID = table.remove(Conscripts, math.random(1, #Conscripts));
        ExecuteLocal("Lib.MilitiaSystem.Local.MilitiaMapping[%d][%d] = true", _PlayerID, UnitID);
        self.ConscriptMapping[_PlayerID][Soldiers[i+1]] = ID;
        SetEntityScaling(Soldiers[i+1], 1.05);
        SuspendSettler(ID);
    end
end

function Lib.MilitiaSystem.Global:SetRequiredRank(_Title, _Tech)
    ExecuteLocal(string.format([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], 1, %d)
        CreateTechnologyKnightTitleTable()
    ]], _Title, _Tech));
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], 1, _Tech);
    CreateTechnologyKnightTitleTable();
    for playerID = 1, 8 do
        Logic.TechnologySetState(playerID, _Tech, 0);
    end
end

function Lib.MilitiaSystem.Global:GetUnitTypeSkill(_Entity)
    local ID = GetID(_Entity)
    local Type = Logic.GetEntityType(ID);
    local TypeName = Logic.GetEntityTypeName(Type);
    return Lib.MilitiaSystem.Shared.TypeSkills[TypeName];
end

function Lib.MilitiaSystem.Global:InitDamageCalculationCallback()
    GameCallback_Lib_CalculateBattleDamage = function(_AttackerID, _AttackerPlayer, _TargetID, _TargetPlayer, _Damage)
        return Lib.MilitiaSystem.Global:CalculateBattleDamage(_AttackerID, _AttackerPlayer, _TargetID, _TargetPlayer, _Damage);
    end
end

function Lib.MilitiaSystem.Global:CalculateBattleDamage(_AttackerID, _AttackerPlayer, _TargetID, _TargetPlayer, _Damage)
    local Damage = _Damage;
    if self.ConscriptMapping[_AttackerPlayer] then
        local AttackerSkill = self:GetUnitTypeSkill(_AttackerID);
        if AttackerSkill and self.ConscriptMapping[_AttackerPlayer][_AttackerID] then
            Damage = AttackerSkill:InvokeSkill(_AttackerID, _AttackerID, _TargetID, _Damage);
        end
    end
    if self.ConscriptMapping[_TargetPlayer] then
        local TargetSkill = self:GetUnitTypeSkill(_TargetID);
        if TargetSkill and self.ConscriptMapping[_TargetPlayer][_TargetID] then
            Damage = TargetSkill:InvokeSkill(_TargetID, _AttackerID, _TargetID, _Damage);
        end
    end
    return Damage;
end

-- -------------------------------------------------------------------------- --

function Lib.MilitiaSystem.Global:InitUnitDestroyedCallback()
    RequestJobByEventType(
        Events.LOGIC_EVENT_ENTITY_DESTROYED,
        function()
            local EntityID = Event.GetEntityID();
            local PlayerID = Logic.EntityGetPlayer(EntityID);
            local Health = Logic.GetEntityHealth(EntityID);
            local UnitID = Logic.SoldierGetLeaderEntityID(EntityID);
            if self.ConscriptMapping[PlayerID] then
                if self.ConscriptMapping[PlayerID][EntityID] then
                    local ID = self.ConscriptMapping[PlayerID][EntityID];
                    if Health == 0 then
                        DestroyEntity(ID);
                    else
                        ResumeSettler(ID);
                    end

                    ExecuteLocal("Lib.MilitiaSystem.Local.MilitiaMapping[%d][%d] = nil", PlayerID, UnitID);
                    self.ConscriptMapping[PlayerID][EntityID] = nil;
                end
            end
        end
    );
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.MilitiaSystem.Local:Initialize()
    if not self.IsInstalled then
        Report.BuyMilitia = CreateReport("Event_BuyMilitia");

        Lib.MilitiaSystem.Shared:CreateTechnologies();

        for PlayerID = 1, 8 do
            self.ConscriptCount[PlayerID] = 0;
            self.MilitiaMapping[PlayerID] = {};
            Lib.MilitiaSystem.Shared:SetDefaultUnitTypeAllocation(PlayerID);
        end

        self:InitConscriptUpdate();
        self:InitOverwriteMultiselection();

        for k, v in pairs(Lib.MilitiaSystem.Text.Unit) do
            AddStringText("UI_ObjectNames/" ..k, v.Title);
            AddStringText("UI_ObjectDescription/Abilities_" ..k, v.Text);
        end

        -- Garbage collection
        Lib.MilitiaSystem.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.MilitiaSystem.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.MilitiaSystem.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

function Lib.MilitiaSystem.Local:ActivateMilitia()
    self:AddMilitiaButtons(Entities.B_Castle_ME);
    self:AddMilitiaButtons(Entities.B_Castle_NA);
    self:AddMilitiaButtons(Entities.B_Castle_NE);
    self:AddMilitiaButtons(Entities.B_Castle_SE);
    if Entities.B_Castle_AS ~= nil then
        self:AddMilitiaButtons(Entities.B_Castle_AS);
    end
end

function Lib.MilitiaSystem.Local:DeactivateMilitia()
    self:RemoveMilitiaButtons(Entities.B_Castle_ME);
    self:RemoveMilitiaButtons(Entities.B_Castle_NA);
    self:RemoveMilitiaButtons(Entities.B_Castle_NE);
    self:RemoveMilitiaButtons(Entities.B_Castle_SE);
    if Entities.B_Castle_AS ~= nil then
        self:RemoveMilitiaButtons(Entities.B_Castle_AS);
    end
end

function Lib.MilitiaSystem.Local:AddMilitiaButtons(_Type)
    self.Buttons[_Type] = self.Buttons[_Type] or {};

    -- Button 1
    if self.Buttons[_Type].Melee == nil then
        self.Buttons[_Type].Melee = AddBuildingButtonByEntity(
            _Type,
            function(_WidgetID, _EntityID) Lib.MilitiaSystem.Local:CastleMilitiaButtonAction(1, _WidgetID, _EntityID) end,
            function(_WidgetID, _EntityID) Lib.MilitiaSystem.Local:CastleMilitiaButtonTooltip(1, _WidgetID, _EntityID) end,
            function(_WidgetID, _EntityID) Lib.MilitiaSystem.Local:CastleMilitiaButtonUpdate(1, _WidgetID, _EntityID) end
        );
    end
    -- Button 2
    if self.Buttons[_Type].Ranged == nil then
        self.Buttons[_Type].Ranged = AddBuildingButtonByEntity(
            _Type,
            function(_WidgetID, _EntityID) Lib.MilitiaSystem.Local:CastleMilitiaButtonAction(2, _WidgetID, _EntityID) end,
            function(_WidgetID, _EntityID) Lib.MilitiaSystem.Local:CastleMilitiaButtonTooltip(2, _WidgetID, _EntityID) end,
            function(_WidgetID, _EntityID) Lib.MilitiaSystem.Local:CastleMilitiaButtonUpdate(2, _WidgetID, _EntityID) end
        );
    end
end

function Lib.MilitiaSystem.Local:RemoveMilitiaButtons(_Type)
    if self.Buttons[_Type] then
        DropBuildingButtonFromType(_Type, self.Buttons[_Type].Melee);
        self.Buttons[_Type].Melee = nil;
        DropBuildingButtonFromType(_Type, self.Buttons[_Type].Ranged);
        self.Buttons[_Type].Ranged = nil;
    end
end

function Lib.MilitiaSystem.Local:CastleMilitiaButtonAction(_Index, _WidgetID, _EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local UnitType = Lib.MilitiaSystem.Shared.MilitiaAllocation[PlayerID][_Index];
    local UnitTypeName = Logic.GetEntityTypeName(UnitType);
    local Costs = Lib.MilitiaSystem.Config.UnitCosts[UnitTypeName];
    local MilitaryLimit = Logic.GetCurrentSoldierLimit(PlayerID);
    local MilitaryUsage = Logic.GetCurrentSoldierCount(PlayerID);
    if GetBattalionSizeBySoldierType(UnitType) >= MilitaryLimit - MilitaryUsage then
        AddMessage("Feedback_TextLines/TextLine_SoldierLimitReached");
        return;
    end
    if (Costs[1] and GetPlayerGoodsInSettlement(Costs[1], PlayerID, true) < Costs[2])
    or (Costs[3] and GetPlayerGoodsInSettlement(Costs[3], PlayerID, true) < Costs[4]) then
        AddMessage("Feedback_TextLines/TextLine_NotEnough_Goods");
        return;
    end
    if self.ConscriptCount[PlayerID] < GetBattalionSizeBySoldierType(UnitType) then
        AddMessage(Lib.MilitiaSystem.Text.Message.NoConscripts);
        return;
    end
    SendReportToGlobal(Report.BuyMilitia, PlayerID, UnitType);
    Sound.FXPlay2DSound("ui\\menu_click");
end

function Lib.MilitiaSystem.Local:CastleMilitiaButtonTooltip(_Index, _WidgetID, _EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local UnitType = Lib.MilitiaSystem.Shared.MilitiaAllocation[PlayerID][_Index];
    local UnitTypeName = Logic.GetEntityTypeName(UnitType);
    local Costs = Lib.MilitiaSystem.Config.UnitCosts[UnitTypeName];
    local Data = Lib.MilitiaSystem.Config.UnitData[UnitTypeName];
    local Title = self:GetUnitScreenName(UnitType);
    local Text = self:GetUnitScreenDescription(UnitType);
    local DisabledKey = GUI_Tooltip.GetDisabledKeyForTechnologyType(Technologies[Data[2]]);
    local UnitSize = GetBattalionSizeBySoldierType(UnitType);
    local Conscripts = self.ConscriptCount[PlayerID];
    local AmountString = " (" ..Conscripts.. "/" ..UnitSize.. ")";
    if DisabledKey and XGUIEng.IsButtonDisabled(_WidgetID) == 1 then
        local DisabledText = GetStringText("UI_ButtonDisabled/" ..DisabledKey);
        Text = Text.. "{cr}{@color:210,20,30,255}" ..DisabledText;
    end
    SetTooltipCosts(Title .. AmountString, Text, nil, Costs, true);
end

function Lib.MilitiaSystem.Local:CastleMilitiaButtonUpdate(_Index, _WidgetID, _EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local UnitType = Lib.MilitiaSystem.Shared.MilitiaAllocation[PlayerID][_Index];
    local UnitTypeName = Logic.GetEntityTypeName(UnitType);
    local Data = Lib.MilitiaSystem.Config.UnitData[UnitTypeName];
    ChangeIcon(_WidgetID, Data[3]);
    if Lib.MilitiaSystem.Shared.TypeSkills[UnitTypeName] then
        XGUIEng.SetMaterialColor(_WidgetID, 7, 55, 255, 0, 255);
    else
        XGUIEng.SetMaterialColor(_WidgetID, 7, 255, 255, 255, 255);
    end
    if Logic.TechnologyGetState(PlayerID, Technologies[Data[1]]) ~= TechnologyStates.Researched
    or Logic.TechnologyGetState(PlayerID, Technologies[Data[2]]) ~= TechnologyStates.Researched then
        XGUIEng.DisableButton(_WidgetID, 1);
    else
        XGUIEng.DisableButton(_WidgetID, 0);
    end
end

function Lib.MilitiaSystem.Local:GetUnitTypeSkill(_Entity)
    local ID = GetID(_Entity)
    local Type = Logic.GetEntityType(ID);
    local TypeName = Logic.GetEntityTypeName(Type);
    return Lib.MilitiaSystem.Shared.TypeSkills[TypeName];
end

function Lib.MilitiaSystem.Local:GetUnitScreenName(_Type)
    local TypeName = Logic.GetEntityTypeName(_Type);
    return GetStringText("UI_ObjectNames/" ..TypeName);
end

function Lib.MilitiaSystem.Local:GetUnitScreenDescription(_Type)
    local TypeName = Logic.GetEntityTypeName(_Type);
    local Text = GetStringText("UI_ObjectDescription/Abilities_" ..TypeName);
    if Lib.MilitiaSystem.Shared.TypeSkills[TypeName] then
        local SkillName = Lib.MilitiaSystem.Shared.TypeSkills[TypeName].Name;
        local SkillText = Lib.MilitiaSystem.Text.Skills[SkillName];
        Text = Text.. "{cr}" .. Localize(SkillText);
    end
    return Text;
end

function Lib.MilitiaSystem.Local:InitOverwriteMultiselection()
    self.Orig_GUI_MultiSelection_IconMouseOver = GUI_MultiSelection.IconMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_MultiSelection.IconMouseOver = function()
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local CurrentMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID);
        local CurrentMotherName = XGUIEng.GetWidgetNameByID(CurrentMotherID);
        local Index = tonumber(CurrentMotherName);
        local EntityID = g_MultiSelection.EntityList[Index];
        local PlayerID = Logic.EntityGetPlayer(EntityID);
        if Lib.MilitiaSystem.Local.MilitiaMapping[PlayerID] then
            if Lib.MilitiaSystem.Local.MilitiaMapping[PlayerID][EntityID] then
                local EntityType = Logic.LeaderGetSoldiersType(EntityID);
                local Title = self:GetUnitScreenName(EntityType);
                local Text = self:GetUnitScreenDescription(EntityType);
                SetTooltipNormal(Title, Text);
                return;
            end
        end
        Lib.MilitiaSystem.Local.Orig_GUI_MultiSelection_IconMouseOver();
    end

    self.Orig_GUI_MultiSelection_IconUpdate = GUI_MultiSelection.IconUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_MultiSelection.IconUpdate = function()
        Lib.MilitiaSystem.Local.Orig_GUI_MultiSelection_IconUpdate();
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local CurrentMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID);
        local CurrentMotherName = XGUIEng.GetWidgetNameByID(CurrentMotherID);
        local Index = CurrentMotherName + 0;
        local EntityID = g_MultiSelection.EntityList[Index];
        local PlayerID = Logic.EntityGetPlayer(EntityID);
        if not Lib.MilitiaSystem.Local.MilitiaMapping[PlayerID]
        or not Lib.MilitiaSystem.Local.MilitiaMapping[PlayerID][EntityID] then
            XGUIEng.SetMaterialColor(CurrentWidgetID, 7, 255, 255, 255, 255);
            return;
        end
        if Logic.IsLeader(EntityID) == 1 then
            local UnitType = Logic.LeaderGetSoldiersType(EntityID);
            local UnitTypeName = Logic.GetEntityTypeName(UnitType);
            if not Lib.MilitiaSystem.Shared.TypeSkills[UnitTypeName] then
                XGUIEng.SetMaterialColor(CurrentWidgetID, 7, 255, 255, 255, 255);
                return;
            end
        end
        XGUIEng.SetMaterialColor(CurrentWidgetID, 7, 55, 255, 0, 255);
    end
end

-- -------------------------------------------------------------------------- --

function Lib.MilitiaSystem.Local:InitConscriptUpdate()
    RequestJobByEventType(
        Events.LOGIC_EVENT_EVERY_TURN,
        function()
            local PlayerID = (Logic.GetCurrentTurn() % 10) +1;
            if self.ConscriptCount[PlayerID] and Logic.PlayerGetIsHumanFlag(PlayerID) then
                local Conscripts = Lib.MilitiaSystem.Shared:GetConscripts(PlayerID);
                self.ConscriptCount[PlayerID] = #Conscripts;
            end
        end
    );
end

-- -------------------------------------------------------------------------- --
-- Shared

function Lib.MilitiaSystem.Shared:GetDefaultMilitiaUnitTypes()
    local MapName = Framework.GetCurrentMapName();
    local MapType, Campaign = Framework.GetCurrentMapTypeAndCampaignName();
    local ClimateZone = Framework.GetMapClimateZone(MapName, MapType, Campaign);

    if ClimateZone == "NorthEurope" then
        return Entities.U_MilitaryBandit_Melee_NE, Entities.U_MilitaryBandit_Ranged_NE;
    elseif ClimateZone == "SouthEurope" then
        return Entities.U_MilitaryBandit_Melee_SE, Entities.U_MilitaryBandit_Ranged_SE;
    elseif ClimateZone == "NorthAfrica" then
        return Entities.U_MilitaryBandit_Melee_NA, Entities.U_MilitaryBandit_Ranged_NA;
    elseif ClimateZone == "Asia" then
        return Entities.U_MilitaryBandit_Melee_AS, Entities.U_MilitaryBandit_Ranged_AS;
    end
    return Entities.U_MilitaryBandit_Melee_ME, Entities.U_MilitaryBandit_Ranged_ME;
end

function Lib.MilitiaSystem.Shared:GetRandomMilitiaUnitTypes(_PlayerID, _Allocation)
    local MeleeList, RangedList = {}, {};
    -- Get types allowed for player
    for Type, Data in pairs(Lib.MilitiaSystem.Config.UnitData) do
        if Entities[Type] and Logic.IsEntityTypeInCategory(Entities[Type], EntityCategories.Melee) == 1 then
            if  Logic.TechnologyGetState(_PlayerID, Technologies[Data[1]]) == TechnologyStates.Researched
            and Logic.TechnologyGetState(_PlayerID, Technologies[Data[2]]) == TechnologyStates.Researched then
                table.insert(MeleeList, Entities[Type]);
            end
        end
        if Entities[Type] and Logic.IsEntityTypeInCategory(Entities[Type], EntityCategories.Range) == 1 then
            if  Logic.TechnologyGetState(_PlayerID, Technologies[Data[1]]) == TechnologyStates.Researched
            and Logic.TechnologyGetState(_PlayerID, Technologies[Data[2]]) == TechnologyStates.Researched then
                table.insert(RangedList, Entities[Type]);
            end
        end
    end
    -- Select a random type, if more than one type available, that is not
    -- the currently allocated type
    if #MeleeList > 1 and #RangedList > 1 then
        local Melee, Ranged;
        repeat
            Melee = MeleeList[math.random(1, #MeleeList)];
        until (Melee ~= _Allocation[_PlayerID][1]);
        repeat
            Ranged = MeleeList[math.random(1, #MeleeList)];
        until (Ranged ~= _Allocation[_PlayerID][2]);
        return Melee, Ranged;
    -- Return default types otherwise
    else
        return self:GetDefaultMilitiaUnitTypes();
    end
end

function Lib.MilitiaSystem.Shared:GetConscripts(_PlayerID)
    -- Check buildings
    local Buildings = {};
    for k,v in pairs({Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.OuterRimBuilding)}) do
        if Logic.IsConstructionComplete(v) == 1 then
            table.insert(Buildings, v);
        end
    end
    for k,v in pairs({Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.CityBuilding)}) do
        if Logic.IsConstructionComplete(v) == 1 then
            table.insert(Buildings, v);
        end
    end
    -- Check settlers
    local Conscripts = {};
    for _, BuildingID in pairs(Buildings) do
        for _, SettlerID in pairs({Logic.GetWorkersForBuilding(BuildingID)}) do
            if SettlerID > 0 and not IsSettlerSuspended(SettlerID) then
                local Type = Logic.GetEntityType(SettlerID);
                local Task = Logic.GetCurrentTaskList(SettlerID);
                local Grade = Lib.MilitiaSystem.Shared.ConscriptConfig;
                if Type ~= Entities.U_Priest then
                    if Lib.MilitiaSystem.Config.ConscriptTasks[Grade][Task] then
                        table.insert(Conscripts, SettlerID);
                    end
                end
            end
        end
    end
    -- Return result
    return Conscripts;
end

function Lib.MilitiaSystem.Shared:CreateTechnologies()
    for i= 1, #Lib.MilitiaSystem.Config.Technology do
        local Technology = Lib.MilitiaSystem.Config.Technology[i];
        if g_GameExtraNo >= Technology[4] then
            if not Technologies[Technology[1]] then
                AddCustomTechnology(Technology[1],Technology[2],Technology[3]);
                if not IsLocalScript() then
                    for j= 1, 8 do
                        Logic.TechnologySetState(j, Technologies[Technology[1]], 3);
                    end
                end
            end
        end
    end
end

function Lib.MilitiaSystem.Shared:ActivateUnitTypeSkills()
    self.TypeSkills["U_MilitaryBandit_Melee_AS"] = MilitiaSkill.Execution;
    self.TypeSkills["U_MilitaryBandit_Ranged_AS"] = MilitiaSkill.Critical;
    self.TypeSkills["U_MilitaryBandit_Melee_ME"] = MilitiaSkill.Concussion;
    self.TypeSkills["U_MilitaryBandit_Ranged_ME"] = MilitiaSkill.BraveStand;
    self.TypeSkills["U_MilitaryBandit_Melee_NA"] = MilitiaSkill.BraveStand;
    self.TypeSkills["U_MilitaryBandit_Ranged_NA"] = MilitiaSkill.Doge;
    self.TypeSkills["U_MilitaryBandit_Melee_NE"] = MilitiaSkill.Bleeding;
    self.TypeSkills["U_MilitaryBandit_Ranged_NE"] = MilitiaSkill.Bleeding;
    self.TypeSkills["U_MilitaryBandit_Melee_SE"] = MilitiaSkill.Doge;
    self.TypeSkills["U_MilitaryBandit_Ranged_SE"] = MilitiaSkill.Critical;
end

function Lib.MilitiaSystem.Shared:DeactivateUnitTypeSkills()
    self.TypeSkills["U_MilitaryBandit_Melee_AS"] = nil;
    self.TypeSkills["U_MilitaryBandit_Ranged_AS"] = nil;
    self.TypeSkills["U_MilitaryBandit_Melee_ME"] = nil;
    self.TypeSkills["U_MilitaryBandit_Ranged_ME"] = nil;
    self.TypeSkills["U_MilitaryBandit_Melee_NA"] = nil;
    self.TypeSkills["U_MilitaryBandit_Ranged_NA"] = nil;
    self.TypeSkills["U_MilitaryBandit_Melee_NE"] = nil;
    self.TypeSkills["U_MilitaryBandit_Ranged_NE"] = nil;
    self.TypeSkills["U_MilitaryBandit_Melee_SE"] = nil;
    self.TypeSkills["U_MilitaryBandit_Ranged_SE"] = nil;
end

function Lib.MilitiaSystem.Shared:SetDefaultUnitTypeAllocation(_PlayerID)
    local Melee, Ranged = self:GetDefaultMilitiaUnitTypes();
    self.MilitiaAllocation[_PlayerID] = {Melee, Ranged};
end

function Lib.MilitiaSystem.Shared:SetRandomUnitTypeAllocation(_PlayerID)
    local Melee, Ranged = self:GetRandomMilitiaUnitTypes(_PlayerID);
    self.MilitiaAllocation[_PlayerID] = {Melee, Ranged};
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.MilitiaSystem.Name);

