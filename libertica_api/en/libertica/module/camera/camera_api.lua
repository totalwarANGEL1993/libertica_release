--- 
Lib.Camera = Lib.Camera or {};

local anyInteger = math.random(1, 2);

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

--- Allows/Prohibits the extended zoom for one or for all players.
--- @param _Flag boolean Extended zoom allowed
--- @param _PlayerID integer? ID of player
function AllowExtendedZoom(_Flag, _PlayerID)
end
API.AllowExtendedZoom = AllowExtendedZoom;

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
--- #### Parameter
--- - `PlayerID` - ID of Player
--- - `Position` - ID of Entity camera is fixed on
Report.BorderScrollLocked = anyInteger;

--- Scrolling at the edge of the screen is activated for a player.
---
--- #### Parameter
--- - `PlayerID` - ID of Player
Report.BorderScrollReset = anyInteger;

--- Extended zoom distance is deactivated for the player.
--- 
--- #### Parameter
--- - `PlayerID` - ID of Player
Report.ExtendedZoomDeactivated = anyInteger;

--- Extended zoom distance is activated for the player.
--- 
--- #### Parameter
--- - `PlayerID` - ID of Player
Report.ExtendedZoomActivated = anyInteger;