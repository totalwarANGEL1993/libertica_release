Lib.Register("comfort/CreateEntityName");

CreateEntityName_Sequence_ID = 0;

function CreateEntityName(_EntityID)
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    if type(_EntityID) == "string" then
        return _EntityID;
    else
        assert(type(_EntityID) == "number", "Invalid entity ID.");
        local name = Logic.GetEntityName(_EntityID);
        if (type(name) ~= "string" or name == "" ) then
            CreateEntityName_Sequence_ID = CreateEntityName_Sequence_ID + 1;
            name = "AutomaticScriptName_"..CreateEntityName_Sequence_ID;
            Logic.SetEntityName(_EntityID, name);
        end
        return name;
    end
end
API.EnsureScriptName = CreateEntityName;
API.CreateEntityName = CreateEntityName;

