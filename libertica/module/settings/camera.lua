--- @diagnostic disable: duplicate-set-field

Lib.Camera = Lib.Camera or {};
Lib.Camera.Name = "Camera";
Lib.Camera.Global = {};
Lib.Camera.Local  = {
    BorderScrollDeactivated = false,
    ExtendedZoomHotKeyID = 0,
    ExtendedZoomAllowed = true,

    CameraExtendedZoom = {
        [1] = {0.870001, 0.870000, 0.099999},
        [2] = {0.870001, 0.870000, 0.099999},
    },
    CameraNormalZoom = {
        [1] = {0.50001, 0.50000, 0.099999},
        [2] = {0.50001, 0.50000, 0.099999},
    },
};

CONST_FARCLIPPLANE = 45000;
CONST_FARCLIPPLANE_DEFAULT = 0;

Lib.Require("core/Core");
Lib.Require("module/settings/Camera_API");
Lib.Require("module/settings/Camera_Text");
Lib.Register("module/settings/Camera");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Camera.Global:Initialize()
    if not self.IsInstalled then
        --- Scrolling at the edge of the screen is deactivated for a player.
        ---
        --- #### Parameter
        --- - `PlayerID` - ID of Player
        --- - `Position` - ID of Entity camera is fixed on
        Report.BorderScrollLocked = CreateReport("Event_BorderScrollLocked");

        --- Scrolling at the edge of the screen is activated for a player.
        ---
        --- #### Parameter
        --- - `PlayerID` - ID of Player
        Report.BorderScrollReset = CreateReport("Event_BorderScrollReset");

        --- Extended zoom distance is deactivated for the player.
        --- 
        --- #### Parameter
        --- - `PlayerID` - ID of Player
        Report.ExtendedZoomDeactivated = CreateReport("Event_ExtendedZoomDeactivated");

        --- Extended zoom distance is activated for the player.
        --- 
        --- #### Parameter
        --- - `PlayerID` - ID of Player
        Report.ExtendedZoomActivated = CreateReport("Event_ExtendedZoomActivated");

        -- Garbage collection
        Lib.Camera.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Camera.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Camera.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Camera.Local:Initialize()
    if not self.IsInstalled then
        Report.BorderScrollLocked = CreateReport("Event_BorderScrollLocked");
        Report.BorderScrollReset  = CreateReport("Event_BorderScrollReset");
        Report.ExtendedZoomDeactivated = CreateReport("Event_ExtendedZoomDeactivated");
        Report.ExtendedZoomActivated = CreateReport("Event_ExtendedZoomActivated");

        self:ResetRenderDistance();
        self:DescribeExtendedZoomShortcut();
        self:InitExtendedZoomHotkey();

        -- Garbage collection
        Lib.Camera.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Camera.Local:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Camera.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.SaveGameLoaded then
        if self.ExtendedZoomActive then
            self:ActivateExtendedZoom(GUI.GetPlayerID());
        end
        self:InitExtendedZoomHotkey();
        self:ResetRenderDistance();
    end
end

function Lib.Camera.Local:SetRenderDistance(_View)
    Camera.Cutscene_SetFarClipPlane(_View, _View);
    Display.SetFarClipPlaneMinAndMax(_View, _View);
end

function Lib.Camera.Local:ResetRenderDistance()
    Camera.Cutscene_SetFarClipPlane(CONST_FARCLIPPLANE);
    Display.SetFarClipPlaneMinAndMax(CONST_FARCLIPPLANE_DEFAULT, CONST_FARCLIPPLANE_DEFAULT);
end

function Lib.Camera.Local:DeactivateBorderScroll(_PlayerID, _PositionID)
    if (_PlayerID ~= -1 and _PlayerID ~= GUI.GetPlayerID())
    or self.BorderScrollDeactivated then
        return;
    end
    self.BorderScrollDeactivated = true;
    if _PositionID then
        Camera.RTS_FollowEntity(_PositionID);
    end
    Camera.RTS_SetBorderScrollSize(0);
    Camera.RTS_SetZoomWheelSpeed(0);

    SendReportToGlobal(Report.BorderScrollLocked, _PlayerID, (_PositionID or 0));
    SendReport(Report.BorderScrollLocked, _PlayerID, (_PositionID or 0));
end

function Lib.Camera.Local:ActivateBorderScroll(_PlayerID)
    if (_PlayerID ~= -1 and _PlayerID ~= GUI.GetPlayerID())
    or not self.BorderScrollDeactivated then
        return;
    end
    self.BorderScrollDeactivated = false;
    Camera.RTS_FollowEntity(0);
    Camera.RTS_SetBorderScrollSize(3.0);
    Camera.RTS_SetZoomWheelSpeed(4.2);

    SendReportToGlobal(Report.BorderScrollReset, _PlayerID);
    SendReport(Report.BorderScrollReset, _PlayerID);
end

function Lib.Camera.Local:SetCameraToEntity(_Entity, _Rotation, _ZoomFactor)
    local pos = GetPosition(_Entity);
    local rotation = (_Rotation or -45);
    local zoomFactor = (_ZoomFactor or 0.5);
    Camera.RTS_SetLookAtPosition(pos.X, pos.Y);
    Camera.RTS_SetRotationAngle(rotation);
    Camera.RTS_SetZoomFactor(zoomFactor);
end

function Lib.Camera.Local:DescribeExtendedZoomShortcut()
    self:RemoveExtendedZoomShortcut();
    if self.ExtendedZoomHotKeyID == 0 then
        self.ExtendedZoomHotKeyID = AddShortcutDescription(
            Localize(Lib.Camera.Text.Shortcut.Hotkey),
            Localize(Lib.Camera.Text.Shortcut.Description)
        );
    end
end

function Lib.Camera.Local:RemoveExtendedZoomShortcut()
    if self.ExtendedZoomHotKeyID ~= 0 then
        RemoveShortcutDescription(self.ExtendedZoomHotKeyID);
        self.ExtendedZoomHotKeyID = 0;
    end
end

function Lib.Camera.Local:InitExtendedZoomHotkey()
    Input.KeyBindDown(
        Keys.ModifierControl + Keys.ModifierShift + Keys.K,
        "Lib.Camera.Local:ToggleExtendedZoom(GUI.GetPlayerID())",
        2
    );
end

function Lib.Camera.Local:ToggleExtendedZoom(_PlayerID)
    if self.ExtendedZoomAllowed then
        if self.ExtendedZoomActive then
            self:DeactivateExtendedZoom(_PlayerID);
        else
            self:ActivateExtendedZoom(_PlayerID);
        end
    end
end

function Lib.Camera.Local:ActivateExtendedZoom(_PlayerID)
    if _PlayerID~= -1 and _PlayerID ~= GUI.GetPlayerID() then
        return;
    end
    if not self.ExtendedZoomActive then
        SendReportToGlobal(Report.ExtendedZoomDeactivated, _PlayerID);
    end
    self.ExtendedZoomActive = true;
    Camera.RTS_SetZoomFactor(self.CameraExtendedZoom[1][2]);
    Camera.RTS_SetZoomFactorMax(self.CameraExtendedZoom[1][1]);
    Camera.RTS_SetZoomFactorMin(self.CameraExtendedZoom[1][3]);
    SendReportToGlobal(Report.ExtendedZoomDeactivated, _PlayerID);
end

function Lib.Camera.Local:DeactivateExtendedZoom(_PlayerID)
    if _PlayerID~= -1 and _PlayerID ~= GUI.GetPlayerID() then
        return;
    end
    if self.ExtendedZoomActive then
        SendReportToGlobal(Report.ExtendedZoomActivated, _PlayerID);
    end
    self.ExtendedZoomActive = false;
    Camera.RTS_SetZoomFactor(self.CameraNormalZoom[1][2]);
    Camera.RTS_SetZoomFactorMax(self.CameraNormalZoom[1][1]);
    Camera.RTS_SetZoomFactorMin(self.CameraNormalZoom[1][3]);
end

function Lib.Camera.Local:SetNormalZoomProps(_Limit)
    local min, cur, max = 0.099999, _Limit, _Limit + 0.000001;
    if max > self.CameraNormalZoom[2][1] then
        max = self.CameraNormalZoom[2][1];
    end
    self.CameraNormalZoom[1] = {max, cur, min}
end

function Lib.Camera.Local:SetExtendedZoomProps(_Limit)
    local min, cur, max = 0.099999, _Limit, _Limit + 0.000001;
    if max > self.CameraExtendedZoom[2][1] then
        max = self.CameraExtendedZoom[2][1];
    end
    self.CameraExtendedZoom[1] = {max, cur, min}
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Camera.Name);

