Lib.Require("comfort/IsLocalScript");
Lib.Register("module/ui/UIBuilding_Buttons");

-- Global ------------------------------------------------------------------- --

Lib.UIBuilding.Global.ExtraButton = {};

-- -------------------------------------------------------------------------- --

Lib.UIBuilding.Global.ExtraButton.Downgrade = {};

function Lib.UIBuilding.Global.ExtraButton.Downgrade:InitEvents()
    Report.DowngradeBuilding = CreateReport("Event_DowngradeBuilding");
end

function Lib.UIBuilding.Global.ExtraButton.Downgrade:ExtraButtonOnReportReceived(_ID, ...)
    if _ID == Report.DowngradeBuilding then
        self:OnBuildingDowngrade(arg[1]);
    end
end

function Lib.UIBuilding.Global.ExtraButton.Downgrade:OnBuildingDowngrade(_BuildingID)
    local Health = Logic.GetEntityHealth(_BuildingID);
    local MaxHealth = Logic.GetEntityMaxHealth(_BuildingID);
    Logic.HurtEntity(_BuildingID, (Health - (MaxHealth/2)));
    SendReportToLocal(Report.DowngradeBuilding, _BuildingID);
end

-- -------------------------------------------------------------------------- --

Lib.UIBuilding.Global.ExtraButton.SingleReserve = {};

function Lib.UIBuilding.Global.ExtraButton.SingleReserve:InitEvents()
    Report.LockGoodType = CreateReport("Event_LockGoodType");
    Report.UnlockGoodType = CreateReport("Event_UnlockGoodType");
end

function Lib.UIBuilding.Global.ExtraButton.SingleReserve:ExtraButtonOnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

Lib.UIBuilding.Global.ExtraButton.SingleStop = {};

function Lib.UIBuilding.Global.ExtraButton.SingleStop:InitEvents()
    Report.ResumeBuilding = CreateReport("Event_ResumeBuilding");
    Report.YieldBuilding = CreateReport("Event_YieldBuilding");
end

function Lib.UIBuilding.Global.ExtraButton.SingleStop:ExtraButtonOnReportReceived(_ID, ...)
end

-- Local -------------------------------------------------------------------- --

Lib.UIBuilding.Local.ExtraButton = {};

-- -------------------------------------------------------------------------- --

Lib.UIBuilding.Local.ExtraButton.Downgrade = {};
Lib.UIBuilding.Local.ExtraButton.Downgrade.Cost = 0;
Lib.UIBuilding.Local.ExtraButton.Downgrade.Bindings = {};
Lib.UIBuilding.Local.ExtraButton.Downgrade.Types = {
    ["B_Bakery"] = true,
    ["B_BannerMaker"] = true,
    ["B_Barracks"] = true,
    ["B_BarracksArchers"] = true,
    ["B_Baths"] = true,
    ["B_Beekeeper"] = true,
    ["B_Blacksmith"] = true,
    ["B_BowMaker"] = true,
    ["B_BroomMaker"] = true,
    ["B_Butcher"] = true,
    ["B_CandleMaker"] = true,
    ["B_Carpenter"] = true,
    ["B_CattleFarm"] = true,
    ["B_Dairy"] = true,
    ["B_FishingHut"] = true,
    ["B_GrainFarm"] = true,
    ["B_HerbGatherer"] = true,
    ["B_HuntersHut"] = true,
    ["B_IronMine"] = true,
    ["B_Pharmacy"] = true,
    ["B_SheepFarm"] = true,
    ["B_SiegeEngineWorkshop"] = true,
    ["B_SmokeHouse"] = true,
    ["B_Soapmaker"] = true,
    ["B_StoneQuarry"] = true,
    ["B_SwordSmith"] = true,
    ["B_Tanner"] = true,
    ["B_Tavern"] = true,
    ["B_Theatre"] = true,
    ["B_Weaver"] = true,
    ["B_Woodcutter"] = true,
};

function Lib.UIBuilding.Local.ExtraButton.Downgrade:InitEvents()
    Report.DowngradeBuilding = CreateReport("Event_DowngradeBuilding");
end

function Lib.UIBuilding.Local.ExtraButton.Downgrade:ExtraButtonOnReportReceived(_ID, ...)
end

function Lib.UIBuilding.Local.ExtraButton.Downgrade:SetCost(_MoneyCost)
    self.Cost = _MoneyCost;
end

function Lib.UIBuilding.Local.ExtraButton.Downgrade:Activate()
    for TypeName, _ in pairs(self.Types) do
        local ID = AddBuildingButtonByTypeAtPosition(
            Entities[TypeName],
            220,
            62,
            self.ButtonAction,
            self.ButtonTooltip,
            self.ButtonUpdate
        );
        self.Bindings[TypeName] = ID;
    end
end

function Lib.UIBuilding.Local.ExtraButton.Downgrade:Deactivate()
    for TypeName, _ in pairs(self.Types) do
        local ID = self.Bindings[TypeName];
        DropBuildingButtonFromType(Entities[TypeName], ID);
    end
end

function Lib.UIBuilding.Local.ExtraButton.Downgrade.ButtonAction(_WidgetID, _BuildingID)
    local CastleID = Logic.GetHeadquarters(GUI.GetPlayerID());
    local Cost = Lib.UIBuilding.Local.ExtraButton.Downgrade.Cost;
    if Cost > 0 and Logic.GetAmountOnOutStockByGoodType(CastleID, Goods.G_Gold) < Cost then
        AddMessage("Feedback_TextLines/TextLine_NotEnough_G_Gold");
        return;
    end
    Sound.FXPlay2DSound("ui\\menu_click");
    if Cost > 0 then
        GUI.RemoveGoodFromStock(CastleID, Goods.G_Gold, Cost);
    end
    GUI.DeselectEntity(_BuildingID);
    SendReportToGlobal(Report.DowngradeBuilding, _BuildingID);
end

function Lib.UIBuilding.Local.ExtraButton.Downgrade.ButtonTooltip(_WidgetID, _BuildingID)
    local Title, Text, Error;
    Title = Lib.UIBuilding.Text.ExtraButton.Downgrade.Normal.Title;
    Text = Lib.UIBuilding.Text.ExtraButton.Downgrade.Normal.Text;
    if XGUIEng.IsButtonDisabled(_WidgetID) == 1 then
        Error = Lib.UIBuilding.Text.ExtraButton.Downgrade.Normal.Error;
        Error = XGUIEng.GetStringTableText(Error);
    end
    local Cost = Lib.UIBuilding.Local.ExtraButton.Downgrade.Cost;
    API.SetTooltipCosts(
        ConvertPlaceholders(Localize(Title)),
        ConvertPlaceholders(Localize(Text)),
        Error,
        (Cost > 0 and {Goods.G_Gold, Cost}) or nil
    );
end

function Lib.UIBuilding.Local.ExtraButton.Downgrade.ButtonUpdate(_WidgetID, _BuildingID)
    if Logic.IsConstructionComplete(_BuildingID) == 0 then
        XGUIEng.ShowWidget(_WidgetID, 0);
        return;
    end
    if Logic.IsBuildingBeingUpgraded(_BuildingID)
    or Logic.GetUpgradeLevel(_BuildingID) < 1
    or Logic.IsBuildingBeingKnockedDown(_BuildingID)
    or Logic.IsBurning(_BuildingID)
    or Logic.GetEntityMaxHealth(_BuildingID) > Logic.GetEntityHealth(_BuildingID)
    or Logic.BuildingDoWorkersStrike(_BuildingID) == true
    or Logic.CanCancelUpgradeBuilding(_BuildingID)
    or Logic.CanCancelKnockDownBuilding(_BuildingID) then
        XGUIEng.DisableButton(_WidgetID, 1);
    else
        XGUIEng.DisableButton(_WidgetID, 0);
    end
    SetIcon(_WidgetID, {3, 15});
end

-- -------------------------------------------------------------------------- --

Lib.UIBuilding.Local.ExtraButton.SingleReserve = {};
Lib.UIBuilding.Local.ExtraButton.SingleReserve.Bindings = {};
Lib.UIBuilding.Local.ExtraButton.SingleReserve.Types = {
    ["B_Bakery"] = true,
    ["B_BannerMaker"] = true,
    ["B_Barracks"] = true,
    ["B_BarracksArchers"] = true,
    ["B_Baths"] = true,
    ["B_Blacksmith"] = true,
    ["B_BowMaker"] = true,
    ["B_BroomMaker"] = true,
    ["B_Butcher"] = true,
    ["B_CandleMaker"] = true,
    ["B_Carpenter"] = true,
    ["B_Dairy"] = true,
    ["B_Pharmacy"] = true,
    ["B_SiegeEngineWorkshop"] = true,
    ["B_SmokeHouse"] = true,
    ["B_Soapmaker"] = true,
    ["B_SwordSmith"] = true,
    ["B_Tanner"] = true,
    ["B_Tavern"] = true,
    ["B_Theatre"] = true,
    ["B_Weaver"] = true,
};

function Lib.UIBuilding.Local.ExtraButton.SingleReserve:InitEvents()
    Report.LockGoodType = CreateReport("Event_LockGoodType");
    Report.UnlockGoodType = CreateReport("Event_UnlockGoodType");
end

function Lib.UIBuilding.Local.ExtraButton.SingleReserve:ExtraButtonOnReportReceived(_ID, ...)
end

function Lib.UIBuilding.Local.ExtraButton.SingleReserve:Activate()
    for TypeName, _ in pairs(self.Types) do
        local ID = AddBuildingButtonByType(
            Entities[TypeName],
            self.ButtonAction,
            self.ButtonTooltip,
            self.ButtonUpdate
        );
        self.Bindings[TypeName] = ID;
    end
end

function Lib.UIBuilding.Local.ExtraButton.SingleReserve:Deactivate()
    for TypeName, _ in pairs(self.Types) do
        local ID = self.Bindings[TypeName];
        DropBuildingButtonFromType(Entities[TypeName], ID);
    end
end

function Lib.UIBuilding.Local.ExtraButton.SingleReserve.ButtonAction(_WidgetID, _BuildingID)
    local PlayerID = Logic.EntityGetPlayer(_BuildingID);
    local EntityType = Logic.GetEntityType(_BuildingID);
    local GoodType = Logic.GetProductOfBuildingType(EntityType);
    if Logic.IsGoodLocked(PlayerID, GoodType) then
        GUI.SetGoodLockState(GoodType, false);
        SendReportToGlobal(Report.LockGoodType, PlayerID, EntityType);
        SendReport(Report.LockGoodType, PlayerID, EntityType);
    else
        GUI.SetGoodLockState(GoodType, true);
        SendReportToGlobal(Report.UnlockGoodType, PlayerID, EntityType);
        SendReport(Report.UnlockGoodType, PlayerID, EntityType);
    end
end

function Lib.UIBuilding.Local.ExtraButton.SingleReserve.ButtonTooltip(_WidgetID, _BuildingID)
    local PlayerID = Logic.EntityGetPlayer(_BuildingID);
    local EntityType = Logic.GetEntityType(_BuildingID);
    local GoodType = Logic.GetProductOfBuildingType(EntityType);

    local Title, Text, Error;
    if Logic.IsGoodLocked(PlayerID, GoodType) then
        Title = Lib.UIBuilding.Text.ExtraButton.SingleReserve.Stopped.Title;
        Title = XGUIEng.GetStringTableText(Title);
        Text = Lib.UIBuilding.Text.ExtraButton.SingleReserve.Stopped.Text;
        Text = XGUIEng.GetStringTableText(Text);
        if XGUIEng.IsButtonDisabled(_WidgetID) == 1 then
            Error = Lib.UIBuilding.Text.ExtraButton.SingleReserve.Stopped.Error;
            Error = XGUIEng.GetStringTableText(Error);
        end
    else
        Title = Lib.UIBuilding.Text.ExtraButton.SingleReserve.Normal.Title;
        Title = XGUIEng.GetStringTableText(Title);
        Text = Lib.UIBuilding.Text.ExtraButton.SingleReserve.Normal.Text;
        Text = XGUIEng.GetStringTableText(Text);
        if XGUIEng.IsButtonDisabled(_WidgetID) == 1 then
            Error = Lib.UIBuilding.Text.ExtraButton.SingleReserve.Normal.Error;
            Error = XGUIEng.GetStringTableText(Error);
        end
    end
    API.SetTooltipCosts(Title, Text, Error);
end

function Lib.UIBuilding.Local.ExtraButton.SingleReserve.ButtonUpdate(_WidgetID, _BuildingID)
    local PlayerID = Logic.EntityGetPlayer(_BuildingID);
    local EntityType = Logic.GetEntityType(_BuildingID);
    local GoodType = Logic.GetProductOfBuildingType(EntityType);

    if Logic.IsConstructionComplete(_BuildingID) == 0 then
        XGUIEng.ShowWidget(_WidgetID, 0);
        return;
    end
    if Logic.IsBuildingBeingUpgraded(_BuildingID)
    or Logic.IsBuildingBeingKnockedDown(_BuildingID)
    or Logic.BuildingDoWorkersStrike(_BuildingID) == true
    or Logic.IsBurning(_BuildingID) then
        XGUIEng.DisableButton(_WidgetID, 1);
    else
        XGUIEng.DisableButton(_WidgetID, 0);
    end
    SetIcon(_WidgetID, {15, 6});
    if Logic.IsGoodLocked(PlayerID, GoodType) then
        SetIcon(_WidgetID, {10, 9});
    end
end

-- -------------------------------------------------------------------------- --

Lib.UIBuilding.Local.ExtraButton.SingleStop = {};
Lib.UIBuilding.Local.ExtraButton.SingleStop.Bindings = {};
Lib.UIBuilding.Local.ExtraButton.SingleStop.Types = {
    ["B_Bakery"] = true,
    ["B_BannerMaker"] = true,
    ["B_Barracks"] = true,
    ["B_BarracksArchers"] = true,
    ["B_Baths"] = true,
    ["B_Beekeeper"] = true,
    ["B_Blacksmith"] = true,
    ["B_BowMaker"] = true,
    ["B_BroomMaker"] = true,
    ["B_Butcher"] = true,
    ["B_CandleMaker"] = true,
    ["B_Carpenter"] = true,
    ["B_CattleFarm"] = true,
    ["B_Dairy"] = true,
    ["B_FishingHut"] = true,
    ["B_GrainFarm"] = true,
    ["B_HerbGatherer"] = true,
    ["B_HuntersHut"] = true,
    ["B_IronMine"] = true,
    ["B_Pharmacy"] = true,
    ["B_SheepFarm"] = true,
    ["B_SiegeEngineWorkshop"] = true,
    ["B_SmokeHouse"] = true,
    ["B_Soapmaker"] = true,
    ["B_StoneQuarry"] = true,
    ["B_SwordSmith"] = true,
    ["B_Tanner"] = true,
    ["B_Tavern"] = true,
    ["B_Theatre"] = true,
    ["B_Weaver"] = true,
    ["B_Woodcutter"] = true,
};

function Lib.UIBuilding.Local.ExtraButton.SingleStop:InitEvents()
    Report.ResumeBuilding = CreateReport("Event_ResumeBuilding");
    Report.YieldBuilding = CreateReport("Event_YieldBuilding");
end

function Lib.UIBuilding.Local.ExtraButton.SingleStop:ExtraButtonOnReportReceived(_ID, ...)
end

function Lib.UIBuilding.Local.ExtraButton.SingleStop:Activate()
    for TypeName, _ in pairs(self.Types) do
        local ID = AddBuildingButtonByType(
            Entities[TypeName],
            self.ButtonAction,
            self.ButtonTooltip,
            self.ButtonUpdate
        );
        self.Bindings[TypeName] = ID;
    end
end

function Lib.UIBuilding.Local.ExtraButton.SingleStop:Deactivate()
    for TypeName, _ in pairs(self.Types) do
        local ID = self.Bindings[TypeName];
        DropBuildingButtonFromType(Entities[TypeName], ID);
    end
end

function Lib.UIBuilding.Local.ExtraButton.SingleStop.ButtonAction(_WidgetID, _BuildingID)
    if Logic.IsBuildingStopped(_BuildingID) then
        GUI.SetStoppedState(_BuildingID, false);
        SendReportToGlobal(Report.ResumeBuilding, _BuildingID);
        SendReport(Report.ResumeBuilding, _BuildingID);
    else
        GUI.SetStoppedState(_BuildingID, true);
        SendReportToGlobal(Report.YieldBuilding, _BuildingID);
        SendReport(Report.YieldBuilding, _BuildingID);
    end
end

function Lib.UIBuilding.Local.ExtraButton.SingleStop.ButtonTooltip(_WidgetID, _BuildingID)
    local Title, Text, Error;
    if Logic.IsBuildingStopped(_BuildingID) then
        Title = Lib.UIBuilding.Text.ExtraButton.SingleStop.Stopped.Title;
        Title = XGUIEng.GetStringTableText(Title);
        Text = Lib.UIBuilding.Text.ExtraButton.SingleStop.Stopped.Text;
        if XGUIEng.IsButtonDisabled(_WidgetID) == 1 then
            Error = Lib.UIBuilding.Text.ExtraButton.SingleStop.Stopped.Error;
            Error = XGUIEng.GetStringTableText(Error);
        end
    else
        Title = Lib.UIBuilding.Text.ExtraButton.SingleStop.Normal.Title;
        Title = XGUIEng.GetStringTableText(Title);
        Text = Lib.UIBuilding.Text.ExtraButton.SingleStop.Normal.Text;
        if XGUIEng.IsButtonDisabled(_WidgetID) == 1 then
            Error = Lib.UIBuilding.Text.ExtraButton.SingleStop.Normal.Error;
            Error = XGUIEng.GetStringTableText(Error);
        end
    end
    API.SetTooltipCosts(
        Title,
        ConvertPlaceholders(Localize(Text)),
        Error
    );
end

function Lib.UIBuilding.Local.ExtraButton.SingleStop.ButtonUpdate(_WidgetID, _BuildingID)
    if Logic.IsConstructionComplete(_BuildingID) == 0 then
        XGUIEng.ShowWidget(_WidgetID, 0);
        return;
    end
    if Logic.IsBuildingBeingUpgraded(_BuildingID)
    or Logic.IsBuildingBeingKnockedDown(_BuildingID)
    or Logic.BuildingDoWorkersStrike(_BuildingID) == true
    or Logic.IsBurning(_BuildingID) then
        XGUIEng.DisableButton(_WidgetID, 1);
    else
        XGUIEng.DisableButton(_WidgetID, 0);
    end
    SetIcon(_WidgetID, {4, 13});
    if Logic.IsBuildingStopped(_BuildingID) then
        SetIcon(_WidgetID, {4, 12});
    end
end

