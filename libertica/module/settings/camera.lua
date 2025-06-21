Lib.Camera = Lib.Camera or {};
Lib.Camera.Name = "Camera";
Lib.Camera.Global = {};
Lib.Camera.Local  = {
    BorderScrollDeactivated = false,
    ExtendedZoomHotKeyID = 0,
    ExtendedZoomAllowed = true,

    AbsoluteCameraLimits = {
        Min = 0.05,
        Max = 0.85,
    },

    CameraExtendedZoom = {
        [1] = {0.85, 0.85, 0.05},
        [2] = {0.85, 0.85, 0.05},
    },
    CameraNormalZoom = {
        [1] = {0.5, 0.5, 0.05},
        [2] = {0.5, 0.5, 0.05},
    },
};

CONST_FARCLIPPLANE = 45000;
CONST_FARCLIPPLANE_DEFAULT = 0;

Lib.Require("comfort/GetPosition");
Lib.Require("core/Core");
Lib.Require("module/settings/Camera_API");
Lib.Require("module/settings/Camera_Text");
Lib.Register("module/settings/Camera");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Camera.Global:Initialize()
    if not self.IsInstalled then
        Report.BorderScrollLocked = CreateReport("Event_BorderScrollLocked");
        Report.BorderScrollReset = CreateReport("Event_BorderScrollReset");
        Report.ExtendedZoomDeactivated = CreateReport("Event_ExtendedZoomDeactivated");
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

        local ZoomMin = Camera.RTS_GetZoomFactorMin();
        local ZoomMax = Camera.RTS_GetZoomFactorMax();
        self.CameraNormalZoom[1][1] = ZoomMin;
        self.CameraNormalZoom[1][3] = ZoomMax;
        self.CameraNormalZoom[2][1] = ZoomMin;
        self.CameraNormalZoom[2][3] = ZoomMax;

        self:ResetRenderDistance();
        self:UpdateCamera(ZoomMin, ZoomMax);

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
    local BorderScrollSize = Options.GetFloatValue("Game", "BorderScrolling", g_DefaultBorderScrollSize);
    local ZoomWheelSpeed = Options.GetFloatValue("Game", "ZoomSpeed", g_DefaultZoomStateWheelSpeed);
    Camera.RTS_FollowEntity(0);
    Camera.RTS_SetBorderScrollSize(BorderScrollSize);
    Camera.RTS_SetZoomWheelSpeed(ZoomWheelSpeed);
    self.BorderScrollDeactivated = false;

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
    if _PlayerID ~= -1 and _PlayerID ~= GUI.GetPlayerID() then
        return;
    end
    if not self.ExtendedZoomActive then
        SendReportToGlobal(Report.ExtendedZoomDeactivated, _PlayerID);
    end
    self.ExtendedZoomActive = true;
    if SetCameraProperties then
        SetCameraProperties(self.CameraExtendedZoom[1][1], self.CameraExtendedZoom[1][3]);
    else
        Camera.RTS_SetZoomFactorMax(self.CameraExtendedZoom[1][1]);
        Camera.RTS_SetZoomFactorMin(self.CameraExtendedZoom[1][3]);
        self:UpdateCamera(self.CameraExtendedZoom[1][1], self.CameraExtendedZoom[1][3]);
    end
    SendReportToGlobal(Report.ExtendedZoomDeactivated, _PlayerID);
end

function Lib.Camera.Local:DeactivateExtendedZoom(_PlayerID)
    if _PlayerID ~= -1 and _PlayerID ~= GUI.GetPlayerID() then
        return;
    end
    if self.ExtendedZoomActive then
        SendReportToGlobal(Report.ExtendedZoomActivated, _PlayerID);
    end
    self.ExtendedZoomActive = false;
    if SetCameraProperties then
        SetCameraProperties(self.CameraNormalZoom[1][1], self.CameraNormalZoom[1][3]);
    else
        Camera.RTS_SetZoomFactorMax(self.CameraNormalZoom[1][1]);
        Camera.RTS_SetZoomFactorMin(self.CameraNormalZoom[1][3]);
        self:UpdateCamera(self.CameraNormalZoom[1][1], self.CameraNormalZoom[1][3]);
    end
end

function Lib.Camera.Local:SetNormalZoomProps(_Limit)
    local min = self.AbsoluteCameraLimits.Min;
    local cur, max = _Limit, _Limit;
    if max > self.AbsoluteCameraLimits.Max then
        max = max;
    end
    self.CameraNormalZoom[1] = {max, cur, min}
end

function Lib.Camera.Local:SetExtendedZoomProps(_Limit)
    local min = self.AbsoluteCameraLimits.Min;
    local cur, max = _Limit, _Limit;
    if max > self.AbsoluteCameraLimits.Max then
        max = self.AbsoluteCameraLimits.Max;
    end
    self.CameraExtendedZoom[1] = {max, cur, min}
end

function Lib.Camera.Local:UpdateCamera(_Min, _Max)
    local ZoomFactor = Camera.RTS_GetZoomFactor();
    if ZoomFactor > _Max then
        Camera.RTS_SetZoomFactor(_Max);
    end
    if ZoomFactor < _Min then
        Camera.RTS_SetZoomFactor(_Min);
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Camera.Name);

