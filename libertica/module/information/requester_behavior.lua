Lib.Register("module/information/Requester_Behavior");

function Goal_Decide(...)
    return B_Goal_Decide:new(...);
end

g_GoalDecideDialogDisplayed = nil;
g_DecisionWindowResult = nil;

B_Goal_Decide = {
    Name = "Goal_Decide",
    Description = {
        en = "Goal: Opens a Yes/No Dialog. The decision dictates the quest result (yes=true, no=false).",
        de = "Ziel: Öffnet einen Ja/Nein-Dialog. Die Entscheidung bestimmt das Quest-Ergebnis (ja=true, nein=false).",
        fr = "Objectif: ouvre une fenêtre de dialogue oui/non. La décision détermine le résultat de la quête (oui=true, non=false).",
    },
    Parameter = {
        { ParameterType.Default, en = "Text",          de = "Text",                fr = "Text", },
        { ParameterType.Default, en = "Title",         de = "Titel",               fr = "Titre", },
        { ParameterType.Custom,  en = "Button labels", de = "Button Beschriftung", fr = "Inscription sur le bouton", },
    },
}

function B_Goal_Decide:GetGoalTable()
    return { Objective.Custom2, { self, self.CustomFunction } }
end

function B_Goal_Decide:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Text = _Parameter
    elseif (_Index == 1) then
        self.Title = _Parameter
    elseif (_Index == 2) then
        self.Buttons = (_Parameter == "Ok/Cancel" or _Parameter == true)
    end
end

function B_Goal_Decide:CustomFunction(_Quest)
    if Framework.IsNetworkGame() then
        return false;
    end
    if IsCinematicEventActive and IsCinematicEventActive(_Quest.ReceivingPlayer) then
        return;
    end
    if g_GoalDecideDialogDisplayed == nil then
        g_GoalDecideDialogDisplayed = true;
        ExecuteLocal(
            [[DialogRequestBox("%s", "%s", function(_Yes) end, %s)]],
            self.Title,
            self.Text,
            (self.Buttons and "true") or "nil"
        );
    end
    local result = g_DecisionWindowResult
    if result ~= nil then
        g_GoalDecideDialogDisplayed = nil;
        g_DecisionWindowResult = nil;
        return result;
    end
end

function B_Goal_Decide:GetCustomData(_Index)
    if _Index == 2 then
        return {"Yes/No", "Ok/Cancel"};
    end
end

function B_Goal_Decide:Debug(_Quest)
    if Framework.IsNetworkGame() then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": Can not be used in multiplayer!");
        return true;
    end
    if _Quest.Visible == true then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": Is supposed to be used in invisible quests!");
        return true;
    end
    return false;
end

function B_Goal_Decide:Reset()
    g_GoalDecideDialogDisplayed = nil;
end

RegisterBehavior(B_Goal_Decide);

-- -------------------------------------------------------------------------- --

