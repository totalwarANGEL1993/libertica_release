--- @diagnostic disable: cast-local-type
--- @diagnostic disable: missing-return-value

Lib.Promotion = Lib.Promotion or {};
Lib.Promotion.Name = "Promotion";
Lib.Promotion.Global = {};
Lib.Promotion.Local = {};
Lib.Promotion.Shared = {
    TechnologiesToResearch = {},
};

CONST_REQUIREMENT_TOOLTIP_TYPE = {};
CONST_CONSUMED_GOODS_COUNTER = {};

Lib.Require("core/Core");
Lib.Require("module/faker/Technology");
Lib.Require("module/ui/UITools");
Lib.Require("module/city/Promotion_API");
Lib.Require("module/city/Promotion_Config");
Lib.Require("module/city/Promotion_Helper");
Lib.Require("module/city/Promotion_Requirements");
Lib.Register("module/city/Promotion");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Promotion.Global:Initialize()
    if not self.IsInstalled then
        Report.KnightTitleChanged = CreateReport("Event_KnightTitleChanged");
        Report.GoodsConsumed = CreateReport("Event_GoodsConsumed");

        Lib.Promotion.Shared:CreateTechnologies();
        Lib.Promotion.Shared:UpdateInvisibleTechnologies();
        Lib.Promotion.Shared:InitRelatedTechnologies();
        Lib.Promotion.Shared:OverwriteTitleTechnologyUpdate();

        self:OverrideKnightTitleChanged();
        self:OverwriteConsumedGoods();

        -- Garbage collection
        Lib.Promotion.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Promotion.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Promotion.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        Lib.Promotion.Helper.OverwritePromotionHelper();
        InitKnightTitleTables = InitKnightTitleTablesOverwrite;
        InitKnightTitleTables();
        for i= 1, 8 do
            ActivateNeedsAndRightsForPlayerByKnightTitle(i, 0);
        end
        self.LoadscreenClosed = true;
    elseif _ID == Report.KnightTitleChanged then
        self:UnlockRelatedTechnologies(arg[1], arg[2]);
        local Consume = CONST_CONSUMED_GOODS_COUNTER[arg[1]];
        CONST_CONSUMED_GOODS_COUNTER[arg[1]] = Consume or {};
        for k,v in pairs(CONST_CONSUMED_GOODS_COUNTER[arg[1]]) do
            CONST_CONSUMED_GOODS_COUNTER[arg[1]][k] = 0;
        end
    elseif _ID == Report.GoodsConsumed then
        local PlayerID = Logic.EntityGetPlayer(arg[1]);
        self:RegisterConsumedGoods(PlayerID, arg[2]);
    end
end

function Lib.Promotion.Global:RegisterConsumedGoods(_PlayerID, _Good)
    CONST_CONSUMED_GOODS_COUNTER[_PlayerID]        = CONST_CONSUMED_GOODS_COUNTER[_PlayerID] or {};
    CONST_CONSUMED_GOODS_COUNTER[_PlayerID][_Good] = CONST_CONSUMED_GOODS_COUNTER[_PlayerID][_Good] or 0;
    CONST_CONSUMED_GOODS_COUNTER[_PlayerID][_Good] = CONST_CONSUMED_GOODS_COUNTER[_PlayerID][_Good] +1;
end

function Lib.Promotion.Global:OverrideKnightTitleChanged()
    GameCallback_KnightTitleChanged_Orig_Promo = GameCallback_KnightTitleChanged;
    GameCallback_KnightTitleChanged = function(_PlayerID, _TitleID)
        GameCallback_KnightTitleChanged_Orig_Promo(_PlayerID, _TitleID);
        SendReport(Report.KnightTitleChanged, _PlayerID, _TitleID);
        SendReportToLocal(Report.KnightTitleChanged, _PlayerID, _TitleID);
    end
end

function Lib.Promotion.Global:OverwriteConsumedGoods()
    GameCallback_ConsumeGood_Orig_Promo = GameCallback_ConsumeGood;
    GameCallback_ConsumeGood = function(_Consumer, _Good, _Building)
        GameCallback_ConsumeGood_Orig_Promo(_Consumer, _Good, _Building)
        SendReport(Report.GoodsConsumed, _Consumer, _Good, _Building);
        SendReportToLocal(Report.GoodsConsumed, _Consumer, _Good, _Building);
    end
end

-- Unlocks technologies mapped to a technology researched by the new knight
-- title if they are still prohibited.
function Lib.Promotion.Global:UnlockRelatedTechnologies(_PlayerID, _TitleID)
    if NeedsAndRightsByKnightTitle[_TitleID] then
        for k,v in pairs(NeedsAndRightsByKnightTitle[_TitleID][4]) do
            if Lib.Promotion.Shared.TechnologiesToResearch[v] then
                for _,Technology in pairs(Lib.Promotion.Shared.TechnologiesToResearch[v]) do
                    if Logic.TechnologyGetState(_PlayerID, Technology) == 0
                    or Logic.TechnologyGetState(_PlayerID, Technology) == 2 then
                        Logic.TechnologySetState(_PlayerID, Technology, 3);
                    end
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Promotion.Local:Initialize()
    if not self.IsInstalled then
        Report.KnightTitleChanged = CreateReport("Event_KnightTitleChanged");
        Report.GoodsConsumed = CreateReport("Event_GoodsConsumed");

        Lib.Promotion.Shared:CreateTechnologies();
        Lib.Promotion.Shared:UpdateInvisibleTechnologies();
        Lib.Promotion.Shared:InitRelatedTechnologies();
        Lib.Promotion.Shared:OverwriteTitleTechnologyUpdate();

        self:InitTexturePositions();
        self:OverwriteUpdateRequirements();
        self:OverwriteTooltips();

        -- Garbage collection
        Lib.Promotion.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Promotion.Local:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Promotion.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        Lib.Promotion.Helper.OverwritePromotionHelper();
        InitKnightTitleTables = InitKnightTitleTablesOverwrite;
        InitKnightTitleTables();
        self.LoadscreenClosed = true;
    elseif _ID == Report.KnightTitleChanged then
        local Consume = CONST_CONSUMED_GOODS_COUNTER[arg[1]];
        CONST_CONSUMED_GOODS_COUNTER[arg[1]] = Consume or {};
        for k,v in pairs(CONST_CONSUMED_GOODS_COUNTER[arg[1]]) do
            CONST_CONSUMED_GOODS_COUNTER[arg[1]][k] = 0;
        end
    elseif _ID == Report.GoodsConsumed then
        local PlayerID = Logic.EntityGetPlayer(arg[1]);
        self:RegisterConsumedGoods(PlayerID, arg[2]);
    end
end

function Lib.Promotion.Local:RegisterConsumedGoods(_PlayerID, _Good)
    CONST_CONSUMED_GOODS_COUNTER[_PlayerID]        = CONST_CONSUMED_GOODS_COUNTER[_PlayerID] or {};
    CONST_CONSUMED_GOODS_COUNTER[_PlayerID][_Good] = CONST_CONSUMED_GOODS_COUNTER[_PlayerID][_Good] or 0;
    CONST_CONSUMED_GOODS_COUNTER[_PlayerID][_Good] = CONST_CONSUMED_GOODS_COUNTER[_PlayerID][_Good] +1;
end

function Lib.Promotion.Local:InitTexturePositions()
    Lib.Promotion.Config:InitTexturePositions();
    Lib.Promotion.Config:InitTexturePositionsAddon();
end

function Lib.Promotion.Local:OverwriteUpdateRequirements()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Knight.UpdateRequirements = function()
        local WidgetPos = Lib.Promotion.Config.RequirementWidgets;
        local RequirementsIndex = 1;

        local PlayerID = GUI.GetPlayerID();
        local CurrentTitle = Logic.GetKnightTitle(PlayerID);
        local NextTitle = CurrentTitle + 1;

        -- Headline
        local KnightID = Logic.GetKnightID(PlayerID);
        local KnightType = Logic.GetEntityType(KnightID);
        XGUIEng.SetText("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/NextKnightTitle", "{center}" .. GUI_Knight.GetTitleNameByTitleID(KnightType, NextTitle));
        XGUIEng.SetText("/InGame/Root/Normal/AlignBottomRight/KnightTitleMenu/NextKnightTitleWhite", "{center}" .. GUI_Knight.GetTitleNameByTitleID(KnightType, NextTitle));

        -- show Settlers
        if KnightTitleRequirements[NextTitle].Settlers ~= nil then
            ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", {5,16})
            local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededNumberOfSettlersForKnightTitleExist(PlayerID, NextTitle)
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount)
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1)
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0)
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1)

            CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Settlers";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- show rich buildings
        if KnightTitleRequirements[NextTitle].RichBuildings ~= nil then
            ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", {8,4});
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfRichBuildingsForKnightTitleExist(PlayerID, NextTitle);
            if NeededAmount == -1 then
                NeededAmount = Logic.GetNumberOfPlayerEntitiesInCategory(PlayerID, EntityCategories.CityBuilding);
            end
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "RichBuildings";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Castle
        if KnightTitleRequirements[NextTitle].Headquarters ~= nil then
            ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", {4,7});
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededSpecialBuildingUpgradeForKnightTitleExist(PlayerID, NextTitle, EntityCategories.Headquarters);
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount + 1 .. "/" .. NeededAmount + 1);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Headquarters";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Storehouse
        if KnightTitleRequirements[NextTitle].Storehouse ~= nil then
            ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", {4,6});
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededSpecialBuildingUpgradeForKnightTitleExist(PlayerID, NextTitle, EntityCategories.Storehouse);
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount + 1 .. "/" .. NeededAmount + 1);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Storehouse";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Cathedral
        if KnightTitleRequirements[NextTitle].Cathedrals ~= nil then
            ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", {4,5});
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededSpecialBuildingUpgradeForKnightTitleExist(PlayerID, NextTitle, EntityCategories.Cathedrals);
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount + 1 .. "/" .. NeededAmount + 1);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Cathedrals";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Volldekorierte Gebäude
        if KnightTitleRequirements[NextTitle].FullDecoratedBuildings ~= nil then
            local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfFullDecoratedBuildingsForKnightTitleExist(PlayerID, NextTitle);
            local EntityCategory = KnightTitleRequirements[NextTitle].FullDecoratedBuildings;
            ChangeIcon(WidgetPos[RequirementsIndex].."/Icon"  , g_TexturePositions.Needs[Needs.Wealth]);

            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] , 1);

            CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "FullDecoratedBuildings";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Stadtruf
        if KnightTitleRequirements[NextTitle].Reputation ~= nil then
            ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", {5,14});
            local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededCityReputationForKnightTitleExist(PlayerID, NextTitle);
            XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
            if IsFulfilled then
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
            else
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
            end
            XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

            CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Reputation";
            RequirementsIndex = RequirementsIndex +1;
        end

        -- Güter sammeln
        if KnightTitleRequirements[NextTitle].Goods ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Goods do
                local GoodType = KnightTitleRequirements[NextTitle].Goods[i][1];
                ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.Goods[GoodType]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededNumberOfGoodTypesForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Goods" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Kategorien
        if KnightTitleRequirements[NextTitle].Category ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Category do
                local Category = KnightTitleRequirements[NextTitle].Category[i][1];
                ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.EntityCategories[Category]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededNumberOfEntitiesInCategoryForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                local EntitiesInCategory = {Logic.GetEntityTypesInCategory(Category)};
                if Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.GC_Weapon_Supplier) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Weapons" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.SiegeEngine) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "HeavyWeapons" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Spouse) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Spouse" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Worker) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Worker" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Soldier) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Soldiers" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Leader) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Leader" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.Outpost) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Outposts" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.CattlePasture) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Cattle" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.SheepPasture) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Sheep" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.CityBuilding) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "CityBuilding" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.OuterRimBuilding) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "OuterRimBuilding" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.GrainField) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "FarmerBuilding" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.BeeHive) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "FarmerBuilding" .. i;
                elseif Logic.IsEntityTypeInCategory(EntitiesInCategory[1], EntityCategories.AttackableBuilding) == 1 then
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Buildings" .. i;
                else
                    CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "EntityCategoryDefault" .. i;
                end
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Entities
        if KnightTitleRequirements[NextTitle].Entities ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Entities do
                local EntityType = KnightTitleRequirements[NextTitle].Entities[i][1];
                local EntityTypeName = Logic.GetEntityTypeName(EntityType);
                ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.Entities[EntityType]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoesNeededNumberOfEntitiesOfTypeForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                local TopltipType = "Entities" .. i;
                if EntityTypeName == "B_Beehive" or EntityTypeName:find("GrainField") or EntityTypeName:find("Pasture") then
                    TopltipType = "FarmerBuilding" .. i;
                end
                CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = TopltipType;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Güter konsumieren
        if KnightTitleRequirements[NextTitle].Consume ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Consume do
                local GoodType = KnightTitleRequirements[NextTitle].Consume[i][1];
                ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.Goods[GoodType]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfConsumedGoodsForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Consume" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Güter aus Gruppe produzieren
        if KnightTitleRequirements[NextTitle].Products ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Products do
                local Product = KnightTitleRequirements[NextTitle].Products[i][1];
                ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.GoodCategories[Product]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoNumberOfProductsInCategoryExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Products" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Bonus aktivieren
        if KnightTitleRequirements[NextTitle].Buff ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Buff do
                local Buff = KnightTitleRequirements[NextTitle].Buff[i];
                ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", g_TexturePositions.Buffs[Buff]);
                local IsFulfilled = DoNeededDiversityBuffForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "");
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Buff" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Selbstdefinierte Bedingung
        if KnightTitleRequirements[NextTitle].Custom ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].Custom do
                local FileBaseName;
                local Icon = table.copy(KnightTitleRequirements[NextTitle].Custom[i][2]);
                if type(Icon[3]) == "string" then
                    FileBaseName = Icon[3];
                    Icon[3] = 0;
                end
                ChangeIcon(WidgetPos[RequirementsIndex] .. "/Icon", Icon, nil, FileBaseName);
                local IsFulfilled, CurrentAmount, NeededAmount = DoCustomFunctionForKnightTitleSucceed(PlayerID, NextTitle, i);
                if CurrentAmount and NeededAmount then
                    XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                else
                    XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "");
                end
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "Custom" .. i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Dekorationselemente
        if KnightTitleRequirements[NextTitle].DecoratedBuildings ~= nil then
            for i=1, #KnightTitleRequirements[NextTitle].DecoratedBuildings do
                local GoodType = KnightTitleRequirements[NextTitle].DecoratedBuildings[i][1];
                ChangeIcon(WidgetPos[RequirementsIndex].."/Icon", g_TexturePositions.Goods[GoodType]);
                local IsFulfilled, CurrentAmount, NeededAmount = DoNeededNumberOfDecoratedBuildingsForKnightTitleExist(PlayerID, NextTitle, i);
                XGUIEng.SetText(WidgetPos[RequirementsIndex] .. "/Amount", "{center}" .. CurrentAmount .. "/" .. NeededAmount);
                if IsFulfilled then
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 1);
                else
                    XGUIEng.ShowWidget(WidgetPos[RequirementsIndex] .. "/Done", 0);
                end
                XGUIEng.ShowWidget(WidgetPos[RequirementsIndex], 1);

                CONST_REQUIREMENT_TOOLTIP_TYPE[RequirementsIndex] = "DecoratedBuildings" ..i;
                RequirementsIndex = RequirementsIndex +1;
            end
        end

        -- Übrige ausblenden
        for i=RequirementsIndex, 6 do
            XGUIEng.ShowWidget(WidgetPos[i], 0);
        end
    end
end

function Lib.Promotion.Local:OverwriteTooltips()
    GUI_Tooltip.SetNameAndDescription_Orig_QSB_Requirements = GUI_Tooltip.SetNameAndDescription;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Tooltip.SetNameAndDescription = function(...)
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();

        for k,v in pairs(Lib.Promotion.Config.RequirementWidgets) do
            if v .. "/Icon" == XGUIEng.GetWidgetPathByID(CurrentWidgetID) then
                local key = CONST_REQUIREMENT_TOOLTIP_TYPE[k];
                local num = tonumber(string.sub(key, string.len(key)));
                if num ~= nil then
                    key = string.sub(key, 1, string.len(key)-1);
                end
                Lib.Promotion.Local:RequirementTooltipWrapped(key, num);
                return;
            end
        end
        GUI_Tooltip.SetNameAndDescription_Orig_QSB_Requirements(...);
    end

    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Knight.RewardTooltip = function(_ButtonIndex)
        Lib.Promotion.Local:RewardTooltipWrapped(_ButtonIndex);
    end

    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Knight.RequiredGoodTooltip = function()
        local key = CONST_REQUIREMENT_TOOLTIP_TYPE[2];
        local num = tonumber(string.sub(key, string.len(key)));
        if num ~= nil then
            key = string.sub(key, 1, string.len(key)-1);
        end
        Lib.Promotion.Local:RequirementTooltipWrapped(key, num);
    end

    Lib.Promotion.Config:InitAddonText();
end

function Lib.Promotion.Local:RewardTooltipWrapped(_i)
    local TechnologyType = GUI_Knight.NextRightsForTitle[_i];
    local TechnologyTypeName =  GetNameOfKeyInTable(Technologies, TechnologyType);
    local Name = string.gsub(TechnologyTypeName, "R_", "");
    local TooltipName = "";

    local Key = "B_" .. Name;
    if GetStringText("UI_ObjectNames/" .. Key) == "" then
        Key = "U_" .. Name;
    end
    if GetStringText("UI_ObjectNames/" .. Key) == "" then
        Key = "Start" .. Name;
    end
    if GetStringText("UI_ObjectNames/" .. Key) == "" then
        Key = "R_" .. Name;
    end

    TooltipName = GetStringText("UI_ObjectNames/" .. Key);
    SetTooltipNormal(Localize(TooltipName), "");
end

function Lib.Promotion.Local:RequirementTooltipWrapped(_key, _i)
    local PlayerID = GUI.GetPlayerID();
    local KnightTitle = Logic.GetKnightTitle(PlayerID);
    local Title = ""
    local Text = "";

    if _key == "Consume" or _key == "Goods" or _key == "DecoratedBuildings" then
        local GoodType     = KnightTitleRequirements[KnightTitle+1][_key][_i][1];
        local GoodTypeName = Logic.GetGoodTypeName(GoodType);
        local GoodName     = GetStringText("UI_ObjectNames/" .. GoodTypeName);

        if GoodName == nil then
            GoodName = "Goods." .. GoodTypeName;
        end
        Title = GoodName;
        Text  = Lib.Promotion.Config.Description[_key].Text;

    elseif _key == "Products" then
        local GoodCategoryNames = Lib.Promotion.Config.GoodCategoryNames;
        local Category = KnightTitleRequirements[KnightTitle+1][_key][_i][1];
        local CategoryName = Localize(GoodCategoryNames[Category]);

        if CategoryName == nil then
            CategoryName = "ERROR: Name missng!";
        end
        Title = CategoryName;
        Text  = Lib.Promotion.Config.Description[_key].Text;

    elseif _key == "Entities" then
        local EntityType     = KnightTitleRequirements[KnightTitle+1][_key][_i][1];
        local EntityTypeName = Logic.GetEntityTypeName(EntityType);
        local EntityName = GetStringText("Names/" .. EntityTypeName);

        if EntityName == nil then
            EntityName = "Entities." .. EntityTypeName;
        end

        Title = EntityName;
        Text  = Lib.Promotion.Config.Description[_key].Text;

    elseif _key == "Custom" then
        local Custom = KnightTitleRequirements[KnightTitle+1].Custom[_i];
        Title = Custom[3];
        Text  = Custom[4];

    elseif _key == "Buff" then
        local BuffTypeNames = Lib.Promotion.Config.BuffTypeNames;
        local BuffType = KnightTitleRequirements[KnightTitle+1][_key][_i];
        local BuffTitle = Localize(BuffTypeNames[BuffType]);

        if BuffTitle == nil then
            BuffTitle = "ERROR: Name missng!";
        end
        Title = BuffTitle;
        Text  = Lib.Promotion.Config.Description[_key].Text;

    else
        Title = Lib.Promotion.Config.Description[_key].Title;
        Text  = Lib.Promotion.Config.Description[_key].Text;
    end
    SetTooltipNormal(Localize(Title), Localize(Text), nil);
end

-- -------------------------------------------------------------------------- --
-- Shared

-- A workaround that clears all technologies.
InitKnightTitleTables = function()
    NeedsAndRightsByKnightTitle = {};
    KnightTitleRequirements = {};
end

function Lib.Promotion.Shared:UpdateInvisibleTechnologies()
    if not IsLocalScript() then
        return;
    end
    if TechnologiesNotShownForKnightTitle == nil then
        TechnologiesNotShownForKnightTitle = {};
        TechnologiesNotShownForKnightTitle[Technologies.R_Nutrition] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_Clothes] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_Hygiene] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_Entertainment] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_Wealth] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_Prosperity] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_Military] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_Column] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_Pavilion] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_StatueDario] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_StatueFamily] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_StatueProduction] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_SpecialEdition_StatueSettler] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_Victory] = true;

        -- Disabled to make space in the window
        TechnologiesNotShownForKnightTitle[Technologies.R_Barracks] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_BarracksArchers] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_BowMaker] = true;
        TechnologiesNotShownForKnightTitle[Technologies.R_SwordSmith] = true;
    end

    -- If io module is used this pseudo technology exists
    if g_GameExtraNo > 0 and Technologies.R_CallGeologist then
        TechnologiesNotShownForKnightTitle[Technologies.R_CallGeologist] = true;
    end
end

function Lib.Promotion.Shared:OverwriteTitleTechnologyUpdate()
    CreateTechnologyKnightTitleTable = function()
        KnightTitleNeededForTechnology = {};
        for KnightTitle = 0, #NeedsAndRightsByKnightTitle do
            local TechnologyTable = NeedsAndRightsByKnightTitle[KnightTitle][4];
            if TechnologyTable ~= nil then
                for i=1, #TechnologyTable do
                    local TechnologyType = TechnologyTable[i];
                    KnightTitleNeededForTechnology[TechnologyType] = KnightTitle;

                    -- Set required title for the relatives of the technology
                    local Relatives = Lib.Promotion.Shared.TechnologiesToResearch;
                    if Relatives[TechnologyType] then
                        for j= 1, #Relatives[TechnologyType] do
                            RelativeType = Relatives[TechnologyType][j];
                            KnightTitleNeededForTechnology[RelativeType] = KnightTitle;
                        end
                    end
                end
            end
        end
    end
end

function Lib.Promotion.Shared:InitRelatedTechnologies()
    self.TechnologiesToResearch[Technologies.R_MilitaryBow] = {
        Technologies.R_BarracksArchers,
        Technologies.R_BowMaker,
    };
    self.TechnologiesToResearch[Technologies.R_MilitarySword] = {
        Technologies.R_Barracks,
        Technologies.R_SwordSmith,
    };
end

function Lib.Promotion.Shared:CreateTechnologies()
    for i= 1, #Lib.Promotion.Config.Technology do
        local Technology = Lib.Promotion.Config.Technology[i];
        if g_GameExtraNo >= Technology[4] then
            if not Technologies[Technology[1]] then
                AddCustomTechnology(Technology[1], Technology[2], Technology[3]);
                -- The technologies are not to be researched EVER!
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Promotion.Name);

