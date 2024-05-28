Lib.Register("comfort/IsLocalScript");

function IsLocalScript()
    return GUI ~= nil;
end
API.IsLocalScript = IsLocalScript;

