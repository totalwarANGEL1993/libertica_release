Lib.SettlementLimitation = Lib.SettlementLimitation or {};
Lib.SettlementLimitation.Name = "SettlementLimitation";
Lib.SettlementLimitation.Global = {
    Active = false,

    TerritoryRestriction = {},
    TerritoryTypeRestriction = {},
    OutpostUpgradeBonus = {},

    UpgradeTerritoryCosts = {Goods.G_Gold, 300},

    CityBuildings = {},
    OuterRimBuildings = {},
};
Lib.SettlementLimitation.Local  = {
    Active = false,

    TerritoryRestriction = {},
    TerritoryTypeRestriction = {},
    OutpostUpgradeBonus = {},

    UpgradeTerritoryCosts = {Goods.G_Gold, 300},

    CityBuildings = {},
    OuterRimBuildings = {},
};

Lib.Require("comfort/GetTerritoryID");
Lib.Require("core/Core");
Lib.Require("module/city/Construction");
Lib.Require("module/ui/UIBuilding");
Lib.Require("module/ui/UITools");
Lib.Require("module/mode/SettlementLimitation_API");
Lib.Require("module/mode/SettlementLimitation_Text");
Lib.Register("module/mode/SettlementLimitation");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.SettlementLimitation.Global:Initialize()
    if not self.IsInstalled then
        Report.DevelopTerritory_Internal = CreateReport("DevelopTerritory_Internal");

        self.CityBuildings = {Logic.GetEntityTypesInCategory(EntityCategories.CityBuilding)};
        self.OuterRimBuildings = {Logic.GetEntityTypesInCategory(EntityCategories.OuterRimBuilding)};

        for PlayerID = 1, 8 do
            self.TerritoryRestriction[PlayerID] = {};
            self.TerritoryTypeRestriction[PlayerID] = {};
            self.OutpostUpgradeBonus[PlayerID] = {};
        end

        -- Garbage collection
        Lib.SettlementSurvival.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.SettlementLimitation.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.SettlementLimitation.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
        for PlayerID = 1, 8 do
            self:InitDefaultRules(PlayerID);
            self:InitConstructionLimit(PlayerID);
        end
    elseif _ID == Report.DevelopTerritory_Internal then
        local Costs = Lib.SettlementLimitation.Local.UpgradeTerritoryCosts;
        AddGood(Costs[1], Costs[2], arg[1]);
        self:SetOutpostUpgradeBonusAmount(arg[1], arg[2], arg[3]);
    end
end

function Lib.SettlementLimitation.Global:InitDefaultRules(_PlayerID)
    local Territories = {Logic.GetTerritories()};
    for i = 1, #Territories do
        SetTerritoryBuildingLimit(_PlayerID, Territories[i], 3);
        for j= 1, #self.CityBuildings do
            SetTerritoryBuildingTypeLimit(_PlayerID, Territories[i], self.CityBuildings[j], 0);
        end
        for j= 1, #self.OuterRimBuildings do
            SetTerritoryBuildingTypeLimit(_PlayerID, Territories[i], self.OuterRimBuildings[j], 1);
        end
    end
end

function Lib.SettlementLimitation.Global:InitConstructionLimit(_PlayerID)
    -- Check general amount of buildings in a territory.
    SettlementLimitation_Global_TerritoryBuildingGeneralLimitRule = function(_PlayerID, _Type, _X, _Y)
        local MainBuilding = Logic.GetStoreHouse(_PlayerID);
        local TerritoryID = Logic.GetTerritoryAtPosition(_X, _Y);
        local OutpostID = Logic.GetTerritoryAcquiringBuildingID(TerritoryID);
        if  Lib.SettlementLimitation.Global.Active
        and GetTerritoryUnderEntity(MainBuilding) ~= TerritoryID then
            if  Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID] then
                local Limit = Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID][TerritoryID];
                if Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID][0] then
                    Limit = Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID][0];
                end
                local Bonus = Lib.SettlementLimitation.Global:GetOutpostUpgradeBonusAmount(_PlayerID, TerritoryID);
                local Current = #{Logic.GetEntitiesOfCategoryInTerritory(TerritoryID, _PlayerID, EntityCategories.AttackableBuilding, 0)};
                Current = Current - ((OutpostID ~= 0 and 1) or 0);
                if (Limit or -1) ~= -1 then
                    return Current < (Limit + Bonus);
                end
            end
        end
        return true;
    end

    -- Check type amount of buildings in a territory.
    SettlementLimitation_Global_TerritoryBuildingTypeLimitRule = function(_PlayerID, _Type, _X, _Y)
        local MainBuilding = Logic.GetStoreHouse(_PlayerID);
        local TerritoryID = Logic.GetTerritoryAtPosition(_X, _Y);
        if  Lib.SettlementLimitation.Global.Active
        and GetTerritoryUnderEntity(MainBuilding) ~= TerritoryID then
            if  Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID] then
                local Limit = -1;
                if Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID][TerritoryID] then
                    Limit = Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID][TerritoryID][_Type] or -1;
                end
                if Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID][0] then
                    Limit = Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID][0][_Type] or -1;
                end
                local Current = #{Logic.GetEntitiesOfTypeInTerritory(TerritoryID, _PlayerID, _Type, 0)};
                if (Limit or -1) ~= -1 then
                    return Current < Limit;
                end
            end
        end
        return true;
    end

    CustomRuleConstructBuilding(_PlayerID, "SettlementLimitation_Global_TerritoryBuildingGeneralLimitRule");
    CustomRuleConstructBuilding(_PlayerID, "SettlementLimitation_Global_TerritoryBuildingTypeLimitRule");
end

function Lib.SettlementLimitation.Global:ActivateSettlementLimitation(_Flag)
    self.Active = _Flag == true;
    ExecuteLocal(
        [[Lib.SettlementLimitation.Local.Active = %s == true]],
        tostring(_Flag == true)
    );
end

function Lib.SettlementLimitation.Global:GetOutpostUpgradeBonusAmount(_PlayerID, _ID)
    if self.OutpostUpgradeBonus[_PlayerID] then
        return self.OutpostUpgradeBonus[_PlayerID][_ID] or 0;
    end
    return 0;
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.SettlementLimitation.Local:Initialize()
    if not self.IsInstalled then
        Report.DevelopTerritory_Internal = CreateReport("DevelopTerritory_Internal");

        self:AddOutpostDevelopButton();
        self:OverwritePlacementUpdate();

        self.CityBuildings = {Logic.GetEntityTypesInCategory(EntityCategories.CityBuilding)};
        self.OuterRimBuildings = {Logic.GetEntityTypesInCategory(EntityCategories.OuterRimBuilding)};

        for PlayerID = 1, 8 do
            self.TerritoryRestriction[PlayerID] = {};
            self.TerritoryTypeRestriction[PlayerID] = {};
            self.OutpostUpgradeBonus[PlayerID] = {};
        end

        -- Garbage collection
        Lib.SettlementSurvival.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.SettlementLimitation.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.SettlementLimitation.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.SettlementLimitation.Local:AddOutpostDevelopButton()
    local Action = function(_WidgetID, _EntityID)
        local PlayerID = GUI.GetPlayerID();
        local TerritoryID = GetTerritoryUnderEntity(_EntityID);
        local Costs = Lib.SettlementLimitation.Local.UpgradeTerritoryCosts;
        if  GetPlayerGoodsInSettlement(Costs[1], PlayerID, true) <= Costs[2] then
            Message(XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_G_Gold"));
            return;
        end
        SendReportToGlobal(Report.DevelopTerritory_Internal, PlayerID, TerritoryID, 1);
    end

    local Tooltip = function(_WidgetID, _EntityID)
        local PlayerID = GUI.GetPlayerID();
        local TerritoryID = GetTerritoryUnderEntity(_EntityID);
        local DisabledText;
        if Logic.GetUpgradeLevel(_EntityID) < 1 then
            DisabledText = Localize(Lib.SettlementLimitation.Text.DevelopTerritory.DisabledUpgrade);
        elseif Lib.SettlementLimitation.Local.OutpostUpgradeBonus[PlayerID][TerritoryID] then
            DisabledText = Localize(Lib.SettlementLimitation.Text.DevelopTerritory.DisabledDone);
        end
        SetTooltipCosts(
            Localize(Lib.SettlementLimitation.Text.DevelopTerritory.Title),
            Localize(Lib.SettlementLimitation.Text.DevelopTerritory.Text),
            DisabledText,
            Lib.SettlementLimitation.Local.UpgradeTerritoryCosts,
            true
        )
    end

    local Update = function(_WidgetID, _EntityID)
        local PlayerID = GUI.GetPlayerID();
        local TerritoryID = GetTerritoryUnderEntity(_EntityID);
        SetIcon(_WidgetID, {1, 8});
        if Lib.SettlementLimitation.Local.Active then
            if Lib.SettlementLimitation.Local.OutpostUpgradeBonus[PlayerID][TerritoryID]
            or Logic.GetUpgradeLevel(_EntityID) < 1 then
                XGUIEng.DisableButton(_WidgetID, 1);
            else
                XGUIEng.DisableButton(_WidgetID, 0);
            end
        else
            XGUIEng.ShowWidget(_WidgetID, 0);
        end
    end

    AddBuildingButtonByType(Entities.B_Outpost_ME, Action, Tooltip, Update);
    AddBuildingButtonByType(Entities.B_Outpost_NA, Action, Tooltip, Update);
    AddBuildingButtonByType(Entities.B_Outpost_NE, Action, Tooltip, Update);
    AddBuildingButtonByType(Entities.B_Outpost_SE, Action, Tooltip, Update);
    if Entities.B_Outpost_AS then
        AddBuildingButtonByType(Entities.B_Outpost_AS, Action, Tooltip, Update);
    end
end

function Lib.SettlementLimitation.Local:OverwritePlacementUpdate()
    self.Orig_GUI_Construction_PlacementUpdate = GUI_Construction.PlacementUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Construction.PlacementUpdate = function()
        if PlacementState ~= 0 then
            Lib.SettlementLimitation.Local.Orig_GUI_Construction_PlacementUpdate();
            return;
        end

        local PlayerID = GUI.GetPlayerID();
        local x,y = GUI.Debug_GetMapPositionUnderMouse();
        local TerritoryPlayerID;
        local TerritoryID;
        if x ~= -1 then
            TerritoryID = Logic.GetTerritoryAtPosition(x,y);
            FoWState = Logic.GetFoWState(PlayerID, x, y);
            if TerritoryID ~= nil then
                TerritoryName = GetTerritoryName(TerritoryID);
                TerritoryPlayerID = Logic.GetTerritoryPlayerID(TerritoryID);
            end
        end

        if TerritoryID == nil or TerritoryPlayerID == 0
        or g_Construction.CurrentPlacementType == 1 then
            return;
        end

        local R, G, B = GUI.GetPlayerColor(TerritoryPlayerID);
        PlayerColor = "{@color:" .. R .. ",".. G ..",".. B .. ",255}";
        local TerritoryName = GetTerritoryName(TerritoryID);
        local UpgradeCategory = Lib.Construction.Local.LastSelectedBuildingType;
        local _, BuildingType = Logic.GetBuildingTypesInUpgradeCategory(UpgradeCategory);
        local RestrictionTerritoryString = self:GetRestrictionText(PlayerID, TerritoryID, BuildingType);
        local RestrictionTypeString = self:GetRestrictionTypeText(PlayerID, TerritoryID, BuildingType);
        local RestrictionString = "";
        if RestrictionTerritoryString == "" and RestrictionTypeString == "" then
            TerritoryName = "";
        else
            RestrictionString = RestrictionTerritoryString .. RestrictionTypeString;
        end

        for i = 0, 4 do
            XGUIEng.SetText("/Ingame/Root/Normal/PlacementStatus/TerritoryName" .. i, "{center}" ..PlayerColor.. " " ..TerritoryName);
            XGUIEng.SetText("/Ingame/Root/Normal/PlacementStatus/TerritoryReason" .. i, "{center}" ..RestrictionString);
            XGUIEng.SetText("/Ingame/Root/Normal/PlacementStatus/OtherReason" .. i, "");
            XGUIEng.SetText("/InGame/Root/Normal/TextMessages/MessageContainer/Message" .. i, "");
        end
    end
end

function Lib.SettlementLimitation.Local:GetRestrictionText(_PlayerID, _TerritoryID, _Type)
    local MainBuilding = Logic.GetStoreHouse(_PlayerID);
    if GetTerritoryUnderEntity(MainBuilding) == _TerritoryID 
    or not Lib.SettlementLimitation.Local.Active then
        return "";
    end

    local function getRestrictionText(playerID, territoryID, limit)
        local OutpostID = Logic.GetTerritoryAcquiringBuildingID(territoryID);
        local Current = #{Logic.GetEntitiesOfCategoryInTerritory(territoryID, playerID, EntityCategories.AttackableBuilding, 0)};
        Current = Current - ((OutpostID ~= 0 and 1) or 0);
        local Bonus = self:GetOutpostUpgradeBonusAmount(playerID, territoryID);
        local Text = string.format(
            "%s%s %d / %d{@color:255,255,255,255}{cr}",
            (Current >= limit and "{@color:255,0,0,255}") or "{@color:255,255,255,255}",
            Localize(Lib.SettlementLimitation.Text.BuildingLimit),
            Current,
            limit + Bonus
        );
        return Text;
    end

    local TerritoryRestriction = self.TerritoryRestriction[_PlayerID];
    if TerritoryRestriction then
        local SpecificLimit = TerritoryRestriction[_TerritoryID];
        if SpecificLimit and SpecificLimit ~= -1 then
            return getRestrictionText(_PlayerID, _TerritoryID, SpecificLimit);
        end

        local GeneralLimit = TerritoryRestriction[0]
        if GeneralLimit and GeneralLimit ~= -1 then
            return getRestrictionText(_PlayerID, _TerritoryID, GeneralLimit);
        end
    end

    return "";
end


function Lib.SettlementLimitation.Local:GetRestrictionTypeText(_PlayerID, _TerritoryID, _Type)
    local MainBuilding = Logic.GetStoreHouse(_PlayerID);
    if GetTerritoryUnderEntity(MainBuilding) == _TerritoryID
    or not Lib.SettlementLimitation.Local.Active then
        return "";
    end

    local function getRestrictionText(playerID, territoryID, entityType, typeRestriction)
        local TypeName = Logic.GetEntityTypeName(entityType);
        local Current = #{Logic.GetEntitiesOfTypeInTerritory(territoryID, playerID, entityType, 0)};
        local Limit = typeRestriction;
        local Bonus = self:GetOutpostUpgradeBonusAmount(playerID, territoryID);
        local Text = string.format(
            "%s%s %d / %d{@color:255,255,255,255}{cr}",
            (Current >= Limit and "{@color:255,0,0,255}") or "{@color:255,255,255,255}",
            XGUIEng.GetStringTableText("Names/" .. TypeName),
            Current,
            Limit + Bonus
        );
        return Text;
    end

    local TypeRestriction = self.TerritoryTypeRestriction[_PlayerID];
    if TypeRestriction then
        local TerritoryRestriction = TypeRestriction[_TerritoryID];
        if TerritoryRestriction and TerritoryRestriction[_Type] and TerritoryRestriction[_Type] ~= -1 then
            return getRestrictionText(_PlayerID, _TerritoryID, _Type, TerritoryRestriction[_Type]);
        end
        local GeneralRestriction = TypeRestriction[0]
        if GeneralRestriction and GeneralRestriction[_Type] and GeneralRestriction[_Type] ~= -1 then
            return getRestrictionText(_PlayerID, _TerritoryID, _Type, GeneralRestriction[_Type]);
        end
    end

    return "";
end

function Lib.SettlementLimitation.Local:GetOutpostUpgradeBonusAmount(_PlayerID, _ID)
    if self.OutpostUpgradeBonus[_PlayerID] then
        return self.OutpostUpgradeBonus[_PlayerID][_ID] or 0;
    end
    return 0;
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.SettlementLimitation.Name);

