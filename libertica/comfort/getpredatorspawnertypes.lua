Lib.Register("comfort/GetPredatorSpawnerTypes");

CONST_PREDATOR_SPAWNER_TYPES = {
    -- Base
    ["S_Bear"] = true,
    ["S_Bear_Black"] = true,
    ["S_LionPack_NA"] = true,
    ["S_PolarBear_NE"] = true,
    ["S_WolfPack"] = true,
    -- Extra 1
    ["S_BearBlack"] = true,
    ["S_TigerPack_AS"] = true,
}

function GetPredatorSpawnerTypes()
    local Types = {};
    for Type, _ in pairs(CONST_PREDATOR_SPAWNER_TYPES) do
        if Type ~= nil then
            Types[#Types +1] = Entities[Type];
        end
    end
    return Types;
end

