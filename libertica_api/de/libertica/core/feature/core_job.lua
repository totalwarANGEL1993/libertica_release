--- Ermöglicht das Starten von Jobs verschiedener Ereignistypen und deren 
--- Steuerung. Auch einfache Verzögerungen werden bereitgestellt.
Lib.Core.Job = {}

--- Fordert einen Job des übergebenen Ereignistyps an.
--- @param _EventType integer Typ des Jobs
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestJobByEventType(_EventType, _Function, ...)
    return 0;
end
API.StartJobByEventType = RequestJobByEventType;

--- Fordert einen Job an, der jede Sekunde ausgelöst wird.
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestJob(_Function, ...)
    return 0;
end
API.StartJob = RequestJob;
StartSimpleJob = RequestJob;
StartSimpleJobEx = RequestJob;

--- Fordert einen Job an, der jede Runde ausgelöst wird.
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestHiResJob(_Function, ...)
    return 0;
end
API.StartHiResJob = RequestHiResJob;
StartSimpleHiResJob = RequestHiResJob;
StartSimpleHiResJobEx = RequestHiResJob;

--- Fordert eine verzögerte Aktion an, verzögert um Sekunden.
--- @param _Waittime integer Sekunden
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestDelay(_Waittime, _Function, ...)
    return 0;
end
API.StartDelay = RequestDelay;

--- Fordert eine verzögerte Aktion an, verzögert um Runden.
--- @param _Waittime integer Runden
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestHiResDelay(_Waittime, _Function, ...)
    return 0;
end
API.StartHiResDelay = RequestHiResDelay;

--- Fordert eine verzögerte Aktion an, verzögert um Echtzeit-Sekunden.
--- @param _Waittime integer Sekunden
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestRealTimeDelay(_Waittime, _Function, ...)
    return 0;
end
API.StartRealTimeDelay = RequestRealTimeDelay;

--- Beendet einen Job. Der Job kann nicht reaktiviert werden.
--- @param _JobID integer ID des Jobs
function StopJob(_JobID)
end
API.EndJob = StopJob;

--- Gibt zurück, ob der Job ausgeführt wird.
--- @param _JobID integer ID des Jobs
--- @return boolean Running Job wird ausgeführt
function IsJobRunning(_JobID)
    return true;
end
API.JobIsRunning = IsJobRunning;

--- Setzt einen pausierten Job fort.
--- @param _JobID integer ID des Jobs
function ResumeJob(_JobID)
end
API.ResumeJob = ResumeJob;

--- Pausiert einen laufenden Job.
--- @param _JobID integer ID des Jobs
function YieldJob(_JobID)
end
API.YieldJob = YieldJob;

--- Gibt die seit dem Spielstart vergangenen Echtzeit-Sekunden zurück.
--- @return integer Sekunden Anzahl der Sekunden
function GetSecondsRealTime()
    return 0;
end
API.GetSecondsRealTime = GetSecondsRealTime;

