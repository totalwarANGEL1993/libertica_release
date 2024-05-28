Lib.Register("comfort/global/GetQuestID");

function GetQuestID(_Name)
    if type(_Name) == "number" then
        return _Name;
    end
    for k, v in pairs(Quests) do
        if v and k > 0 then
            if v.Identifier == _Name then
                return k;
            end
        end
    end
    return -1;
end
API.GetQuestID = GetQuestID;

