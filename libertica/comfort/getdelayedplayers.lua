Lib.Require("comfort/GetActivePlayers");
Lib.Register("comfort/GetDelayedPlayers");

function GetDelayedPlayers()
    local PlayerList = {};
    for _, PlayerID in pairs(GetActivePlayers()) do
        if Network.IsWaitingForNetworkSlotID(API.GetPlayerSlotID(PlayerID)) then
            table.insert(PlayerList, PlayerID);
        end
    end
    return PlayerList;
end
API.GetDelayedPlayers = GetDelayedPlayers;

