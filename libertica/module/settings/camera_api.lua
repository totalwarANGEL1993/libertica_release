Lib.Require("comfort/IsLocalScript");
Lib.Register("module/settings/Camera_API");

function SetRenderDistance(_View)
    if not IsLocalScript() then
        ExecuteLocal([[Lib.Camera.Local:SetRenderDistance(%f)]], _View);
        return;
    end
    Lib.Camera.Local:SetRenderDistance(_View);
end

function ResetRenderDistance()
    if not IsLocalScript() then
        ExecuteLocal([[Lib.Camera.Local:ResetRenderDistance()]]);
        return;
    end
    Lib.Camera.Local:ResetRenderDistance();
end

function ActivateBorderScroll(_PlayerID)
    _PlayerID = _PlayerID or -1;
    assert(_PlayerID == -1 or (_PlayerID >= 1 and _PlayerID <= 8));
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.Camera.Local:ActivateBorderScroll(%d)",
            _PlayerID
        );
        return;
    end
    Lib.Camera.Local:ActivateBorderScroll(_PlayerID);
end
API.ActivateBorderScroll = ActivateBorderScroll;

function DeactivateBorderScroll(_Position, _PlayerID)
    _PlayerID = _PlayerID or -1;
    assert(_PlayerID == -1 or (_PlayerID >= 1 and _PlayerID <= 8));
    local PositionID;
    if _Position then
        PositionID = GetID(_Position);
    end
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.Camera.Local:DeactivateBorderScroll(%d, %d)",
            _PlayerID,
            (PositionID or 0)
        );
        return;
    end
    Lib.Camera.Local:DeactivateBorderScroll(_PlayerID, PositionID);
end
API.DeactivateBorderScroll = DeactivateBorderScroll;

function AllowExtendedZoom(_Flag, _PlayerID)
    _PlayerID = _PlayerID or -1;
    if not GUI then
        ExecuteLocal([[API.AllowExtendedZoom(%s, %d)]], tostring(_Flag == true), _PlayerID);
        return;
    end
    if _PlayerID ~= -1 and GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    Lib.Camera.Local.ExtendedZoomAllowed = _Flag == true;
    if _Flag == true then
        Lib.Camera.Local:DescribeExtendedZoomShortcut();
    else
        Lib.Camera.Local:RemoveExtendedZoomShortcut();
        Lib.Camera.Local:DeactivateExtendedZoom(_PlayerID);
    end
end
API.AllowExtendedZoom = AllowExtendedZoom;

function ToggleExtendedZoom(_PlayerID)
    if not GUI then
        ExecuteLocal([[ToggleExtendedZoom(%d)]], _PlayerID);
        return;
    end
    Lib.Camera.Local:ToggleExtendedZoom(_PlayerID)
end
API.ToggleExtendedZoom = ToggleExtendedZoom;

function SetNormalZoomProps(_Limit)
    if not GUI then
        ExecuteLocal([[SetNormalZoomProps(%f)]], _Limit);
        return;
    end
    assert(type(_Limit) == "number", "Limit is wrong!");
    Lib.Camera.Local:SetNormalZoomProps(_Limit);
end
API.SetNormalZoomProps = SetNormalZoomProps;

function SetExtendedZoomProps(_Limit)
    if not GUI then
        ExecuteLocal([[SetExtendedZoomProps(%f)]], _Limit);
        return;
    end
    assert(type(_Limit) == "number", "Limit is wrong!");
    Lib.Camera.Local:SetExtendedZoomProps(_Limit);
end
API.SetExtendedZoomProps = SetExtendedZoomProps;

function FocusCameraOnKnight(_PlayerID, _Rotation, _ZoomFactor)
    FocusCameraOnEntity(Logic.GetKnightID(_PlayerID), _Rotation, _ZoomFactor)
end
API.FocusCameraOnKnight = FocusCameraOnKnight;

function FocusCameraOnEntity(_Entity, _Rotation, _ZoomFactor)
    if not GUI then
        local Subject = (type(_Entity) ~= "string" and _Entity) or ("'" .._Entity.. "'");
        ExecuteLocal([[API.FocusCameraOnEntity(%s, %f, %f)]], Subject, _Rotation, _ZoomFactor);
        return;
    end
    assert(type(_Rotation) == "number", "Rotation is wrong!");
    assert(type(_ZoomFactor) == "number", "Zoom factor is wrong!");
    assert(IsExisting(_Entity), "Entity does not exist!");
    Lib.Camera.Local:SetCameraToEntity(_Entity, _Rotation, _ZoomFactor);
end
API.FocusCameraOnEntity = FocusCameraOnEntity;

