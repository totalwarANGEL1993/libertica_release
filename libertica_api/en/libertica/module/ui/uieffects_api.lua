Lib.UIEffects = Lib.UIEffects or {};



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

--- Propagates the start of a cinema event.
--- @param _Name     string  Bezeichner
--- @param _PlayerID integer ID of player
function StartCinematicEvent(_Name, _PlayerID)
end
API.StartCinematicEvent = StartCinematicEvent;

--- Propagates the end of a cinema event.
--- @param _Name     string  Bezeichner
--- @param _PlayerID integer ID of player
function FinishCinematicEvent(_Name, _PlayerID)
end
API.FinishCinematicEvent = FinishCinematicEvent;

---
-- Gibt den Zustand des Kinoevent zurück.
--
-- @param _Identifier            Bezeichner oder ID
-- @param[type=number] _PlayerID ID des Spielers
-- @return[type=number] Zustand des Kinoevent
-- @within Anwenderfunktionen
--
function GetCinematicEvent(_Identifier, _PlayerID)
    return 0;
end
API.GetCinematicEvent = GetCinematicEvent;

---
-- Prüft ob gerade ein Kinoevent für den Spieler aktiv ist.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @return[type=boolean] Kinoevent ist aktiv
-- @within Anwenderfunktionen
--
function IsCinematicEventActive(_PlayerID)
    return false;
end
API.IsCinematicEventActive = IsCinematicEventActive;

--- Displays a text byte by byte.
---
--- If used at game start the text starts, after the map is loaded. If another
--- cinema event is running the typewriter waits for completion.
---
--- Controll symbols like {cr} are evaluated as one token and are handled as
--- an atomic token and are displayed immedaitly. More than 1 space in a row
--- is atomaticaly trunk to 1 space (by the game engine).
---
--- #### Fields of table
--- * Text         - Text to display
--- * Name         - (Optional) Name for event
--- * PlayerID     - (Optional) Player text is shown
--- * Callback     - (Optional) Callback function
--- * TargetEntity - (Optional) Entity camera is focused on
--- * CharSpeed    - (Optional) Factor of typing speed (default: 1.0)
--- * Waittime     - (Optional) Initial waittime before typing
--- * Opacity      - (Optional) Opacity of background (default: 1.0)
--- * Color        - (Optional) Background color (default: {R= 0, G= 0, B= 0})
--- * Image        - (Optional) Background image (needs to be 16:9 ratio)
---
--- #### Examples
--- ```lua
--- local EventName = StartTypewriter {
---     PlayerID = 1,
---     Text     = "Lorem ipsum dolor sit amet, consetetur "..
---                "sadipscing elitr, sed diam nonumy eirmod "..
---                "tempor invidunt ut labore et dolore magna "..
---                "aliquyam erat, sed diam voluptua.",
---     Callback = function(_Data)
---     end
--- };
--- ```
---
--- @param _Data table Data table
--- @return string? EventName Name of event
function StartTypewriter(_Data)
    return "";
end
API.StartTypewriter = StartTypewriter;

