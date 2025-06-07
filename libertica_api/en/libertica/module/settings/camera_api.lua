--- Functions to manipulate the RTS camera.



--- Changes the max rendering distance until something is clipped.
--- @param _View number Max randering distance
function SetRenderDistance(_View)
end

--- Resets the clipping to it's default values.
function ResetRenderDistance()
end

--- Activates border scroll and loosens camera fixation.
--- @param _PlayerID integer? ID of player
function ActivateBorderScroll(_PlayerID)
end
API.ActivateBorderScroll = ActivateBorderScroll;

--- Deactivates border scroll and fixes camera.
--- @param _PlayerID integer? ID of player
--- @param _Position integer? (Optional) Entity to fix camera on
function DeactivateBorderScroll(_Position, _PlayerID)
end
API.DeactivateBorderScroll = DeactivateBorderScroll;

--- Activates the extended zoom for one or for all players.
--- @param _PlayerID integer? ID of player
function ActivateExtendedZoom(_PlayerID)
end
API.ActivateExtendedZoom = ActivateExtendedZoom;

--- Deactivates the extended zoom for one or for all players.
--- @param _PlayerID integer? ID of player
function DeactivateExtendedZoom(_PlayerID)
end
API.DeactivateExtendedZoom = DeactivateExtendedZoom;

--- Changes the limit for the normal zoom.
--- 
--- The default value is set to 0.5.
--- 
--- @param _Limit number Zoom limit (between 0.1 and 0.87)
function SetNormalZoomProps(_Limit)
end
API.SetNormalZoomProps = SetNormalZoomProps;

--- Changes the limit for the extended zoom.
--- 
--- The default value is set to 0.65.
--- 
--- @param _Limit number Zoom limit (between 0.1 and 0.87)
function SetExtendedZoomProps(_Limit)
end
API.SetExtendedZoomProps = SetExtendedZoomProps;

--- Focuses a camera on the players knight but does not lock the camera.
--- @param _PlayerID integer ID of player
--- @param _Rotation number Rotation angle
--- @param _ZoomFactor number Zoom factor
function FocusCameraOnKnight(_PlayerID, _Rotation, _ZoomFactor)
end
API.FocusCameraOnKnight = FocusCameraOnKnight;

--- Focuses a camera on an entity but does not lock the camera.
--- @param _Entity any
--- @param _Rotation number Rotation angle
--- @param _ZoomFactor number Zoom factor
function FocusCameraOnEntity(_Entity, _Rotation, _ZoomFactor)
end
API.FocusCameraOnEntity = FocusCameraOnEntity;



--- Scrolling at the edge of the screen is deactivated for a player.
---
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of Player
--- * `Position`: <b>integer</b> ID of Entity camera is fixed on
Report.BorderScrollLocked = anyInteger;

--- Scrolling at the edge of the screen is activated for a player.
---
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of Player
Report.BorderScrollReset = anyInteger;

--- Extended zoom distance is deactivated for the player.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of Player
Report.ExtendedZoomDeactivated = anyInteger;

--- Extended zoom distance is activated for the player.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of Player
Report.ExtendedZoomActivated = anyInteger;