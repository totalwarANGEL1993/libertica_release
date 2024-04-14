-- Importiere diese Datei nachdem die regulären Beförderungsaufgaben importiert 
-- wurden. Sie kann einfach mit Script.Load geladen werden, aber dies muss in 
-- beiden Umgebungen erfolgen.

InitKnightTitleTablesOverwrite = function()
    KnightTitles = {}
    KnightTitles.Knight     = 0
    KnightTitles.Mayor      = 1
    KnightTitles.Baron      = 2
    KnightTitles.Earl       = 3
    KnightTitles.Marquees   = 4
    KnightTitles.Duke       = 5
    KnightTitles.Archduke   = 6

    -- ---------------------------------------------------------------------- --
    -- Rechte und Pflichten                                                  --
    -- ---------------------------------------------------------------------- --

    NeedsAndRightsByKnightTitle = {}

    -- Das Folgende gilt für Rechte und Bedürfnisse: Beides wird in der 
    -- Reihenfolge angezeigt, in der sie in der Tabelle aufgeführt sind.
    -- Es stehen nur 8 Symbole für die Rechte und nur 3 für die Bedürfnisse 
    -- zur Verfügung. Wenn etwas für den Spieler sichtbar sein muss, muss 
    -- es zuerst in die Tabelle eingefügt werden.

    -- Ritter -----------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Knight] = {
        ActivateNeedForPlayer,
        {
            Needs.Nutrition,                                    -- Bedarf: Nahrung
            Needs.Medicine,                                     -- Bedarf: Medizin
        },
        ActivateRightForPlayer,
        {
            Technologies.R_Gathering,                           -- Recht: Sammeln
            Technologies.R_Woodcutter,                          -- Recht: Holzfäller
            Technologies.R_StoneQuarry,                         -- Recht: Steinbruch
            Technologies.R_HuntersHut,                          -- Recht: Jäger
            Technologies.R_FishingHut,                          -- Recht: Fischereihütte
            Technologies.R_CattleFarm,                          -- Recht: Rinderfarm
            Technologies.R_GrainFarm,                           -- Recht: Getreidefarm
            Technologies.R_SheepFarm,                           -- Recht: Schaffarm
            Technologies.R_IronMine,                            -- Recht: Eisenmine
            Technologies.R_Beekeeper,                           -- Recht: Imker
            Technologies.R_HerbGatherer,                        -- Recht: Kräutersammler
            Technologies.R_Nutrition,                           -- Recht: Ernährung
            Technologies.R_Bakery,                              -- Recht: Bäckerei
            Technologies.R_Dairy,                               -- Recht: Molkerei
            Technologies.R_Butcher,                             -- Recht: Metzger
            Technologies.R_SmokeHouse,                          -- Recht: Räucherei
            Technologies.R_Clothes,                             -- Recht: Kleidung
            Technologies.R_Tanner,                              -- Recht: Gerber
            Technologies.R_Weaver,                              -- Recht: Weber
            Technologies.R_Construction,                        -- Recht: Bauwesen
            Technologies.R_Trail,                               -- Recht: Pfad
            Technologies.R_KnockDown,                           -- Recht: Abbruch
            Technologies.R_Sermon,                              -- Recht: Predigt
        }
    }

    -- Bürgermeister -----------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Mayor] = {
        ActivateNeedForPlayer,
        {
            Needs.Clothes,                                      -- Bedarf: Kleidung
        },
        ActivateRightForPlayer,
        {
            Technologies.R_Military,                            -- Recht: Militär
            Technologies.R_MilitarySword,                       -- Recht: Schwertkämpfer
            Technologies.R_Thieves,                             -- Recht: Diebe
            Technologies.R_Hygiene,                             -- Recht: Hygiene
            Technologies.R_Soapmaker,                           -- Recht: Seifenmacher
            Technologies.R_BroomMaker,                          -- Recht: Besenmacher
            Technologies.R_SpecialEdition,                      -- Recht: Spezialausgabe
            Technologies.R_SpecialEdition_Pavilion,             -- Recht: Pavillon (AeK SE)
            Technologies.R_SpecialEdition_StatueFamily,         -- Recht: Statue der Familie (AeK SE)
            -- Technologies.R_SwordSmith,                       
            -- Technologies.R_Barracks,                         
        },
        StartKnightsPromotionCelebration                        -- Starte Beförderungsfeier
    }

    -- Baron -------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Baron] = {
        ActivateNeedForPlayer,
        {
            Needs.Hygiene,                                      -- Bedarf: Hygiene
        },
        ActivateRightForPlayer,
        {
            Technologies.R_SiegeEngineWorkshop,                 -- Recht: Belagerungsmaschinenwerkstatt
            Technologies.R_BatteringRam,                        -- Recht: Rammbock
            Technologies.R_Pallisade,                           -- Recht: Palisade
            Technologies.R_Medicine,                            -- Recht: Medizin
            Technologies.R_Entertainment,                       -- Recht: Unterhaltung
            Technologies.R_Tavern,                              -- Recht: Taverne
            Technologies.R_Street,                              -- Recht: Straße
            Technologies.R_Festival,                            -- Recht: Festival
            Technologies.R_SpecialEdition_Column,               -- Recht: Säule (AeK SE)
        },
        StartKnightsPromotionCelebration                        -- Starte Beförderungsfeier
    }

    -- Graf --------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Earl] = {
        ActivateNeedForPlayer,
        {
            Needs.Entertainment,                                -- Bedarf: Unterhaltung
            Needs.Prosperity,                                   -- Bedarf: Wohlstand
        },
        ActivateRightForPlayer,
        {
            Technologies.R_MilitaryBow,                         -- Recht: Bogenschützen
            Technologies.R_Baths,                               -- Recht: Bäder
            Technologies.R_Prosperity,                          -- Recht: Wohlstand
            Technologies.R_Taxes,                               -- Recht: Steuern anpassen
            Technologies.R_SpecialEdition_StatueSettler,        -- Recht: Statue der Siedler (AeK SE)
            -- Technologies.R_BowMaker,                         
            -- Technologies.R_BarracksArchers,                  
        },
        StartKnightsPromotionCelebration                        -- Starte Beförderungsfeier
    }

    -- Marquis ----------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Marquees] = {
        ActivateNeedForPlayer,
        {
            Needs.Wealth,                                       -- Bedarf: Dekoration
        },
        ActivateRightForPlayer,
        {
            Technologies.R_Theater,                             -- Recht: Theater
            Technologies.R_Wealth,                              -- Recht: Dekorationen
            Technologies.R_BannerMaker,                         -- Recht: Bannerhersteller
            Technologies.R_SiegeTower,                          -- Recht: Belagerungsturm
            Technologies.R_Wall,                                -- Recht: Mauer
            Technologies.R_Ballista,                            -- Recht: Mauerkatapult
            Technologies.R_AmmunitionCart,                      -- Recht: Munitionswagen
            Technologies.R_SpecialEdition_StatueProduction,     -- Recht: Produktionsstatue (AeK SE)
        },
        StartKnightsPromotionCelebration                        -- Starte Beförderungsfeier
    }

    -- Herzog ------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Duke] = {
        ActivateNeedForPlayer,
        nil,
        ActivateRightForPlayer,
        {
            Technologies.R_Catapult,                            -- Recht: Katapult
            Technologies.R_Carpenter,                           -- Recht: Zimmermann
            Technologies.R_CandleMaker,                         -- Recht: Kerzenmacher
            Technologies.R_Blacksmith,                          -- Recht: Schmied
            Technologies.R_SpecialEdition_StatueDario,          -- Recht: Statue von Dario (AeK SE)
        },
        StartKnightsPromotionCelebration                        -- Starte Beförderungsfeier
    }

    -- Erzherzog ---------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Archduke] = {
        ActivateNeedForPlayer,
        nil,
        ActivateRightForPlayer,
        {
            Technologies.R_Victory                              -- Sieg
        },
        -- VictroryBecauseOfTitle,                              -- Sieg aufgrund des Titels
        StartKnightsPromotionCelebration                        -- Starte Beförderungsfeier
    }

    -- Addon -------------------------------------------------------------------

    if Framework.GetGameExtraNo() >= 1 then
        local TechnologiesTableIndex = 4;
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],Technologies.R_Cistern);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Mayor][TechnologiesTableIndex],Technologies.R_Beautification_Brazier);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Baron][TechnologiesTableIndex],Technologies.R_Beautification_Shrine);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Baron][TechnologiesTableIndex],Technologies.R_Beautification_Pillar);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],Technologies.R_Beautification_StoneBench);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Earl][TechnologiesTableIndex],Technologies.R_Beautification_Sundial);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Marquees][TechnologiesTableIndex],Technologies.R_Beautification_Vase);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Duke][TechnologiesTableIndex],Technologies.R_Beautification_VictoryColumn);
        table.insert(NeedsAndRightsByKnightTitle[KnightTitles.Archduke][TechnologiesTableIndex],Technologies.R_Beautification_TriumphalArch);
    end

    -- ---------------------------------------------------------------------- --
    -- Bedingungen                                                            --
    -- ---------------------------------------------------------------------- --

    KnightTitleRequirements = {}

    -- Bürgermeister -----------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Mayor] = {}
    KnightTitleRequirements[KnightTitles.Mayor].Headquarters = 1
    KnightTitleRequirements[KnightTitles.Mayor].Settlers = 10
    KnightTitleRequirements[KnightTitles.Mayor].Products = {
        {GoodCategories.GC_Clothes, 6},
    }

    -- Baron -------------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Baron] = {}
    KnightTitleRequirements[KnightTitles.Baron].Settlers = 30
    KnightTitleRequirements[KnightTitles.Baron].Headquarters = 1
    KnightTitleRequirements[KnightTitles.Baron].Storehouse = 1
    KnightTitleRequirements[KnightTitles.Baron].Cathedrals = 1
    KnightTitleRequirements[KnightTitles.Baron].Products = {
        {GoodCategories.GC_Hygiene, 12},
    }

    -- Graf --------------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Earl] = {}
    KnightTitleRequirements[KnightTitles.Earl].Settlers = 50
    KnightTitleRequirements[KnightTitles.Earl].Headquarters = 2
    KnightTitleRequirements[KnightTitles.Earl].Goods = {
        {Goods.G_Beer, 18},
    }

    -- Marquis -----------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Marquees] = {}
    KnightTitleRequirements[KnightTitles.Marquees].Settlers = 70
    KnightTitleRequirements[KnightTitles.Marquees].Headquarters = 2
    KnightTitleRequirements[KnightTitles.Marquees].Storehouse = 2
    KnightTitleRequirements[KnightTitles.Marquees].Cathedrals = 2
    KnightTitleRequirements[KnightTitles.Marquees].RichBuildings = 20

    -- Herzog ------------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Duke] = {}
    KnightTitleRequirements[KnightTitles.Duke].Settlers = 90
    KnightTitleRequirements[KnightTitles.Duke].Storehouse = 2
    KnightTitleRequirements[KnightTitles.Duke].Cathedrals = 2
    KnightTitleRequirements[KnightTitles.Duke].Headquarters = 3
    KnightTitleRequirements[KnightTitles.Duke].DecoratedBuildings = {
        {Goods.G_Banner, 9 },
    }

    -- Erzherzog ---------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Archduke] = {}
    KnightTitleRequirements[KnightTitles.Archduke].Settlers = 150
    KnightTitleRequirements[KnightTitles.Archduke].Storehouse = 3
    KnightTitleRequirements[KnightTitles.Archduke].Cathedrals = 3
    KnightTitleRequirements[KnightTitles.Archduke].Headquarters = 3
    KnightTitleRequirements[KnightTitles.Archduke].RichBuildings = 30
    KnightTitleRequirements[KnightTitles.Archduke].FullDecoratedBuildings = 30

    -- Aktiviere Einstellungen
    CreateTechnologyKnightTitleTable()
end

