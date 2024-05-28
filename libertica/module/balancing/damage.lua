Lib.Damage = Lib.Damage or {};
Lib.Damage.Name = "Damage";
Lib.Damage.Global = {
    InvulnerableList = {},
    --
    EntityTypeDamage = {},
    EntityNameDamage = {},
    EntityTypeArmor = {},
    EntityNameArmor = {},
    --
    TerritoryBonus = {},
    HeightModifier = {},
};
Lib.Damage.Local  = {};

Lib.Require("core/Core");
Lib.Require("module/entity/EntityEvent");
Lib.Require("module/balancing/Damage_API");
Lib.Register("module/balancing/Damage");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Damage.Global:Initialize()
    if not self.IsInstalled then
        for PlayerID = 0, 8 do
            self.TerritoryBonus[PlayerID] = 1;
            self.HeightModifier[PlayerID] = 1;
        end
        self:OverwriteVulnerabilityFunctions();
        self:InitEntityBaseDamage();

        -- Garbage collection
        Lib.Damage.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Damage.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Damage.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.EntityDestroyed then
        self.InvulnerableList[arg[1]] = nil;
    elseif _ID == Report.EntityHurt then
        self:OnEntityHurtEntity(arg[1], arg[2], arg[3], arg[4]);
    end
end

function Lib.Damage.Global:SetEntityTypeDamage(_Type, _Damage, ...)
    assert(type(_Damage) == "number");
    local Categories = {...};
    self.EntityTypeDamage[_Type] = self.EntityTypeDamage[_Type] or {};
    if #Categories == 0 then
        self.EntityTypeDamage[_Type][0] = _Damage;
        return;
    end
    for i= 1, #Categories do
        self.EntityTypeDamage[_Type][Categories[i]] = _Damage;
    end
end

function Lib.Damage.Global:SetEntityNameDamage(_Name, _Damage, ...)
    assert(type(_Damage) == "number");
    local Categories = {...};
    self.EntityNameDamage[_Name] = self.EntityNameDamage[_Name] or {};
    if #Categories == 0 then
        self.EntityNameDamage[_Name][0] = _Damage;
        return;
    end
    for i= 1, #Categories do
        self.EntityNameDamage[_Name][Categories[i]] = _Damage;
    end
end

function Lib.Damage.Global:SetEntityTypeArmor(_Type, _Armor)
    assert(type(_Armor) == "number");
    self.EntityTypeArmor[_Type] = _Armor;
end

function Lib.Damage.Global:SetEntityNameArmor(_Name, _Armor)
    assert(type(_Armor) == "number");
    self.EntityNameArmor[_Name] = _Armor;
end

function Lib.Damage.Global:SetTerritoryBonus(_PlayerID, _Bonus)
    assert(type(_Bonus) == "number");
    self.TerritoryBonus[_PlayerID] = _Bonus or 1;
end

function Lib.Damage.Global:SetHeightModifier(_PlayerID, _Bonus)
    assert(type(_Bonus) == "number");
    self.HeightModifier[_PlayerID] = _Bonus or 1;
end

function Lib.Damage.Global:IsInvulnerable(_Entity)
    return self.InvulnerableList[GetID(_Entity)] ~= nil;
end

function Lib.Damage.Global:InitEntityBaseDamage()
    self:SetEntityTypeDamage(Entities.U_MilitaryBow, 20);
    self:SetEntityTypeDamage(Entities.U_MilitaryBow, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBow_RedPrince, 20);
    self:SetEntityTypeDamage(Entities.U_MilitaryBow_RedPrince, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitarySword, 30);
    self:SetEntityTypeDamage(Entities.U_MilitarySword, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitarySword_RedPrince, 30);
    self:SetEntityTypeDamage(Entities.U_MilitarySword_RedPrince, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    --
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_ME, 30);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_ME, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_ME, 20);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_ME, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_NA, 30);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_NA, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_NA, 20);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_NA, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_NE, 30);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_NE, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_NE, 20);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_NE, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_SE, 30);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_SE, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_SE, 20);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_SE, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    --
    self:SetEntityTypeDamage(Entities.U_MilitaryBallista, 50);
    self:SetEntityTypeDamage(Entities.U_MilitaryBallista, 10,
        EntityCategories.CityWallGate
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryCatapult, 50);
    self:SetEntityTypeDamage(Entities.U_MilitaryCatapult, 10,
        EntityCategories.CityWallGate
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBatteringRam, 120);
    self:SetEntityTypeDamage(Entities.U_MilitaryBatteringRam, 20,
        EntityCategories.CityWallSegment
    );
    self:SetEntityTypeDamage(Entities.U_MilitarySiegeTower, 0);
    self:SetEntityTypeDamage(Entities.U_MilitaryTrap, 800);
    --
    self:SetEntityTypeDamage(Entities.A_ME_Bear, 120);
    self:SetEntityTypeDamage(Entities.A_ME_Bear_black, 120);
    self:SetEntityTypeDamage(Entities.A_ME_Wolf, 20);
    self:SetEntityTypeDamage(Entities.A_NA_Lion_Female, 40);
    self:SetEntityTypeDamage(Entities.A_NA_Lion_Male, 40);
    self:SetEntityTypeDamage(Entities.A_NE_PolarBear, 120);

    if g_GameExtraNo == 0 then
        return;
    end

    self:SetEntityTypeDamage(Entities.U_MilitaryBow_Khana, 20);
    self:SetEntityTypeDamage(Entities.U_MilitaryBow_Khana, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitarySword_Khana, 30);
    self:SetEntityTypeDamage(Entities.U_MilitarySword_Khana, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    --
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_AS, 30);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Melee_AS, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_AS, 20);
    self:SetEntityTypeDamage(Entities.U_MilitaryBandit_Ranged_AS, 5,
        EntityCategories.AttackableBuilding,
        EntityCategories.PalisadeSegment,
        EntityCategories.SpecialBuilding
    );
    --
    self:SetEntityTypeDamage(Entities.A_AS_BearBlack, 120);
    self:SetEntityTypeDamage(Entities.A_AS_Tiger, 40);
end

function Lib.Damage.Global:OverwriteVulnerabilityFunctions()
    MakeInvulnerable = function(_Entity)
        if IsExisting(_Entity) then
            local ID = GetID(_Entity);
            Lib.Damage.Global.InvulnerableList[ID] = nil;
            Logic.SetEntityInvulnerabilityFlag(ID, 1);
        end
    end

    MakeVulnerable = function(_Entity)
        if IsExisting(_Entity) then
            local ID = GetID(_Entity);
            Lib.Damage.Global.InvulnerableList[ID] = true;
            Logic.SetEntityInvulnerabilityFlag(ID, 0);
        end
    end
end

function Lib.Damage.Global:OnEntityHurtEntity(_EntityID1, _PlayerID1, _EntityID2, _PlayerID2)
    -- Get involved entities
    local AggressorID = self:GetTrueEntityID(_EntityID1);
    local TargetID = self:GetTrueEntityID(_EntityID2);
    if AggressorID == 0 or TargetID == 0 then
        return;
    end

    -- Set initial invulnerability
    Logic.SetEntityInvulnerabilityFlag(TargetID, 1);

    -- Do not touch the invincible
    if self.InvulnerableList[TargetID] then
        return;
    end

    local Damage = 1;

    -- Player properties
    local TerritoryBonus = Logic.GetTerritoryBonus(AggressorID) * self.TerritoryBonus[_PlayerID1];
    local HeightModifier = Logic.GetHeightDamageModifier(AggressorID) * self.HeightModifier[_PlayerID1];
    local EntityType1 = Logic.GetEntityType(AggressorID);
    local EntityType2 = Logic.GetEntityType(TargetID);
    local EntityName1 = Logic.GetEntityName(AggressorID);
    local EntityName2 = Logic.GetEntityName(TargetID);

    -- Get attacker properties
    local MoralFactor  = Logic.GetPlayerMorale(_PlayerID1);
    Damage = self:GetEntityTypeBaseDamage(EntityType1, EntityType2);
    Damage = self:GetEntityNameBaseDamage(EntityName1, EntityType2);

    -- Get defender properties
    local Armor = 0;
    if self.EntityTypeArmor[EntityType2] then
        Armor = self.EntityTypeArmor[EntityType2];
    end
    if self.EntityNameArmor[EntityName2] then
        Armor = self.EntityNameArmor[EntityName2];
    end

    -- Calculate damage
    Damage = Damage * (math.max(MoralFactor, 0.5) + TerritoryBonus) * HeightModifier;
    Damage = self:ApllyRangedCloseCombatDamage(AggressorID, Damage);
    Damage = self:ApllyWallCatapultCombatDamage(AggressorID, Damage);
    Damage = math.abs(Damage - Armor);
    if GameCallback_Lib_CalculateBattleDamage ~= nil then
        Damage = GameCallback_Lib_CalculateBattleDamage(AggressorID, _PlayerID1, TargetID, _PlayerID2, Damage);
    end

    -- Apply damage
    local Health = Logic.GetEntityHealth(TargetID);
    Damage = math.min(Health, math.max(1, math.ceil(Damage)));
    Logic.SetEntityInvulnerabilityFlag(TargetID, 0);
    Logic.HurtEntity(TargetID, Damage);

    -- Reset invulnerability
    if Health > Damage then
        Logic.SetEntityInvulnerabilityFlag(TargetID, 1);
    end
end

-- Returns the base damage of the entity type depending on the target type.
function Lib.Damage.Global:GetEntityTypeBaseDamage(_Type1, _Type2)
    if self.EntityTypeDamage[_Type1] then
        for Category, Damage in pairs(self.EntityTypeDamage[_Type1]) do
            if Category > 0 and Logic.IsEntityTypeInCategory(_Type2, Category) == 1 then
                return Damage;
            end
        end
        return self.EntityTypeDamage[_Type1][0] or 25;
    end
    return 25;
end

-- Returns the base damage of the entity type depending on the target type.
function Lib.Damage.Global:GetEntityNameBaseDamage(_Name1, _Type2)
    if self.EntityNameDamage[_Name1] then
        for Category, Damage in pairs(self.EntityNameDamage[_Name1]) do
            if Category > 0 and Logic.IsEntityTypeInCategory(_Type2, Category) == 1 then
                return Damage;
            end
        end
        return self.EntityNameDamage[_Name1][0] or 25;
    end
    return 25;
end

-- Returns a valid entity ID or 0. If entity is a leader the first soldier
-- of the battalion is returned.
function Lib.Damage.Global:GetTrueEntityID(_EntityID)
    -- Find first alive soldier if entity is leader
    if Logic.IsLeader(_EntityID) == 1 then
        local Soldiers = {Logic.GetSoldiersAttachedToLeader(_EntityID)};
        for i= 2, Soldiers[1] +1 do
            if Logic.GetEntityHealth(Soldiers[i]) > 0 then
                return Soldiers[i];
            end
        end
        return 0;
    end
    -- Otherwise check if entity has health
    if Logic.GetEntityHealth(_EntityID) == 0 then
        return 0;
    end
    return _EntityID;
end

-- Emulates the reduced close combat damage of archers.
function Lib.Damage.Global:ApllyRangedCloseCombatDamage(_EntityID, _Damage)
    local Damage = _Damage;
    if Logic.GetCurrentTaskList(_EntityID) == "TL_BATTLE_BOW_CLOSECOMBAT" then
        local Factor = 0.3;
        if GameCallback_Lib_CalculateRangedCloseCombatDamageFactor then
            local PlayerID = Logic.EntityGetPlayer(_EntityID);
            Factor = GameCallback_Lib_CalculateRangedCloseCombatDamageFactor(PlayerID, _EntityID, _Damage);
        end
        Damage = Damage * Factor;
    end
    return Damage;
end

-- Reduces the damage of wall catapult depending on the distance to the
-- next clostest wall catapult. (Only for human players)
function Lib.Damage.Global:ApllyWallCatapultCombatDamage(_EntityID, _Damage)
    local Damage = _Damage;
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.U_MilitaryBallista then
        local Factor = 1;
        local PlayerID = Logic.EntityGetPlayer(_EntityID);
        if GameCallback_Lib_CalculateWallCatapultDamageFactor then
            Factor = GameCallback_Lib_CalculateWallCatapultDamageFactor(PlayerID, _EntityID, _Damage);
        elseif Logic.PlayerGetIsHumanFlag(PlayerID) == true then
            local x,y,z = Logic.EntityGetPos(_EntityID);
            local Ballista = {Logic.GetPlayerEntitiesInArea(PlayerID, Type, x, y, 1500, 16)};
            Factor = (Ballista[1] > 1 and Factor / Ballista[1]) or 1;
        end
        Damage = Damage * Factor;
    end
    return Damage;
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Damage.Local:Initialize()
    if not self.IsInstalled then

        -- Garbage collection
        Lib.Damage.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Damage.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.Damage.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Damage.Name);

