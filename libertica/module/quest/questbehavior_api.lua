Lib.Register("module/quest/QuestBehavior_API");

function GetEnemySoldierKillsOfPlayer(_PlayerID1, _PlayerID2)
    return Lib.QuestBehavior.Global:GetEnemySoldierKillsOfPlayer(_PlayerID1, _PlayerID2);
end

