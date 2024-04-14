--- Allows to start jobs of different event types and controlling them. Also 
--- simple delays are provided.
Lib.Core.Job = {}

--- Requests a job of the passed event type.
--- @param _EventType integer Type of job
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestJobByEventType(_EventType, _Function, ...)
    return 0;
end
API.StartJobByEventType = RequestJobByEventType;

--- Requests a job that triggers each second.
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestJob(_Function, ...)
    return 0;
end
API.StartJob = RequestJob;
StartSimpleJob = RequestJob;
StartSimpleJobEx = RequestJob;

--- Requests a job that triggers each turn.
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestHiResJob(_Function, ...)
    return 0;
end
API.StartHiResJob = RequestHiResJob;
StartSimpleHiResJob = RequestHiResJob;
StartSimpleHiResJobEx = RequestHiResJob;

--- Requests a delayed action delayed by seconds.
--- @param _Waittime integer Seconds
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestDelay(_Waittime, _Function, ...)
    return 0;
end
API.StartDelay = RequestDelay;

--- Requests a delayed action delayed by turns
--- @param _Waittime integer Turns
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestHiResDelay(_Waittime, _Function, ...)
    return 0;
end
API.StartHiResDelay = RequestHiResDelay;

--- Requests a delayed action delayed by realtime seconds.
--- @param _Waittime integer Seconds
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestRealTimeDelay(_Waittime, _Function, ...)
    return 0;
end
API.StartRealTimeDelay = RequestRealTimeDelay;

--- Ends a job. The job can not be reactivated.
--- @param _JobID integer ID of job
function StopJob(_JobID)
end
API.EndJob = StopJob;

--- Returns if the job is running.
--- @param _JobID integer ID of job
--- @return boolean Running Job is runnung
function IsJobRunning(_JobID)
    return true;
end
API.JobIsRunning = IsJobRunning;

--- Resumes a paused job.
--- @param _JobID integer ID of job
function ResumeJob(_JobID)
end
API.ResumeJob = ResumeJob;

--- Pauses a runnung job.
--- @param _JobID integer ID of job
function YieldJob(_JobID)
end
API.YieldJob = YieldJob;

--- Returns the real time seconds passed since game start.
--- @return integer Seconds Amount of seconds
function GetSecondsRealTime()
    return 0;
end
API.GetSecondsRealTime = GetSecondsRealTime;

