Lib.Register("comfort/GetSiegecartTypeByEngineType");

CONST_ENGINE_TO_CART = {
    ["U_MilitaryBatteringRam"] = "U_BatteringRamCart",
    ["U_MilitaryCatapult"] = "U_CatapultCart",
    ["U_MilitarySiegeTower"] = "U_SiegeTowerCart",
    -- TODO: Add CP types
};

function GetSiegecartTypeByEngineType(_Type)
    local EngineType = Logic.GetEntityTypeName(_Type);
    local CartType = CONST_ENGINE_TO_CART[EngineType];
    return Entities[CartType] or 0;
end

