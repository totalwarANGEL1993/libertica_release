--- Creates an interactive construction site at the position.
--- 
--- The territorium where the construction site is located must be owned by
--- the player who will construct the building.
---
--- #### Parameter
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
--- #### Parameter
--- - `ScriptName` - Scriptname of site
--- * `PlayerID`   - ID of activating player
--- * `BuildingID` - ID of constructed building
Report.InteractiveSiteBuild = anyInteger;

