Lib.Register("module/city/Promotion_Requirements");

-- This is the real deal. Defines the requirements, needs and rights.
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
    -- Rights and Duties                                                      --
    -- ---------------------------------------------------------------------- --

    NeedsAndRightsByKnightTitle = {}

    -- The following applies to rights and needs: Both are displayed in the
    -- order they are listed in the table. There are only 8 icons available
    -- for the rights and only 3 for the needs. So if something needs to be
    -- visible for the player it must be put first in the table.

    -- Knight ------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Knight] = {
        ActivateNeedForPlayer,
        {
            Needs.Nutrition,                                    -- Need: Food
            Needs.Medicine,                                     -- Need: Medicine
        },
        ActivateRightForPlayer,
        {
            Technologies.R_Gathering,                           -- Right: Gathering
            Technologies.R_Woodcutter,                          -- Right: Woodcutter
            Technologies.R_StoneQuarry,                         -- Right: Stone Quarry
            Technologies.R_HuntersHut,                          -- Right: Hunter
            Technologies.R_FishingHut,                          -- Right: Fishing Hut
            Technologies.R_CattleFarm,                          -- Right: Cow Farm
            Technologies.R_GrainFarm,                           -- Right: Grain Farm
            Technologies.R_SheepFarm,                           -- Right: Sheep Farm
            Technologies.R_IronMine,                            -- Right: Iron Mine
            Technologies.R_Beekeeper,                           -- Right: Beekeeper
            Technologies.R_HerbGatherer,                        -- Right: Herb Gatherer
            Technologies.R_Nutrition,                           -- Right: Food
            Technologies.R_Bakery,                              -- Right: Bakery
            Technologies.R_Dairy,                               -- Right: Dairy
            Technologies.R_Butcher,                             -- Right: Butcher
            Technologies.R_SmokeHouse,                          -- Right: Smoke House
            Technologies.R_Clothes,                             -- Right: Clothes
            Technologies.R_Tanner,                              -- Right: Tanner
            Technologies.R_Weaver,                              -- Right: Weaver
            Technologies.R_Construction,                        -- Right: Construction
            Technologies.R_Trail,                               -- Right: Path
            Technologies.R_KnockDown,                           -- Right: Demolition
            Technologies.R_Sermon,                              -- Right: Sermon
        }
    }

    -- Mayor -------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Mayor] = {
        ActivateNeedForPlayer,
        {
            Needs.Clothes,                                      -- Need: Clothes
        },
        ActivateRightForPlayer,
        {
            Technologies.R_Military,                            -- Right: Military
            Technologies.R_MilitarySword,                       -- Right: Swordmen
            Technologies.R_Thieves,                             -- Right: Thief
            Technologies.R_Hygiene,                             -- Right: Hygiene
            Technologies.R_Soapmaker,                           -- Right: Soap Maker
            Technologies.R_BroomMaker,                          -- Right: Broom Maker
            Technologies.R_SpecialEdition,                      -- Right: Special Edition
            Technologies.R_SpecialEdition_Pavilion,             -- Right: Pavilion (AeK SE)
            Technologies.R_SpecialEdition_StatueFamily,         -- Right: Statue of Family (AeK SE)
            -- Technologies.R_SwordSmith,                          
            -- Technologies.R_Barracks,                            
        },
        StartKnightsPromotionCelebration                        -- Start promotion celebration
    }

    -- Baron -------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Baron] = {
        ActivateNeedForPlayer,
        {
            Needs.Hygiene,                                      -- Need: Hygiene
        },
        ActivateRightForPlayer,
        {
            Technologies.R_SiegeEngineWorkshop,                 -- Right: Siege Engine Workshop
            Technologies.R_BatteringRam,                        -- Right: Battering Ram
            Technologies.R_Pallisade,                           -- Right: Palisade
            Technologies.R_Medicine,                            -- Right: Medicine
            Technologies.R_Entertainment,                       -- Right: Entertainment
            Technologies.R_Tavern,                              -- Right: Tavern
            Technologies.R_Street,                              -- Right: Street
            Technologies.R_Festival,                            -- Right: Festival
            Technologies.R_SpecialEdition_Column,               -- Right: Pilar (AeK SE)
        },
        StartKnightsPromotionCelebration                        -- Start promotion celebration
    }

    -- Earl --------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Earl] = {
        ActivateNeedForPlayer,
        {
            Needs.Entertainment,                                -- Need: Entertainment
            Needs.Prosperity,                                   -- Need: Prosperity
        },
        ActivateRightForPlayer,
        {
            Technologies.R_MilitaryBow,                         -- Right: Swordmen
            Technologies.R_Baths,                               -- Right: Baths
            Technologies.R_Prosperity,                          -- Right: Prosperity
            Technologies.R_Taxes,                               -- Right: Adjust taxes
            Technologies.R_SpecialEdition_StatueSettler,        -- Right: Statue of Settlers (AeK SE)
            -- Technologies.R_BowMaker,                            
            -- Technologies.R_BarracksArchers,                     
        },
        StartKnightsPromotionCelebration                        -- Start promotion celebration
    }

    -- Marquees ----------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Marquees] = {
        ActivateNeedForPlayer,
        {
            Needs.Wealth,                                       -- Need: Decoration
        },
        ActivateRightForPlayer,
        {
            Technologies.R_Theater,                             -- Right: Theathre
            Technologies.R_Wealth,                              -- Right: Decorations
            Technologies.R_BannerMaker,                         -- Right: Banner Maker
            Technologies.R_SiegeTower,                          -- Right: Siege Tower
            Technologies.R_Wall,                                -- Right: Wall
            Technologies.R_Ballista,                            -- Right: Wall Catapult
            Technologies.R_AmmunitionCart,                      -- Right: Ammunition Cart
            Technologies.R_SpecialEdition_StatueProduction,     -- Right: Statue of Production (AeK SE)
        },
        StartKnightsPromotionCelebration                        -- Start promotion celebration
    }

    -- Duke --------------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Duke] = {
        ActivateNeedForPlayer,
        nil,
        ActivateRightForPlayer,
        {
            Technologies.R_Catapult,                            -- Right: Catapult
            Technologies.R_Carpenter,                           -- Right: Carpenter
            Technologies.R_CandleMaker,                         -- Right: Cancle Maker
            Technologies.R_Blacksmith,                          -- Right: Blacksmith
            Technologies.R_SpecialEdition_StatueDario,          -- Right: Statue of Dario (AeK SE)
        },
        StartKnightsPromotionCelebration                        -- Start promotion celebration
    }

    -- Archduke ----------------------------------------------------------------

    NeedsAndRightsByKnightTitle[KnightTitles.Archduke] = {
        ActivateNeedForPlayer,
        nil,
        ActivateRightForPlayer,
        {
            Technologies.R_Victory                              -- Victory
        },
        -- VictroryBecauseOfTitle,                              -- Victory because of title
        StartKnightsPromotionCelebration                        -- Start promotion celebration
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
    -- Conditions                                                             --
    -- ---------------------------------------------------------------------- --

    KnightTitleRequirements = {}

    -- Knight ------------------------------------------------------------------

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

    -- Earl --------------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Earl] = {}
    KnightTitleRequirements[KnightTitles.Earl].Settlers = 50
    KnightTitleRequirements[KnightTitles.Earl].Headquarters = 2
    KnightTitleRequirements[KnightTitles.Earl].Goods = {
        {Goods.G_Beer, 18},
    }

    -- Marquess ----------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Marquees] = {}
    KnightTitleRequirements[KnightTitles.Marquees].Settlers = 70
    KnightTitleRequirements[KnightTitles.Marquees].Headquarters = 2
    KnightTitleRequirements[KnightTitles.Marquees].Storehouse = 2
    KnightTitleRequirements[KnightTitles.Marquees].Cathedrals = 2
    KnightTitleRequirements[KnightTitles.Marquees].RichBuildings = 20

    -- Duke --------------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Duke] = {}
    KnightTitleRequirements[KnightTitles.Duke].Settlers = 90
    KnightTitleRequirements[KnightTitles.Duke].Storehouse = 2
    KnightTitleRequirements[KnightTitles.Duke].Cathedrals = 2
    KnightTitleRequirements[KnightTitles.Duke].Headquarters = 3
    KnightTitleRequirements[KnightTitles.Duke].DecoratedBuildings = {
        {Goods.G_Banner, 9 },
    }

    -- Archduke ----------------------------------------------------------------

    KnightTitleRequirements[KnightTitles.Archduke] = {}
    KnightTitleRequirements[KnightTitles.Archduke].Settlers = 150
    KnightTitleRequirements[KnightTitles.Archduke].Storehouse = 3
    KnightTitleRequirements[KnightTitles.Archduke].Cathedrals = 3
    KnightTitleRequirements[KnightTitles.Archduke].Headquarters = 3
    KnightTitleRequirements[KnightTitles.Archduke].RichBuildings = 30
    KnightTitleRequirements[KnightTitles.Archduke].FullDecoratedBuildings = 30

    -- Activate settings
    CreateTechnologyKnightTitleTable()
end

