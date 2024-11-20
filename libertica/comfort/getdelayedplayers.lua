Lib.Require("comfort/GetActivePlayers");
Lib.Require("comfort/GetSlotByPlayer");
Lib.Register("comfort/GetDelayedPlayers");

function GetDelayedPlayers()
    local PlayerList = {};
    for _, PlayerID in pairs(GetActivePlayers()) do
        if Network.IsWaitingForNetworkSlotID(GetSlotByPlayer(PlayerID)) then
            table.insert(PlayerList, PlayerID);
        end
    end
    return PlayerList;
end
API.GetDelayedPlayers = GetDelayedPlayers;

