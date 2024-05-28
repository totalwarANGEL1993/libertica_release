Lib.Require("comfort/GetActivePlayers");
Lib.Register("comfort/GetDelayedPlayers");

function GetDelayedPlayers()
    local PlayerList = {};
    for k, v in pairs(GetActivePlayers()) do
        if Network.IsWaitingForNetworkSlotID(API.GetPlayerSlotID(v)) then
            table.insert(PlayerList, v);
        end
    end
    return PlayerList;
end
API.GetDelayedPlayers = GetDelayedPlayers;

