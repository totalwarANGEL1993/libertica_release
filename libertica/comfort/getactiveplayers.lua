Lib.Register("comfort/GetActivePlayers");

function GetActivePlayers()
    local PlayerList = {};
    for PlayerID = 1, 8 do
        if Network.IsNetworkSlotIDUsed(PlayerID) then
            local SlotPlayerID = Logic.GetSlotPlayerID(PlayerID);
            if Logic.PlayerGetIsHumanFlag(SlotPlayerID) and Logic.PlayerGetGameState(SlotPlayerID) ~= 0 then
                table.insert(PlayerList, SlotPlayerID);
            end
        end
    end
    return PlayerList;
end
API.GetActivePlayers = GetActivePlayers;

