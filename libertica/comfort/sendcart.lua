Lib.Require("comfort/CreateStock");
Lib.Require("comfort/CreateCartByGoodType");
Lib.Register("comfort/SendCart");

function SendCart(_Position, _PlayerID, _GoodType, _Amount, _CartOverlay, _IgnoreReservation, _Overtake)
    assert(Lib.Loader.IsLocalEnv == false, "Can only be used in global script.");
    local OriginalID = GetID(_Position);
    if not IsExisting(OriginalID) then
        return 0;
    end
    local Orientation = Logic.GetEntityOrientation(OriginalID);
    local ScriptName = Logic.GetEntityName(OriginalID);
    local ID = CreateCartByGoodType(_PlayerID, OriginalID, _GoodType, Orientation, _CartOverlay);
    assert(ID ~= 0, "Cart was not created properly.");
    CreateStock(_PlayerID, _GoodType);
    Logic.HireMerchant(ID, _PlayerID, _GoodType, _Amount, _PlayerID, _IgnoreReservation);
    if _Overtake and Logic.IsBuilding(OriginalID) == 0 then
        Logic.SetEntityName(ID, ScriptName);
        DestroyEntity(OriginalID);
    end
    return ID;
end
API.SendCart = SendCart;

