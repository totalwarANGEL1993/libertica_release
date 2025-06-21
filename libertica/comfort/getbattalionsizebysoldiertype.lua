Lib.Register("comfort/GetBattalionSizeBySoldierType");

CONST_TYPE_SOLDIER_AMOUNT_MAP = {
    -- Base
    ["U_MilitaryBandit_Melee_ME"] = 3,
    ["U_MilitaryBandit_Ranged_ME"] = 3,
    ["U_MilitaryBandit_Melee_NA"] = 3,
    ["U_MilitaryBandit_Ranged_NA"] = 3,
    ["U_MilitaryBandit_Melee_NE"] = 3,
    ["U_MilitaryBandit_Ranged_NE"] = 3,
    ["U_MilitaryBandit_Melee_SE"] = 3,
    ["U_MilitaryBandit_Ranged_SE"] = 3,
    ["U_MilitaryBow"] = 6,
    ["U_MilitaryBow_RedPrince"] = 6,
    ["U_MilitarySword"] = 6,
    ["U_MilitarySword_RedPrince"] = 6,
    -- Extra 1
    ["U_MilitaryBandit_Melee_AS"] = 3,
    ["U_MilitaryBandit_Ranged_AS"] = 3,
    ["U_MilitaryBow_Khana"] = 6,
    ["U_MilitarySword_Khana"] = 6,
};

function GetBattalionSizeBySoldierType(_Type)
	local TypeName = Logic.GetEntityTypeName(_Type);
    return CONST_TYPE_SOLDIER_AMOUNT_MAP[TypeName] or 0;
end
API.GetBattalionSizeBySoldierType = GetBattalionSizeBySoldierType;

