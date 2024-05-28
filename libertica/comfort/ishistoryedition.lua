Lib.Register("comfort/IsHistoryEdition");

function IsHistoryEdition()
    return Network.IsNATReady ~= nil;
end
API.IsHistoryEdition = IsHistoryEdition;

