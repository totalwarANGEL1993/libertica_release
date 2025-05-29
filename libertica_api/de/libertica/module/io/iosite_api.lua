--- Erzeugt eine interaktive Baustelle an der Position.
--- 
--- Das Territorium unter der interaktiven Baustelle muss dem Spieler gehören,
--- der das Gebäude errichten wird.
---
--- #### Parameters:
--- * `ScriptName`            - Skriptname der Position
--- * `PlayerID`              - Besitzer des Gebäudes
--- * `Type`                  - Typ des Gebäudes
--- * `Title`                 - (Optional) Tooltip-Titel
--- * `Text`                  - (Optional) Tooltip-Text
--- * `Costs`                 - (Optional) Baukosten
--- * `Icon`                  - (Optional) Icon Grafik
--- * `Condition`             - (Optional) Aktivierungsbedingung
--- * `Action`                - (Optional) Aktion nach Aktivierung
--- 
--- @param _Data table Konfiguration
function CreateIOBuildingSite(_Data)
end
API.CreateIOBuildingSite = CreateIOBuildingSite;



--- Eine Baustelle wurde fertiggestellt.
---
--- #### Parameters:
--- - `ScriptName` - Skriptname der Baustelle
--- * `PlayerID`   - ID des aktivierenden Spielers
--- * `BuildingID` - ID des gebauten Gebäude
Report.InteractiveSiteBuild = anyInteger;

