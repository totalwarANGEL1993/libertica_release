--- Provides access to scripting values - unprotected access to the RAM.
---
--- Working Scripting valkues:
--- * `CONST_SCRIPTING_VALUES.Destination.X` - X coordinate of movement target
--- * `CONST_SCRIPTING_VALUES.Destination.Y` - Y coordinate of movement target
--- * `CONST_SCRIPTING_VALUES.Health` - Health of entity
--- * `CONST_SCRIPTING_VALUES.Player` - Player ID of entity
--- * `CONST_SCRIPTING_VALUES.Size` - Scaling of entity
--- * `CONST_SCRIPTING_VALUES.Visible` - Is entity visible (= 801280)
--- * `CONST_SCRIPTING_VALUES.NPC` - Type of npc (> 0)
Lib.Core.ScriptingValue = {}



--- Returns the current movement destination of the entity.
--- @param _Entity any ID or script name
--- @return table Position movement destination of the entity
function GetEntityDestination(_Entity)
    return {};
end

--- Returns the health of the entity.
--- @param _Entity any ID or script name
--- @return integer Health health of the entity
function GetEntityHealth(_Entity)
    return 0;
end

--- Sets the health of the entity, without checking plausibility.
--- @param _Entity any ID or script name
--- @param _Health integer health of the entity
function SetEntityHealth(_Entity, _Health)
end

--- Returns whether the entity is an NPC.
--- @param _Entity any ID or script name
--- @return boolean Active entity is NPC
function GetEntityNpc(_Entity)
    return true;
end

--- Returns the owner of the entity.
--- @param _Entity any ID or script name
--- @return integer Player ID of the player
function GetEntityPlayer(_Entity)
    return 0;
end

--- Sets the owner of the entity, without checking plausibility.
--- @param _Entity any ID or script name
--- @param _Player integer Player ID of the player
function SetEntityPlayer(_Entity, _Player)
end

--- Returns the scaling of the entity.
--- @param _Entity any
--- @return number Scaling scaling of the entity
function GetEntityScaling(_Entity)
    return 0;
end

--- Sets the scaling of the entity.
--- @param _Entity any ID or script name
--- @param _Scaling number scaling of the entity
function GetEntityScaling(_Entity, _Scaling)
end

--- Returns whether the entity is invisible.
--- @param _Entity any ID or script name
--- @return boolean Visible entity is invisible
function IsEntityInvisible(_Entity)
    return true;
end

--- Returns whether the entity is not selectable.
--- @param _Entity any ID or script name
--- @return boolean Visible Entity is inaccessible
function IsEntityInaccessible(_Entity)
    return true;
end

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

