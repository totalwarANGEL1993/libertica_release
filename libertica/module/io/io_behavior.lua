Lib.Register("module/io/IO_Behavior");

function Goal_ActivateSeveralObjects(...)
    return B_Goal_ActivateSeveralObjects:new(...);
end

B_Goal_ActivateSeveralObjects = {
    Name = "Goal_ActivateSeveralObjects",
    Description = {
        en = "Goal: Activate an interactive object",
        de = "Ziel: Aktiviere ein interaktives Objekt",
        fr = "Objectif: activer un objet interactif",
    },
    Parameter = {
        { ParameterType.Default, en = "Object name 1", de = "Skriptname 1", fr = "Nom de l'entité 1" },
        { ParameterType.Default, en = "Object name 2", de = "Skriptname 2", fr = "Nom de l'entité 2" },
        { ParameterType.Default, en = "Object name 3", de = "Skriptname 3", fr = "Nom de l'entité 3" },
        { ParameterType.Default, en = "Object name 4", de = "Skriptname 4", fr = "Nom de l'entité 4" },
    },
    ScriptNames = {};
}

function B_Goal_ActivateSeveralObjects:GetGoalTable()
    return {Objective.Object, { unpack(self.ScriptNames) } }
end

function B_Goal_ActivateSeveralObjects:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        assert(_Parameter ~= nil and _Parameter ~= "", "Goal_ActivateSeveralObjects: At least one IO needed!");
    end
    if _Parameter ~= nil and _Parameter ~= "" then
        table.insert(self.ScriptNames, _Parameter);
    end
end

function B_Goal_ActivateSeveralObjects:GetMsgKey()
    return "Quest_Object_Activate"
end

RegisterBehavior(B_Goal_ActivateSeveralObjects);

-- -------------------------------------------------------------------------- --

--- @diagnostic disable-next-line: duplicate-set-field
B_Reward_ObjectInit.CustomFunction = function(self, _Quest)
    local EntityID = GetID(self.ScriptName);
    if EntityID == 0 then
        return;
    end
    CONST_INITIALIZED_OBJECTS[EntityID] = _Quest.Identifier;

    local GoodReward;
    if self.RewardType and self.RewardType ~= "-" then
        GoodReward = {Goods[self.RewardType], self.RewardAmount};
    end

    local GoodCosts;
    if self.FirstCostType and self.FirstCostType ~= "-" then
        GoodCosts = GoodReward or {};
        table.insert(GoodCosts, Goods[self.FirstCostType]);
        table.insert(GoodCosts, Goods[self.FirstCostAmount]);
    end
    if self.SecondCostType and self.SecondCostType ~= "-" then
        GoodCosts = GoodReward or {};
        table.insert(GoodCosts, Goods[self.SecondCostType]);
        table.insert(GoodCosts, Goods[self.SecondCostAmount]);
    end

    SetupObject {
        Name                   = self.ScriptName,
        Distance               = self.Distance,
        Waittime               = self.Waittime,
        Reward                 = GoodReward,
        Costs                  = GoodCosts,
    };
    InteractiveObjectActivate(self.ScriptName, self.UsingState);
end

-- -------------------------------------------------------------------------- --

