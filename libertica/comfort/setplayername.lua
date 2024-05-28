Lib.Register("comfort/SetPlayerName");

CONST_PLAYER_NAMES = {};

function SetPlayerName(_PlayerID, _Name)
    assert(type(_PlayerID) == "number");
    assert(type(_Name) == "string");
    if not GUI then
        ExecuteLocal(
            [[SetPlayerName(%d, "%s")]],
            _PlayerID,
            _Name
        );
        return;
    end
    GUI_MissionStatistic.PlayerNames[_PlayerID] = _Name
    CONST_PLAYER_NAMES[_PlayerID] = _Name;
end
API.SetPlayerName = SetPlayerName;

