Lib.IOSite = Lib.IOSite or {};
Lib.IOSite.Name = "IOSite";
Lib.IOSite.Global = {
    CreatedSites = {},
};
Lib.IOSite.Local  = {};

Lib.Require("core/Core");
Lib.Require("module/io/IO");
Lib.Require("module/io/IOSite_Text");
Lib.Require("module/io/IOSite_API");
Lib.Register("module/io/IOSite");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.IOSite.Global:Initialize()
    if not self.IsInstalled then
        Report.InteractiveSiteBuild = CreateReport("Event_InteractiveSiteBuild");

        self:OverrideConstructionCompleteCallback();

        -- Garbage collection
        Lib.IOSite.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.IOSite.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.IOSite.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.ObjectReset then
    elseif _ID == Report.ObjectDelete then
    end
end

function Lib.IOSite.Global:CreateIOBuildingSite(_Data)
    local Costs = _Data.Costs or {Logic.GetEntityTypeFullCost(_Data.Type)};
    local Title = _Data.Title or Lib.IOSite.Text.Description.Title;
    local Text = _Data.Text or Lib.IOSite.Text.Description.Text;

    local EntityID = GetID(_Data.ScriptName);
    Logic.SetModel(EntityID, Models.Buildings_B_BuildingPlot_10x10);
    Logic.SetVisible(EntityID, true);

    _Data.Title = Title;
    _Data.Text = Text;
    _Data.Costs = Costs;
    _Data.ConditionOrigSite = _Data.Condition;
    _Data.ActionOrigSite = _Data.Action;
    API.SetupObject(_Data);

    CONST_IO[_Data.ScriptName].Condition = function(_Data)
        if _Data.ConditionOrigSite then
            _Data.ConditionOrigSite(_Data);
        end
        return self:ConditionIOConstructionSite(_Data);
    end
    CONST_IO[_Data.ScriptName].Action = function(_Data, _KnightID, _PlayerID)
        self:CallbackIOConstructionSite(_Data, _KnightID, _PlayerID);
        if _Data.ActionOrigSite then
            _Data.ActionOrigSite(_Data, _KnightID, _PlayerID);
        end
    end
end

function Lib.IOSite.Global:CallbackIOConstructionSite(_Data, _KnightID, _PlayerID)
    local Position = GetPosition(_Data.ScriptName);
    local EntityID = GetID(_Data.ScriptName);
    local Orientation = Logic.GetEntityOrientation(EntityID);
    local SiteID = Logic.CreateConstructionSite(Position.X, Position.Y, Orientation, _Data.Type, _Data.PlayerID);
    Logic.SetVisible(EntityID, false);

    if (SiteID == nil) then
        warn("For object '" .._Data.ScriptName.. "' building placement failed! Building created instead");
        SiteID = Logic.CreateEntity(_Data.Type, Position.X, Position.Y, Orientation, _Data.PlayerID);
    end
    self.CreatedSites[SiteID] = _Data;
end

function Lib.IOSite.Global:ConditionIOConstructionSite(_Data)
    local EntityID = GetID(_Data.ScriptName);
    local TerritoryID = GetTerritoryUnderEntity(EntityID);
    local PlayerID = Logic.GetTerritoryPlayerID(TerritoryID);

    if Logic.GetStoreHouse(_Data.PlayerID) == 0 then
        return false;
    end
    if _Data.PlayerID ~= PlayerID then
        return false;
    end
    return true;
end

function Lib.IOSite.Global:OverrideConstructionCompleteCallback()
    self.Orig_GameCallback_OnBuildingConstructionComplete = GameCallback_OnBuildingConstructionComplete;
    GameCallback_OnBuildingConstructionComplete = function(_PlayerID, _EntityID)
        Lib.IOSite.Global.Orig_GameCallback_OnBuildingConstructionComplete(_PlayerID, _EntityID);

        if Lib.IOSite.Global.CreatedSites[_EntityID] then
            local Object = Lib.IOSite.Global.CreatedSites[_EntityID];
            if Object then
                SendReport(Report.InteractiveSiteBuild, Object.ScriptName, _PlayerID, _EntityID);
                SendReportToLocal(Report.InteractiveSiteBuild, Object.ScriptName, _PlayerID, _EntityID);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.IOSite.Local:Initialize()
    if not self.IsInstalled then
        Report.InteractiveSiteBuild = CreateReport("Event_InteractiveSiteBuild");

        -- Garbage collection
        Lib.IOSite.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.IOSite.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.IOSite.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.IOSite.Name);

