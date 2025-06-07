--- Adds different effects for the user interface.



--- Shows a black background behind the interface and over the game world.
--- @param _PlayerID integer ID of player
function ActivateColoredScreen(_PlayerID, _Red, _Green, _Blue, _Alpha)
end
API.ActivateColoredScreen = ActivateColoredScreen;

--- Hides the black screen.
--- @param _PlayerID integer ID of player
function DeactivateColoredScreen(_PlayerID)
end
API.DeactivateColoredScreen = DeactivateColoredScreen;

--- Shows a full screen graphic over the game world and below the interface.
---
--- The graphic must be supplied in 16:9 ratio. For 4:3 resolutions the graphic
--- is centered left and right to fit the format.
---
--- @param _PlayerID integer ID of player
--- @param _Image string     Path to graphic
--- @param _Red integer?     (Optional) Red value (default: 255)
--- @param _Green integer?   (Optional) Green value (default: 255)
--- @param _Blue integer?    (Optional) Blue value (default: 255)
--- @param _Alpha integer?   (Optional) Alpha value (default: 255)
function ActivateImageScreen(_PlayerID, _Image, _Red, _Green, _Blue, _Alpha)
end
API.ActivateImageScreen = ActivateImageScreen;

--- Hides the full screen picture.
--- @param _PlayerID integer ID of player
function DeactivateImageScreen(_PlayerID)
end
API.DeactivateImageScreen = DeactivateImageScreen;

--- Shows the normal game interface.
--- @param _PlayerID integer ID of player
function ActivateNormalInterface(_PlayerID)
end
API.ActivateNormalInterface = ActivateNormalInterface;

--- Hides the normal game interface.
--- @param _PlayerID integer ID of player
function DeactivateNormalInterface(_PlayerID)
end
API.DeactivateNormalInterface = DeactivateNormalInterface;



--- The normal interface is shown for the player.
---
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of receiving Player
Report.GameInterfaceShown = anyInteger;

--- The normal interface is hidden from the player.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of receiving Player
Report.GameInterfaceHidden = anyInteger;

--- The fullscreen image background is shown for the player.
---
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of receiving Player
Report.ImageScreenShown = anyInteger;

--- The fullscreen image background is hidden from the player.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of receiving Player
Report.ImageScreenHidden = anyInteger;

