Lib.SettlementLimitation = Lib.SettlementLimitation or {};
Lib.SettlementLimitation.Name = "SettlementLimitation";
Lib.SettlementLimitation.Global = {
    Active = false,
    TerritoryRestriction = {},
    TerritoryTypeRestriction = {},
    AdditionalBuildingBonus = {},
    MultiConstructionBonus = {},
    WallUpkeepCosts = false,
    WallDeteriation = false,
};
Lib.SettlementLimitation.Local  = {
    Active = false,
    TerritoryRestriction = {},
    TerritoryTypeRestriction = {},
    AdditionalBuildingBonus = {},
    MultiConstructionBonus = {},
    WallUpkeepCosts = false,
    WallDeteriation = false,
};
Lib.SettlementLimitation.Shared = {
    DevelopTerritoryCosts = {Goods.G_Gold, 500},
    CityBuildings = {},
    OuterRimBuildings = {},
    WallDeteriation = {
        Health = 10,
        Chance = 15,
    },
    Upkeep = {
        Palisade = 0.3,
        Wall = 1.5,
    },
    AbsolutLimitIgnore = {
        ["B_Beehive"] = true,
        ["B_GrainField_AS"] = true,
        ["B_GrainField_ME"] = true,
        ["B_GrainField_NA"] = true,
        ["B_GrainField_NE"] = true,
        ["B_GrainField_SE"] = true,
    },
};

Lib.Require("comfort/GetDistance");
Lib.Require("comfort/GetTerritoryID");
Lib.Require("core/Core");
Lib.Require("module/city/Construction");
Lib.Require("module/entity/EntityEvent");
Lib.Require("module/faker/Technology");
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
        for PlayerID = 1, 8 do
            self.TerritoryRestriction[PlayerID] = {};
            self.TerritoryTypeRestriction[PlayerID] = {};
            self.AdditionalBuildingBonus[PlayerID] = {};
            self.MultiConstructionBonus[PlayerID] = {};
        end
        Lib.SettlementLimitation.Shared:CreateTypeLists();

        self:InitConstructionLimitRules();
        self:InitWallUpkeep();

        -- Garbage collection
        Lib.SettlementLimitation.Local = nil;
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
            CustomRuleConstructBuilding(PlayerID, "SettlementLimitation_Global_TerritoryBuildingGeneralLimitRule");
            CustomRuleConstructBuilding(PlayerID, "SettlementLimitation_Global_TerritoryBuildingTypeLimitRule");
            CustomRuleConstructBuilding(PlayerID, "SettlementLimitation_Global_HomeTerritoryBuildingGeneralLimitRule");
            CustomRuleConstructBuilding(PlayerID, "SettlementLimitation_Global_HomeTerritoryBuildingTypeLimitRule");
        end
    elseif _ID == Report.BuildingUpgraded then
        local Costs = Lib.SettlementLimitation.Shared.DevelopTerritoryCosts;
        local IsOutpost = Logic.IsEntityInCategory(arg[1], EntityCategories.Outpost) == 1;
        local TerritoryID = GetTerritoryUnderEntity(arg[1]);
        local Bonus = self:GetMultiConstructionBonusAmount(arg[2], TerritoryID);
        if IsOutpost and Bonus == 0 then
            AddGood(Costs[1], Costs[2], arg[1]);
            self:SetMultiConstructionBonusAmount(arg[2], TerritoryID, 1);
        end
    end
end

function Lib.SettlementLimitation.Global:InitDefaultRules(_PlayerID)
    local Territories = {Logic.GetTerritories()};
    for i = 1, #Territories do
        SetTerritoryBuildingLimit(_PlayerID, Territories[i], 3);
        for Type, _ in pairs(Lib.SettlementLimitation.Shared.CityBuildings) do
            SetTerritoryBuildingTypeLimit(_PlayerID, Territories[i], Type, 0);
        end
        for Type, _ in pairs(Lib.SettlementLimitation.Shared.OuterRimBuildings) do
            SetTerritoryBuildingTypeLimit(_PlayerID, Territories[i], Type, 1);
        end
    end
end

function Lib.SettlementLimitation.Global:InitConstructionLimitRules()
    -- Check general amount of buildings in a territory.
    SettlementLimitation_Global_TerritoryBuildingGeneralLimitRule = function(_PlayerID, _Type, _X, _Y)
        local MainBuilding = Logic.GetStoreHouse(_PlayerID);
        local MainTerritoryID = GetTerritoryUnderEntity(MainBuilding);
        local TerritoryID = Logic.GetTerritoryAtPosition(_X, _Y);
        local OutpostID = Logic.GetTerritoryAcquiringBuildingID(TerritoryID);
        if  Lib.SettlementLimitation.Global.Active
        and MainTerritoryID ~= TerritoryID then
            if Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID] then
                local IgnoreList = Lib.SettlementLimitation.Shared.AbsolutLimitIgnore;
                local TypeName = Logic.GetEntityTypeName(_Type);
                if IgnoreList[TypeName] then
                    return true;
                end

                local Limit = -1;
                if Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID][TerritoryID] then
                    Limit = Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID][TerritoryID];
                end
                if Limit == -1 and Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID][0] then
                    Limit = Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID][0];
                end
    	        local Bonus = Lib.SettlementLimitation.Global:GetAdditionalBuildingBonusAmount(_PlayerID, TerritoryID);
                local Current = 0;
                Current = Current + #{Logic.GetEntitiesOfCategoryInTerritory(TerritoryID, _PlayerID, EntityCategories.CityBuilding, 0)};
                Current = Current + #{Logic.GetEntitiesOfCategoryInTerritory(TerritoryID, _PlayerID, EntityCategories.OuterRimBuilding, 0)};
                -- Current = Current - ((OutpostID ~= 0 and 1) or 0);
                if (Limit or -1) ~= -1 then
                    return Current < ((Limit > 0 and Limit + Bonus) or Limit);
                end
            end
        end
        return true;
    end

    -- Check type amount of buildings in a territory.
    SettlementLimitation_Global_TerritoryBuildingTypeLimitRule = function(_PlayerID, _Type, _X, _Y)
        local MainBuilding = Logic.GetStoreHouse(_PlayerID);
        local MainTerritoryID = GetTerritoryUnderEntity(MainBuilding);
        local TerritoryID = Logic.GetTerritoryAtPosition(_X, _Y);
        local OutpostID = Logic.GetTerritoryAcquiringBuildingID(TerritoryID);
        if  Lib.SettlementLimitation.Global.Active
        and MainTerritoryID ~= TerritoryID then
            if Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID] then
                local IgnoreList = Lib.SettlementLimitation.Shared.AbsolutLimitIgnore;
                local TypeName = Logic.GetEntityTypeName(_Type);
                if IgnoreList[TypeName] then
                    return true;
                end

                local Limit = -1;
                if Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID][TerritoryID] then
                    Limit = Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID][TerritoryID][_Type] or -1;
                end
                if Limit == -1 and Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID][0] then
                    Limit = Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID][0][_Type] or -1;
                end
                local Bonus = Lib.SettlementLimitation.Global:GetMultiConstructionBonusAmount(_PlayerID, TerritoryID);
                local Current = #{Logic.GetEntitiesOfTypeInTerritory(TerritoryID, _PlayerID, _Type, 0)};
                if (Limit or -1) ~= -1 then
                    return Current < ((Limit > 0 and Limit + Bonus) or Limit);
                end
            end
        end
        return true;
    end

    -- Check amount of outer rim buildings in home territory
    SettlementLimitation_Global_HomeTerritoryBuildingGeneralLimitRule = function(_PlayerID, _Type, _X, _Y)
        local MainBuilding = Logic.GetStoreHouse(_PlayerID);
        local MainTerritoryID = GetTerritoryUnderEntity(MainBuilding);
        local TerritoryID = Logic.GetTerritoryAtPosition(_X, _Y);
        local OutpostID = Logic.GetTerritoryAcquiringBuildingID(TerritoryID);
        if  Lib.SettlementLimitation.Global.Active
        and Logic.IsEntityTypeInCategory(_Type, EntityCategories.OuterRimBuilding) == 1
        and MainTerritoryID == TerritoryID then
            if Lib.SettlementLimitation.Global.TerritoryRestriction[_PlayerID] then
                local IgnoreList = Lib.SettlementLimitation.Shared.AbsolutLimitIgnore;
                local TypeName = Logic.GetEntityTypeName(_Type);
                if IgnoreList[TypeName] then
                    return true;
                end
                local Current = #{Logic.GetEntitiesOfCategoryInTerritory(TerritoryID, _PlayerID, EntityCategories.OuterRimBuilding, 0)};
                return Current < 3;
            end
        end
        return true;
    end

    -- Check amount of type of outer rim building in home territory
    SettlementLimitation_Global_HomeTerritoryBuildingTypeLimitRule = function(_PlayerID, _Type, _X, _Y)
        local MainBuilding = Logic.GetStoreHouse(_PlayerID);
        local MainTerritoryID = GetTerritoryUnderEntity(MainBuilding);
        local TerritoryID = Logic.GetTerritoryAtPosition(_X, _Y);
        local OutpostID = Logic.GetTerritoryAcquiringBuildingID(TerritoryID);
        if  Lib.SettlementLimitation.Global.Active
        and Logic.IsEntityTypeInCategory(_Type, EntityCategories.OuterRimBuilding) == 1
        and MainTerritoryID == TerritoryID then
            if Lib.SettlementLimitation.Global.TerritoryTypeRestriction[_PlayerID] then
                local IgnoreList = Lib.SettlementLimitation.Shared.AbsolutLimitIgnore;
                local TypeName = Logic.GetEntityTypeName(_Type);
                if IgnoreList[TypeName] then
                    return true;
                end
                local Current = #{Logic.GetEntitiesOfTypeInTerritory(TerritoryID, _PlayerID, _Type, 0)};
                return Current < 1;
            end
        end
        return true;
    end
end

function Lib.SettlementLimitation.Global:ActivateSettlementLimitation(_Flag)
    self.Active = _Flag == true;

    ExecuteLocal(
        [[Lib.SettlementLimitation.Local.Active = %s == true]],
        tostring(_Flag == true)
    );
end

function Lib.SettlementLimitation.Global:GetAdditionalBuildingBonusAmount(_PlayerID, _ID)
    if self.AdditionalBuildingBonus[_PlayerID] then
        return self.AdditionalBuildingBonus[_PlayerID][_ID] or 0;
    end
    return 0;
end

function Lib.SettlementLimitation.Global:SetAdditionalBuildingBonusAmount(_PlayerID, _ID, _Amount)
    if self.AdditionalBuildingBonus[_PlayerID] then
        local CurrentAmount = self.AdditionalBuildingBonus[_PlayerID][_ID] or 0;
        self.AdditionalBuildingBonus[_PlayerID][_ID] = CurrentAmount + _Amount;

        ExecuteLocal(
            [[Lib.SettlementLimitation.Local.AdditionalBuildingBonus[%d][%d] = %d]],
            _PlayerID,
            _ID,
            CurrentAmount + _Amount
        );
    end
end

function Lib.SettlementLimitation.Global:GetMultiConstructionBonusAmount(_PlayerID, _ID)
    if self.MultiConstructionBonus[_PlayerID] then
        return self.MultiConstructionBonus[_PlayerID][_ID] or 0;
    end
    return 0;
end

function Lib.SettlementLimitation.Global:SetMultiConstructionBonusAmount(_PlayerID, _ID, _Amount)
    if self.MultiConstructionBonus[_PlayerID] then
        local CurrentAmount = self.MultiConstructionBonus[_PlayerID][_ID] or 0;
        self.MultiConstructionBonus[_PlayerID][_ID] = CurrentAmount + _Amount;

        ExecuteLocal(
            [[Lib.SettlementLimitation.Local.MultiConstructionBonus[%d][%d] = %d]],
            _PlayerID,
            _ID,
            CurrentAmount + _Amount
        );
    end
end

-- -------------------------------------------------------------------------- --

function Lib.SettlementLimitation.Global:InitWallUpkeep()
    self.Orig_GameCallback_TaxCollectionFinished = GameCallback_TaxCollectionFinished;
    GameCallback_TaxCollectionFinished = function(_PlayerID, _Total, _Bonus)
        Lib.SettlementLimitation.Global.Orig_GameCallback_TaxCollectionFinished(_PlayerID, _Total, _Bonus);
        Lib.SettlementLimitation.Global:PayFacilityUpkeep(_PlayerID);
    end
end

function Lib.SettlementLimitation.Global:PayFacilityUpkeep(_PlayerID)
    if self.WallUpkeepCosts then
        if Logic.PlayerGetIsHumanFlag(_PlayerID) then
            local WallCost = self:GetWallUpkeep(_PlayerID);
            local MoneyCost = WallCost;

            if WallCost > 0 then
                if GetPlayerResources(Goods.G_Gold, _PlayerID) < WallCost then
                    local WallList = {Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.Wall)};
                    local Deteriation = Lib.SettlementLimitation.Shared.WallDeteriation;
                    for _,ID in pairs(WallList) do
                        if math.random(1, 100) <= Deteriation.Chance then
                            local Health = Logic.GetEntityHealth(ID);
                            local MaxHealth = Logic.GetEntityHealth(ID);
                            local Damage = math.ceil(MaxHealth * 0.05);
                            if Health > 0 and Damage >= Health then
                                Logic.HurtEntity(ID, Damage);
                            end
                        end
                    end
                else
                    AddGood(Goods.G_Gold, (-1) * WallCost, _PlayerID);
                end
            end

            RequestHiResDelay(
                0,
                ExecuteLocal,
                [[GUI_FeedbackWidgets.GoldAdd(%d, nil, {3, 11, 0}, {1, 8, 0})]],
                (-1) * MoneyCost
            );
        end
    end
end

function Lib.SettlementLimitation.Global:GetWallUpkeep(_PlayerID)
    local Upkeep = 0;
    local UpkeepPalisade = Lib.SettlementLimitation.Shared.Upkeep.Palisade;
    local UpkeepWall = Lib.SettlementLimitation.Shared.Upkeep.Wall;
    for _, ID in pairs{Logic.GetPlayerEntitiesInCategory(_PlayerID, EntityCategories.Wall)} do
        if Logic.IsEntityInCategory(ID, EntityCategories.Wall) == 1 then
            if Logic.IsEntityInCategory(ID, EntityCategories.PalisadeSegment) == 1 then
                Upkeep = Upkeep + UpkeepPalisade;
            else
                Upkeep = Upkeep + UpkeepWall;
            end
        end
    end
    return math.ceil(Upkeep);
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.SettlementLimitation.Local:Initialize()
    if not self.IsInstalled then
        for PlayerID = 1, 8 do
            self.TerritoryRestriction[PlayerID] = {};
            self.TerritoryTypeRestriction[PlayerID] = {};
            self.AdditionalBuildingBonus[PlayerID] = {};
            self.MultiConstructionBonus[PlayerID] = {};
        end
        Lib.SettlementLimitation.Shared:CreateTypeLists();

        self:OverwritePlacementUpdate();

        -- Garbage collection
        Lib.SettlementLimitation.Global = nil;
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

function Lib.SettlementLimitation.Local:OverwritePlacementUpdate()
    self.Orig_GUI_Construction_PlacementUpdate = GUI_Construction.PlacementUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Construction.PlacementUpdate = function()
        if PlacementState ~= 0 then
            Lib.SettlementLimitation.Local.Orig_GUI_Construction_PlacementUpdate();
            return;
        end

        local this = Lib.SettlementLimitation.Local;

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
        local RestrictionTerritoryString = this:GetRestrictionText(PlayerID, TerritoryID, BuildingType);
        local RestrictionTypeString = this:GetRestrictionTypeText(PlayerID, TerritoryID, BuildingType);
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
        end
    end
end

function Lib.SettlementLimitation.Local:GetRestrictionText(_PlayerID, _TerritoryID, _Type)
    local MainBuilding = Logic.GetStoreHouse(_PlayerID);
    if GetTerritoryUnderEntity(MainBuilding) == _TerritoryID
    or not Lib.SettlementLimitation.Local.Active then
        return "";
    end

    local getRestrictionText = function(playerID, territoryID, buildingLimit)
        local this = Lib.SettlementLimitation.Local;
        local Current = 0;
        Current = Current + #{Logic.GetEntitiesOfCategoryInTerritory(territoryID, playerID, EntityCategories.CityBuilding, 0)};
        Current = Current + #{Logic.GetEntitiesOfCategoryInTerritory(territoryID, playerID, EntityCategories.OuterRimBuilding, 0)};
        local Bonus = this:GetAdditionalBuildingBonusAmount(playerID, territoryID);
        local Limit = buildingLimit;
        Limit = (Limit > 0 and Limit + Bonus) or Limit;
        local Text = string.format(
            "%s%s %d / %d{@color:255,255,255,255}{cr}",
            (Current >= Limit and "{@color:255,0,0,255}") or "{@color:255,255,255,255}",
            Localize(Lib.SettlementLimitation.Text.BuildingLimit),
            Current,
            Limit
        );
        return Text;
    end

    if Lib.SettlementLimitation.Shared:IsCheckedType(_Type) then
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
    end
    return "";
end

function Lib.SettlementLimitation.Local:GetRestrictionTypeText(_PlayerID, _TerritoryID, _Type)
    local MainBuilding = Logic.GetStoreHouse(_PlayerID);
    if GetTerritoryUnderEntity(MainBuilding) == _TerritoryID
    or not Lib.SettlementLimitation.Local.Active then
        return "";
    end

    local getRestrictionText = function (playerID, territoryID, entityType, typeRestriction)
        local this = Lib.SettlementLimitation.Local;
        local TypeName = Logic.GetEntityTypeName(entityType);
        local Current = #{Logic.GetEntitiesOfTypeInTerritory(territoryID, playerID, entityType, 0)};
        local Limit = typeRestriction;
        local Bonus = this:GetMultiConstructionBonusAmount(playerID, territoryID);
        Limit = (Limit > 0 and Limit + Bonus) or Limit;
        local Text = string.format(
            "%s%s %d / %d{@color:255,255,255,255}{cr}",
            (Current >= Limit and "{@color:255,0,0,255}") or "{@color:255,255,255,255}",
            XGUIEng.GetStringTableText("Names/" .. TypeName),
            Current,
            Limit
        );
        return Text;
    end

    if Lib.SettlementLimitation.Shared:IsCheckedType(_Type) then
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
    end

    return "";
end

function Lib.SettlementLimitation.Local:GetAdditionalBuildingBonusAmount(_PlayerID, _ID)
    if self.AdditionalBuildingBonus[_PlayerID] then
        return self.AdditionalBuildingBonus[_PlayerID][_ID] or 0;
    end
    return 0;
end

function Lib.SettlementLimitation.Local:GetMultiConstructionBonusAmount(_PlayerID, _ID)
    if self.MultiConstructionBonus[_PlayerID] then
        return self.MultiConstructionBonus[_PlayerID][_ID] or 0;
    end
    return 0;
end

-- -------------------------------------------------------------------------- --
-- Shared

function Lib.SettlementLimitation.Shared:CreateTypeLists()
    self.CityBuildings = {};
    self.OuterRimBuildings = {};

    local CityBuildings = {Logic.GetEntityTypesInCategory(EntityCategories.CityBuilding)};
    for _, Type in pairs(CityBuildings) do
        self.CityBuildings[Type] = true;
    end
    local OuterRimBuildings = {Logic.GetEntityTypesInCategory(EntityCategories.OuterRimBuilding)};
    for _, Type in pairs(OuterRimBuildings) do
        self.OuterRimBuildings[Type] = true;
    end
end

function Lib.SettlementLimitation.Shared:IsCheckedType(_Type)
    if self.CityBuildings[_Type] then
        return true;
    end
    if self.OuterRimBuildings[_Type] then
        return true;
    end
    return false;
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.SettlementLimitation.Name);

