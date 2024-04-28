--- Bietet Zugriff auf Skriptwerte - ungeschützter Zugriff auf den RAM.
---
--- #### Bekannte Index:
--- * `CONST_SCRIPTING_VALUES.Destination.X` - X-Koordinate des Bewegungsziels
--- * `CONST_SCRIPTING_VALUES.Destination.Y` - Y-Koordinate des Bewegungsziels
--- * `CONST_SCRIPTING_VALUES.Health` - Gesundheit der Entität
--- * `CONST_SCRIPTING_VALUES.Player` - Spieler-ID der Entität
--- * `CONST_SCRIPTING_VALUES.Size` - Skalierung der Entität
--- * `CONST_SCRIPTING_VALUES.Visible` - Ist die Entität sichtbar (= 801280)
--- * `CONST_SCRIPTING_VALUES.NPC` - Art des NPCs (> 0)
Lib.Core.ScriptingValue = {}



--- Gibt das aktuelle Bewegungsziel der Entität zurück.
--- @param _Entity any ID oder Skriptname
--- @return table Position Bewegungsziel der Entität
function GetEntityDestination(_Entity)
    return {};
end

--- Gibt die Gesundheit der Entität zurück.
--- @param _Entity any ID oder Skriptname
--- @return integer Health Gesundheit der Entität
function GetEntityHealth(_Entity)
    return 0;
end

--- Setzt die Gesundheit der Entität, ohne Prüfung auf plausibelität.
--- @param _Entity any ID oder Skriptname
--- @param _Health integer Gesundheit der Entität
function SetEntityHealth(_Entity, _Health)
end

--- Gibt zurück, ob die Entität ein NPC ist.
--- @param _Entity any ID oder Skriptname
--- @return boolean Active Entität ist NPC 
function GetEntityNpc(_Entity)
    return true;
end

--- Gibt den Besitzer der Entität zurück.
--- @param _Entity any ID oder Skriptname
--- @return integer Player ID des Spielers
function GetEntityPlayer(_Entity)
    return 0;
end

--- Setzt den Eigentümer der Entität, ohne Prüfung auf plausibelität.
--- @param _Entity any ID oder Skriptname
--- @param _Player integer Player ID des Spielers
function SetEntityPlayer(_Entity, _Player)
end

--- Gibt die Skalierung der Entität zurück.
--- @param _Entity any
--- @return number Scaling Skalierung der Entität
function GetEntityScaling(_Entity)
    return 0;
end

--- Setzt die Skalierung der Entität.
--- @param _Entity any ID oder Skriptname
--- @param _Scaling number Skalierung der Entität
function GetEntityScaling(_Entity, _Scaling)
end

--- Gibt zurück, ob die Entität unsichtbar ist,
--- @param _Entity any ID oder Skriptname
--- @return boolean Visible Entity ist unsichtbar
function IsEntityInvisible(_Entity)
    return true;
end

--- Gibt zurück, ob die Entität nicht auswählbar ist.
--- @param _Entity any ID oder Skriptname
--- @return boolean Visible Entity nicht auswählbar
function IsEntityInaccessible(_Entity)
    return true;
end

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

