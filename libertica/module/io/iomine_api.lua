Lib.Require("comfort/IsLocalScript");
Lib.Register("module/io/IOMine_API");

function CreateIOIronMine(_Data)
    local Costs = {Goods.G_Gold, 500, Goods.G_Wood, 20};
    CheckIOMineParameter(_Data);
    Lib.IOMine.Global:CreateIOMine(
        _Data.ScriptName,
        Entities.R_IronMine,
        _Data.Title,
        _Data.Text,
        _Data.Costs or Costs,
        _Data.ResourceAmount,
        _Data.RefillAmount,
        _Data.ConstructionCondition,
        _Data.ConditionInfo,
        _Data.ConstructionAction
    );
end
API.CreateIOIronMine = CreateIOIronMine;

function CreateIOStoneMine(_Data)
    local Costs = {Goods.G_Gold, 500, Goods.G_Wood, 20};
    CheckIOMineParameter(_Data);
    Lib.IOMine.Global:CreateIOMine(
        _Data.ScriptName,
        Entities.R_StoneMine,
        _Data.Title,
        _Data.Text,
        _Data.Costs or Costs,
        _Data.ResourceAmount,
        _Data.RefillAmount,
        _Data.ConstructionCondition,
        _Data.ConditionInfo,
        _Data.ConstructionAction
    );
end
API.CreateIOStoneMine = CreateIOStoneMine;

function CheckIOMineParameter(_Data)
    error(not IsLocalScript(), "Must be used in global script!");
    error(IsExisting(_Data.Scriptname),
          "Scriptname '%s' does not exist!",
          tostring(_Data.Scriptname));

    if not _Data.Costs then
        return;
    end
    error(not _Data.Costs[1] or GetNameOfKeyInTable(Goods, _Data.Costs[1]),
          "First cost type '%s' is wrong!",
          tostring(_Data.Costs[1]));
    error(not _Data.Costs[2] or (type(_Data.Costs[2]) == "number" and _Data.Costs[2] > 0),
          "First cost amount must be above 0!",
          tostring(_Data.Costs[1]));
    error(not _Data.Costs[3] or GetNameOfKeyInTable(Goods, _Data.Costs[3]),
          "Second cost type '%s' is wrong!",
          tostring(_Data.Costs[3]));
    error(not _Data.Costs[4] or (type(_Data.Costs[4]) == "number" and _Data.Costs[4] > 0),
          "Second cost amount must be above 0!",
          tostring(_Data.Costs[4]));
end

