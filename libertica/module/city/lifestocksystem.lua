Lib.LifestockSystem = Lib.LifestockSystem or {};
Lib.LifestockSystem.Name = "LifestockSystem";
Lib.LifestockSystem.Global = {
    CattleBasePrice = 300,
    CattleGrainCost = 10,
    CattleGrainUpkeep = 1,
    CattleFeedingTimer = 0,
    CattleStarveChance = 35,
    SheepBasePrice = 300,
    SheepGrainCost = 10,
    SheepGrainUpkeep = 1,
    SheepFeedingTimer = 0,
    SheepStarveChance = 35,

    Text = {
        CattleStaved = "",
        SheepStarved = "",
    }
};
Lib.LifestockSystem.Local  = {
    BuyLock = false,
    CattleBasePrice = 300,
    CattleGrainCost = 10,
    CattleGrainUpkeep = 1,
    CattleFeedingTimer = 0,
    CattleStarveChance = 35,
    SheepBasePrice = 300,
    SheepGrainCost = 10,
    SheepGrainUpkeep = 1,
    SheepFeedingTimer = 0,
    SheepStarveChance = 35,

    Text = {
        CattleTitle = "",
        CattleDescription = "",
        CattleDisabled = "",
        SheepTitle = "",
        SheepDescription = "",
        SheepDisabled = "",
    }
};
Lib.LifestockSystem.Shared = {
    TechnologyConfig = {
        -- Tech name, Description, Icon, Extra Number
        {"R_Cattle", {de = "Kühe züchten",   en = "Breeding Cows",   fr = "Vaches reproductrices"}, {3, 16, 0}, 0},
        {"R_Sheep",  {de = "Schafe züchten", en = "Breeding Sheeps", fr = "Moutons reproducteurs"}, {4,  1, 0}, 0},
    },
};

Lib.Require("comfort/global/SetHealth");
Lib.Require("core/Core");
Lib.Require("module/ui/UIEffects");
Lib.Require("module/ui/UITools");
Lib.Require("module/ui/UIBuilding");
Lib.Require("module/faker/Technology");
Lib.Require("module/city/Promotion");
Lib.Require("module/city/LifestockSystem_API");
Lib.Require("module/city/LifestockSystem_Text");
Lib.Register("module/city/LifestockSystem");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.LifestockSystem.Global:Initialize()
    if not self.IsInstalled then
        --- The player has clicked the buy animal button
        --- 
        --- #### Parameters
        --- * `Index   `   - "Cattle" or "Sheep"
        --- * `PlayerID`   - ID of player
        --- * `EntityID`   - ID of pasture
        Report.BreedAnimalClicked = CreateReport("Event_BreedAnimalClicked");

        --- The player has bought a cow.
        --- 
        --- #### Parameters
        --- * `PlayerID`   - ID of player
        --- * `EntityID`   - ID of created cow
        --- * `BuildingID` - ID of pasture
        Report.CattleBought = CreateReport("Event_CattleBought");

        --- The player has bought a sheep.
        --- 
        --- #### Parameters
        --- * `PlayerID`   - ID of player
        --- * `EntityID`   - ID of created sheep
        --- * `BuildingID` - ID of pasture
        Report.SheepBought = CreateReport("Event_SheepBought");

        --- A cow has starved.
        --- 
        --- #### Parameters
        --- * `PlayerID`   - ID of player
        --- * `EntityID`   - ID of created cow
        Report.CattleStarved = CreateReport("Event_CattleStarved");

        --- A sheep has starved.
        --- 
        --- #### Parameters
        --- * `PlayerID`   - ID of player
        --- * `EntityID`   - ID of created cow
        Report.SheepStarved = CreateReport("Event_SheepStarved");

        -- Get texts
        self.Text.CattleStarved = Localize(Lib.LifestockSystem.Text.CattleStarved);
        self.Text.SheepStarved = Localize(Lib.LifestockSystem.Text.SheepStarved);

        -- Change base prices
        MerchantSystem.BasePricesOrigModuleLifestockBreeding                = {};
        MerchantSystem.BasePricesOrigModuleLifestockBreeding[Goods.G_Sheep] = MerchantSystem.BasePrices[Goods.G_Sheep];
        MerchantSystem.BasePricesOrigModuleLifestockBreeding[Goods.G_Cow]   = MerchantSystem.BasePrices[Goods.G_Cow];

        MerchantSystem.BasePrices[Goods.G_Sheep] = self.SheepBasePrice;
        MerchantSystem.BasePrices[Goods.G_Cow]   = self.CattleBasePrice;

        -- Breeding
        Lib.LifestockSystem.Shared:CreateTechnologies();
        RequestJob(function()
            Lib.LifestockSystem.Global:ControlFeeding();
            Lib.LifestockSystem.Global:ControlDecay();
        end);

        -- Garbage collection
        Lib.LifestockSystem.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.LifestockSystem.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.LifestockSystem.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.LanguageChanged then
        self.Text.CattleStarved = Localize(Lib.LifestockSystem.Text.CattleStarved);
        self.Text.SheepStarved = Localize(Lib.LifestockSystem.Text.SheepStarved);
    elseif _ID == Report.BreedAnimalClicked then
        --- @diagnostic disable-next-line: param-type-mismatch
        Lib.LifestockSystem.Global:BuyAnimal(arg[1], arg[2], arg[3]);
    end
end

function Lib.LifestockSystem.Global:BuyAnimal(_Index, _PlayerID, _BuildingID)
    local AnimalType = (_Index == "Cattle" and Entities.A_X_Cow01) or Entities.A_X_Sheep01;
    local GrainCost = self[_Index.. "GrainCost"];
    if GetPlayerResources(Goods.G_Grain, _PlayerID) < GrainCost then
        return;
    end
    local x,y = Logic.GetBuildingApproachPosition(_BuildingID);
    local EntityID = Logic.CreateEntity(AnimalType, x, y, 0, _PlayerID);
    AddGood(Goods.G_Grain, (-1) * GrainCost, _PlayerID);
    SendReport(Report[_Index.. "Bought"], _PlayerID, EntityID, _BuildingID);
    SendReportToLocal(Report[_Index.. "Bought"], _PlayerID, EntityID, _BuildingID);
end

function Lib.LifestockSystem.Global:ControlFeeding()
    for PlayerID = 1, 8 do
        if Logic.PlayerGetIsHumanFlag(PlayerID) then
            -- Cattle
            local CattleTimer = self.CattleFeedingTimer;
            local CattleList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.CattlePasture)};
            if CattleTimer > 0 then
                local FeedingTime = math.max(CattleTimer * (1 - (0.03 * #CattleList)), 15);
                if #CattleList > 0 and Logic.GetTime() % math.floor(FeedingTime) == 0 then
                    local Upkeep = self.CattleGrainUpkeep;
                    local GrainAmount = GetPlayerResources(Goods.G_Grain, PlayerID);
                    if GrainAmount < Upkeep then
                        -- Make animals starve
                        local AnimalStarved = false;
                        for k,v in pairs(CattleList) do
                            local x,y,z = Logic.EntityGetPos(v);
                            local _,PastureID = Logic.GetEntitiesInArea(Entities.B_CattlePasture, x, y, 750, 1);
                            if IsExisting(PastureID) and math.random(1, 100) <= self.CattleStarveChance then
                                if Logic.GetEntityHealth(v) > 0 then
                                    SetHealth(v, 0);
                                end
                                SendReportToLocal(Report.CattleStarved, PlayerID, v);
                                SendReport(Report.CattleStarved, PlayerID, v);
                                AnimalStarved = true;
                            end
                        end
                        -- Show message if animals have starved
                        if AnimalStarved then
                            local Text = Localize(self.Text.CattleStarved);
                            AddMessage(Text);
                        end
                    else
                        AddGood(Goods.G_Grain, (-1) * Upkeep, PlayerID);
                    end
                end
            end
            -- Sheep
            local SheepTimer = self.SheepFeedingTimer;
            local SheepList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories.SheepPasture)};
            if SheepTimer > 0 then
                local FeedingTime = math.max(SheepTimer * (1 - (0.03 * #SheepList)), 15);
                if #SheepList > 0 and Logic.GetTime() % math.floor(FeedingTime) == 0 then
                    local Upkeep = self.SheepGrainUpkeep;
                    local GrainAmount = GetPlayerResources(Goods.G_Grain, PlayerID);
                    if GrainAmount < Upkeep then
                        -- Make animals starve
                        local AnimalStarved = false;
                        for k,v in pairs(SheepList) do
                            local x,y,z = Logic.EntityGetPos(v);
                            local _,PastureID = Logic.GetEntitiesInArea(Entities.B_CattlePasture, x, y, 750, 1);
                            if IsExisting(PastureID) and math.random(1, 100) <= self.SheepStarveChance then
                                if Logic.GetEntityHealth(v) > 0 then
                                    SetHealth(v, 0);
                                end
                                SendReportToLocal(Report.SheepStarved, PlayerID, v);
                                SendReport(Report.SheepStarved, PlayerID, v);
                            end
                        end
                        -- Show message if animals have starved
                        if AnimalStarved then
                            local Text = Localize(self.Text.SheepStarved);
                            AddMessage(Text);
                        end
                    else
                        AddGood(Goods.G_Grain, (-1) * Upkeep, PlayerID);
                    end
                end
            end
        end
    end
end

function Lib.LifestockSystem.Global:ControlDecay()
    if Logic.GetTime() % 10 == 0 then
        -- Cattle
        local CattleCorpses = Logic.GetEntitiesOfType(Entities.R_DeadCow);
        for k,v in pairs(CattleCorpses) do
            local x,y,z = Logic.EntityGetPos(v);
            local _,PastureID = Logic.GetEntitiesInArea(Entities.B_CattlePasture, x, y, 900, 1);
            if IsExisting(PastureID) then
                local GoodAmount = Logic.GetResourceDoodadGoodAmount(v);
                Logic.SetResourceDoodadGoodAmount(v, GoodAmount -1);
            end
        end
        -- Sheep
        local SheepCorpses = Logic.GetEntitiesOfType(Entities.R_DeadSheep);
        for k,v in pairs(SheepCorpses) do
            local x,y,z = Logic.EntityGetPos(v);
            local _,PastureID = Logic.GetEntitiesInArea(Entities.B_SheepPasture, x, y, 900, 1);
            if IsExisting(PastureID) then
                local GoodAmount = Logic.GetResourceDoodadGoodAmount(v);
                Logic.SetResourceDoodadGoodAmount(v, GoodAmount -1);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.LifestockSystem.Local:Initialize()
    if not self.IsInstalled then
        Report.BreedAnimalClicked = CreateReport("Event_BreedAnimalClicked");
        Report.CattleBought = CreateReport("Event_CattleBought");
        Report.SheepBought = CreateReport("Event_SheepBought");
        Report.CattleStarved = CreateReport("Event_CattleStarved");
        Report.SheepStarved = CreateReport("Event_SheepStarved");

        -- Get texts
        self.Text.CattleTitle = XGUIEng.GetStringTableText("Names/A_X_Cow01");
        self.Text.CattleDescription = XGUIEng.GetStringTableText("UI_ObjectDescription/G_Cow");
        self.Text.CattleDisabled = XGUIEng.GetStringTableText("UI_ButtonDisabled/PromoteKnight");
        self.Text.SheepTitle = XGUIEng.GetStringTableText("Names/A_X_Sheep01");
        self.Text.SheepDescription = XGUIEng.GetStringTableText("UI_ObjectDescription/G_Sheep");
        self.Text.SheepDisabled = XGUIEng.GetStringTableText("UI_ButtonDisabled/PromoteKnight");

        -- Change base prices
        MerchantSystem.BasePricesOrigModuleLifestockBreeding                = {};
        MerchantSystem.BasePricesOrigModuleLifestockBreeding[Goods.G_Sheep] = MerchantSystem.BasePrices[Goods.G_Sheep];
        MerchantSystem.BasePricesOrigModuleLifestockBreeding[Goods.G_Cow]   = MerchantSystem.BasePrices[Goods.G_Cow];

        MerchantSystem.BasePrices[Goods.G_Sheep] = self.SheepBasePrice;
        MerchantSystem.BasePrices[Goods.G_Cow]   = self.CattleBasePrice;

        -- Breeding
        Lib.LifestockSystem.Shared:CreateTechnologies();
        self:InitBuyCowButton();
        self:InitBuySheepButton();

        -- Garbage collection
        Lib.LifestockSystem.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.LifestockSystem.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.LifestockSystem.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.CattleBought then
        if arg[1] == GUI.GetPlayerID() then
            self.BuyLock = false;
        end
    elseif _ID == Report.SheepBought then
        if arg[1] == GUI.GetPlayerID() then
            self.BuyLock = false;
        end
    end
end

function Lib.LifestockSystem.Local:BuyAnimalAction(_Index, _WidgetID, _EntityID)
    local GrainCost = self[_Index.. "GrainCost"];
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if GetPlayerResources(Goods.G_Grain, PlayerID) < GrainCost then
        local Text = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_Resources");
        Message(Text);
        return;
    end
    -- Prevent click spam
    self.BuyLock = true;
    -- Send reports
    SendReportToGlobal(Report.BreedAnimalClicked, _Index, PlayerID, _EntityID);
    SendReport(Report.BreedAnimalClicked, _Index, PlayerID, _EntityID);
end

function Lib.LifestockSystem.Local:BuyAnimalTooltip(_Index, _WidgetID, _EntityID)
    local Title = self.Text[_Index.. "Title"];
    local Text  = self.Text[_Index.. "Description"];
    local Disabled = "";

    local GrainCost = self[_Index.. "GrainCost"];
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local TechType = (_Index == "Cattle" and Technologies.R_Cattle) or Technologies.R_Sheep;
    if Logic.TechnologyGetState(PlayerID, TechType) == 0 then
        local Key = GUI_Tooltip.GetDisabledKeyForTechnologyType(TechType);
        Disabled = GetStringText("UI_ButtonDisabled/" ..Key);
    elseif XGUIEng.IsButtonDisabled(_WidgetID) == 1 then
        Disabled = self.Text[_Index.. "Disabled"];
    end
    SetTooltipCosts(Title, Text, Disabled, {Goods.G_Grain, GrainCost}, true);
end

function Lib.LifestockSystem.Local:BuyAnimalUpdate(_Index, _WidgetID, _EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local TechType = (_Index == "Cattle" and Technologies.R_Cattle) or Technologies.R_Sheep;
    local PastureType = Logic.GetEntityType(_EntityID);
    local TechState = Logic.TechnologyGetState(PlayerID, TechType);
    local Icon = (_Index == "Cattle" and {3, 16}) or {4, 1};
    local DisabledFlag = 0;

    local PastureList = GetPlayerEntities(PlayerID, PastureType);
    local AnimalList = {Logic.GetPlayerEntitiesInCategory(PlayerID, EntityCategories[_Index.. "Pasture"])};

    if (TechState ~= TechnologyStates.Unlocked and TechState ~= TechnologyStates.Researched)
    or self.BuyLock or (#PastureList * 5) <= #AnimalList then
        Icon = (_Index == "Cattle" and {4, 2}) or {4, 3};
        DisabledFlag = 1;
    end
    XGUIEng.DisableButton(_WidgetID, DisabledFlag);
    SetIcon(_WidgetID, Icon);
end

function Lib.LifestockSystem.Local:InitBuyCowButton()
    local Position = {XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/BuyCatapultCart")};
    AddBuildingButtonByTypeAtPosition(
        Entities.B_CattlePasture,
        Position[1], Position[2],
        function(_WidgetID, _EntityID)
            Lib.LifestockSystem.Local:BuyAnimalAction("Cattle", _WidgetID, _EntityID);
        end,
        function(_WidgetID, _EntityID)
            Lib.LifestockSystem.Local:BuyAnimalTooltip("Cattle", _WidgetID, _EntityID);
        end,
        function(_WidgetID, _EntityID)
            Lib.LifestockSystem.Local:BuyAnimalUpdate("Cattle", _WidgetID, _EntityID);
        end
    )
end

function Lib.LifestockSystem.Local:InitBuySheepButton()
    local Position = {XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/BuyCatapultCart")};
    AddBuildingButtonByTypeAtPosition(
        Entities.B_SheepPasture,
        Position[1], Position[2],
        function(_WidgetID, _EntityID)
            Lib.LifestockSystem.Local:BuyAnimalAction("Sheep", _WidgetID, _EntityID);
        end,
        function(_WidgetID, _EntityID)
            Lib.LifestockSystem.Local:BuyAnimalTooltip("Sheep", _WidgetID, _EntityID);
        end,
        function(_WidgetID, _EntityID)
            Lib.LifestockSystem.Local:BuyAnimalUpdate("Sheep", _WidgetID, _EntityID);
        end
    )
end

-- -------------------------------------------------------------------------- --
-- Shared

function Lib.LifestockSystem.Shared:CreateTechnologies()
    for i= 1, #self.TechnologyConfig do
        if g_GameExtraNo >= self.TechnologyConfig[i][4] then
            if not Technologies[self.TechnologyConfig[i][1]] then
                AddCustomTechnology(self.TechnologyConfig[i][1], self.TechnologyConfig[i][2], self.TechnologyConfig[i][3]);
                if not IsLocalScript() then
                    for j= 1, 8 do
                        Logic.TechnologySetState(j, Technologies[self.TechnologyConfig[i][1]], 3);
                    end
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.LifestockSystem.Name);

