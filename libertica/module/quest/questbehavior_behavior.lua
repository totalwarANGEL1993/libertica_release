Lib.Register("module/quest/QuestBehavior_Behavior");

function Goal_MoveToPosition(...)
    return B_Goal_MoveToPosition:new(...);
end

B_Goal_MoveToPosition = {
    Name = "Goal_MoveToPosition",
    Description = {
        en = "Goal: A entity have to moved as close as the distance to another entity. The target can be marked with a static marker.",
        de = "Ziel: Ein Entity muss sich einer anderen bis auf eine bestimmte Distanz nähern. Die Lupe wird angezeigt, das Ziel kann markiert werden.",
        fr = "Objectif: une entité doit s'approcher d'une autre à une distance donnée. La loupe est affichée, la cible peut être marquée.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",   de = "Entity",         fr = "Entité" },
        { ParameterType.ScriptName, en = "Target",   de = "Ziel",           fr = "Cible" },
        { ParameterType.Number,     en = "Distance", de = "Entfernung",     fr = "Distance" },
        { ParameterType.Custom,     en = "Marker",   de = "Ziel markieren", fr = "Marquer la cible" },
    },
}

function B_Goal_MoveToPosition:GetGoalTable()
    return {Objective.Distance, self.Entity, self.Target, self.Distance, self.Marker}
end

function B_Goal_MoveToPosition:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Entity = _Parameter
    elseif (_Index == 1) then
        self.Target = _Parameter
    elseif (_Index == 2) then
        self.Distance = _Parameter * 1
    elseif (_Index == 3) then
        self.Marker = ToBoolean(_Parameter)
    end
end

function B_Goal_MoveToPosition:GetCustomData( _Index )
    local Data = {};
    if _Index == 3 then
        Data = {"true", "false"}
    end
    return Data
end

RegisterBehavior(B_Goal_MoveToPosition);

-- -------------------------------------------------------------------------- --

function Goal_AmmunitionAmount(...)
    return B_Goal_AmmunitionAmount:new(...);
end

B_Goal_AmmunitionAmount = {
    Name = "Goal_AmmunitionAmount",
    Description = {
        en = "Goal: Reach a smaller or bigger value than the given amount of ammunition in a war machine.",
        de = "Ziel: Über- oder unterschreite die angegebene Anzahl Munition in einem Kriegsgerät.",
        fr = "Objectif : Dépasser ou ne pas dépasser le nombre de munitions indiqué dans un engin de guerre.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname",  fr = "Nom de l'entité" },
        { ParameterType.Custom,     en = "Relation",    de = "Relation",    fr = "Relation" },
        { ParameterType.Number,     en = "Amount",      de = "Menge",       fr = "Quantité" },
    },
}

function B_Goal_AmmunitionAmount:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_AmmunitionAmount:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Scriptname = _Parameter
    elseif (_Index == 1) then
        self.bRelSmallerThan = tostring(_Parameter) == "true" or _Parameter == "<"
    elseif (_Index == 2) then
        self.Amount = _Parameter * 1
    end
end

function B_Goal_AmmunitionAmount:CustomFunction()
    local EntityID = GetID(self.Scriptname);
    if not IsExisting(EntityID) then
        return false;
    end
    local HaveAmount = Logic.GetAmmunitionAmount(EntityID);
    if ( self.bRelSmallerThan and HaveAmount < self.Amount ) or ( not self.bRelSmallerThan and HaveAmount >= self.Amount ) then
        return true;
    end
    return nil;
end

function B_Goal_AmmunitionAmount:Debug(_Quest)
    if self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Amount is negative");
        return true
    end
end

function B_Goal_AmmunitionAmount:GetCustomData( _Index )
    if _Index == 1 then
        return {"<", ">="};
    end
end

RegisterBehavior(B_Goal_AmmunitionAmount);

-- -------------------------------------------------------------------------- --

function Goal_CityReputation(...)
    return B_Goal_CityReputation:new(...);
end

B_Goal_CityReputation = {
    Name = "Goal_CityReputation",
    Description = {
        en = "Goal: The reputation of the quest receivers city must at least reach the desired hight.",
        de = "Ziel: Der Ruf der Stadt des Empfängers muss mindestens so hoch sein, wie angegeben.",
        fr = "Objectif: la réputation de la ville du receveur doit être au moins aussi élevée que celle indiquée.",
    },
    Parameter = {
        { ParameterType.Number, en = "City reputation", de = "Ruf der Stadt", fr = "Réputation de la ville" },
    },
    Text = {
        de = "RUF DER STADT{cr}{cr}Hebe den Ruf der Stadt durch weise Herrschaft an!{cr}Benötigter Ruf: %d",
        en = "CITY REPUTATION{cr}{cr}Raise your reputation by fair rulership!{cr}Needed reputation: %d",
        fr = "RÉPUTATION DE LA VILLE{cr}{cr} Augmente la réputation de la ville en la gouvernant sagement!{cr}Réputation requise : %d",
    }
}

function B_Goal_CityReputation:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_CityReputation:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Reputation = _Parameter * 1;
    end
end

function B_Goal_CityReputation:CustomFunction(_Quest)
    self:SetCaption(_Quest);
    local CityReputation = Logic.GetCityReputation(_Quest.ReceivingPlayer) * 100;
    if CityReputation >= self.Reputation then
        return true;
    end
end

function B_Goal_CityReputation:SetCaption(_Quest)
    if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local Text = string.format(Localize(self.Text), self.Reputation);
        Lib.Core.Quest:ChangeCustomQuestCaptionText(Text .."%", _Quest);
    end
end

function B_Goal_CityReputation:GetIcon()
    return {5, 14};
end

function B_Goal_CityReputation:Debug(_Quest)
    if type(self.Reputation) ~= "number" or self.Reputation < 0 or self.Reputation > 100 then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Reputation must be between 0 and 100!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_CityReputation);

-- -------------------------------------------------------------------------- --

function Goal_DestroySpawnedEntities(...)
    return B_Goal_DestroySpawnedEntities:new(...);
end

B_Goal_DestroySpawnedEntities = {
    Name = "Goal_DestroySpawnedEntities",
    Description = {
        en = "Goal: Destroy all entities spawned at the spawnpoint.",
        de = "Ziel: Zerstöre alle Entitäten, die bei dem Spawnpoint erzeugt wurde.",
        fr = "Objectif: Détruire toutes les entités créées au point d'apparition.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Spawnpoint",       de = "Spawnpoint",         fr = "Point d'émergence" },
        { ParameterType.Number,     en = "Amount",           de = "Menge",              fr = "Quantité" },
        { ParameterType.Custom,     en = "Name is prefixed", de = "Name ist Präfix",    fr = "Le nom est un préfixe" },
    },
};

function B_Goal_DestroySpawnedEntities:GetGoalTable()
    if self.Prefixed then
        local Parameter = table.remove(self.SpawnPoint);
        local i = 1;
        while (IsExisting(Parameter .. i)) do
            table.insert(self.SpawnPoint, Parameter .. i);
            i = i +1;
        end
        assert(#self.SpawnPoint > 0, "No spawnpoints found!");
    end
    return {Objective.DestroyEntities, 3, self.SpawnPoint, self.Amount};
end

function B_Goal_DestroySpawnedEntities:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.SpawnPoint = {_Parameter};
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1;
    elseif (_Index == 2) then
        _Parameter = _Parameter or "false";
        self.Prefixed = ToBoolean(_Parameter);
    end
end

function B_Goal_DestroySpawnedEntities:GetMsgKey()
    local ID = GetID(self.SpawnPoint[1]);
    if ID ~= 0 then
        local TypeName = Logic.GetEntityTypeName(Logic.GetEntityType(ID));
        if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableBuilding ) == 1 then
            return "Quest_Destroy_Leader";
        elseif TypeName:find("Bear") or TypeName:find("Lion") or TypeName:find("Tiger") or TypeName:find("Wolf") then
            return "Quest_DestroyEntities_Predators";
        elseif TypeName:find("Military") or TypeName:find("Cart") then
            return "Quest_DestroyEntities_Unit";
        end
    end
    return "Quest_DestroyEntities";
end

function B_Goal_DestroySpawnedEntities:GetCustomData(_Index)
    if _Index == 2 then
        return {"false", "true"};
    end
end

RegisterBehavior(B_Goal_DestroySpawnedEntities);

-- -------------------------------------------------------------------------- --

function Goal_StealGold(...)
    return B_Goal_StealGold:new(...)
end

B_Goal_StealGold = {
    Name = "Goal_StealGold",
    Description = {
        en = "Goal: Steal an explicit amount of gold from a players or any players city buildings.",
        de = "Ziel: Diebe sollen eine bestimmte Menge Gold aus feindlichen Stadtgebäuden stehlen.",
        fr = "Objectif: les voleurs doivent dérober une certaine quantité d'or dans les bâtiments urbains ennemis.",
    },
    Parameter = {
        { ParameterType.Number,   en = "Amount on Gold", de = "Zu stehlende Menge",             fr = "Quantité à voler" },
        { ParameterType.Custom,   en = "Target player",  de = "Spieler von dem gestohlen wird", fr = "Joueur à qui l'on vole" },
        { ParameterType.Custom,   en = "Cheat earnings", de = "Einnahmen generieren",           fr = "Générer des revenus" },
        { ParameterType.Custom,   en = "Print progress", de = "Fortschritt ausgeben",           fr = "Afficher les progrès" },
    },
}

function B_Goal_StealGold:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_StealGold:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Amount = _Parameter * 1;
    elseif (_Index == 1) then
        local PlayerID = tonumber(_Parameter) or -1;
        self.Target = PlayerID * 1;
    elseif (_Index == 2) then
        _Parameter = _Parameter or "false"
        self.CheatEarnings = ToBoolean(_Parameter);
    elseif (_Index == 3) then
        _Parameter = _Parameter or "true"
        self.Printout = ToBoolean(_Parameter);
    end
    self.StohlenGold = 0;
end

function B_Goal_StealGold:GetCustomData(_Index)
    if _Index == 1 then
        return { "-", 1, 2, 3, 4, 5, 6, 7, 8 };
    elseif _Index == 2 then
        return { "true", "false" };
    end
end

function B_Goal_StealGold:SetDescriptionOverwrite(_Quest)
    local TargetPlayerName = Localize({
        de = " anderen Spielern ",
        en = " different parties ",
        fr = " d'autres joueurs ",
    });

    if self.Target ~= -1 then
        TargetPlayerName = GetPlayerName(self.Target);
        if TargetPlayerName == nil or TargetPlayerName == "" then
            TargetPlayerName = " PLAYER_NAME_MISSING ";
        end
    end

    -- Cheat earnings
    if self.CheatEarnings then
        local PlayerIDs = {self.Target};
        if self.Target == -1 then
            PlayerIDs = {1, 2, 3, 4, 5, 6, 7, 8};
        end
        for i= 1, #PlayerIDs, 1 do
            if i ~= _Quest.ReceivingPlayer and Logic.GetStoreHouse(i) ~= 0 then
                local CityBuildings = {Logic.GetPlayerEntitiesInCategory(i, EntityCategories.CityBuilding)};
                for j= 1, #CityBuildings, 1 do
                    local CurrentEarnings = Logic.GetBuildingProductEarnings(CityBuildings[j]);
                    if CurrentEarnings < 45 and Logic.GetTime() % 5 == 0 then
                        Logic.SetBuildingEarnings(CityBuildings[j], CurrentEarnings +1);
                    end
                end
            end
        end
    end

    local amount = self.Amount - self.StohlenGold;
    amount = (amount > 0 and amount) or 0;
    local text = {
        de = "Gold von %s stehlen {cr}{cr}Aus Stadtgebäuden zu stehlende Goldmenge: %d",
        en = "Steal gold from %s {cr}{cr}Amount on gold to steal from city buildings: %d",
        fr = "Voler l'or de %s {cr}{cr}Quantité d'or à voler dans les bâtiments de la ville : %d",
    };
    return "{center}" ..string.format(Localize(text), TargetPlayerName, amount);
end

function B_Goal_StealGold:CustomFunction(_Quest)
    if Lib.Core.Quest then
        Lib.Core.Quest:ChangeCustomQuestCaptionText(self:SetDescriptionOverwrite(_Quest), _Quest);
    end
    if self.StohlenGold >= self.Amount then
        return true;
    end
    return nil;
end

function B_Goal_StealGold:GetIcon()
    return {5,13};
end

function B_Goal_StealGold:Debug(_Quest)
    if tonumber(self.Amount) == nil and self.Amount < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": amount can not be negative!");
        return true;
    end
    return false;
end

function B_Goal_StealGold:Reset(_Quest)
    self.StohlenGold = 0;
end

RegisterBehavior(B_Goal_StealGold)

-- -------------------------------------------------------------------------- --

function Goal_StealFromBuilding(...)
    return B_Goal_StealFromBuilding:new(...)
end

B_Goal_StealFromBuilding = {
    Name = "Goal_StealFromBuilding",
    Description = {
        en = "Goal: The player has to steal from a building. Not a castle and not a village storehouse!",
        de = "Ziel: Der Spieler muss ein bestimmtes Gebäude bestehlen. Dies darf keine Burg und kein Dorflagerhaus sein!",
        fr = "Objectif: Le joueur doit voler un bâtiment spécifique. Il ne peut s'agir ni d'un château ni d'un entrepôt de village !",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Building",        de = "Gebäude",              fr = "Bâtiment" },
        { ParameterType.Custom,     en = "Cheat earnings",  de = "Einnahmen generieren", fr = "Générer des revenus" },
    },
}

function B_Goal_StealFromBuilding:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_StealFromBuilding:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Building = _Parameter
    elseif (_Index == 1) then
        _Parameter = _Parameter or "false"
        self.CheatEarnings = ToBoolean(_Parameter);
    end
    self.RobberList = {};
end

function B_Goal_StealFromBuilding:GetCustomData(_Index)
    if _Index == 1 then
        return { "true", "false" };
    end
end

function B_Goal_StealFromBuilding:SetDescriptionOverwrite(_Quest)
    local isCathedral = Logic.IsEntityInCategory(GetID(self.Building), EntityCategories.Cathedrals) == 1;
    local isWarehouse = Logic.GetEntityType(GetID(self.Building)) == Entities.B_StoreHouse;
    local isCistern = Logic.GetEntityType(GetID(self.Building)) == Entities.B_Cistern;
    local text;

    if isCathedral then
        text = {
            de = "Sabotage {cr}{cr} Sendet einen Dieb und sabotiert die markierte Kirche.",
            en = "Sabotage {cr}{cr} Send a thief to sabotage the marked chapel.",
            fr = "Sabotage {cr}{cr} Envoyez un voleur pour saboter la chapelle marquée.",
        };
    elseif isWarehouse then
        text = {
            de = "Lagerhaus bestehlen {cr}{cr} Sendet einen Dieb in das markierte Lagerhaus.",
            en = "Steal from storehouse {cr}{cr} Steal from the marked storehouse.",
            fr = "Voler un entrepôt {cr}{cr} Envoie un voleur dans l'entrepôt marqué.",
        };
    elseif isCistern then
        text = {
            de = "Sabotage {cr}{cr} Sendet einen Dieb und sabotiert den markierten Brunnen.",
            en = "Sabotage {cr}{cr} Send a thief and break the marked well of the enemy.",
            fr = "Sabotage {cr}{cr} Envoie un voleur et sabote le puits marqué.",
        };
    else
        text = {
            de = "Gebäude bestehlen {cr}{cr} Sendet einen Dieb und bestehlt das markierte Gebäude.",
            en = "Steal from building {cr}{cr} Send a thief to steal from the marked building.",
            fr = "Voler un bâtiment {cr}{cr} Envoie un voleur et vole le bâtiment marqué.",
        };
    end
    return "{center}" .. Localize(text);
end

function B_Goal_StealFromBuilding:CustomFunction(_Quest)
    if not IsExisting(self.Building) then
        if self.Marker then
            Logic.DestroyEffect(self.Marker);
        end
        return false;
    end

    if not self.Marker then
        local pos = GetPosition(self.Building);
        self.Marker = Logic.CreateEffect(EGL_Effects.E_Questmarker, pos.X, pos.Y, 0);
    end

    -- Cheat earnings
    if self.CheatEarnings then
        local BuildingID = GetID(self.Building);
        local CurrentEarnings = Logic.GetBuildingProductEarnings(BuildingID);
        if  Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1
        and CurrentEarnings < 45 and Logic.GetTime() % 5 == 0 then
            Logic.SetBuildingEarnings(BuildingID, CurrentEarnings +1);
        end
    end

    if self.SuccessfullyStohlen then
        Logic.DestroyEffect(self.Marker);
        return true;
    end
    return nil;
end

function B_Goal_StealFromBuilding:GetIcon()
    return {5,13};
end

function B_Goal_StealFromBuilding:Debug(_Quest)
    local eTypeName = Logic.GetEntityTypeName(Logic.GetEntityType(GetID(self.Building)));
    local IsHeadquarter = Logic.IsEntityInCategory(GetID(self.Building), EntityCategories.Headquarters) == 1;
    if Logic.IsBuilding(GetID(self.Building)) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": target is not a building");
        return true;
    elseif not IsExisting(self.Building) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": target is destroyed :(");
        return true;
    elseif string.find(eTypeName, "B_NPC_BanditsHQ") or string.find(eTypeName, "B_NPC_Cloister") or string.find(eTypeName, "B_NPC_StoreHouse") then
        error(_Quest.Identifier.. ": " ..self.Name .. ": village storehouses are not allowed!");
        return true;
    elseif IsHeadquarter then
        error(_Quest.Identifier.. ": " ..self.Name .. ": use Goal_StealInformation for headquarters!");
        return true;
    end
    return false;
end

function B_Goal_StealFromBuilding:Reset(_Quest)
    self.SuccessfullyStohlen = false;
    self.RobberList = {};
    self.Marker = nil;
end

function B_Goal_StealFromBuilding:Interrupt(_Quest)
    Logic.DestroyEffect(self.Marker);
end

RegisterBehavior(B_Goal_StealFromBuilding)

-- -------------------------------------------------------------------------- --

function Goal_SpyOnBuilding(...)
    return B_Goal_SpyOnBuilding:new(...)
end

B_Goal_SpyOnBuilding = {
    Name = "Goal_SpyOnBuilding",
    IconOverwrite = {5,13},
    Description = {
        en = "Goal: Infiltrate a building with a thief. A thief must be able to steal from the target building.",
        de = "Ziel: Infiltriere ein Gebäude mit einem Dieb. Nur mit Gebaueden möglich, die bestohlen werden koennen.",
        fr = "Objectif: Infiltrer un bâtiment avec un voleur. Seulement possible avec des bâtiments qui peuvent être volés.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Target Building", de = "Zielgebäude",           fr = "Bâtiment cible" },
        { ParameterType.Custom,     en = "Cheat earnings",  de = "Einnahmen generieren",  fr = "Générer des revenus" },
        { ParameterType.Custom,     en = "Destroy Thief",   de = "Dieb löschen",          fr = "Supprimer le voleur" },
    },
}

function B_Goal_SpyOnBuilding:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_SpyOnBuilding:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Building = _Parameter
    elseif (_Index == 1) then
        _Parameter = _Parameter or "false"
        self.CheatEarnings = ToBoolean(_Parameter);
    elseif (_Index == 2) then
        _Parameter = _Parameter or "true"
        self.Delete = ToBoolean(_Parameter)
    end
end

function B_Goal_SpyOnBuilding:GetCustomData(_Index)
    if _Index == 1 then
        return { "true", "false" };
    end
end

function B_Goal_SpyOnBuilding:SetDescriptionOverwrite(_Quest)
    if not _Quest.QuestDescription then
        local text = {
            de = "Gebäude infriltrieren {cr}{cr}Spioniere das markierte Gebäude mit einem Dieb aus!",
            en = "Infiltrate building {cr}{cr}Spy on the highlighted buildings with a thief!",
            fr = "Infiltrer un bâtiment {cr}{cr}Espionner le bâtiment marqué avec un voleur!",
        };
        return Localize(text);
    else
        return _Quest.QuestDescription;
    end
end

function B_Goal_SpyOnBuilding:CustomFunction(_Quest)
    if not IsExisting(self.Building) then
        if self.Marker then
            Logic.DestroyEffect(self.Marker);
        end
        return false;
    end

    if not self.Marker then
        local pos = GetPosition(self.Building);
        self.Marker = Logic.CreateEffect(EGL_Effects.E_Questmarker, pos.X, pos.Y, 0);
    end

    -- Cheat earnings
    if self.CheatEarnings then
        local BuildingID = GetID(self.Building);
        if  Logic.IsEntityInCategory(BuildingID, EntityCategories.CityBuilding) == 1
        and Logic.GetBuildingEarnings(BuildingID) < 5 then
            Logic.SetBuildingEarnings(BuildingID, 5);
        end
    end

    if self.Infiltrated then
        Logic.DestroyEffect(self.Marker);
        return true;
    end
    return nil;
end

function B_Goal_SpyOnBuilding:GetIcon()
    return self.IconOverwrite;
end

function B_Goal_SpyOnBuilding:Debug(_Quest)
    if Logic.IsBuilding(GetID(self.Building)) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": target is not a building");
        return true;
    elseif not IsExisting(self.Building) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": target is destroyed :(");
        return true;
    end
    return false;
end

function B_Goal_SpyOnBuilding:Reset(_Quest)
    self.Infiltrated = false;
    self.Marker = nil;
end

function B_Goal_SpyOnBuilding:Interrupt(_Quest)
    Logic.DestroyEffect(self.Marker);
end

RegisterBehavior(B_Goal_SpyOnBuilding);

-- -------------------------------------------------------------------------- --

function Goal_DestroySoldiers(...)
    return B_Goal_DestroySoldiers:new(...);
end

B_Goal_DestroySoldiers = {
    Name = "Goal_DestroySoldiers",
    Description = {
        en = "Goal: Destroy a given amount of enemy soldiers",
        de = "Ziel: Zerstöre eine Anzahl gegnerischer Soldaten",
        fr = "Objectif: Détruire un certain nombre de soldats ennemis",
    },
    Parameter = {
        {ParameterType.PlayerID, en = "Attacking Player",   de = "Angreifer",   fr = "Attaquant", },
        {ParameterType.PlayerID, en = "Defending Player",   de = "Verteidiger", fr = "Défenseur", },
        {ParameterType.Number,   en = "Amount",             de = "Anzahl",      fr = "Quantité", },
    },

    Text = {
        de = "{center}SOLDATEN ZERSTÖREN {cr}{cr}von der Partei: %s{cr}{cr}Anzahl: %d",
        en = "{center}DESTROY SOLDIERS {cr}{cr}from faction: %s{cr}{cr}Amount: %d",
        fr = "{center}DESTRUIRE DES SOLDATS {cr}{cr}de la faction: %s{cr}{cr}Nombre : %d",
    }
}

function B_Goal_DestroySoldiers:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_DestroySoldiers:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.AttackingPlayer = _Parameter * 1
    elseif (_Index == 1) then
        self.AttackedPlayer = _Parameter * 1
    elseif (_Index == 2) then
        self.KillsNeeded = _Parameter * 1
    end
end

function B_Goal_DestroySoldiers:CustomFunction(_Quest)
    if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local PlayerName = GetPlayerName(self.AttackedPlayer) or
                           ("Player " ..self.AttackedPlayer);
        Lib.Core.Quest:ChangeCustomQuestCaptionText(
            string.format(
                Lib.Core.Placeholder:Localize(self.Text),
                PlayerName, self.KillsNeeded
            ),
            _Quest
        );
    end

    local KillsCurrent = GetEnemySoldierKillsOfPlayer(
        self.AttackingPlayer,
        self.AttackedPlayer
    );
    if not self.KillstStart then
        self.KillstStart = KillsCurrent;
    end
    if self.KillsNeeded <= KillsCurrent - self.KillstStart then
        return true;
    end
end

function B_Goal_DestroySoldiers:Debug(_Quest)
    if Logic.GetStoreHouse(self.AttackingPlayer) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AttackinPlayer .. " is dead :-(")
        return true
    elseif Logic.GetStoreHouse(self.AttackedPlayer) == 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AttackedPlayer .. " is dead :-(")
        return true
    elseif self.KillsNeeded < 0 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Amount negative")
        return true
    end
end

function B_Goal_DestroySoldiers:Reset()
    self.KillstStart = nil;
end

function B_Goal_DestroySoldiers:GetIcon()
    return {7,12}
end

RegisterBehavior(B_Goal_DestroySoldiers);

-- -------------------------------------------------------------------------- --

function Reprisal_SetPosition(...)
    return B_Reprisal_SetPosition:new(...);
end

B_Reprisal_SetPosition = {
    Name = "Reprisal_SetPosition",
    Description = {
        en = "Reprisal: Places an entity relative to the position of another. The entity can look the target.",
        de = "Vergeltung: Setzt eine Entity relativ zur Position einer anderen. Die Entity kann zum Ziel ausgerichtet werden.",
        fr = "Rétribution: place une Entity vis-à-vis de l'emplacement d'une autre. L'entité peut être orientée vers la cible.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",          de = "Entity",          fr = "Entité", },
        { ParameterType.ScriptName, en = "Target position", de = "Zielposition",    fr = "Position cible", },
        { ParameterType.Custom,     en = "Face to face",    de = "Ziel ansehen",    fr = "Voir la cible", },
        { ParameterType.Number,     en = "Distance",        de = "Zielentfernung",  fr = "Distance de la cible", },
    },
}

function B_Reprisal_SetPosition:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_SetPosition:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Target = _Parameter;
    elseif (_Index == 2) then
        self.FaceToFace = ToBoolean(_Parameter)
    elseif (_Index == 3) then
        self.Distance = (_Parameter ~= nil and tonumber(_Parameter)) or 100;
    end
end

function B_Reprisal_SetPosition:CustomFunction(_Quest)
    if not IsExisting(self.Entity) or not IsExisting(self.Target) then
        return;
    end

    local entity = GetID(self.Entity);
    local target = GetID(self.Target);
    local x,y,z = Logic.EntityGetPos(target);
    if Logic.IsBuilding(target) == 1 then
        x,y = Logic.GetBuildingApproachPosition(target);
    end
    local ori = Logic.GetEntityOrientation(target)+90;

    if self.FaceToFace then
        x = x + self.Distance * math.cos( math.rad(ori) );
        y = y + self.Distance * math.sin( math.rad(ori) );
        Logic.DEBUG_SetSettlerPosition(entity, x, y);
        LookAt(self.Entity, self.Target);
    else
        if Logic.IsBuilding(target) == 1 then
            x,y = Logic.GetBuildingApproachPosition(target);
        end
        Logic.DEBUG_SetSettlerPosition(entity, x, y);
    end
end

function B_Reprisal_SetPosition:GetCustomData(_Index)
    if _Index == 2 then
        return { "true", "false" }
    end
end

function B_Reprisal_SetPosition:Debug(_Quest)
    if self.FaceToFace then
        if tonumber(self.Distance) == nil or self.Distance < 50 then
            error(_Quest.Identifier.. ": " ..self.Name.. ": Distance is nil or to short!");
            return true;
        end
    end
    if not IsExisting(self.Entity) or not IsExisting(self.Target) then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Mover entity or target entity does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_SetPosition);

-- -------------------------------------------------------------------------- --

function Reprisal_ChangePlayer(...)
    return B_Reprisal_ChangePlayer:new(...)
end

B_Reprisal_ChangePlayer = {
    Name = "Reprisal_ChangePlayer",
    Description = {
        en = "Reprisal: Changes the owner of the entity or a battalion.",
        de = "Vergeltung: Aendert den Besitzer einer Entity oder eines Battalions.",
        fr = "Rétribution : Change le propriétaire d'une entité ou d'un bataillon.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",     de = "Entity",   fr = "Entité", },
        { ParameterType.Custom,     en = "Player",     de = "Spieler",  fr = "Joueur", },
    },
}

function B_Reprisal_ChangePlayer:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_ChangePlayer:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Player = tostring(_Parameter);
    end
end

function B_Reprisal_ChangePlayer:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end
    local eID = GetID(self.Entity);
    if Logic.IsLeader(eID) == 1 then
        Logic.ChangeSettlerPlayerID(eID, self.Player);
    else
        Logic.ChangeEntityPlayerID(eID, self.Player);
    end
end

function B_Reprisal_ChangePlayer:GetCustomData(_Index)
    if _Index == 1 then
        return {"0", "1", "2", "3", "4", "5", "6", "7", "8"}
    end
end

function B_Reprisal_ChangePlayer:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_ChangePlayer);

-- -------------------------------------------------------------------------- --

function Reprisal_SetVisible(...)
    return B_Reprisal_SetVisible:new(...)
end

B_Reprisal_SetVisible = {
    Name = "Reprisal_SetVisible",
    Description = {
        en = "Reprisal: Changes the visibility of an entity. If the entity is a spawner the spawned entities will be affected.",
        de = "Vergeltung: Setzt die Sichtbarkeit einer Entity. Handelt es sich um einen Spawner werden auch die gespawnten Entities beeinflusst.",
        fr = "Rétribution: fixe la visibilité d'une Entité. S'il s'agit d'un spawn, les Entities spawnées sont également affectées.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",      de = "Entity",   fr = "Entité", },
        { ParameterType.Custom,     en = "Visible",     de = "Sichtbar", fr = "Visible", },
    },
}

function B_Reprisal_SetVisible:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_SetVisible:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Visible = ToBoolean(_Parameter)
    end
end

function B_Reprisal_SetVisible:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end

    local eID = GetID(self.Entity);
    local pID = Logic.EntityGetPlayer(eID);
    local eType = Logic.GetEntityType(eID);
    local tName = Logic.GetEntityTypeName(eType);

    if string.find(tName, "^S_") or string.find(tName, "^B_NPC_Bandits")
    or string.find(tName, "^B_NPC_Barracks") then
        local spawned = {Logic.GetSpawnedEntities(eID)};
        for i=1, #spawned do
            if Logic.IsLeader(spawned[i]) == 1 then
                local soldiers = {Logic.GetSoldiersAttachedToLeader(spawned[i])};
                for j=2, #soldiers do
                    Logic.SetVisible(soldiers[j], self.Visible);
                end
            else
                Logic.SetVisible(spawned[i], self.Visible);
            end
        end
    else
        if Logic.IsLeader(eID) == 1 then
            local soldiers = {Logic.GetSoldiersAttachedToLeader(eID)};
            for j=2, #soldiers do
                Logic.SetVisible(soldiers[j], self.Visible);
            end
        else
            Logic.SetVisible(eID, self.Visible);
        end
    end
end

function B_Reprisal_SetVisible:GetCustomData(_Index)
    if _Index == 1 then
        return { "true", "false" }
    end
end

function B_Reprisal_SetVisible:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_SetVisible);

-- -------------------------------------------------------------------------- --

function Reprisal_SetVulnerability(...)
    return B_Reprisal_SetVulnerability:new(...);
end

B_Reprisal_SetVulnerability = {
    Name = "Reprisal_SetVulnerability",
    Description = {
        en = "Reprisal: Changes the vulnerability of the entity. If the entity is a spawner the spawned entities will be affected.",
        de = "Vergeltung: Macht eine Entity verwundbar oder unverwundbar. Handelt es sich um einen Spawner, sind die gespawnten Entities betroffen.",
        fr = "Rétribution: rend une Entité vulnérable ou invulnérable. S'il s'agit d'un spawn, les Entities spawnées sont affectées.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",             de = "Entity",     fr = "Entité", },
        { ParameterType.Custom,     en = "Vulnerability",      de = "Verwundbar", fr = "Vulnérabilité", },
    },
}

function B_Reprisal_SetVulnerability:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_SetVulnerability:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Vulnerability = ToBoolean(_Parameter)
    end
end

function B_Reprisal_SetVulnerability:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end
    local eID = GetID(self.Entity);
    local eType = Logic.GetEntityType(eID);
    local tName = Logic.GetEntityTypeName(eType);
    local EntitiesToCheck = {eID};
    if string.find(tName, "S_") or string.find(tName, "B_NPC_Bandits")
    or string.find(tName, "B_NPC_Barracks") then
        EntitiesToCheck = {Logic.GetSpawnedEntities(eID)};
    end
    local MethodToUse = "MakeInvulnerable";
    if self.Vulnerability then
        MethodToUse = "MakeVulnerable";
    end
    for i= 1, #EntitiesToCheck, 1 do
        if Logic.IsLeader(EntitiesToCheck[i]) == 1 then
            local Soldiers = {Logic.GetSoldiersAttachedToLeader(EntitiesToCheck[i])};
            for j=2, #Soldiers, 1 do
                _G[MethodToUse](Soldiers[j]);
            end
        end
        _G[MethodToUse](EntitiesToCheck[i]);
    end
end

function B_Reprisal_SetVulnerability:GetCustomData(_Index)
    if _Index == 1 then
        return { "true", "false" }
    end
end

function B_Reprisal_SetVulnerability:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_SetVulnerability);

-- -------------------------------------------------------------------------- --

function Reprisal_SetModel(...)
    return B_Reprisal_SetModel:new(...);
end

B_Reprisal_SetModel = {
    Name = "Reprisal_SetModel",
    Description = {
        en = "Reprisal: Changes the model of the entity. Be careful, some models crash the game.",
        de = "Vergeltung: Ändert das Model einer Entity. Achtung: Einige Modelle führen zum Absturz.",
        fr = "Rétribution: modifie le modèle d'une entité. Attention: certains modèles entraînent un crash.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",    de = "Entity", fr = "Entité", },
        { ParameterType.Custom,     en = "Model",     de = "Model",  fr = "Modèle", },
    },
}

function B_Reprisal_SetModel:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } }
end

function B_Reprisal_SetModel:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Model = _Parameter;
    end
end

function B_Reprisal_SetModel:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end
    local eID = GetID(self.Entity);
    Logic.SetModel(eID, Models[self.Model]);
end

function B_Reprisal_SetModel:GetCustomData(_Index)
    if _Index == 1 then
        local Data = {};
        -- Add generic models
        for k, v in pairs(Models) do
            if  not string.find(k, "Animals_")
            and not string.find(k, "MissionMap_")
            and not string.find(k, "R_Fish")
            and not string.find(k, "^[GEHUVXYZgt][ADSTfm]*")
            and not string.find(string.lower(k), "goods|tools_") then
                table.insert(Data, k);
            end
        end
        -- Add specific models
        table.insert(Data, "Effects_Dust01");
        table.insert(Data, "Effects_E_DestructionSmoke");
        table.insert(Data, "Effects_E_DustLarge");
        table.insert(Data, "Effects_E_DustSmall");
        table.insert(Data, "Effects_E_Firebreath");
        table.insert(Data, "Effects_E_Fireworks01");
        table.insert(Data, "Effects_E_Flies01");
        table.insert(Data, "Effects_E_Grasshopper03");
        table.insert(Data, "Effects_E_HealingFX");
        table.insert(Data, "Effects_E_Knight_Chivalry_Aura");
        table.insert(Data, "Effects_E_Knight_Plunder_Aura");
        table.insert(Data, "Effects_E_Knight_Song_Aura");
        table.insert(Data, "Effects_E_Knight_Trader_Aura");
        table.insert(Data, "Effects_E_Knight_Wisdom_Aura");
        table.insert(Data, "Effects_E_KnightFight");
        table.insert(Data, "Effects_E_NA_BlowingSand01");
        table.insert(Data, "Effects_E_NE_BlowingSnow01");
        table.insert(Data, "Effects_E_Oillamp");
        table.insert(Data, "Effects_E_SickBuilding");
        table.insert(Data, "Effects_E_Splash");
        table.insert(Data, "Effects_E_Torch");
        table.insert(Data, "Effects_Fire01");
        table.insert(Data, "Effects_FX_Lantern");
        table.insert(Data, "Effects_FX_SmokeBIG");
        table.insert(Data, "Effects_XF_BuildingSmoke");
        table.insert(Data, "Effects_XF_BuildingSmokeLarge");
        table.insert(Data, "Effects_XF_BuildingSmokeMedium");
        table.insert(Data, "Effects_XF_HouseFire");
        table.insert(Data, "Effects_XF_HouseFireLo");
        table.insert(Data, "Effects_XF_HouseFireMedium");
        table.insert(Data, "Effects_XF_HouseFireSmall");
        if g_GameExtraNo > 0 then
            table.insert(Data, "Effects_E_KhanaTemple_Fire");
            table.insert(Data, "Effects_E_Knight_Saraya_Aura");
        end
        -- Sort list
        table.sort(Data);
        return Data;
    end
end

function B_Reprisal_SetModel:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    if not Models[self.Model] then
        error(_Quest.Identifier.. ": " ..self.Name .. ": model '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_SetModel);

-- -------------------------------------------------------------------------- --

function Reward_SetPosition(...)
    return B_Reward_SetPosition:new(...);
end

B_Reward_SetPosition = CopyTable(B_Reprisal_SetPosition);
B_Reward_SetPosition.Name = "Reward_SetPosition";
B_Reward_SetPosition.Description.en = "Reward: Places an entity relative to the position of another. The entity can look the target.";
B_Reward_SetPosition.Description.de = "Lohn: Setzt eine Entity relativ zur Position einer anderen. Die Entity kann zum Ziel ausgerichtet werden.";
B_Reward_SetPosition.Description.fr = "Récompense: Définit une Entity vis-à-vis de la position d'une autre. L'entité peut être orientée vers la cible.";
B_Reward_SetPosition.GetReprisalTable = nil;

B_Reward_SetPosition.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

RegisterBehavior(B_Reward_SetPosition);

-- -------------------------------------------------------------------------- --

function Reward_ChangePlayer(...)
    return B_Reward_ChangePlayer:new(...);
end

B_Reward_ChangePlayer = CopyTable(B_Reprisal_ChangePlayer);
B_Reward_ChangePlayer.Name = "Reward_ChangePlayer";
B_Reward_ChangePlayer.Description.en = "Reward: Changes the owner of the entity or a battalion.";
B_Reward_ChangePlayer.Description.de = "Lohn: Ändert den Besitzer einer Entity oder eines Battalions.";
B_Reward_ChangePlayer.Description.fr = "Récompense: Change le propriétaire d'une entité ou d'un bataillon.";
B_Reward_ChangePlayer.GetReprisalTable = nil;

B_Reward_ChangePlayer.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

RegisterBehavior(B_Reward_ChangePlayer);

-- -------------------------------------------------------------------------- --

function Reward_MoveToPosition(...)
    return B_Reward_MoveToPosition:new(...);
end

B_Reward_MoveToPosition = {
    Name = "Reward_MoveToPosition",
    Description = {
        en = "Reward: Moves an entity relative to another entity. If angle is zero the entities will be standing directly face to face.",
        de = "Lohn: Bewegt eine Entity relativ zur Position einer anderen. Wenn Winkel 0 ist, stehen sich die Entities direkt gegenüber.",
        fr = "Récompense: Déplace une entité par rapport à la position d'une autre. Si l'angle est égal à 0, les entités sont directement opposées.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Settler",     de = "Siedler",     fr = "Settler" },
        { ParameterType.ScriptName, en = "Destination", de = "Ziel",        fr = "Destination" },
        { ParameterType.Number,     en = "Distance",    de = "Entfernung",  fr = "Distance" },
        { ParameterType.Number,     en = "Angle",       de = "Winkel",      fr = "Angle" },
    },
}

function B_Reward_MoveToPosition:GetRewardTable()
    return { Reward.Custom, {self, self.CustomFunction} }
end

function B_Reward_MoveToPosition:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Target = _Parameter;
    elseif (_Index == 2) then
        self.Distance = _Parameter * 1;
    elseif (_Index == 3) then
        self.Angle = _Parameter * 1;
    end
end

function B_Reward_MoveToPosition:CustomFunction(_Quest)
    if not IsExisting(self.Entity) or not IsExisting(self.Target) then
        return;
    end
    self.Angle = self.Angle or 0;

    local entity = GetID(self.Entity);
    local target = GetID(self.Target);
    local orientation = Logic.GetEntityOrientation(target);
    local x,y,z = Logic.EntityGetPos(target);
    if Logic.IsBuilding(target) == 1 then
        x, y = Logic.GetBuildingApproachPosition(target);
        orientation = orientation -90;
    end
    x = x + self.Distance * math.cos(math.rad(orientation+self.Angle));
    y = y + self.Distance * math.sin(math.rad(orientation+self.Angle));
    Logic.MoveSettler(entity, x, y);
    self.EntityMovingJob = RequestJob( function(_entityID, _targetID)
        if Logic.IsEntityMoving(_entityID) == false then
            LookAt(_entityID, _targetID);
            return true;
        end
    end, entity, target);
end

function B_Reward_MoveToPosition:Reset(_Quest)
    if self.EntityMovingJob then
        EndJob(self.EntityMovingJob);
    end
end

function B_Reward_MoveToPosition:Debug(_Quest)
    if tonumber(self.Distance) == nil or self.Distance < 50 then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Distance is nil or to short!");
        return true;
    elseif not IsExisting(self.Entity) or not IsExisting(self.Target) then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Mover entity or target entity does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reward_MoveToPosition);

-- -------------------------------------------------------------------------- --

function Reward_VictoryWithParty()
    return B_Reward_VictoryWithParty:new();
end

B_Reward_VictoryWithParty = {
    Name = "Reward_VictoryWithParty",
    Description = {
        en = "Reward: (Singleplayer) The player wins the game with an animated festival on the market. Continue playing deleates the festival.",
        de = "Lohn: (Einzelspieler) Der Spieler gewinnt das Spiel mit einer animierten Siegesfeier. Bei weiterspielen wird das Fest gelöscht.",
        fr = "Récompense: (Joueur unique) Le joueur gagne la partie avec une fête de la victoire animée. Si le joueur continue à jouer, la fête est effacée.",
    },
    Parameter = {}
};

function B_Reward_VictoryWithParty:GetRewardTable()
    return {Reward.Custom, {self, self.CustomFunction}};
end

function B_Reward_VictoryWithParty:AddParameter(_Index, _Parameter)
end

function B_Reward_VictoryWithParty:CustomFunction(_Quest)
    if not Lib.QuestBehavior then
        return;
    end
    if Framework.IsNetworkGame() then
        error(_Quest.Identifier.. ": " ..self.Name.. ": Can not be used in multiplayer!");
        return;
    end
    Victory(g_VictoryAndDefeatType.VictoryMissionComplete);
    local PlayerID = _Quest.ReceivingPlayer;

    local MarketID = Logic.GetMarketplace(PlayerID);
    if IsExisting(MarketID) then
        local pos = GetPosition(MarketID);
        Logic.CreateEffect(EGL_Effects.FXFireworks01,pos.X,pos.Y,0);
        Logic.CreateEffect(EGL_Effects.FXFireworks02,pos.X,pos.Y,0);

        local Generated = self:GenerateParty(PlayerID);
        Lib.QuestBehavior.Global.VictoryWithPartyEntities[PlayerID] = Generated;

        Logic.ExecuteInLuaLocalState(string.format(
            [[
                local MarketID = %d
                if IsExisting(MarketID) then
                    CameraAnimation.AllowAbort = false
                    CameraAnimation.QueueAnimation(CameraAnimation.SetCameraToEntity, MarketID)
                    CameraAnimation.QueueAnimation(CameraAnimation.StartCameraRotation, 5)
                    CameraAnimation.QueueAnimation(CameraAnimation.Stay ,9999)
                end

                GUI_Window.ContinuePlayingClicked_Orig_Reward_VictoryWithParty = GUI_Window.ContinuePlayingClicked
                GUI_Window.ContinuePlayingClicked = function()
                    GUI_Window.ContinuePlayingClicked_Orig_Reward_VictoryWithParty()
                    
                    local PlayerID = GUI.GetPlayerID()
                    GUI.SendScriptCommand("B_Reward_VictoryWithParty:ClearParty(" ..PlayerID.. ")")

                    CameraAnimation.AllowAbort = true
                    CameraAnimation.Abort()
                end
            ]],
            MarketID
        ));
    end
end

function B_Reward_VictoryWithParty:ClearParty(_PlayerID)
    if Lib.QuestBehavior.Global.VictoryWithPartyEntities[_PlayerID] then
        for k, v in pairs(Lib.QuestBehavior.Global.VictoryWithPartyEntities[_PlayerID]) do
            DestroyEntity(v);
        end
        Lib.QuestBehavior.Global.VictoryWithPartyEntities[_PlayerID] = nil;
    end
end

function B_Reward_VictoryWithParty:GenerateParty(_PlayerID)
    local GeneratedEntities = {};
    local Marketplace = Logic.GetMarketplace(_PlayerID);
    if Marketplace ~= nil and Marketplace ~= 0 then
        local MarketX, MarketY = Logic.GetEntityPosition(Marketplace);
        local ID = Logic.CreateEntity(Entities.D_X_Garland, MarketX, MarketY, 0, _PlayerID)
        table.insert(GeneratedEntities, ID);
        for j=1, 10 do
            for k=1,10 do
                local SettlersX = MarketX -700+ (j*150);
                local SettlersY = MarketY -700+ (k*150);
                local rand = math.random(1, 100);
                if rand > 70 then
                    local SettlerType = GetRandomSettlerType();
                    local Orientation = math.random(1, 359);
                    local WorkerID = Logic.CreateEntityOnUnblockedLand(SettlerType, SettlersX, SettlersY, Orientation, _PlayerID);
                    Logic.SetTaskList(WorkerID, TaskLists.TL_WORKER_FESTIVAL_APPLAUD_SPEECH);
                    table.insert(GeneratedEntities, WorkerID);
                end
            end
        end
    end
    return GeneratedEntities;
end

function B_Reward_VictoryWithParty:Debug(_Quest)
    if Lib.QuestBehavior then
        if Lib.QuestBehavior.Global.VictoryWithPartyEntities[_Quest.ReceivingPlayer] then
            error(_Quest.Identifier.. ": " ..self.Name..": Victory festival already started for player ".._Quest.ReceivingPlayer.."!");
            return true;
        end
    end
    return false;
end

RegisterBehavior(B_Reward_VictoryWithParty);

-- -------------------------------------------------------------------------- --

function Reward_SetVisible(...)
    return B_Reward_SetVisible:new(...)
end

B_Reward_SetVisible = CopyTable(B_Reprisal_SetVisible);
B_Reward_SetVisible.Name = "Reward_SetVisible";
B_Reward_SetVisible.Description.en = "Reward: Changes the visibility of an entity. If the entity is a spawner the spawned entities will be affected.";
B_Reward_SetVisible.Description.de = "Lohn: Setzt die Sichtbarkeit einer Entity. Handelt es sich um einen Spawner werden auch die gespawnten Entities beeinflusst.";
B_Reward_SetVisible.Description.fr = "Récompense: Définit la visibilité d'une Entity. S'il s'agit d'un spawn, les entités spawnées sont également influencées.";
B_Reward_SetVisible.GetReprisalTable = nil;

B_Reward_SetVisible.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } }
end

RegisterBehavior(B_Reward_SetVisible);

-- -------------------------------------------------------------------------- --

function Reward_SetVulnerability(...)
    return B_Reward_SetVulnerability:new(...);
end

B_Reward_SetVulnerability = CopyTable(B_Reprisal_SetVulnerability);
B_Reward_SetVulnerability.Name = "Reward_SetVulnerability";
B_Reward_SetVulnerability.Description.en = "Reward: Changes the vulnerability of the entity. If the entity is a spawner the spawned entities will be affected.";
B_Reward_SetVulnerability.Description.de = "Lohn: Macht eine Entity verwundbar oder unverwundbar. Handelt es sich um einen Spawner, sind die gespawnten Entities betroffen.";
B_Reward_SetVulnerability.Description.fr = "Récompense: Rend une Entité vulnérable ou invulnérable. S'il s'agit d'un spawn, les entités spawnées sont affectées.";
B_Reward_SetVulnerability.GetReprisalTable = nil;

B_Reward_SetVulnerability.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } }
end

RegisterBehavior(B_Reward_SetVulnerability);

-- -------------------------------------------------------------------------- --

function Reward_SetModel(...)
    return B_Reward_SetModel:new(...);
end

B_Reward_SetModel = CopyTable(B_Reprisal_SetModel);
B_Reward_SetModel.Name = "Reward_SetModel";
B_Reward_SetModel.Description.en = "Reward: Changes the model of the entity. Be careful, some models crash the game.";
B_Reward_SetModel.Description.de = "Lohn: Ändert das Model einer Entity. Achtung: Einige Modelle führen zum Absturz.";
B_Reward_SetModel.Description.fr = "Récompense: Modifie le modèle d'une entité. Attention : certains modèles entraînent un plantage.";
B_Reward_SetModel.GetReprisalTable = nil;

B_Reward_SetModel.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } }
end

RegisterBehavior(B_Reward_SetModel);

-- -------------------------------------------------------------------------- --

function Reward_AI_SetEntityControlled(...)
    return B_Reward_AI_SetEntityControlled:new(...);
end

B_Reward_AI_SetEntityControlled = {
    Name = "Reward_AI_SetEntityControlled",
    Description = {
        en = "Reward: Bind or Unbind an entity or a battalion to/from an AI player. The AI player must be activated!",
        de = "Lohn: Die KI kontrolliert die Entity oder der KI die Kontrolle entziehen. Die KI muss aktiv sein!",
        fr = "Récompense: L'IA contrôle l'entité ou retirer le contrôle à l'IA. L'IA doit être active !",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity",            de = "Entity",                 fr = "Entité", },
        { ParameterType.Custom,     en = "AI control entity", de = "KI kontrolliert Entity", fr = "L'IA contrôle l'entité", },
    },
}

function B_Reward_AI_SetEntityControlled:GetRewardTable()
    return { Reward.Custom, { self, self.CustomFunction } }
end

function B_Reward_AI_SetEntityControlled:AddParameter( _Index, _Parameter )
    if (_Index == 0) then
        self.Entity = _Parameter;
    elseif (_Index == 1) then
        self.Hidden = ToBoolean(_Parameter)
    end
end

function B_Reward_AI_SetEntityControlled:CustomFunction(_Quest)
    if not IsExisting(self.Entity) then
        return;
    end
    local eID = GetID(self.Entity);
    local pID = Logic.EntityGetPlayer(eID);
    local eType = Logic.GetEntityType(eID);
    local tName = Logic.GetEntityTypeName(eType);
    if string.find(tName, "S_") or string.find(tName, "B_NPC_Bandits")
    or string.find(tName, "B_NPC_Barracks") then
        local spawned = {Logic.GetSpawnedEntities(eID)};
        for i=1, #spawned do
            if Logic.IsLeader(spawned[i]) == 1 then
                AICore.HideEntityFromAI(pID, spawned[i], not self.Hidden);
            end
        end
    else
        AICore.HideEntityFromAI(pID, eID, not self.Hidden);
    end
end

function B_Reward_AI_SetEntityControlled:GetCustomData(_Index)
    if _Index == 1 then
        return { "false", "true" }
    end
end

function B_Reward_AI_SetEntityControlled:Debug(_Quest)
    if not IsExisting(self.Entity) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": entity '"..  self.Entity .. "' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reward_AI_SetEntityControlled);

-- -------------------------------------------------------------------------- --

function Trigger_AmmunitionDepleted(...)
    return B_Trigger_AmmunitionDepleted:new(...);
end

B_Trigger_AmmunitionDepleted = {
    Name = "Trigger_AmmunitionDepleted",
    Description = {
        en = "Trigger: if the ammunition of the entity is depleted.",
        de = "Auslöser: wenn die Munition der Entity aufgebraucht ist.",
        fr = "Déclencheur: lorsque les munitions de l'entité sont épuisées.",
    },
    Parameter = {
        { ParameterType.Scriptname, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
    },
}

function B_Trigger_AmmunitionDepleted:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_AmmunitionDepleted:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Scriptname = _Parameter
    end
end

function B_Trigger_AmmunitionDepleted:CustomFunction()
    if not IsExisting(self.Scriptname) then
        return false;
    end

    local EntityID = GetID(self.Scriptname);
    if Logic.GetAmmunitionAmount(EntityID) > 0 then
        return false;
    end

    return true;
end

function B_Trigger_AmmunitionDepleted:Debug(_Quest)
    if not IsExisting(self.Scriptname) then
        error(_Quest.Identifier.. ": " ..self.Name .. ": '"..self.Scriptname.."' is destroyed!");
        return true
    end
    return false
end

RegisterBehavior(B_Trigger_AmmunitionDepleted);

-- -------------------------------------------------------------------------- --

