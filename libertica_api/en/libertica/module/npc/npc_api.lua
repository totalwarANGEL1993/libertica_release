--- Allows to use settlers somewhat like interactive objects.
---
--- NPCs are characters who are activated by the player with a hero hence
--- talk to them. Much like interactive objects an action can be called
--- and some other adjustments can be made.
Lib.NPC = Lib.NPC or {};



--- Adds an NPC to an entity.
---
--- #### Fields of table
--- * Name              Script name of entity (mandatory)
--- * Callback          Function called at activation
--- * Condition         Condition checked before activation
--- * Type              Type of NPC (1, 2, 3, 4)
--- * Player            Players allowed to talk
--- * WrongPlayerAction Message for wrong players
--- * Hero              Name of specific hero
--- * WrongHeroAction   Message for wrong heroes
--- * Active            NPC is active
---
--- #### Examples
--- ```lua
--- -- Example #1: Creates a simple NPC
--- MyNpc = NpcCompose {
---     Name     = "HansWurst",
---     Callback = function(_Data)
---         local HeroID = CONST_LAST_HERO_INTERACTED;
---         local NpcID = GetID(_Data.Name);
---     end
--- }
--- ```
---
--- ```lua
--- -- Example #2: Creates a NPC with conditions
--- MyNpc = NpcCompose {
---     Name      = "HansWurst",
---     Condition = function(_Data)
---         local NpcID = GetID(_Data.Name);
---         -- prüfe irgend was
---         return MyConditon == true;
---     end
---     Callback  = function(_Data)
---         local HeroID = CONST_LAST_HERO_INTERACTED;
---         local NpcID = GetID(_Data.Name);
---     end
--- }
---```
---
--- ```lua
--- -- Example #3: Limit players for activation
--- MyNpc = NpcCompose {
---     Name              = "HansWurst",
---     Player            = {1, 2},
---     WrongPlayerAction = function(_Data)
---         AddNote("I will not talk to you!");
---     end,
---     Callback          = function(_Data)
---         local HeroID = CONST_LAST_HERO_INTERACTED;
---         local NpcID = GetID(_Data.Name);
---     end
--- }
---```
---
--- @param _Data table NPC data
--- @return table NPC NPC data
function NpcCompose(_Data)
    return {};
end
API.NpcCompose = NpcCompose;

--- Removes the NPC but does not delete the entity.
--- @param _Data table NPC data
function NpcDispose(_Data)
end
API.NpcDispose = NpcDispose;

--- Updates the NPC with the data table.
---
--- #### Fields of table
--- * Name              Script name of entity (mandatory)
--- * Callback          Function called at activation
--- * Condition         Condition checked before activation
--- * Type              Type of NPC (1, 2, 3, 4)
--- * Player            Players allowed to talk
--- * WrongPlayerAction Message for wrong players
--- * Hero              Name of specific hero
--- * WrongHeroAction   Message for wrong heroes
--- * Active            NPC is active
---
--- #### Examples
--- ```lua
--- -- Example #1: Reset NPC and change action
--- MyNpc.Active = true;
--- MyNpc.TalkedTo = 0;
--- MyNpc.Callback = function(_Data)
---     -- mach was hier
--- end;
--- NpcUpdate(MyNpc);
--- ```
---
--- @param _Data table NPC data
function NpcUpdate(_Data)
end
API.NpcUpdate = NpcUpdate;

--- Checks if the NPC is active.
--- @param _Data table NPC data
--- @return boolean Active NPC is active
function NpcIsActive(_Data)
    return false;
end
API.NpcIsActive = NpcIsActive;

--- Returns if an NPC has talked.
--- @param _Data table NPC data
--- @param _Hero string Scriptname of hero
--- @param _PlayerID integer ID of player
--- @return boolean HasTalked NPC has talked
function NpcTalkedTo(_Data, _Hero, _PlayerID)
    return true;
end
API.NpcTalkedTo = NpcTalkedTo;



--- Someone talks to an NPC
---
--- #### Parameters
--- * `NpcEntityID`  - ID of npc
--- * `HeroEntityID` - ID of hero
Report.NpcInteraction = anyInteger;

