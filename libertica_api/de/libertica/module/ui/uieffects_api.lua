--- Fügt verschiedene Effekte für das Interface hinzu.
---
--- #### Reports
--- `Report.CinematicActivated` - Ein Kinoevent, empfangen von einem bestimmten Spieler, startet.
--- `Report.GameInterfaceShown` - Ein Kinoevent, empfangen von einem bestimmten Spieler, endet.
--- `Report.GameInterfaceHidden` - Die normale Oberfläche wird dem Spieler angezeigt.
--- `Report.ImageScreenShown` - Der Vollbildhintergrund wird dem Spieler angezeigt.
--- `Report.ImageScreenHidden` - Der Vollbildhintergrund wird vor dem Spieler versteckt.
---
Lib.UIEffects = Lib.UIEffects or {};



--- Ermöglicht das Anzeigen eines schwarzen Hintergrunds hinter der Benutzeroberfläche und über der Spielwelt.
--- @param _PlayerID integer ID des Spielers
function ActivateColoredScreen(_PlayerID, _Red, _Green, _Blue, _Alpha)
end
API.ActivateColoredScreen = ActivateColoredScreen;

--- Versteckt den schwarzen Bildschirm.
--- @param _PlayerID integer ID des Spielers
function DeactivateColoredScreen(_PlayerID)
end
API.DeactivateColoredScreen = DeactivateColoredScreen;

--- Zeigt eine Vollbildgrafik über der Spielwelt und unterhalb der Benutzeroberfläche an.
---
--- Die Grafik muss im 16:9-Format geliefert werden. Für 4:3-Auflösungen wird die Grafik
--- links und rechts zentriert, um das Format anzupassen.
---
--- @param _PlayerID integer ID des Spielers
--- @param _Image string     Pfad zur Grafik
--- @param _Red integer?     (Optional) Rotwert (Standard: 255)
--- @param _Green integer?   (Optional) Grünwert (Standard: 255)
--- @param _Blue integer?    (Optional) Blauwert (Standard: 255)
--- @param _Alpha integer?   (Optional) Alphawert (Standard: 255)
function ActivateImageScreen(_PlayerID, _Image, _Red, _Green, _Blue, _Alpha)
end
API.ActivateImageScreen = ActivateImageScreen;

--- Versteckt das Vollbildbild.
--- @param _PlayerID integer ID des Spielers
function DeactivateImageScreen(_PlayerID)
end
API.DeactivateImageScreen = DeactivateImageScreen;

--- Zeigt die normale Benutzeroberfläche des Spiels an.
--- @param _PlayerID integer ID des Spielers
function ActivateNormalInterface(_PlayerID)
end
API.ActivateNormalInterface = ActivateNormalInterface;

--- Versteckt die normale Benutzeroberfläche des Spiels.
--- @param _PlayerID integer ID des Spielers
function DeactivateNormalInterface(_PlayerID)
end
API.DeactivateNormalInterface = DeactivateNormalInterface;

--- Propagiert den Beginn eines Kinoveranstaltung.
--- @param _Name     string  Bezeichner
--- @param _PlayerID integer ID des Spielers
function StartCinematicEvent(_Name, _PlayerID)
end
API.StartCinematicEvent = StartCinematicEvent;

--- Propagiert das Ende einer Kinoveranstaltung.
--- @param _Name     string  Bezeichner
--- @param _PlayerID integer ID des Spielers
function FinishCinematicEvent(_Name, _PlayerID)
end
API.FinishCinematicEvent = FinishCinematicEvent;

---
--- Gibt den Zustand des Kinoevent zurück.
---
--- @param _Identifier any Bezeichner oder ID
--- @param _PlayerID integer ID des Spielers
--- @return integer State Zustand des Kinoevent
---
function GetCinematicEvent(_Identifier, _PlayerID)
    return 0;
end
API.GetCinematicEvent = GetCinematicEvent;

---
--- Prüft ob gerade ein Kinoevent für den Spieler aktiv ist.
---
--- @param _PlayerID integer ID des Spielers
--- @return boolean Active Kinoevent ist aktiv
---
function IsCinematicEventActive(_PlayerID)
    return false;
end
API.IsCinematicEventActive = IsCinematicEventActive;

--- Zeigt einen Text byte für byte an.
---
--- Wenn bei Spielstart verwendet, beginnt der Text nach dem Laden der Karte. Wenn ein anderes
--- Kinoevent läuft, wartet der Typewriter auf Abschluss.
---
--- Kontrollzeichen wie {cr} werden als ein Token ausgewertet und als atomares Token behandelt
--- und sofort angezeigt. Mehr als 1 Leerzeichen hintereinander werden automatisch auf 1 Leerzeichen
--- abgeschnitten (durch den Spiel-Engine).
---
--- #### Felder der Tabelle
--- * Text         - Anzuzeigender Text
--- * Name         - (Optional) Name für das Ereignis
--- * PlayerID     - (Optional) Spieler, dessen Text angezeigt wird
--- * Callback     - (Optional) Rückruffunktion
--- * TargetEntity - (Optional) Entität, auf die die Kamera fokussiert ist
--- * CharSpeed    - (Optional) Faktor der Schreibgeschwindigkeit (Standard: 1.0)
--- * Waittime     - (Optional) Anfangswartezeit vor dem Schreiben
--- * Opacity      - (Optional) Deckkraft des Hintergrunds (Standard: 1.0)
--- * Color        - (Optional) Hintergrundfarbe (Standard: {R= 0, G= 0, B= 0})
--- * Image        - (Optional) Hintergrundbild (muss im 16:9-Format sein)
---
--- #### Beispiele
--- ```lua
--- local EventName = StartTypewriter {
---     PlayerID = 1,
---     Text     = "Lorem ipsum dolor sit amet, consetetur "..
---                "sadipscing elitr, sed diam nonumy eirmod "..
---                "tempor invidunt ut labore et dolore magna "..
---                "aliquyam erat, sed diam voluptua.",
---     Callback = function(_Data)
---     end
--- };
--- ```
---
--- @param _Data table Daten-Tabelle
--- @return string? EventName Name des Ereignisses
function StartTypewriter(_Data)
    return "";
end
API.StartTypewriter = StartTypewriter;



--- Ein Kinoevent, empfangen von einem bestimmten Spieler, startet.
---
--- #### Parameter
--- * `EventID`  - ID des Kinoevent
--- * `PlayerID` - ID des Empfängers
Report.CinematicActivated = anyInteger;

--- Ein Kinoevent, empfangen von einem bestimmten Spieler, endet.
--- 
--- #### Parameter
--- * `EventID`  - ID des Kinoevent
--- * `PlayerID` - ID des Empfängers
Report.CinematicConcluded = anyInteger;

--- Die normale Oberfläche wird dem Spieler angezeigt.
---
--- #### Parameter
--- * `PlayerID` - ID des Spielers
Report.GameInterfaceShown = anyInteger;

--- Die normale Oberfläche wird vor dem Spieler versteckt.
--- 
--- #### Parameter
--- * `PlayerID` - ID des Spielers
Report.GameInterfaceHidden = anyInteger;

--- Der Vollbildhintergrund wird dem Spieler angezeigt.
---
--- #### Parameter
--- * `PlayerID` - ID des Spielers
Report.ImageScreenShown = anyInteger;

--- Der Vollbildhintergrund wird vor dem Spieler versteckt.
--- 
--- #### Parameter
--- * `PlayerID` - ID des Spielers
Report.ImageScreenHidden = anyInteger;

