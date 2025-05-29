--- This module contains the core components of the library.

--- Writes a message to the log.
--- @param _Text string Message text
--- @param ... any Parameter list
--- @return string Log Logged text
function log(_Text, ...)
    return "";
end

--- Prints a warning message to the screen and writes to the log.
--- @param _Condition boolean Success condition
--- @param _Text string Message text
--- @param ... any Parameter list
--- @return string? Warning Warning text (if any)
function warn(_Condition, _Text, ...)
    return "";
end

--- Asserts in case of error and writes a message to the log.
--- @param _Condition boolean Success condition
--- @param _Text string Message text
--- @param ... any Parameter list
--- @return ...? Return values
function error(_Condition, _Text, ...)
end

--- Initializes the whole library.
function PrepareLibrary()
end
API.PrepareLibrary = PrepareLibrary;

--- Register a module in the module list.
--- @param _Name string Name of module
function RegisterModule(_Name)
end
API.RegisterModule = RegisterModule;

--- Executes dynamic lua in the local script.
--- @param _Command string Lua string
--- @param ... unknown Replacement values
function ExecuteLocal(_Command, ...)
end
API.ExecuteLocal = ExecuteLocal;

--- Executes dynamic lua in the global script.
--- @param _Command string Lua string
--- @param ... unknown Replacement values
function ExecuteGlobal(_Command, ...)
end
API.ExecuteGlobal = ExecuteGlobal;

