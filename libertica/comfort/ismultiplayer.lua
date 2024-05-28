Lib.Register("comfort/IsMultiplayer");

function IsMultiplayer()
    return Framework.IsNetworkGame();
end
API.IsMultiplayer = IsMultiplayer;

