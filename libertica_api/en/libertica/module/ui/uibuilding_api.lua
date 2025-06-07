--- Allows adding additional buttons in building menus.
---
--- Since only 6 buttons can be used, the assignment of buttons 
--- is prioritized by binding type:
--- <ol>
--- <li>Buttons bound by script name</li>
--- <li>Buttons bound by entity type</li>
--- <li>Global (general) buttons</li>
--- </ol>
--- <p>
--- If you add more than 6 buttons to a building, 
--- they will be assigned in this order until all 6 slots are filled.




--- Creates a building button at the menu position.
--- @param _X integer X position for button
--- @param _Y integer X position for button
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonAtPosition(_X, _Y, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonAtPosition = AddBuildingButtonAtPosition;

--- Creates a building button.
---
--- #### Example:
--- A simple button.
--- ```lua
--- SpecialButtonID = AddBuildingButton(
---     -- Aktion
---     function(_WidgetID, _BuildingID)
---         GUI.AddNote("Something happens!");
---     end,
---     -- Tooltip
---     function(_WidgetID, _BuildingID)
---         -- Es MUSS ein Kostentooltip verwendet werden.
---         SetTooltipCosts("Description", "This is the description!");
---     end,
---     -- Update
---     function(_WidgetID, _BuildingID)
---         -- Disable for when under construction
---         if Logic.IsConstructionComplete(_BuildingID) == 0 then
---             XGUIEng.ShowWidget(_WidgetID, 0);
---             return;
---         end
---         -- Disable for when being upgraded
---         if Logic.IsBuildingBeingUpgraded(_BuildingID) then
---             XGUIEng.DisableButton(_WidgetID, 1);
---         end
---         SetIcon(_WidgetID, {1, 1});
---     end
--- );
--- ```
---
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButton(_Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButton = AddBuildingButton;

--- Creates a building button at the menu position for a entity type.
--- @param _Type integer Type of entity
--- @param _X integer X position for button
--- @param _Y integer Y position for button
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonByTypeAtPosition(_Type, _X, _Y, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonByTypeAtPosition = AddBuildingButtonByTypeAtPosition;

--- Creates a building button for a entity type.
--- @param _Type integer Type of entity
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonByType(_Type, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonByType = AddBuildingButtonByType;

--- Creates a building button at the menu position for a specific entity.
--- @param _ScriptName string Script name of entity
--- @param _X integer X position for button
--- @param _Y integer X position for button
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonByEntityAtPosition(_ScriptName, _X, _Y, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonByEntityAtPosition = AddBuildingButtonByEntityAtPosition;

--- Creates a building button for a specific entity.
--- @param _ScriptName string Script name of entity
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonByEntity(_ScriptName, _Action, _Tooltip, _Update)
    return 0;
end
API.AddBuildingButtonByEntity = AddBuildingButtonByEntity;

--- Removes a building button.
--- @param _ID integer ID of button
function DropBuildingButton(_ID)
end
API.DropBuildingButton = DropBuildingButton;

--- Removes a building button for the entity type.
--- @param _Type integer Type of entity
--- @param _ID integer ID of button
function DropBuildingButtonFromType(_Type, _ID)
end
API.DropBuildingButtonFromType = DropBuildingButtonFromType;

--- Removes a building button for a specific entity.
--- @param _ScriptName string Script name of entity
--- @param _ID integer ID of button
function DropBuildingButtonFromEntity(_ScriptName, _ID)
end
API.DropBuildingButtonFromEntity = DropBuildingButtonFromEntity;

--- Activates the downgrade option for city and gatherer buildings.
function ActivateDowngradeBuilding()
end
API.ActivateDowngradeBuilding = ActivateDowngradeBuilding;

--- Dectivates the downgrade option for city and gatherer buildings.
function DeactivateDowngradeBuilding()
end
API.DeactivateDowngradeBuilding = DeactivateDowngradeBuilding;

--- Sets the costs for downgrading a building for all players.
--- @param _MoneyCost integer Downgrade costs
function SetDowngradeBuildingCost(_MoneyCost)
end
API.SetDowngradeCosts = SetDowngradeBuildingCost;
API.SetDowngradeBuildingCost = SetDowngradeBuildingCost;

--- Activates the reservation of goods direcrly at the building.
--- <p>
--- <b>Attention</b>: Goods can not be locked for a single building. Instead
--- they will be locked in all buildings. This is virtually the same as the
--- production menu can do!
function ActivateSingleReserveBuilding()
end
API.ActivateSingleReserveBuilding = ActivateSingleReserveBuilding;

--- Deactivates the reservation of goods direcrly at the building.
function DeactivateSingleReserveBuilding()
end
API.DeactivateSingleReserveBuilding = DeactivateSingleReserveBuilding;

--- Activates the pausing of individual buildings.
function ActivateSingleStopBuilding()
end
API.ActivateSingleStopBuilding = ActivateSingleStopBuilding;

--- Deactivates the pausing of individual buildings.
function DeactivateSingleStopBuilding()
end
API.DeactivateSingleStopBuilding = DeactivateSingleStopBuilding;



--- The player has downgraded a building.
--- 
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of building
Report.DowngradeBuilding = anyInteger;

--- The player has locked a good type.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of player
--- * `GoodType`: <b>integer</b> Type of good
Report.LockGoodType = anyInteger;

--- The player has unlocked a good type.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of player
--- * `GoodType`: <b>integer</b> Type of good
Report.UnlockGoodType = anyInteger;

--- The player has resumed the production in a building.
--- 
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of building
Report.ResumeBuilding = anyInteger;

--- The player has paused the production in a building.
--- 
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of building
Report.YieldBuilding = anyInteger;

--- The player clicked the cancel upgrade button.
--- 
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of building
--- * `PlayerID`: <b>integer</b> ID of owner
Report.CancelUpgradeClicked = anyInteger;

--- The player clicked the start upgrade button.
--- 
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of building
--- * `PlayerID`: <b>integer</b> ID of owner
Report.StartUpgradeClicked = anyInteger;

--- The player clicked the start festival button.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of player
--- * `Type`:     <b>integer</b> Type of festival
Report.FestivalClicked = anyInteger;

--- The player clicked the start sermon button.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID of player
Report.SermonClicked = anyInteger;

--- The player clicked the start theatre play button.
--- 
--- #### Parameters:
--- * `EntityID`: <b>integer</b> ID of building
--- * `PlayerID`: <b>integer</b> ID of owner
Report.TheatrePlayClicked = anyInteger;

