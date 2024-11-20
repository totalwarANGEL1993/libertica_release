Lib.Require("comfort/IsLocalScript");
Lib.Register("module/mode/SettlementLimitation_API");

function ActivateSettlementLimitation(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("ActivateSettlementLimitation(%s)", tostring(_Flag == true));
    end
    Lib.SettlementLimitation.AquireContext();
    this.Active = _Flag == true;
    Lib.SettlementLimitation.ReleaseContext();
end
API.ActivateSettlementLimitation = ActivateSettlementLimitation;

function UseWallUpkeepCosts(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("UseWallUpkeepCosts(%s)", tostring(_Flag == true));
    end
    Lib.SettlementLimitation.AquireContext();
    this.WallUpkeepCosts = _Flag == true;
    Lib.SettlementLimitation.ReleaseContext();
end
API.UseWallUpkeepCosts = UseWallUpkeepCosts;

function UseWallDeteriation(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("UseWallDeteriation(%s)", tostring(_Flag == true));
    end
    Lib.SettlementLimitation.AquireContext();
    this.WallDeteriation = _Flag == true;
    Lib.SettlementLimitation.ReleaseContext();
end
API.UseWallDeteriation = UseWallDeteriation;

function RequireTitleToDevelopTerritory(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], 1, Technologies.R_RuralLogistics)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], 1, Technologies.R_RuralLogistics);
    CreateTechnologyKnightTitleTable()
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_RuralLogistics, 0);
    end
end
API.RequireTitleToDevelopTerritory = RequireTitleToDevelopTerritory;

function AllowDevelopTerritory(_PlayerID, _Allowed)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Logic.TechnologySetState(_PlayerID, Technologies.R_RuralLogistics, (_Allowed and 3 or 1));
end
API.AllowDevelopTerritory = AllowDevelopTerritory;

function SetTerritoryBuildingLimit(_PlayerID, _Territory, _Limit)
    local TerritoryID = GetTerritoryID(_Territory);
    if not IsLocalScript() then
        ExecuteLocal("SetTerritoryBuildingLimit(%d,%d,%d)", _PlayerID, TerritoryID, _Limit);
    end
    Lib.SettlementLimitation.AquireContext();
    this.TerritoryRestriction[_PlayerID][TerritoryID] = _Limit;
    Lib.SettlementLimitation.ReleaseContext();
end
API.SetTerritoryBuildingLimit = SetTerritoryBuildingLimit;

function SetTerritoryBuildingTypeLimit(_PlayerID, _Territory, _Type, _Limit)
    local TerritoryID = GetTerritoryID(_Territory);
    if not IsLocalScript() then
        ExecuteLocal("SetTerritoryBuildingTypeLimit(%d,%d,%d,%d)", _PlayerID, TerritoryID, _Type, _Limit);
    end
    Lib.SettlementLimitation.AquireContext();
    if not this.TerritoryTypeRestriction[_PlayerID][TerritoryID] then
        this.TerritoryTypeRestriction[_PlayerID][TerritoryID] = {};
    end
    this.TerritoryTypeRestriction[_PlayerID][TerritoryID][_Type] = _Limit;
    Lib.SettlementLimitation.ReleaseContext();
end
API.SetTerritoryBuildingTypeLimit = SetTerritoryBuildingTypeLimit;

function ClearTerritoryBuildingLimit(_PlayerID, _Territory)
    local TerritoryID = GetTerritoryID(_Territory);
    if not IsLocalScript() then
        ExecuteLocal("SetTerritoryBuildingTypeLimit(%d,%d)", _PlayerID, TerritoryID);
    end
    Lib.SettlementLimitation.AquireContext();
    this.TerritoryRestriction[_PlayerID][TerritoryID] = nil;
    Lib.SettlementLimitation.ReleaseContext();
end
API.ClearTerritoryBuildingLimit = ClearTerritoryBuildingLimit;

function ClearTerritoryBuildingTypeLimit(_PlayerID, _Territory, _Type)
    local TerritoryID = GetTerritoryID(_Territory);
    if not IsLocalScript() then
        ExecuteLocal("ClearTerritoryBuildingTypeLimit(%d,%d,%d)", _PlayerID, TerritoryID, _Type);
    end
    Lib.SettlementLimitation.AquireContext();
    if not this.TerritoryTypeRestriction[_PlayerID][TerritoryID] then
        this.TerritoryTypeRestriction[_PlayerID][TerritoryID] = {};
    end
    this.TerritoryTypeRestriction[_PlayerID][TerritoryID][_Type] = nil;
    Lib.SettlementLimitation.ReleaseContext();
end
API.ClearTerritoryBuildingTypeLimit = ClearTerritoryBuildingTypeLimit;

function SetTerritoryDevelopmentCost(_CostType1, _Amount1, _CostType2, _Amount2)
    if not IsLocalScript() then
        ExecuteLocal(
            "SetTerritoryDevelopmentCost(%s,%s,%s,%s)",
            tostring(_CostType1),
            tostring(_Amount1),
            tostring(_CostType2 or nil),
            tostring(_Amount2 or nil)
        );
    end
    Lib.SettlementLimitation.AquireContext();
    this.DevelopTerritoryCosts = {_CostType1, _Amount1, _CostType2, _Amount2};
    Lib.SettlementLimitation.ReleaseContext();
end
API.SetTerritoryDevelopmentCost = SetTerritoryDevelopmentCost;

function AddToBuildingTerritoryBlacklist(_Type, _Territory)
    Lib.SettlementLimitation.Global:AddToBuildingTerritoryBlacklist(_Type, _Territory);
end
API.AddToBuildingTerritoryBlacklist = AddToBuildingTerritoryBlacklist;

function AddToBuildingTerritoryWhitelist(_Type, _Territory)
    Lib.SettlementLimitation.Global:AddToBuildingTerritoryWhitelist(_Type, _Territory);
end
API.AddToBuildingTerritoryWhitelist = AddToBuildingTerritoryWhitelist;

function RemoveFromBuildingTerritoryBlacklist(_Type, _Territory)
    Lib.SettlementLimitation.Global:RemoveFromBuildingTerritoryBlacklist(_Type, _Territory);
end
API.RemoveFromBuildingTerritoryBlacklist = RemoveFromBuildingTerritoryBlacklist;

function RemoveFromBuildingTerritoryWhitelist(_Type, _Territory)
    Lib.SettlementLimitation.Global:RemoveFromBuildingTerritoryWhitelist(_Type, _Territory);
end
API.RemoveFromBuildingTerritoryWhitelist = RemoveFromBuildingTerritoryWhitelist;

function ActivateOutpostLimit(_Flag)
    Lib.SettlementLimitation.Global:ActivateOutpostLimit(_Flag);
end
API.ActivateOutpostLimit = ActivateOutpostLimit;

function SetOutpostLimit(_UpgradeLevel, _Limit)
    Lib.SettlementLimitation.Global:SetOutpostLimit(_UpgradeLevel, _Limit);
end
API.SetOutpostLimit = SetOutpostLimit;

