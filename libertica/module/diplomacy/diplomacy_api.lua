Lib.Require("comfort/IsLocalScript");
Lib.Register("module/diplomacy/Diplomacy_API");

function SetDiplomacyStateForPlayer(_PlayerID, _State, ...)
    local PlayerList = #{...} == 0 and {1,2,3,4,5,6,7,8} or {...};
    error(not IsLocalScript(), "Can not be used in local script!");
    Lib.Diplomacy.Global:SetDiplomacyStateForPlayer(_PlayerID, _State, PlayerList);
end

function SetDiplomacyStateForPlayers(_State, ...)
    local PlayerList = {1,2,3,4,5,6,7,8};
    error(not IsLocalScript(), "Can not be used in local script!");
    for i= 1, #PlayerList do
        Lib.Diplomacy.Global:SetDiplomacyStateForPlayer(PlayerList[i], _State, PlayerList);
    end
end

function SaveDiplomacyStates()
    error(not IsLocalScript(), "Can not be used in local script!");
    Lib.Diplomacy.Global:SaveDiplomacy();
end

function ResetDiplomacyStates()
    error(not IsLocalScript(), "Can not be used in local script!");
    Lib.Diplomacy.Global:ResetDiplomacy();
end

