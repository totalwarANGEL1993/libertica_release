--- Implementiert die Funktionalität zum Mithören von Berichten für die Bibliothek.
Lib.Core.Report = {};

--- Erstellt einen neuen Berichtstyp.
--- @param _Name string Name des Berichts
--- @return integer
function CreateReport(_Name)
    return 0;
end
API.CreateScriptEvent = CreateReport;

--- Sendet einen Bericht mit optionalen Parametern.
--- @param _ID integer Berichts-ID
--- @param ... unknown Parameter
function SendReport(_ID, ...)
end
API.SendScriptEvent = SendReport;

--- Sendet einen Bericht mit optionalen Parametern an das globale Skript.
---
--- Dies wird immer eine Broadcast sein!
--- @param _ID integer Berichts-ID
--- @param ... unknown Parameter
function SendReportToGlobal(_ID, ...)
end
API.SendScriptEventToGlobal = SendReportToGlobal;

--- Sendet einen Bericht mit optionalen Parametern an das lokale Skript.
--- @param _ID integer Berichts-ID
--- @param ... unknown Parameter
function SendReportToLocal(_ID, ...)
end
API.SendScriptEventToLocal = SendReportToLocal;

--- Erstellt einen Berichtslistener für den Berichtstyp.
--- @param _EventID integer ID des Berichts
--- @param _Function function Listener-Funktion
--- @return integer
function CreateReportReceiver(_EventID, _Function)
    return 0;
end
API.CreateScriptEventReceiver = CreateReportReceiver;

--- Löscht einen Berichtslistener für den Berichtstyp.
--- @param _EventID integer ID des Berichts
--- @param _ID integer ID des Listeners
function RemoveReportReceiver(_EventID, _ID)
end
API.RemoveScriptEventReceiver = RemoveReportReceiver;

