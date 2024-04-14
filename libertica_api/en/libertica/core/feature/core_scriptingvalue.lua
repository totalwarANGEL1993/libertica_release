--- Provides access to scripting values - unprotected access to the RAM.
---
--- Working Scripting valkues:
--- * `CONST_SCRIPTING_VALUES.Destination.X` - X coordinate of movement target
--- * `CONST_SCRIPTING_VALUES.Destination.Y` - Y coordinate of movement target
--- * `CONST_SCRIPTING_VALUES.Health` - Health of entity
--- * `CONST_SCRIPTING_VALUES.Player` - Player ID of entity
--- * `CONST_SCRIPTING_VALUES.Size` - Scaling of entity
--- * `CONST_SCRIPTING_VALUES.Visible` - Is entity visible
--- * `CONST_SCRIPTING_VALUES.NPC` - Type of npc
Lib.Core.ScriptingValue = {}

--- Returns the value of the index as integer.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @return integer Value Value at index
function GetInteger(_Entity, _SV)
    return 0;
end
API.GetInteger = GetInteger;

--- Returns the value of the index as double.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @return number Value Value at index
function GetFloat(_Entity, _SV)
    return 0;
end
API.GetFloat = GetFloat;

--- Sets an integer value at the index.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @param _Value integer Value to set
function SetInteger(_Entity, _SV, _Value)
end
API.SetInteger = SetInteger;

--- Sets a double value at the index.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @param _Value number Value to set
function SetFloat(_Entity, _SV, _Value)
end
API.SetFloat = SetFloat;

--- Converts the double value into integer representation.
--- @param _Value number Integer value
--- @return number Value Double value
function ConvertIntegerToFloat(_Value)
    return 0;
end
API.ConvertIntegerToFloat = ConvertIntegerToFloat;

--- Converts the integer value into double representation.
--- @param _Value number Double value
--- @return integer Value Integer value
function ConvertFloatToInteger(_Value)
    return 0;
end
API.ConvertFloatToInteger = ConvertFloatToInteger;

