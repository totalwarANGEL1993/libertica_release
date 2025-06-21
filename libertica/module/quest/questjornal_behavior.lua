Lib.Register("module/quest/QuestJornal_Behavior");

CONST_JORNAL_ENTRY_TO_QUEST = {};
CONST_JORNAL_ENTRY_TO_ID = {};

function Reprisal_JournalEnable(...)
    return B_Reprisal_JournalEnable:new(...);
end

B_Reprisal_JournalEnable = {
    Name = "Reprisal_JournalEnable",
    Description = {
        en = "Reprisal: Displays the journal for a quest or hides it.",
        de = "Vergeltung: Zeigt das Tagebuch für einen Quest an oder versteckt es.",
        fr = "Rétribution: Affiche ou cache le journal pour une quête.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name",     de = "Name Quest",     fr = "Nom de la quête" },
        { ParameterType.Custom,    en = "Journal active", de = "Tagebuch aktiv", fr = "Journal actif" },
    },
}

function B_Reprisal_JournalEnable:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} };
end

function B_Reprisal_JournalEnable:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
    elseif (_Index == 1) then
        self.ActiveFlag = API.ToBoolean(_Parameter);
    end
end

function B_Reprisal_JournalEnable:CustomFunction(_Quest)
    API.ShowJournalForQuest(self.QuestName, self.ActiveFlag == true);
end

function B_Reprisal_JournalEnable:Debug(_Quest)
    if not API.IsValidQuest(GetQuestID(self.QuestName)) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": quest '" ..tostring(self.QuestName).."' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_JournalEnable);

-- -------------------------------------------------------------------------- --

function Reward_JournalEnable(...)
    return B_Reward_JournalEnable:new(...);
end

B_Reward_JournalEnable = CopyTable(B_Reprisal_JournalEnable);
B_Reward_JournalEnable.Name = "Reward_JournalEnable";
B_Reward_JournalEnable.Description.en = "Reward: Displays the journal for a quest or hides it.";
B_Reward_JournalEnable.Description.de = "Lohn: Zeigt das Tagebuch für einen Quest an oder versteckt es.";
B_Reward_JournalEnable.Description.fr = "Récompense: Affiche ou cache le journal d'une quête.";
B_Reward_JournalEnable.GetReprisalTable = nil;

B_Reward_JournalEnable.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

RegisterBehavior(B_Reward_JournalEnable);

-- -------------------------------------------------------------------------- --

function Reprisal_JournalWrite(...)
    return B_Reprisal_JournalWrite:new(...);
end

B_Reprisal_JournalWrite = {
    Name = "Reprisal_JournalWrite",
    Description = {
        en = "Reprisal: Adds or alters a journal entry to a quest.",
        de = "Vergeltung: Schreibt oder ändert einen Tagebucheintrag.",
        fr = "Rétribution: Écrit ou modifie une entrée de journal.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Name Quest",   fr = "Nom de la quête" },
        { ParameterType.Default,   en = "Entry name", de = "Name Eintrag", fr = "Nom de l'entrée" },
        { ParameterType.Default,   en = "Entry text", de = "Text Eintrag", fr = "Texte de l'entrée" },
    },
}

function B_Reprisal_JournalWrite:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} };
end

function B_Reprisal_JournalWrite:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
    elseif (_Index == 1) then
        self.EntryName = _Parameter;
    elseif (_Index == 2) then
        self.EntryText = _Parameter;
    end
end

function B_Reprisal_JournalWrite:CustomFunction(_Quest)
    if CONST_JORNAL_ENTRY_TO_QUEST[self.EntryName] then
        local EntryID = CONST_JORNAL_ENTRY_TO_ID[self.EntryName];
        API.AlterJournalEntry(EntryID, self.EntryText);
    else
        local EntryID = API.CreateJournalEntry(self.EntryText);
        API.AddJournalEntryToQuest(EntryID, self.QuestName);
        CONST_JORNAL_ENTRY_TO_QUEST[self.EntryName] = self.QuestName;
        CONST_JORNAL_ENTRY_TO_ID[self.EntryName] = EntryID;
    end
end

function B_Reprisal_JournalWrite:Debug(_Quest)
    if not API.IsValidQuest(GetQuestID(self.QuestName)) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": quest '" ..tostring(self.QuestName).."' does not exist!");
        return true;
    end
    if CONST_JORNAL_ENTRY_TO_QUEST[self.EntryName] ~= self.QuestName then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entry name '" ..tostring(self.EntryName).."' is already in use in another quest!");
        return true;
    end
    if not CONST_JORNAL_ENTRY_TO_ID[self.EntryName] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entry '" ..tostring(self.EntryName).."' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_JournalWrite);

-- -------------------------------------------------------------------------- --

function Reward_JournalWrite(...)
    return B_Reward_JournalWrite:new(...);
end

B_Reward_JournalWrite = CopyTable(B_Reprisal_JournalWrite);
B_Reward_JournalWrite.Name = "Reward_JournalWrite";
B_Reward_JournalWrite.Description.en = "Reward: Adds or alters a journal entry to a quest.";
B_Reward_JournalWrite.Description.de = "Lohn: Schreibt oder ändert einen Tagebucheintrag.";
B_Reward_JournalWrite.Description.fr = "Récompense: Écrit ou modifie une entrée de journal.";
B_Reward_JournalWrite.GetReprisalTable = nil;

B_Reward_JournalWrite.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

RegisterBehavior(B_Reward_JournalWrite);

-- -------------------------------------------------------------------------- --

function Reprisal_JournalRemove(...)
    return B_Reprisal_JournalRemove:new(...);
end

B_Reprisal_JournalRemove = {
    Name = "Reprisal_JournalRemove",
    Description = {
        en = "Reprisal: Remove a journal entry from a quest.",
        de = "Vergeltung: Entfernt einen Tagebucheintrag vom Quest.",
        fr = "Rétribution: Supprime une entrée de journal de la quête.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Name Quest",   fr = "Nom de la quête" },
        { ParameterType.Default,   en = "Entry name", de = "Name Eintrag", fr = "Nom de l'entrée" },
    },
}

function B_Reprisal_JournalRemove:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} };
end

function B_Reprisal_JournalRemove:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
    elseif (_Index == 1) then
        self.EntryName = _Parameter;
    end
end

function B_Reprisal_JournalRemove:CustomFunction(_Quest)
    if CONST_JORNAL_ENTRY_TO_QUEST[self.EntryName] then
        local EntryID = CONST_JORNAL_ENTRY_TO_ID[self.EntryName];
        API.RemoveJournalEntryFromQuest(EntryID, self.QuestName);
        API.DeleteJournalEntry(EntryID);
        CONST_JORNAL_ENTRY_TO_QUEST[self.EntryName] = nil;
        CONST_JORNAL_ENTRY_TO_ID[self.EntryName] = nil;
    end
end

function B_Reprisal_JournalRemove:Debug(_Quest)
    if not API.IsValidQuest(GetQuestID(self.QuestName)) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": quest '" ..tostring(self.QuestName).."' does not exist!");
        return true;
    end
    if CONST_JORNAL_ENTRY_TO_QUEST[self.EntryName] ~= self.QuestName then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entry name '" ..tostring(self.EntryName).."' is already in use in another quest!");
        return true;
    end
    if not CONST_JORNAL_ENTRY_TO_ID[self.EntryName] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entry '" ..tostring(self.EntryName).."' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_JournalRemove);

-- -------------------------------------------------------------------------- --

function Reward_JournalRemove(...)
    return B_Reward_JournalRemove:new(...);
end

B_Reward_JournalRemove = CopyTable(B_Reprisal_JournalRemove);
B_Reward_JournalRemove.Name = "Reward_JournalRemove";
B_Reward_JournalRemove.Description.en = "Reward: Remove a journal entry from a quest.";
B_Reward_JournalRemove.Description.de = "Lohn: Entfernt einen Tagebucheintrag vom Quest.";
B_Reward_JournalRemove.Description.fr = "Récompense: Supprime une entrée de journal de la quête.";
B_Reward_JournalRemove.GetReprisalTable = nil;

B_Reward_JournalRemove.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

RegisterBehavior(B_Reward_JournalRemove);

-- -------------------------------------------------------------------------- --

function Reprisal_JournaHighlight(...)
    return B_Reprisal_JournaHighlight:new(...);
end

B_Reprisal_JournaHighlight = {
    Name = "Reprisal_JournaHighlight",
    Description = {
        en = "Reprisal: Highlights or unhighlights a journal entry of a quest.",
        de = "Vergeltung: Hebt einen Tagebucheintrag hevor oder hebt die Hervorhebung auf.",
        fr = "Rétribution: met en valeur ou annule la mise en valeur d'une entrée de journal.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name",      de = "Name Quest",   fr= "Nom de la quête" },
        { ParameterType.Default,   en = "Name of entry",   de = "Name Eintrag", fr= "Nom de l'entrée" },
        { ParameterType.Custom,    en = "Highlight entry", de = "Hebe hervor",  fr= "Mettre en valeur" },
    },
}

function B_Reprisal_JournaHighlight:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} };
end

function B_Reprisal_JournaHighlight:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
    elseif (_Index == 1) then
        self.EntryName = _Parameter;
    elseif (_Index == 2) then
        self.IsImportant = API.ToBoolean(_Parameter);
    end
end

function B_Reprisal_JournaHighlight:GetCustomData(_Index)
    return {"true","false"};
end

function B_Reprisal_JournaHighlight:CustomFunction(_Quest)
    if CONST_JORNAL_ENTRY_TO_QUEST[self.EntryName] then
        local EntryID = CONST_JORNAL_ENTRY_TO_ID[self.EntryName];
        API.HighlightJournalEntry(EntryID, self.IsImportant == true);
    end
end

function B_Reprisal_JournaHighlight:Debug(_Quest)
    if not API.IsValidQuest(GetQuestID(self.QuestName)) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": quest '" ..tostring(self.QuestName).."' does not exist!");
        return true;
    end
    if CONST_JORNAL_ENTRY_TO_QUEST[self.EntryName] ~= self.QuestName then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entry name '" ..tostring(self.EntryName).."' is not mapped to the quest!");
        return true;
    end
    if not CONST_JORNAL_ENTRY_TO_ID[self.EntryName] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entry '" ..tostring(self.EntryName).."' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_JournaHighlight);

-- -------------------------------------------------------------------------- --

function Reward_JournaHighlight(...)
    return B_Reward_JournaHighlight:new(...);
end

B_Reward_JournaHighlight = CopyTable(B_Reprisal_JournaHighlight);
B_Reward_JournaHighlight.Name = "Reward_JournaHighlight";
B_Reward_JournaHighlight.Description.en = "Reward: Highlights or unhighlights a journal entry of a quest.";
B_Reward_JournaHighlight.Description.de = "Lohn: Hebt einen Tagebucheintrag hevor oder hebt die Hervorhebung auf.";
B_Reward_JournaHighlight.Description.fr = "Récompense: met en valeur ou annule la mise en valeur d'une entrée de journal.";
B_Reward_JournaHighlight.GetReprisalTable = nil;

B_Reward_JournaHighlight.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

RegisterBehavior(B_Reward_JournaHighlight);

-- -------------------------------------------------------------------------- --

