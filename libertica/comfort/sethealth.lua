Lib.Register("comfort/SetHealth");

function SetHealth(_Entity, _Health)
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    assert(type(_Health) == "number" and _Health >= 0);

    local EntityID = GetID(_Entity);
    assert(EntityID ~= 0, "Entity does not exist.");
    assert(Logic.IsLeader(EntityID) == 0, "Can not be used on groups.");
    local MaxHealth = Logic.GetEntityMaxHealth(EntityID);
    local Health = math.max(math.min(_Health, MaxHealth), 0);
    local OldHealth = Logic.GetEntityHealth(EntityID);
    local NewHealth = math.ceil((MaxHealth) * (Health/100));

    if NewHealth > OldHealth then
        Logic.HealEntity(EntityID, NewHealth - OldHealth);
    elseif NewHealth < OldHealth then
        Logic.HurtEntity(EntityID, OldHealth - NewHealth);
    end
end
API.SetHealth = SetHealth;

