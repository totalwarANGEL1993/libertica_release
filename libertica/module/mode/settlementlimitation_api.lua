Lib.Require("comfort/IsLocalScript");
Lib.Register("module/mode/SettlementLimitation_API");

function ActivateSettlementLimitation(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("ActivateSettlementLimitation(%s)", tostring(_Flag == true));
    end
    Lib.SettlementLimitation.AquireContext();
    this.Active = true;
    Lib.SettlementLimitation.ReleaseContext();
end

function SetTerritoryBuildingLimit(_PlayerID, _Territory, _Limit)
    local TerritoryID = GetTerritoryID(_Territory);
    if not IsLocalScript() then
        ExecuteLocal("SetTerritoryBuildingLimit(%d,%d,%d)", _PlayerID, TerritoryID, _Limit);
    end
    Lib.SettlementLimitation.AquireContext();
    this.TerritoryRestriction[_PlayerID][TerritoryID] = _Limit;
    Lib.SettlementLimitation.ReleaseContext();
end

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

function ClearTerritoryBuildingLimit(_PlayerID, _Territory)
    local TerritoryID = GetTerritoryID(_Territory);
    if not IsLocalScript() then
        ExecuteLocal("SetTerritoryBuildingTypeLimit(%d,%d)", _PlayerID, TerritoryID);
    end
    Lib.SettlementLimitation.AquireContext();
    this.TerritoryRestriction[_PlayerID][TerritoryID] = nil;
    Lib.SettlementLimitation.ReleaseContext();
end

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
    this.UpgradeTerritoryCosts = {_CostType1, _Amount1, _CostType2, _Amount2};
    Lib.SettlementLimitation.ReleaseContext();
end

