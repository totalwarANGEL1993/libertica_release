--- Behavior of the core module.

--- Enables debug mode.
---
--- @param _Assertions boolean Enable assertions
--- @param _CheckAtRun boolean Check quests at runtime
--- @param _DevelopingCheats boolean Enable cheats
--- @param _DevelopingShell boolean Enable input
--- @param _TraceQuests boolean Enable quest tracking
---
function Reward_DEBUG(_Assertions, _CheckAtRun, _DevelopingCheats, _DevelopingShell, _TraceQuests)
end

---
--- An interactive object must be used.
---
--- @param _ScriptName string Script name of the interactive object
---
function Goal_ActivateObject(_ScriptName)
end

---
--- A player must send resources or goods.
---
--- Typically sent to the contractor. However, it is possible to send to
--- another target player. If a cart is captured, it must be sent again.
--- Optionally, the player may be allowed to recapture the cart.
---
--- @param _GoodType       string Type of good
--- @param _GoodAmount     integer Amount of goods
--- @param _OtherTarget?   integer Another target as contractor
--- @param _IgnoreCapture? boolean Cart can be recaptured
---
function Goal_Deliver(_GoodType, _GoodAmount, _OtherTarget, _IgnoreCapture)
end

---
--- A specific diplomatic status must be reached with another faction.
---
--- The status can be an improvement or a deterioration from the current status.
---
--- @param _PlayerID integer Faction to be discovered
--- @param _Relation string Greater-Less relation
--- @param _State    string Diplomatic status
---
function Goal_Diplomacy(_PlayerID, _Relation, _State)
end

---
--- The player's home territory must be discovered.
---
--- The home territory is always where the faction's castle or warehouse is located.
---
--- @param _PlayerID integer ID of the faction to be discovered
---
function Goal_DiscoverPlayer(_PlayerID)
end

---
--- A territory must be entered for the first time by the contractor.
---
--- If a player's units have been on the territory before, it is already discovered, and the goal is immediately fulfilled.
---
--- @param _Territory any Name or ID of the territory
---
function Goal_DiscoverTerritory(_Territory)
end

---
--- Another faction must be defeated.
---
--- The faction is considered defeated when a main building (castle, church, warehouse) has been destroyed.
--- 
--- <b>Attention:</b> For bandits, this behavior is not very useful as they are not destroyed by destroying their main tent. In this case, Goal_DestroyAllPlayerUnits is more suitable.
---
--- @param _PlayerID integer ID of the player
---
function Goal_DestroyPlayer(_PlayerID)
end

---
--- Information must be stolen from the castle.
---
--- The player must send a thief to steal information from the castle. 
---
--- <b>Attention:</b> This is only possible with enemies!
---
--- @param _PlayerID integer ID of the faction
---
function Goal_StealInformation(_PlayerID)
end

---
--- All units of the player must be destroyed.
---
--- <b>Attention:</b> For normal factions with a village or city, Goal_DestroyPlayer is better suited!
---
--- @param _PlayerID integer ID of the player
---
function Goal_DestroyAllPlayerUnits(_PlayerID)
end

---
--- A named entity must be destroyed.
---
--- An entity is considered destroyed if it no longer exists or if its entity ID or owner changes during the quest runtime.
---
--- <b>Attention:</b> Heroes cannot be directly destroyed. For them, it is sufficient if they "retreat to the castle."
---
--- @param _ScriptName string Script name of the target
---
function Goal_DestroyScriptEntity(_ScriptName)
end

---
--- A number of entities of a type must be destroyed.
---
--- <b>Attention:</b> If predators are to be destroyed, player 0 must be specified as the owner.
---
--- @param _EntityType string Type of the entity
--- @param _Amount     integer Quantity of entities of the type
--- @param _PlayerID   integer Owner of the entity
---
function Goal_DestroyType(_EntityType, _Amount, _PlayerID)
end

---
--- A distance between two entities must be reached.
---
--- Depending on the specified relation, the distance must be either less than or greater than, to win the quest.
---
--- @param _ScriptName1  string First entity
--- @param _ScriptName2  string Second entity
--- @param _Relation     string Relation
--- @param _Distance     integer Distance
---
function Goal_EntityDistance(_ScriptName1, _ScriptName2, _Relation, _Distance)
end

---
--- The primary knight of the specified player must approach the target.
---
--- The distance that must be undershot can be freely determined. If the distance is left at 0, it will automatically be set to 2500.
---
--- @param _ScriptName string Script name of the target
--- @param _Disctande  integer (optional) Distance to the target
---
function Goal_KnightDistance(_ScriptName, _Disctande)
end

---
--- A certain number of units of a category must be on the territory.
---
--- Either fewer than the specified quantity on the territory can be demanded (e.g. "<"" 1 for 0) or at least that many units (e.g. ">=" 5 for at least 5).
---
--- @param _Territory  integer TerritoryID or TerritoryName
--- @param _PlayerID   integer PlayerID of the units
--- @param _Category   string Category of the units
--- @param _Relation   string Quantity relation (< or >=)
--- @param _Amount     integer Quantity of units
---
function Goal_UnitsOnTerritory(_Territory, _PlayerID, _Category, _Relation, _Amount)
end

---
--- Activates a specified buff for a player.
---
--- <u>Buffs "Rise of a Kingdom"</u>
--- <li>Buff_Spice: Salt</li>
--- <li>Buff_Colour: Colors</li>
--- <li>Buff_Entertainers: Hire entertainers</li>
--- <li>Buff_FoodDiversity: Diverse food</li>
--- <li>Buff_ClothesDiversity: Diverse clothing</li>
--- <li>Buff_HygieneDiversity: Diverse hygiene</li>
--- <li>Buff_EntertainmentDiversity: Diverse entertainment</li>
--- <li>Buff_Sermon: Deliver a sermon</li>
--- <li>Buff_Festival: Organize a festival</li>
--- <li>Buff_ExtraPayment: Pay bonus salary</li>
--- <li>Buff_HighTaxes: Demand high taxes</li>
--- <li>Buff_NoPayment: Eliminate salary</li>
--- <li>Buff_NoTaxes: Abolish taxes</li>
--- <br/>
--- <u>Buffs "Eastern Realm"</u>
--- <li>Buff_Gems: Gems</li>
--- <li>Buff_MusicalInstrument: Musical instruments</li>
--- <li>Buff_Olibanum: Incense</li>
---
--- @param _PlayerID integer The player who needs to activate the buff
--- @param _Buff     string The buff to activate
---
function Goal_ActivateBuff(_PlayerID, _Buff)
end

---
--- Connects two points on the game world with a road.
---
--- @param _Position1 any First endpoint of the road
--- @param _Position2 any Second endpoint of the road
--- @param _OnlyRoads boolean Whether to accept only roads
---
function Goal_BuildRoad(_Position1, _Position2, _OnlyRoads)
end

---
--- Builds a wall to restrict the movement of a player.
--- Restriction means the specified player cannot move from point A to point B because there's a wall in the way.
--- The points can be freely chosen. In most cases, specifying marketplaces is sufficient.
--- Example: Player 3 is the enemy of Player 1 but is friendly with Player 2.
--- If Player 3 cannot move between the marketplaces of Player 1 and 2 because a wall is in the way, the goal is achieved.
--- <b>Caution:</b> During monsoon, this goal may mistakenly be considered achieved if the path is blocked by water!
---
--- @param _PlayerID  integer The PlayerID to be blocked
--- @param _Position1 any First position
--- @param _Position2 any Second position
---
function Goal_BuildWall(_PlayerID, _Position1, _Position2)
end

---
--- Requires the conquer of a specific territory by the contractor.
---
--- @param _Territory integer Territory ID or name
---
function Goal_Claim(_Territory)
end

---
--- Requires the contractor to possess a certain number of territories. The 
--- player's home territory is included!
---
--- @param _Amount integer Number of territories
---
function Goal_ClaimXTerritories(_Amount)
end

---
--- Requires the contractor to create a certain number of entities of a 
--- specific type on the territory. This behavior is suitable for tasks like 
--- "Build X grain farms on Territory >".
---
--- @param _Type      string Type of the entity
--- @param _Amount    integer Number of entities
--- @param _Territory any Territory
---
function Goal_Create(_Type, _Amount, _Territory)
end

---
--- Requires the contractor to produce a certain amount of resources.
---
--- @param _Type   string Type of the resource
--- @param _Amount integer Amount of resources
---
function Goal_Produce(_Type, _Amount)
end

---
--- Requires the player to achieve a specific amount of a good.
---
--- @param _Type     string Type of the good
--- @param _Amount   integer Amount of the good
--- @param _Relation string Quantity relation
---
function Goal_GoodAmount(_Type, _Amount, _Relation)
end

---
--- Ensures the settlers of the player do not go on strike due to a specific 
--- need.
---
--- <u>Needs</u>
--- <ul>
--- <li>Clothes: Clothing</li>
--- <li>Entertainment: Entertainment</li>
--- <li>Nutrition: Food</li>
--- <li>Hygiene: Hygiene</li>
--- <li>Medicine: Medicine</li>
--- </ul>
---
--- @param _PlayerID integer ID of the player
--- @param _Need     string Need
---
function Goal_SatisfyNeed(_PlayerID, _Need)
end

---
--- Requires the specified player to have a certain number of settlers in 
--- the city.
---
--- @param _Amount   integer Number of settlers
--- @param _PlayerID integer ID of the player (Default: 1)
---
function Goal_SettlersNumber(_Amount, _PlayerID)
end

---
--- Requires the contractor to have a certain number of spouses in the city.
---
--- @param _Amount integer Number of spouses
---
function Goal_Spouses(_Amount)
end

---
--- Requires a player to have a certain number of soldiers.
---
--- <u>Relations</u>
--- <ul>
--- <li>>= - Number as minimum amount</li>
--- <li>< - Less than the number</li>
--- </ul>
---
--- This behavior can be used to count the number of enemy soldiers or the 
--- number of soldiers of the player.
---
--- @param _PlayerID integer ID of the player
--- @param _Relation string Quantity relation
--- @param _Amount   integer Number of soldiers
---
function Goal_SoldierCount(_PlayerID, _Relation, _Amount)
end

---
--- Requires the contractor to achieve at least a specific title.
---
--- The following titles can be used:
--- <table border="1">
--- <tr>
--- <td><b>Title</b></td>
--- <td><b>Translation</b></td>
--- </tr>
--- <tr>
--- <td>Knight</td>
--- <td>Knight</td>
--- </tr>
--- <tr>
--- <td>Mayor</td>
--- <td>Mayor</td>
--- </tr>
--- <tr>
--- <td>Baron</td>
--- <td>Baron</td>
--- </tr>
--- <tr>
--- <td>Earl</td>
--- <td>Earl</td>
--- </tr>
--- <tr>
--- <td>Marquees</td>
--- <td>Marquees</td>
--- </tr>
--- <tr>
--- <td>Duke</td>
--- <td>Duke</td>
--- </tr>
--- </tr>
--- <tr>
--- <td>Archduke</td>
--- <td>Archduke</td>
--- </tr>
--- <table>
---
--- @param _Title string Title to achieve
---
function Goal_KnightTitle(_Title)
end

---
--- Requires the specified player to celebrate at least a certain number of 
--- festivals.
---
--- A festival is considered achieved once the mead barrels appear on the 
--- market. These mead barrels only appear in the normal course of the game 
--- through a festival!
---
--- <b>Attention</b>: If a player possesses mead barrels for another reason, 
--- this behavior will no longer work correctly!
---
--- @param _PlayerID integer ID of the player
--- @param _Amount   integer Number of festivals
---
function Goal_Festivals(_PlayerID, _Amount)
end

---
--- Requires the contractor to capture a unit.
---
--- @param _ScriptName string Target
---
function Goal_Capture(_ScriptName)
end

---
--- Requires the contractor to capture a number of units of a certain type 
--- from a player.
---
--- @param _Type      string Type to capture
--- @param _Amount    integer Number of units
--- @param _PlayerID  integer Owner of the units
---
function Goal_CaptureType(_Type, _Amount, _PlayerID)
end

---
--- Requires the contractor to protect the specified entity.
---
--- If a cart is destroyed or brought into an enemy warehouse/castle, the 
--- goal fails.
---
--- @param _ScriptName string Entity to protect
---
function Goal_Protect(_ScriptName)
end

---
--- Requires the contractor to refill a mine with a geologist.
---
--- <b>Caution</b>: This behavior is only available in "Eastern Realm".
---
--- @param _ScriptName string Mine script name
---
function Goal_Refill(_ScriptName)
end

---
--- Requires a specific amount of resources to be reached in a mine.
---
--- This behavior is especially suitable for use as a hidden quest to trigger 
--- a reaction, for example, when a mine is empty.
---
--- <u>Relations</u>
--- <ul>
--- <li>> - More than quantity</li>
--- <li>< - Less than quantity</li>
--- </ul>
---
--- @param _ScriptName string Mine script name
--- @param _Relation   string Quantity relation
--- @param _Amount     integer Amount of resources
---
function Goal_ResourceAmount(_ScriptName, _Relation, _Amount)
end

---
--- Immediately fails the quest.
---
function Goal_InstantFailure()
end

---
--- Immediately completes the quest.
---
function Goal_InstantSuccess()
end

---
--- The quest state never changes.
---
--- If there is a time limit on the quest, this behavior will not fail but 
--- will be automatically completed.
---
function Goal_NoChange()
end

---
--- Executes a function in the script as a goal.
---
--- The function must return either true, false, or nothing.
--- <ul>
--- <li>true: Successfully completed</li>
--- <li>false: Failure</li>
--- <li>nothing: State undefined</li>
--- </ul>
---
--- Instead of a string, a function reference can be passed when used in 
--- the script. In this case, all other parameters are passed directly to 
--- the function.
---
--- @param _FunctionName any Name of the function
--- @param ... any Optional parameters
---
function Goal_MapScriptFunction(_FunctionName, ...)
end

---
--- A custom variable must have a specific value.
---
--- Custom variables can only contain numbers. Before a variable can be 
--- queried in a goal, it must have been initialized with 
--- Reprisal_CustomVariables or Reward_CutsomVariables.
---
--- <p>Comparison operators</p>
--- <ul>
--- <li>== - Values must be equal</li>
--- <li>~= - Values must be unequal</li>
--- <li>> - Variable value greater than comparison value</li>
--- <li>>= - Variable value greater than or equal to comparison value</li>
--- <li>< - Variable value less than comparison value</li>
--- <li><= - Variable value less than or equal to comparison value</li>
--- </ul>
---
--- @param _Name     string Name of the variable
--- @param _Relation string Comparison operator
--- @param _Value    any Value or another custom variable with value
---
function Goal_CustomVariables(_Name, _Relation, _Value)
end

---
--- Deactivates an interactive object.
---
--- @param _ScriptName string Script name of the interactive object
---
function Reprisal_ObjectDeactivate(_ScriptName)
end

---
--- Activates an interactive object.
---
--- The status determines how the object is activated.
--- <ul>
--- <li>0: Can only be activated with heroes</li>
--- <li>1: Can always be activated</li>
--- <li>2: Can never be activated</li>
--- </ul>
---
--- @param _ScriptName string Script name of the interactive object
--- @param _State      integer Status of the object
---
function Reprisal_ObjectActivate(_ScriptName, _State)
end

---
--- Decreases the diplomatic status between the sender and receiver by one level.
---
function Reprisal_DiplomacyDecrease()
end

---
--- Changes the diplomatic status between two players.
---
--- @param _Party1   integer ID of the first party
--- @param _Party2   integer ID of the second party
--- @param _State    string New diplomatic status
---
function Reprisal_Diplomacy(_Party1, _Party2, _State)
end

---
--- Removes a named entity.
---
--- <b>Note:</b> The entity will be replaced by an XD_ScriptEntity. It retains name, owner, and orientation.
---
--- @param _ScriptName string Script name of the entity
---
function Reprisal_DestroyEntity(_ScriptName)
end

---
--- Destroys an effect created by a behavior.
---
--- @param _EffectName string Name of the effect
---
function Reprisal_DestroyEffect(_EffectName)
end

---
--- Causes the player to lose the game.
---
function Reprisal_Defeat()
end

---
--- Displays defeat decoration on the quest.
---
--- This is purely cosmetic! The player will not actually lose.
---
function Reprisal_FakeDefeat()
end

---
--- Replaces an entity with a new type of entity.
---
--- The new entity inherits the script name, owner, and orientation of the old entity.
---
--- @param _Entity string Script name or ID of the entity
--- @param _Type   string New type of the entity
--- @param _Owner  integer Owner of the entity
---
function Reprisal_ReplaceEntity(_Entity, _Type, _Owner)
end

---
--- Restarts a quest.
---
--- @param _QuestName string Name of the quest
---
function Reprisal_QuestRestart(_QuestName)
end

---
--- Causes a quest to fail.
---
--- @param _QuestName string Name of the quest
---
function Reprisal_QuestFailure(_QuestName)
end

---
--- Marks a quest as successful.
---
--- @param _QuestName string Name of the quest
---
function Reprisal_QuestSuccess(_QuestName)
end

---
--- Triggers a quest.
---
--- @param _QuestName string Name of the quest
---
function Reprisal_QuestActivate(_QuestName)
end

---
--- Interrupts a quest.
---
--- @param _QuestName string Name of the quest
---
function Reprisal_QuestInterrupt(_QuestName)
end

---
--- Forces the interruption of a quest, even if it has not been triggered yet.
---
--- @param _QuestName   string Name of the quest
--- @param _EndetQuests string Quests already ended to interrupt
---
function Reprisal_QuestForceInterrupt(_QuestName, _EndetQuests)
end

---
--- Changes the value of a custom variable.
---
--- Custom variables can only be numbers. Use this behavior before querying
--- the variable in a goal or trigger to initialize it!
---
--- <p>Operators</p>
--- <ul>
--- <li>= - Variable value set to the value</li>
--- <li>- - Variable value subtracted by value</li>
--- <li>+ - Variable value added by value</li>
--- <li>* - Variable value multiplied by value</li>
--- <li>/ - Variable value divided by value</li>
--- <li>^ - Variable value powered by value</li>
--- </ul>
---
--- @param _Name     string Name of the variable
--- @param _Operator string Arithmetic or assignment operator
--- @param _Value    integer Value or another custom variable
---
function Reprisal_CustomVariables(_Name, _Operator, _Value)
end

---
--- Executes a function in the script as a reprisal.
---
--- If a function name is passed as a string, the function is called with the
--- data of the behavior and the associated quest (default).
---
--- If a function reference is specified, the function is called along with all
--- optional parameters, as if it were a regular call in the script.
--- <pre> Reprisal_MapScriptFunction(ReplaceEntity, "block", Entities.XD_ScriptEntity);
--- -- equivalent to: ReplaceEntity("block", Entities.XD_ScriptEntity);</pre>
--- <b>Attention:</b> Not available via the assistant!
---
--- @param _Function string any of the function or function reference
--- @param ... any Optional parameters
---
function Reprisal_MapScriptFunction(_Function, ...)
end

---
--- Allows or disallows a player a right.
---
--- @param _PlayerID   integer ID of the player
--- @param _Lock       string Lock/unlock
--- @param _Technology string Name of the right
---
function Reprisal_Technology(_PlayerID, _Lock, _Technology)
end

---
--- Deactivates an interactive object.
---
--- @param _ScriptName string Script name of the interactive object
---
function Reward_ObjectDeactivate(_ScriptName)
end

---
--- Activates an interactive object.
---
--- The status determines how the object is activated.
--- <ul>
--- <li>0: Can only be activated with heroes</li>
--- <li>1: Can always be activated</li>
--- <li>2: Can never be activated</li>
--- </ul>
---
--- @param _ScriptName string Script name of the interactive object
--- @param _State integer Status of the object
---
function Reward_ObjectActivate(_ScriptName, _State)
end

---
--- Initializes an interactive object.
---
--- Interactive objects can include costs and rewards, but they don't have to. If a cooldown is specified, the object can only be used after the cooldown period has elapsed.
---
--- @param _ScriptName string Script name of the interactive object
--- @param _Distance   integer Distance to activation
--- @param _Time       integer Waiting time until activation
--- @param _RType1     string Type of reward
--- @param _RAmount    integer Amount of reward
--- @param _CType1     string Type of 1st cost
--- @param _CAmount1   integer Amount of 1st cost
--- @param _CType2     string Type of 2nd cost
--- @param _CAmount2   integer Amount of 2nd cost
--- @param _Status     integer Activation (0: hero, 1: always, 2: never)
---
function Reward_ObjectInit(_ScriptName, _Distance, _Time, _RType1, _RAmount, _CType1, _CAmount1, _CType2, _CAmount2, _Status)
end

---
--- Changes the diplomatic status between two players.
---
--- @param _Party1   integer ID of the first party
--- @param _Party2   integer ID of the second party
--- @param _State    string New diplomatic status
---
function Reward_Diplomacy(_Party1, _Party2, _State)
end

---
--- Improves the diplomatic relations between the sender and receiver
--- by one grade.
---
function Reward_DiplomacyIncrease()
end

--- Initaized an tradepost, sets it up for a player and deactivates it.
---
--- @param _ScriptName string Scriptname of tradepost 
--- @param _PlayerID integer Player of offer
--- @param _PayType1 string Name of Pay
--- @param _PayAmount1 integer Amount of Pay
--- @param _GoodType string Name of Good
--- @param _GoodAmount1 integer Amount of Good
--- @param _PayType2 string Name of Pay
--- @param _PayAmount2 integer Amount of Pay
--- @param _GoodType2 string Name of Good
--- @param _GoodAmount2 integer Amount of Pay
--- @param _PayType3 string Name of Pay
--- @param _PayAmount3 integer Amount of Good
--- @param _GoodType3 string Name of Good
--- @param _GoodAmount3 integer Amount of Good
--- @param _PayType4 string Name of Pay
--- @param _PayAmount4 integer Amount of Pay
--- @param _GoodType4 string Name of Good
--- @param _GoodAmount4 integer Amount of Good
---
function Reward_TradePost(_ScriptName, _PlayerID, _PayType1, _PayAmount1, _GoodType, _GoodAmount1, _PayType2, _PayAmount2, _GoodType2, _GoodAmount2, _PayType3, _PayAmount3, _GoodType3, _GoodAmount3, _PayType4, _PayAmount4, _GoodType4, _GoodAmount4)
end

---
--- Generates trade offers in the warehouse of the specified player.
---
--- If offers are to be deleted, "-" must be selected as the commodity.
---
--- <b>Attention:</b> City warehouses cannot offer mercenaries!
---
--- @param _PlayerID integer Party offering
--- @param _Amount1  integer Quantity of the 1st offer
--- @param _Type1    string Commodity or type of the 1st offer
--- @param _Amount2  integer Quantity of the 2nd offer
--- @param _Type2    string Commodity or type of the 2nd offer
--- @param _Amount3  integer Quantity of the 3rd offer
--- @param _Type3    string Commodity or type of the 3rd offer
--- @param _Amount4  integer Quantity of the 4th offer
--- @param _Type4    string Commodity or type of the 4th offer
---
function Reward_TradeOffers(_PlayerID, _Amount1, _Type1, _Amount2, _Type2, _Amount3, _Type3, _Amount4, _Type4)
end

---
--- A named entity is removed.
---
--- <b>Note</b>: The entity is replaced by an XD_ScriptEntity. It
--- retains name, owner, and orientation.
---
--- @param _ScriptName string Script name of the entity
---
function Reward_DestroyEntity(_ScriptName)
end

---
--- Destroys an effect generated by a behavior.
---
--- @param _EffectName string Name of the effect
---
function Reward_DestroyEffect(_EffectName)
end

---
--- Replaces an entity with a battalion.
---
--- If the position is a building, the battalions are created at the entrance and
--- the entity is not replaced.
---
--- The created battalion can be hidden from the owner's AI.
---
--- @param _Position    string Script name of the entity
--- @param _PlayerID    integer PlayerID of the battalion
--- @param _UnitType    string Unit type of soldiers
--- @param _Orientation integer Orientation in °
--- @param _Soldiers    integer Number of soldiers
--- @param _HideFromAI  boolean Hide from AI
---
function Reward_CreateBattalion(_Position, _PlayerID, _UnitType, _Orientation, _Soldiers, _HideFromAI)
end

---
--- Creates a number of battalions at the position.
---
--- The created battalions can be hidden from the owner's AI.
---
--- @param _Amount      integer Number of battalions created
--- @param _Position    string Script name of the entity
--- @param _PlayerID    integer PlayerID of the battalion
--- @param _UnitType    string Unit type of soldiers
--- @param _Orientation integer Orientation in °
--- @param _Soldiers    integer Number of soldiers
--- @param _HideFromAI  boolean Hide from AI
---
function Reward_CreateSeveralBattalions(_Amount, _Position, _PlayerID, _UnitType, _Orientation, _Soldiers, _HideFromAI)
end

---
--- Creates an effect at the specified position.
---
--- The effect can be deleted at any time via its name.
---
--- <b>Attention</b>: Fire effects are known to cause crashes.
--- Either avoid them altogether or disable saving while such
--- an effect is active!
---
--- @param _EffectName  string Unique effect name
--- @param _TypeName    string Type of the effect
--- @param _PlayerID    integer PlayerID of the effect
--- @param _Location    integer Position of the effect
--- @param _Orientation integer Orientation in °
---
function Reward_CreateEffect(_EffectName, _TypeName, _PlayerID, _Location, _Orientation)
end

---
--- Replaces an entity with the specified script name with a new entity.
---
--- If the position is a building, the entities are created at the entrance and
--- the position is not replaced.
---
--- The created entity can be hidden from the owner's AI.
---
--- @param _ScriptName  string Script name of the entity
--- @param _PlayerID    integer PlayerID of the effect
--- @param _TypeName    string Type name of the entity
--- @param _Orientation integer Orientation in °
--- @param _HideFromAI  boolean Hide from AI
---
function Reward_CreateEntity(_ScriptName, _PlayerID, _TypeName, _Orientation, _HideFromAI)
end

---
--- Creates multiple entities at the specified position.
--- 
--- The created entities can be hidden from the owner's AI.
--- 
--- @param _Amount      integer Number of entities
--- @param _ScriptName  string Script name of the entity
--- @param _PlayerID    integer PlayerID of the effect
--- @param _TypeName    string Unique effect name
--- @param _Orientation integer Orientation in °
--- @param _HideFromAI  boolean Hide from AI
--- 
function Reward_CreateSeveralEntities(_Amount, _ScriptName, _PlayerID, _TypeName, _Orientation, _HideFromAI)
end

---
--- Moves a settler, a hero, or a battalion to the specified 
--- destination.
---
--- @param _Settler     string Unit being moved
--- @param _Destination string Destination of movement
---
function Reward_MoveSettler(_Settler, _Destination)
end

---
--- The player wins the game.
---
function Reward_Victory()
end

---
--- The player loses the game.
---
---
function Reward_Defeat()
end

---
--- Displays victory decoration at the quest.
---
--- This is purely cosmetic! It will not cause the player to win the game.
---
function Reward_FakeVictory()
end

---
--- Creates an army to attack the specified territory.
---
--- The army will attempt to destroy buildings within the territory.
--- <ul>
--- <li>Outpost: The army will try to destroy the outpost</li>
--- <li>City: The army will try to destroy the warehouse</li>
--- </ul>
---
--- @param _PlayerID   integer PlayerID of the attacker
--- @param _SpawnPoint string Script name of the spawn point
--- @param _Territory  string Target territory
--- @param _Sword      integer Number of swordsmen (battalion)
--- @param _Bow        integer Number of archers (battalion)
--- @param _Cata       integer Number of catapults
--- @param _Towers     integer Number of siege towers
--- @param _Rams       integer Number of rams
--- @param _Ammo       integer Number of ammunition carts
--- @param _Type       string Type of soldiers
--- @param _Reuse      boolean Reuse free troops
---
function Reward_AI_SpawnAndAttackTerritory(_PlayerID, _SpawnPoint, _Territory, _Sword, _Bow, _Cata, _Towers, _Rams, _Ammo, _Type, _Reuse)
end

---
--- Creates an army that moves to the target point and attacks the area.
---
--- Soldiers will set fire to all reachable buildings. If
--- the target area is walled, soldiers cannot attack and will
--- retreat.
---
--- @param _PlayerID   integer PlayerID of the attacker
--- @param _SpawnPoint string Script name of the spawn point
--- @param _Target     string Script name of the target
--- @param _Radius     integer Action radius around the target
--- @param _Sword      integer Number of swordsmen (battalions)
--- @param _Bow        integer Number of archers (battalions)
--- @param _Soldier    string Type of soldiers
--- @param _Reuse      boolean Reuse free troops
---
function Reward_AI_SpawnAndAttackArea(_PlayerID, _SpawnPoint, _Target, _Radius, _Sword, _Bow, _Soldier, _Reuse)
end

---
--- Creates an army to defend the target area.
---
--- @param _PlayerID     integer PlayerID of the attacker
--- @param _SpawnPoint   string Script name of the spawn point
--- @param _Target       string Script name of the target
--- @param _Radius       integer Guarded area
--- @param _Time         integer Duration of guarding (-1 for infinite)
--- @param _Sword        integer Number of swordsmen (battalions)
--- @param _Bow          integer Number of archers (battalions)
--- @param _CaptureCarts integer Soldiers attack carts
--- @param _Type         string Type of soldiers
--- @param _Reuse        boolean Reuse free troops
---
function Reward_AI_SpawnAndProtectArea(_PlayerID, _SpawnPoint, _Target, _Radius, _Time, _Sword, _Bow, _CaptureCarts, _Type, _Reuse)
end

---
--- Modifies the configuration of an AI player.
---
--- Options:
--- <ul>
--- <li>Courage/FEAR: Fear factor (0 to ?)</li>
--- <li>Reconstruction/BARB: Building reconstruction (0 or 1)</li>
--- <li>Build Order/BPMX: Execute build order (build order number)</li>
--- <li>Conquer Outposts/FCOP: Conquer outposts (0 or 1)</li>
--- <li>Mount Outposts/FMOP: Man own outposts (0 or 1)</li>
--- <li>max. Bowmen/FMBM: Maximum number of archers (min. 1)</li>
--- <li>max. Swordmen/FMSM: Maximum number of swordsmen (min. 1) </li>
--- <li>max. Rams/FMRA: Maximum number of rams (min. 1)</li>
--- <li>max. Catapults/FMCA: Maximum number of catapults (min. 1)</li>
--- <li>max. Ammunition Carts/FMAC: Maximum number of ammunition carts (min. 1)</li>
--- <li>max. Siege Towers/FMST: Maximum number of siege towers (min. 1)</li>
--- <li>max. Wall Catapults/FMBA: Maximum number of wall catapults (min. 1)</li>
--- </ul>
---
--- @param _PlayerID integer PlayerID of the AI
--- @param _Fact     string Configuration entry
--- @param _Value    integer New value
---
function Reward_AI_SetNumericalFact(_PlayerID, _Fact, _Value)
end

---
--- Adjusts the aggressiveness value of the AI player.
---
--- @param _PlayerID         integer PlayerID of the AI player
--- @param _Aggressiveness   integer Aggressiveness value (1 to 3)
---
function Reward_AI_Aggressiveness(_PlayerID, _Aggressiveness)
end

---
--- Sets the enemy of the skirmish AI.
---
--- The skirmish AI (maximum aggressiveness) can only treat one player as an enemy.
--- Typically, this is the human player.
---
--- @param _PlayerID      integer PlayerID of the AI
--- @param _EnemyPlayerID integer PlayerID of the enemy
---
function Reward_AI_SetEnemy(_PlayerID, _EnemyPlayerID)
end

---
--- Replaces an entity with another type.
---
--- The new entity inherits script name, owner, and orientation of
--- the old entity.
---
--- @param _Entity string Script name or ID of the entity
--- @param _Type   string New type of the entity
--- @param _Owner  integer Owner of the entity
---
function Reward_ReplaceEntity(_Entity, _Type, _Owner)
end

---
--- Sets the amount of resources in a mine.
---
--- <b>Caution:</b> In the Eastern Realm, the mine must not have collapsed!
--- Also, this behavior disrupts the refill mechanism.
---
--- @param _ScriptName string Script name of the mine
--- @param _Amount     integer Amount of resources
---
function Reward_SetResourceAmount(_ScriptName, _Amount)
end

---
--- Adds a quantity of resources to the contractor's warehouse. The
--- resources are placed directly into the warehouse or treasure chamber.
---
--- @param _Type   string Type of resource
--- @param _Amount integer Amount of resources
---
function Reward_Resources(_Type, _Amount)
end

---
--- Sends a cart to the specified player.
---
--- If the spawn point is a building, the cart will be created at the entrance.
--- Otherwise, the spawn point can be deleted and the cart will take over
--- the script name.
---
--- @param _ScriptName    string Script name of the spawn point
--- @param _Owner         integer Recipient of the delivery
--- @param _Type          string Type of the cart
--- @param _Good          string Type of goods
--- @param _Amount        integer Amount of goods
--- @param _OtherPlayer   integer Different recipient than the contractor
--- @param _NoReservation boolean Ignore space reservation on the market (sensible?)
--- @param _Replace       boolean Replace spawn point
---
function Reward_SendCart(_ScriptName, _Owner, _Type, _Good, _Amount, _OtherPlayer, _NoReservation, _Replace)
end

---
--- Grants the contractor a quantity of units.
---
--- The units appear at the castle. If the player has no castle, they
--- appear in front of the warehouse.
---
--- @param _Type   string Type of unit
--- @param _Amount integer Amount of units
---
function Reward_Units(_Type, _Amount)
end

---
--- Restarts a quest.
---
--- @param _QuestName string Name of the quest
---
function Reward_QuestRestart(_QuestName)
end

---
--- Causes a quest to fail.
---
--- @param _QuestName string Name of the quest
---
function Reward_QuestFailure(_QuestName)
end

---
--- Evaluates a quest as successful.
---
--- @param _QuestName string Name of the quest
---
function Reward_QuestSuccess(_QuestName)
end

---
--- Triggers a quest.
---
--- @param _QuestName string Name of the quest
---
function Reward_QuestActivate(_QuestName)
end

---
--- Interrupts a quest.
---
--- @param _QuestName string Name of the quest
---
function Reward_QuestInterrupt(_QuestName)
end

---
--- Interrupts a quest, even if it has not been triggered yet.
---
--- @param _QuestName   string Name of the quest
--- @param _EndetQuests boolean Interrupt already completed quests
---
function Reward_QuestForceInterrupt(_QuestName, _EndetQuests)
end

---
--- Changes the value of a custom variable.
---
--- Custom variables can only be numbers. Use
--- this behavior before the variable is queried in a goal or trigger
--- to initialize it!
---
--- <p>Operators</p>
--- <ul>
--- <li>= - Variable value is set to the value</li>
--- <li>- - Subtract value from variable value</li>
--- <li>+ - Add value to variable value</li>
--- <li>* - Multiply variable value by value</li>
--- <li>/ - Divide variable value by value</li>
--- <li>^ - Raise variable value to the power of value</li>
--- </ul>
---
--- @param _Name     string Name of the variable
--- @param _Operator string Arithmetic or assignment operator
--- @param _Value    any Value or another custom variable
---
function Reward_CustomVariables(_Name, _Operator, _Value)
end

---
--- Executes a function as a reward in the script.
---
--- If a function name is passed as a string, the function is called with the
--- data of the behavior and the associated quest (default).
---
--- If a function reference is provided, the function is called along with all
--- optional parameters, as if it were a regular call in the script.
--- <pre>Reward_MapScriptFunction(ReplaceEntity, "block", Entities.XD_ScriptEntity);
--- -- corresponds to: ReplaceEntity("block", Entities.XD_ScriptEntity);</pre>
--- <b>Attention:</b> Not available via the assistant!
---
--- @param _FunctionName any Name of the function or function reference
--- @param ... any Optional parameters
---
function Reward_MapScriptFunction(_FunctionName, ...)
end

---
--- Grants or revokes a right to a player.
---
--- @param _PlayerID   integer ID of the player
--- @param _Lock       string Lock/Unlock
--- @param _Technology string Name of the right
---
function Reward_Technology(_PlayerID, _Lock, _Technology)
end

---
--- Gives the contractor a number of prestige points.
---
--- Prestige usually has no function and is only displayed as additional points in the statistics.
---
--- @param _Amount integer Amount of prestige
---
function Reward_PrestigePoints(_Amount)
end

---
--- Occupies an outpost with soldiers.
---
--- @param _ScriptName string Script name of the outpost
--- @param _Type       string Type of soldier
---
function Reward_AI_MountOutpost(_ScriptName, _Type)
end

---
--- Restarts a quest and triggers it immediately.
---
--- @param _QuestName string Name of the quest
---
function Reward_QuestRestartForceActive(_QuestName)
end

---
--- Upgrades the specified building by one level. The building is expanded by one level by a worker. The worker must first come out of the warehouse and move to the building.
---
--- <b>Attention:</b> A building must be fully upgraded before another upgrade can be started!
---
--- @param _ScriptName string Script name of the building
---
function Reward_UpgradeBuilding(_ScriptName)
end

---
--- Sets the upgrade level of the specified building.
---
--- A building immediately receives a new level without needing a worker to come and upgrade it. For a workshop, a new worker is spawned.
---
--- @param _ScriptName string Script name of the building
--- @param _Level integer Upgrade level
---
function Reward_SetBuildingUpgradeLevel(_ScriptName, _Level)
end

---
--- Triggers the quest when another player is discovered.
---
--- A player is considered discovered when their home territory is revealed.
---
--- @param _PlayerID integer Player to be discovered
---
function Trigger_PlayerDiscovered(_PlayerID)
end

---
--- Triggers the quest when the required diplomacy status exists between the recipient and the specified party.
---
--- @param _PlayerID integer ID of the party
--- @param _State    string Diplomacy status
---
function Trigger_OnDiplomacy(_PlayerID, _State)
end

---
--- Triggers the quest when a need is not satisfied.
---
--- @param _PlayerID integer ID of the player
--- @param _Need     string Need
--- @param _Amount   integer Amount of unsatisfied settlers
---
function Trigger_OnNeedUnsatisfied(_PlayerID, _Need, _Amount)
end

---
--- Triggers the quest when the specified mine is depleted.
---
--- @param _ScriptName string Script name of the mine
---
function Trigger_OnResourceDepleted(_ScriptName)
end

---
--- Triggers the quest when the specified player has a certain amount of resources in the warehouse.
---
--- @param  _PlayerID integer ID of the player
--- @param  _Type     string Type of resource
--- @param _Amount    integer Amount of resources
---
function Trigger_OnAmountOfGoods(_PlayerID, _Type, _Amount)
end

---
--- Triggers the quest when another quest is active.
---
--- @param _QuestName string Name of the quest
--- @param _Time      integer Waiting time
--- return Table with behavior
function Trigger_OnQuestActive(_QuestName, _Time)
end
Trigger_OnQuestActiveWait = Trigger_OnQuestActive;

---
--- Triggers the quest when another quest fails.
---
--- @param _QuestName string Name of the quest
--- @param _Time      integer Waiting time
function Trigger_OnQuestFailure(_QuestName, _Time)
end
Trigger_OnQuestFailureWait = Trigger_OnQuestFailure;

---
--- Triggers the quest when another quest has not been triggered yet.
---
--- @param _QuestName string Name of the quest
function Trigger_OnQuestNotTriggered(_QuestName)
end

---
--- Triggers the quest when another quest is interrupted.
---
--- @param _QuestName string Name of the quest
--- @param _Time      integer Waiting time
function Trigger_OnQuestInterrupted(_QuestName, _Time)
end
Trigger_OnQuestInterruptedWait = Trigger_OnQuestInterrupted;

---
--- Triggers the quest when another quest is over.
---
--- The result does not matter. The quest can either have been successfully completed or failed.
---
--- @param _QuestName string Name of the quest
--- @param _Time      integer Waiting time
function Trigger_OnQuestOver(_QuestName, _Time)
end
Trigger_OnQuestOverWait = Trigger_OnQuestOver;

---
--- Triggers the quest when another quest is successfully completed.
---
--- @param _QuestName string Name of the quest
--- @param _Time      integer Waiting time
function Trigger_OnQuestSuccess(_QuestName, _Time)
end
Trigger_OnQuestSuccessWait = Trigger_OnQuestSuccess;

---
--- Triggers the quest when a custom variable reaches a certain value.
---
--- Custom variables must be numbers. Before a variable can be queried in a goal, it must have been initialized with Reprisal_CustomVariables or Reward_CutsomVariables.
---
--- @param _Name     string Name of the variable
--- @param _Relation string Comparison operator
--- @param _Value    any Value or custom variable
---
function Trigger_CustomVariables(_Name, _Relation, _Value)
end

---
--- Triggers the quest immediately.
---
function Trigger_AlwaysActive()
end

---
--- Starts the quest in the specified month.
---
--- @param _Month integer Month
---
function Trigger_OnMonth(_Month)
end

---
--- Starts the quest once the monsoon rain begins.
---
--- <b>Attention:</b> This behavior is only available for Realm of the East.
---
function Trigger_OnMonsoon()
end

---
--- Starts the quest once the timer expires.
---
--- The timer always counts from the start of the map.
---
--- @param _Time integer Time until start
---
function Trigger_Time(_Time)
end

---
--- Starts the quest once the water freezes.
---
function Trigger_OnWaterFreezes()
end

---
--- Never triggers the quest.
---
--- Quests for which this trigger is set must be started by another
--- quest through Reward_QuestActive or Reprisal_QuestActive.
---
function Trigger_NeverTriggered()
end

---
--- Starts the quest once at least one of two quests fails.
---
--- @param _QuestName1 string Name of the first quest
--- @param _QuestName2 string Name of the second quest
---
function Trigger_OnAtLeastOneQuestFailure(_QuestName1, _QuestName2)
end

---
--- Starts the quest once at least one of two quests succeeds.
---
--- @param _QuestName1 string Name of the first quest
--- @param _QuestName2 string Name of the second quest
---
function Trigger_OnAtLeastOneQuestSuccess(_QuestName1, _QuestName2)
end

---
--- Executes a function in the script as a trigger.
---
--- The function must return either true or false.
---
--- Script Only: If a function reference (string) is passed instead of a function name,
--- all subsequent parameters are passed to the function.
---
--- @param _FunctionName any Name of the function
--- @param ... any Optional parameters
---
function Trigger_MapScriptFunction(_FunctionName, ...)
end

---
--- Starts the quest once an effect is destroyed or disappears.
---
--- <b>Attention:</b> This behavior can only be applied to effects created
--- through effect behaviors.
---
--- @param _EffectName string Name of the effect
---
function Trigger_OnEffectDestroyed(_EffectName)
end

