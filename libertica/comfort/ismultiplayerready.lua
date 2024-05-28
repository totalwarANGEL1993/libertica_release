Lib.Register("comfort/IsMultiplayerReady");

function IsMultiplayerReady()
    return Framework.IsNetworkGame() and Network.SessionHaveAllPlayersFinishedLoading() == true;
end
API.IsMultiplayerReady = IsMultiplayerReady;

