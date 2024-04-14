--- Ermöglicht das Erstellen von konstruierbaren Ressourcenquellen.
Lib.IOMine = Lib.IOMine or {};



--- Erstellt eine vergrabene Eisenerzmine.
---
--- #### Parameter
--- * `Scriptname`            - Skriptname der Position
--- * `Title`                 - (Optional) Tooltip-Titel
--- * `Text`                  - (Optional) Tooltip-Text
--- * `Costs`                 - (Optional) Baukosten
--- * `ResourceAmount`        - (Optional) Menge der Ressourcen
--- * `RefillAmount`          - (Optional) Auffüllmenge
--- * `ConstructionCondition` - (Optional) Bedingungsfunktion
--- * `ConditionInfo`         - (Optional) Info-Bedingung nicht erfüllt
--- * `ConstructionAction`    - (Optional) Aktion nach dem Bau
---
--- @param _Data table Mine-Konfiguration
function CreateIOIronMine(_Data)
end
API.CreateIOIronMine = CreateIOIronMine;

--- Erstellt eine vergrabene Steingrube.
---
--- #### Parameter
--- * `Scriptname`            - Skriptname der Position
--- * `Title`                 - (Optional) Tooltip-Titel
--- * `Text`                  - (Optional) Tooltip-Text
--- * `Costs`                 - (Optional) Baukosten
--- * `ResourceAmount`        - (Optional) Menge der Ressourcen
--- * `RefillAmount`          - (Optional) Auffüllmenge
--- * `ConstructionCondition` - (Optional) Bedingungsfunktion
--- * `ConditionInfo`         - (Optional) Info-Bedingung nicht erfüllt
--- * `ConstructionAction`    - (Optional) Aktion nach dem Bau
---
--- @param _Data table Mine-Konfiguration
function CreateIOStoneMine(_Data)
end
API.CreateIOStoneMine = CreateIOStoneMine;



--- Eine Ressourcenquelle wurde erstellt.
---
--- #### Parameter
--- - `ScriptName` - Skriptname der Mine
--- * `KnightID`   - ID des aktivierenden Helden
--- * `PlayerID`   - ID des aktivierenden Spielers
Report.InteractiveMineErected = anyInteger;

