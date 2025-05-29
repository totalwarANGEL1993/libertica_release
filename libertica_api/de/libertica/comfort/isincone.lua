--- Gibt zurück, ob die Position innerhalb eines Kegels ist.

--- Gibt zurück, ob die Position innerhalb eines Kegels ist.
--- @param _Position table Zu prüfende Position
--- @param _Center table Zentrum des Kegels
--- @param _MiddleAlpha number Middle Alpha
--- @param _BetaAvaiable number Beta Alpha
--- @return boolean InCone Position im Kegel
--- @author mcb
function IsInCone(_Position, _Center, _MiddleAlpha, _BetaAvaiable)
    return false;
end
API.IsInCone = IsInCone;

