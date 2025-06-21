Lib.Register("module/city/Promotion_Config");

Lib.Promotion = Lib.Promotion or {};
Lib.Promotion.Config = {
    Technology = {
        -- Tech name, Description, Icon, Extra Number
        {"R_MilitarySword", "UI_ObjectNames/BuySwordfighters", {9, 7, 0}, 0},
        {"R_MilitaryBow",   "UI_ObjectNames/BuyBowmen",        {9, 8, 0}, 0},
    }
};

function Lib.Promotion.Config:InitAddonText()
    if Framework.GetGameExtraNo() ~= 0 then
        Lib.Promotion.Config.BuffTypeNames[Buffs.Buff_Gems] = {
            de = "Edelsteine beschaffen",
            en = "Obtain gems",
            fr = "Se procurer des Gemmes",
        }
        Lib.Promotion.Config.BuffTypeNames[Buffs.Buff_Olibanum] = {
            de = "Weihrauch beschaffen",
            en = "Obtain olibanum",
            fr = "Se procurer de l'encens",
        }
        Lib.Promotion.Config.BuffTypeNames[Buffs.Buff_MusicalInstrument] = {
            de = "Muskinstrumente beschaffen",
            en = "Obtain instruments",
            fr = "Se procurer des instruments de musique",
        }
    end
end

function Lib.Promotion.Config:InitTexturePositions()
    g_TexturePositions.EntityCategories[EntityCategories.GC_Food_Supplier]          = { 1, 1};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Clothes_Supplier]       = { 1, 2};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Hygiene_Supplier]       = {16, 1};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Entertainment_Supplier] = { 1, 4};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Luxury_Supplier]        = {16, 3};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Weapon_Supplier]        = { 1, 7};
    g_TexturePositions.EntityCategories[EntityCategories.GC_Medicine_Supplier]      = { 2,10};
    g_TexturePositions.EntityCategories[EntityCategories.Outpost]                   = {12, 3};
    g_TexturePositions.EntityCategories[EntityCategories.Spouse]                    = { 5,15};
    g_TexturePositions.EntityCategories[EntityCategories.CattlePasture]             = { 3,16};
    g_TexturePositions.EntityCategories[EntityCategories.SheepPasture]              = { 4, 1};
    g_TexturePositions.EntityCategories[EntityCategories.Soldier]                   = { 7,12};
    g_TexturePositions.EntityCategories[EntityCategories.GrainField]                = {14, 2};
    g_TexturePositions.EntityCategories[EntityCategories.BeeHive]                   = { 2, 1};
    g_TexturePositions.EntityCategories[EntityCategories.OuterRimBuilding]          = { 3, 4};
    g_TexturePositions.EntityCategories[EntityCategories.CityBuilding]              = { 8, 1};
    g_TexturePositions.EntityCategories[EntityCategories.Leader]                    = { 7, 11};
    g_TexturePositions.EntityCategories[EntityCategories.Range]                     = { 9, 8};
    g_TexturePositions.EntityCategories[EntityCategories.Melee]                     = { 9, 7};
    g_TexturePositions.EntityCategories[EntityCategories.SiegeEngine]               = { 2,15};

    g_TexturePositions.Entities[Entities.B_Beehive]                                 = { 2, 1};
    g_TexturePositions.Entities[Entities.B_Cathedral_Big]                           = { 3,12};
    g_TexturePositions.Entities[Entities.B_CattlePasture]                           = { 3,16};
    g_TexturePositions.Entities[Entities.B_GrainField_ME]                           = { 1,13};
    g_TexturePositions.Entities[Entities.B_GrainField_NA]                           = { 1,13};
    g_TexturePositions.Entities[Entities.B_GrainField_NE]                           = { 1,13};
    g_TexturePositions.Entities[Entities.B_GrainField_SE]                           = { 1,13};
    g_TexturePositions.Entities[Entities.U_MilitaryBallista]                        = {10, 5};
    g_TexturePositions.Entities[Entities.B_Outpost]                                 = {12, 3};
    g_TexturePositions.Entities[Entities.B_Outpost_ME]                              = {12, 3};
    g_TexturePositions.Entities[Entities.B_Outpost_NA]                              = {12, 3};
    g_TexturePositions.Entities[Entities.B_Outpost_NE]                              = {12, 3};
    g_TexturePositions.Entities[Entities.B_Outpost_SE]                              = {12, 3};
    g_TexturePositions.Entities[Entities.B_SheepPasture]                            = { 4, 1};
    g_TexturePositions.Entities[Entities.U_SiegeEngineCart]                         = { 9, 4};
    g_TexturePositions.Entities[Entities.U_Trebuchet]                               = { 9, 1};

    g_TexturePositions.Needs[Needs.Medicine]                                        = { 2,10};

    g_TexturePositions.Technologies[Technologies.R_Castle_Upgrade_1]                = { 4, 7};
    g_TexturePositions.Technologies[Technologies.R_Castle_Upgrade_2]                = { 4, 7};
    g_TexturePositions.Technologies[Technologies.R_Castle_Upgrade_3]                = { 4, 7};
    g_TexturePositions.Technologies[Technologies.R_Cathedral_Upgrade_1]             = { 4, 5};
    g_TexturePositions.Technologies[Technologies.R_Cathedral_Upgrade_2]             = { 4, 5};
    g_TexturePositions.Technologies[Technologies.R_Cathedral_Upgrade_3]             = { 4, 5};
    g_TexturePositions.Technologies[Technologies.R_Storehouse_Upgrade_1]            = { 4, 6};
    g_TexturePositions.Technologies[Technologies.R_Storehouse_Upgrade_2]            = { 4, 6};
    g_TexturePositions.Technologies[Technologies.R_Storehouse_Upgrade_3]            = { 4, 6};

    g_TexturePositions.Buffs = g_TexturePositions.Buffs or {};

    g_TexturePositions.Buffs[Buffs.Buff_ClothesDiversity]                           = { 1, 2};
    g_TexturePositions.Buffs[Buffs.Buff_EntertainmentDiversity]                     = { 1, 4};
    g_TexturePositions.Buffs[Buffs.Buff_FoodDiversity]                              = { 1, 1};
    g_TexturePositions.Buffs[Buffs.Buff_HygieneDiversity]                           = { 1, 3};
    g_TexturePositions.Buffs[Buffs.Buff_Colour]                                     = { 5,11};
    g_TexturePositions.Buffs[Buffs.Buff_Entertainers]                               = { 5,12};
    g_TexturePositions.Buffs[Buffs.Buff_ExtraPayment]                               = { 1, 8};
    g_TexturePositions.Buffs[Buffs.Buff_Sermon]                                     = { 4,14};
    g_TexturePositions.Buffs[Buffs.Buff_Spice]                                      = { 5,10};
    g_TexturePositions.Buffs[Buffs.Buff_NoTaxes]                                    = { 1, 6};

    g_TexturePositions.GoodCategories = g_TexturePositions.GoodCategories or {};

    g_TexturePositions.GoodCategories[GoodCategories.GC_Ammunition]                 = {10, 6};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Animal]                     = { 4,16};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Clothes]                    = { 1, 2};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Document]                   = { 5, 6};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Entertainment]              = { 1, 4};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Food]                       = { 1, 1};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Gold]                       = { 1, 8};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Hygiene]                    = {16, 1};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Luxury]                     = {16, 3};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Medicine]                   = { 2,10};
    g_TexturePositions.GoodCategories[GoodCategories.GC_None]                       = {15,16};
    g_TexturePositions.GoodCategories[GoodCategories.GC_RawFood]                    = { 3, 4};
    g_TexturePositions.GoodCategories[GoodCategories.GC_RawMedicine]                = { 2, 2};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Research]                   = { 5, 6};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Resource]                   = { 3, 4};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Tools]                      = { 4,12};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Water]                      = { 1,16};
    g_TexturePositions.GoodCategories[GoodCategories.GC_Weapon]                     = { 8, 5};
end

function Lib.Promotion.Config:InitTexturePositionsAddon()
    if Framework.GetGameExtraNo() ~= 0 then
        g_TexturePositions.Entities[Entities.B_GrainField_AS]  = { 1,13};
        g_TexturePositions.Entities[Entities.B_Outpost_AS]     = {12, 3};
        g_TexturePositions.Buffs[Buffs.Buff_Gems]              = { 1, 1, 1};
        g_TexturePositions.Buffs[Buffs.Buff_MusicalInstrument] = { 1, 3, 1};
        g_TexturePositions.Buffs[Buffs.Buff_Olibanum]          = { 1, 2, 1};
    end
end

Lib.Promotion.Config.RequirementWidgets = {
    [1] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Settlers",
    [2] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Goods",
    [3] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/RichBuildings",
    [4] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Castle",
    [5] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Storehouse",
    [6] = "/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/Requirements/Cathedral",
};

if GoodCategories then
    Lib.Promotion.Config.GoodCategoryNames = {
        [GoodCategories.GC_Ammunition]      = {de = "Munition",         en = "Ammunition",      fr = "Munition"},
        [GoodCategories.GC_Animal]          = {de = "Nutztiere",        en = "Livestock",       fr = "Animaux d'élevage"},
        [GoodCategories.GC_Clothes]         = {de = "Kleidung",         en = "Clothes",         fr = "Vêtements"},
        [GoodCategories.GC_Document]        = {de = "Dokumente",        en = "Documents",       fr = "Documents"},
        [GoodCategories.GC_Entertainment]   = {de = "Unterhaltung",     en = "Entertainment",   fr = "Divertissement"},
        [GoodCategories.GC_Food]            = {de = "Nahrungsmittel",   en = "Food",            fr = "Nourriture"},
        [GoodCategories.GC_Gold]            = {de = "Gold",             en = "Gold",            fr = "Or"},
        [GoodCategories.GC_Hygiene]         = {de = "Hygieneartikel",   en = "Hygiene",         fr = "Hygiène"},
        [GoodCategories.GC_Luxury]          = {de = "Dekoration",       en = "Decoration",      fr = "Décoration"},
        [GoodCategories.GC_Medicine]        = {de = "Medizin",          en = "Medicine",        fr = "Médecine"},
        [GoodCategories.GC_None]            = {de = "Nichts",           en = "None",            fr = "Rien"},
        [GoodCategories.GC_RawFood]         = {de = "Nahrungsmittel",   en = "Food",            fr = "Nourriture"},
        [GoodCategories.GC_RawMedicine]     = {de = "Medizin",          en = "Medicine",        fr = "Médecine"},
        [GoodCategories.GC_Research]        = {de = "Forschung",        en = "Research",        fr = "Recherche"},
        [GoodCategories.GC_Resource]        = {de = "Rohstoffe",        en = "Resource",        fr = "Ressources"},
        [GoodCategories.GC_Tools]           = {de = "Werkzeug",         en = "Tools",           fr = "Outils"},
        [GoodCategories.GC_Water]           = {de = "Wasser",           en = "Water",           fr = "Eau"},
        [GoodCategories.GC_Weapon]          = {de = "Waffen",           en = "Weapon",          fr = "Armes"},
    };
end

if Buffs then
    Lib.Promotion.Config.BuffTypeNames = {
        [Buffs.Buff_ClothesDiversity]        = {de = "Vielfältige Kleidung",        en = "Clothes variety",         fr = "Diversité vestimentaire"},
        [Buffs.Buff_Colour]                  = {de = "Farben beschaffen",           en = "Obtain color",            fr = "Se procurer des couleurs"},
        [Buffs.Buff_Entertainers]            = {de = "Gaukler anheuern",            en = "Hire entertainer",        fr = "Engager des saltimbanques"},
        [Buffs.Buff_EntertainmentDiversity]  = {de = "Vielfältige Unterhaltung",    en = "Entertainment variety",   fr = "Diversité des divertissements"},
        [Buffs.Buff_ExtraPayment]            = {de = "Sonderzahlung",               en = "Extra payment",           fr = "Paiement supplémentaire"},
        [Buffs.Buff_Festival]                = {de = "Fest veranstalten",           en = "Hold Festival",           fr = "Organiser une fête"},
        [Buffs.Buff_FoodDiversity]           = {de = "Vielfältige Nahrung",         en = "Food variety",            fr = "Diversité alimentaire"},
        [Buffs.Buff_HygieneDiversity]        = {de = "Vielfältige Hygiene",         en = "Hygiene variety",         fr = "Diversité hygiénique"},
        [Buffs.Buff_NoTaxes]                 = {de = "Steuerbefreiung",             en = "No taxes",                fr = "Exonération fiscale"},
        [Buffs.Buff_Sermon]                  = {de = "Pregigt abhalten",            en = "Hold sermon",             fr = "Tenir des prêches"},
        [Buffs.Buff_Spice]                   = {de = "Salz beschaffen",             en = "Obtain salt",             fr = "Se procurer du sel"},
    };
end

Lib.Promotion.Config.Description = {
    Settlers = {
        Title = {
            de = "Benötigte Siedler",
            en = "Needed settlers",
            fr = "Settlers nécessaires",
        },
        Text = {
            de = "- Benötigte Menge an Siedlern",
            en = "- Needed number of settlers",
            fr = "- Quantité de settlers nécessaire",
        },
    },

    RichBuildings = {
        Title = {
            de = "Reiche Häuser",
            en = "Rich city buildings",
            fr = "Bâtiments riches",
        },
        Text = {
            de = "- Menge an reichen Stadtgebäuden",
            en = "- Needed amount of rich city buildings",
            fr = "- Quantité de bâtiments de la ville riches",
        },
    },

    Goods = {
        Title = {
            de = "Waren lagern",
            en = "Store Goods",
            fr = "Entreposer des marchandises",
        },
        Text = {
            de = "- Benötigte Menge",
            en = "- Needed amount",
            fr = "- Quantité nécessaire",
        },
    },

    FullDecoratedBuildings = {
        Title = {
            de = "Dekorierte Häuser",
            en = "Decorated City buildings",
            fr = "Bâtiments décorés",
        },
        Text = {
            de = "- Menge an voll dekorierten Gebäuden",
            en = "- Amount of full decoraded city buildings",
            fr = "- Quantité de bâtiments entièrement décorés",
        },
    },

    DecoratedBuildings = {
        Title = {
            de = "Dekoration",
            en = "Decoration",
            fr = "Décoration",
        },
        Text = {
            de = "- Menge an Dekorationsgütern in der Siedlung",
            en = "- Amount of decoration goods in settlement",
            fr = "- Quantité de biens de décoration dans la ville",
        },
    },

    Headquarters = {
        Title = {
            de = "Burgstufe",
            en = "Castle level",
            fr = "Niveau du château",
        },
        Text = {
            de = "- Benötigte Ausbauten der Burg",
            en = "- Needed castle upgrades",
            fr = "- Améliorations nécessaires du château",
        },
    },

    Storehouse = {
        Title = {
            de = "Lagerhausstufe",
            en = "Storehouse level",
            fr = "Niveau de l'entrepôt",
        },
        Text = {
            de = "- Benötigte Ausbauten des Lagerhauses",
            en = "- Needed storehouse upgrades",
            fr = "- Améliorations nécessaires de l'entrepôt",
        },
    },

    Cathedrals = {
        Title = {
            de = "Kirchenstufe",
            en = "Cathedral level",
            fr = "Niveau de la cathédrale",
        },
        Text = {
            de = "- Benötigte Ausbauten der Kirche",
            en = "- Needed cathedral upgrades",
            fr = "- Améliorations nécessaires de la cathédrale",
        },
    },

    Reputation = {
        Title = {
            de = "Ruf der Stadt",
            en = "City reputation",
            fr = "Réputation de la ville",
        },
        Text = {
            de = "- Benötigter Ruf der Stadt",
            en = "- Needed city reputation",
            fr = "- Réputation de la ville nécessaire",
        },
    },

    EntityCategoryDefault = {
        Title = {
            de = "",
            en = "",
            fr = "",
        },
        Text = {
            de = "- Benötigte Anzahl",
            en = "- Needed amount",
            fr = "- Nombre requis",
        },
    },

    Cattle = {
        Title = {
            de = "Kühe",
            en = "Cattle",
            fr = "Vaches",
        },
        Text = {
            de = "- Benötigte Menge an Kühen",
            en = "- Needed amount of cattle",
            fr = "- Quantité de vaches nécessaire",
        },
    },

    Sheep = {
        Title = {
            de = "Schafe",
            en = "Sheeps",
            fr = "Moutons",
        },
        Text = {
            de = "- Benötigte Menge an Schafen",
            en = "- Needed amount of sheeps",
            fr = "- Quantité de moutons nécessaire",
        },
    },

    Outposts = {
        Title = {
            de = "Territorien",
            en = "Territories",
            fr = "Territoires",
        },
        Text = {
            de = "- Zu erobernde Territorien",
            en = "- Territories to claim",
            fr = "- Territoires à conquérir",
        },
    },

    CityBuilding = {
        Title = {
            de = "Stadtgebäude",
            en = "City buildings",
            fr = "Bâtiment de la ville",
        },
        Text = {
            de = "- Menge benötigter Stadtgebäude",
            en = "- Needed amount of city buildings",
            fr = "- Quantité de bâtiments urbains nécessaires",
        },
    },

    OuterRimBuilding = {
        Title = {
            de = "Rohstoffgebäude",
            en = "Gatherer",
            fr = "Cueilleur",
        },
        Text = {
            de = "- Menge benötigter Rohstoffgebäude",
            en = "- Needed amount of gatherer",
            fr = "- Quantité de bâtiments de matières premières nécessaires",
        },
    },

    FarmerBuilding = {
        Title = {
            de = "Farmeinrichtungen",
            en = "Farming structure",
            fr = "Installations de la ferme",
        },
        Text = {
            de = "- Menge benötigter Nutzfläche",
            en = "- Needed amount of farming structure",
            fr = "- Quantité de surface utile nécessaire",
        },
    },

    Consume = {
        Title = {
            de = "",
            en = "",
            fr = "",
        },
        Text = {
            de = "- Durch Siedler zu konsumierende Menge",
            en = "- Amount to be consumed by the settlers",
            fr = "- Quantité à consommer par les settlers",
        },
    },

    Products = {
        Title = {
            de = "",
            en = "",
            fr = "",
        },
        Text = {
            de = "- Benötigte Menge",
            en = "- Needed amount",
            fr = "- Quantité nécessaire",
        },
    },

    Buff = {
        Title = {
            de = "Bonus aktivieren",
            en = "Activate Buff",
            fr = "Activer bonus",
        },
        Text = {
            de = "- Aktiviere diesen Bonus auf den Ruf der Stadt",
            en = "- Raise the city reputatition with this buff",
            fr = "- Active ce bonus sur la réputation de la ville",
        },
    },

    Leader = {
        Title = {
            de = "Batalione",
            en = "Battalions",
            fr = "Battalions",
        },
        Text = {
            de = "- Menge an Batalionen unterhalten",
            en = "- Battalions you need under your command",
            fr = "- Maintenir une quantité de bataillons",
        },
    },

    Soldiers = {
        Title = {
            de = "Soldaten",
            en = "Soldiers",
            fr = "Soldats",
        },
        Text = {
            de = "- Menge an Streitkräften unterhalten",
            en = "- Soldiers you need under your command",
            fr = "- Maintenir une quantité de forces armées",
        },
    },

    Worker = {
        Title = {
            de = "Arbeiter",
            en = "Workers",
            fr = "Travailleurs",
        },
        Text = {
            de = "- Menge an arbeitender Bevölkerung",
            en = "- Workers you need under your reign",
            fr = "- Quantité de population au travail",
        },
    },

    Entities = {
        Title = {
            de = "",
            en = "",
            fr = "",
        },
        Text = {
            de = "- Benötigte Menge",
            en = "- Needed Amount",
            fr = "- Quantité nécessaire",
        },
    },

    Buildings = {
        Title = {
            de = "Gebäude",
            en = "Buildings",
            fr = "Bâtiments",
        },
        Text = {
            de = "- Gesamtmenge an Gebäuden",
            en = "- Amount of buildings",
            fr = "- Total des bâtiments",
        },
    },

    Weapons = {
        Title = {
            de = "Waffen",
            en = "Weapons",
            fr = "Armes",
        },
        Text = {
            de = "- Benötigte Menge an Waffen",
            en = "- Needed amount of weapons",
            fr = "- Quantité d'armes nécessaire",
        },
    },

    HeavyWeapons = {
        Title = {
            de = "Belagerungsgeräte",
            en = "Siege Engines",
            fr = "Matériel de siège",
        },
        Text = {
            de = "- Benötigte Menge an Belagerungsgeräten",
            en = "- Needed amount of siege engine",
            fr = "- Quantité de matériel de siège nécessaire",
        },
    },

    Spouse = {
        Title = {
            de = "Ehefrauen",
            en = "Spouses",
            fr = "Épouses",
        },
        Text = {
            de = "- Benötigte Anzahl Ehefrauen in der Stadt",
            en = "- Needed amount of spouses in your city",
            fr = "- Nombre d'épouses nécessaires dans la ville",
        },
    },
};

