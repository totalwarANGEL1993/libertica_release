--- Provides some diplomacy functions.
Lib.Diplomacy = Lib.Diplomacy or {};

--- Changes the diplomacy between the player and the listed players.
---
--- The current diplomatic relations will be saved, if no backup exists.
---
--- @param _PlayerID integer Player ID
--- @param _State integer State ID
--- @param ... integer List of player IDs
function SetDiplomacyStateForPlayer(_PlayerID, _State, ...)
end

--- Changes the diplomacy between all listed players.
---
--- The current diplomatic relations will be saved, if no backup exists.
---
--- @param _State integer State ID
--- @param ... integer List of player IDs
function SetDiplomacyStateForPlayers(_State, ...)
end

--- Saves the current diplomatic relations between all parties.
--- 
--- This is usually done automatically.
--- 
--- A backup is only created if no backup exists.
function SaveDiplomacyStates()
end

--- Resets the diplomacy states to the backup if it exist.
--- 
--- After that, the backup is invalidated.
function ResetDiplomacyStates()
end



--- The diplomatic relations between two players changed.
---
--- #### Parameters
--- * `PlayerID1` - Frist player ID
--- * `PlayerID2` - Second player ID
--- * `OldState`  - Previous diplomatic state
--- * `NewState`  - New diplomatic state
Report.DiplomacyChanged = anyInteger

