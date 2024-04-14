--- Erlaubt es, Pseudo-Technologien zu erzeugen.
---
--- Technologien sollten direkt zu Spielbeginn initialisiert werden.
---
Lib.Technology = Lib.Technology or {};



--- Initialisiert eine Pseudo-Technologie
--- @param _Key string Name der Technologie
--- @param _Name string|table Beschreibung der Technology
--- @param _Icon table Icon
function AddCustomTechnology(_Key, _Name, _Icon)
    Lib.Technology.Shared:AddCustomTechnology(_Key, _Name, _Icon);
end
API.AddCustomTechnology = AddCustomTechnology;

