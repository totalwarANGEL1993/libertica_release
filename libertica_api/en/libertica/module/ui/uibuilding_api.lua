--- Allows to place up to 6 additional buttons in building menus.
---
--- #### Reports
--- * `Report.CancelUpgradeClicked` - An upgrade has been canceled
--- * `Report.StartUpgradeClicked` - An upgrade has been started
--- * `Report.FestivalClicked` - The festival button has been clicked
--- * `Report.SermonClicked` - The sermon button has been clicked
--- * `Report.TheatrePlayClicked` - The theatre play button has been clicked
---
Lib.UIBuilding = Lib.UIBuilding or {};



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
--- #### Examples
--- ```lua
--- -- Example #1: A simple button
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



--- The player clicked the cancel upgrade button.
--- 
--- #### Parameter
--- * `EntityID` - ID of building
--- * `PlayerID` - ID of owner
Report.CancelUpgradeClicked = anyInteger;

--- The player clicked the start upgrade button.
--- 
--- #### Parameter
--- * `EntityID` - ID of building
--- * `PlayerID` - ID of owner
Report.StartUpgradeClicked = anyInteger;

--- The player clicked the start festival button.
--- 
--- #### Parameter
--- * `PlayerID` - ID of player
--- * `Type`     - Type of festival
Report.FestivalClicked = anyInteger;

--- The player clicked the start sermon button.
--- 
--- #### Parameter
--- * `PlayerID` - ID of player
Report.SermonClicked = anyInteger;

--- The player clicked the start theatre play button.
--- 
--- #### Parameter
--- * `EntityID` - ID of building
--- * `PlayerID` - ID of owner
Report.TheatrePlayClicked = anyInteger;

