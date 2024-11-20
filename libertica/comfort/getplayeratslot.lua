Lib.Register("comfort/GetPlayerAtSlot");

function GetPlayerAtSlot(_SlotID)
    if Network.IsNetworkSlotIDUsed(_SlotID) then
        local CurrentPlayerID = Logic.GetSlotPlayerID(_SlotID);
        if Logic.PlayerGetIsHumanFlag(CurrentPlayerID) then
            return CurrentPlayerID;
        end
    end
    return -1;
end
API.GetSlotPlayerID = GetPlayerAtSlot;

