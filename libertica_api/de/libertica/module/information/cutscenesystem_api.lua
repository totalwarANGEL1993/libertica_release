--- Ermöglicht das Definieren von Zwischensequenzen.
---
--- **Veraltet! Das Modul ist nur für Rückwärtskompatibelität integriert.**
---
--- Zwischensequenzen sind XML-definierte Kamerabewegungen, die von der
--- Spiel-Engine wiedergegeben werden können. Zwischensequenzen zeichnen sich
--- durch flüssige Kamerabewegungen aus.
---
Lib.CutsceneSystem = Lib.CutsceneSystem or {};

--- Startet eine Zwischensequenz.
---
--- #### Einstellungen
---
--- Mögliche Felder für die Zwischensequenz-Tabelle:
--- * `Starting`                - Funktion, die beim Starten der Zwischensequenz aufgerufen wird              
--- * `Finished`                - Funktion, die beim Beenden der Zwischensequenz aufgerufen wird                 
--- * `EnableGlobalImmortality` - Während der Zwischensequenz sind alle Entitäten unverwundbar        
--- * `EnableSky`               - Anzeigen des Himmels während der Zwischensequenz                   
--- * `EnableFoW`               - Anzeigen des Nebels des Krieges während der Zwischensequenz           
--- * `EnableBorderPins`        - Anzeigen der Grenzstifte während der Zwischensequenz 
---
--- #### Beispiel
---
--- ```lua
--- function Cutscene1(_Name, _PlayerID)
---     local Cutscene = {};
---     local AP = API.AddCutscenePages(Cutscene);
---
---     -- Seiten ...
---
---     Cutscene.Starting = function(_Data)
---     end
---     Cutscene.Finished = function(_Data)
---     end
---     API.StartCutscene(Cutscene, _Name, _PlayerID);
--- end
--- ```
---
--- @param _Cutscene table   Zwischensequenz-Tabelle
--- @param _Name string      Name der Zwischensequenz
--- @param _PlayerID integer Spieler-ID des Empfängers
function StartCutscene(_Cutscene, _Name, _PlayerID)
end
API.StartCutscene = StartCutscene;

--- Fragt den Spieler um Erlaubnis, Grafikeinstellungen zu ändern.
---
--- Ist das BriefingSystem oder das DialogSystem geladen, werden stattdessen
--- deren Funktionen verwendet.
---
--- Diese Funktionalität ist im Multiplayer deaktiviert.
function RequestCutsceneAlternateGraphics()
end
API.RequestCutsceneAlternateGraphics = RequestCutsceneAlternateGraphics;

--- Überprüft, ob eine Zwischensequenz aktiv ist.
--- @param _PlayerID integer Spieler-ID des Empfängers
--- @return boolean IsActive Zwischensequenz ist aktiv
function IsCutsceneActive(_PlayerID)
    return true;
end
API.IsCutsceneActive = IsCutsceneActive;

--- Bereitet die Zwischensequenz vor und gibt die Seitenfunktion zurück.
---
--- Muss aufgerufen werden, bevor Seiten hinzugefügt werden.
--- @param _Cutscene table Zwischensequenz-Tabelle
--- @return function AP  Seitenfunktion
function AddCutscenePages(_Cutscene)
    return function(...) end;
end
API.AddCutscenePages = AddCutscenePages;

--- Erstellt eine Seite.
---
--- #### Zwischensequenzseite
--- Mögliche Felder für die Seite:
---
--- * `Flight`          - Name der Flug-XML (ohne .cs)
--- * `Title`           - Angezeigter Seitentitel
--- * `Text`            - Angezeigter Seitentext
--- * `Action`          - Funktion, die beim Anzeigen der Seite aufgerufen wird
--- * `FarClipPlane`    - Render-Entfernung
--- * `FadeIn`          - Dauer des Einblendens aus Schwarz
--- * `FadeOut`         - Dauer des Ausblendens nach Schwarz
--- * `FaderAlpha`      - Maskenalpha
--- * `DisableSkipping` - Erlauben/Verbieten des Überspringens von Seiten
--- * `BarOpacity`      - Deckkraft der Leisten
--- * `BigBars`         - Verwendung großer Leisten
---
--- #### Beispiel
---
--- ```lua
--- AP {
---     Flight       = "c02",
---     FarClipPlane = 45000,
---     Title        = "Titel",
---     Text         = "Text des Flugs.",
--- };
--- ```
---
--- @param _Data table Seitendaten
function AP(_Data)
    assert(false);
end

