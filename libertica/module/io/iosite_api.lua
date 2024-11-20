Lib.Require("comfort/IsLocalScript");
Lib.Register("module/io/IOSite_API");

function CreateIOBuildingSite(_Data)
    error(not IsLocalScript(), "Must be used in global script!");
    error(IsExisting(_Data.ScriptName),
          "ScriptName '%s' does not exist!",
          tostring(_Data.ScriptName));
    error(type(_Data.PlayerID) == "number" and (_Data.PlayerID >= 1 and _Data.PlayerID <= 8),
          "PlayerID is wrong!");
    error(GetNameOfKeyInTable(Entities, _Data.Type) ~= nil,
          "Type (%s) is wrong!",
          tostring(_Data.Type));
    error((not _Data.Distance or (type(_Data.Distance) == "number" and _Data.Distance >= 100)),
          "Distance (%s) is wrong or too small!",
          tostring(_Data.Distance));
    error(not _Data.Condition or type(_Data.Condition) == "function",
          "Condition must be a function!");
    error(not _Data.Action or type(_Data.Action) == "function",
          "Action must be a function!");

    error((not _Data.Costs or not _Data.Costs[1]) or GetNameOfKeyInTable(Goods, _Data.Costs[1]),
          "First cost type '%s' is wrong!",
          tostring(_Data.Costs[1]));
    error((not _Data.Costs or not _Data.Costs[2]) or (type(_Data.Costs[2]) == "number" and _Data.Costs[2] > 0),
          "First cost amount must be above 0!",
          tostring(_Data.Costs[1]));
    error((not _Data.Costs or not _Data.Costs[3]) or GetNameOfKeyInTable(Goods, _Data.Costs[3]),
          "Second cost type '%s' is wrong!",
          tostring(_Data.Costs[3]));
    error((not _Data.Costs or not _Data.Costs[4]) or (type(_Data.Costs[4]) == "number" and _Data.Costs[4] > 0),
          "Second cost amount must be above 0!",
          tostring(_Data.Costs[4]));

    Lib.IOMine.Global:CreateIOBuildingSite(_Data);
end
API.CreateIOBuildingSite = CreateIOBuildingSite;

