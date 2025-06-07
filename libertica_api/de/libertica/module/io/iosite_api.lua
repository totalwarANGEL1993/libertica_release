--- Ermöglicht das Erstellen von aktivierbaren Baustellen.



--- Erzeugt eine interaktive Baustelle an der Position.
--- 
--- Das Territorium unter der interaktiven Baustelle muss dem Spieler gehören,
--- der das Gebäude errichten wird.
---
--- #### Fields `_Data`:
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
--- - `ScriptName`: <b>string</b> Skriptname der Baustelle
--- * `PlayerID`:   <b>integer</b> ID des aktivierenden Spielers
--- * `BuildingID`: <b>integer</b> ID des gebauten Gebäude
Report.InteractiveSiteBuild = anyInteger;

