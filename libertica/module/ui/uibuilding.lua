Lib.UIBuilding = Lib.UIBuilding or {};
Lib.UIBuilding.Name = "UIBuilding";
Lib.UIBuilding.Global = Lib.UIBuilding.Global or {};
Lib.UIBuilding.Local = Lib.UIBuilding.Local or {};
Lib.UIBuilding.Local.BuildingButtons = {
    BindingCounter = 0,
    Bindings = {},
};

Lib.Require("core/Core");
Lib.Require("module/ui/UIBuilding_API");
Lib.Require("module/ui/UIBuilding_Config");
Lib.Require("module/ui/UIBuilding_Text");
Lib.Require("module/ui/UIBuilding_Buttons");
Lib.Register("module/ui/UIBuilding");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.UIBuilding.Global:Initialize()
    if not self.IsInstalled then
        Report.CancelUpgradeClicked = CreateReport("Event_CancelUpgradeClicked");
        Report.StartUpgradeClicked = CreateReport("Event_StartUpgradeClicked");
        Report.FestivalClicked = CreateReport("Event_FestivalClicked");
        Report.SermonClicked = CreateReport("Event_SermonClicked");
        Report.TheatrePlayClicked = CreateReport("Event_TheatrePlayClicked");

        self.ExtraButton.Downgrade:InitEvents();
        self.ExtraButton.SingleReserve:InitEvents();
        self.ExtraButton.SingleStop:InitEvents();
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.UIBuilding.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.UIBuilding.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.StartUpgradeClicked then
        SendReportToLocal(_ID, ...);
    elseif _ID == Report.CancelUpgradeClicked then
        SendReportToLocal(_ID, ...);
    elseif _ID == Report.FestivalClicked then
        SendReportToLocal(_ID, ...);
    elseif _ID == Report.SermonClicked then
        SendReportToLocal(_ID, ...);
    elseif _ID == Report.TheatrePlayClicked then
        SendReportToLocal(_ID, ...);
    end
    self.ExtraButton.Downgrade:ExtraButtonOnReportReceived(_ID, ...);
    self.ExtraButton.SingleReserve:ExtraButtonOnReportReceived(_ID, ...);
    self.ExtraButton.SingleStop:ExtraButtonOnReportReceived(_ID, ...);
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.UIBuilding.Local:Initialize()
    if not self.IsInstalled then
        Report.CancelUpgradeClicked = CreateReport("Event_CancelUpgradeClicked");
        Report.StartUpgradeClicked = CreateReport("Event_StartUpgradeClicked");
        Report.FestivalClicked = CreateReport("Event_FestivalClicked");
        Report.SermonClicked = CreateReport("Event_SermonClicked");
        Report.TheatrePlayClicked = CreateReport("Event_TheatrePlayClicked");

        self:InitBackupPositions();
        self:OverrideOnSelectionChanged();
        self:OverrideBuyAmmunitionCart();
        self:OverrideBuyBattalion();
        self:OverrideBuySiegeEngineCart();
        self:OverridePlaceField();
        self:OverrideStartFestival();
        self:OverrideStartTheatrePlay();
        self:OverrideUpgradeTurret();
        self:OverrideUpgradeBuilding();
        self:OverrideStartSermon();

        self.ExtraButton.Downgrade:InitEvents();
        self.ExtraButton.SingleReserve:InitEvents();
        self.ExtraButton.SingleStop:InitEvents();
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.UIBuilding.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.UIBuilding.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
    self.ExtraButton.Downgrade:ExtraButtonOnReportReceived(_ID, ...);
    self.ExtraButton.SingleReserve:ExtraButtonOnReportReceived(_ID, ...);
    self.ExtraButton.SingleStop:ExtraButtonOnReportReceived(_ID, ...);
end

-- -------------------------------------------------------------------------- --

function Lib.UIBuilding.Local:OverrideOnSelectionChanged()
    self.Orig_GameCallback_GUI_SelectionChanged = GameCallback_GUI_SelectionChanged;
    GameCallback_GUI_SelectionChanged = function(_Source)
        Lib.UIBuilding.Local.Orig_GameCallback_GUI_SelectionChanged(_Source);
        Lib.UIBuilding.Local:UnbindButtons();
        Lib.UIBuilding.Local:BindButtons(GUI.GetSelectedEntity());
    end
end

function Lib.UIBuilding.Local:OverrideBuyAmmunitionCart()
    self.Orig_BuyAmmunitionCartClicked = GUI_BuildingButtons.BuyAmmunitionCartClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.BuyAmmunitionCartClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            return Lib.UIBuilding.Local.Orig_BuyAmmunitionCartClicked();
        end
        Button.Action(WidgetID, EntityID);
    end

    Lib.UIBuilding.Local.Orig_BuyAmmunitionCartUpdate = GUI_BuildingButtons.BuyAmmunitionCartUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.BuyAmmunitionCartUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        XGUIEng.SetMaterialColor(WidgetID, 7, 255, 255, 255, 255);
        if not Button then
            SetIcon(WidgetID, {10, 4});
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return Lib.UIBuilding.Local.Orig_BuyAmmunitionCartUpdate();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function Lib.UIBuilding.Local:OverrideBuyBattalion()
    self.Orig_BuyBattalionClicked = GUI_BuildingButtons.BuyBattalionClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.BuyBattalionClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            return Lib.UIBuilding.Local.Orig_BuyBattalionClicked();
        end
        Button.Action(WidgetID, EntityID);
    end

    self.Orig_BuyBattalionMouseOver = GUI_BuildingButtons.BuyBattalionMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.BuyBattalionMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if Lib.UIBuilding.Config.Buttons[WidgetName] then
            Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        end
        if not Button then
            return Lib.UIBuilding.Local.Orig_BuyBattalionMouseOver();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    self.Orig_BuyBattalionUpdate = GUI_BuildingButtons.BuyBattalionUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.BuyBattalionUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        XGUIEng.SetMaterialColor(WidgetID, 7, 255, 255, 255, 255);
        if not Button then
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return Lib.UIBuilding.Local.Orig_BuyBattalionUpdate();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function Lib.UIBuilding.Local:OverridePlaceField()
    self.Orig_PlaceFieldClicked = GUI_BuildingButtons.PlaceFieldClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.PlaceFieldClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            return Lib.UIBuilding.Local.Orig_PlaceFieldClicked();
        end
        Button.Action(WidgetID, EntityID);
    end

    self.Orig_PlaceFieldMouseOver = GUI_BuildingButtons.PlaceFieldMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.PlaceFieldMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            return Lib.UIBuilding.Local.Orig_PlaceFieldMouseOver();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    self.Orig_PlaceFieldUpdate = GUI_BuildingButtons.PlaceFieldUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.PlaceFieldUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        XGUIEng.SetMaterialColor(WidgetID, 7, 255, 255, 255, 255);
        if not Button then
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return Lib.UIBuilding.Local.Orig_PlaceFieldUpdate();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function Lib.UIBuilding.Local:OverrideStartFestival()
    self.Orig_StartKnightsPromotionCelebration = StartKnightsPromotionCelebration;
    StartKnightsPromotionCelebration = function(_PlayerID, _OldTitle, _FirstTime)
        Lib.UIBuilding.Local.Orig_StartKnightsPromotionCelebration(_PlayerID, _OldTitle, _FirstTime);
        SendReportToGlobal(Report.FestivalClicked, _PlayerID, 1);
    end

    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartFestivalClicked = function(_FestivalIndex)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            local PlayerID = GUI.GetPlayerID();
            local Costs = {Logic.GetFestivalCost(PlayerID, _FestivalIndex)};
            local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs);
            if EntityID ~= Logic.GetMarketplace(PlayerID) then
                return;
            end
            if CanBuyBoolean == true then
                Sound.FXPlay2DSound("ui\\menu_click");
                GUI.StartFestival(PlayerID, _FestivalIndex);
                StartEventMusic(MusicSystem.EventFestivalMusic, PlayerID);
                StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightSong);
                GUI.AddBuff(Buffs.Buff_Festival);
                SendReportToGlobal(Report.FestivalClicked, PlayerID, 0);
            else
                Message(CanNotBuyString);
            end
            return;
        end
        Button.Action(WidgetID, EntityID);
    end

    self.Orig_StartFestivalMouseOver = GUI_BuildingButtons.StartFestivalMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartFestivalMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            return Lib.UIBuilding.Local.Orig_StartFestivalMouseOver();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    self.Orig_StartFestivalUpdate = GUI_BuildingButtons.StartFestivalUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartFestivalUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        XGUIEng.SetMaterialColor(WidgetID, 7, 255, 255, 255, 255);
        if not Button then
            SetIcon(WidgetID, {4, 15});
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return Lib.UIBuilding.Local.Orig_StartFestivalUpdate();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function Lib.UIBuilding.Local:OverrideStartTheatrePlay()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartTheatrePlayClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            local PlayerID = GUI.GetPlayerID();
            local GoodType = Logic.GetGoodTypeOnOutStockByIndex(EntityID, 0);
            local Amount = Logic.GetMaxAmountOnStock(EntityID);
            local Costs = {GoodType, Amount};
            local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs);
            if Logic.CanStartTheatrePlay(EntityID) == true then
                Sound.FXPlay2DSound("ui\\menu_click");
                GUI.StartTheatrePlay(EntityID);
                SendReportToGlobal(Report.TheatrePlayClicked, PlayerID);
            elseif CanBuyBoolean == false then
                Message(CanNotBuyString);
            end
            return;
        end
        Button.Action(WidgetID, EntityID);
    end

    self.Orig_StartTheatrePlayMouseOver = GUI_BuildingButtons.StartTheatrePlayMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartTheatrePlayMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            return Lib.UIBuilding.Local.Orig_StartTheatrePlayMouseOver();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    self.Orig_StartTheatrePlayUpdate = GUI_BuildingButtons.StartTheatrePlayUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartTheatrePlayUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        XGUIEng.SetMaterialColor(WidgetID, 7, 255, 255, 255, 255);
        if not Button then
            SetIcon(WidgetID, {16, 2});
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return Lib.UIBuilding.Local.Orig_StartTheatrePlayUpdate();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function Lib.UIBuilding.Local:OverrideUpgradeTurret()
    self.Orig_UpgradeTurretClicked = GUI_BuildingButtons.UpgradeTurretClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.UpgradeTurretClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            return Lib.UIBuilding.Local.Orig_UpgradeTurretClicked();
        end
        Button.Action(WidgetID, EntityID);
    end

    self.Orig_UpgradeTurretMouseOver = GUI_BuildingButtons.UpgradeTurretMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.UpgradeTurretMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        if not Button then
            return Lib.UIBuilding.Local.Orig_UpgradeTurretMouseOver();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    self.Orig_UpgradeTurretUpdate = GUI_BuildingButtons.UpgradeTurretUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.UpgradeTurretUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        XGUIEng.SetMaterialColor(WidgetID, 7, 255, 255, 255, 255);
        if not Button then
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return Lib.UIBuilding.Local.Orig_UpgradeTurretUpdate();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function Lib.UIBuilding.Local:OverrideBuySiegeEngineCart()
    self.Orig_BuySiegeEngineCartClicked = GUI_BuildingButtons.BuySiegeEngineCartClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.BuySiegeEngineCartClicked = function(_EntityType)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if WidgetName == "BuyCatapultCart"
        or WidgetName == "BuySiegeTowerCart"
        or WidgetName == "BuyBatteringRamCart" then
            Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        end
        if not Button then
            return Lib.UIBuilding.Local.Orig_BuySiegeEngineCartClicked(_EntityType);
        end
        Button.Action(WidgetID, EntityID);
    end

    self.Orig_BuySiegeEngineCartMouseOver = GUI_BuildingButtons.BuySiegeEngineCartMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.BuySiegeEngineCartMouseOver = function(_EntityType, _Right)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if WidgetName == "BuyCatapultCart"
        or WidgetName == "BuySiegeTowerCart"
        or WidgetName == "BuyBatteringRamCart" then
            Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        end
        if not Button then
            return Lib.UIBuilding.Local.Orig_BuySiegeEngineCartMouseOver(_EntityType, _Right);
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    self.Orig_BuySiegeEngineCartUpdate = GUI_BuildingButtons.BuySiegeEngineCartUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.BuySiegeEngineCartUpdate = function(_EntityType)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if WidgetName == "BuyCatapultCart"
        or WidgetName == "BuySiegeTowerCart"
        or WidgetName == "BuyBatteringRamCart" then
            Button = Lib.UIBuilding.Config.Buttons[WidgetName].Bind;
        end
        XGUIEng.SetMaterialColor(WidgetID, 7, 255, 255, 255, 255);
        if not Button then
            if WidgetName == "BuyBatteringRamCart" then
                SetIcon(WidgetID, {9, 2});
            elseif WidgetName == "BuySiegeTowerCart" then
                SetIcon(WidgetID, {9, 3});
            elseif WidgetName == "BuyCatapultCart" then
                SetIcon(WidgetID, {9, 1});
            end
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return Lib.UIBuilding.Local.Orig_BuySiegeEngineCartUpdate(_EntityType);
        end
        Button.Update(WidgetID, EntityID);
    end
end

function Lib.UIBuilding.Local:OverrideUpgradeBuilding()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.UpgradeClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local EntityID = GUI.GetSelectedEntity();
        if Logic.CanCancelUpgradeBuilding(EntityID) then
            Sound.FXPlay2DSound("ui\\menu_click");
            GUI.CancelBuildingUpgrade(EntityID);
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons", 1);
            SendReportToGlobal(Report.CancelUpgradeClicked, EntityID, GUI.GetPlayerID());
            return;
        end
        local Costs = GUI_BuildingButtons.GetUpgradeCosts();
        local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs);
        if CanBuyBoolean == true then
            Sound.FXPlay2DSound("ui\\menu_click");
            GUI.UpgradeBuilding(EntityID, nil);
            StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightWisdom);
            if WidgetID ~= 0 then
                SaveButtonPressed(WidgetID);
            end
            SendReportToGlobal(Report.StartUpgradeClicked, EntityID, GUI.GetPlayerID());
        else
            Message(CanNotBuyString);
        end
    end
end

function Lib.UIBuilding.Local:OverrideStartSermon()
    --- @diagnostic disable-next-line: duplicate-set-field
    function GUI_BuildingButtons.StartSermonClicked()
        local PlayerID = GUI.GetPlayerID();
        if Logic.CanSermonBeActivated(PlayerID) then
            GUI.ActivateSermon(PlayerID);
            StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightHealing);
            GUI.AddBuff(Buffs.Buff_Sermon);
            local CathedralID = Logic.GetCathedral(PlayerID);
            local x, y = Logic.GetEntityPosition(CathedralID);
            local z = 0;
            Sound.FXPlay3DSound("buildings\\building_start_sermon", x, y, z);
            SendReportToGlobal(Report.SermonClicked, GUI.GetPlayerID());
        end
    end
end

-- -------------------------------------------------------------------------- --

function Lib.UIBuilding.Local:InitBackupPositions()
    for k, v in pairs(Lib.UIBuilding.Config.Buttons) do
        local x, y = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/" ..k);
        Lib.UIBuilding.Config.Buttons[k].OriginalPosition = {x, y};
    end
end

function Lib.UIBuilding.Local:GetButtonsForOverwrite(_ID, _Amount)
    local Buttons = {};
    local Type = Logic.GetEntityType(_ID);
    local TypeName = Logic.GetEntityTypeName(Type);
    for k, v in pairs(Lib.UIBuilding.Config.Buttons) do
        if #Buttons == _Amount then
            break;
        end
        if not TypeName:find(v.TypeExclusion) then
            table.insert(Buttons, k);
        end
    end
    assert(#Buttons == _Amount);
    table.sort(Buttons);
    return Buttons;
end

function Lib.UIBuilding.Local:AddButtonBinding(_Type, _X, _Y, _ActionFunction, _TooltipController, _UpdateController)
    if not self.BuildingButtons.Bindings[_Type] then
        self.BuildingButtons.Bindings[_Type] = {};
    end
    if #self.BuildingButtons.Bindings[_Type] < 6 then
        self.BuildingButtons.BindingCounter = self.BuildingButtons.BindingCounter +1;
        table.insert(self.BuildingButtons.Bindings[_Type], {
            ID       = self.BuildingButtons.BindingCounter,
            Position = {_X, _Y},
            Action   = _ActionFunction,
            Tooltip  = _TooltipController,
            Update   = _UpdateController,
        });
        return self.BuildingButtons.BindingCounter;
    end
    return 0;
end

function Lib.UIBuilding.Local:RemoveButtonBinding(_Type, _ID)
    if not self.BuildingButtons.Bindings[_Type] then
        self.BuildingButtons.Bindings[_Type] = {};
    end
    for i= #self.BuildingButtons.Bindings[_Type], 1, -1 do
        if self.BuildingButtons.Bindings[_Type][i].ID == _ID then
            table.remove(self.BuildingButtons.Bindings[_Type], i);
        end
    end
end

function Lib.UIBuilding.Local:BindButtons(_ID)
    if _ID == nil or _ID == 0 or (Logic.IsBuilding(_ID) == 0 and not Logic.IsWall(_ID)) then
        return self:UnbindButtons();
    end
    local Name = Logic.GetEntityName(_ID);
    local Type = Logic.GetEntityType(_ID);

    local WidgetsForOverride = self:GetButtonsForOverwrite(_ID, 6);
    local ButtonOverride = {};
    -- Add buttons for named entity
    if self.BuildingButtons.Bindings[Name] and #self.BuildingButtons.Bindings[Name] > 0 then
        for i= 1, #self.BuildingButtons.Bindings[Name] do
            table.insert(ButtonOverride, self.BuildingButtons.Bindings[Name][i]);
        end
    end
    -- Add buttons for type
    if self.BuildingButtons.Bindings[Type] and #self.BuildingButtons.Bindings[Type] > 0 then
        for i= 1, #self.BuildingButtons.Bindings[Type] do
            table.insert(ButtonOverride, self.BuildingButtons.Bindings[Type][i]);
        end
    end
    -- Add buttons for all
    if self.BuildingButtons.Bindings[0] and #self.BuildingButtons.Bindings[0] > 0 then
        for i= 1, #self.BuildingButtons.Bindings[0] do
            table.insert(ButtonOverride, self.BuildingButtons.Bindings[0][i]);
        end
    end

    -- Place first six buttons (if present)
    for i= 1, #ButtonOverride do
        if i > 6 then
            break;
        end
        local ButtonName = WidgetsForOverride[i];
        Lib.UIBuilding.Config.Buttons[ButtonName].Bind = ButtonOverride[i];
        XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons/" ..ButtonName, 1);
        XGUIEng.DisableButton("/InGame/Root/Normal/BuildingButtons/" ..ButtonName, 0);
        local X = ButtonOverride[i].Position[1];
        local Y = ButtonOverride[i].Position[2];
        if not X or not Y then
            local AnchorPosition = {15, 296};
            X = AnchorPosition[1] + (64 * (i-1));
            Y = AnchorPosition[2];
        end
        XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/" ..ButtonName, X, Y);
    end
end

function Lib.UIBuilding.Local:UnbindButtons()
    for k, v in pairs(Lib.UIBuilding.Config.Buttons) do
        local Position = Lib.UIBuilding.Config.Buttons[k].OriginalPosition;
        if Position then
            XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/" ..k, Position[1], Position[2]);
        end
        Lib.UIBuilding.Config.Buttons[k].Bind = nil;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.UIBuilding.Name);

