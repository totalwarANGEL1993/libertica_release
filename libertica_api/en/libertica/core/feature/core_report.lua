--- Implements the report listening functionality for the library.
Lib.Core.Report = {};

--- Creates a new report type.
--- @param _Name string Name of report
--- @return integer
function CreateReport(_Name)
    return 0;
end
API.CreateScriptEvent = CreateReport;

--- Sends a report with optional parameter.
--- @param _ID integer Report ID
--- @param ... unknown Parameters
function SendReport(_ID, ...)
end
API.SendScriptEvent = SendReport;

--- Returns the player who has send the report.
--- 
--- If this function is called out of report context or if another error has
--- occured, it will return 0 instead.
--- 
--- @return integer PlayerID ID of source player
function GetReportSender()
    return 0;
end
API.GetReportSender = GetReportSender;
API.GetReportSourcePlayerID = GetReportSender;

--- Sends a report with optional parameter to the global script.
---
--- This will always be a broadcast!
--- @param _ID integer Report ID
--- @param ... unknown Parameters
function SendReportToGlobal(_ID, ...)
end
API.SendScriptEventToGlobal = SendReportToGlobal;

--- Sends a report with optional parameter to the local script.
--- @param _ID integer Report ID
--- @param ... unknown Parameters
function SendReportToLocal(_ID, ...)
end
API.SendScriptEventToLocal = SendReportToLocal;

--- Creates a report listener for the report type.
--- @param _EventID integer ID of report
--- @param _Function function Listener function
--- @return integer
function CreateReportReceiver(_EventID, _Function)
    return 0;
end
API.CreateScriptEventReceiver = CreateReportReceiver;

--- Deletes a report listener for the report type.
--- @param _EventID integer ID of report
--- @param _ID integer ID of listener
function RemoveReportReceiver(_EventID, _ID)
end
API.RemoveScriptEventReceiver = RemoveReportReceiver;

