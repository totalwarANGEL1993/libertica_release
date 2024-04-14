--- Allows to create user defined technologies.
---
--- Technologies should be defined directly on game start.
---
Lib.Technology = Lib.Technology or {};



--- Initializes a pseudo technology.
--- @param _Key string Name of technology
--- @param _Name string|table Description of Technology
--- @param _Icon table Icon
function AddCustomTechnology(_Key, _Name, _Icon)
    Lib.Technology.Shared:AddCustomTechnology(_Key, _Name, _Icon);
end
API.AddCustomTechnology = AddCustomTechnology;

