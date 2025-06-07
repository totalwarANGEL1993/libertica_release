--- Allows to create user defined technologies.
---
--- <b>Attention:</b> Technologies should be defined directly on game start.
---



--- Initializes a pseudo technology.
--- @param _Key string Name of technology
--- @param _Name any Description of Technology
--- @param _Icon table Icon
function AddCustomTechnology(_Key, _Name, _Icon)
    Lib.Technology.Shared:AddCustomTechnology(_Key, _Name, _Icon);
end
API.AddCustomTechnology = AddCustomTechnology;

