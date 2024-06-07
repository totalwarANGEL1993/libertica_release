Lib.Register("module/entity/NPC_Behavior");

function Goal_NPC(_NpcName, _HeroName)
    return B_Goal_NPC:new(_NpcName, _HeroName);
end

B_Goal_NPC = {
    Name             = "Goal_NPC",
    Description     = {
        en = "Goal: The hero has to talk to a non-player character.",
        de = "Ziel: Der Held muss einen Nichtspielercharakter ansprechen.",
        fr = "Objectif: le héros doit interpeller un personnage non joueur.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "NPC",  de = "NPC",  fr = "NPC" },
        { ParameterType.ScriptName, en = "Hero", de = "Held", fr = "Héro" },
    },
}

function B_Goal_NPC:GetGoalTable()
    return {Objective.Distance, -65565, self.Hero, self.NPC, self}
end

function B_Goal_NPC:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.NPC = _Parameter
    elseif (_Index == 1) then
        self.Hero = _Parameter
        if self.Hero == "-" then
            self.Hero = nil
        end
   end
end

function B_Goal_NPC:GetIcon()
    return {14,10}
end

RegisterBehavior(B_Goal_NPC);

-- -------------------------------------------------------------------------- --

