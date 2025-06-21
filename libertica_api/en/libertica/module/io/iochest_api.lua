--- Offers easy to use treasure chests.
--- 
--- #### Console Commands:
--- There are special commands that can be entered into the console. Things in
--- brackets are optional.
--- * `goldchest entity`:   Restarts the current map
--- * `goodchest entity`:   Removes all messages from the screen
--- * `luxurychest entity`: Shows the current version of Libertica



--- Creates a random chest with specific content.
--- @param _Name string Script name of entity
--- @param _Good integer Good type
--- @param _Min integer Minimum amount
--- @param _Max integer? (Optional) Maximum amount
--- @param _Condition function? (Optional) Condition function
--- @param _Action function? (Optional) Action function
function CreateRandomChest(_Name, _Good, _Min, _Max, _Condition, _Action)
end
API.CreateRandomChest = CreateRandomChest;

--- Creates a random ruin with specific content.
--- @param _Name string Script name of entity
--- @param _Good integer Good type
--- @param _Min integer Minimum amount
--- @param _Max integer? (Optional) Maximum amount
--- @param _Condition function? (Optional) Condition function
--- @param _Action function? (Optional) Action function
function CreateRandomTreasure(_Name, _Good, _Min, _Max, _Condition, _Action)
end
API.CreateRandomTreasure = CreateRandomTreasure;

--- Creates a chest with random gold.
--- @param _Name string Script name of entity
function CreateRandomGoldChest(_Name)
end
API.CreateRandomGoldChest = CreateRandomGoldChest;

--- Creates a chest with random resources.
--- @param _Name string Script name of entity
function CreateRandomResourceChest(_Name)
end
API.CreateRandomResourceChest = CreateRandomResourceChest;

--- Creates a chest with a random luxury.
--- @param _Name string Script name of entity
function CreateRandomLuxuryChest(_Name)
end
API.CreateRandomLuxuryChest = CreateRandomLuxuryChest;



--- The player activated a treasure
--- 
--- #### Parameters:
--- * `ScriptName`: <b>string</b> Scriptname of entity
--- * `KnightID`:   <b>integer</b> ID of activating hero
--- * `PlayerID`:   <b>integer</b> ID of activating player
Report.InteractiveTreasureActivated = anyInteger;

