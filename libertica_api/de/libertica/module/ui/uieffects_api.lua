--- Fügt verschiedene Effekte für das Interface hinzu.



--- Ermöglicht das Anzeigen eines schwarzen Hintergrunds hinter der 
--- Benutzeroberfläche und über der Spielwelt.
--- @param _PlayerID integer ID des Spielers
function ActivateColoredScreen(_PlayerID, _Red, _Green, _Blue, _Alpha)
end
API.ActivateColoredScreen = ActivateColoredScreen;

--- Versteckt den schwarzen Bildschirm.
--- @param _PlayerID integer ID des Spielers
function DeactivateColoredScreen(_PlayerID)
end
API.DeactivateColoredScreen = DeactivateColoredScreen;

--- Zeigt eine Vollbildgrafik über der Spielwelt und unterhalb der 
--- Benutzeroberfläche an.
---
--- Die Grafik muss im 16:9-Format geliefert werden. Für 4:3-Auflösungen 
--- wird die Grafik links und rechts zentriert, um das Format anzupassen.
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



--- Die normale Oberfläche wird dem Spieler angezeigt.
---
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID des Spielers
Report.GameInterfaceShown = anyInteger;

--- Die normale Oberfläche wird vor dem Spieler versteckt.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID des Spielers
Report.GameInterfaceHidden = anyInteger;

--- Der Vollbildhintergrund wird dem Spieler angezeigt.
---
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID des Spielers
Report.ImageScreenShown = anyInteger;

--- Der Vollbildhintergrund wird vor dem Spieler versteckt.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID des Spielers
Report.ImageScreenHidden = anyInteger;

