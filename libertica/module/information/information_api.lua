Lib.Require("comfort/IsMultiplayer");
Lib.Register("module/information/Information_API");

Lib.Information = Lib.Information or {};

function StartCinematicEvent(_Name, _PlayerID)
    assert(IsLocalScript() == false);
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    Lib.Information.CinematicEvents[_PlayerID] = Lib.Information.CinematicEvents[_PlayerID] or {};
    local ID = Lib.Information.Global:ActivateCinematicEvent(_PlayerID);
    Lib.Information.CinematicEvents[_PlayerID][_Name] = ID;
end
API.StartCinematicEvent = StartCinematicEvent;

function FinishCinematicEvent(_Name, _PlayerID)
    assert(IsLocalScript() == false);
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    Lib.Information.CinematicEvents[_PlayerID] = Lib.Information.CinematicEvents[_PlayerID] or {};
    if Lib.Information.CinematicEvents[_PlayerID][_Name] then
        Lib.Information.Global:ConcludeCinematicEvent(
            Lib.Information.CinematicEvents[_PlayerID][_Name],
            _PlayerID
        );
    end
end
API.FinishCinematicEvent = FinishCinematicEvent;

function GetCinematicEvent(_Identifier, _PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    Lib.Information.CinematicEvents[_PlayerID] = Lib.Information.CinematicEvents[_PlayerID] or {};
    if type(_Identifier) == "number" then
        if IsLocalScript() then
            return Lib.Information.Local:GetCinematicEventStatus(_Identifier);
        end
        return Lib.Information.Global:GetCinematicEventStatus(_Identifier);
    end
    if Lib.Information.CinematicEvents[_PlayerID][_Identifier] then
        if IsLocalScript() then
            return Lib.Information.Local:GetCinematicEventStatus(Lib.Information.CinematicEvents[_PlayerID][_Identifier]);
        end
        return Lib.Information.Global:GetCinematicEventStatus(Lib.Information.CinematicEvents[_PlayerID][_Identifier]);
    end
    return CinematicEventState.NotTriggered;
end
API.GetCinematicEvent = GetCinematicEvent;

function IsCinematicEventActive(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    Lib.Information.CinematicEvents[_PlayerID] = Lib.Information.CinematicEvents[_PlayerID] or {};
    for k, v in pairs(Lib.Information.CinematicEvents[_PlayerID]) do
        if GetCinematicEvent(k, _PlayerID) == CinematicEventState.Active then
            return true;
        end
    end
    return false;
end
API.IsCinematicEventActive = IsCinematicEventActive;

