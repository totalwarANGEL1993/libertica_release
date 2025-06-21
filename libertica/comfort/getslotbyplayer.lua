Lib.Register("comfort/GetSlotByPlayer");

function GetSlotByPlayer(_PlayerID)
    for i= 1, 8 do
        if Network.IsNetworkSlotIDUsed(i) then
            local CurrentPlayerID = Logic.GetSlotPlayerID(i);
            if  Logic.PlayerGetIsHumanFlag(CurrentPlayerID)
            and CurrentPlayerID == _PlayerID then
                return i;
            end
        end
    end
    return -1;
end
API.GetPlayerSlotID = GetSlotByPlayer;
API.GetSlotByPlayer = GetSlotByPlayer;

