Lib.Require("comfort/IsLocalScript");
Lib.Register("module/city/MilitiaSystem_API");

function ActivateMilitia()
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal("Lib.MilitiaSystem.Local:ActivateMilitia()");
end
API.ActivateMilitia = ActivateMilitia;

function DeactivateMilitia()
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal("Lib.MilitiaSystem.Local:DeactivateMilitia()");
end
API.DeactivateMilitia = DeactivateMilitia;

function ActivateMilitiaSkills()
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal("Lib.MilitiaSystem.Shared:ActivateUnitTypeSkills()");
    Lib.MilitiaSystem.Shared:ActivateUnitTypeSkills();
end
API.ActivateMilitiaSkills = ActivateMilitiaSkills;

function DeactivateMilitiaSkills()
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal("Lib.MilitiaSystem.Shared:DeactivateUnitTypeSkills()");
    Lib.MilitiaSystem.Shared:DeactivateUnitTypeSkills();
end
API.DeactivateMilitiaSkills = DeactivateMilitiaSkills;

function UseDefaultMilitiaTypes(_PlayerID)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal("Lib.MilitiaSystem.Shared:SetDefaultUnitTypeAllocation(%d)", _PlayerID);
    Lib.MilitiaSystem.Shared:SetDefaultUnitTypeAllocation(_PlayerID);
end
API.UseDefaultMilitiaTypes = UseDefaultMilitiaTypes;

function UseDefaultMilitiaTypesForAllPlayers()
    assert(not IsLocalScript(), "Can not be used in local script!");
    for PlayerID = 1, 8 do
        UseDefaultMilitiaTypes(PlayerID);
    end
end
API.UseDefaultMilitiaTypesForAllPlayers = UseDefaultMilitiaTypesForAllPlayers;

function UseRandomMilitiaTypes(_PlayerID)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal("Lib.MilitiaSystem.Shared:SetRandomUnitTypeAllocation(%d)", _PlayerID);
    Lib.MilitiaSystem.Shared:SetRandomUnitTypeAllocation(_PlayerID);
end
API.UseRandomMilitiaTypes = UseRandomMilitiaTypes;

function UseRandomMilitiaTypesForAllPlayers()
    assert(not IsLocalScript(), "Can not be used in local script!");
    for PlayerID = 1, 8 do
        UseRandomMilitiaTypes(PlayerID);
    end
end
API.UseRandomMilitiaTypesForAllPlayers = UseRandomMilitiaTypesForAllPlayers;

function UseOnlyIdlingWorkersForMilitia()
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[Lib.MilitiaSystem.Shared.ConscriptConfig = "%s"]], "Idle");
    Lib.MilitiaSystem.Shared.ConscriptConfig = "Idle";
end
API.UseOnlyIdlingWorkersForMilitia = UseOnlyIdlingWorkersForMilitia;

function UseAllWorkersForMilitia()
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[Lib.MilitiaSystem.Shared.ConscriptConfig = "%s"]], "Work");
    Lib.MilitiaSystem.Shared.ConscriptConfig = "Work";
end
API.UseAllWorkersForMilitia = UseAllWorkersForMilitia;

function SetMilitiaUnitCosts(_Type, _Good1, _Amount1, _Good2, _Amount2)
    assert(not IsLocalScript(), "Can not be used in local script!");
    assert(_Good1 ~= nil);
    assert(_Amount1 ~= nil and _Amount1 > 0);
    if _Good2 then
        assert(_Amount2 ~= nil and _Amount2 > 0);
    end
    local TypeName = Logic.GetEntityTypeName(_Type);
    Lib.MilitiaSystem.Config.UnitCosts[TypeName] = {_Good1, _Amount1, _Good2, _Amount2};
    ExecuteLocal(
        [[Lib.MilitiaSystem.Config.UnitCosts["%s"] = {%s, %s, %s, %s}]],
        tostring(_Good1), tostring(_Amount1), tostring(_Good2), tostring(_Amount2)
    )
end
API.UseAllWorkersForMilitia = UseAllWorkersForMilitia;

function RequireTitleForMeleeMilitia(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Tech = Technologies.R_Mercenary_Melee;
    Lib.MilitiaSystem.Global:SetRequiredRank(_Title, Tech);
end
API.RequireTitleForMeleeMilitia = RequireTitleForMeleeMilitia;

function RequireTitleForRangedMilitia(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Tech = Technologies.R_Mercenary_Ranged;
    Lib.MilitiaSystem.Global:SetRequiredRank(_Title, Tech);
end
API.RequireTitleForRangedMilitia = RequireTitleForRangedMilitia;

