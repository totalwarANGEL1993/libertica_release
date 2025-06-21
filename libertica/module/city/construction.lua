Lib.Construction = Lib.Construction or {};
Lib.Construction.Name = "Construction";
Lib.Construction.Global = {
    Construction = {
        ForceBallistaDistance = false,
        Restriction = {
            Index = 0,
            BuildingCustomRule = {},
            BuildingTerritoryBlacklist = {},
            BuildingAreaBlacklist = {},
            BuildingTerritoryWhitelist = {},
            BuildingAreaWhitelist = {},
            RoadCustomRule = {},
            RoadTerritoryBlacklist = {},
            RoadAreaBlacklist = {},
            RoadTerritoryWhitelist = {},
            RoadAreaWhitelist = {},
            WallCustomRule = {},
            WallTerritoryBlacklist = {},
            WallAreaBlacklist = {},
            WallTerritoryWhitelist = {},
            WallAreaWhitelist = {},
        },
    },
    Knockdown = {
        Restriction = {
            Index = 0,
            BuildingCustomRule = {},
            BuildingTerritoryBlacklist = {},
            BuildingAreaBlacklist = {},
            BuildingTerritoryWhitelist = {},
            BuildingAreaWhitelist = {},
        },
    },
};
Lib.Construction.Local  = {
    Construction = {
        ForceBallistaDistance = false,
        Restriction = {
            BuildingCustomRule = {},
            BuildingTerritoryBlacklist = {},
            BuildingAreaBlacklist = {},
            BuildingTerritoryWhitelist = {},
            BuildingAreaWhitelist = {},
            RoadCustomRule = {},
            RoadTerritoryBlacklist = {},
            RoadAreaBlacklist = {},
            RoadTerritoryWhitelist = {},
            RoadAreaWhitelist = {},
            WallCustomRule = {},
            WallTerritoryBlacklist = {},
            WallAreaBlacklist = {},
            WallTerritoryWhitelist = {},
            WallAreaWhitelist = {},
        },
    },
    Knockdown = {
        Restriction = {
            LastSelectedBuildingType = 0,
            LastSelectedRoadType = 0,
            BuildingCustomRule = {},
            BuildingTerritoryBlacklist = {},
            BuildingAreaBlacklist = {},
            BuildingTerritoryWhitelist = {},
            BuildingAreaWhitelist = {},
        }
    }
};

Lib.Require("comfort/GetCategoriesOfType");
Lib.Require("comfort/GetDistance");
Lib.Require("comfort/IsLocalScript");
Lib.Require("core/Core");
Lib.Require("module/city/Construction_API");
Lib.Require("module/city/Construction_Text");
Lib.Register("module/city/Construction");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Construction.Global:Initialize()
    if not self.IsInstalled then
        for i= 1, 8 do
            self.Construction.Restriction.BuildingCustomRule[i] = {};
            self.Construction.Restriction.BuildingTerritoryBlacklist[i] = {};
            self.Construction.Restriction.BuildingAreaBlacklist[i] = {};
            self.Construction.Restriction.BuildingTerritoryWhitelist[i] = {};
            self.Construction.Restriction.BuildingAreaWhitelist[i] = {};
            self.Construction.Restriction.RoadCustomRule[i] = {};
            self.Construction.Restriction.RoadTerritoryBlacklist[i] = {};
            self.Construction.Restriction.RoadAreaBlacklist[i] = {};
            self.Construction.Restriction.RoadTerritoryWhitelist[i] = {};
            self.Construction.Restriction.RoadAreaWhitelist[i] = {};
            self.Construction.Restriction.WallCustomRule[i] = {};
            self.Construction.Restriction.WallTerritoryBlacklist[i] = {};
            self.Construction.Restriction.WallAreaBlacklist[i] = {};
            self.Construction.Restriction.WallTerritoryWhitelist[i] = {};
            self.Construction.Restriction.WallAreaWhitelist[i] = {};
            self.Knockdown.Restriction.BuildingCustomRule[i] = {};
            self.Knockdown.Restriction.BuildingTerritoryBlacklist[i] = {};
            self.Knockdown.Restriction.BuildingAreaBlacklist[i] = {};
            self.Knockdown.Restriction.BuildingTerritoryWhitelist[i] = {};
            self.Knockdown.Restriction.BuildingAreaWhitelist[i] = {};
        end

        -- Garbage collection
        Lib.Construction.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Construction.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Construction.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self:OverwriteGameCallbacks();

        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Construction.Global:WhitelistConstructTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    return self:ListConstructArea("BuildingAreaWhitelist", _PlayerID, _Type, nil, _X, _Y, _Area);
end

function Lib.Construction.Global:WhitelistConstructCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    return self:ListConstructArea("BuildingCateWhitelist", _PlayerID, nil, _Category, _X, _Y, _Area);
end

function Lib.Construction.Global:WhitelistConstructTypeInTerritory(_PlayerID, _Type, _Territory)
    return self:ListConstructTerritory("BuildingTerritoryWhitelist", _PlayerID, _Type, nil, _Territory);
end

function Lib.Construction.Global:WhitelistConstructCategoryInTerritory(_PlayerID, _Category, _Territory)
    return self:ListConstructTerritory("BuildingTerritoryWhitelist", _PlayerID, nil, _Category, _Territory);
end

function Lib.Construction.Global:BlacklistConstructTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    return self:ListConstructArea("BuildingAreaBlacklist", _PlayerID, _Type, nil, _X, _Y, _Area);
end

function Lib.Construction.Global:BlacklistConstructCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    return self:ListConstructArea("BuildingAreaBlacklist", _PlayerID, nil, _Category, _X, _Y, _Area);
end

function Lib.Construction.Global:BlacklistConstructTypeInTerritory(_PlayerID, _Type, _Territory)
    return self:ListConstructTerritory("BuildingTerritoryBlacklist", _PlayerID, _Type, nil, _Territory);
end

function Lib.Construction.Global:BlacklistConstructCategoryInTerritory(_PlayerID, _Category, _Territory)
    return self:ListConstructTerritory("BuildingTerritoryBlacklist", _PlayerID, nil, _Category, _Territory);
end

function Lib.Construction.Global:WhitelistConstructRoadInArea(_PlayerID, _IsRoad, _X, _Y, _Area)
    return self:ListConstructArea("RoadAreaWhitelist", _PlayerID, _IsRoad, nil, _X, _Y, _Area);
end

function Lib.Construction.Global:WhitelistConstructWallInArea(_PlayerID, _IsWall, _X, _Y, _Area)
    return self:ListConstructArea("WallAreaWhitelist", _PlayerID, _IsWall, nil, _X, _Y, _Area);
end

function Lib.Construction.Global:WhitelistConstructRoadInTerritory(_PlayerID, _IsRoad, _Territory)
    return self:ListConstructTerritory("RoadTerritoryWhitelist", _PlayerID, _IsRoad, nil, _Territory);
end

function Lib.Construction.Global:WhitelistConstructWallInTerritory(_PlayerID, _IsWall, _Territory)
    return self:ListConstructTerritory("WallTerritoryWhitelist", _PlayerID, _IsWall, nil, _Territory);
end

function Lib.Construction.Global:BlacklistConstructRoadInArea(_PlayerID, _IsRoad, _X, _Y, _Area)
    return self:ListConstructArea("RoadAreaBlacklist", _PlayerID, _IsRoad, nil, _X, _Y, _Area);
end

function Lib.Construction.Global:BlacklistConstructWallInArea(_PlayerID, _IsWall, _X, _Y, _Area)
    return self:ListConstructArea("WallAreaBlacklist", _PlayerID, _IsWall, nil, _X, _Y, _Area);
end

function Lib.Construction.Global:BlacklistConstructRoadInTerritory(_PlayerID, _IsRoad, _Territory)
    return self:ListConstructTerritory("RoadTerritoryBlacklist", _PlayerID, _IsRoad, nil, _Territory);
end

function Lib.Construction.Global:BlacklistConstructWallInTerritory(_PlayerID, _IsWall, _Territory)
    return self:ListConstructTerritory("WallTerritoryBlacklist", _PlayerID, _IsWall, nil, _Territory);
end

function Lib.Construction.Global:CustomRuleConstructBuilding(_PlayerID, _FunctionName, ...)
    return self:ListConstructCustom("BuildingCustomRule", _PlayerID, _FunctionName, unpack(arg));
end

function Lib.Construction.Global:CustomRuleConstructRoad(_PlayerID, _FunctionName, ...)
    return self:ListConstructCustom("RoadCustomRule", _PlayerID, _FunctionName, unpack(arg));
end

function Lib.Construction.Global:CustomRuleConstructWall(_PlayerID, _FunctionName, ...)
    return self:ListConstructCustom("WallCustomRule", _PlayerID, _FunctionName, unpack(arg));
end

function Lib.Construction.Global:ListConstructArea(_List, _PlayerID, _Type, _Category, _X, _Y, _Area)
    local ID = self:GetNewRestrictionID();
    table.insert(self.Construction.Restriction[_List][_PlayerID], {
        ID = ID,
        Category = _Category,
        Type = _Type,
        Center = {X= _X, Y= _Y},
        Area = _Area,
    });
    self:MirrorConstructionRestrictionsToLocalScript();
    return ID;
end

function Lib.Construction.Global:ListConstructTerritory(_List, _PlayerID, _Type, _Category, _Territory)
    local ID = self:GetNewRestrictionID();
    table.insert(self.Construction.Restriction[_List][_PlayerID], {
        ID = ID,
        Category = _Category,
        Type = _Type,
        Territory = _Territory,
    });
    self:MirrorConstructionRestrictionsToLocalScript();
    return ID;
end

function Lib.Construction.Global:ListConstructCustom(_List, _PlayerID, _Rule, ...)
    local ID = self:GetNewRestrictionID();
    table.insert(self.Construction.Restriction[_List][_PlayerID], {
        ID = ID,
        Function = _Rule,
        Arguments = arg
    });
    self:MirrorConstructionRestrictionsToLocalScript();
    return ID;
end

function Lib.Construction.Global:GetNewRestrictionID()
    self.Construction.Restriction.Index = self.Construction.Restriction.Index + 1;
    local Index = self.Construction.Restriction.Index
    ExecuteLocal([[Lib.Construction.Local.Construction.Restriction.Index = %d]], Index);
    return Index;
end

function Lib.Construction.Global:MirrorConstructionRestrictionsToLocalScript()
    local Table = table.tostring(self.Construction.Restriction);
    ExecuteLocal([[Lib.Construction.Local.Construction.Restriction = %s]], Table);
end

function Lib.Construction.Global:UnlistConstruction(_ID)
    for List, PlayerData in pairs(self.Construction.Restriction) do
        for PlayerID = 1, 8 do
            for i= #PlayerData[PlayerID], 1, -1 do
                if PlayerData[PlayerID][i].ID == _ID then
                    table.remove(self.Construction.Restriction[List][PlayerID], 1);
                end
            end
        end
    end
    ExecuteLocal([[Lib.Construction.Local:UnlistConstruction(%d)]], _ID);
end

-- -------------------------------------------------------------------------- --

function Lib.Construction.Global:WhitelistKnockdownTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    return self:ListKnockdownArea("BuildingAreaWhitelist", _PlayerID, _Type, nil, _X, _Y, _Area);
end

function Lib.Construction.Global:WhitelistKnockdownCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    return self:ListKnockdownArea("BuildingAreaWhitelist", _PlayerID, nil, _Category, _X, _Y, _Area);
end

function Lib.Construction.Global:WhitelistKnockdownTypeInTerritory(_PlayerID, _Type, _Territory)
    return self:ListKnockdownTerritory("BuildingTerritoryWhitelist", _PlayerID, _Type, nil, _Territory);
end

function Lib.Construction.Global:WhitelistKnockdownCategoryInTerritory(_PlayerID, _Category, _Territory)
    return self:ListKnockdownTerritory("BuildingTerritoryWhitelist", _PlayerID, nil, _Category, _Territory);
end

function Lib.Construction.Global:BlacklistKnockdownTypeInArea(_PlayerID, _Type, _X, _Y, _Area)
    return self:ListKnockdownArea("BuildingAreaBlacklist", _PlayerID, _Type, nil, _X, _Y, _Area);
end

function Lib.Construction.Global:BlacklistKnockdownCategoryInArea(_PlayerID, _Category, _X, _Y, _Area)
    return self:ListKnockdownArea("BuildingAreaBlacklist", _PlayerID, nil, _Category, _X, _Y, _Area);
end

function Lib.Construction.Global:BlacklistKnockdownTypeInTerritory(_PlayerID, _Type, _Territory)
    return self:ListKnockdownTerritory("BuildingTerritoryBlacklist", _PlayerID, _Type, nil, _Territory);
end

function Lib.Construction.Global:BlacklistKnockdownCategoryInTerritory(_PlayerID, _Category, _Territory)
    return self:ListKnockdownTerritory("BuildingTerritoryBlacklist", _PlayerID, nil, _Category, _Territory);
end

function Lib.Construction.Global:CustomRuleKnockdownBuilding(_PlayerID, _FunctionName, ...)
    return self:ListKnockdownCustom("BuildingCustomRule", _PlayerID, _FunctionName, unpack(arg));
end

function Lib.Construction.Global:ListKnockdownArea(_List, _PlayerID, _Type, _Category, _X, _Y, _Area)
    local ID = self:GetNewProtectionID();
    table.insert(self.Knockdown.Restriction[_List][_PlayerID], {
        ID = ID,
        Category = _Category,
        Type = _Type,
        Center = {X= _X, Y= _Y},
        Area = _Area,
    });
    self:MirrorKnockdownRestrictionsToLocalScript();
    return ID;
end

function Lib.Construction.Global:ListKnockdownTerritory(_List, _PlayerID, _Type, _Category, _Territory)
    local ID = self:GetNewProtectionID();
    table.insert(self.Knockdown.Restriction[_List][_PlayerID], {
        ID = ID,
        Category = _Category,
        Type = _Type,
        Territory = _Territory,
    });
    self:MirrorKnockdownRestrictionsToLocalScript();
    return ID;
end

function Lib.Construction.Global:ListKnockdownCustom(_List, _PlayerID, _Rule, ...)
    local ID = self:GetNewRestrictionID();
    table.insert(self.Knockdown.Restriction[_List][_PlayerID], {
        ID = ID,
        Function = _Rule,
        Arguments = arg
    });
    self:MirrorKnockdownRestrictionsToLocalScript();
    return ID;
end

function Lib.Construction.Global:GetNewProtectionID()
    self.Knockdown.Restriction.Index = self.Knockdown.Restriction.Index + 1;
    local Index = self.Knockdown.Restriction.Index
    ExecuteLocal([[Lib.Construction.Local.Knockdown.Restriction.Index = %d]], Index);
    return Index;
end

function Lib.Construction.Global:MirrorKnockdownRestrictionsToLocalScript()
    local Table = table.tostring(self.Knockdown.Restriction);
    ExecuteLocal([[Lib.Construction.Local.Knockdown.Restriction = %s]], Table);
end

function Lib.Construction.Global:UnlistKnockdown(_ID)
    for List, PlayerData in pairs(self.Knockdown.Restriction) do
        for PlayerID = 1, 8 do
            for i= #PlayerData[PlayerID], 1, -1 do
                if PlayerData[PlayerID][i].ID == _ID then
                    table.remove(self.Knockdown.Restriction[List][PlayerID], 1);
                end
            end
        end
    end
    ExecuteLocal([[Lib.Construction.Local:UnlistKnockdown(%d)]], _ID);
end

-- -------------------------------------------------------------------------- --

function Lib.Construction.Global:IsConstructionAllowed(_PlayerID, _Type, _X, _Y)
    local Territory = Logic.GetTerritoryAtPosition(_X, _Y);
    local Categories = GetCategoriesOfType(_Type);

    -- Do explicitly allow types or categories in territory
    local TerritoryWhitelist = self.Construction.Restriction.BuildingTerritoryWhitelist[_PlayerID];
    if #TerritoryWhitelist > 0 then
        for k,v in pairs(TerritoryWhitelist) do
            if  (v.Type == _Type or table.contains(Categories, v.Category))
            and v.Territory == Territory then
                return true;
            end
        end
        return false;
    end
    -- Do explicitly allow types or categories in area
    local AreaWhitelist = self.Construction.Restriction.BuildingAreaWhitelist[_PlayerID];
    if #AreaWhitelist > 0 then
        for k,v in pairs(AreaWhitelist) do
            if  (v.Type == _Type or table.contains(Categories, v.Category))
            and v.Center and GetDistance({X=_X, Y= _Y}, v.Center) <= v.Area then
                return true;
            end
        end
        return false;
    end

    -- Do not allow types of categories in territory
    local TerritoryBlacklist = self.Construction.Restriction.BuildingTerritoryBlacklist[_PlayerID];
    for k,v in pairs(TerritoryBlacklist) do
        if  (v.Type == _Type or table.contains(Categories, v.Category))
        and v.Territory == Territory then
            return false;
        end
    end
    -- Do not allow types or categories in area
    local AreaBlacklist = self.Construction.Restriction.BuildingAreaBlacklist[_PlayerID];
    for k,v in pairs(AreaBlacklist) do
        if  (v.Type == _Type or table.contains(Categories, v.Category))
        and v.Center and GetDistance({X=_X, Y= _Y}, v.Center) <= v.Area then
            return false;
        end
    end

    -- Do not allow by custom function
    local CustomRule = self.Construction.Restriction.BuildingCustomRule[_PlayerID];
    for k,v in pairs(CustomRule) do
        if _G[v.Function] and not _G[v.Function](_PlayerID, _Type, _X, _Y, unpack(v.Arguments)) then
            return false;
        end
    end
    return true;
end

function Lib.Construction.Global:OverwriteGameCallbacks()
    self.Orig_GameCallback_CanPlayerPlaceBuilding = GameCallback_CanPlayerPlaceBuilding;
    GameCallback_CanPlayerPlaceBuilding = function( _PlayerID, _Type, _X, _Y )
        if Lib.Construction.Global:IsConstructionAllowed(_PlayerID, _Type, _X, _Y) then
            return Lib.Construction.Global.Orig_GameCallback_CanPlayerPlaceBuilding( _PlayerID, _Type, _X, _Y );
        end
        return false;
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Construction.Local:Initialize()
    if not self.IsInstalled then
        for i= 1, 8 do
            self.Construction.Restriction.BuildingCustomRule[i] = {};
            self.Construction.Restriction.BuildingTerritoryBlacklist[i] = {};
            self.Construction.Restriction.BuildingAreaBlacklist[i] = {};
            self.Construction.Restriction.BuildingTerritoryWhitelist[i] = {};
            self.Construction.Restriction.BuildingAreaWhitelist[i] = {};
            self.Construction.Restriction.RoadCustomRule[i] = {};
            self.Construction.Restriction.RoadTerritoryBlacklist[i] = {};
            self.Construction.Restriction.RoadAreaBlacklist[i] = {};
            self.Construction.Restriction.RoadTerritoryWhitelist[i] = {};
            self.Construction.Restriction.RoadAreaWhitelist[i] = {};
            self.Construction.Restriction.WallCustomRule[i] = {};
            self.Construction.Restriction.WallTerritoryBlacklist[i] = {};
            self.Construction.Restriction.WallAreaBlacklist[i] = {};
            self.Construction.Restriction.WallTerritoryWhitelist[i] = {};
            self.Construction.Restriction.WallAreaWhitelist[i] = {};
            self.Knockdown.Restriction.BuildingCustomRule[i] = {};
            self.Knockdown.Restriction.BuildingTerritoryBlacklist[i] = {};
            self.Knockdown.Restriction.BuildingAreaBlacklist[i] = {};
            self.Knockdown.Restriction.BuildingTerritoryWhitelist[i] = {};
            self.Knockdown.Restriction.BuildingAreaWhitelist[i] = {};
        end
        self:OverrideBuildButtonClicked();
        self:OverridePlacementUpdate();

        -- Garbage collection
        Lib.Construction.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Construction.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.Construction.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self:OverwriteGameCallbacks();

        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Construction.Local:UnlistConstruction(_ID)
    for List, PlayerData in pairs(self.Construction.Restriction) do
        for PlayerID = 1, 8 do
            for i= #PlayerData[PlayerID], 1, -1 do
                if PlayerData[PlayerID][i].ID == _ID then
                    table.remove(self.Construction.Restriction[List][PlayerID], 1);
                end
            end
        end
    end
end

function Lib.Construction.Local:UnlistKnockdown(_ID)
    for List, PlayerData in pairs(self.Knockdown.Restriction) do
        for PlayerID = 1, 8 do
            for i= #PlayerData[PlayerID], 1, -1 do
                if PlayerData[PlayerID][i].ID == _ID then
                    table.remove(self.Knockdown.Restriction[List][PlayerID], 1);
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Construction.Local:IsKnockdownAllowed(_PlayerID, _EntityID, _State)
    local Type = Logic.GetEntityType(_EntityID);
    local x,y,z = Logic.EntityGetPos(_EntityID);
    local Territory = GetTerritoryUnderEntity(_EntityID);
    local Categories = GetCategoriesOfType(Type);

    -- Do explicitly allow types or categories in territory
    local TerritoryWhitelist = self.Knockdown.Restriction.BuildingTerritoryWhitelist[_PlayerID];
    if #TerritoryWhitelist > 0 then
        for k,v in pairs(TerritoryWhitelist) do
            if  (v.Type == Type or table.contains(Categories, v.Category))
            and v.Territory == Territory then
                return true;
            end
        end
        return false;
    end
    -- Do explicitly allow types or categories in area
    local AreaWhitelist = self.Knockdown.Restriction.BuildingAreaWhitelist[_PlayerID];
    if #AreaWhitelist > 0 then
        for k,v in pairs(AreaWhitelist) do
            if  (v.Type == Type or table.contains(Categories, v.Category))
            and v.Center and GetDistance({X= x, Y= y}, v.Center) <= v.Area then
                return true;
            end
        end
        return false;
    end

    -- Do not allow types of categories in territory
    local TerritoryBlacklist = self.Knockdown.Restriction.BuildingTerritoryBlacklist[_PlayerID];
    for k,v in pairs(TerritoryBlacklist) do
        if  (v.Type == Type or table.contains(Categories, v.Category))
        and v.Territory == Territory then
            return false;
        end
    end
    -- Do not allow types or categories in area
    local AreaBlacklist = self.Knockdown.Restriction.BuildingAreaBlacklist[_PlayerID];
    for k,v in pairs(AreaBlacklist) do
        if  (v.Type == Type or table.contains(Categories, v.Category))
        and v.Center and GetDistance({X= x, Y= y}, v.Center) <= v.Area then
            return false;
        end
    end

    -- Do not allow by custom function
    local CustomRule = self.Knockdown.Restriction.BuildingCustomRule[_PlayerID];
    for k,v in pairs(CustomRule) do
        if _G[v.Function] and not _G[v.Function](_PlayerID, _EntityID, x, y, unpack(v.Arguments)) then
            return false;
        end
    end
    return true;
end

function Lib.Construction.Local:OverwriteGameCallbacks()
    self.Orig_GameCallback_GUI_DeleteEntityStateBuilding = GameCallback_GUI_DeleteEntityStateBuilding;
    GameCallback_GUI_DeleteEntityStateBuilding = function(_BuildingID, _State)
        local PlayerID = Logic.EntityGetPlayer(_BuildingID);
        if not Lib.Construction.Local:IsKnockdownAllowed(PlayerID, _BuildingID, _State) then
            Message(Localize(Lib.Construction.Text.NoKnockdown));
            GUI.CancelBuildingKnockDown(_BuildingID);
            return;
        end
        Lib.Construction.Local.Orig_GameCallback_GUI_DeleteEntityStateBuilding(_BuildingID, _State);
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Construction.Local:OverrideBuildButtonClicked()
    self.Orig_BuildClicked = GUI_Construction.BuildClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Construction.BuildClicked = function(_BuildingType)
        Lib.Construction.Local.LastSelectedBuildingType = _BuildingType;
        Lib.Construction.Local.Orig_BuildClicked(_BuildingType);
    end

    self.Orig_BuildStreetClicked = GUI_Construction.BuildStreetClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Construction.BuildStreetClicked = function(_IsTrail)
        _IsTrail = (_IsTrail ~= nil and _IsTrail) or false;
        Lib.Construction.Local.LastSelectedRoadType = _IsTrail;
        Lib.Construction.Local.Orig_BuildStreetClicked(_IsTrail);
    end

    self.Orig_BuildWallClicked = GUI_Construction.BuildWallClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Construction.BuildWallClicked = function(_BuildingType)
        if _BuildingType == nil then
            _BuildingType = GetUpgradeCategoryForClimatezone("WallSegment");
        end
        Lib.Construction.Local.LastSelectedBuildingType = _BuildingType;
        Lib.Construction.Local.Orig_BuildWallClicked(_BuildingType);
    end

    self.Orig_BuildWallGateClicked = GUI_Construction.BuildWallGateClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Construction.BuildWallGateClicked = function(_BuildingType)
        if _BuildingType == nil then
            _BuildingType = GetUpgradeCategoryForClimatezone("WallGate");
        end
        Lib.Construction.Local.LastSelectedBuildingType = _BuildingType;
        Lib.Construction.Local.Orig_BuildWallGateClicked(_BuildingType);
    end

    self.Orig_PlaceFieldClicked = GUI_BuildingButtons.PlaceFieldClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.PlaceFieldClicked = function()
        -- TODO: Implement anti crops spam
        local EntityType = Logic.GetEntityType(GUI.GetSelectedEntity());
        Lib.Construction.Local.LastSelectedBuildingType = EntityType;
        Lib.Construction.Local.Orig_PlaceFieldClicked();
    end
end

function Lib.Construction.Local:OverridePlacementUpdate()
    self.Orig_GameCallBack_GUI_ConstructWallSegmentCountChanged = GameCallBack_GUI_ConstructWallSegmentCountChanged;
    GameCallBack_GUI_ConstructWallSegmentCountChanged = function(_SegmentType, _TurretType)
        self.Orig_GameCallBack_GUI_ConstructWallSegmentCountChanged(_SegmentType, _TurretType);
        Lib.Construction.Local:CancleConstructWallSegmentState(GUI.GetPlayerID(), _SegmentType, _TurretType);
    end

    self.Orig_GameCallBack_GUI_BuildRoadCostChanged = GameCallBack_GUI_BuildRoadCostChanged;
    GameCallBack_GUI_BuildRoadCostChanged = function(_Length)
        self.Orig_GameCallBack_GUI_BuildRoadCostChanged(_Length);
        Lib.Construction.Local:CancleConstructRoad(GUI.GetPlayerID(), _Length);
    end

    self.Orig_PlacementUpdate = GUI_Construction.PlacementUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Construction.PlacementUpdate = function()
        Lib.Construction.Local.Orig_PlacementUpdate();
        Lib.Construction.Local:CancleConstructWallGateState(GUI.GetPlayerID());
    end

    self.Orig_UpgradeTurretClicked = GUI_BuildingButtons.UpgradeTurretClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.UpgradeTurretClicked = function()
        local EntityID = GUI.GetSelectedEntity();
        local PlayerID = Logic.EntityGetPlayer(EntityID);
        local x,y,z = Logic.EntityGetPos(EntityID)
        if Lib.Construction.Local:AreOtherBallistasToCloseToPosition(PlayerID, x, y, 2500) then
            Message(Localize(Lib.Construction.Text.NoBallista));
            return;
        end
        Lib.Construction.Local.Orig_UpgradeTurretClicked();
    end
end

function Lib.Construction.Local:AreOtherBallistasToCloseToPosition(_PlayerID, _x, _y, _AreaSize)
    if self.Construction.ForceBallistaDistance then
        local nSite, SiteID = Logic.GetPlayerEntitiesInArea(_PlayerID, Entities.U_MilitaryBallista_BuildingSite, _x, _y, _AreaSize, 1);
        local nBallista, BallistaID = Logic.GetPlayerEntitiesInArea(_PlayerID, Entities.U_MilitaryBallista, _x, _y, _AreaSize, 1);
        return (nSite + nBallista) > 0;
    end
    return false;
end

function Lib.Construction.Local:CancleConstructWallSegmentState(_PlayerID, _SegmentType, _TurretType)
    local GuiState = GUI.GetCurrentStateID();
    if g_Construction.CurrentPlacementType == 3 then
        local Costs = {Logic.GetCostForWall(_SegmentType, _TurretType, StartTurretX, StartTurretY, EndTurretX, EndTurretY)}
        if GuiState == 2 and Costs[1] and Costs[2] > 0 then
            local x, y = GUI.Debug_GetMapPositionUnderMouse();
            Lib.Construction.Local:CancleConstructWallState(_PlayerID, self.LastSelectedBuildingType, x, y);
        end
    end
end

function Lib.Construction.Local:CancleConstructWallGateState(_PlayerID)
    local GuiState = GUI.GetCurrentStateID();
    if g_Construction.CurrentPlacementType == 4 then
        if GuiState == 3 then
            local x, y = GUI.Debug_GetMapPositionUnderMouse();
            Lib.Construction.Local:CancleConstructWallState(_PlayerID, self.LastSelectedBuildingType, x, y);
        end
    end
end

function Lib.Construction.Local:CancleConstructWallState(_PlayerID, _Type, _X, _Y)
    local Territory = Logic.GetTerritoryAtPosition(_X or 1, _Y or 1);

    -- Cancel build walls if not whitelisted for territory
    local TerritoryWhitelist = self.Construction.Restriction.WallTerritoryWhitelist[_PlayerID];
    if #TerritoryWhitelist > 0 then
        for k,v in pairs(TerritoryWhitelist) do
            if v.Type == true then
                if  string.find(Logic.GetEntityTypeName(_Type), "B_Wall")
                and v.Territory == Territory then
                    return;
                end
            else
                if  (_Type == Entities.B_PalisadeSegment or _Type == Entities.B_PalisadeGate)
                and v.Territory == Territory then
                    return;
                end
            end
        end
        self:CancelState(g_Construction.CurrentPlacementType);
    end
    -- Cancel build walls if not whitelisted for area
    local AreaWhitelist = self.Construction.Restriction.WallAreaWhitelist[_PlayerID];
    if #AreaWhitelist > 0 then
        for k,v in pairs(TerritoryWhitelist) do
            if v.Type == true then
                if  string.find(Logic.GetEntityTypeName(_Type), "B_Wall")
                and v.Center and GetDistance({X= _X, Y= _Y}, v.Center) <= v.Area then
                    return;
                end
            else
                if  (_Type == Entities.B_PalisadeSegment or _Type == Entities.B_PalisadeGate)
                and v.Center and GetDistance({X= _X, Y= _Y}, v.Center) <= v.Area then
                    return;
                end
            end
        end
        self:CancelState(g_Construction.CurrentPlacementType);
    end

    -- Cancel build walls if blacklisted for territory
    local TerritoryBlacklist = self.Construction.Restriction.WallTerritoryBlacklist[_PlayerID];
    if true then
        for k,v in pairs(TerritoryBlacklist) do
            if v.Type == true then
                if  string.find(Logic.GetEntityTypeName(_Type), "B_Wall")
                and v.Territory == Territory then
                    self:CancelState(g_Construction.CurrentPlacementType);
                    return;
                end
            else
                if  (_Type == Entities.B_PalisadeSegment or _Type == Entities.B_PalisadeGate)
                and v.Territory == Territory then
                    self:CancelState(g_Construction.CurrentPlacementType);
                    return;
                end
            end
        end
    end
    -- Cancel build walls if blacklisted for area
    local AreaBlacklist = self.Construction.Restriction.WallAreaBlacklist[_PlayerID];
    if true then
        for k,v in pairs(AreaBlacklist) do
            if v.Type == true then
                if  string.find(Logic.GetEntityTypeName(_Type), "B_Wall")
                and v.Center and GetDistance({X= _X, Y= _Y}, v.Center) <= v.Area then
                    self:CancelState(g_Construction.CurrentPlacementType);
                    return;
                end
            else
                if  (_Type == Entities.B_PalisadeSegment or _Type == Entities.B_PalisadeGate)
                and v.Center and GetDistance({X= _X, Y= _Y}, v.Center) <= v.Area then
                    self:CancelState(g_Construction.CurrentPlacementType);
                    return;
                end
            end
        end
    end

    -- Cancel build walls by custom function
    local CustomRule = self.Construction.Restriction.WallCustomRule[_PlayerID];
    for k,v in pairs(CustomRule) do
        local IsWall = string.find(Logic.GetEntityTypeName(_Type), "B_Wall") ~= nil;
        if _G[v.Function] and not _G[v.Function](_PlayerID, IsWall, _X, _Y, unpack(v.Arguments)) then
            self:CancelState(g_Construction.CurrentPlacementType);
            return;
        end
    end
end

function Lib.Construction.Local:CancleConstructRoad(_PlayerID, _Length)
    local GuiState = GUI.GetCurrentStateID();
    local x,y = GUI.Debug_GetMapPositionUnderMouse();
    local Territory = Logic.GetTerritoryAtPosition(x or 1, y or 1);


    -- Check placing roads
    if g_Construction.CurrentPlacementType == 1 then
        if GuiState == 5 and _Length > 0 then
            local IsRoad = not self.LastSelectedRoadType;

            -- Allow roads only in territoty
            local TerritoryWhitelist = self.Construction.Restriction.RoadTerritoryWhitelist[_PlayerID];
            if #TerritoryWhitelist > 0 then
                for k,v in pairs(TerritoryWhitelist) do
                    if v.Type == IsRoad and v.Territory == Territory then
                        return;
                    end
                end
                self:CancelState(g_Construction.CurrentPlacementType);
            end
            -- Allow roads only in area
            local AreaWhitelist = self.Construction.Restriction.RoadAreaWhitelist[_PlayerID];
            if #AreaWhitelist > 0 then
                for k,v in pairs(AreaWhitelist) do
                    if v.Type == IsRoad and v.Center and GetDistance({X= x, Y= y}, v.Center) <= v.Area then
                        return;
                    end
                end
                self:CancelState(g_Construction.CurrentPlacementType);
            end

            -- Forbid roads in territory
            local TerritoryBlacklist = self.Construction.Restriction.RoadTerritoryBlacklist[_PlayerID];
            for k,v in pairs(TerritoryBlacklist) do
                if v.Type == IsRoad and v.Territory == Territory then
                    self:CancelState(g_Construction.CurrentPlacementType);
                    return;
                end
            end
            -- Forbid roads in area
            local AreaBlacklist = self.Construction.Restriction.RoadAreaBlacklist[_PlayerID];
            for k,v in pairs(AreaBlacklist) do
                if v.Type == IsRoad and v.Center and GetDistance({X= x, Y= y}, v.Center) <= v.Area then
                    self:CancelState(g_Construction.CurrentPlacementType);
                    return;
                end
            end

            -- Cancel build walls by custom function
            local CustomRule = self.Construction.Restriction.RoadCustomRule[_PlayerID];
            for k,v in pairs(CustomRule) do
                if _G[v.Function] and not _G[v.Function](_PlayerID, IsRoad, x, y, unpack(v.Arguments)) then
                    self:CancelState(g_Construction.CurrentPlacementType);
                    return;
                end
            end
        end
    end
end

function Lib.Construction.Local:CancelState(_PlacementType)
    local Text = Lib.Construction.Text.NoWall;
    if _PlacementType == 1 then
        Text = Lib.Construction.Text.NoRoad;
    elseif _PlacementType == -1 then
        Text = Lib.Construction.Text.NoWallGate;
    end
    Message(Localize(Text));
    GUI.CancelState();
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Construction.Name);

