Lib.Require("comfort/IsLocalScript");
Lib.Register("module/balancing/Damage_API");

function SetEntityTypeDamage(_Type, _Damage, ...)
    Lib.Damage.Global:SetEntityTypeDamage(_Type, _Damage, ...);
end
API.SetEntityTypeDamage = SetEntityTypeDamage;

function SetEntityNameDamage(_Name, _Damage, ...)
    Lib.Damage.Global:SetEntityNameDamage(_Name, _Damage, ...);
end
API.SetEntityNameDamage = SetEntityNameDamage;

function SetEntityTypeArmor(_Type, _Armor)
    Lib.Damage.Global:SetEntityTypeArmor(_Type, _Armor);
end
API.SetEntityTypeArmor = SetEntityTypeArmor;

function SetEntityNameArmor(_Name, _Armor)
    Lib.Damage.Global:SetEntityNameArmor(_Name, _Armor);
end
API.SetEntityNameArmor = SetEntityNameArmor;

function SetTerritoryBonus(_PlayerID, _Bonus)
    Lib.Damage.Global:SetTerritoryBonus(_PlayerID, _Bonus);
end
API.SetTerritoryBonus = SetTerritoryBonus;

function SetHeightModifier(_PlayerID, _Bonus)
    Lib.Damage.Global:SetHeightModifier(_PlayerID, _Bonus);
end
API.SetHeightModifier = SetHeightModifier;

function IsInvulnerable(_Entity)
    return Lib.Damage.Global:IsInvulnerable(_Entity);
end
API.IsInvulnerable = IsInvulnerable;

