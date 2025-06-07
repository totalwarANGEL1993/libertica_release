Lib.Permadeath = Lib.Permadeath or {};
Lib.Permadeath.Name = "Permadeath";
Lib.Permadeath.Global = {
    SuspendedSettlers = {},
};
Lib.Permadeath.Local  = {
    SuspendedSettlers = {},
};

Lib.Require("core/Core");
Lib.Require("module/city/Construction");
Lib.Require("module/ui/UIBuilding");
Lib.Require("module/faker/Permadeath_API");
Lib.Register("module/faker/Permadeath");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Permadeath.Global:Initialize()
    if not self.IsInstalled then
        Report.SettlerSuspensionElapsed = CreateReport("Event_SettlerSuspensionElapsed");
        Report.FireAlarmDeactivated_Internal = CreateReport("Event_FireAlarmDeactivated_Internal");
        Report.FireAlarmActivated_Internal = CreateReport("Event_FireAlarmActivated_Internal");
        Report.RepairAlarmDeactivated_Internal = CreateReport("Event_RepairAlarmFeactivated");
        Report.RepairAlarmActivated_Internal = CreateReport("Event_RepairAlarmActivated_Internal");

        for PlayerID= 1,8 do
            self.SuspendedSettlers[PlayerID] = {};
        end

        RequestJobByEventType(
            Events.LOGIC_EVENT_EVERY_TURN,
            function()
                local Turn = Logic.GetCurrentTurn();
                Lib.Permadeath.Global:ResumeSettlersAfterSuspension(Turn);
            end
        );

        -- Garbage collection
        Lib.Permadeath.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Permadeath.Global:OnSaveGameLoaded()
    self:RestoreSettlerSuspension();
end

-- Global report listener
function Lib.Permadeath.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.FireAlarmDeactivated_Internal then
        self:RestoreSettlerSuspension();
    elseif _ID == Report.FireAlarmActivated_Internal then
        self:RestoreSettlerSuspension();
    elseif _ID == Report.RepairAlarmDeactivated_Internal then
        self:RestoreSettlerSuspension();
    elseif _ID == Report.RepairAlarmActivated_Internal then
        self:RestoreSettlerSuspension();
    end
end

-- -------------------------------------------------------------------------- --

-- Resumes a settler.
function Lib.Permadeath.Global:ResumeSettler(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local StoreHouseID = Logic.GetStoreHouse(PlayerID);
    -- Can't resume if player is dead
    if StoreHouseID == 0 then
        return;
    end
    -- Can only resume workers and spouses
    if  Logic.IsEntityInCategory(EntityID, EntityCategories.Spouse) == 0
    and Logic.IsEntityInCategory(EntityID, EntityCategories.Worker) == 0 then
        return;
    end
    -- Resume settler
    local x, y = Logic.GetBuildingApproachPosition(StoreHouseID);
    Logic.DEBUG_SetSettlerPosition(EntityID, x, y);
    Logic.SetVisible(EntityID, true);
    Logic.SetTaskList(EntityID, TaskLists.TL_WORKER_IDLE);
    -- Remove from suspension list
    if self.SuspendedSettlers[PlayerID][EntityID] then
        ExecuteLocal("Lib.Permadeath.Local.SuspendedSettlers[%d][%d] = nil", PlayerID, EntityID);
        self.SuspendedSettlers[PlayerID][EntityID] = nil;
    end
end

-- Suspend a settler.
function Lib.Permadeath.Global:SuspendSettler(_Entity, _SuspendtionTime)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local StoreHouseID = Logic.GetStoreHouse(PlayerID);
    local Time = math.floor(Logic.GetTime());
    -- Can't suspend if player is dead
    if StoreHouseID == 0 then
        return;
    end
    -- Can only suspend workers and spouses
    if  Logic.IsEntityInCategory(EntityID, EntityCategories.Spouse) == 0
    and Logic.IsEntityInCategory(EntityID, EntityCategories.Worker) == 0 then
        return;
    end
    -- Reset needs if building empty
    local BuildingID = Logic.GetSettlersWorkBuilding(EntityID);
    local AttachedSettlers = {Logic.GetWorkersAndSpousesForBuilding(BuildingID)};
    local AnyNotSuspended = false;
    for i= 1, #AttachedSettlers do
        if AttachedSettlers[i] > 0 and not self:IsSettlerSuspended(AttachedSettlers[i]) then
            AnyNotSuspended = true;
            break;
        end
    end
    if AnyNotSuspended == false then
        Logic.SetNeedState(EntityID, Needs.Nutrition, 1.0);
        Logic.SetNeedState(EntityID, Needs.Entertainment, 1.0);
        Logic.SetNeedState(EntityID, Needs.Clothes, 1.0);
        Logic.SetNeedState(EntityID, Needs.Hygiene, 1.0);
        Logic.SetNeedState(EntityID, Needs.Medicine, 1.0);
    end
    -- Relocate inside storehouse and make invisible
    local x,y,z = Logic.EntityGetPos(StoreHouseID);
    Logic.DEBUG_SetSettlerPosition(EntityID, x, y);
    Logic.SetVisible(EntityID, false);
    Logic.SetTaskList(EntityID, TaskLists.TL_NPC_IDLE);
    -- Add to suspended settler map
    if not self.SuspendedSettlers[PlayerID][EntityID] then
        ExecuteLocal("Lib.Permadeath.Local.SuspendedSettlers[%d][%d] = {%d, %d}", PlayerID, EntityID, Time, _SuspendtionTime or -1);
        self.SuspendedSettlers[PlayerID][EntityID] = {Time, _SuspendtionTime or -1};
    end
end

function Lib.Permadeath.Global:IsSettlerSuspended(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    return self.SuspendedSettlers[PlayerID] and self.SuspendedSettlers[PlayerID][EntityID] ~= nil;
end

function Lib.Permadeath.Global:HasSuspendedInhabitants(_Entity)
    local BuildingID = GetID(_Entity)
    local AttachedSettlers = {Logic.GetWorkersAndSpousesForBuilding(BuildingID)};
    for i= 1, #AttachedSettlers do
        if AttachedSettlers[i] > 0 and self:IsSettlerSuspended(AttachedSettlers[i]) then
            return true;
        end
    end
    return false;
end

function Lib.Permadeath.Global:CountWorkerInBuilding(_Entity)
    local WorkerCount = 0;
    local BuildingID = GetID(_Entity);
    local Slots = Logic.GetUpgradeLevel(BuildingID) +1;
    for _, SettlerID in pairs({Logic.GetWorkersForBuilding(BuildingID)}) do
        if SettlerID > 0 and not IsSettlerSuspended(SettlerID) then
            WorkerCount = WorkerCount +1;
        end
    end
    return math.min(WorkerCount, Slots);
end

function Lib.Permadeath.Global:CountInhabitantsInBuilding(_Entity)
    local WorkerCount = 0;
    local BuildingID = GetID(_Entity);
    local Slots = Logic.GetUpgradeLevel(BuildingID) +1;
    for _, SettlerID in pairs({Logic.GetWorkersAndSpousesForBuilding(BuildingID)}) do
        if SettlerID > 0 and not IsSettlerSuspended(SettlerID) then
            WorkerCount = WorkerCount +1;
        end
    end
    return math.min(WorkerCount, Slots);
end

-- Restores tasklist and position of fake dead settlers.
function Lib.Permadeath.Global:RestoreSettlerSuspension()
    for PlayerID = 1, 8 do
        for Entity, Data in pairs(self.SuspendedSettlers[PlayerID]) do
            if not IsExisting(Entity) then
                ExecuteLocal("Lib.Permadeath.Local.SuspendedSettlers[%d][%d] = nil", PlayerID, Entity);
                self.SuspendedSettlers[PlayerID][Entity] = nil;
            else
                local SuspensionTime = -1;
                local Time = math.floor(Logic.GetTime());
                if Data[2] > -1 and (Data[1] + Data[2]) - Time > 0 then
                    SuspensionTime = (Data[1] + Data[2]) - Time;
                end
                local ID = GetID(Entity);
                self.SuspendedSettlers[PlayerID][ID] = nil;
                self:SuspendSettler(Entity, SuspensionTime);
            end
        end
    end
end

-- Removes the suspended settler after the suspention time is over.
function Lib.Permadeath.Global:ResumeSettlersAfterSuspension(_Turn)
    local CurrentTime = Logic.GetTime();
    local PlayerID = _Turn % 10;
    if PlayerID >= 1 and PlayerID <= 8 then
        for k,v in pairs(self.SuspendedSettlers[PlayerID]) do
            if v[2] > -1 and v[1] + v[2] < CurrentTime then
                self:ResumeSettler(k);
                SendReportToLocal(Report.SettlerSuspensionElapsed, k);
                SendReport(Report.SettlerSuspensionElapsed, k);
            end
        end
    end
end

function Lib.Permadeath.Global:IsSettlerStriking(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local TaskList = Logic.GetCurrentTaskList(EntityID);
    local MarketID = Logic.GetMarketplace(PlayerID);
    if MarketID ~= 0 and TaskList == "TL_WORKER_IDLE_UNFIT" then
        if Logic.IsEntityMoving(EntityID) == false then
            return Logic.CheckEntitiesDistance(EntityID, MarketID, 1500) == true;
        end
    end
    return false;
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Permadeath.Local:Initialize()
    if not self.IsInstalled then
        Report.SettlerSuspensionElapsed = CreateReport("Event_SettlerSuspensionElapsed");
        Report.FireAlarmDeactivated_Internal = CreateReport("Event_FireAlarmDeactivated_Internal");
        Report.FireAlarmActivated_Internal = CreateReport("Event_FireAlarmActivated_Internal");
        Report.RepairAlarmDeactivated_Internal = CreateReport("Event_RepairAlarmFeactivated");
        Report.RepairAlarmActivated_Internal = CreateReport("Event_RepairAlarmActivated_Internal");

        self:OverwriteJumpToWorker();
        self:OverwriteGameCallbacks();
        self:OverrideSelectionChanged();
        self:OverwriteAlarmButtons();

        for PlayerID = 1,8 do
            self.SuspendedSettlers[PlayerID] = {};
        end

        -- Garbage collection
        Lib.Permadeath.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Permadeath.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.Permadeath.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.Permadeath.Local:OverwriteJumpToWorker()
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingInfo.JumpToWorkerClicked = function()
        Sound.FXPlay2DSound( "ui\\menu_click");
        local PlayerID = GUI.GetPlayerID();
        local SelectedEntityID = GUI.GetSelectedEntity();
        local InhabitantsBuildingID = 0;
        local IsSettlerSelected;
        if Logic.IsBuilding(SelectedEntityID) == 1 then
            InhabitantsBuildingID = SelectedEntityID;
            IsSettlerSelected = false;
        else
            if Logic.IsWorker(SelectedEntityID) == 1
            or Logic.IsSpouse(SelectedEntityID) == true
            or Logic.GetEntityType(SelectedEntityID) == Entities.U_Priest then
                InhabitantsBuildingID = Logic.GetSettlersWorkBuilding(SelectedEntityID);
                IsSettlerSelected = true;
            end
        end
        if InhabitantsBuildingID ~= 0 then
            local WorkersAndSpousesInBuilding = {Logic.GetWorkersAndSpousesForBuilding(InhabitantsBuildingID)}

            -- To pretend settlers of the building have died, we need to remove
            -- them from the intabitants list.
            for i = #WorkersAndSpousesInBuilding, 1, -1 do
                local SettlerID = WorkersAndSpousesInBuilding[i];
                if Lib.Permadeath.Local.SuspendedSettlers[PlayerID] then
                    if Lib.Permadeath.Local.SuspendedSettlers[PlayerID][SettlerID] then
                        table.remove(WorkersAndSpousesInBuilding, i);
                    end
                end
            end

            local InhabitantID
            if g_CloseUpView.Active == false and IsSettlerSelected == true then
                InhabitantID = SelectedEntityID;
            else
                local InhabitantPosition = 1;
                for i = 1, #WorkersAndSpousesInBuilding do
                    if WorkersAndSpousesInBuilding[i] == g_LastSelectedInhabitant then
                        InhabitantPosition = i + 1;
                        break;
                    end
                end
                InhabitantID = WorkersAndSpousesInBuilding[InhabitantPosition];
                if InhabitantID == 0 then
                    InhabitantID = WorkersAndSpousesInBuilding[InhabitantPosition + 1];
                end
            end
            if InhabitantID == nil then
                local x,y = Logic.GetEntityPosition(InhabitantsBuildingID);
                g_LastSelectedInhabitant = nil;
                ShowCloseUpView(0, x, y);
                GUI.SetSelectedEntity(InhabitantsBuildingID);
            else
                GUI.SetSelectedEntity(InhabitantID);
                ShowCloseUpView(InhabitantID);
                g_LastSelectedInhabitant = InhabitantID;
            end
        end
    end
end

function Lib.Permadeath.Local:IsSettlerSuspended(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    return self.SuspendedSettlers[PlayerID] and self.SuspendedSettlers[PlayerID][EntityID] ~= nil;
end

function Lib.Permadeath.Local:HasSuspendedInhabitants(_Entity)
    local BuildingID = GetID(_Entity);
    local AttachedSettlers = {Logic.GetWorkersAndSpousesForBuilding(BuildingID)};
    for i= 1, #AttachedSettlers do
        if AttachedSettlers[i] > 0 and self:IsSettlerSuspended(AttachedSettlers[i]) then
            return true;
        end
    end
    return false;
end

function Lib.Permadeath.Local:CountWorkerInBuilding(_Entity)
    local WorkerCount = 0;
    local BuildingID = GetID(_Entity);
    local Slots = Logic.GetUpgradeLevel(BuildingID) +1;
    for _, SettlerID in pairs({Logic.GetWorkersForBuilding(BuildingID)}) do
        if SettlerID > 0 and not IsSettlerSuspended(SettlerID) then
            WorkerCount = WorkerCount +1;
        end
    end
    return math.min(WorkerCount, Slots);
end

function Lib.Permadeath.Local:CountInhabitantsInBuilding(_Entity)
    local WorkerCount = 0;
    local BuildingID = GetID(_Entity);
    local Slots = Logic.GetUpgradeLevel(BuildingID) +1;
    for _, SettlerID in pairs({Logic.GetWorkersAndSpousesForBuilding(BuildingID)}) do
        if SettlerID > 0 and not IsSettlerSuspended(SettlerID) then
            WorkerCount = WorkerCount +1;
        end
    end
    return math.min(WorkerCount, Slots);
end

function Lib.Permadeath.Local:OverwriteGameCallbacks()
    self.Orig_GameCallback_Feedback_OnBuildingBurning = GameCallback_Feedback_OnBuildingBurning;
    GameCallback_Feedback_OnBuildingBurning = function(_PlayerID, _EntityID)
        Lib.Permadeath.Local.Orig_GameCallback_Feedback_OnBuildingBurning(_PlayerID, _EntityID);
        SendReportToGlobal(Report.FireAlarmActivated_Internal, _EntityID);
    end
end

function Lib.Permadeath.Local:OverwriteAlarmButtons()
    GUI_BuildingButtons.StartStopFireAlarmClicked_Orig_Permadeath = GUI_BuildingButtons.StartStopFireAlarmClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartStopFireAlarmClicked = function()
        GUI_BuildingButtons.StartStopFireAlarmClicked_Orig_Permadeath();
        local EntityID = GUI.GetSelectedEntity()
        if Logic.IsFireAlarmActiveAtBuilding(EntityID) == true then
            SendReportToGlobal(Report.FireAlarmActivated_Internal, EntityID);
        else
            SendReportToGlobal(Report.FireAlarmDeactivated_Internal, EntityID);
        end
    end

    GUI_BuildingButtons.StartStopRepairAlarmClicked_Orig_Permadeath = GUI_BuildingButtons.StartStopRepairAlarmClicked;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_BuildingButtons.StartStopRepairAlarmClicked = function()
        GUI_BuildingButtons.StartStopRepairAlarmClicked_Orig_Permadeath();
        local EntityID = GUI.GetSelectedEntity()
        if Logic.IsRepairAlarmActiveAtBuilding(EntityID) == true then
            SendReportToGlobal(Report.RepairAlarmActivated_Internal, EntityID);
        else
            SendReportToGlobal(Report.RepairAlarmDeactivated_Internal, EntityID);
        end
    end
end

function Lib.Permadeath.Local:OverrideSelectionChanged()
    self.Orig_GameCallback_GUI_SelectionChanged = GameCallback_GUI_SelectionChanged;
    GameCallback_GUI_SelectionChanged = function(_Source)
        Lib.Permadeath.Local.Orig_GameCallback_GUI_SelectionChanged(_Source);
        Lib.Permadeath.Local:OnBuildingSelected();
    end
end

function Lib.Permadeath.Local:OnBuildingSelected()
    local EntityID = GUI.GetSelectedEntity();
    if self.IsActive then
        -- Buildings
        if Logic.IsEntityInCategory(EntityID, EntityCategories.OuterRimBuilding) == 1 then
            if self.Misc.ClothesForOuterRim then
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Clothes", 1);
            else
                XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Clothes", 0);
            end
        end
        -- Settlers
        if Logic.IsEntityInCategory(EntityID, EntityCategories.Spouse) == 1
        or Logic.IsEntityInCategory(EntityID, EntityCategories.Worker) == 1 then
            local BuildingID = Logic.GetSettlersWorkBuilding(EntityID);
            if Logic.IsEntityInCategory(BuildingID, EntityCategories.OuterRimBuilding) == 1 then
                if self.Misc.ClothesForOuterRim then
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Clothes", 1);
                else
                    XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomRight/Selection/Needs/Clothes", 0);
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Permadeath.Name);

