Lib.Register("comfort/GetSiegeengineTypeByCartType");

if Entities then
    CONST_CART_TO_ENGINE = {
        [Entities.U_BatteringRamCart] = Entities.U_MilitaryBatteringRam,
        [Entities.U_CatapultCart] = Entities.U_MilitaryCatapult,
        [Entities.U_SiegeTowerCart] = Entities.U_MilitarySiegeTower,
        -- TODO: Add CP types
    };
end

function GetSiegeengineTypeByCartType(_Type)
    return CONST_CART_TO_ENGINE[_Type];
end

