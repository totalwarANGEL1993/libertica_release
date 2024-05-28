Lib.Require("comfort/IsLocalScript");
Lib.Register("module/io/IOMine_API");

function CreateIOIronMine(_Data)
    local Costs = {Goods.G_Gold, 500, Goods.G_Wood, 20};
    CheckIOMineParameter(_Data);
    Lib.IOMine.Global:CreateIOMine(
        _Data.Scriptname,
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
        _Data.Scriptname,
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
          "API.CreateIOIronMine: Scriptname '%s' does not exist!",
          tostring(_Data.Scriptname));
    local Costs = {Goods.G_Gold, 500, Goods.G_Wood, 20};
    if _Data.Costs then
        if _Data.Costs[1] then
            error(
                GetNameOfKeyInTable(Goods, _Data.Costs[1]),
                "API.CreateIOIronMine: First cost type '%s' is wrong!",
                tostring(_Data.Costs[1])
            );
            error(
                _Data.Costs[2] and (type(_Data.Costs[2]) == "number" or _Data.Costs[2] < 1),
                "API.CreateIOIronMine: First cost amount must be above 0!"
            );
        end
        if _Data.Costs[3] then
            error(
                GetNameOfKeyInTable(Goods, _Data.Costs[3]),
                "API.CreateIOIronMine: First cost type '%s' is wrong!",
                tostring(_Data.Costs[3])
            );
            error(
                _Data.Costs[4] and (type(_Data.Costs[4]) == "number" or _Data.Costs[4] < 1),
                "API.CreateIOIronMine: First cost amount must be above 0!"
            );
        end
    end
end

