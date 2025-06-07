--- Ermöglicht das Definieren von Zwischensequenzen.
---
--- Zwischensequenzen sind XML-definierte Kamerabewegungen, die von der
--- Spiel-Engine wiedergegeben werden können. Zwischensequenzen zeichnen sich
--- durch flüssige Kamerabewegungen aus.
---

--- Initialisiert den Builder für eine Cutscene.
--- 
--- #### Functions `CutsceneBuilder`:
--- * `SetName(_Name)`:              Setzt den Namen der Cutscene.
--- * `SetPlayer(_Player)`:          Setzt den empfangenden Spieler der Cutscene.
--- * `UseBigBars(_Flag)`:           Verwendet die breiten Briefing Bars. (Aus ästhetischen Gründen nicht zu empfehlen.)
--- * `UseGlobalImmortality(_Flag)`: Während der Cutscene sind alle Entities unverwundbar.
--- * `SetHideNotes(_Flag)`:         Versteckt das Notes Window wärhend der Cutscene.
--- * `SetEnableSky(_Flag)`:         Zeigt den Himmel während der Cutscene an.
--- * `SetEnableFoW(_Flag)`:         Zeigt den Nebel des Krieges während der Cutscene an.
--- * `SetEnableBorderPins(_Flag)`:  Zeigt die Grenzsteine während der Cutscene an.
--- * `SetOnBegin(_OnBegin)`:        Funktion, die beim Start der Cutscene ausgeführt wird.
--- * `SetOnFinish(_OnFinish)`:      Funktion, die beim Ende der Cutscene ausgeführt wird.
--- * `BeginFlight()`:               Eröffnet den `FlightBuilder`.
--- * `Start()`:                     Startet die Cutscene.
---
--- #### Functions `FlightBuilder`:
--- * `SetSpeech(_Speech)`:         Setzt den Pfad zur Voice Line.
--- * `SetTitle(_Title)`:           Setzt den anzuzeigenden Titel der Page.
--- * `SetText(_Text)`:             Setzt den anzuzeigenden Text der Page.
--- * `SetFadeIn(_Time)`:           Blendet von Schwarz ein.
--- * `SetFadeOut(_Time)`:          Blendet zu Schwarz aus.
--- * `SetFaderAlpha(_Opacity)`:    Setzt den Alphawert der Fadermaske.
--- * `UseBigBars(_Flag)`:          Verwendet die breiten Cutscene Bars auf dieser Seite. (Aus ästhetischen Gründen nicht zu empfehlen.)
--- * `UseSkipping(_Flag)`:         Die Seite kann übersprungen werden.
--- * `SetFarClipPlane(_Distance)`: Setzt die maximale Sichtweite. <b>Achtung</b>: Kann auf schwachen Systemen ruckeln.
--- * `EndFlight()`:                Beendet den `FlightBuilder` und kehrt zum `CutsceneBuilder` zurück.
--- 
--- #### Example:
--- ```lua
--- NewCutscene("TestCutscene", 1)
---     :SetEnableBorderPins(true)
---     :SetEnableSky(true)
---     :BeginFlight()
---         :SetFlight("c01")
---         :SetTitle("Flight 1")
---         :SetText("This is the shown text.")
---         :SetFadeIn(3)
---     :EndFlight()
---     :BeginFlight()
---         :SetFlight("c02")
---         :SetTitle("Flight 2")
---         :SetText("This is the shown text.")
---     :EndFlight()
---     :BeginFlight()
---         :SetFlight("c03")
---         :SetTitle("Flight 3")
---         :SetText("This is the shown text.")
---         :SetFadeOut(3)
---     :EndFlight()
---     :Start();
--- ```
---  
--- @param _Name string Name der Cutscene
--- @param _PlayerID integer Spieler-ID des Empfängers
--- @return table BriefingBuilder Builder der Cutscene
function NewCutscene(_Name, _PlayerID)
    return {};
end
API.NewCutscene = NewCutscene;

--- Überprüft, ob eine Zwischensequenz aktiv ist.
--- @param _PlayerID integer Spieler-ID des Empfängers
--- @return boolean IsActive Zwischensequenz ist aktiv
function IsCutsceneActive(_PlayerID)
    return true;
end
API.IsCutsceneActive = IsCutsceneActive;

--- Startet eine Zwischensequenz.
--- <p>
--- <b>Achtung</b>: Diese Funktion ist veraltet und kann nur mit der
--- deklarativen API benutzt werden.
---
--- #### Fields `_Cutscene`:
--- * `Starting`:                (optional) <b>function</b> Funktion, die beim Starten der Einleitung aufgerufen wird              
--- * `Finished`:                (optional) <b>function</b> Funktion, die beim Beenden der Einleitung aufgerufen wird                
--- * `EnableGlobalImmortality`: (optional) <b>boolean</b> Während Einleitungen sind alle Entitäten unverwundbar        
--- * `EnableSky`:               (optional) <b>boolean</b> Zeigt den Himmel während der Einleitung an                   
--- * `EnableFoW`:               (optional) <b>boolean</b> Zeigt den Nebel des Krieges während der Einleitung an 
--- * `EnableBorderPins`:        (optional) <b>boolean</b> Zeigt die Randnadeln während der Einleitung an     
--- * `HideNotes`:               (optional) <b>boolean</b> Nachrichten nicht anzeigen
---
--- #### Example:
--- ```lua
--- function Cutscene1(_Name, _PlayerID)
---     local Cutscene = {};
---     local AP = API.AddCutscenePages(Cutscene);
---     -- Seiten
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

--- Bereitet die Zwischensequenz vor und gibt die Seitenfunktion zurück.
--- <p>
--- <b>Achtung</b>: Diese Funktion ist veraltet und kann nur mit der
--- deklarativen API benutzt werden.
---
--- Muss aufgerufen werden, bevor Seiten hinzugefügt werden.
--- @param _Cutscene table Zwischensequenz-Tabelle
--- @return function AP  Seitenfunktion
function AddCutscenePages(_Cutscene)
    return function(...) end;
end
API.AddCutscenePages = AddCutscenePages;

--- Erstellt eine Seite.
--- <p>
--- <b>Achtung</b>: Diese Funktion ist veraltet und kann nur mit der
--- deklarativen API benutzt werden.
---
--- #### Fields `_Data`:
--- * `Flight`:          <b>string</b> Name der Flug-XML (ohne .cs)
--- * `Title`:           (optional) <b>any</b> Angezeigter Seitentitel (String oder Language Table)
--- * `Text`:            (optional) <b>any</b> Angezeigter Seitentext (String oder Language Table)
--- * `Speech`:          (optional) <b>string</b> Pfad zum Voiceover (MP3-Datei)
--- * `Action`:          (optional) <b>function</b> Funktion, die beim Anzeigen der Seite aufgerufen wird
--- * `FarClipPlane`:    (optional) <b>boolean</b> Render-Entfernung
--- * `FadeIn`:          (optional) <b>float</b> Dauer des Einblendens aus Schwarz
--- * `FadeOut`:         (optional) <b>float</b> Dauer des Ausblendens nach Schwarz
--- * `FaderAlpha`:      (optional) <b>float</b> Maskenalpha
--- * `DisableSkipping`: (optional) <b>boolean</b> Erlauben/Verbieten des Überspringens von Seiten
--- * `BarOpacity`:      (optional) <b>float</b> Deckkraft der Leisten
--- * `BigBars`:         (optional) <b>boolean</b> Verwendung großer Leisten
---
--- #### Example:
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
--- @return table Page Erzeugte Seite
function AP(_Data)
    return {};
end

