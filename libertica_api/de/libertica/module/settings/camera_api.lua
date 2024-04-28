--- 
Lib.Camera = Lib.Camera or {};

--- Ändert die maximale Darstellungsreichweite, bis etwas abgeschnitten wird.
--- @param _View number Maximale Darstellungsreichweite
function SetRenderDistance(_View)
end

--- Setzt das Clipping auf seine Standardwerte zurück.
function ResetRenderDistance()
end

--- Aktiviert den Bildlauf am Rand des Bildschirms und lockert die Kamerabefestigung.
--- @param _PlayerID integer? ID des Spielers
function ActivateBorderScroll(_PlayerID)
end
API.ActivateBorderScroll = ActivateBorderScroll;

--- Deaktiviert den Bildlauf am Rand des Bildschirms und fixiert die Kamera.
--- @param _PlayerID integer? ID des Spielers
--- @param _Position integer? (Optional) Entität, auf die die Kamera fixiert werden soll
function DeactivateBorderScroll(_Position, _PlayerID)
end
API.DeactivateBorderScroll = DeactivateBorderScroll;

--- Erlaubt/Verbietet die erweiterte Zoomfunktion für einen oder alle Spieler.
--- @param _Flag boolean Erweiterter Zoom erlaubt
--- @param _PlayerID integer? ID des Spielers
function AllowExtendedZoom(_Flag, _PlayerID)
end
API.AllowExtendedZoom = AllowExtendedZoom;

--- Fokussiert eine Kamera auf den Ritter des Spielers, sperrt die Kamera jedoch nicht.
--- @param _PlayerID integer ID des Spielers
--- @param _Rotation number Drehwinkel
--- @param _ZoomFactor number Zoomfaktor
function FocusCameraOnKnight(_PlayerID, _Rotation, _ZoomFactor)
end
API.FocusCameraOnKnight = FocusCameraOnKnight;

--- Fokussiert eine Kamera auf eine Entität, sperrt die Kamera jedoch nicht.
--- @param _Entity any
--- @param _Rotation number Drehwinkel
--- @param _ZoomFactor number Zoomfaktor
function FocusCameraOnEntity(_Entity, _Rotation, _ZoomFactor)
end
API.FocusCameraOnEntity = FocusCameraOnEntity;

--- Der Bildlauf am Rand des Bildschirms ist für einen Spieler deaktiviert.
---
--- #### Parameter
--- - `PlayerID` - ID des Spielers
--- - `Position` - ID der Entität, auf die die Kamera fixiert ist
Report.BorderScrollLocked = anyInteger;

--- Der Bildlauf am Rand des Bildschirms ist für einen Spieler aktiviert.
---
--- #### Parameter
--- - `PlayerID` - ID des Spielers
Report.BorderScrollReset = anyInteger;

--- Die erweiterte Zoomentfernung ist für den Spieler deaktiviert.
--- 
--- #### Parameter
--- - `PlayerID` - ID des Spielers
Report.ExtendedZoomDeactivated = anyInteger;

--- Die erweiterte Zoomentfernung ist für den Spieler aktiviert.
--- 
--- #### Parameter
--- - `PlayerID` - ID des Spielers
Report.ExtendedZoomActivated = anyInteger;

