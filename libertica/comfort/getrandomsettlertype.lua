Lib.Register("comfort/GetRandomSettlerType");

CONST_RANDOM_SETTLER_TYPES = {
    Male = {
        Entities.U_BannerMaker,
        Entities.U_Baker,
        Entities.U_Barkeeper,
        Entities.U_Blacksmith,
        Entities.U_Butcher,
        Entities.U_BowArmourer,
        Entities.U_BowMaker,
        Entities.U_CandleMaker,
        Entities.U_Carpenter,
        Entities.U_DairyWorker,
        Entities.U_Pharmacist,
        Entities.U_Tanner,
        Entities.U_SmokeHouseWorker,
        Entities.U_Soapmaker,
        Entities.U_SwordSmith,
        Entities.U_Weaver,
    },
    Female = {
        Entities.U_BathWorker,
        Entities.U_SpouseS01,
        Entities.U_SpouseS02,
        Entities.U_SpouseS03,
        Entities.U_SpouseF01,
        Entities.U_SpouseF02,
        Entities.U_SpouseF03,
    }
}

function GetRandomSettlerType()
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    local Gender = (math.random(1, 2) == 1 and "Male") or "Female";
    local Type   = math.random(1, #CONST_RANDOM_SETTLER_TYPES[Gender]);
    return CONST_RANDOM_SETTLER_TYPES[Gender][Type];
end
API.GetRandomSettlerType = GetRandomSettlerType;

function GetRandomMaleSettlerType()
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    local Type = math.random(1, #CONST_RANDOM_SETTLER_TYPES.Male);
    return CONST_RANDOM_SETTLER_TYPES.Male[Type];
end
API.GetRandomMaleSettlerType = GetRandomMaleSettlerType;

function GetRandomFemaleSettlerType()
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    local Type = math.random(1, #CONST_RANDOM_SETTLER_TYPES.Female);
    return CONST_RANDOM_SETTLER_TYPES.Female[Type];
end
API.GetRandomFemaleSettlerType = GetRandomFemaleSettlerType;

