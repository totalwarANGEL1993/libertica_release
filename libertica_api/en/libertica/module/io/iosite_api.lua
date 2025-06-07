--- Allows to create interactable resources.



--- Creates an interactive construction site at the position.
--- 
--- The territorium where the construction site is located must be owned by
--- the player who will construct the building.
---
--- #### Fields `_Data`:
--- * `ScriptName`            - Scriptname of location
--- * `PlayerID`              - Constructing player
--- * `Type`                  - Type of building
--- * `Title`                 - (Optional) Tooltip titel
--- * `Text`                  - (Optional) Tooltip text
--- * `Costs`                 - (Optional) Activation costs
--- * `Icon`                  - (Optional) Icon graphics
--- * `Condition`             - (Optional) Activation condition
--- * `Action`                - (Optional) Activation action
--- 
--- @param _Data table Konfiguration
function CreateIOBuildingSite(_Data)
end
API.CreateIOBuildingSite = CreateIOBuildingSite;



--- A construction site was finished.
---
--- #### Parameters:
--- - `ScriptName`: <b>string</b> Scriptname of site
--- * `PlayerID`:   <b>integer</b> ID of activating player
--- * `BuildingID`: <b>integer</b> ID of constructed building
Report.InteractiveSiteBuild = anyInteger;

