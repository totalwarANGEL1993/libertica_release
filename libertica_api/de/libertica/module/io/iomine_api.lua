--- Ermöglicht das Erstellen von konstruierbaren Ressourcenquellen.



--- Erstellt eine vergrabene Eisenerzmine.
---
--- #### Fields `_Data`:
--- * `ScriptName`            - Skriptname der Position
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
--- #### Fields `_Data`:
--- * `ScriptName`            - Skriptname der Position
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
--- #### Parameters:
--- * `ScriptName`: <b>string</b> Scriptname der Entität
--- * `KnightID`:   <b>integer</b> ID des Helden
--- * `PlayerID`:   <b>integer</b> ID des Spielers
Report.InteractiveMineErected = anyInteger;

