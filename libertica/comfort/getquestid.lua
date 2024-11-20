Lib.Register("comfort/GetQuestID");

function GetQuestID(_Name)
    if type(_Name) == "number" then
        return _Name;
    end
    for Index, Quest in pairs(Quests) do
        if Quest and Index > 0 then
            if Quest.Identifier == _Name then
                return Index;
            end
        end
    end
    return -1;
end
API.GetQuestID = GetQuestID;

