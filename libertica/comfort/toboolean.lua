Lib.Register("comfort/ToBoolean");

function ToBoolean(_Input)
    if type(_Input) == "boolean" then
        return _Input;
    end
    if type(_Input) == "number" then
        return _Input == 1;
    end
    if string.find(string.lower(tostring(_Input)), "^[1tjy\\+].*$") then
        return true;
    end
    return false;
end
API.ToBoolean = ToBoolean;

