--- Dieses Modul beinhalet die Kernkomponenten der Bibliothek.

--- Schreibt eine Nachricht ins Log.
--- @param _Text string Nachrichtentext
--- @param ... any Parameterliste
--- @return string Log Geloggter Text
function log(_Text, ...)
    return "";
end

--- Zeigt eine Warnung auf dem Bildschirm an und schreibt sie ins Log.
--- @param _Condition boolean Geprüfte Bedingung
--- @param _Text string Nachrichtentext
--- @param ... any Parameterliste
--- @return string? Warning Text der Warnung
function warn(_Condition, _Text, ...)
    return "";
end

--- Löst DSE aus und schreibt den Text ins Log.
--- @param _Condition boolean Geprüfte Bedingung
--- @param _Text string Nachrichtentext
--- @param ... any Parameterliste
--- @return any? List Liste der Rückgabewerte
function error(_Condition, _Text, ...)
end

--- Initialisiert die Bibliothek.
function PrepareLibrary()
end
API.PrepareLibrary = PrepareLibrary;

--- Registriert ein Modul in der Modulliste.
--- @param _Name string Name des Modul
function RegisterModule(_Name)
end
API.RegisterModule = RegisterModule;

--- Führt dynamischen Code im lokalen Skript aus.
--- @param _Command string Lua String
--- @param ... unknown Ersetzungsparameter
function ExecuteLocal(_Command, ...)
end
API.ExecuteLocal = ExecuteLocal;

--- Führt dynamischen Code im globalen Skript aus.
--- @param _Command string Lua String
--- @param ... unknown Ersetzungsparameter
function ExecuteGlobal(_Command, ...)
end
API.ExecuteGlobal = ExecuteGlobal;

