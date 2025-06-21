--- Improves on interactive objects.
---
--- (Almost) All entities can be used as interactive object not just those
--- that are supposed to. An object is described by a table and (almost) all
--- keys are optional.
--- 
--- #### Console Commands:
--- There are special commands that can be entered into the console. Things in
--- brackets are optional.
--- * `enableobject object (state (player))`: An interactive object is made available
--- * `disableobject object (player)`:        An interactive object is made unavailable
--- * `initobject object `:                   An entity is turned into an interactive object



--- Adds an interaction to a object.
---
--- #### Fields `_Description`:
--- * `ScriptName`             - Scriptname of object
--- * `Texture`                - (Optional) table with coordinates
--- * `Title`                  - (Optional) Title of tooltip
--- * `Text`                   - (Optional) Text of tooltip
--- * `Distance`               - (Optional) Activation distance
--- * `Player`                 - (optional) List of players
--- * `Waittime`               - (optional) Activation waittime
--- * `Replacement`            - (Optional) Type to replace with
--- * `Costs`                  - (Optional) Activation cost table
--- * `Reward`                 - (Optional) Activation reward table
--- * `State`                  - (Optional) Actvation behavior
--- * `Condition`              - (Optional) Activation condition function
--- * `ConditionInfo`          - (Optional) Condition failure text
--- * `Action`                 - (Optional) Activation callback function
--- * `RewardResourceCartType` - (Optional) Type of reward resource cart
--- * `RewardGoldCartType`     - (Optional) Type of reward gold cart
--- * `CostResourceCartType`   - (Optional) Type of cost resource cart
--- * `CostGoldCartType`       - (Optional) Type of cost gold cart
---
--- #### Example:
--- ```lua
--- -- Create a simple object
--- SetupObject {
---     Name     = "hut",
---     Distance = 1500,
---     Reward   = {Goods.G_Gold, 1000},
--- };
--- ```
---
--- @param _Description table Object description
--- @return table? Data Object description
function SetupObject(_Description)
    return {};
end
API.CreateObject = SetupObject;

--- Removes the interaction from the object.
--- @param _ScriptName string Script name of entity
function DisposeObject(_ScriptName)
end
API.DisposeObject = DisposeObject;

--- Resets the interactive object. Needs to be activated separately.
--- @param _ScriptName string Script name of entity
function ResetObject(_ScriptName)
end
API.ResetObject = ResetObject;

--- Changes the name of the object in the 2D interface.
--- 
--- #### Exsample:
--- ```lua
--- InteractiveObjectAddCustomName("D_X_HabourCrane", {
---     de = "Hafenkran",
---     en = "Habour Crane"
--- });
--- ```
---
--- @param _Key string Key to add
--- @param _Text any   Text or replacement text
function InteractiveObjectAddCustomName(_Key, _Text)
end
API.InteractiveObjectSetQuestName = InteractiveObjectAddCustomName;

--- Removes the changes to the object name.
--- 
--- #### Exsampl:
--- ```lua
--- InteractiveObjectDeleteCustomName("D_X_HabourCrane");
--- ```
---
--- @param _Key string Key to remove
function InteractiveObjectDeleteCustomName(_Key)
end
API.InteractiveObjectUnsetQuestName = InteractiveObjectDeleteCustomName;

--- Allows or forbids to refill iron mines.
--- 
--- #### Requires Addon!
--- @param _PlayerID integer ID of player
--- @param _Allowed boolean  Activation is allowed
function AllowActivateIronMines(_PlayerID, _Allowed)
end
API.AllowActivateIronMines = AllowActivateIronMines;

--- Sets the required title to refill iron mines.
--- 
--- #### Requires Addon!
--- @param _Title integer  Knight title
function RequireTitleToRefilIronMines(_Title)
end
API.RequireTitleToRefilIronMines = RequireTitleToRefilIronMines;

--- Allows or forbids to refill stone mines.
--- 
--- #### Requires Addon!
--- @param _PlayerID integer ID of player
--- @param _Allowed boolean  Activation is allowed
function AllowActivateStoneMines(_PlayerID, _Allowed)
end
API.AllowActivateStoneMines = AllowActivateStoneMines;

--- Sets the required title to refill stone quarries.
--- 
--- #### Requires Addon!
--- @param _Title integer  Knight title
function RequireTitleToRefilStoneMines(_Title)
end
API.RequireTitleToRefilStoneMines = RequireTitleToRefilStoneMines;

--- Allows or forbids to refill cisterns.
--- 
--- #### Requires Addon!
--- @param _PlayerID integer ID of player
--- @param _Allowed boolean  Activation is allowed
function AllowActivateCisterns(_PlayerID, _Allowed)
end
API.AllowActivateCisterns = AllowActivateCisterns;

--- Sets the required title to refill cisterns.
--- 
--- #### Requires Addon!
--- @param _Title integer  Knight title
function RequireTitleToRefilCisterns(_Title)
end
API.RequireTitleToRefilCisterns = RequireTitleToRefilCisterns;

--- Allows or forbids to build tradeposts.
--- 
--- #### Requires Addon!
--- @param _PlayerID integer ID of player
--- @param _Allowed boolean  Activation is allowed
function AllowActivateTradepost(_PlayerID, _Allowed)
end
API.AllowActivateTradepost = AllowActivateTradepost;

--- Sets the required title to build tradeposts.
--- 
--- #### Requires Addon!
--- @param _Title integer  Knight title
function RequireTitleToBuildTradeposts(_Title)
end
API.RequireTitleToBuildTradeposts = RequireTitleToBuildTradeposts;

--- Activates an interactive object.
--- @param _ScriptName string Script name of entity
--- @param _State? integer    Interactable state
--- @param ... integer        List of player IDs
InteractiveObjectActivate = function(_ScriptName, _State, ...)
end
API.InteractiveObjectActivate = InteractiveObjectActivate;

--- Deactivates an interactive object.
--- @param _ScriptName string Script name of entity
--- @param ... integer        List of player IDs
InteractiveObjectDeactivate = function(_ScriptName, ...)
end
API.InteractiveObjectDeactivate = InteractiveObjectDeactivate;



--- The interaction with the object was successfull.
--- If the object has costs the activation concludes when the costs arrive.
--- 
--- #### Parameters:
--- * `ScriptName`: <b>string</b> Scriptname of entity
--- * `KnightID`:   <b>integer</b> ID of activating hero
--- * `PlayerID`:   <b>integer</b> ID of activating player
Report.ObjectInteraction = anyInteger;

--- The interaction is deleted from the object.
---
--- #### Parameters:
--- * `ScriptName`: <b>string</b> Scriptname of entity
Report.ObjectReset = anyInteger;

--- The state of an object has been reset.
---
--- #### Parameters:
--- * `ScriptName`: <b>string</b> Scriptname of entity
Report.ObjectDelete = anyInteger;

