--- Dieses Modul steuert die Kino-Events.
--- 
--- Kino-Events werden von Briefings, Cutscenes u.ä. verwendet, um so die
--- Anzeigereihefolge zu synchronisieren. Verwende dieses Modul nur, wenn
--- du selbst eine Präsentationsform implementierst, die mit z.B. Briefings
--- zusammen funktionieren soll.



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
--- Gibt den Zustand des Kino-Event zurück.
---
--- @param _Identifier any Bezeichner oder ID
--- @param _PlayerID integer ID des Spielers
--- @return integer State Zustand des Kino-Event
---
function GetCinematicEvent(_Identifier, _PlayerID)
    return 0;
end
API.GetCinematicEvent = GetCinematicEvent;

---
--- Prüft ob gerade ein Kino-Event für den Spieler aktiv ist.
---
--- @param _PlayerID integer ID des Spielers
--- @return boolean Active Kino-Event ist aktiv
---
function IsCinematicEventActive(_PlayerID)
    return false;
end
API.IsCinematicEventActive = IsCinematicEventActive;



--- Ein Kino-Event, empfangen von einem bestimmten Spieler, startet.
---
--- #### Parameter
--- * `EventID`  - ID des Kino-Event
--- * `PlayerID` - ID des Empfängers
Report.CinematicActivated = anyInteger;

--- Ein Kino-Event, empfangen von einem bestimmten Spieler, endet.
--- 
--- #### Parameter
--- * `EventID`  - ID des Kino-Event
--- * `PlayerID` - ID des Empfängers
Report.CinematicConcluded = anyInteger;