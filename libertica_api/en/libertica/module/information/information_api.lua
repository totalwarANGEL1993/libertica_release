--- This module manages the cinematic events.
--- 
--- Cinematic events are used by briefings, cutscenes and similar things to
--- synchronize them. Onyl use this module if you are implementing a system
--- similar to briefings that need synchronizing.



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
--- Returns the state of the cinema event.
---
--- @param _Identifier any Identifier or ID
--- @param _PlayerID integer ID of player
--- @return integer State Zustand des Kinoevent
---
function GetCinematicEvent(_Identifier, _PlayerID)
    return 0;
end
API.GetCinematicEvent = GetCinematicEvent;

---
--- Checks if a cinema event is active for the player.
---
--- @param _PlayerID integer ID of player
--- @return boolean State Cinema event is active
---
function IsCinematicEventActive(_PlayerID)
    return false;
end
API.IsCinematicEventActive = IsCinematicEventActive;



--- A cinematic event has started for the player.
---
--- #### Parameter
--- * `EventID`  - ID of cinematic event
--- * `PlayerID` - ID of receiving Player
Report.CinematicActivated = anyInteger;

--- A cinematic event has concluded for the player.
--- 
--- #### Parameter
--- * `EventID`  - ID of cinematic event
--- * `PlayerID` - ID of receiving Player
Report.CinematicConcluded = anyInteger;

