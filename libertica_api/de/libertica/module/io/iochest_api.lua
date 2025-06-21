--- Bietet einfach zu verwendende Schatzkisten.
--- 
--- #### Console Commands:
--- In der Konsole können spezielle Komandos eingegeben werden. Eingeklammerte
--- Angaben sind dabei optional.
--- * `goldchest entity`:   Startet die Map sofort neu
--- * `goodchest entity`:   Entfernt alle Nachrichten vom Bildschirm
--- * `luxurychest entity`: Zeigt die aktuelle Version von Libertica an



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



--- Der Spieler hat einen Schatz aktivier.
--- 
--- #### Parameters:
--- * `ScriptName`: <b>string</b> Scriptname der Entität
--- * `KnightID`:   <b>integer</b> ID des Helden
--- * `PlayerID`:   <b>integer</b> ID des Spielers
Report.InteractiveTreasureActivated = anyInteger;

