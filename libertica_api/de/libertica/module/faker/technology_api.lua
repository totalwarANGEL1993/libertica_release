--- Erlaubt es, Pseudo-Technologien zu erzeugen.
---
--- <b>Achtung:</b>  Technologien sollten direkt zu Spielbeginn initialisiert 
--- werden.
---



--- Initialisiert eine Pseudo-Technologie
--- @param _Key string Name der Technologie
--- @param _Name any Beschreibung der Technology
--- @param _Icon table Icon
function AddCustomTechnology(_Key, _Name, _Icon)
    Lib.Technology.Shared:AddCustomTechnology(_Key, _Name, _Icon);
end
API.AddCustomTechnology = AddCustomTechnology;

