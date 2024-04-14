--- Ermöglicht die Zucht von Vieh.
---
--- Die Zucht von Kühen und Schafen ist an Technologien gebunden. Diese Technologien können
--- auch dem Beförderungssystem hinzugefügt werden.
---
--- Zusätzlich besteht die Möglichkeit, Nutztiere verhungern zu lassen, wenn sie nicht gefüttert werden.
---
--- #### Fügt Pseudotechnologien hinzu:
--- * `Technologies.R_Cattle` - Ermöglicht die Zucht von Kühen
--- * `Technologies.R_Sheep`  - Ermöglicht die Zucht von Schafen
--- 
Lib.LifestockSystem = Lib.LifestockSystem or {};



--- Ändert die Parameter für die Aufzucht von Kühen.
---
--- Wenn der Fütterungsintervall auf 0 gesetzt ist, müssen die Tiere überhaupt nicht gefüttert werden. Alle
--- Felder, die in der Tabelle ausgelassen werden, werden auf den Standardwert zurückgesetzt.
---
--- #### Felder
--- * `BasePrice`    - Basispreis bei regulären Händlern (Standard: 300)
--- * `GrainCost`    - Kosten für den Kauf eines einzelnen Tieres (Standard: 10)
--- * `GrainUpkeep`  - Kosten für die Tierhaltung (Standard: 1)
--- * `FeedingTimer` - Häufigkeit, mit der die Tierhaltung überprüft wird (Standard: 0)
--- * `StarveChance` - Chance, dass ein Tier verhungert, wenn es hungrig ist (Standard: 35)
---
--- @param _Data table Zucht-Konfiguration
function SetCattleBreedingParameters(_Data)
end
API.SetCattleBreedingParameters = SetCattleBreedingParameters;

--- Ändert die Parameter für die Aufzucht von Schafen.
---
--- Wenn der Fütterungsintervall auf 0 gesetzt ist, müssen die Tiere überhaupt nicht gefüttert werden. Alle
--- Felder, die in der Tabelle ausgelassen werden, werden auf den Standardwert zurückgesetzt.
---
--- #### Felder
--- * `BasePrice`    - Basispreis bei regulären Händlern (Standard: 300)
--- * `GrainCost`    - Kosten für den Kauf eines einzelnen Tieres (Standard: 10)
--- * `GrainUpkeep`  - Kosten für die Tierhaltung (Standard: 1)
--- * `FeedingTimer` - Häufigkeit, mit der die Tierhaltung überprüft wird (Standard: 0)
--- * `StarveChance` - Chance, dass ein Tier verhungert, wenn es hungrig ist (Standard: 35)
---
--- @param _Data table Zucht-Konfiguration
function SetSheepBreedingParameters(_Data)
end
API.SetSheepBreedingParameters = SetSheepBreedingParameters;

--- Legt den erforderlichen Titel fest, um Kühe zu züchten.
---
--- Standardmäßig ist die Zucht von Kühen von Anfang an erlaubt.
--- @param _Title integer Erforderlicher Titel
function RequireTitleToBreedCattle(_Title)
end
API.RequireTitleToBreedCattle = RequireTitleToBreedCattle;

--- Legt den erforderlichen Titel fest, um Schafe zu züchten.
---
--- Standardmäßig ist die Zucht von Schafen von Anfang an erlaubt.
--- @param _Title integer Erforderlicher Titel
function RequireTitleToBreedSheep(_Title)
end
API.RequireTitleToBreedSheep = RequireTitleToBreedSheep;



--- Der Spieler hat auf die Schaltfläche zum Kauf eines Tieres geklickt
--- 
--- #### Parameter
--- * `Index   `   - "Cattle" oder "Sheep"
--- * `PlayerID`   - ID des Spielers
--- * `EntityID`   - ID der Weide
Report.BreedAnimalClicked = anyInteger;

--- Der Spieler hat eine Kuh gekauft.
--- 
--- #### Parameter
--- * `PlayerID`   - ID des Spielers
--- * `EntityID`   - ID der erstellten Kuh
--- * `BuildingID` - ID der Weide
Report.CattleBought = anyInteger;

--- Der Spieler hat ein Schaf gekauft.
--- 
--- #### Parameter
--- * `PlayerID`   - ID des Spielers
--- * `EntityID`   - ID des erstellten Schafs
--- * `BuildingID` - ID der Weide
Report.SheepBought = anyInteger;

--- Eine Kuh ist verhungert.
--- 
--- #### Parameter
--- * `PlayerID`   - ID des Spielers
--- * `EntityID`   - ID der erstellten Kuh
Report.CattleStarved = anyInteger;

--- Ein Schaf ist verhungert.
--- 
--- #### Parameter
--- * `PlayerID`   - ID des Spielers
--- * `EntityID`   - ID des erstellten Schafs
Report.SheepStarved = anyInteger;

