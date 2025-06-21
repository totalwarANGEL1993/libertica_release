Lib.Register("module/ui/UIBuilding_Config");

Lib.UIBuilding = Lib.UIBuilding or {};
Lib.UIBuilding.Config = {
    Buttons = {
        ["BuyAmmunitionCart"] = {
            TypeExclusion = "^B_.*StoreHouse",
            OriginalPosition = nil,
            Bind = nil,
        },
        ["BuyBattallion"] = {
            TypeExclusion = "^B_[CB]a[sr][tr][la][ec]",
            OriginalPosition = nil,
            Bind = nil,
        },
        ["PlaceField"] = {
            TypeExclusion = "^B_.*[BFH][aei][erv][kme]",
            OriginalPosition = nil,
            Bind = nil,
        },
        ["StartFestival"] = {
            TypeExclusion = "^B_Marketplace",
            OriginalPosition = nil,
            Bind = nil,
        },
        ["StartTheatrePlay"] = {
            TypeExclusion = "^B_Theatre",
            OriginalPosition = nil,
            Bind = nil,
        },
        ["UpgradeTurret"] = {
            TypeExclusion = "^B_WallTurret",
            OriginalPosition = nil,
            Bind = nil,
        },
        ["BuyBatteringRamCart"] = {
            TypeExclusion = "^B_SiegeEngineWorkshop",
            OriginalPosition = nil,
            Bind = nil,
        },
        ["BuyCatapultCart"] = {
            TypeExclusion = "^B_SiegeEngineWorkshop",
            OriginalPosition = nil,
            Bind = nil,
        },
        ["BuySiegeTowerCart"] = {
            TypeExclusion = "^B_SiegeEngineWorkshop",
            OriginalPosition = nil,
            Bind = nil,
        },
    },
};

