--- Bietet Zugriff auf Skriptwerte - ungeschützter Zugriff auf den RAM.
---
--- #### Bekannte Index:
--- * `CONST_SCRIPTING_VALUES.Destination.X` - X-Koordinate des Bewegungsziels
--- * `CONST_SCRIPTING_VALUES.Destination.Y` - Y-Koordinate des Bewegungsziels
--- * `CONST_SCRIPTING_VALUES.Health` - Gesundheit der Entität
--- * `CONST_SCRIPTING_VALUES.Player` - Spieler-ID der Entität
--- * `CONST_SCRIPTING_VALUES.Size` - Skalierung der Entität
--- * `CONST_SCRIPTING_VALUES.Visible` - Ist die Entität sichtbar
--- * `CONST_SCRIPTING_VALUES.NPC` - Art des NPCs
Lib.Core.ScriptingValue = {}

--- Gibt den Wert des Index als Ganzzahl zurück.
--- @param _Entity any ID oder Skriptname
--- @param _SV integer Index des Skriptwerts
--- @return integer Wert Wert am Index
function GetInteger(_Entity, _SV)
    return 0;
end
API.GetInteger = GetInteger;

--- Gibt den Wert des Index als Gleitkommazahl zurück.
--- @param _Entity any ID oder Skriptname
--- @param _SV integer Index des Skriptwerts
--- @return number Wert Wert am Index
function GetFloat(_Entity, _SV)
    return 0;
end
API.GetFloat = GetFloat;

--- Legt einen Ganzzahlwert am Index fest.
--- @param _Entity any ID oder Skriptname
--- @param _SV integer Index des Skriptwerts
--- @param _Value integer Zu setzender Wert
function SetInteger(_Entity, _SV, _Value)
end
API.SetInteger = SetInteger;

--- Legt einen Gleitkommawert am Index fest.
--- @param _Entity any ID oder Skriptname
--- @param _SV integer Index des Skriptwerts
--- @param _Value number Zu setzender Wert
function SetFloat(_Entity, _SV, _Value)
end
API.SetFloat = SetFloat;

--- Konvertiert den Gleitkommawert in die Ganzzahldarstellung um.
--- @param _Value number Ganzzahliger Wert
--- @return number Wert Gleitkommawert
function ConvertIntegerToFloat(_Value)
    return 0;
end
API.ConvertIntegerToFloat = ConvertIntegerToFloat;

--- Konvertiert den Ganzzahlwert in die Gleitkommadarstellung um.
--- @param _Value number Gleitkommawert
--- @return integer Wert Ganzzahliger Wert
function ConvertFloatToInteger(_Value)
    return 0;
end
API.ConvertFloatToInteger = ConvertFloatToInteger;

