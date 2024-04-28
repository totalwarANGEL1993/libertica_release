--- Allows to create constructable resource sources.
---
--- #### Reports
--- * `Report.InteractiveMineErected` - A resource source was constructed.
---
Lib.IOMine = Lib.IOMine or {};



--- Creates a buried iron mine.
---
--- #### Parameter
--- * `Scriptname`            - Scriptname of position
--- * `Title`                 - (Optional) Tooltip title
--- * `Text`                  - (Optional) Tooltip text
--- * `Costs`                 - (Optional) Construction costs
--- * `ResourceAmount`        - (Optional) Amount of resources
--- * `RefillAmount`          - (Optional) Refill amount
--- * `ConstructionCondition` - (Optional) Condition function
--- * `ConditionInfo`         - (Optional) Info condition not fulfilled
--- * `ConstructionAction`    - (Optional) Action after construction
---
--- @param _Data table Mine configuration
function CreateIOIronMine(_Data)
end
API.CreateIOIronMine = CreateIOIronMine;

--- Creates a buried stone mine.
---
--- #### Parameter
--- * `Scriptname`            - Scriptname of position
--- * `Title`                 - (Optional) Tooltip title
--- * `Text`                  - (Optional) Tooltip text
--- * `Costs`                 - (Optional) Construction costs
--- * `ResourceAmount`        - (Optional) Amount of resources
--- * `RefillAmount`          - (Optional) Refill amount
--- * `ConstructionCondition` - (Optional) Condition function
--- * `ConditionInfo`         - (Optional) Info condition not fulfilled
--- * `ConstructionAction`    - (Optional) Action after construction
---
--- @param _Data table Mine configuration
function CreateIOStoneMine(_Data)
end
API.CreateIOStoneMine = CreateIOStoneMine;



--- A resource source was constructed.
---
--- #### Parameter
--- - `ScriptName` - Scriptname of mine
--- * `KnightID`   - ID of activating hero
--- * `PlayerID`   - ID of activating player
Report.InteractiveMineErected = anyInteger;

