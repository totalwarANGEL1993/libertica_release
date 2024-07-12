Lib.Register("comfort/IsValidQuestName");

CONST_REGEX_QUEST_NAME = "^[A-Za-z0-9_ @ÄÖÜäöüß]+$";

function IsValidQuestName(_Name)
    return string.find(_Name, CONST_REGEX_QUEST_NAME) ~= nil;
end
API.IsValidQuestName = IsValidQuestName;

