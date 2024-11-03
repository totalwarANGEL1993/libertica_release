Lib.UITools = Lib.UITools or {};
Lib.UITools.Name = "UITools";
Lib.UITools.Global = {};
Lib.UITools.Local = {};

CONST_PLAYER_NAMES = {};

Lib.Require("core/Core");
Lib.Require("module/ui/UITools_Shortcut");
Lib.Require("module/ui/UITools_Widget");
Lib.Require("module/ui/UITools_Speed");
Lib.Require("module/ui/UITools_API");
Lib.Register("module/ui/UITools");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.UITools.Global:Initialize()
    if not self.IsInstalled then
        -- public reports
        Report.BuildingPlaced = CreateReport("Event_BuildingPlaced");

        -- internal reports
        Report.UpdateTexturePosition = CreateReport("Event_UpdateTexturePosition");

        -- Garbage collection
        Lib.UITools.Local = nil;
        Lib.UITools.Shortcut = nil;
        Lib.UITools.Speed = nil;
        Lib.UITools.Widget = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.UITools.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.UITools.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.UpdateTexturePosition then
        g_TexturePositions = g_TexturePositions or {};
        g_TexturePositions[arg[1]] = g_TexturePositions[arg[1]] or {};
        g_TexturePositions[arg[1]][arg[2]] = {arg[3], arg[4], arg[5]};
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.UITools.Local:Initialize()
    if not self.IsInstalled then
        -- public reports
        Report.BuildingPlaced = CreateReport("Event_BuildingPlaced");

        -- internal reports
        Report.UpdateTexturePosition = CreateReport("Event_UpdateTexturePosition");

        Lib.UITools.Shortcut:OverrideRegisterHotkey();
        Lib.UITools.Widget:OverrideMissionGoodCounter();
        Lib.UITools.Widget:OverrideUpdateClaimTerritory();
        Lib.UITools.Speed:InitForbidSpeedUp();

        self:PostTexturePositionsToGlobal();
        self:OverrideAfterBuildingPlacement();

        -- Garbage collection
        Lib.UITools.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.UITools.Local:OnSaveGameLoaded()
    Lib.UITools.Widget:UpdateHiddenWidgets();
end

-- Global report listener
function Lib.UITools.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.UITools.Local:OverrideAfterBuildingPlacement()
    GameCallback_GUI_AfterBuildingPlacement_Orig_UITools = GameCallback_GUI_AfterBuildingPlacement;
    GameCallback_GUI_AfterBuildingPlacement = function ()
        GameCallback_GUI_AfterBuildingPlacement_Orig_UITools();

        local x,y = GUI.Debug_GetMapPositionUnderMouse();
        RequestHiResJob(function()
            local Results = {Logic.GetPlayerEntitiesInArea(GUI.GetPlayerID(), 0, x, y, 50, 16)};
            for i= 2, Results[1] +1 do
                if  Results[i]
                and Results[i] ~= 0
                and Logic.IsBuilding(Results[i]) == 1
                and Logic.IsConstructionComplete(Results[i]) == 0
                then
                    SendReportToGlobal(Report.BuildingPlaced, Results[i], Logic.EntityGetPlayer(Results[i]));
                    SendReport(Report.BuildingPlaced, Results[i], Logic.EntityGetPlayer(Results[i]));
                end
            end
        end, x, y);
    end
end

function Lib.UITools.Local:PostTexturePositionsToGlobal()
    RequestJob(function()
        if Logic.GetTime() > 1 then
            for k, v in pairs(g_TexturePositions) do
                for kk, vv in pairs(v) do
                    local x,y,z = vv[1] or 1, vv[2] or 1, vv[3] or 0;
                    SendReportToGlobal(Report.UpdateTexturePosition, k, kk, x, y, z);
                end
            end
            return true;
        end
    end);
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.UITools.Name);

