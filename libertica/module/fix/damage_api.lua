Lib.Require("comfort/IsLocalScript");
Lib.Register("module/fix/Damage_API");

function SetEntityTypeDamage(_Type, _Damage, ...)
    assert(not IsLocalScript());
    assert(type(_Damage) == "number");
    local Categories = {...};

    Lib.Damage.AquireContext();
    this.EntityTypeDamage[_Type] = this.EntityTypeDamage[_Type] or {};
    if #Categories ~= 0 then
        for i= 1, #Categories do
            this.EntityTypeDamage[_Type][Categories[i]] = _Damage;
        end
    else
        this.EntityTypeDamage[_Type][0] = _Damage;
    end
    Lib.Damage.ReleaseContext();
end
API.SetEntityTypeDamage = SetEntityTypeDamage;

function SetEntityNameDamage(_Name, _Damage, ...)
    assert(not IsLocalScript());
    assert(type(_Damage) == "number");
    local Categories = {...};

    Lib.Damage.AquireContext();
    this.EntityNameDamage[_Name] = this.EntityNameDamage[_Name] or {};
    if #Categories ~= 0 then
        for i= 1, #Categories do
            this.EntityNameDamage[_Name][Categories[i]] = _Damage;
        end
    else
        this.EntityNameDamage[_Name][0] = _Damage;
    end
    Lib.Damage.ReleaseContext();
end
API.SetEntityNameDamage = SetEntityNameDamage;

function SetEntityTypeArmor(_Type, _Armor)
    assert(not IsLocalScript());
    assert(type(_Armor) == "number");
    Lib.Damage.AquireContext();
    this.EntityTypeArmor[_Type] = _Armor;
    Lib.Damage.ReleaseContext();
end
API.SetEntityTypeArmor = SetEntityTypeArmor;

function SetEntityNameArmor(_Name, _Armor)
    assert(not IsLocalScript());
    assert(type(_Armor) == "number");
    Lib.Damage.AquireContext();
    this.EntityNameArmor[_Name] = _Armor;
    Lib.Damage.ReleaseContext();
end
API.SetEntityNameArmor = SetEntityNameArmor;

function SetTerritoryBonus(_PlayerID, _Bonus)
    assert(not IsLocalScript());
    assert(type(_Bonus) == "number");
    Lib.Damage.AquireContext();
    this.TerritoryBonus[_PlayerID] = _Bonus or 1;
    Lib.Damage.ReleaseContext();
end
API.SetTerritoryBonus = SetTerritoryBonus;

function SetHeightModifier(_PlayerID, _Bonus)
    assert(not IsLocalScript());
    assert(type(_Bonus) == "number");
    Lib.Damage.AquireContext();
    this.HeightModifier[_PlayerID] = _Bonus or 1;
    Lib.Damage.ReleaseContext();
end
API.SetHeightModifier = SetHeightModifier;

function IsInvulnerable(_Entity)
    local Result = false;
    if not IsLocalScript() then
        Lib.Damage.AquireContext();
        Result = this.InvulnerableList[GetID(_Entity)] ~= nil;
        Lib.Damage.ReleaseContext();
    end
    return Result;
end
API.IsInvulnerable = IsInvulnerable;

