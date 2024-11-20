Lib.Register("comfort/GetSiegeengineTypeByCartType");

CONST_CART_TO_ENGINE = {
    ["U_BatteringRamCart"] = "U_MilitaryBatteringRam",
    ["U_CatapultCart"] = "U_MilitaryCatapult",
    ["U_SiegeTowerCart"] = "U_MilitarySiegeTower",
    -- TODO: Add CP types
};

function GetSiegeengineTypeByCartType(_Type)
    local CartType = Logic.GetEntityTypeName(_Type);
    local EngineType = CONST_CART_TO_ENGINE[CartType];
    return Entities[EngineType] or 0;
end

