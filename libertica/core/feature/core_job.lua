Lib.Core = Lib.Core or {};
Lib.Core.Job = {
    EventJobMappingID = 0;
    EventJobMapping = {},
    EventJobs = {},

    SecondsSinceGameStart = 0;
    LastTimeStamp = 0;
}

Lib.Register("core/feature/Core_Job");

-- -------------------------------------------------------------------------- --

function Lib.Core.Job:Initialize()
    self:StartJobs();
end

function Lib.Core.Job:OnSaveGameLoaded()
end

function Lib.Core.Job:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Job:StartJobs()
    -- Update Real time variable
    self:CreateEventJob(
        Events.LOGIC_EVENT_EVERY_TURN,
        function()
            Lib.Core.Job:RealtimeController();
        end
    )
end

function Lib.Core.Job:CreateEventJob(_Type, _Function, ...)
    self.EventJobMappingID = self.EventJobMappingID +1;
    local ID = Trigger.RequestTrigger(
        _Type,
        "",
        "LiberticaCore_Job_EventJobExecutor",
        1,
        {},
        {self.EventJobMappingID}
    );
    self.EventJobs[ID] = {ID, true, _Function, arg};
    self.EventJobMapping[self.EventJobMappingID] = ID;
    return ID;
end

function Lib.Core.Job:EventJobExecutor(_MappingID)
    local ID = self.EventJobMapping[_MappingID];
    if ID and self.EventJobs[ID] and self.EventJobs[ID][2] then
        local Parameter = self.EventJobs[ID][4];
        if self.EventJobs[ID][3](unpack(Parameter)) then
            self.EventJobs[ID][2] = false;
        end
    end
end

function Lib.Core.Job:RealtimeController()
    if not self.LastTimeStamp then
        self.LastTimeStamp = math.floor(Framework.TimeGetTime());
    end
    local CurrentTimeStamp = math.floor(Framework.TimeGetTime());

    if self.LastTimeStamp ~= CurrentTimeStamp then
        self.LastTimeStamp = CurrentTimeStamp;
        self.SecondsSinceGameStart = self.SecondsSinceGameStart +1;
    end
end

-- -------------------------------------------------------------------------- --

function LiberticaCore_Job_EventJobExecutor(_MappingID)
    Lib.Core.Job:EventJobExecutor(_MappingID);
end

-- -------------------------------------------------------------------------- --

function RequestJobByEventType(_EventType, _Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return Lib.Core.Job:CreateEventJob(_EventType, _Function, ...);
end
API.StartEventJob = RequestJobByEventType;
API.RequestJobByEventType = RequestJobByEventType;
API.StartJobByEventType = RequestJobByEventType;

function RequestJob(_Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestJobByEventType(Events.LOGIC_EVENT_EVERY_SECOND, Function, ...);
end
API.RequestJob = RequestJob;
API.StartJob = RequestJob;
StartSimpleJob = RequestJob;
StartSimpleJobEx = RequestJob;

function RequestHiResJob(_Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestJobByEventType(Events.LOGIC_EVENT_EVERY_TURN, Function, ...);
end
API.RequestHiResJob = RequestHiResJob;
API.StartHiResJob = RequestHiResJob;
StartSimpleHiResJob = RequestHiResJob;
StartSimpleHiResJobEx = RequestHiResJob;

function RequestDelay(_Waittime, _Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestJob(
        function(_StartTime, _Delay, _Callback, _Arguments)
            if _StartTime + _Delay <= Logic.GetTime() then
                _Callback(unpack(_Arguments or {}));
                return true;
            end
        end,
        Logic.GetTime(),
        _Waittime,
        _Function,
        {...}
    );
end
API.RequestDelay = RequestDelay;
API.StartDelay = RequestDelay;

function RequestHiResDelay(_Waittime, _Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestHiResJob(
        function(_StartTime, _Delay, _Callback, _Arguments)
            if _StartTime + _Delay <= Logic.GetCurrentTurn() then
                _Callback(unpack(_Arguments or {}));
                return true;
            end
        end,
        Logic.GetTime(),
        _Waittime,
        _Function,
        {...}
    );
end
API.RequestHiResDelay = RequestHiResDelay;
API.StartHiResDelay = RequestHiResDelay;

function RequestRealTimeDelay(_Waittime, _Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestHiResJob(
        function(_StartTime, _Delay, _Callback, _Arguments)
            if (Lib.Core.Job.SecondsSinceGameStart >= _StartTime + _Delay) then
                _Callback(unpack(_Arguments or {}));
                return true;
            end
        end,
        Lib.Core.Job.SecondsSinceGameStart,
        _Waittime,
        _Function,
        {...}
    );
end
API.RequestRealTimeDelay = RequestRealTimeDelay;
API.RealTimeWait = RequestRealTimeDelay;
API.StartRealTimeDelay = RequestRealTimeDelay;

function StopJob(_JobID)
    if Lib.Core.Job.EventJobs[_JobID] then
        Trigger.UnrequestTrigger(Lib.Core.Job.EventJobs[_JobID][1]);
        Lib.Core.Job.EventJobs[_JobID] = nil;
        return;
    end
    EndJob(_JobID);
end
API.StopJob = StopJob;
API.EndJob = StopJob;

function IsJobRunning(_JobID)
    if Lib.Core.Job.EventJobs[_JobID] then
        return Lib.Core.Job.EventJobs[_JobID][2] == true;
    end
    return JobIsRunning(_JobID);
end
API.IsJobRunning = IsJobRunning;
API.JobIsRunning = IsJobRunning;

function ResumeJob(_JobID)
    if Lib.Core.Job.EventJobs[_JobID] then
        if Lib.Core.Job.EventJobs[_JobID][2] ~= true then
            Lib.Core.Job.EventJobs[_JobID][2] = true;
        end
        return;
    end
    assert(false, "Failed to resume job.");
end
API.ResumeJob = ResumeJob;

function YieldJob(_JobID)
    if Lib.Core.Job.EventJobs[_JobID] then
        if Lib.Core.Job.EventJobs[_JobID][2] == true then
            Lib.Core.Job.EventJobs[_JobID][2] = false;
        end
        return;
    end
    assert(false, "Failed to yield job.");
end
API.YieldJob = YieldJob;

function GetSecondsRealTime()
    return Lib.Core.Job.SecondsSinceGameStart;
end
API.RealTimeGetSecondsPassedSinceGameStart = GetSecondsRealTime;
API.GetSecondsRealTime = GetSecondsRealTime;

