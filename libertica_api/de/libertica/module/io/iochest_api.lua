--- Offers easy to use treasure chests
---
--- #### Reports
--- * `Report.InteractiveTreasureActivated` - Der Spieler hat einen Schatz aktivier.
---
--- #### Debug Functions
--- * `Debug_GoldChest(Entity)   - Erzeugt eine Kiste mit zufälligem Gold
--- * `Debug_GoodChest(Entity)   - Erzeugt eine Kiste mit zufälligem Rohstoff
--- * `Debug_LuxuryChest(Entity) - Erzeugt eine Kiste mit zufälligem Luxusgut
---
Lib.IOChest = Lib.IOChest or {};



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
function CreateRandomChest(_Name, _Good, _Min, _Max, _Condition, _Action)
end
API.CreateRandomChest = CreateRandomChest;

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



--- Der Spieler hat einen Schatz aktivier.
--- 
--- #### Parameters
--- * `ScriptName` - Scriptname der Entität
--- * `KnightID`   - ID des Helden
--- * `PlayerID`   - ID des Spielers
Report.InteractiveTreasureActivated = anyInteger;

