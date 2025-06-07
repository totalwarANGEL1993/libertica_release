Lib.Register("module/city/MilitiaSystem_Config");

Lib.MilitiaSystem = Lib.MilitiaSystem or {};
Lib.MilitiaSystem.Config = {
    Skills = {
        Dodge = {
            Name = "Dodge",
            Chance = 15,
            InvokeSkill = function(_self, _UserID, _AttackerID, _TargetID, _Damage)
                if _UserID == _TargetID then
                    if math.random(1, 100) <= _self.Chance then
                        return 1;
                    end
                end
                return _Damage;
            end
        },
        Miracle = {
            Name = "Miracle",
            Chance = 7,
            InvokeSkill = function(_self, _UserID, _AttackerID, _TargetID, _Damage)
                if _UserID == _TargetID then
                    local Health = Logic.GetEntityHealth(_TargetID);
                    local MaxHealth = Logic.GetEntityHealth(_TargetID);
                    if Health < _Damage and math.random(1, 100) <= _self.Chance then
                        Logic.HealEntity(_TargetID, MaxHealth - MaxHealth);
                        return 1;
                    end
                end
                return _Damage;
            end
        },
        BraveStand = {
            Name = "BraveStand",
            InvokeSkill = function(_self, _UserID, _AttackerID, _TargetID, _Damage)
                if _UserID == _TargetID then
                    local Health = Logic.GetEntityHealth(_TargetID);
                    local MaxHealth = Logic.GetEntityHealth(_TargetID);
                    local Factor = math.min((Health / MaxHealth) + 0.3, 1);
                    return math.max(math.floor(_Damage * Factor), 1);
                end
                return _Damage;
            end
        },
        Critical = {
            Name = "Critical",
            Chance = 10,
            Factor = 2.0,
            InvokeSkill = function(_self, _UserID, _AttackerID, _TargetID, _Damage)
                if _UserID == _AttackerID then
                    if math.random(1, 100) <= _self.Chance then
                        return math.floor(_Damage * _self.Factor);
                    end
                end
                return _Damage;
            end
        },
        Bleeding = {
            Name = "Bleeding",
            Types = {
                ["U_MilitaryBow"] = true,
                ["U_MilitaryBow_RedPrince"] = true,
                ["U_MilitaryBow_Khana"] = true,
                ["U_MilitarySword_Khana"] = true,
                ["U_MilitaryBandit_Ranged_ME"] = true,
                ["U_MilitaryBandit_Melee_NA"] = true,
                ["U_MilitaryBandit_Ranged_NA"] = true,
                ["U_MilitaryBandit_Ranged_SE"] = true,
            },
            Factor = 1.2,
            InvokeSkill = function(_self, _UserID, _AttackerID, _TargetID, _Damage)
                if _UserID == _AttackerID then
                    local Type = Logic.GetEntityType(_TargetID);
                    local TypeName = Logic.GetEntityTypeName(Type);
                    if _self.Types[TypeName] then
                        return math.floor(_Damage * _self.Factor);
                    end
                end
                return _Damage;
            end
        },
        Concussion = {
            Name = "Concussion",
            Types = {
                ["U_MilitarySword"] = true,
                ["U_MilitarySword_RedPrince"] = true,
                ["U_MilitaryBandit_Melee_ME"] = true,
                ["U_MilitaryBandit_Melee_NE"] = true,
                ["U_MilitaryBandit_Ranged_NE"] = true,
                ["U_MilitaryBandit_Melee_SE"] = true,
            },
            Factor = 1.2,
            InvokeSkill = function(_self, _UserID, _AttackerID, _TargetID, _Damage)
                if _UserID == _AttackerID then
                    local Type = Logic.GetEntityType(_TargetID);
                    local TypeName = Logic.GetEntityTypeName(Type);
                    if _self.Types[TypeName] then
                        return math.floor(_Damage * _self.Factor);
                    end
                end
                return _Damage;
            end
        },
        Execution = {
            Name = "Execution",
            Chance = 3,
            Damage = 300,
            InvokeSkill = function(_self, _UserID, _AttackerID, _TargetID, _Damage)
                if _UserID == _AttackerID then
                    if math.random(1, 100) <= _self.Chance then
                        return _self.Damage;
                    end
                end
                return _Damage;
            end
        },
    },
    UnitCosts = {
        ["U_MilitaryBandit_Melee_AS"] = {Goods.G_Gold, 45, Goods.G_Sausage, 3},
        ["U_MilitaryBandit_Ranged_AS"] = {Goods.G_Gold, 45, Goods.G_Beer, 3},
        ["U_MilitaryBandit_Melee_ME"] = {Goods.G_Gold, 45, Goods.G_Sausage, 3},
        ["U_MilitaryBandit_Ranged_ME"] = {Goods.G_Gold, 45, Goods.G_Beer, 3},
        ["U_MilitaryBandit_Melee_NA"] = {Goods.G_Gold, 45, Goods.G_Sausage, 3},
        ["U_MilitaryBandit_Ranged_NA"] = {Goods.G_Gold, 45, Goods.G_Beer, 3},
        ["U_MilitaryBandit_Melee_NE"] = {Goods.G_Gold, 45, Goods.G_Sausage, 3},
        ["U_MilitaryBandit_Ranged_NE"] = {Goods.G_Gold, 45, Goods.G_Beer, 3},
        ["U_MilitaryBandit_Melee_SE"] = {Goods.G_Gold, 45, Goods.G_Sausage, 3},
        ["U_MilitaryBandit_Ranged_SE"] = {Goods.G_Gold, 45, Goods.G_Beer, 3},
    },
    UnitData = {
        ["U_MilitaryBandit_Melee_AS"] = {"R_MilitaryBandit_Melee_AS", "R_Mercenary_Melee", {6, 3, 1}},
        ["U_MilitaryBandit_Ranged_AS"] = {"R_MilitaryBandit_Ranged_AS", "R_Mercenary_Ranged", {6, 2, 1}},
        ["U_MilitaryBandit_Melee_ME"] = {"R_MilitaryBandit_Melee_ME", "R_Mercenary_Melee", {9, 9, 0}},
        ["U_MilitaryBandit_Ranged_ME"] = {"R_MilitaryBandit_Ranged_ME", "R_Mercenary_Ranged", {9, 10, 0}},
        ["U_MilitaryBandit_Melee_NA"] = {"R_MilitaryBandit_Melee_NA", "R_Mercenary_Melee", {9, 11, 0}},
        ["U_MilitaryBandit_Ranged_NA"] = {"R_MilitaryBandit_Ranged_NA", "R_Mercenary_Ranged", {9, 12, 0}},
        ["U_MilitaryBandit_Melee_NE"] = {"R_MilitaryBandit_Melee_NE", "R_Mercenary_Melee", {9, 13, 0}},
        ["U_MilitaryBandit_Ranged_NE"] = {"R_MilitaryBandit_Ranged_NE", "R_Mercenary_Ranged", {9, 14, 0}},
        ["U_MilitaryBandit_Melee_SE"] = {"R_MilitaryBandit_Melee_SE", "R_Mercenary_Melee", {9, 15, 0}},
        ["U_MilitaryBandit_Ranged_SE"] = {"R_MilitaryBandit_Ranged_SE", "R_Mercenary_Ranged", {9, 26, 0}},
    },
    Technology = {
        -- Tech name, Description, Icon, Extra Number
        {"R_MilitaryBandit_Melee_AS",  {de = "Hindun Schwertkämpfer",   en = "Hindun Swordmen",},    {6,  3, 1}, 1},
        {"R_MilitaryBandit_Ranged_AS", {de = "Hindun Bogenschützen",    en = "Hindun Archers",},     {6,  2, 1}, 1},
        {"R_MilitaryBandit_Melee_ME",  {de = "Westerlin Keulenkämpfer", en = "Westerlin Macemen",},  {9,  9, 0}, 0},
        {"R_MilitaryBandit_Ranged_ME", {de = "Westerlin Bogenschützen", en = "Westerlin Archers",},  {9, 10, 0}, 0},
        {"R_MilitaryBandit_Melee_NA",  {de = "Janub Schwertkämpfer",    en = "Janub Swordmen",},     {9, 11, 0}, 0},
        {"R_MilitaryBandit_Ranged_NA", {de = "Janub Bogenschützen",     en = "Janub Archers",},      {9, 12, 0}, 0},
        {"R_MilitaryBandit_Melee_NE",  {de = "Narlind Axtkämpfer",      en = "Narlind Axemen",},     {9, 13, 0}, 0},
        {"R_MilitaryBandit_Ranged_NE", {de = "Narlind Axtwerfer",       en = "Narlind Axethrower",}, {9, 14, 0}, 0},
        {"R_MilitaryBandit_Melee_SE",  {de = "Raudrlin Schwertkämpfer", en = "Raudrlin Swordmen",},  {9, 15, 0}, 0},
        {"R_MilitaryBandit_Ranged_SE", {de = "Raudrlin Bogenschützen",  en = "Raudrlin Archers",},   {9, 26, 0}, 0},
        --
        {"R_Mercenary_Melee",          {de = "Miliz Nahkämpfer",        en = "Militia Infantry",},   {9,  9, 0}, 0},
        {"R_Mercenary_Ranged",         {de = "Miliz Fernkämpfer",       en = "Militia Archers",},    {9, 10, 0}, 0},
    },
    ConscriptTasks = {
        Idle = {
            ["TL_WORKER_IDLE"] = true,
            ["TL_WORKER_IDLE_CHAT"] = true,
        },
        Work = {
            ["TL_BAKER_WORK01"] = true,
            ["TL_BAKER_WORK02"] = true,
            ["TL_BAKER_WORK03"] = true,
            ["TL_BANNERMAKER_WORK01"] = true,
            ["TL_BANNERMAKER_WORK02"] = true,
            ["TL_BANNERMAKER_WORK03"] = true,
            ["TL_BARKEEPER_WORK01"] = true,
            ["TL_BARKEEPER_WORK02"] = true,
            ["TL_BARKEEPER_WORK03"] = true,
            ["TL_BLACKSMITH_WORK01"] = true,
            ["TL_BLACKSMITH_WORK02"] = true,
            ["TL_BLACKSMITH_WORK03"] = true,
            ["TL_BROOMMAKER_WORK01"] = true,
            ["TL_BROOMMAKER_WORK02"] = true,
            ["TL_BROOMMAKER_WORK03"] = true,
            ["TL_BUTCHER_WORK01"] = true,
            ["TL_BUTCHER_WORK02"] = true,
            ["TL_BUTCHER_WORK03"] = true,
            ["TL_BOWMAKER_WORK01"] = true,
            ["TL_BOWMAKER_WORK02"] = true,
            ["TL_BOWMAKER_WORK03"] = true,
            ["TL_CANDLEMAKER_WORK01"] = true,
            ["TL_CANDLEMAKER_WORK02"] = true,
            ["TL_CANDLEMAKER_WORK03"] = true,
            ["TL_CARPENTER_WORK01"] = true,
            ["TL_CARPENTER_WORK02"] = true,
            ["TL_CARPENTER_WORK03"] = true,
            ["TL_DAIRYWORKER_WORK01"] = true,
            ["TL_DAIRYWORKER_WORK02"] = true,
            ["TL_DAIRYWORKER_WORK03"] = true,
            ["TL_PHARMACYWORKER_WORK01"] = true,
            ["TL_PHARMACYWORKER_WORK02"] = true,
            ["TL_PHARMACYWORKER_WORK03"] = true,
            ["TL_SIEGEENGINEBUILDER_WORK01"] = true,
            ["TL_SIEGEENGINEBUILDER_WORK02"] = true,
            ["TL_SIEGEENGINEBUILDER_WORK03"] = true,
            ["TL_SMOKEHOUSEWORKER_WORK01"] = true,
            ["TL_SMOKEHOUSEWORKER_WORK02"] = true,
            ["TL_SMOKEHOUSEWORKER_WORK03"] = true,
            ["TL_SOAPMAKER_WORK01"] = true,
            ["TL_SOAPMAKER_WORK02"] = true,
            ["TL_SOAPMAKER_WORK03"] = true,
            ["TL_SWORDSMITH_WORK01"] = true,
            ["TL_SWORDSMITH_WORK02"] = true,
            ["TL_SWORDSMITH_WORK03"] = true,
            ["TL_TANNER_WORK01"] = true,
            ["TL_TANNER_WORK02"] = true,
            ["TL_TANNER_WORK03"] = true,
            ["TL_THEATREWORKER_WORK"] = true,
            ["TL_WEAVER_WORK01"] = true,
            ["TL_WEAVER_WORK02"] = true,
            ["TL_WEAVER_WORK03"] = true,
            --
            ["TL_CATTLE_FARMER_WORK"] = true,
            ["TL_FISHER_WORK"] = true,
            ["TL_GRAIN_FARMER_WORK"] = true,
            ["TL_HERB_GATHERER_WORK"] = true,
            ["TL_HUNTER_HUNT"] = true,
            ["TL_HUNTER_HUNT_IDLE"] = true,
            ["TL_HUNTER_WORK"] = true,
            ["TL_IRONMINER_WORK"] = true,
            ["TL_SHEEP_FARMER_FIND_FIELD"] = true,
            ["TL_SHEEP_FARMER_WORK"] = true,
            ["TL_STONECUTTER_WORK"] = true,
            ["TL_WOODCUTTER_WORK"] = true,
            --
            ["TL_GATHERER_DELIVER_RESOURCES_TO_KEEP_WITH_CART"] = true,
            ["TL_GATHERER_DELIVER_RESOURCES_TO_WORKPLACE"] = true,
            --
            ["TL_PROCESSOR_DELIVER_RESOURCE_TO_WORKPLACE"] = true,
            ["TL_PROCESSOR_ENTER_WORKPLACE_TO_WORK"] = true,
            ["TL_PROCESSOR_FETCH_RESOURCE"] = true,
            ["TL_PROCESSOR_FETCH_RESOURCE_AT_CISTERN"] = true,
            ["TL_PROCESSOR_FETCH_RESOURCE_AT_WELL"] = true,
            ["TL_PROCESSOR_FETCH_RESOURCE_FROM_KEEP"] = true,
            --
            ["TL_WORKER_IDLE"] = true,
            ["TL_WORKER_IDLE_CHAT"] = true,
        },
    },
};

MilitiaSkill = Lib.MilitiaSystem.Config.Skills;

