--- Funktionen zur Manipulation der RTS-Kamera.



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

--- Aktiviert den erweiterten Zoom für einen Spieler oder für alle Spieler.
--- @param _PlayerID integer? ID des Spielers
function ActivateExtendedZoom(_PlayerID)
end
API.ActivateExtendedZoom = ActivateExtendedZoom;

--- Deaktiviert den erweiterten Zoom für einen Spieler oder für alle Spieler.
--- @param _PlayerID integer? ID des Spielers
function DeactivateExtendedZoom(_PlayerID)
end
API.DeactivateExtendedZoom = DeactivateExtendedZoom;

--- Setzt das Zoom Limit für den normalen Zoom.
--- 
--- Der voreingestellte Wert beträgt 0.5.
--- 
--- @param _Limit number Zoom Limit (zwischen 0.1 und 0.87)
function SetNormalZoomProps(_Limit)
end
API.SetNormalZoomProps = SetNormalZoomProps;

--- Setzt das Zoom Limit für den erweiterten Zoom.
--- 
--- Der voreingestellte Wert beträgt 0.65.
--- 
--- @param _Limit number Zoom Limit (zwischen 0.1 und 0.87)
function SetExtendedZoomProps(_Limit)
end
API.SetExtendedZoomProps = SetExtendedZoomProps;

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
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID des Spielers
--- * `Position`: <b>integer</b> ID der Entität, auf die die Kamera fixiert ist
Report.BorderScrollLocked = anyInteger;

--- Der Bildlauf am Rand des Bildschirms ist für einen Spieler aktiviert.
---
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID des Spielers
Report.BorderScrollReset = anyInteger;

--- Die erweiterte Zoomentfernung ist für den Spieler deaktiviert.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID des Spielers
Report.ExtendedZoomDeactivated = anyInteger;

--- Die erweiterte Zoomentfernung ist für den Spieler aktiviert.
--- 
--- #### Parameters:
--- * `PlayerID`: <b>integer</b> ID des Spielers
Report.ExtendedZoomActivated = anyInteger;

