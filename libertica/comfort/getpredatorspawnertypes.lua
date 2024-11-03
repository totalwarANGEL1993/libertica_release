Lib.Register("comfort/GetPredatorSpawnerTypes");

function GetPredatorSpawnerTypes()
    local Types = {
        Entities.S_Bear,
        Entities.S_Bear_Black,
        Entities.S_LionPack_NA,
        Entities.S_PolarBear_NE,
        Entities.S_WolfPack,
    };
    if Framework.GetGameExtraNo() > 0 then
        table.insert(Types, Entities.S_BearBlack);
        table.insert(Types, Entities.S_TigerPack_AS);
    end
    return Types;
end

