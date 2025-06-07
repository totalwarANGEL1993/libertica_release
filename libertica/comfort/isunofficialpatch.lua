Lib.Register("comfort/IsUnofficialPatch");

function IsUnofficialPatch()
    return g_UnofficialPatchVersion ~= nil;
end
API.IsUnofficialPatch = IsUnofficialPatch;

