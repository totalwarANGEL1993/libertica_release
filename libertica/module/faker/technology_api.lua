Lib.Require("comfort/IsLocalScript");
Lib.Register("module/faker/Technology_API");

function AddCustomTechnology(_Key, _Name, _Icon)
    Lib.Technology.Shared:AddCustomTechnology(_Key, _Name, _Icon);
end
API.AddCustomTechnology = AddCustomTechnology;

