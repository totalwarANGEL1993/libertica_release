Lib.Register("comfort/UnlockTitleForPlayer");

function UnlockTitleForPlayer(_PlayerID, _KnightTitle)
    if LockedKnightTitles[_PlayerID] == _KnightTitle then
        LockedKnightTitles[_PlayerID] = nil;
        for KnightTitle = _KnightTitle, #NeedsAndRightsByKnightTitle do
            local TechnologyTable = NeedsAndRightsByKnightTitle[KnightTitle][4];
            if type(TechnologyTable) == "table" then
                UnLockFeaturesForPlayer(_PlayerID, TechnologyTable);
            end
        end
    end
end
API.UnlockTitleForPlayer = UnlockTitleForPlayer;

