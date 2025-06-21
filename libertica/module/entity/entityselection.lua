Lib.EntitySelection = Lib.EntitySelection or {};
Lib.EntitySelection.Name = "EntitySelection";
Lib.EntitySelection.Global = {
    TrebuchetIDToCart = {},
};
Lib.EntitySelection.Local  = {
    TrebuchetDisassemble = false,
    TrebuchetErect = false,
    ThiefRelease = false,
    SiegeEngineRelease = true,
    MilitaryRelease = true,
};

Lib.Require("comfort/GetPosition");
Lib.Require("comfort/IsUnofficialPatch");
Lib.Require("core/Core");
Lib.Require("module/ui/UITools");
Lib.Require("module/entity/EntitySelection_API");
Lib.Require("module/entity/EntitySelection_Text");
Lib.Register("module/entity/EntitySelection");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.EntitySelection.Global:Initialize()
    if not self.IsInstalled then
        Report.ExpelSettler = CreateReport("Event_ExpelSettler");
        Report.ForceTrebuchetTasklist = CreateReport("Event_ForceTrebuchetTasklist");
        Report.ErectTrebuchet = CreateReport("Event_ErectTrebuchet");
        Report.DisambleTrebuchet = CreateReport("Event_DisambleTrebuchet");

        -- Garbage collection
        Lib.EntitySelection.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.EntitySelection.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.EntitySelection.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.ForceTrebuchetTasklist then
        Logic.SetTaskList(arg[1], arg[2]);
    elseif _ID == Report.ErectTrebuchet then
        Lib.EntitySelection.Global:MilitaryErectTrebuchet(arg[1]);
    elseif _ID == Report.DisambleTrebuchet then
        Lib.EntitySelection.Global:MilitaryDisambleTrebuchet(arg[1]);
    elseif _ID == Report.ExpelSettler then
        DestroyEntity(arg[1]);
    end
end

function Lib.EntitySelection.Global:MilitaryDisambleTrebuchet(_EntityID)
    local x,y,z = Logic.EntityGetPos(_EntityID);
    local PlayerID = Logic.EntityGetPlayer(_EntityID);

    -- Extern callback for the mapscript
    if GameCallback_Lib_OnDisambleTrebuchet then
        GameCallback_Lib_OnDisambleTrebuchet(_EntityID, PlayerID, x, y, z);
        return;
    end

    Logic.CreateEffect(EGL_Effects.E_Shockwave01, x, y, 0);
    Logic.SetEntityInvulnerabilityFlag(_EntityID, 1);
    Logic.SetEntitySelectableFlag(_EntityID, 0);
    Logic.SetVisible(_EntityID, false);

    local TrebuchetCart = self.TrebuchetIDToCart[_EntityID];
    if TrebuchetCart ~= nil then
        Logic.SetEntityInvulnerabilityFlag(TrebuchetCart, 0);
        Logic.SetEntitySelectableFlag(TrebuchetCart, 1);
        Logic.SetVisible(TrebuchetCart, true);
    else
        TrebuchetCart = Logic.CreateEntity(Entities.U_SiegeEngineCart, x, y, 0, PlayerID);
        self.TrebuchetIDToCart[_EntityID] = TrebuchetCart;
    end

    Logic.DEBUG_SetSettlerPosition(TrebuchetCart, x, y);
    Logic.SetTaskList(TrebuchetCart, TaskLists.TL_NPC_IDLE);
    ExecuteLocal([[GUI.SelectEntity(%d)]], TrebuchetCart);
end

function Lib.EntitySelection.Global:MilitaryErectTrebuchet(_EntityID)
    local x,y,z = Logic.EntityGetPos(_EntityID);
    local PlayerID = Logic.EntityGetPlayer(_EntityID);

    -- Extern callback for the mapscript
    if GameCallback_Lib_OnErectTrebuchet then
        GameCallback_Lib_OnErectTrebuchet(_EntityID, PlayerID, x, y, z);
        return;
    end

    Logic.CreateEffect(EGL_Effects.E_Shockwave01, x, y, 0);
    Logic.SetEntityInvulnerabilityFlag(_EntityID, 1);
    Logic.SetEntitySelectableFlag(_EntityID, 0);
    Logic.SetVisible(_EntityID, false);

    local Trebuchet;
    for k, v in pairs(self.TrebuchetIDToCart) do
        if v == _EntityID then
            Trebuchet = tonumber(k);
        end
    end
    if Trebuchet == nil then
        Trebuchet = Logic.CreateEntity(Entities.U_Trebuchet, x, y, 0, PlayerID);
        self.TrebuchetIDToCart[Trebuchet] = _EntityID;
    end

    Logic.SetEntityInvulnerabilityFlag(Trebuchet, 0);
    Logic.SetEntitySelectableFlag(Trebuchet, 1);
    Logic.SetVisible(Trebuchet, true);
    Logic.DEBUG_SetSettlerPosition(Trebuchet, x, y);
    ExecuteLocal([[GUI.SelectEntity(%d)]], Trebuchet);
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.EntitySelection.Local:Initialize()
    if not self.IsInstalled then
        Report.ExpelSettler = CreateReport("Event_ExpelSettler");
        Report.ForceTrebuchetTasklist = CreateReport("Event_ForceTrebuchetTasklist");
        Report.ErectTrebuchet = CreateReport("Event_ErectTrebuchet");
        Report.DisambleTrebuchet = CreateReport("Event_DisambleTrebuchet");

        self:OverwriteMilitaryCommands();
        self:OverwriteMilitaryErect();
        self:OverwriteMilitaryDisamble();
        self:OverwriteMultiselectIcon();
        self:OverwriteSelectKnight();
        self:OverwriteSelectAllUnits();
        self:OverwriteNamesAndDescription();
        if not IsUnofficialPatch() then
            self:OverwriteMilitaryDismount();
            self:OverwriteThiefDeliver();
        end

        -- Garbage collection
        Lib.EntitySelection.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.EntitySelection.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.EntitySelection.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.EntitySelection.Local:OverwriteMilitaryCommands()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.StandGroundClicked = function()
        Sound.FXPlay2DSound( "ui\\menu_click");
        local SelectedEntities = {GUI.GetSelectedEntities()};
        for i=1,#SelectedEntities do
            local LeaderID = SelectedEntities[i];
            local eType = Logic.GetEntityType(LeaderID);
            GUI.SendCommandStationaryDefend(LeaderID);
            if eType == Entities.U_Trebuchet then
                SendReportToGlobal(Report.ForceTrebuchetTasklist, LeaderID, TaskLists.TL_NPC_IDLE);
                SendReport(Report.ForceTrebuchetTasklist, LeaderID, TaskLists.TL_NPC_IDLE);
            end
        end
    end

    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.StandGroundUpdate = function()
        local WidgetAttack = "/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military/Attack";
        local SelectedEntities = {GUI.GetSelectedEntities()};
        SetIcon(WidgetAttack, {12, 4});
        if #SelectedEntities == 1 then
            local eID = SelectedEntities[1];
            local eType = Logic.GetEntityType(eID);
            if eType == Entities.U_Trebuchet then
                if Logic.GetAmmunitionAmount(eID) > 0 then
                    XGUIEng.ShowWidget(WidgetAttack, 0);
                else
                    XGUIEng.ShowWidget(WidgetAttack, 1);
                end
                SetIcon(WidgetAttack, {1, 10});
            else
                XGUIEng.ShowWidget(WidgetAttack, 1);
            end
        end
    end
end

function Lib.EntitySelection.Local:OverwriteMilitaryErect()
    GUI_Military.ErectClicked_Orig_Selection = GUI_Military.ErectClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.ErectClicked = function()
        GUI_Military.ErectClicked_Orig_Selection();
        local SelectedEntities = {GUI.GetSelectedEntities()};
        for i=1, #SelectedEntities, 1 do
            local EntityType = Logic.GetEntityType(SelectedEntities[i]);
            if EntityType == Entities.U_SiegeEngineCart then
                SendReportToGlobal(Report.ErectTrebuchet, SelectedEntities[i]);
                SendReport(Report.ErectTrebuchet, SelectedEntities[i]);
            end
        end
    end

    GUI_Military.ErectUpdate_Orig_Selection = GUI_Military.ErectUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.ErectUpdate = function()
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local SiegeCartID = GUI.GetSelectedEntity();
        local EntityType = Logic.GetEntityType(SiegeCartID);
        if EntityType == Entities.U_SiegeEngineCart then
            local Disabled = (Lib.EntitySelection.Local.TrebuchetErect and 0) or 1;
            XGUIEng.DisableButton(CurrentWidgetID, Disabled);
            SetIcon(CurrentWidgetID, {12, 6});
        else
            GUI_Military.ErectUpdate_Orig_Selection();
        end
    end

    GUI_Military.ErectMouseOver_Orig_Selection = GUI_Military.ErectMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.ErectMouseOver = function()
        local SiegeCartID = GUI.GetSelectedEntity();
        local TooltipTextKey;
        if Logic.GetEntityType(SiegeCartID) == Entities.U_SiegeEngineCart then
            TooltipTextKey = "ErectCatapult";
        else
            GUI_Military.ErectMouseOver_Orig_Selection();
            return;
        end
        GUI_Tooltip.TooltipNormal(TooltipTextKey, "Erect");
    end
end

function Lib.EntitySelection.Local:OverwriteMilitaryDisamble()
    GUI_Military.DisassembleClicked_Orig_Selection = GUI_Military.DisassembleClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.DisassembleClicked = function()
        GUI_Military.DisassembleClicked_Orig_Selection();
        local SelectedEntities = {GUI.GetSelectedEntities()};
        for i=1, #SelectedEntities, 1 do
            local EntityType = Logic.GetEntityType(SelectedEntities[i]);
            if EntityType == Entities.U_Trebuchet then
                SendReportToGlobal(Report.DisambleTrebuchet, SelectedEntities[i]);
                SendReport(Report.DisambleTrebuchet, SelectedEntities[i]);
            end
        end
    end

    GUI_Military.DisassembleMouseOver_Orig_Selection = GUI_Military.DisassembleMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.DisassembleMouseOver = function()
        local SiegeEngineID = GUI.GetSelectedEntity()
        local TooltipDisabledTextKey
        if Logic.IsSiegeEngineUnderConstruction(SiegeEngineID) == true then
            TooltipDisabledTextKey = "Disassemble"
        else
            TooltipDisabledTextKey = "DisassembleNoSoldiersAttached"
            if not Lib.EntitySelection.Local.TrebuchetDisassemble then
                TooltipDisabledTextKey = "Disassemble";
            end
        end
        GUI_Tooltip.TooltipNormal(nil, TooltipDisabledTextKey)
    end

    GUI_Military.DisassembleUpdate_Orig_Selection = GUI_Military.DisassembleUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.DisassembleUpdate = function()
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local SiegeEngineID = GUI.GetSelectedEntity();
        local EntityType = Logic.GetEntityType(SiegeEngineID);
        if EntityType == Entities.U_Trebuchet then
            local Disabled = (Lib.EntitySelection.Local.TrebuchetDisassemble and 0) or 1;
            XGUIEng.DisableButton(CurrentWidgetID, Disabled);
            SetIcon(CurrentWidgetID, {12, 9});
        else
            GUI_Military.DisassembleUpdate_Orig_Selection();
        end
    end
end

function Lib.EntitySelection.Local:OnSelectionCanged(_Source)
    local EntityID = GUI.GetSelectedEntity();
    local EntityType = Logic.GetEntityType(EntityID);

    if EntityID ~= nil then
        if EntityType == Entities.U_SiegeEngineCart then
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection", 1);
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection", 0);
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary", 1);
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons", 1);
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons", 0);
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/SiegeEngineCart", 1);
        elseif EntityType == Entities.U_Trebuchet then
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection", 1);
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/Selection", 0);
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/BGMilitary", 1);
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons", 1);
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons", 0);
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military", 1);
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military", 1);
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Military/Attack", 0);
            GUI_Military.StrengthUpdate();
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/DialogButtons/SiegeEngine", 1);
        end
    end
end

function Lib.EntitySelection.Local:OverwriteMultiselectIcon()
    GUI_MultiSelection.IconUpdate_Orig_Selection = GUI_MultiSelection.IconUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_MultiSelection.IconUpdate = function()
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local CurrentMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID);
        local CurrentMotherName = XGUIEng.GetWidgetNameByID(CurrentMotherID);
        local Index = CurrentMotherName + 0;
        local CurrentMotherPath = XGUIEng.GetWidgetPathByID(CurrentMotherID);
        local HealthWidgetPath = CurrentMotherPath .. "/Health";
        local EntityID = g_MultiSelection.EntityList[Index];
        local EntityType = Logic.GetEntityType(EntityID);
        local HealthState = Logic.GetEntityHealth(EntityID);
        local EntityMaxHealth = Logic.GetEntityMaxHealth(EntityID);
        if EntityType ~= Entities.U_SiegeEngineCart and EntityType ~= Entities.U_Trebuchet then
            GUI_MultiSelection.IconUpdate_Orig_Selection();
            return;
        end
        if Logic.IsEntityAlive(EntityID) == false then
            XGUIEng.ShowWidget(CurrentMotherID, 0);
            GUI_MultiSelection.CreateEX();
            return;
        end
        SetIcon(CurrentWidgetID, g_TexturePositions.Entities[EntityType]);
        HealthState = math.floor(HealthState / EntityMaxHealth * 100);
        if HealthState < 50 then
            local green = math.floor(2*255* (HealthState/100));
            XGUIEng.SetMaterialColor(HealthWidgetPath,0,255,green, 20,255);
        else
            local red = 2*255 - math.floor(2*255* (HealthState/100));
            XGUIEng.SetMaterialColor(HealthWidgetPath,0,red, 255, 20,255);
        end
        XGUIEng.SetProgressBarValues(HealthWidgetPath,HealthState, 100);
    end

    GUI_MultiSelection.IconMouseOver_Orig_Selection = GUI_MultiSelection.IconMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_MultiSelection.IconMouseOver = function()
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local CurrentMotherID = XGUIEng.GetWidgetsMotherID(CurrentWidgetID);
        local CurrentMotherName = XGUIEng.GetWidgetNameByID(CurrentMotherID);
        local Index = tonumber(CurrentMotherName);
        local EntityID = g_MultiSelection.EntityList[Index];
        local EntityType = Logic.GetEntityType(EntityID);
        if EntityType ~= Entities.U_SiegeEngineCart and EntityType ~= Entities.U_Trebuchet then
            GUI_MultiSelection.IconMouseOver_Orig_Selection();
            return;
        end
        if EntityType == Entities.U_SiegeEngineCart then
            SetTooltipNormal(
                Localize(Lib.EntitySelection.Text.Tooltips.TrebuchetCart.Title),
                Localize(Lib.EntitySelection.Text.Tooltips.TrebuchetCart.Text)
            );
        elseif EntityType == Entities.U_Trebuchet then
            SetTooltipNormal(
                Localize(Lib.EntitySelection.Text.Tooltips.Trebuchet.Title),
                Localize(Lib.EntitySelection.Text.Tooltips.Trebuchet.Text)
            );
        end
    end
end

function Lib.EntitySelection.Local:OverwriteMilitaryDismount()
    GUI_Military.DismountClicked_Orig_Selection = GUI_Military.DismountClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.DismountClicked = function()
        local Selected = GUI.GetSelectedEntity();
        local Type = Logic.GetEntityType(Selected);
        local Guarded = Logic.GetGuardedEntityID(Selected);
        local Guardian = Logic.GetGuardianEntityID(Selected);
        if Guarded ~= 0 and Logic.EntityGetPlayer(Guarded) ~= GUI.GetPlayerID() then
            GUI_Military.DismountClicked_Orig_Selection();
            return;
        end
        if Logic.IsKnight(Selected) or Logic.IsEntityInCategory(Selected, EntityCategories.AttackableMerchant) == 1 then
            GUI_Military.DismountClicked_Orig_Selection();
            return;
        end
        if Logic.IsLeader(Selected) == 1 and Guarded == 0 then
            if Lib.EntitySelection.Local.MilitaryRelease then
                Sound.FXPlay2DSound( "ui\\menu_click");
                local Soldiers = {Logic.GetSoldiersAttachedToLeader(Selected)};
                SendReportToGlobal(Report.ExpelSettler, Soldiers[#Soldiers]);
                SendReport(Report.ExpelSettler, Soldiers[#Soldiers]);
                return;
            end
        end
        if Type == Entities.U_AmmunitionCart or Type == Entities.U_BatteringRamCart
        or Type == Entities.U_CatapultCart or Type == Entities.U_SiegeTowerCart
        or Type == Entities.U_MilitaryBatteringRam or Type == Entities.U_MilitaryCatapult
        or Type == Entities.U_MilitarySiegeTower then
            if Lib.EntitySelection.Local.SiegeEngineRelease and Guardian == 0 then
                Sound.FXPlay2DSound( "ui\\menu_click");
                SendReportToGlobal(Report.ExpelSettler, Selected);
                SendReport(Report.ExpelSettler, Selected);
            else
                GUI_Military.DismountClicked_Orig_Selection();
            end
        end
    end

    GUI_Military.DismountUpdate_Orig_Selection = GUI_Military.DismountUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Military.DismountUpdate = function()
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local Selected = GUI.GetSelectedEntity();
        local Type = Logic.GetEntityType(Selected);
        local Guarded = Logic.GetGuardedEntityID(Selected);
        local Guardian = Logic.GetGuardianEntityID(Selected);
        SetIcon(CurrentWidgetID, {12, 1});
        if Guarded ~= 0 and Logic.EntityGetPlayer(Guarded) ~= GUI.GetPlayerID() then
            XGUIEng.DisableButton(CurrentWidgetID, 0);
            GUI_Military.DismountUpdate_Orig_Selection();
            return;
        end
        if Logic.IsKnight(Selected) or Logic.IsEntityInCategory(Selected, EntityCategories.AttackableMerchant) == 1 then
            XGUIEng.DisableButton(CurrentWidgetID, 0);
            GUI_Military.DismountUpdate_Orig_Selection();
            return;
        end
        SetIcon(CurrentWidgetID, {14, 12});
        if Type == Entities.U_MilitaryLeader then
            if not Lib.EntitySelection.Local.MilitaryRelease then
                XGUIEng.DisableButton(CurrentWidgetID, 1);
            else
                XGUIEng.DisableButton(CurrentWidgetID, 0);
            end
            return;
        end
        if Type == Entities.U_AmmunitionCart or Type == Entities.U_BatteringRamCart
        or Type == Entities.U_CatapultCart or Type == Entities.U_SiegeTowerCart
        or Type == Entities.U_MilitaryBatteringRam or Type == Entities.U_MilitaryCatapult
        or Type == Entities.U_MilitarySiegeTower then
            if Guardian ~= 0 then
                SetIcon(CurrentWidgetID, {12, 1});
                XGUIEng.DisableButton(CurrentWidgetID, 0);
            else
                if not Lib.EntitySelection.Local.SiegeEngineRelease then
                    XGUIEng.DisableButton(CurrentWidgetID, 1);
                else
                    XGUIEng.DisableButton(CurrentWidgetID, 0);
                end
            end
        end
    end
end

function Lib.EntitySelection.Local:OverwriteThiefDeliver()
    GUI_Thief.ThiefDeliverClicked_Orig_Selection = GUI_Thief.ThiefDeliverClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Thief.ThiefDeliverClicked = function()
        if not Lib.EntitySelection.Local.ThiefRelease then
            GUI_Thief.ThiefDeliverClicked_Orig_Selection();
            return;
        end
        Sound.FXPlay2DSound( "ui\\menu_click");
        local ThiefID = GUI.GetSelectedEntity()
        if ThiefID == nil or Logic.GetEntityType(ThiefID) ~= Entities.U_Thief then
            return;
        end
        SendReportToGlobal(Report.ExpelSettler, ThiefID);
        SendReport(Report.ExpelSettler, ThiefID);
    end

    GUI_Thief.ThiefDeliverMouseOver_Orig_Selection = GUI_Thief.ThiefDeliverMouseOver;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Thief.ThiefDeliverMouseOver = function()
        if not Lib.EntitySelection.Local.ThiefRelease then
            GUI_Thief.ThiefDeliverMouseOver_Orig_Selection();
            return;
        end
        SetTooltipNormal(
            Localize(Lib.EntitySelection.Text.Tooltips.ReleaseSoldiers.Title),
            Localize(Lib.EntitySelection.Text.Tooltips.ReleaseSoldiers.Text),
            Localize(Lib.EntitySelection.Text.Tooltips.ReleaseSoldiers.Disabled)
        );
    end

    GUI_Thief.ThiefDeliverUpdate_Orig_Selection = GUI_Thief.ThiefDeliverUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Thief.ThiefDeliverUpdate = function()
        if not Lib.EntitySelection.Local.ThiefRelease then
            GUI_Thief.ThiefDeliverUpdate_Orig_Selection();
            return;
        end
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local ThiefID = GUI.GetSelectedEntity();
        if ThiefID == nil or Logic.GetEntityType(ThiefID) ~= Entities.U_Thief then
            XGUIEng.DisableButton(CurrentWidgetID, 1);
        else
            XGUIEng.DisableButton(CurrentWidgetID, 0);
        end
        SetIcon(CurrentWidgetID, {14, 12});
    end
end

function Lib.EntitySelection.Local:OverwriteSelectKnight()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Knight.JumpToButtonClicked = function()
        local PlayerID = GUI.GetPlayerID();
        local KnightID = Logic.GetKnightID(PlayerID);
        if KnightID > 0 then
            g_MultiSelection.EntityList = {};
            g_MultiSelection.Highlighted = {};
            GUI.ClearSelection();
            if XGUIEng.IsModifierPressed(Keys.ModifierShift) then
                local knights = {}
                Logic.GetKnights(PlayerID, knights);
                for i=1,#knights do
                    GUI.SelectEntity(knights[i]);
                end
            else
                GUI.SelectEntity(Logic.GetKnightID(PlayerID));
                if ((Framework.GetTimeMs() - g_Selection.LastClickTime ) < g_Selection.MaxDoubleClickTime) then
                    local pos = GetPosition(KnightID);
                    Camera.RTS_SetLookAtPosition(pos.X, pos.Y);
                else
                    Sound.FXPlay2DSound("ui\\mini_knight");
                end
                g_Selection.LastClickTime = Framework.GetTimeMs();
            end
            GUI_MultiSelection.CreateMultiSelection(g_SelectionChangedSource.User);
        else
            GUI.AddNote("Debug: You do not have a knight!");
        end
    end
end

function Lib.EntitySelection.Local:OverwriteSelectAllUnits()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_MultiSelection.SelectAllPlayerUnitsClicked = function()
        local ModifierAlt = XGUIEng.IsModifierPressed(Keys.ModifierAlt);
        local ModifierControl = XGUIEng.IsModifierPressed(Keys.ModifierControl);
        local ModifierShift = XGUIEng.IsModifierPressed(Keys.ModifierShift);

        -- Select all units
        if not ModifierAlt and not ModifierControl and not ModifierShift then
            Lib.EntitySelection.Local:SortOrderFullSelection();
        end
        -- Select only thieves
        if ModifierAlt and not ModifierControl and not ModifierShift then
            Lib.EntitySelection.Local:SortOrderSiegeEnginesOnly();
        end
        -- Select only military and knight
        if not ModifierAlt and ModifierControl and not ModifierShift then
            Lib.EntitySelection.Local:SortOrderThievesOnly();
        end
        -- Select only siege engines
        if not ModifierAlt and not ModifierControl and ModifierShift then
            Lib.EntitySelection.Local:SortOrderMilitaryUnitsOnly();
        end

        Sound.FXPlay2DSound("ui\\menu_click");
        GUI.ClearSelection();
        local PlayerID = GUI.GetPlayerID()
        for i = 1, #LeaderSortOrder do
            local EntitiesOfThisType = GetPlayerEntities(PlayerID, LeaderSortOrder[i])
            for j = 1, #EntitiesOfThisType do
                GUI.SelectEntity(EntitiesOfThisType[j])
            end
        end

        -- Add knight only to full selection or military selection
        if (not ModifierAlt and not ModifierControl and not ModifierShift)
        or (not ModifierAlt and not ModifierControl and ModifierShift) then
            local Knights = {}
            Logic.GetKnights(PlayerID, Knights)
            for k = 1, #Knights do
                GUI.SelectEntity(Knights[k])
            end
        end

        GUI_MultiSelection.CreateMultiSelection(g_SelectionChangedSource.User);
    end
end

function Lib.EntitySelection.Local:SortOrderFullSelection()
    g_MultiSelection = {};
    g_MultiSelection.EntityList = {};
    g_MultiSelection.Highlighted = {};

    LeaderSortOrder     = {};
    LeaderSortOrder[1]  = Entities.U_MilitarySword;
    LeaderSortOrder[2]  = Entities.U_MilitaryBow;
    LeaderSortOrder[3]  = Entities.U_MilitarySword_RedPrince;
    LeaderSortOrder[4]  = Entities.U_MilitaryBow_RedPrince;
    LeaderSortOrder[5]  = Entities.U_MilitaryBandit_Melee_ME;
    LeaderSortOrder[6]  = Entities.U_MilitaryBandit_Melee_NA;
    LeaderSortOrder[7]  = Entities.U_MilitaryBandit_Melee_NE;
    LeaderSortOrder[8]  = Entities.U_MilitaryBandit_Melee_SE;
    LeaderSortOrder[9]  = Entities.U_MilitaryBandit_Ranged_ME;
    LeaderSortOrder[10] = Entities.U_MilitaryBandit_Ranged_NA;
    LeaderSortOrder[11] = Entities.U_MilitaryBandit_Ranged_NE;
    LeaderSortOrder[12] = Entities.U_MilitaryBandit_Ranged_SE;
    LeaderSortOrder[13] = Entities.U_MilitaryCatapult;
    LeaderSortOrder[14] = Entities.U_Trebuchet;
    LeaderSortOrder[15] = Entities.U_MilitarySiegeTower;
    LeaderSortOrder[16] = Entities.U_MilitaryBatteringRam;
    LeaderSortOrder[17] = Entities.U_CatapultCart;
    LeaderSortOrder[18] = Entities.U_SiegeTowerCart;
    LeaderSortOrder[19] = Entities.U_BatteringRamCart;
    LeaderSortOrder[20] = Entities.U_AmmunitionCart;
    LeaderSortOrder[21] = Entities.U_Thief;

    if g_GameExtraNo >= 1 then
        table.insert(LeaderSortOrder,  4, Entities.U_MilitarySword_Khana);
        table.insert(LeaderSortOrder,  6, Entities.U_MilitaryBow_Khana);
        table.insert(LeaderSortOrder,  7, Entities.U_MilitaryBandit_Melee_AS);
        table.insert(LeaderSortOrder, 12, Entities.U_MilitaryBandit_Ranged_AS);
    end

    -- Community Patch
    if Entities.U_MilitaryPoleArm then
        table.insert(LeaderSortOrder,  1, Entities.U_MilitaryPoleArm);
    end
    if Entities.U_MilitaryCavalry then
        table.insert(LeaderSortOrder,  1, Entities.U_MilitaryCavalry);
    end
    if Entities.U_MilitaryCannon then
        table.insert(LeaderSortOrder,  17, Entities.U_MilitaryCannon);
    end

end

function Lib.EntitySelection.Local:SortOrderMilitaryUnitsOnly()
    g_MultiSelection = {};
    g_MultiSelection.EntityList = {};
    g_MultiSelection.Highlighted = {};
    g_MultiSelection = {};
    g_MultiSelection.EntityList = {};
    g_MultiSelection.Highlighted = {};

    LeaderSortOrder     = {};
    LeaderSortOrder[1]  = Entities.U_MilitarySword;
    LeaderSortOrder[2]  = Entities.U_MilitaryBow;
    LeaderSortOrder[3]  = Entities.U_MilitarySword_RedPrince;
    LeaderSortOrder[4]  = Entities.U_MilitaryBow_RedPrince;
    LeaderSortOrder[5]  = Entities.U_MilitaryBandit_Melee_ME;
    LeaderSortOrder[6]  = Entities.U_MilitaryBandit_Melee_NA;
    LeaderSortOrder[7]  = Entities.U_MilitaryBandit_Melee_NE;
    LeaderSortOrder[8]  = Entities.U_MilitaryBandit_Melee_SE;
    LeaderSortOrder[9]  = Entities.U_MilitaryBandit_Ranged_ME;
    LeaderSortOrder[10] = Entities.U_MilitaryBandit_Ranged_NA;
    LeaderSortOrder[11] = Entities.U_MilitaryBandit_Ranged_NE;
    LeaderSortOrder[12] = Entities.U_MilitaryBandit_Ranged_SE;

    if g_GameExtraNo >= 1 then
        table.insert(LeaderSortOrder,  4, Entities.U_MilitarySword_Khana);
        table.insert(LeaderSortOrder,  6, Entities.U_MilitaryBow_Khana);
        table.insert(LeaderSortOrder,  7, Entities.U_MilitaryBandit_Melee_AS);
        table.insert(LeaderSortOrder, 12, Entities.U_MilitaryBandit_Ranged_AS);
    end

    -- Community Patch
    if Entities.U_MilitaryPoleArm then
        table.insert(LeaderSortOrder,  1, Entities.U_MilitaryPoleArm);
    end
    if Entities.U_MilitaryCavalry then
        table.insert(LeaderSortOrder,  1, Entities.U_MilitaryCavalry);
    end

end

function Lib.EntitySelection.Local:SortOrderSiegeEnginesOnly()
    g_MultiSelection = {};
    g_MultiSelection.EntityList = {};
    g_MultiSelection.Highlighted = {};

    LeaderSortOrder     = {};
    LeaderSortOrder[1] = Entities.U_MilitaryCatapult;
    LeaderSortOrder[2] = Entities.U_Trebuchet;
    LeaderSortOrder[3] = Entities.U_MilitarySiegeTower;
    LeaderSortOrder[4] = Entities.U_MilitaryBatteringRam;
    LeaderSortOrder[5] = Entities.U_CatapultCart;
    LeaderSortOrder[6] = Entities.U_SiegeTowerCart;
    LeaderSortOrder[7] = Entities.U_BatteringRamCart;
    LeaderSortOrder[8] = Entities.U_AmmunitionCart;

    -- Community Patch
    if Entities.U_MilitaryCannon then
        table.insert(LeaderSortOrder,  1, Entities.U_MilitaryCannon);
    end
end

function Lib.EntitySelection.Local:SortOrderThievesOnly()
    g_MultiSelection = {};
    g_MultiSelection.EntityList = {};
    g_MultiSelection.Highlighted = {};

    LeaderSortOrder     = {};
    LeaderSortOrder[1] = Entities.U_Thief;
end

function Lib.EntitySelection.Local:OverwriteNamesAndDescription()
    GUI_Tooltip.SetNameAndDescription_Orig_Selection = GUI_Tooltip.SetNameAndDescription;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Tooltip.SetNameAndDescription = function(
        _TooltipNameWidget, _TooltipDescriptionWidget, _OptionalTextKeyName,
        _OptionalDisabledTextKeyName, _OptionalMissionTextFileBoolean
    )
        local MotherWidget = "/InGame/Root/Normal/AlignBottomRight";
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();

        if XGUIEng.GetWidgetID(MotherWidget.. "/MapFrame/KnightButton") == CurrentWidgetID then
            SetTooltipNormal(
                Localize(Lib.EntitySelection.Text.Tooltips.KnightButton.Title),
                Localize(Lib.EntitySelection.Text.Tooltips.KnightButton.Text)
            );
            return;
        end

        if XGUIEng.GetWidgetID(MotherWidget.. "/MapFrame/BattalionButton") == CurrentWidgetID then
            SetTooltipNormal(
                Localize(Lib.EntitySelection.Text.Tooltips.BattalionButton.Title),
                Localize(Lib.EntitySelection.Text.Tooltips.BattalionButton.Text)
            );
            return;
        end

        if not IsUnofficialPatch() then
            if XGUIEng.GetWidgetID(MotherWidget.. "/DialogButtons/SiegeEngineCart/Dismount") == CurrentWidgetID
            or XGUIEng.GetWidgetID(MotherWidget.. "/DialogButtons/AmmunitionCart/Dismount") == CurrentWidgetID
            or XGUIEng.GetWidgetID(MotherWidget.. "/DialogButtons/Military/Dismount") == CurrentWidgetID
            then
                local SelectedEntity = GUI.GetSelectedEntity();
                if SelectedEntity ~= 0 then
                    if Logic.IsEntityInCategory(SelectedEntity, EntityCategories.Military) == 1 then
                        local GuardianEntity = Logic.GetGuardianEntityID(SelectedEntity);
                        local GuardedEntity = Logic.GetGuardedEntityID(SelectedEntity);
                        if GuardianEntity == 0 and GuardedEntity == 0 then
                            SetTooltipNormal(
                                Localize(Lib.EntitySelection.Text.Tooltips.ReleaseSoldiers.Title),
                                Localize(Lib.EntitySelection.Text.Tooltips.ReleaseSoldiers.Text),
                                Localize(Lib.EntitySelection.Text.Tooltips.ReleaseSoldiers.Disabled)
                            );
                            return;
                        end
                    end
                end
            end
        end

        GUI_Tooltip.SetNameAndDescription_Orig_Selection(
            _TooltipNameWidget, _TooltipDescriptionWidget, _OptionalTextKeyName,
            _OptionalDisabledTextKeyName, _OptionalMissionTextFileBoolean
        );
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.EntitySelection.Name);

