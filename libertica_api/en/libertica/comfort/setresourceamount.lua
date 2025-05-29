--- Changes the resource amount in a resouce entity.

--- Changes the resource amount in a resouce entity.
--- @param _Entity any Scriptname or ID
--- @param _StartAmount integer Amount of resources
--- @param _RefillAmount integer Refill amount (only Addon)
function SetResourceAmount(_Entity, _StartAmount, _RefillAmount)
    return true;
end
API.SetResourceAmount = SetResourceAmount;

