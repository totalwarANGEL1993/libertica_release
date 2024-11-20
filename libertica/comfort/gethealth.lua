Lib.Register("comfort/GetHealth");

function GetHealth(_Entity)
    local EntityID = GetID(_Entity);
    if IsExisting(EntityID) then
        local MaxHealth = Logic.GetEntityMaxHealth(EntityID);
        local Health = Logic.GetEntityHealth(EntityID);
        return (Health/MaxHealth) * 100;
    end
    return 0;
end
API.GetHealth = GetHealth;

