Lib.Require("comfort/IsLocalScript");
Lib.Register("module/io/IOChest_API");

function CreateRandomChest(_Name, _Good, _Min, _Max, _Condition, _Action)
    if IsLocalScript() then
        return;
    end
    if not _Action then
        _Action = _Condition;
        _Condition = nil;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    assert(GetNameOfKeyInTable(Goods, _Good) ~= nil, "Good type is invalid!");
    assert(type(_Min) == "number" and _Min >= 1, "Minimum is to low!");
    _Max = _Max or _Min;
    assert(type(_Max) == "number" or _Max >= 1, "Maximum is to low!");
    assert(_Max >= _Min, "Maximum can not be lower than minimum!");
    Lib.IOChest.Global:CreateRandomChest(_Name, _Good, _Min, _Max, false, false, _Condition, _Action);
end
API.CreateRandomChest = CreateRandomChest;

function CreateRandomTreasure(_Name, _Good, _Min, _Max, _Condition, _Action)
    if IsLocalScript() then
        return;
    end
    if not _Action then
        _Action = _Condition;
        _Condition = nil;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    assert(GetNameOfKeyInTable(Goods, _Good) ~= nil, "Good type is invalid!");
    assert(type(_Min) == "number" and _Min >= 1, "Minimum is to low!");
    _Max = _Max or _Min;
    assert(type(_Max) == "number" or _Max >= 1, "Maximum is to low!");
    assert(_Max >= _Min, "Maximum can not be lower than minimum!");
    Lib.IOChest.Global:CreateRandomChest(_Name, _Good, _Min, _Max, false, true, _Condition, _Action);
end
API.CreateRandomTreasure = CreateRandomTreasure;

function CreateRandomGoldChest(_Name)
    if IsLocalScript() then
        return;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    Lib.IOChest.Global:CreateRandomGoldChest(_Name);
end
API.CreateRandomGoldChest = CreateRandomGoldChest;

function CreateRandomResourceChest(_Name)
    if IsLocalScript() then
        return;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    Lib.IOChest.Global:CreateRandomResourceChest(_Name);
end
API.CreateRandomResourceChest = CreateRandomResourceChest;

function CreateRandomLuxuryChest(_Name)
    if IsLocalScript() then
        return;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    Lib.IOChest.Global:CreateRandomLuxuryChest(_Name);
end
API.CreateRandomLuxuryChest = CreateRandomLuxuryChest;

