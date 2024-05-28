Lib.Register("comfort/GetActivePlayers");

function GetActivePlayers()
    local PlayerList = {};
    for i= 1, 8 do
        if Network.IsNetworkSlotIDUsed(i) then
            local PlayerID = Logic.GetSlotPlayerID(i);
            if Logic.PlayerGetIsHumanFlag(PlayerID) and Logic.PlayerGetGameState(PlayerID) ~= 0 then
                table.insert(PlayerList, PlayerID);
            end
        end
    end
    return PlayerList;
end
API.GetActivePlayers = GetActivePlayers;

