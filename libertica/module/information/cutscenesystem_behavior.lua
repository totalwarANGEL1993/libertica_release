Lib.Register("module/information/CutsceneSystem_Behavior");

function Reprisal_Cutscene(...)
    return B_Reprisal_Cutscene:new(...);
end

B_Reprisal_Cutscene = {
    Name = "Reprisal_Cutscene",
    Description = {
        en = "Reprisal: Calls a function to start an new Cutscene.",
        de = "Vergeltung: Ruft die Funktion auf und startet die enthaltene Cutscene.",
        fr = "Rétribution : Appelle la fonction et démarre la cutscene contenue.",
    },
    Parameter = {
        { ParameterType.Default, en = "Cutscene name",     de = "Name der Cutscene",     fr = "Nom de la cutscene", },
        { ParameterType.Default, en = "Cutscene function", de = "Funktion mit Cutscene", fr = "Fonction avec cutscene", },
    },
}

function B_Reprisal_Cutscene:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} }
end

function B_Reprisal_Cutscene:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.CutsceneName = _Parameter;
    elseif (_Index == 1) then
        self.Function = _Parameter;
    end
end

function B_Reprisal_Cutscene:CustomFunction(_Quest)
    _G[self.Function](self.CutsceneName, _Quest.ReceivingPlayer);
end

function B_Reprisal_Cutscene:Debug(_Quest)
    if self.CutsceneName == nil or self.CutsceneName == "" then
        debug(false, string.format("%s: %s: Dialog name is invalid!", _Quest.Identifier, self.Name));
        return true;
    end
    if not type(_G[self.Function]) == "function" then
        debug(false, _Quest.Identifier..": "..self.Name..": '"..self.Function.."' was not found!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_Cutscene);

-- -------------------------------------------------------------------------- --

function Reward_Cutscene(...)
    return B_Reward_Cutscene:new(...);
end

B_Reward_Cutscene = CopyTable(B_Reprisal_Cutscene);
B_Reward_Cutscene.Name = "Reward_Cutscene";
B_Reward_Cutscene.Description.en = "Reward: Calls a function to start an new Cutscene.";
B_Reward_Cutscene.Description.de = "Lohn: Ruft die Funktion auf und startet die enthaltene Cutscene.";
B_Reward_Cutscene.Description.fr = "Récompense: Appelle la fonction et démarre la cutscene contenue.";
B_Reward_Cutscene.GetReprisalTable = nil;

B_Reward_Cutscene.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, {self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_Cutscene);

-- -------------------------------------------------------------------------- --

function Trigger_Cutscene(...)
    return B_Trigger_Cutscene:new(...);
end

B_Trigger_Cutscene = {
    Name = "Trigger_Cutscene",
    Description = {
        en = "Trigger: Checks if an Cutscene has concluded and starts the quest if so.",
        de = "Auslöser: Prüft, ob eine Cutscene beendet ist und startet dann den Quest.",
        fr = "Déclencheur: Vérifie si une cutscene est terminée et démarre ensuite la quête.",
    },
    Parameter = {
        { ParameterType.Default,  en = "Cutscene name", de = "Name der Cutscene", fr  ="Nom de la cutscene" },
        { ParameterType.PlayerID, en = "Player ID",     de = "Player ID",         fr  ="Player ID" },
        { ParameterType.Number,   en = "Wait time",     de = "Wartezeit",         fr  ="Temps d'attente" },
    },
}

function B_Trigger_Cutscene:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_Cutscene:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.CutsceneName = _Parameter;
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1;
    elseif (_Index == 2) then
        _Parameter = _Parameter or 0;
        self.WaitTime = _Parameter * 1;
    end
end

function B_Trigger_Cutscene:CustomFunction(_Quest)
    if GetCinematicEvent(self.CutsceneName, self.PlayerID) == CinematicEventState.Concluded then
        if self.WaitTime and self.WaitTime > 0 then
            self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
            if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                return true;
            end
        else
            return true;
        end
    end
    return false;
end

function B_Trigger_Cutscene:Debug(_Quest)
    if self.WaitTime < 0 then
        debug(false, string.format("%s: %s: Wait time must be 0 or greater!", _Quest.Identifier, self.Name));
        return true;
    end
    if self.PlayerID < 1 or self.PlayerID > 8 then
        debug(false, string.format("%s: %s: Player-ID must be between 1 and 8!", _Quest.Identifier, self.Name));
        return true;
    end
    if self.CutsceneName == nil or self.CutsceneName == "" then
        debug(false, string.format("%s: %s: Dialog name is invalid!", _Quest.Identifier, self.Name));
        return true;
    end
    return false;
end

RegisterBehavior(B_Trigger_Cutscene);

-- -------------------------------------------------------------------------- --

