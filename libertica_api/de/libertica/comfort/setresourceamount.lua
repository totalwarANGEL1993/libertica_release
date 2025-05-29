--- Ändert die Menge an Rohstoffen in einer Rohstoffentität.

--- Ändert die Menge an Rohstoffen in einer Rohstoffentität.
--- @param _Entity any Skriptname oder ID
--- @param _StartAmount integer Menge an Rohstoffen
--- @param _RefillAmount integer Auffüllmenge (nur Reich des Ostens)
function SetResourceAmount(_Entity, _StartAmount, _RefillAmount)
    return true;
end
API.SetResourceAmount = SetResourceAmount;

