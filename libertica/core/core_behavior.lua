Lib.Require("comfort/GetPosition");
Lib.Register("core/Core_Behavior");

function Reward_DEBUG(...)
    return B_Reward_DEBUG:new(...);
end

B_Reward_DEBUG = {
    Name = "Reward_DEBUG",
    Description = {
        en = "Reward: Start the debug mode. See documentation for more information.",
        de = "Lohn: Startet den Debug-Modus. Für mehr Informationen siehe Dokumentation.",
        fr = "Récompense: Démarre le mode de débug. Pour plus d'informations, voir la documentation.",
    },
    Parameter = {
        { ParameterType.Custom, en = "Activate script errors",     de = "Skriptfeleranzeige nutzen",  fr = "Afficher les erreurs de script" },
        { ParameterType.Custom, en = "Check quest while runtime",  de = "Quests zur Laufzeit prüfen", fr = "Vérifier les quêtes au cours de l'exécution" },
        { ParameterType.Custom, en = "Activate developing cheats", de = "Cheats aktivieren",          fr = "Activer les cheats" },
        { ParameterType.Custom, en = "Activate developing shell",  de = "Eingabe aktivieren",         fr = "Activer la saisie" },
        { ParameterType.Custom, en = "Use quest trace",            de = "Questverfolgung",            fr = "Suivi de quête" },
    },
}

function B_Reward_DEBUG:GetRewardTable(_Quest)
    return { Reward.Custom, {self, self.CustomFunction} }
end

function B_Reward_DEBUG:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.DisplayScriptErrors = ToBoolean(_Parameter);
    elseif (_Index == 1) then
        self.CheckWhileRuntime = ToBoolean(_Parameter);
    elseif (_Index == 2) then
        self.DevelopingCheats = ToBoolean(_Parameter);
    elseif (_Index == 3) then
        self.DevelopingShell = ToBoolean(_Parameter);
    elseif (_Index == 4) then
        self.UseQuestTrace = ToBoolean(_Parameter);
    end
end

function B_Reward_DEBUG:CustomFunction(_Quest)
    ActivateDebugMode(self.DisplayScriptErrors, self.CheckWhileRuntime, self.DevelopingCheats, self.DevelopingShell, self.UseQuestTrace );
end

function B_Reward_DEBUG:GetCustomData(_Index)
    return {"true","false"};
end

RegisterBehavior(B_Reward_DEBUG);

-- -------------------------------------------------------------------------- --

function Goal_ActivateObject(...)
    return B_Goal_ActivateObject:new(...);
end

B_Goal_ActivateObject = {
    Name = "Goal_ActivateObject",
    Description = {
        en = "Goal: Activate an interactive object",
        de = "Ziel: Aktiviere ein interaktives Objekt",
        fr = "Objectif: activer un objet interactif",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Object name", de = "Skriptname", fr = "Nom de l'entité" },
    },
}

function B_Goal_ActivateObject:GetGoalTable()
    return {Objective.Object, { self.ScriptName } }
end

function B_Goal_ActivateObject:AddParameter(_Index, _Parameter)
   if _Index == 0 then
        self.ScriptName = _Parameter
   end
end

function B_Goal_ActivateObject:GetMsgKey()
    return "Quest_Object_Activate"
end

RegisterBehavior(B_Goal_ActivateObject);

-- -------------------------------------------------------------------------- --

function Goal_Deliver(...)
    return B_Goal_Deliver:new(...)
end

B_Goal_Deliver = {
    Name = "Goal_Deliver",
    Description = {
        en = "Goal: Deliver goods to quest giver or to another player.",
        de = "Ziel: Liefere Waren zum Auftraggeber oder zu einem anderen Spieler.",
        fr = "Objectif: livrer des marchandises au mandant ou à un autre joueur.",
    },
    Parameter = {
        { ParameterType.Custom, en = "Type of good", de = "Ressourcentyp", fr = "Type de ressources" },
        { ParameterType.Number, en = "Amount of good", de = "Ressourcenmenge", fr = "Quantité de ressources" },
        { ParameterType.Custom, en = "To different player", de = "Anderer Empfänger", fr = "Autre bénéficiaire" },
        { ParameterType.Custom, en = "Ignore capture", de = "Abfangen ignorieren", fr = "Ignorer une interception" },
    },
}

function B_Goal_Deliver:GetGoalTable()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    return { Objective.Deliver, GoodType, self.GoodAmount, self.OverrideTarget, self.IgnoreCapture }
end

function B_Goal_Deliver:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 1) then
        self.GoodAmount = _Parameter * 1
    elseif (_Index == 2) then
        self.OverrideTarget = tonumber(_Parameter)
    elseif (_Index == 3) then
        self.IgnoreCapture = ToBoolean(_Parameter)
    end
end

function B_Goal_Deliver:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for k, v in pairs( Goods ) do
            if string.find( k, "^G_" ) then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        table.insert( Data, "-" )
        for i = 1, 8 do
            table.insert( Data, i )
        end
    elseif _Index == 3 then
        table.insert( Data, "true" )
        table.insert( Data, "false" )
    else
        assert( false )
    end
    return Data
end

function B_Goal_Deliver:GetMsgKey()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    local GC = Logic.GetGoodCategoryForGoodType( GoodType )

    local tMapping = {
        [GoodCategories.GC_Clothes] = "Quest_Deliver_GC_Clothes",
        [GoodCategories.GC_Entertainment] = "Quest_Deliver_GC_Entertainment",
        [GoodCategories.GC_Food] = "Quest_Deliver_GC_Food",
        [GoodCategories.GC_Gold] = "Quest_Deliver_GC_Gold",
        [GoodCategories.GC_Hygiene] = "Quest_Deliver_GC_Hygiene",
        [GoodCategories.GC_Medicine] = "Quest_Deliver_GC_Medicine",
        [GoodCategories.GC_Water] = "Quest_Deliver_GC_Water",
        [GoodCategories.GC_Weapon] = "Quest_Deliver_GC_Weapon",
        [GoodCategories.GC_Resource] = "Quest_Deliver_Resources",
    }

    if GC then
        local Key = tMapping[GC]
        if Key then
            return Key
        end
    end
    return "Quest_Deliver_Goods"
end

RegisterBehavior(B_Goal_Deliver);

-- -------------------------------------------------------------------------- --

function Goal_Diplomacy(...)
    return B_Goal_Diplomacy:new(...);
end

B_Goal_Diplomacy = {
    Name = "Goal_Diplomacy",
    Description = {
        en = "Goal: A diplomatic state must b reached. Can be lower than current state or higher.",
        de = "Ziel: Die Beziehungen zu einem Spieler müssen entweder verbessert oder verschlechtert werden.",
        fr = "Objectif: les relations avec un joueur doivent être soit améliorées, soit détériorées.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Party", de = "Partei", fr = "Faction" },
        { ParameterType.Custom,   en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Custom,   en = "Diplomacy state", de = "Diplomatische Beziehung", fr = "Relations diplomatiques" },
    },
    TextPattern = {
        de = "DIPLOMATIESTATUS ERREICHEN {cr}{cr}Status: %s{cr}Zur Partei: %s",
        en = "DIPLOMATIC STATE {cr}{cr}State: %s{cr}To player: %s",
        fr = "ATTEINDRE LE STATUT DE DIPLOMATIQUE {cr}{cr}Statut : %s{cr}Avec la faction : %s",
    },
}

function B_Goal_Diplomacy:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_Diplomacy:GetDiplomacyMapping()
    return {
        [DiplomacyStates.Allied]             = {de = "Verbündeter",    en = "Allied",               fr = "Allié"},
        [DiplomacyStates.TradeContact]       = {de = "Handelspartner", en = "Trade Contact",        fr = "Partenaire commercial"},
        [DiplomacyStates.EstablishedContact] = {de = "Bekannt",        en = "Established Contact",  fr = "Contact établi"},
        [DiplomacyStates.Undecided]          = {de = "Unbekannt",      en = "Undecided",            fr = "Inconnu"},
        [DiplomacyStates.Enemy]              = {de = "Feind",          en = "Enemy",                fr = "Ennemi"},
    };
end

function B_Goal_Diplomacy:ChangeCaption(_Quest)
    local DiplomacyMap = self:GetDiplomacyMapping();
    local PlayerName = GetPlayerName(self.PlayerID) or "";
    local Text = string.format(
        Localize(self.TextPattern),
        Localize(DiplomacyMap[self.DiplState]),
        PlayerName
    );
    Lib.Core.Quest:ChangeCustomQuestCaptionText(Text, _Quest);
end

function B_Goal_Diplomacy:CustomFunction(_Quest)
    self:ChangeCaption(_Quest);
    if self.Relation == "<=" then
        if GetDiplomacyState(_Quest.ReceivingPlayer, self.PlayerID) <= self.DiplState then
            return true;
        end
    elseif self.Relation == ">=" then
        if GetDiplomacyState(_Quest.ReceivingPlayer, self.PlayerID) >= self.DiplState then
            return true;
        end
    else
        if GetDiplomacyState(_Quest.ReceivingPlayer, self.PlayerID) == self.DiplState then
            return true;
        end
    end
end

function B_Goal_Diplomacy:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Relation = _Parameter;
    elseif (_Index == 2) then
        self.DiplState = DiplomacyStates[_Parameter];
    end
end

function B_Goal_Diplomacy:GetIcon()
    return {6, 3};
end

function B_Goal_Diplomacy:GetCustomData(_Index)
    if _Index == 1 then
        return {">=", "<=", "=="};
    elseif _Index == 2 then
        return {"Allied", "TradeContact", "EstablishedContact", "Undecided", "Enemy"};
    end
end

RegisterBehavior(B_Goal_Diplomacy);

-- -------------------------------------------------------------------------- --

function Goal_DiscoverPlayer(...)
    return B_Goal_DiscoverPlayer:new(...);
end

B_Goal_DiscoverPlayer = {
    Name = "Goal_DiscoverPlayer",
    Description = {
        en = "Goal: Discover the home territory of another player.",
        de = "Ziel: Entdecke das Heimatterritorium eines Spielers.",
        fr = "Objectif: Découvrir le territoire d'origine d'un joueur.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_DiscoverPlayer:GetGoalTable()
    return {Objective.Discover, 2, { self.PlayerID } }
end

function B_Goal_DiscoverPlayer:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_DiscoverPlayer:GetMsgKey()
    local tMapping = {
        [PlayerCategories.BanditsCamp] = "Quest_Discover",
        [PlayerCategories.City] = "Quest_Discover_City",
        [PlayerCategories.Cloister] = "Quest_Discover_Cloister",
        [PlayerCategories.Harbour] = "Quest_Discover",
        [PlayerCategories.Village] = "Quest_Discover_Village",
    }
    local PlayerCategory = GetPlayerCategoryType(self.PlayerID)
    if PlayerCategory then
        local Key = tMapping[PlayerCategory]
        if Key then
            return Key
        end
    end
    return "Quest_Discover"
end

RegisterBehavior(B_Goal_DiscoverPlayer);

-- -------------------------------------------------------------------------- --

function Goal_DiscoverTerritory(...)
    return B_Goal_DiscoverTerritory:new(...);
end

B_Goal_DiscoverTerritory = {
    Name = "Goal_DiscoverTerritory",
    Description = {
        en = "Goal: Discover a territory",
        de = "Ziel: Entdecke ein Territorium",
        fr = "Objectif : Découvrir un territoire",
    },
    Parameter = {
        { ParameterType.TerritoryName, en = "Territory", de = "Territorium", fr = "Territoire" },
    },
}

function B_Goal_DiscoverTerritory:GetGoalTable()
    return { Objective.Discover, 1, { self.TerritoryID  } }
end

function B_Goal_DiscoverTerritory:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.TerritoryID = tonumber(_Parameter)
        if not self.TerritoryID then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
        assert( self.TerritoryID > 0 )
    end
end

function B_Goal_DiscoverTerritory:GetMsgKey()
    return "Quest_Discover_Territory"
end

RegisterBehavior(B_Goal_DiscoverTerritory);

-- -------------------------------------------------------------------------- --

function Goal_DestroyPlayer(...)
    return B_Goal_DestroyPlayer:new(...);
end

B_Goal_DestroyPlayer = {
    Name = "Goal_DestroyPlayer",
    Description = {
        en = "Goal: Destroy a player (destroy a main building)",
        de = "Ziel: Zerstöre einen Spieler (ein Hauptgebäude muss zerstört werden).",
        fr = "Objectif : Détruire un joueur (un bâtiment principal doit être détruit).",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_DestroyPlayer:GetGoalTable()
    assert( self.PlayerID <= 8 and self.PlayerID >= 1, "Error in " .. self.Name .. ": GetGoalTable: PlayerID is invalid")
    return { Objective.DestroyPlayers, self.PlayerID }
end

function B_Goal_DestroyPlayer:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_DestroyPlayer:GetMsgKey()
    local tMapping = {
        [PlayerCategories.BanditsCamp] = "Quest_DestroyPlayers_Bandits",
        [PlayerCategories.City] = "Quest_DestroyPlayers_City",
        [PlayerCategories.Cloister] = "Quest_DestroyPlayers_Cloister",
        [PlayerCategories.Harbour] = "Quest_DestroyEntities_Building",
        [PlayerCategories.Village] = "Quest_DestroyPlayers_Village",
    }

    local PlayerCategory = GetPlayerCategoryType(self.PlayerID)
    if PlayerCategory then
        local Key = tMapping[PlayerCategory]
        if Key then
            return Key
        end
    end
    return "Quest_DestroyEntities_Building"
end

RegisterBehavior(B_Goal_DestroyPlayer)

-- -------------------------------------------------------------------------- --

function Goal_StealInformation(...)
    return B_Goal_StealInformation:new(...);
end

B_Goal_StealInformation = {
    Name = "Goal_StealInformation",
    Description = {
        en = "Goal: Steal information from another players castle",
        de = "Ziel: Stehle Informationen aus der Burg eines Spielers",
        fr = "Objectif : voler des informations du château d'un joueur",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_StealInformation:GetGoalTable()

    local Target = Logic.GetHeadquarters(self.PlayerID)
    if not Target or Target == 0 then
        Target = Logic.GetStoreHouse(self.PlayerID)
    end
    assert( Target and Target ~= 0 )
    return {Objective.Steal, 1, { Target } }

end

function B_Goal_StealInformation:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end

end

function B_Goal_StealInformation:GetMsgKey()
    return "Quest_Steal_Info"

end

RegisterBehavior(B_Goal_StealInformation);

-- -------------------------------------------------------------------------- --

function Goal_DestroyAllPlayerUnits(...)
    return B_Goal_DestroyAllPlayerUnits:new(...);
end

B_Goal_DestroyAllPlayerUnits = {
    Name = "Goal_DestroyAllPlayerUnits",
    Description = {
        en = "Goal: Destroy all units owned by player (be careful with script entities)",
        de = "Ziel: Zerstöre alle Einheiten eines Spielers (vorsicht mit Script-Entities)",
        fr = "Objectif: Détruire toutes les unités d'un joueur (attention aux entités de script)",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_DestroyAllPlayerUnits:GetGoalTable()
    return { Objective.DestroyAllPlayerUnits, self.PlayerID }
end

function B_Goal_DestroyAllPlayerUnits:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_DestroyAllPlayerUnits:GetMsgKey()
    local tMapping = {
        [PlayerCategories.BanditsCamp] = "Quest_DestroyPlayers_Bandits",
        [PlayerCategories.City] = "Quest_DestroyPlayers_City",
        [PlayerCategories.Cloister] = "Quest_DestroyPlayers_Cloister",
        [PlayerCategories.Harbour] = "Quest_DestroyEntities_Building",
        [PlayerCategories.Village] = "Quest_DestroyPlayers_Village",
    }

    local PlayerCategory = GetPlayerCategoryType(self.PlayerID)
    if PlayerCategory then
        local Key = tMapping[PlayerCategory]
        if Key then
            return Key
        end
    end
    return "Quest_DestroyEntities"
end

RegisterBehavior(B_Goal_DestroyAllPlayerUnits);

-- -------------------------------------------------------------------------- --

function Goal_DestroyScriptEntity(...)
    return B_Goal_DestroyScriptEntity:new(...);
end

B_Goal_DestroyScriptEntity = {
    Name = "Goal_DestroyScriptEntity",
    Description = {
        en = "Goal: Destroy an entity",
        de = "Ziel: Zerstöre eine Entität",
        fr = "Objectif : Détruire une entité",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
    },
}

function B_Goal_DestroyScriptEntity:GetGoalTable()
    return {Objective.DestroyEntities, 1, { self.ScriptName } }
end

function B_Goal_DestroyScriptEntity:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Goal_DestroyScriptEntity:GetMsgKey()
    if Logic.IsEntityAlive(self.ScriptName) then
        local ID = GetID(self.ScriptName)
        if ID and ID ~= 0 then
            ID = Logic.GetEntityType( ID )
            if ID and ID ~= 0 then
                if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableBuilding ) == 1 then
                    return "Quest_DestroyEntities_Building"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableAnimal ) == 1 then
                    return "Quest_DestroyEntities_Predators"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then
                    return "Quest_Destroy_Leader"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Military ) == 1
                    or Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableSettler ) == 1
                    or Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1  then

                    return "Quest_DestroyEntities_Unit"
                end
            end
        end
    end
    return "Quest_DestroyEntities"
end

RegisterBehavior(B_Goal_DestroyScriptEntity);

-- -------------------------------------------------------------------------- --

function Goal_DestroyType(...)
    return B_Goal_DestroyType:new(...);
end

B_Goal_DestroyType = {
    Name = "Goal_DestroyType",
    Description = {
        en = "Goal: Destroy entity types",
        de = "Ziel: Zerstöre Entitätstypen",
        fr = "Objectif: Détruire les types d'entités",
    },
    Parameter = {
        { ParameterType.Custom, en = "Type name", de = "Typbezeichnung", fr = "Désignation du type" },
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr = "Quantité" },
        { ParameterType.Custom, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_DestroyType:GetGoalTable()
    return {Objective.DestroyEntities, 2, Entities[self.EntityName], self.Amount, self.PlayerID }
end

function B_Goal_DestroyType:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.EntityName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
        self.DestroyTypeAmount = self.Amount
    elseif (_Index == 2) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_DestroyType:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for k, v in pairs( Entities ) do
            if string.find( k, "^[ABU]_" ) then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        for i = 0, 8 do
            table.insert( Data, i )
        end
    else
        assert( false )
    end
    return Data
end

function B_Goal_DestroyType:GetMsgKey()
    local ID = self.EntityName
    if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableBuilding ) == 1 then
        return "Quest_DestroyEntities_Building"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableAnimal ) == 1 then
        return "Quest_DestroyEntities_Predators"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then
        return "Quest_Destroy_Leader"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Military ) == 1
        or Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableSettler ) == 1
        or Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1  then

        return "Quest_DestroyEntities_Unit"
    end
    return "Quest_DestroyEntities"
end

RegisterBehavior(B_Goal_DestroyType);

-- -------------------------------------------------------------------------- --

function Goal_EntityDistance(...)
    return B_Goal_EntityDistance:new(...);
end

B_Goal_EntityDistance = {
    Name = "Goal_EntityDistance",
    Description = {
        en = "Goal: Distance between two entities",
        de = "Ziel: Zwei Entities sollen zueinander eine Entfernung über- oder unterschreiten.",
        fr = "Objectif: deux entités doivent se trouver à une distance supérieure ou inférieure l'une de l'autre.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity 1", de = "Entity 1", fr = "Entité 1" },
        { ParameterType.ScriptName, en = "Entity 2", de = "Entity 2", fr = "Entité 2" },
        { ParameterType.Custom, en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Number, en = "Distance", de = "Entfernung", fr = "Distance" },
    },
}

function B_Goal_EntityDistance:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_EntityDistance:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Entity1 = _Parameter
    elseif (_Index == 1) then
        self.Entity2 = _Parameter
    elseif (_Index == 2) then
        self.bRelSmallerThan = _Parameter == "<"
    elseif (_Index == 3) then
        self.Distance = _Parameter * 1
    end
end

function B_Goal_EntityDistance:CustomFunction(_Quest)
    if Logic.IsEntityDestroyed( self.Entity1 ) or Logic.IsEntityDestroyed( self.Entity2 ) then
        return false
    end
    local ID1 = GetID( self.Entity1 )
    local ID2 = GetID( self.Entity2 )
    local InRange = Logic.CheckEntitiesDistance( ID1, ID2, self.Distance )
    if ( self.bRelSmallerThan and InRange ) or ( not self.bRelSmallerThan and not InRange ) then
        return true
    end
end

function B_Goal_EntityDistance:GetCustomData( _Index )
    local Data = {}
    if _Index == 2 then
        table.insert( Data, ">" )
        table.insert( Data, "<" )
    else
        assert( false )
    end
    return Data
end

function B_Goal_EntityDistance:Debug(_Quest)
    if not IsExisting(self.Entity1) or not IsExisting(self.Entity2) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": At least 1 of the entities for distance check don't exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_EntityDistance);

-- -------------------------------------------------------------------------- --

function Goal_KnightDistance(...)
    return B_Goal_KnightDistance:new(...);
end

B_Goal_KnightDistance = {
    Name = "Goal_KnightDistance",
    Description = {
        en = "Goal: Bring the knight close to a given entity. If the distance is left at 0 it will automatically set to 2500.",
        de = "Ziel: Bringe den Ritter nah an eine bestimmte Entität. Wird die Entfernung 0 gelassen, ist sie automatisch 2500.",
        fr = "Objectif : Rapproche le chevalier d'une entité donnée. Si la distance est laissée à 0, elle est automatiquement de 2500.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Target", de = "Ziel", fr = "Cible" },
        { ParameterType.Number, en = "Distance", de = "Entfernung", fr = "Distance" },
    },
}

function B_Goal_KnightDistance:GetGoalTable()
    return {Objective.Distance, -65566, self.Target, self.Distance, true}
end

function B_Goal_KnightDistance:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Target = _Parameter;
    elseif (_Index == 1) then
        if _Parameter == nil or _Parameter == "" then
            _Parameter = 0;
        end
        self.Distance = _Parameter * 1;
        if self.Distance == 0 then
            self.Distance = 2500;
        end
    end
end

RegisterBehavior(B_Goal_KnightDistance);

-- -------------------------------------------------------------------------- --

function Goal_UnitsOnTerritory(...)
    return B_Goal_UnitsOnTerritory:new(...);
end

B_Goal_UnitsOnTerritory = {
    Name = "Goal_UnitsOnTerritory",
    Description = {
        en = "Goal: Place a certain amount of units on a territory",
        de = "Ziel: Platziere eine bestimmte Anzahl Einheiten auf einem Gebiet",
        fr = "Objectif: placer un certain nombre d'unités sur un territoire",
    },
    Parameter = {
        { ParameterType.TerritoryNameWithUnknown, en = "Territory", de = "Territorium", fr = "Territoire" },
        { ParameterType.Custom,  en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Custom,  en = "Category", de = "Kategorie", fr = "Catégorie" },
        { ParameterType.Custom,  en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Number,  en = "Number of units", de = "Anzahl Einheiten", fr = "Quantité d'unitées" },
    },
}

function B_Goal_UnitsOnTerritory:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_UnitsOnTerritory:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.TerritoryID = tonumber(_Parameter)
        if self.TerritoryID == nil then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
    elseif (_Index == 1) then
        self.PlayerID = tonumber(_Parameter) * 1
    elseif (_Index == 2) then
        self.Category = _Parameter
    elseif (_Index == 3) then
        self.bRelSmallerThan = (tostring(_Parameter) == "true" or tostring(_Parameter) == "<")
    elseif (_Index == 4) then
        self.NumberOfUnits = _Parameter * 1
    end
end

function B_Goal_UnitsOnTerritory:CustomFunction(_Quest)
    local PlayerEntities = self:GetEntities(self.TerritoryID, self.PlayerID, EntityCategories[self.Category]);
    if self.bRelSmallerThan == false and #PlayerEntities >= self.NumberOfUnits then
        return true;
    elseif self.bRelSmallerThan == true and #PlayerEntities < self.NumberOfUnits then
        return true;
    end
end

function B_Goal_UnitsOnTerritory:GetEntities(_TerritoryID, _PlayerID, _Category)
    local PlayerEntities = {};
    local Units = {};
    if (_PlayerID == -1) then
        for i=0,8 do
            local NumLast = 0;
            repeat
                Units = {Logic.GetEntitiesOfCategoryInTerritory(_TerritoryID, i, _PlayerID, NumLast)};
                PlayerEntities = Array_Append(PlayerEntities, Units);
                NumLast = NumLast + #Units;
            until #Units == 0;
        end
    else
        local NumLast = 0;
        repeat
            Units = { Logic.GetEntitiesOfCategoryInTerritory(_TerritoryID, _PlayerID, _Category, NumLast)};
            PlayerEntities = Array_Append(PlayerEntities, Units);
            NumLast = NumLast + #Units;
        until #Units == 0;
    end
    return PlayerEntities;
end

function B_Goal_UnitsOnTerritory:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then
        table.insert( Data, -1 )
        for i = 1, 8 do
            table.insert( Data, i )
        end
    elseif _Index == 2 then
        for k, v in pairs( EntityCategories ) do
            if not string.find( k, "^G_" ) and k ~= "SheepPasture" then
                table.insert( Data, k )
            end
        end
        table.sort( Data );
    elseif _Index == 3 then
        table.insert( Data, ">=" )
        table.insert( Data, "<" )
    else
        assert( false )
    end
    return Data
end

function B_Goal_UnitsOnTerritory:Debug(_Quest)
    local territories = {Logic.GetTerritories()}
    if tonumber(self.TerritoryID) == nil or self.TerritoryID < 0 or not table.contains(territories, self.TerritoryID) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid territoryID!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 0 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    elseif not EntityCategories[self.Category] then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid entity category!");
        return true;
    elseif tonumber(self.NumberOfUnits) == nil or self.NumberOfUnits < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": amount is negative or nil!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_UnitsOnTerritory);

-- -------------------------------------------------------------------------- --

function Goal_ActivateBuff(...)
    return B_Goal_ActivateBuff:new(...);
end

B_Goal_ActivateBuff = {
    Name = "Goal_ActivateBuff",
    Description = {
        en = "Goal: Activate a buff",
        de = "Ziel: Aktiviere einen Buff",
        fr = "Objectif: Activer un bonus",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Custom, en = "Buff", de = "Buff", fr = "Bonus" },
    },
}

function B_Goal_ActivateBuff:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_ActivateBuff:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.BuffName = _Parameter
        self.Buff = Buffs[_Parameter]
    end
end

function B_Goal_ActivateBuff:CustomFunction(_Quest)
   if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local tMapping = CopyTable(Lib.Core.Quest.Text.ActivateBuff.BuffsVanilla);
        if g_GameExtraNo >= 1 then
            tMapping = CopyTable(Lib.Core.Quest.Text.ActivateBuff.BuffsEx1, tMapping);
        end
        Lib.Core.Quest:ChangeCustomQuestCaptionText(
            string.format(
                Localize(Lib.Core.Quest.Text.ActivateBuff.Pattern),
                Localize(tMapping[self.BuffName])
            ),
            _Quest
        );
    end

    local Buff = Logic.GetBuff( self.PlayerID, self.Buff )
    if Buff and Buff ~= 0 then
        return true
    end
end

function B_Goal_ActivateBuff:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then
        Data = {
            "Buff_Spice",
            "Buff_Colour",
            "Buff_Entertainers",
            "Buff_FoodDiversity",
            "Buff_ClothesDiversity",
            "Buff_HygieneDiversity",
            "Buff_EntertainmentDiversity",
            "Buff_Sermon",
            "Buff_Festival",
            "Buff_ExtraPayment",
            "Buff_HighTaxes",
            "Buff_NoPayment",
            "Buff_NoTaxes"
        }

        if g_GameExtraNo >= 1 then
            table.insert(Data, "Buff_Gems")
            table.insert(Data, "Buff_MusicalInstrument")
            table.insert(Data, "Buff_Olibanum")
        end

        table.sort( Data )
    else
        assert( false )
    end
    return Data
end

function B_Goal_ActivateBuff:GetIcon()
    local tMapping = {
        [Buffs.Buff_Spice]                  = "Goods.G_Salt",
        [Buffs.Buff_Colour]                 = "Goods.G_Dye",
        [Buffs.Buff_Entertainers]           = "Entities.U_Entertainer_NA_FireEater", --{5, 12},
        [Buffs.Buff_FoodDiversity]          = "Needs.Nutrition", --{1, 1},
        [Buffs.Buff_ClothesDiversity]       = "Needs.Clothes", --{1, 2},
        [Buffs.Buff_HygieneDiversity]       = "Needs.Hygiene", --{16, 1},
        [Buffs.Buff_EntertainmentDiversity] = "Needs.Entertainment", --{1, 4},
        [Buffs.Buff_Sermon]                 = "Technologies.R_Sermon", --{4, 14},
        [Buffs.Buff_Festival]               = "Technologies.R_Festival", --{4, 15},
        [Buffs.Buff_ExtraPayment]           = {1,8},
        [Buffs.Buff_HighTaxes]              = {1,6},
        [Buffs.Buff_NoPayment]              = {1,8},
        [Buffs.Buff_NoTaxes]                = {1,6},
    }
    if g_GameExtraNo and g_GameExtraNo >= 1 then
        tMapping[Buffs.Buff_Gems] = "Goods.G_Gems"
        tMapping[Buffs.Buff_MusicalInstrument] = "Goods.G_MusicalInstrument"
        tMapping[Buffs.Buff_Olibanum] = "Goods.G_Olibanum"
    end
    return tMapping[self.Buff]
end

function B_Goal_ActivateBuff:Debug(_Quest)
    if not self.Buff then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": buff '" ..self.BuffName.. "' does not exist!");
        return true;
    elseif not tonumber(self.PlayerID) or self.PlayerID < 1 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_ActivateBuff);

-- -------------------------------------------------------------------------- --

function Goal_BuildRoad(...)
    return B_Goal_BuildRoad:new(...)
end

B_Goal_BuildRoad = {
    Name = "Goal_BuildRoad",
    Description = {
        en = "Goal: Connect two points with a street or a road",
        de = "Ziel: Verbinde zwei Punkte mit einer Strasse oder einem Weg.",
        fr = "Objectif: Relier deux points par une route ou un chemin.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity 1",       de = "Entity 1",     fr = "Entité 1" },
        { ParameterType.ScriptName, en = "Entity 2",       de = "Entity 2",     fr = "Entité 2" },
        { ParameterType.Custom,     en = "Only roads",     de = "Nur Strassen", fr = "Que des Routes" },
    },
}

function B_Goal_BuildRoad:GetGoalTable()
    -- {BehaviorType, {EntityID1, EntityID2, BeSmalerThan, Length, RoadsOnly}}
    -- -> Length wird nicht mehr benutzt. Sorgte für Promleme im Spiel
    return { Objective.BuildRoad, { GetID( self.Entity1 ), GetID( self.Entity2 ), false, 0, self.bRoadsOnly } }
end

function B_Goal_BuildRoad:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Entity1 = _Parameter
    elseif (_Index == 1) then
        self.Entity2 = _Parameter
    elseif (_Index == 2) then
        self.bRoadsOnly = ToBoolean(_Parameter)
    end
end

function B_Goal_BuildRoad:GetCustomData( _Index )
    local Data
    if _Index == 2 then
        Data = {"true","false"}
    end
    return Data
end

function B_Goal_BuildRoad:Debug(_Quest)
    if not IsExisting(self.Entity1) or not IsExisting(self.Entity2) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": first or second entity does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_BuildRoad);

-- -------------------------------------------------------------------------- --

function Goal_BuildWall(...)
    return B_Goal_BuildWall:new(...)
end

B_Goal_BuildWall = {
    Name = "Goal_BuildWall",
    Description = {
        en = "Goal: Build a wall between 2 positions bo stop the movement of an (hostile) player.",
        de = "Ziel: Baue eine Mauer zwischen 2 Punkten, die die Bewegung eines (feindlichen) Spielers zwischen den Punkten verhindert.",
        fr = "Objectif: Construire un mur entre 2 points qui empêche le déplacement d'un joueur (ennemi) entre les points.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Enemy", de = "Feind", fr = "Ennemi" },
        { ParameterType.ScriptName, en = "Entity 1", de = "Entity 1", fr = "Entité 1" },
        { ParameterType.ScriptName, en = "Entity 2", de = "Entity 2", fr = "Entité 2" },
    },
}

function B_Goal_BuildWall:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_BuildWall:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.EntityName1 = _Parameter
    elseif (_Index == 2) then
        self.EntityName2 = _Parameter
    end
end

function B_Goal_BuildWall:CustomFunction(_Quest)
    local eID1 = GetID(self.EntityName1)
    local eID2 = GetID(self.EntityName2)

    if not IsExisting(eID1) then
        return false
    end
    if not IsExisting(eID2) then
        return false
    end
    local x,y,z = Logic.EntityGetPos(eID1)
    if Logic.IsBuilding(eID1) == 1 then
        x,y = Logic.GetBuildingApproachPosition(eID1)
    end
    local Sector1 = Logic.GetPlayerSectorAtPosition(self.PlayerID, x, y)
    local x,y,z = Logic.EntityGetPos(eID2)
    if Logic.IsBuilding(eID2) == 1 then
        x,y = Logic.GetBuildingApproachPosition(eID2)
    end
    local Sector2 = Logic.GetPlayerSectorAtPosition(self.PlayerID, x, y)
    if Sector1 ~= Sector2 then
        return true
    end
    return nil
end

function B_Goal_BuildWall:GetMsgKey()
    return "Quest_Create_Wall"
end

function B_Goal_BuildWall:GetIcon()
    return {3,9}
end

function B_Goal_BuildWall:Debug(_Quest)
    if not IsExisting(self.EntityName1) or not IsExisting(self.EntityName2) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": first or second entity does not exist!");
        return true;
    elseif not tonumber(self.PlayerID) or self.PlayerID < 1 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end

    if GetDiplomacyState(_Quest.ReceivingPlayer, self.PlayerID) > -1 and not self.WarningPrinted then
        warn(false, _Quest.Identifier.. ": " ..self.Name..": player %d is neighter enemy or unknown to quest receiver!");
        self.WarningPrinted = true;
    end
    return false;
end

RegisterBehavior(B_Goal_BuildWall);

-- -------------------------------------------------------------------------- --

function Goal_Claim(...)
    return B_Goal_Claim:new(...)
end

B_Goal_Claim = {
    Name = "Goal_Claim",
    Description = {
        en = "Goal: Claim a territory",
        de = "Ziel: Erobere ein Territorium",
        fr = "Objectif: Conquérir un territoire",
    },
    Parameter = {
        { ParameterType.TerritoryName, en = "Territory", de = "Territorium", fr = "Territoire" },
    },
}

function B_Goal_Claim:GetGoalTable()
    return { Objective.Claim, 1, self.TerritoryID }
end

function B_Goal_Claim:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.TerritoryID = tonumber(_Parameter)
        if not self.TerritoryID then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
    end
end

function B_Goal_Claim:GetMsgKey()
    return "Quest_Claim_Territory"
end

RegisterBehavior(B_Goal_Claim);

-- -------------------------------------------------------------------------- --

function Goal_ClaimXTerritories(...)
    return B_Goal_ClaimXTerritories:new(...)
end

B_Goal_ClaimXTerritories = {
    Name = "Goal_ClaimXTerritories",
    Description = {
        en = "Goal: Claim the given number of territories, all player territories are counted",
        de = "Ziel: Erobere die angegebene Anzahl Territorien, alle spielereigenen Territorien werden gezählt",
        fr = "Objectif: conquérir le nombre de territoires indiqué, tous les territoires des joueurs sont comptabilisés.",
    },
    Parameter = {
        { ParameterType.Number, en = "Territories" , de = "Territorien", fr = "Territoire" }
    },
}

function B_Goal_ClaimXTerritories:GetGoalTable()
    return { Objective.Claim, 2, self.TerritoriesToClaim }
end

function B_Goal_ClaimXTerritories:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.TerritoriesToClaim = _Parameter * 1
    end
end

function B_Goal_ClaimXTerritories:GetMsgKey()
    return "Quest_Claim_Territory"
end

RegisterBehavior(B_Goal_ClaimXTerritories);

-- -------------------------------------------------------------------------- --

function Goal_Create(...)
    return B_Goal_Create:new(...);
end

B_Goal_Create = {
    Name = "Goal_Create",
    Description = {
        en = "Goal: Create Buildings/Units on a specified territory",
        de = "Ziel: Erstelle Einheiten/Gebäude auf einem bestimmten Territorium.",
        fr = "Objectif: créer des unités/bâtiments sur un territoire donné.",
    },
    Parameter = {
        { ParameterType.Entity, en = "Type name", de = "Typbezeichnung", fr = "Désignation du type" },
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr = "Quantité" },
        { ParameterType.TerritoryNameWithUnknown, en = "Territory", de = "Territorium", fr = "Territoire" },
    },
}

function B_Goal_Create:GetGoalTable()
    return { Objective.Create, assert( Entities[self.EntityName] ), self.Amount, self.TerritoryID }
end

function B_Goal_Create:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.EntityName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
    elseif (_Index == 2) then
        self.TerritoryID = tonumber(_Parameter)
        if not self.TerritoryID then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
    end
end

function B_Goal_Create:GetMsgKey()
    return Logic.IsEntityTypeInCategory( Entities[self.EntityName], EntityCategories.AttackableBuilding ) == 1 and "Quest_Create_Building" or "Quest_Create_Unit"
end

RegisterBehavior(B_Goal_Create);

-- -------------------------------------------------------------------------- --

function Goal_Produce(...)
    return B_Goal_Produce:new(...);
end

B_Goal_Produce = {
    Name = "Goal_Produce",
    Description = {
        en = "Goal: Produce an amount of goods",
        de = "Ziel: Produziere eine Anzahl einer bestimmten Ware.",
        fr = "Objectif: produire un certain nombre d'une marchandise donnée."
    },
    Parameter = {
        { ParameterType.RawGoods, en = "Type of good", de = "Ressourcentyp", fr = "Type de ressources" },
        { ParameterType.Number, en = "Amount of good", de = "Anzahl der Ressource", fr = "Quantité de ressources" },
    },
}

function B_Goal_Produce:GetGoalTable()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    return { Objective.Produce, GoodType, self.GoodAmount }
end

function B_Goal_Produce:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 1) then
        self.GoodAmount = _Parameter * 1
    end
end

function B_Goal_Produce:GetMsgKey()
    return "Quest_Produce"
end

RegisterBehavior(B_Goal_Produce);

-- -------------------------------------------------------------------------- --

function Goal_GoodAmount(...)
    return B_Goal_GoodAmount:new(...);
end

B_Goal_GoodAmount = {
    Name = "Goal_GoodAmount",
    Description = {
        en = "Goal: Obtain an amount of goods - either by trading or producing them",
        de = "Ziel: Beschaffe eine Anzahl Waren - entweder durch Handel oder durch eigene Produktion.",
        fr = "Objectif: Se procurer un certain nombre de marchandises - soit par le commerce, soit par sa propre production."
    },
    Parameter = {
        { ParameterType.Custom, en = "Type of good", de = "Warentyp", fr = "TYpe de marchandises" },
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr = "Quantité" },
        { ParameterType.Custom, en = "Relation", de = "Relation", fr = "Relation" },
    },
}

function B_Goal_GoodAmount:GetGoalTable()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    return { Objective.Produce, GoodType, self.GoodAmount, self.bRelSmallerThan }
end

function B_Goal_GoodAmount:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 1) then
        self.GoodAmount = _Parameter * 1
    elseif  (_Index == 2) then
        self.bRelSmallerThan = _Parameter == "<" or tostring(_Parameter) == "true"
    end
end

function B_Goal_GoodAmount:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for k, v in pairs( Goods ) do
            if string.find( k, "^G_" ) then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        table.insert( Data, ">=" )
        table.insert( Data, "<" )
    else
        assert( false )
    end
    return Data
end

RegisterBehavior(B_Goal_GoodAmount);

-- -------------------------------------------------------------------------- --

function Goal_SatisfyNeed(...)
    return B_Goal_SatisfyNeed:new(...);
end

B_Goal_SatisfyNeed = {
    Name = "Goal_SatisfyNeed",
    Description = {
        en = "Goal: Satisfy a need",
        de = "Ziel: Erfuelle ein Beduerfnis",
        fr = "Objectif: Répondre à un besoin",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Need, en = "Need", de = "Beduerfnis", fr = "Besoin" },
    },
}

function B_Goal_SatisfyNeed:GetGoalTable()
    return { Objective.SatisfyNeed, Needs[self.Need], self.PlayerID }

end

function B_Goal_SatisfyNeed:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Need = _Parameter
    end

end

function B_Goal_SatisfyNeed:GetMsgKey()
    local tMapping = {
        [Needs.Clothes] = "Quest_SatisfyNeed_Clothes",
        [Needs.Entertainment] = "Quest_SatisfyNeed_Entertainment",
        [Needs.Nutrition] = "Quest_SatisfyNeed_Food",
        [Needs.Hygiene] = "Quest_SatisfyNeed_Hygiene",
        [Needs.Medicine] = "Quest_SatisfyNeed_Medicine",
    }

    local Key = tMapping[Needs[self.Need]]
    if Key then
        return Key
    end

    -- No default message
end

RegisterBehavior(B_Goal_SatisfyNeed);

-- -------------------------------------------------------------------------- --

function Goal_SettlersNumber(...)
    return B_Goal_SettlersNumber:new(...);
end

B_Goal_SettlersNumber = {
    Name = "Goal_SettlersNumber",
    Description = {
        en = "Goal: Get a given amount of settlers",
        de = "Ziel: Erreiche eine bestimmte Anzahl Siedler.",
        fr = "Objectif: atteindre un certain nombre de Settlers.",
    },
    Parameter = {
        { ParameterType.Number,   en = "Amount", de = "Anzahl", fr = "Quantité" },
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Goal_SettlersNumber:GetGoalTable()
    return {Objective.SettlersNumber, self.PlayerID or 1, self.SettlersAmount };
end

function B_Goal_SettlersNumber:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.SettlersAmount = _Parameter * 1;
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1;
    end
end

function B_Goal_SettlersNumber:GetMsgKey()
    return "Quest_NumberSettlers";
end

RegisterBehavior(B_Goal_SettlersNumber);

-- -------------------------------------------------------------------------- --

function Goal_Spouses(...)
    return B_Goal_Spouses:new(...);
end

B_Goal_Spouses = {
    Name = "Goal_Spouses",
    Description = {
        en = "Goal: Get a given amount of spouses",
        de = "Ziel: Erreiche eine bestimmte Ehefrauenanzahl",
        fr = "Objectif: Atteindre un certain nombre d'épouses",
    },
    Parameter = {
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr = "Quantité" },
    },
}

function B_Goal_Spouses:GetGoalTable()
    return {Objective.Spouses, self.SpousesAmount }
end

function B_Goal_Spouses:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.SpousesAmount = _Parameter * 1
    end
end

function B_Goal_Spouses:GetMsgKey()
    return "Quest_NumberSpouses"
end

RegisterBehavior(B_Goal_Spouses);

-- -------------------------------------------------------------------------- --

function Goal_SoldierCount(...)
    return B_Goal_SoldierCount:new(...);
end

B_Goal_SoldierCount = {
    Name = "Goal_SoldierCount",
    Description = {
        en = "Goal: Create a specified number of soldiers",
        de = "Ziel: Erreiche eine Anzahl grösser oder kleiner der angegebenen Menge Soldaten.",
        fr = "Objectif: Atteindre un nombre de soldats supérieur ou inférieur à la quantité indiquée.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Custom, en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Number, en = "Number of soldiers", de = "Anzahl Soldaten", fr = "Nombre de soldats" },
    },
}

function B_Goal_SoldierCount:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_SoldierCount:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.bRelSmallerThan = tostring(_Parameter) == "true" or tostring(_Parameter) == "<"
    elseif (_Index == 2) then
        self.NumberOfUnits = _Parameter * 1
    end
end

function B_Goal_SoldierCount:CustomFunction(_Quest)
    if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local Relation = tostring(self.bRelSmallerThan);
        local PlayerName = GetPlayerName(self.PlayerID) or "";
        Lib.Core.Quest:ChangeCustomQuestCaptionText(
            string.format(
                Localize(Lib.Core.Quest.Text.SoldierCount.Pattern),
                PlayerName,
                Localize(Lib.Core.Quest.Text.SoldierCount.Relation[Relation]),
                self.NumberOfUnits
            ),
            _Quest
        );
    end

    local NumSoldiers = Logic.GetCurrentSoldierCount( self.PlayerID )
    if ( self.bRelSmallerThan and NumSoldiers < self.NumberOfUnits ) then
        return true
    elseif ( not self.bRelSmallerThan and NumSoldiers >= self.NumberOfUnits ) then
        return true
    end
    return nil
end

function B_Goal_SoldierCount:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then

        table.insert( Data, ">=" )
        table.insert( Data, "<" )

    else
        assert( false )
    end
    return Data
end

function B_Goal_SoldierCount:GetIcon()
    return {7,11}
end

function B_Goal_SoldierCount:GetMsgKey()
    return "Quest_Create_Unit"
end

function B_Goal_SoldierCount:Debug(_Quest)
    if tonumber(self.NumberOfUnits) == nil or self.NumberOfUnits < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": amount can not be below 0!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_SoldierCount);

-- -------------------------------------------------------------------------- --

function Goal_KnightTitle(...)
    return B_Goal_KnightTitle:new(...);
end

B_Goal_KnightTitle = {
    Name = "Goal_KnightTitle",
    Description = {
        en = "Goal: Reach a specified knight title",
        de = "Ziel: Erreiche einen vorgegebenen Titel",
        fr = "Objectif: atteindre un titre donné",
    },
    Parameter = {
        { ParameterType.Custom, en = "Knight title", de = "Titel", fr = "Titre" },
    },
}

function B_Goal_KnightTitle:GetGoalTable()
    return {Objective.KnightTitle, assert( KnightTitles[self.KnightTitle] ) }
end

function B_Goal_KnightTitle:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.KnightTitle = _Parameter
    end
end

function B_Goal_KnightTitle:GetMsgKey()
    return "Quest_KnightTitle"
end

function B_Goal_KnightTitle:GetCustomData( _Index )
    return {"Knight", "Mayor", "Baron", "Earl", "Marquees", "Duke", "Archduke"}
end

RegisterBehavior(B_Goal_KnightTitle);

-- -------------------------------------------------------------------------- --

function Goal_Festivals(...)
    return B_Goal_Festivals:new(...);
end

B_Goal_Festivals = {
    Name = "Goal_Festivals",
    Description = {
        en = "Goal: The player has to start the given number of festivals.",
        de = "Ziel: Der Spieler muss eine gewisse Anzahl Feste gestartet haben.",
        fr = "Objectif: Le joueur doit avoir lancé un certain nombre de festivités."
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
        { ParameterType.Number, en = "Number of festivals", de = "Anzahl Feste", fr = "Nombre de festivités" }
    }
};

function B_Goal_Festivals:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} };
end

function B_Goal_Festivals:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.PlayerID = tonumber(_Parameter);
    else
        assert(_Index == 1, "Error in " .. self.Name .. ": AddParameter: Index is invalid.");
        self.NeededFestivals = tonumber(_Parameter);
    end
end

function B_Goal_Festivals:CustomFunction(_Quest)
    if not _Quest.QuestDescription or _Quest.QuestDescription == "" then
        local PlayerName = GetPlayerName(self.PlayerID) or "";
        Lib.Core.Quest:ChangeCustomQuestCaptionText(
            string.format(
                Localize(Lib.Core.Quest.Text.Festivals.Pattern),
                PlayerName, self.NeededFestivals
            ), 
            _Quest
        );
    end

    if Logic.GetStoreHouse( self.PlayerID ) == 0  then
        return false
    end
    local tablesOnFestival = {Logic.GetPlayerEntities(self.PlayerID, Entities.B_TableBeer, 5,0)}
    local amount = 0
    for k=2, #tablesOnFestival do
        local tableID = tablesOnFestival[k]
        if Logic.GetIndexOnOutStockByGoodType(tableID, Goods.G_Beer) ~= -1 then
            local goodAmountOnMarketplace = Logic.GetAmountOnOutStockByGoodType(tableID, Goods.G_Beer)
            amount = amount + goodAmountOnMarketplace
        end
    end
    if not self.FestivalStarted and amount > 0 then
        self.FestivalStarted = true
        self.FestivalCounter = (self.FestivalCounter and self.FestivalCounter + 1) or 1
        if self.FestivalCounter >= self.NeededFestivals then
            self.FestivalCounter = nil
            return true
        end
    elseif amount == 0 then
        self.FestivalStarted = false
    end
end

function B_Goal_Festivals:Debug(_Quest)
    if Logic.GetStoreHouse( self.PlayerID ) == 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.PlayerID .. " is dead :-(")
        return true
    elseif GetPlayerCategoryType(self.PlayerID) ~= PlayerCategories.City then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ":  Player "..  self.PlayerID .. " is no city")
        return true
    elseif self.NeededFestivals < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Number of Festivals is negative")
        return true
    end
    return false
end

function B_Goal_Festivals:Reset()
    self.FestivalCounter = nil
    self.FestivalStarted = nil
end

function B_Goal_Festivals:GetIcon()
    return {4,15}
end

RegisterBehavior(B_Goal_Festivals)

-- -------------------------------------------------------------------------- --

function Goal_Capture(...)
    return B_Goal_Capture:new(...)
end

B_Goal_Capture = {
    Name = "Goal_Capture",
    Description = {
        en = "Goal: Capture a cart.",
        de = "Ziel: Ein Karren muss erobert werden.",
        fr = "Objectif: un chariot doit être conquis.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
    },
}

function B_Goal_Capture:GetGoalTable()
    return { Objective.Capture, 1, { self.ScriptName } }
end

function B_Goal_Capture:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Goal_Capture:GetMsgKey()
   local ID = GetID(self.ScriptName)
   if Logic.IsEntityAlive(ID) then
        ID = Logic.GetEntityType( ID )
        if ID and ID ~= 0 then
            if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1 then
                return "Quest_Capture_Cart"

            elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.SiegeEngine ) == 1 then
                return "Quest_Capture_SiegeEngine"

            elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Worker ) == 1
                or Logic.IsEntityTypeInCategory( ID, EntityCategories.Spouse ) == 1
                or Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then

                return "Quest_Capture_VIPOfPlayer"

            end
        end
    end
end

RegisterBehavior(B_Goal_Capture);

-- -------------------------------------------------------------------------- --

function Goal_CaptureType(...)
    return B_Goal_CaptureType:new(...)
end

B_Goal_CaptureType = {
    Name = "Goal_CaptureType",
    Description = {
        en = "Goal: Capture specified entity types",
        de = "Ziel: Nimm bestimmte Entitätstypen gefangen",
        fr = "Objectif: capturer certains types d'entités",
    },
    Parameter = {
        { ParameterType.Custom,     en = "Type name",   de = "Typbezeichnung",  fr = "Désignation du type" },
        { ParameterType.Number,     en = "Amount",      de = "Anzahl",          fr = "Quantité" },
        { ParameterType.PlayerID,   en = "Player",      de = "Spieler",         fr = "Joueur" },
    },
}

function B_Goal_CaptureType:GetGoalTable()
    return { Objective.Capture, 2, Entities[self.EntityName], self.Amount, self.PlayerID }
end

function B_Goal_CaptureType:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.EntityName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
    elseif (_Index == 2) then
        self.PlayerID = _Parameter * 1
    end
end

function B_Goal_CaptureType:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for k, v in pairs( Entities ) do
            if string.find( k, "^U_.+Cart" ) or Logic.IsEntityTypeInCategory( v, EntityCategories.AttackableMerchant ) == 1 then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        for i = 0, 8 do
            table.insert( Data, i )
        end
    else
        assert( false )
    end
    return Data
end

function B_Goal_CaptureType:GetMsgKey()

    local ID = self.EntityName
    if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1 then
        return "Quest_Capture_Cart"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.SiegeEngine ) == 1 then
        return "Quest_Capture_SiegeEngine"

    elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Worker ) == 1
        or Logic.IsEntityTypeInCategory( ID, EntityCategories.Spouse ) == 1
        or Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then

        return "Quest_Capture_VIPOfPlayer"
    end
end

RegisterBehavior(B_Goal_CaptureType);

-- -------------------------------------------------------------------------- --

function Goal_Protect(...)
    return B_Goal_Protect:new(...)
end

B_Goal_Protect = {
    Name = "Goal_Protect",
    Description = {
        en = "Goal: Protect an entity (entity needs a script name",
        de = "Ziel: Beschütze eine Entität (Entität benötigt einen Skriptnamen)",
        fr = "Objectif : Protéger une entité (l'entité nécessite un nom de script)"
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
    },
}

function B_Goal_Protect:GetGoalTable()
    return {Objective.Protect, { self.ScriptName }}
end

function B_Goal_Protect:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Goal_Protect:GetMsgKey()
    if Logic.IsEntityAlive(self.ScriptName) then
        local ID = GetID(self.ScriptName)
        if ID and ID ~= 0 then
            ID = Logic.GetEntityType( ID )
            if ID and ID ~= 0 then
                if Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableBuilding ) == 1 then
                    return "Quest_Protect_Building"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.SpecialBuilding ) == 1 then
                    local tMapping = {
                        [PlayerCategories.City]        = "Quest_Protect_City",
                        [PlayerCategories.Cloister]    = "Quest_Protect_Cloister",
                        [PlayerCategories.Village]    = "Quest_Protect_Village",
                    }
                    local PlayerCategory = GetPlayerCategoryType( Logic.EntityGetPlayer(GetID(self.ScriptName)) )
                    if PlayerCategory then
                        local Key = tMapping[PlayerCategory]
                        if Key then
                            return Key
                        end
                    end
                    return "Quest_Protect_Building"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.Hero ) == 1 then
                    return "Quest_Protect_Knight"

                elseif Logic.IsEntityTypeInCategory( ID, EntityCategories.AttackableMerchant ) == 1 then
                    return "Quest_Protect_Cart"
                end
            end
        end
    end
    return "Quest_Protect"
end

RegisterBehavior(B_Goal_Protect);

-- -------------------------------------------------------------------------- --

function Goal_Refill(...)
    return B_Goal_Refill:new(...)
end

B_Goal_Refill = {
    Name = "Goal_Refill",
    Description = {
        en = "Goal: Refill an object using a geologist",
        de = "Ziel: Eine Mine soll durch einen Geologen wieder aufgefuellt werden.",
        fr = "Objectif: Une mine doit être réalimentée par un géologue.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
    },
   RequiresExtraNo = 1,
}

function B_Goal_Refill:GetGoalTable()
    return { Objective.Refill, { GetID(self.ScriptName) } }
end

function B_Goal_Refill:GetIcon()
    return {8,1,1}
end

function B_Goal_Refill:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

if g_GameExtraNo > 0 then
    RegisterBehavior(B_Goal_Refill);
end

-- -------------------------------------------------------------------------- --

function Goal_ResourceAmount(...)
    return B_Goal_ResourceAmount:new(...)
end

B_Goal_ResourceAmount = {
    Name = "Goal_ResourceAmount",
    Description = {
        en = "Goal: Reach a specified amount of resources in a doodad",
        de = "Ziel: In einer Mine soll weniger oder mehr als eine angegebene Anzahl an Rohstoffen sein.",
        fr = "Objectif: Dans une mine, il doit y avoir moins ou plus de matières premières qu'un nombre indiqué.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de l'entité" },
        { ParameterType.Custom, en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Number, en = "Amount", de = "Menge", fr = "Quantité" },
    },
}

function B_Goal_ResourceAmount:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} }
end

function B_Goal_ResourceAmount:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        self.bRelSmallerThan = _Parameter == "<"
    elseif (_Index == 2) then
        self.Amount = _Parameter * 1
    end
end

function B_Goal_ResourceAmount:CustomFunction(_Quest)
    local ID = GetID(self.ScriptName)
    if ID and ID ~= 0 and Logic.GetResourceDoodadGoodType(ID) ~= 0 then
        local HaveAmount = Logic.GetResourceDoodadGoodAmount(ID)
        if ( self.bRelSmallerThan and HaveAmount < self.Amount ) or ( not self.bRelSmallerThan and HaveAmount >= self.Amount ) then
            return true
        end
    end
    return nil
end

function B_Goal_ResourceAmount:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then
        table.insert( Data, ">=" )
        table.insert( Data, "<" )
    else
        assert( false )
    end
    return Data
end

function B_Goal_ResourceAmount:Debug(_Quest)
    if not IsExisting(self.ScriptName) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": entity '" ..self.ScriptName.. "' does not exist!");
        return true;
    elseif tonumber(self.Amount) == nil or self.Amount < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": error at amount! (nil or below 0)");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_ResourceAmount);

-- -------------------------------------------------------------------------- --

function Goal_InstantFailure()
    return B_Goal_InstantFailure:new()
end

B_Goal_InstantFailure = {
    Name = "Goal_InstantFailure",
    Description = {
        en = "Goal: Instant failure, the goal returns false.",
        de = "Ziel: Direkter Misserfolg, das Goal sendet false.",
        fr = "Objectif: échec direct, le goal envoie false.",
    },
}

function B_Goal_InstantFailure:GetGoalTable()
    return {Objective.DummyFail};
end

RegisterBehavior(B_Goal_InstantFailure);

-- -------------------------------------------------------------------------- --

function Goal_InstantSuccess()
    return B_Goal_InstantSuccess:new()
end

B_Goal_InstantSuccess = {
    Name = "Goal_InstantSuccess",
    Description = {
        en = "Goal: Instant success, the goal returns true.",
        de = "Ziel: Direkter Erfolg, das Goal sendet true.",
        fr = "Objectif: succès direct, le goal envoie false."
    },
}

function B_Goal_InstantSuccess:GetGoalTable()
    return {Objective.Dummy};
end

RegisterBehavior(B_Goal_InstantSuccess);

-- -------------------------------------------------------------------------- --

function Goal_NoChange()
    return B_Goal_NoChange:new()
end

B_Goal_NoChange = {
    Name = "Goal_NoChange",
    Description = {
        en = "Goal: The quest state doesn't change. Use reward functions of other quests to change the state of this quest.",
        de = "Ziel: Der Questzustand wird nicht verändert. Ein Reward einer anderen Quest sollte den Zustand dieser Quest verändern.",
        fr = "Objectif: L'état de la quête n'est pas modifié. Une récompense d'une autre quête doit modifier l'état de cette quête.",
    },
}

function B_Goal_NoChange:GetGoalTable()
    return { Objective.NoChange }
end

RegisterBehavior(B_Goal_NoChange);

-- -------------------------------------------------------------------------- --

function Goal_MapScriptFunction(...)
    return B_Goal_MapScriptFunction:new(...);
end

B_Goal_MapScriptFunction = {
    Name = "Goal_MapScriptFunction",
    Description = {
        en = "Goal: Calls a function within the global map script. Return 'true' means success, 'false' means failure and 'nil' doesn't change anything.",
        de = "Ziel: Ruft eine Funktion im globalen Skript auf, die einen Wahrheitswert zurueckgibt. Rueckgabe 'true' gilt als erfuellt, 'false' als gescheitert und 'nil' ändert nichts.",
        fr = "Objectif: Appelle une fonction dans le script global qui renvoie une valeur de vérité. Le retour 'true' est considéré comme rempli, 'false' comme échoué et 'nil' ne change rien.",
    },
    Parameter = {
        { ParameterType.Default, en = "Function name", de = "Funktionsname", fr = "Nom de la fonction" },
    },
}

function B_Goal_MapScriptFunction:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_MapScriptFunction:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.FuncName = _Parameter
    end
end

function B_Goal_MapScriptFunction:CustomFunction(_Quest)
    if type(self.FuncName) == "function" then
        return self.FuncName(unpack(self.i47ya_6aghw_frxil));
    end
    return _G[self.FuncName](self, _Quest);
end

function B_Goal_MapScriptFunction:Debug(_Quest)
    if not self.FuncName then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": function reference is invalid!");
        return true;
    end
    if type(self.FuncName) ~= "function" and not _G[self.FuncName] then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": function does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_MapScriptFunction);

-- -------------------------------------------------------------------------- --

function Goal_CustomVariables(...)
    return B_Goal_CustomVariables:new(...);
end

B_Goal_CustomVariables = {
    Name = "Goal_CustomVariables",
    Description = {
        en = "Goal: A customised variable has to assume a certain value.",
        de = "Ziel: Eine benutzerdefinierte Variable muss einen bestimmten Wert annehmen.",
        fr = "Objectif: une variable définie par l'utilisateur doit prendre une certaine valeur.",
    },
    Parameter = {
        { ParameterType.Default, en = "Name of Variable", de = "Variablenname", fr = "Nom de la variable" },
        { ParameterType.Custom,  en = "Relation", de = "Relation", fr = "Relation" },
        { ParameterType.Default, en = "Value or variable", de = "Wert oder Variable", fr = "Valeur ou variable" }
    }
};

function B_Goal_CustomVariables:GetGoalTable()
    return { Objective.Custom2, {self, self.CustomFunction} };
end

function B_Goal_CustomVariables:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.VariableName = _Parameter
    elseif _Index == 1 then
        self.Relation = _Parameter
    elseif _Index == 2 then
        local value = tonumber(_Parameter);
        self.Value = (value == nil and tostring(_Parameter)) or value;
    end
end

function B_Goal_CustomVariables:CustomFunction()
    local Value1 = ObtainCustomVariable("BehaviorVariable_" ..self.VariableName, 0);
    local Value2 = self.Value;
    if type(self.Value) == "string" then
        Value2 = ObtainCustomVariable("BehaviorVariable_" ..self.Value, 0);
    end

    if self.Relation == "==" then
        if Value1 == Value2 then
            return true;
        end
    elseif self.Relation == "~=" then
        if Value1 == Value2 then
            return true;
        end
    elseif self.Relation == "<" then
        if Value1 < Value2 then
            return true;
        end
    elseif self.Relation == "<=" then
        if Value1 <= Value2 then
            return true;
        end
    elseif self.Relation == ">=" then
        if Value1 >= Value2 then
            return true;
        end
    else
        if Value1 > Value2 then
            return true;
        end
    end
    return nil;
end

function B_Goal_CustomVariables:GetCustomData( _Index )
    return {"==", "~=", "<=", "<", ">", ">="};
end

function B_Goal_CustomVariables:Debug(_Quest)
    local relations = {"==", "~=", "<=", "<", ">", ">="}
    local results    = {true, false, nil}

    if not ObtainCustomVariable("BehaviorVariable_" ..self.VariableName) then
        warn(false, _Quest.Identifier.. ": " ..self.Name..": variable '"..self.VariableName.."' does not exist!");
    end
    if not table.contains(relations, self.Relation) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": '"..self.Relation.."' is an invalid relation!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_CustomVariables)

-- -------------------------------------------------------------------------- --

function Reprisal_ObjectDeactivate(...)
    return B_Reprisal_InteractiveObjectDeactivate:new(...);
end

B_Reprisal_InteractiveObjectDeactivate = {
    Name = "Reprisal_InteractiveObjectDeactivate",
    Description = {
        en = "Reprisal: Deactivates an interactive object",
        de = "Vergeltung: Deaktiviert ein interaktives Objekt",
        fr = "Rétribution: désactive un objet interactif",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Interactive object", de = "Interaktives Objekt", fr = "Object interactif" },
    },
}

function B_Reprisal_InteractiveObjectDeactivate:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_InteractiveObjectDeactivate:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.ScriptName = _Parameter
    end

end

function B_Reprisal_InteractiveObjectDeactivate:CustomFunction(_Quest)
    InteractiveObjectDeactivate(self.ScriptName);
end

function B_Reprisal_InteractiveObjectDeactivate:Debug(_Quest)
    if not Logic.IsInteractiveObject(GetID(self.ScriptName)) and not self.WarningPrinted then
        warn(false, _Quest.Identifier.. ": " ..self.Name..": '" ..self.ScriptName.. "' is not a interactive object!");
        self.WarningPrinted = true;
    end
    local eID = GetID(self.ScriptName);
    if CONST_INITIALIZED_OBJECTS[eID] and CONST_INITIALIZED_OBJECTS[eID] == _Quest.Identifier then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": you can not deactivate in the same quest the object is initalized!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_InteractiveObjectDeactivate);

-- -------------------------------------------------------------------------- --

function Reprisal_ObjectActivate(...)
    return B_Reprisal_InteractiveObjectActivate:new(...);
end

B_Reprisal_InteractiveObjectActivate = {
    Name = "Reprisal_InteractiveObjectActivate",
    Description = {
        en = "Reprisal: Activates an interactive object",
        de = "Vergeltung: Aktiviert ein interaktives Objekt",
        fr = "Retribution : active un objet interactif",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Interactive object",  de = "Interaktives Objekt", fr = "Object interactif" },
        { ParameterType.Custom,     en = "Availability",        de = "Nutzbarkeit",         fr = "Utilisabilité" },
    },
}

function B_Reprisal_InteractiveObjectActivate:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_InteractiveObjectActivate:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        local parameter = 0
        if _Parameter == "Always" or 1 then
            parameter = 1
        end
        self.UsingState = parameter * 1
    end
end

function B_Reprisal_InteractiveObjectActivate:CustomFunction(_Quest)
    InteractiveObjectActivate(self.ScriptName, self.UsingState);
end

function B_Reprisal_InteractiveObjectActivate:GetCustomData( _Index )
    if _Index == 1 then
        return {"Knight only", "Always"}
    end
end

function B_Reprisal_InteractiveObjectActivate:Debug(_Quest)
    if not Logic.IsInteractiveObject(GetID(self.ScriptName)) and not self.WarningPrinted then
        warn(false, _Quest.Identifier.. ": " ..self.Name..": '" ..self.ScriptName.. "' is not a interactive object!");
        self.WarningPrinted = true;
    end
    local eID = GetID(self.ScriptName);
    if CONST_INITIALIZED_OBJECTS[eID] and CONST_INITIALIZED_OBJECTS[eID] == _Quest.Identifier then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": you can not activate in the same quest the object is initalized!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_InteractiveObjectActivate);

-- -------------------------------------------------------------------------- --

function Reprisal_DiplomacyDecrease()
    return B_Reprisal_SlightlyDiplomacyDecrease:new();
end

B_Reprisal_SlightlyDiplomacyDecrease = {
    Name = "Reprisal_SlightlyDiplomacyDecrease",
    Description = {
        en = "Reprisal: Diplomacy decreases slightly to another player.",
        de = "Vergeltung: Der Diplomatiestatus zum Auftraggeber wird um eine Stufe verringert.",
        fr = "Rétribution: le statut diplomatique avec le mandant est réduit d'un niveau.",
    },
}

function B_Reprisal_SlightlyDiplomacyDecrease:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_SlightlyDiplomacyDecrease:CustomFunction(_Quest)
    local Sender = _Quest.SendingPlayer;
    local Receiver = _Quest.ReceivingPlayer;
    local State = GetDiplomacyState(Receiver, Sender);
    if State > -2 then
        SetDiplomacyState(Receiver, Sender, State-1);
    end
end

function B_Reprisal_SlightlyDiplomacyDecrease:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

RegisterBehavior(B_Reprisal_SlightlyDiplomacyDecrease);

-- -------------------------------------------------------------------------- --

function Reprisal_Diplomacy(...)
    return B_Reprisal_Diplomacy:new(...);
end

B_Reprisal_Diplomacy = {
    Name = "Reprisal_Diplomacy",
    Description = {
        en = "Reprisal: Sets Diplomacy state of two Players to a stated value.",
        de = "Vergeltung: Setzt den Diplomatiestatus zweier Spieler auf den angegebenen Wert.",
        fr = "Rétribution: Définit le statut diplomatique de deux joueurs sur la valeur indiquée.",
    },
    Parameter = {
        { ParameterType.PlayerID,         en = "PlayerID 1", de = "Spieler 1", fr = "Joueur 1" },
        { ParameterType.PlayerID,         en = "PlayerID 2", de = "Spieler 2", fr = "Joueur 2" },
        { ParameterType.DiplomacyState,   en = "Relation",   de = "Beziehung", fr = "Relation diplomatique" },
    },
}

function B_Reprisal_Diplomacy:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_Diplomacy:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID1 = _Parameter * 1
    elseif (_Index == 1) then
        self.PlayerID2 = _Parameter * 1
    elseif (_Index == 2) then
        self.Relation = DiplomacyStates[_Parameter]
    end
end

function B_Reprisal_Diplomacy:CustomFunction(_Quest)
    SetDiplomacyState(self.PlayerID1, self.PlayerID2, self.Relation);
end

function B_Reprisal_Diplomacy:Debug(_Quest)
    if not tonumber(self.PlayerID1) or self.PlayerID1 < 1 or self.PlayerID1 > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": PlayerID 1 is invalid!");
        return true;
    elseif not tonumber(self.PlayerID2) or self.PlayerID2 < 1 or self.PlayerID2 > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": PlayerID 2 is invalid!");
        return true;
    elseif not tonumber(self.Relation) or self.Relation < -2 or self.Relation > 2 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": '"..self.Relation.."' is a invalid diplomacy state!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_Diplomacy);

-- -------------------------------------------------------------------------- --

function Reprisal_DestroyEntity(...)
    return B_Reprisal_DestroyEntity:new(...);
end

B_Reprisal_DestroyEntity = {
    Name = "Reprisal_DestroyEntity",
    Description = {
        en = "Reprisal: Replaces an entity with an invisible script entity, which retains the entities name.",
        de = "Vergeltung: Ersetzt eine Entity mit einer unsichtbaren Script-Entity, die den Namen übernimmt.",
        fr = "Rétribution: remplace une entité par une entité de script invisible qui prend son nom.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Entity", de = "Entity", fr = "Entité" },
    },
}

function B_Reprisal_DestroyEntity:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_DestroyEntity:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Reprisal_DestroyEntity:CustomFunction(_Quest)
    ReplaceEntity(self.ScriptName, Entities.XD_ScriptEntity);
end

function B_Reprisal_DestroyEntity:Debug(_Quest)
    if not IsExisting(self.ScriptName) and not self.WarningPrinted then
        warn(false, _Quest.Identifier .. ": " ..self.Name..": '" ..self.ScriptName.. "' is already destroyed!");
        self.WarningPrinted = true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_DestroyEntity);

-- -------------------------------------------------------------------------- --

function Reprisal_DestroyEffect(...)
    return B_Reprisal_DestroyEffect:new(...);
end

B_Reprisal_DestroyEffect = {
    Name = "Reprisal_DestroyEffect",
    Description = {
        en = "Reprisal: Destroys an effect",
        de = "Vergeltung: Zerstört einen Effekt",
        fr = "Rétribution: détruit un effet",
    },
    Parameter = {
        { ParameterType.Default, en = "Effect name", de = "Effektname", fr = "Nom de l'effet" },
    }
}

function B_Reprisal_DestroyEffect:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.EffectName = _Parameter;
    end
end

function B_Reprisal_DestroyEffect:GetReprisalTable()
    return { Reprisal.Custom, { self, self.CustomFunction } };
end

function B_Reprisal_DestroyEffect:CustomFunction(_Quest)
    if not CONST_EFFECT_NAME_TO_ID[self.EffectName] or not Logic.IsEffectRegistered(CONST_EFFECT_NAME_TO_ID[self.EffectName]) then
        return;
    end
    Logic.DestroyEffect(CONST_EFFECT_NAME_TO_ID[self.EffectName]);
end

function B_Reprisal_DestroyEffect:Debug(_Quest)
    if not CONST_EFFECT_NAME_TO_ID[self.EffectName] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Effect " .. self.EffectName .. " never created")
    end
    return false;
end

RegisterBehavior(B_Reprisal_DestroyEffect);

-- -------------------------------------------------------------------------- --

function Reprisal_Defeat()
    return B_Reprisal_Defeat:new()
end

B_Reprisal_Defeat = {
    Name = "Reprisal_Defeat",
    Description = {
        en = "Reprisal: The player loses the game.",
        de = "Vergeltung: Der Spieler verliert das Spiel.",
        fr = "Rétribution: le joueur perd la partie.",
    },
}

function B_Reprisal_Defeat:GetReprisalTable()
    return {Reprisal.Defeat};
end

RegisterBehavior(B_Reprisal_Defeat);

-- -------------------------------------------------------------------------- --

function Reprisal_FakeDefeat()
    return B_Reprisal_FakeDefeat:new();
end

B_Reprisal_FakeDefeat = {
    Name = "Reprisal_FakeDefeat",
    Description = {
        en = "Reprisal: Displays a defeat icon for a quest",
        de = "Vergeltung: Zeigt ein Niederlage Icon fuer eine Quest an",
        fr = "Rétribution: affiche une icône de défaite pour une quête",
    },
}

function B_Reprisal_FakeDefeat:GetReprisalTable()
    return { Reprisal.FakeDefeat }
end

RegisterBehavior(B_Reprisal_FakeDefeat);

-- -------------------------------------------------------------------------- --

function Reprisal_ReplaceEntity(...)
    return B_Reprisal_ReplaceEntity:new(...);
end

B_Reprisal_ReplaceEntity = {
    Name = "Reprisal_ReplaceEntity",
    Description = {
        en = "Reprisal: Replaces an entity with a new one of a different type. The playerID can be changed too.",
        de = "Vergeltung: Ersetzt eine Entity durch eine neue anderen Typs. Es kann auch die Spielerzugehörigkeit geändert werden.",
        fr = "Rétribution: remplace une entité par une nouvelle entité d'un autre type. Il est également possible de changer l'appartenance d'un joueur.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Target", de = "Ziel", fr = "Cible" },
        { ParameterType.Custom, en = "New Type", de = "Neuer Typ", fr = "Nouveau type" },
        { ParameterType.Custom, en = "New playerID", de = "Neue Spieler ID", fr = "Nouvelle ID de joueur" },
    },
}

function B_Reprisal_ReplaceEntity:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_ReplaceEntity:AddParameter(_Index, _Parameter)
   if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        self.NewType = _Parameter
    elseif (_Index == 2) then
        self.PlayerID = tonumber(_Parameter);
    end
end

function B_Reprisal_ReplaceEntity:CustomFunction(_Quest)
    local eID = GetID(self.ScriptName);
    local pID = self.PlayerID;
    if pID == Logic.EntityGetPlayer(eID) then
        pID = nil;
    end
    ReplaceEntity(self.ScriptName, Entities[self.NewType], pID);
end

function B_Reprisal_ReplaceEntity:GetCustomData(_Index)
    local Data = {}
    if _Index == 1 then
        for k, v in pairs( Entities ) do
            local name = {"^M_","^XS_","^X_","^XT_","^Z_", "^XB_"}
            local found = false;
            for i=1,#name do
                if k:find(name[i]) then
                    found = true;
                    break;
                end
            end
            if not found then
                table.insert( Data, k );
            end
        end
        table.sort( Data )
    elseif _Index == 2 then
        Data = {"-","0","1","2","3","4","5","6","7","8",}
    end
    return Data
end

function B_Reprisal_ReplaceEntity:Debug(_Quest)
    if not Entities[self.NewType] then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid entity type!");
        return true;
    elseif self.PlayerID ~= nil and (self.PlayerID < 1 or self.PlayerID > 8) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end

    if not IsExisting(self.ScriptName) and not self.WarningPrinted then
        self.WarningPrinted = true;
        warn(false, _Quest.Identifier.. ": " ..self.Name..": '" ..self.ScriptName.. "' does not exist!");
    end
    return false;
end

RegisterBehavior(B_Reprisal_ReplaceEntity);

-- -------------------------------------------------------------------------- --

function Reprisal_QuestRestart(...)
    return B_Reprisal_QuestRestart:new(...)
end

B_Reprisal_QuestRestart = {
    Name = "Reprisal_QuestRestart",
    Description = {
        en = "Reprisal: Restarts a (completed) quest so it can be triggered and completed again",
        de = "Vergeltung: Startet eine (beendete) Quest neu, damit diese neu ausgelöst und beendet werden kann",
        fr = "Rétribution : relance une quête (terminée) pour qu'elle puisse être redéclenchée et terminée à nouveau",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
    },
}

function B_Reprisal_QuestRestart:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_QuestRestart:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Reprisal_QuestRestart:CustomFunction(_Quest)
    RestartQuest(self.QuestName, true);
end

function B_Reprisal_QuestRestart:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": quest "..  self.QuestName .. " does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_QuestRestart);

-- -------------------------------------------------------------------------- --

function Reprisal_QuestFailure(...)
    return B_Reprisal_QuestFailure:new(...)
end

B_Reprisal_QuestFailure = {
    Name = "Reprisal_QuestFailure",
    Description = {
        en = "Reprisal: Lets another active quest fail",
        de = "Vergeltung: Lässt eine andere aktive Quest fehlschlagen",
        fr = "Rétribution: fait échouer une autre quête active",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
    },
}

function B_Reprisal_QuestFailure:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_QuestFailure:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Reprisal_QuestFailure:CustomFunction(_Quest)
    FailQuest(self.QuestName, true);
end

function B_Reprisal_QuestFailure:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid quest!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_QuestFailure);

-- -------------------------------------------------------------------------- --

function Reprisal_QuestSuccess(...)
    return B_Reprisal_QuestSuccess:new(...)
end

B_Reprisal_QuestSuccess = {
    Name = "Reprisal_QuestSuccess",
    Description = {
        en = "Reprisal: Completes another active quest successfully",
        de = "Vergeltung: Beendet eine andere aktive Quest erfolgreich",
        fr = "Rétribution: Réussir une autre quête active",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
    },
}

function B_Reprisal_QuestSuccess:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_QuestSuccess:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Reprisal_QuestSuccess:CustomFunction(_Quest)
    WinQuest(self.QuestName, true);
end

function B_Reprisal_QuestSuccess:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": quest "..  self.QuestName .. " does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_QuestSuccess);

-- -------------------------------------------------------------------------- --

function Reprisal_QuestActivate(...)
    return B_Reprisal_QuestActivate:new(...)
end

B_Reprisal_QuestActivate = {
    Name = "Reprisal_QuestActivate",
    Description = {
        en = "Reprisal: Activates another quest that is not triggered yet.",
        de = "Vergeltung: Aktiviert eine andere Quest die noch nicht ausgelöst wurde.",
        fr = "Rétribution: Active une autre quête qui n'a pas encore été déclenchée.",
    },
    Parameter = {
        {ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête", },
    },
}

function B_Reprisal_QuestActivate:GetReprisalTable()
    return {Reprisal.Custom, {self, self.CustomFunction} }
end

function B_Reprisal_QuestActivate:AddParameter(_Index, _Parameter)
    if (_Index==0) then
        self.QuestName = _Parameter
    else
        assert(false, "Error in " .. self.Name .. ": AddParameter: Index is invalid")
    end
end

function B_Reprisal_QuestActivate:CustomFunction(_Quest)
    StartQuest(self.QuestName, true);
end

function B_Reprisal_QuestActivate:Debug(_Quest)
    if not IsValidQuest(self.QuestName) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Quest: "..  self.QuestName .. " does not exist");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_QuestActivate)

-- -------------------------------------------------------------------------- --

function Reprisal_QuestInterrupt(...)
    return B_Reprisal_QuestInterrupt:new(...)
end

B_Reprisal_QuestInterrupt = {
    Name = "Reprisal_QuestInterrupt",
    Description = {
        en = "Reprisal: Interrupts another active quest without success or failure",
        de = "Vergeltung: Beendet eine andere aktive Quest ohne Erfolg oder Misserfolg",
        fr = "Rétribution : termine une autre quête active sans succès ni échec",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
    },
}

function B_Reprisal_QuestInterrupt:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_QuestInterrupt:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Reprisal_QuestInterrupt:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then

        local QuestID = GetQuestID(self.QuestName)
        local Quest = Quests[QuestID]
        if Quest.State == QuestState.Active then
            StopQuest(self.QuestName, true);
        end
    end
end

function B_Reprisal_QuestInterrupt:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": quest "..  self.QuestName .. " does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_QuestInterrupt);

-- -------------------------------------------------------------------------- --

function Reprisal_QuestForceInterrupt(...)
    return B_Reprisal_QuestForceInterrupt:new(...)
end

B_Reprisal_QuestForceInterrupt = {
    Name = "Reprisal_QuestForceInterrupt",
    Description = {
        en = "Reprisal: Interrupts another quest (even when it isn't active yet) without success or failure",
        de = "Vergeltung: Beendet eine andere Quest, auch wenn diese noch nicht aktiv ist ohne Erfolg oder Misserfolg",
        fr = "Rétribution: Termine une autre quête, même si elle n'est pas encore active, sans succès ni échec.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la Quête" },
        { ParameterType.Custom, en = "Ended quests", de = "Beendete Quests", fr = "Quêtes terminées" },
    },
}

function B_Reprisal_QuestForceInterrupt:GetReprisalTable()

    return { Reprisal.Custom,{self, self.CustomFunction} }

end

function B_Reprisal_QuestForceInterrupt:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.InterruptEnded = ToBoolean(_Parameter)
    end

end

function B_Reprisal_QuestForceInterrupt:GetCustomData( _Index )
    local Data = {}
    if _Index == 1 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reprisal_QuestForceInterrupt:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then

        local QuestID = GetQuestID(self.QuestName)
        local Quest = Quests[QuestID]
        if self.InterruptEnded or Quest.State ~= QuestState.Over then
            Quest:Interrupt();
        end
    end
end

function B_Reprisal_QuestForceInterrupt:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": quest "..  self.QuestName .. " does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_QuestForceInterrupt);

-- -------------------------------------------------------------------------- --

function Reprisal_CustomVariables(...)
    return B_Reprisal_CustomVariables:new(...);
end

B_Reprisal_CustomVariables = {
    Name = "Reprisal_CustomVariables",
    Description = {
        en = "Reprisal: Executes a mathematical operation with this variable. The other operand can be a number or another custom variable.",
        de = "Vergeltung: Führt eine mathematische Operation mit der Variable aus. Der andere Operand kann eine Zahl oder eine Custom-Varible sein.",
        fr = "Rétribution: effectue une opération mathématique sur la variable. L'autre opérateur peut être un nombre ou une variable personnalisée.",
    },
    Parameter = {
        { ParameterType.Default, en = "Name of variable", de = "Variablenname", fr = "Nom de la variable" },
        { ParameterType.Custom,  en = "Operator", de = "Operator", fr = "Operateur" },
        { ParameterType.Default,  en = "Value or variable", de = "Wert oder Variable", fr = "Valeur ou variable" }
    }
};

function B_Reprisal_CustomVariables:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} };
end

function B_Reprisal_CustomVariables:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.VariableName = _Parameter
    elseif _Index == 1 then
        self.Operator = _Parameter
    elseif _Index == 2 then
        local value = tonumber(_Parameter);
        self.Value = (value == nil and tostring(_Parameter)) or value;
    end
end

function B_Reprisal_CustomVariables:CustomFunction()
    local Value1 = ObtainCustomVariable("BehaviorVariable_" ..self.VariableName, 0);
    local Value2 = self.Value;
    if type(self.Value) == "string" then
        Value2 = ObtainCustomVariable("BehaviorVariable_" ..self.Value, 0);
    end

    if self.Operator == "=" then
        Value1 = Value2;
    elseif self.Operator == "+" then
        Value1 = Value1 + Value2;
    elseif self.Operator == "-" then
        Value1 = Value1 - Value2;
    elseif self.Operator == "*" then
        Value1 = Value1 * Value2;
    elseif self.Operator == "/" then
        Value1 = Value1 / Value2;
    elseif self.Operator == "^" then
        Value1 = Value1 % Value2;
    end
    SaveCustomVariable("BehaviorVariable_"..self.VariableName, Value1);
end

function B_Reprisal_CustomVariables:GetCustomData( _Index )
    return {"=", "+", "-", "*", "/", "^"};
end

function B_Reprisal_CustomVariables:Debug(_Quest)
    local operators = {"=", "+", "-", "*", "/", "^"};
    if not table.contains(operators, self.Operator) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid operator!");
        return true;
    elseif self.VariableName == "" then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": missing name for variable!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_CustomVariables)

-- -------------------------------------------------------------------------- --

function Reprisal_MapScriptFunction(...)
    return B_Reprisal_MapScriptFunction:new(...);
end

B_Reprisal_MapScriptFunction = {
    Name = "Reprisal_MapScriptFunction",
    Description = {
        en = "Reprisal: Calls a function within the global map script if the quest has failed.",
        de = "Vergeltung: Ruft eine Funktion im globalen Kartenskript auf, wenn die Quest fehlschlägt.",
        fr = "Rétribution: lance une fonction dans le script global de la carte en cas d'échec de la quête.",
    },
    Parameter = {
        { ParameterType.Default, en = "Function name", de = "Funktionsname", fr = "Nom de la fonction" },
    },
}

function B_Reprisal_MapScriptFunction:GetReprisalTable()
    return {Reprisal.Custom, {self, self.CustomFunction}};
end

function B_Reprisal_MapScriptFunction:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.FuncName = _Parameter;
    end
end

function B_Reprisal_MapScriptFunction:CustomFunction(_Quest)
    if type(self.FuncName) == "function" then
        self.FuncName(unpack(self.i47ya_6aghw_frxil));
        return;
    end
    _G[self.FuncName](self, _Quest);
end

function B_Reprisal_MapScriptFunction:Debug(_Quest)
    if not self.FuncName then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": function reference is invalid!");
        return true;
    end
    if type(self.FuncName) ~= "function" and not _G[self.FuncName] then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": function does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_MapScriptFunction);

-- -------------------------------------------------------------------------- --

function Reprisal_Technology(...)
    return B_Reprisal_Technology:new(...);
end

B_Reprisal_Technology = {
    Name = "Reprisal_Technology",
    Description = {
        en = "Reprisal: Locks or unlocks a technology for the given player",
        de = "Vergeltung: Sperrt oder erlaubt eine Technolgie fuer den angegebenen Player",
        fr = "Rétribution: bloque ou autorise une technologie pour le joueur spécifié",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "PlayerID", de = "SpielerID", fr = "PlayerID" },
        { ParameterType.Custom,   en = "Un / Lock", de = "Sperren/Erlauben", fr = "Bloquer/Autoriser" },
        { ParameterType.Custom,   en = "Technology", de = "Technologie"; fr = "Technologie" },
    },
}

function B_Reprisal_Technology:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} }
end

function B_Reprisal_Technology:AddParameter(_Index, _Parameter)
    if (_Index ==0) then
        self.PlayerID = _Parameter*1
    elseif (_Index == 1) then
        self.LockType = _Parameter == "Lock"
    elseif (_Index == 2) then
        self.Technology = _Parameter
    end
end

function B_Reprisal_Technology:CustomFunction(_Quest)
    if self.PlayerID
    and Logic.GetStoreHouse(self.PlayerID) ~= 0
    and Technologies[self.Technology]
    then
        if self.LockType  then
            LockFeaturesForPlayer(self.PlayerID, Technologies[self.Technology])
        else
            UnLockFeaturesForPlayer(self.PlayerID, Technologies[self.Technology])
        end
    else
        return false
    end
end

function B_Reprisal_Technology:GetCustomData(_Index)
    local Data = {}
    if (_Index == 1) then
        Data[1] = "Lock"
        Data[2] = "UnLock"
    elseif (_Index == 2) then
        for k, v in pairs( Technologies ) do
            table.insert( Data, k )
        end
    end
    return Data
end

function B_Reprisal_Technology:Debug(_Quest)
    if not Technologies[self.Technology] then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid technology type!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": got an invalid playerID!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reprisal_Technology);

-- -------------------------------------------------------------------------- --

function Reward_ObjectDeactivate(...)
    return B_Reward_InteractiveObjectDeactivate:new(...);
end

B_Reward_InteractiveObjectDeactivate = CopyTable(B_Reprisal_InteractiveObjectDeactivate);
B_Reward_InteractiveObjectDeactivate.Name             = "Reward_InteractiveObjectDeactivate";
B_Reward_InteractiveObjectDeactivate.Description.en   = "Reward: Deactivates an interactive object";
B_Reward_InteractiveObjectDeactivate.Description.de   = "Lohn: Deaktiviert ein interaktives Objekt";
B_Reward_InteractiveObjectDeactivate.Description.fr   = "Récompense: Désactive un objet interactif";
B_Reward_InteractiveObjectDeactivate.GetReprisalTable = nil;

B_Reward_InteractiveObjectDeactivate.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_InteractiveObjectDeactivate);

-- -------------------------------------------------------------------------- --

function Reward_ObjectActivate(...)
    return B_Reward_InteractiveObjectActivate:new(...);
end

B_Reward_InteractiveObjectActivate = CopyTable(B_Reprisal_InteractiveObjectActivate);
B_Reward_InteractiveObjectActivate.Name             = "Reward_InteractiveObjectActivate";
B_Reward_InteractiveObjectActivate.Description.en   = "Reward: Activates an interactive object";
B_Reward_InteractiveObjectActivate.Description.de   = "Lohn: Aktiviert ein interaktives Objekt";
B_Reward_InteractiveObjectActivate.Description.fr   = "Récompense: Active un objet interactif";
B_Reward_InteractiveObjectActivate.GetReprisalTable = nil;

B_Reward_InteractiveObjectActivate.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} };
end

RegisterBehavior(B_Reward_InteractiveObjectActivate);

-- -------------------------------------------------------------------------- --

function Reward_ObjectInit(...)
    return B_Reward_ObjectInit:new(...);
end

B_Reward_ObjectInit = {
    Name = "Reward_ObjectInit",
    Description = {
        en = "Reward: Setup an interactive object with costs and rewards.",
        de = "Lohn: Initialisiert ein interaktives Objekt mit seinen Kosten und Schätzen.",
        fr = "Récompense: Initialise un objet interactif avec ses coûts et ses trésors.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Interactive object", de = "Interaktives Objekt",  fr = "Obejct interactif" },
        { ParameterType.Number,     en = "Distance to use",    de = "Nutzungsentfernung",   fr = "Distance d'utilisation" },
        { ParameterType.Number,     en = "Waittime",           de = "Wartezeit",            fr = "Temps d'attente" },
        { ParameterType.Custom,     en = "Reward good",        de = "Belohnungsware",       fr = "Produits de récompense" },
        { ParameterType.Number,     en = "Reward amount",      de = "Anzahl",               fr = "Quantité" },
        { ParameterType.Custom,     en = "Cost good 1",        de = "Kostenware 1",         fr = "Marchandise de coût 1" },
        { ParameterType.Number,     en = "Cost amount 1",      de = "Anzahl 1",             fr = "Quantité 1" },
        { ParameterType.Custom,     en = "Cost good 2",        de = "Kostenware 2",         fr = "Marchandise de coût 2" },
        { ParameterType.Number,     en = "Cost amount 2",      de = "Anzahl 2",             fr = "Quantité 2" },
        { ParameterType.Custom,     en = "Availability",       de = "Verfügbarkeit",        fr = "Disponibilité" },
    },
}

function B_Reward_ObjectInit:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_ObjectInit:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        self.Distance = _Parameter * 1
    elseif (_Index == 2) then
        self.Waittime = _Parameter * 1
    elseif (_Index == 3) then
        self.RewardType = _Parameter
    elseif (_Index == 4) then
        self.RewardAmount = _Parameter * 1
    elseif (_Index == 5) then
        self.FirstCostType = _Parameter
    elseif (_Index == 6) then
        self.FirstCostAmount = _Parameter * 1
    elseif (_Index == 7) then
        self.SecondCostType = _Parameter
    elseif (_Index == 8) then
        self.SecondCostAmount = _Parameter * 1
    elseif (_Index == 9) then
        local parameter = nil
        if _Parameter == "Always" or _Parameter == 1 then
            parameter = 1
        elseif _Parameter == "Never" or _Parameter == 2 then
            parameter = 2
        elseif _Parameter == "Knight only" or _Parameter == 0 then
            parameter = 0
        end
        self.UsingState = parameter
    end
end

function B_Reward_ObjectInit:CustomFunction(_Quest)
    local eID = GetID(self.ScriptName);
    if eID == 0 then
        return;
    end
    CONST_INITIALIZED_OBJECTS[eID] = _Quest.Identifier;

    Logic.InteractiveObjectClearCosts(eID);
    Logic.InteractiveObjectClearRewards(eID);

    Logic.InteractiveObjectSetInteractionDistance(eID, self.Distance);
    Logic.InteractiveObjectSetTimeToOpen(eID, self.Waittime);

    if self.RewardType and self.RewardType ~= "-" then
        Logic.InteractiveObjectAddRewards(eID, Goods[self.RewardType], self.RewardAmount);
    end
    if self.FirstCostType and self.FirstCostType ~= "-" then
        Logic.InteractiveObjectAddCosts(eID, Goods[self.FirstCostType], self.FirstCostAmount);
    end
    if self.SecondCostType and self.SecondCostType ~= "-" then
        Logic.InteractiveObjectAddCosts(eID, Goods[self.SecondCostType], self.SecondCostAmount);
    end

    Logic.InteractiveObjectSetAvailability(eID,true);
    if self.UsingState then
        for i=1, 8 do
            Logic.InteractiveObjectSetPlayerState(eID,i, self.UsingState);
        end
    end

    Logic.InteractiveObjectSetRewardResourceCartType(eID,Entities.U_ResourceMerchant);
    Logic.InteractiveObjectSetRewardGoldCartType(eID,Entities.U_GoldCart);
    Logic.InteractiveObjectSetCostResourceCartType(eID,Entities.U_ResourceMerchant);
    Logic.InteractiveObjectSetCostGoldCartType(eID, Entities.U_GoldCart);
    RemoveInteractiveObjectFromOpenedList(eID);
    table.insert(HiddenTreasures,eID);
end

function B_Reward_ObjectInit:GetCustomData( _Index )
    if _Index == 3 or _Index == 5 or _Index == 7 then
        local Data = {
            "-",
            "G_Beer",
            "G_Bread",
            "G_Broom",
            "G_Carcass",
            "G_Cheese",
            "G_Clothes",
            "G_Dye",
            "G_Gold",
            "G_Grain",
            "G_Herb",
            "G_Honeycomb",
            "G_Iron",
            "G_Leather",
            "G_Medicine",
            "G_Milk",
            "G_RawFish",
            "G_Salt",
            "G_Sausage",
            "G_SmokedFish",
            "G_Soap",
            "G_Stone",
            "G_Water",
            "G_Wood",
            "G_Wool",
        }

        if g_GameExtraNo >= 1 then
            Data[#Data+1] = "G_Gems"
            Data[#Data+1] = "G_MusicalInstrument"
            Data[#Data+1] = "G_Olibanum"
        end
        return Data
    elseif _Index == 9 then
        return {"-", "Knight only", "Always", "Never",}
    end
end

function B_Reward_ObjectInit:Debug(_Quest)
    if Logic.IsInteractiveObject(GetID(self.ScriptName)) == false then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": '"..self.ScriptName.."' is not a interactive object!");
        return true;
    end
    if self.UsingState ~= 1 and self.Distance < 50 then
        warn(false, _Quest.Identifier.. ": " ..self.Name..": distance is maybe too short!");
    end
    if self.Waittime < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": waittime must be equal or greater than 0!");
        return true;
    end
    if self.RewardType and self.RewardType ~= "-" then
        if not Goods[self.RewardType] then
            debug(false, _Quest.Identifier.. ": " ..self.Name..": '"..self.RewardType.."' is invalid good type!");
            return true;
        elseif self.RewardAmount < 1 then
            debug(false, _Quest.Identifier.. ": " ..self.Name..": amount can not be 0 or negative!");
            return true;
        end
    end
    if self.FirstCostType and self.FirstCostType ~= "-" then
        if not Goods[self.FirstCostType] then
            debug(false, _Quest.Identifier.. ": " ..self.Name..": '"..self.FirstCostType.."' is invalid good type!");
            return true;
        elseif self.FirstCostAmount < 1 then
            debug(false, _Quest.Identifier.. ": " ..self.Name..": amount can not be 0 or negative!");
            return true;
        end
    end
    if self.SecondCostType and self.SecondCostType ~= "-" then
        if not Goods[self.SecondCostType] then
            debug(false, _Quest.Identifier.. ": " ..self.Name..": '"..self.SecondCostType.."' is invalid good type!");
            return true;
        elseif self.SecondCostAmount < 1 then
            debug(false, _Quest.Identifier.. ": " ..self.Name..": amount can not be 0 or negative!");
            return true;
        end
    end
    return false;
end

RegisterBehavior(B_Reward_ObjectInit);

-- -------------------------------------------------------------------------- --

function Reward_Diplomacy(...)
    return B_Reward_Diplomacy:new(...);
end

B_Reward_Diplomacy = CopyTable(B_Reprisal_Diplomacy);
B_Reward_Diplomacy.Name             = "Reward_Diplomacy";
B_Reward_Diplomacy.Description.en   = "Reward: Sets Diplomacy state of two Players to a stated value.";
B_Reward_Diplomacy.Description.de   = "Lohn: Setzt den Diplomatiestatus zweier Spieler auf den angegebenen Wert.";
B_Reward_Diplomacy.Description.fr   = "Récompense: Définit le statut diplomatique de deux joueurs sur la valeur indiquée.";
B_Reward_Diplomacy.GetReprisalTable = nil;

B_Reward_Diplomacy.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_Diplomacy);

-- -------------------------------------------------------------------------- --

function Reward_DiplomacyIncrease()
    return B_Reward_SlightlyDiplomacyIncrease:new();
end

B_Reward_SlightlyDiplomacyIncrease = {
    Name = "Reward_SlightlyDiplomacyIncrease",
    Description = {
        en = "Reward: Diplomacy increases slightly to another player",
        de = "Lohn: Verbesserung des Diplomatiestatus zu einem anderen Spieler",
        fr = "Récompense: Amélioration du statut diplomatique avec un autre joueur",
    },
}

function B_Reward_SlightlyDiplomacyIncrease:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_SlightlyDiplomacyIncrease:CustomFunction(_Quest)
    local Sender = _Quest.SendingPlayer;
    local Receiver = _Quest.ReceivingPlayer;
    local State = GetDiplomacyState(Receiver, Sender);
    if State < 2 then
        SetDiplomacyState(Receiver, Sender, State+1);
    end
end

function B_Reward_SlightlyDiplomacyIncrease:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    end
end

RegisterBehavior(B_Reward_SlightlyDiplomacyIncrease);

-- -------------------------------------------------------------------------- --

function Reward_TradePost(...)
    return B_Reward_TradePost:new(...);
end

B_Reward_TradePost= {
    Name = "B_Reward_TradePost",
    Description = {
        en = "Sets options for a Tradepost and deactivates it.",
        de = "Stellt einen Handelsposten ein und deaktiviert ihn.",
        fr = "",
    },
    Parameter = {
        {ParameterType.ScriptName, en = "ScriptName", de = "ScriptName" },
        {ParameterType.PlayerID, en = "PlayerID", de = "PlayerID" },
        {ParameterType.Custom, en = "Type of good to pay 1", de = "Resourcentyp Bezahlung 1", fr = ""},
        {ParameterType.Number, en = "Amount of good", de = "Anzahl der Resource", fr = ""},
        {ParameterType.Custom, en = "Type of good to get 1", de = "Resourcentyp Angebot 1", fr = ""},
        {ParameterType.Number, en = "Amount of good", de = "Anzahl der Resource" },
        {ParameterType.Custom, en = "Type of good to pay 2", de = "Resourcentyp Bezahlung 2", fr = ""},
        {ParameterType.Number, en = "Amount of good", de = "Anzahl der Resource", fr = ""},
        {ParameterType.Custom, en = "Type of good to get 2", de = "Resourcentyp Angebot 2", fr = ""},
        {ParameterType.Number, en = "Amount of good", de = "Anzahl der Resource", fr = ""},
        {ParameterType.Custom, en = "Type of good to pay 3", de = "Resourcentyp Bezahlung 3", fr = ""},
        {ParameterType.Number, en = "Amount of good", de = "Anzahl der Resource", fr = ""},
        {ParameterType.Custom, en = "Type of good to get 3", de = "Resourcentyp Angebot 3", fr = ""},
        {ParameterType.Number, en = "Amount of good", de = "Anzahl der Resource", fr = ""},
        {ParameterType.Custom, en = "Type of good to pay 4", de = "Resourcentyp Bezahlung 4", fr = ""},
        {ParameterType.Number, en = "Amount of good", de = "Anzahl der Resource", fr = ""},
        {ParameterType.Custom, en = "Type of good to get 4", de = "Resourcentyp Angebot 4", fr = ""},
        {ParameterType.Number, en = "Amount of good", de = "Anzahl der Resource", fr = ""},
    },
}

function B_Reward_TradePost:GetRewardTable()
    return {Reward.Custom, {self, self.CustomFunction}};
end
function B_Reward_TradePost:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter;
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1;
    elseif (_Index == 3) then
        self.PayType1 = _Parameter;
    elseif (_Index == 4) then
        self.PayAmount1 = _Parameter * 1;
    elseif (_Index == 5) then
        self.OfferType1 = _Parameter;
    elseif (_Index == 6) then
        self.OfferAmount1 = _Parameter * 1;
    elseif (_Index == 7) then
        self.PayType2 = _Parameter;
    elseif (_Index == 8) then
        self.PayAmount2 = _Parameter * 1;
    elseif (_Index == 9) then
        self.OfferType2 = _Parameter;
    elseif (_Index == 10) then
        self.OfferAmount2 = _Parameter * 1;
    elseif (_Index == 11) then
        self.PayType3 = _Parameter;
    elseif (_Index == 12) then
        self.PayAmount3 = _Parameter * 1;
    elseif (_Index == 13) then
        self.OfferType3 = _Parameter;
    elseif (_Index == 14) then
        self.OfferAmount3 = _Parameter * 1;
    elseif (_Index == 15) then
        self.PayType4 = _Parameter;
    elseif (_Index == 16) then
        self.PayAmount4 = _Parameter * 1;
    elseif (_Index == 17) then
        self.OfferType4 = _Parameter;
    elseif (_Index == 18) then
        self.OfferAmount4 = _Parameter * 1;
    end
end

function B_Reward_TradePost:CustomFunction(_Quest)
    local OfferCount = 0;
    for i = 1, 4 do
        if self["PayAmount"..i] and self["PayAmount"..i] > 0 and self["OfferAmount"..i] and self["OfferAmount"..i] > 0 then
            OfferCount = i;
        else
            break;
        end
    end
    debug(IsExisting(self.ScriptName), _Quest.Identifier .. ": Error in " .. self.Name .. ": CustomFunction: Tradepost is missing");
    local TradepostID = GetID(self.ScriptName);
    if OfferCount > 0 then
        Logic.TradePost_SetTradePartnerGenerateGoodsFlag(TradepostID, true);
        Logic.TradePost_SetTradePartnerPlayerID(TradepostID, self.PlayerID);
        for i = 1, OfferCount do
            for j = 1, OfferCount do
                Logic.TradePost_SetTradeDefinition(
                    TradepostID,
                    (j-1),
                    Goods[self["PayType"..j]],
                    self["PayAmount"..j],
                    Goods[self["OfferType"..j]],
                    self["OfferAmount"..j]
                );
            end
        end
        Logic.TradePost_SetActiveTradeSlot(TradepostID, 0);
        Logic.InteractiveObjectSetAvailability(TradepostID, false);
        for PlayerID = 1, 8 do
            Logic.InteractiveObjectSetPlayerState(TradepostID, PlayerID, 2);
        end
    end
end

function B_Reward_TradePost:DEBUG(_Quest)
    if Logic.GetStoreHouse(self.PlayerID) == 0 then
        debug(false, _Quest.Identifier .. ":  Error in " .. self.Name ..": Player " .. self.PlayerID .. " is dead :-(");
        return true;
    elseif not IsExisting(self.ScriptName) then
        debug(false, _Quest.Identifier .. ":  Error in " .. self.Name ..": No TradePost found");
        return true;
    end
    for i = 1, 4 do
        if  self["PayAmount"..i]
        and self["OfferAmount"..i]
        and self["PayAmount"..i] > 0
        and self["OfferAmount"..i] > 0
        and (not Goods[self["PayType"..i]] or
             not Goods[self["OfferType"..i]])
        then
            debug(false, _Quest.Identifier .. ":  Error in " .. self.Name ..": Offer type or pay type in Slot " .. i .. " is wrong")
            return true
        end
    end
end

function B_Reward_TradePost:GetCustomData(_index)
    if _index >= 2 and _index <= 16 and _index % 2 == 0 then
        return {
            "G_Carcass",
            "G_Grain",
            "G_Herb",
            "G_Honeycomb",
            "G_Iron",
            "G_Milk",
            "G_RawFish",
            "G_Stone",
            "G_Wood",
            "G_Wool",
            "G_Salt",
            "G_Dye",
            "G_Olibanum",
            "G_Gems",
            "G_MusicalInstrument",
        };
    end
end

if g_GameExtraNo and g_GameExtraNo >= 1 then
    RegisterBehavior(B_Reward_TradePost);
end

-- -------------------------------------------------------------------------- --

function Reward_TradeOffers(...)
    return B_Reward_Merchant:new(...);
end

B_Reward_Merchant = {
    Name = "Reward_Merchant",
    Description = {
        en = "Reward: Deletes all existing offers for a merchant and sets new offers, if given",
        de = "Lohn: Löscht alle Angebote eines Händlers und setzt neue, wenn angegeben",
        fr = "Récompense: Supprime toutes les offres d'un commerçant et en place de nouvelles si elles sont indiquées.",
    },
    Parameter = {
        { ParameterType.Custom, en = "PlayerID", de = "PlayerID",  fr = "PlayerID" },
        { ParameterType.Custom, en = "Amount 1", de = "Menge 1",   fr = "Quantité 1" },
        { ParameterType.Custom, en = "Offer 1",  de = "Angebot 1", fr = "Offre 1" },
        { ParameterType.Custom, en = "Amount 2", de = "Menge 2",   fr = "Quantité 2" },
        { ParameterType.Custom, en = "Offer 2",  de = "Angebot 2", fr = "Offre 2" },
        { ParameterType.Custom, en = "Amount 3", de = "Menge 3",   fr = "Quantité 3" },
        { ParameterType.Custom, en = "Offer 3",  de = "Angebot 3", fr = "Offr 3e" },
        { ParameterType.Custom, en = "Amount 4", de = "Menge 4",   fr = "Quantité 4" },
        { ParameterType.Custom, en = "Offer 4",  de = "Angebot 4", fr = "Offre 4" },
    },
}

function B_Reward_Merchant:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_Merchant:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1;
    elseif (_Index == 1) then
        _Parameter = _Parameter or 0;
        self.AmountOffer1 = _Parameter * 1;
    elseif (_Index == 2) then
        self.Offer1 = _Parameter
    elseif (_Index == 3) then
        _Parameter = _Parameter or 0;
        self.AmountOffer2 = _Parameter * 1;
    elseif (_Index == 4) then
        self.Offer2 = _Parameter
    elseif (_Index == 5) then
        _Parameter = _Parameter or 0;
        self.AmountOffer3 = _Parameter * 1;
    elseif (_Index == 6) then
        self.Offer3 = _Parameter
    elseif (_Index == 7) then
        _Parameter = _Parameter or 0;
        self.AmountOffer4 = _Parameter * 1;
    elseif (_Index == 8) then
        self.Offer4 = _Parameter
    end
end

function B_Reward_Merchant:CustomFunction()
    if (self.PlayerID > 1) and (self.PlayerID < 9) then
        local Storehouse = Logic.GetStoreHouse(self.PlayerID)
        Logic.RemoveAllOffers(Storehouse)
        for i =  1,4 do
            if self["Offer"..i] and self["Offer"..i] ~= "-" then
                if Goods[self["Offer"..i]] then
                    AddOffer(Storehouse, self["AmountOffer"..i], Goods[self["Offer"..i]])
                elseif Logic.IsEntityTypeInCategory(Entities[self["Offer"..i]], EntityCategories.Military) == 1 then
                    AddMercenaryOffer(Storehouse, self["AmountOffer"..i], Entities[self["Offer"..i]])
                else
                    AddEntertainerOffer (Storehouse , Entities[self["Offer"..i]])
                end
            end
        end
    end
end

function B_Reward_Merchant:Debug(_Quest)
    if Logic.GetStoreHouse(self.PlayerID ) == 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.PlayerID .. " is dead. :-(")
        return true
    end
end

function B_Reward_Merchant:GetCustomData(_Index)
    local Players = { 1,2,3,4,5,6,7,8 }
    local Amount = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    local Offers = {"-",
                    "G_Beer",
                    "G_Bow",
                    "G_Bread",
                    "G_Broom",
                    "G_Candle",
                    "G_Carcass",
                    "G_Cheese",
                    "G_Clothes",
                    "G_Cow",
                    "G_Grain",
                    "G_Herb",
                    "G_Honeycomb",
                    "G_Iron",
                    "G_Leather",
                    "G_Medicine",
                    "G_Milk",
                    "G_RawFish",
                    "G_Sausage",
                    "G_Sheep",
                    "G_SmokedFish",
                    "G_Soap",
                    "G_Stone",
                    "G_Sword",
                    "G_Wood",
                    "G_Wool",
                    "G_Salt",
                    "G_Dye",
                    "U_AmmunitionCart",
                    "U_BatteringRamCart",
                    "U_CatapultCart",
                    "U_SiegeTowerCart",
                    "U_MilitaryBandit_Melee_ME",
                    "U_MilitaryBandit_Melee_SE",
                    "U_MilitaryBandit_Melee_NA",
                    "U_MilitaryBandit_Melee_NE",
                    "U_MilitaryBandit_Ranged_ME",
                    "U_MilitaryBandit_Ranged_NA",
                    "U_MilitaryBandit_Ranged_NE",
                    "U_MilitaryBandit_Ranged_SE",
                    "U_MilitaryBow_RedPrince",
                    "U_MilitaryBow",
                    "U_MilitarySword_RedPrince",
                    "U_MilitarySword",
                    "U_Entertainer_NA_FireEater",
                    "U_Entertainer_NA_StiltWalker",
                    "U_Entertainer_NE_StrongestMan_Barrel",
                    "U_Entertainer_NE_StrongestMan_Stone",
                    }
    if g_GameExtraNo and g_GameExtraNo >= 1 then
        table.insert(Offers, "G_Gems")
        table.insert(Offers, "G_Olibanum")
        table.insert(Offers, "G_MusicalInstrument")
        table.insert(Offers, "G_MilitaryBandit_Ranged_AS")
        table.insert(Offers, "G_MilitaryBandit_Melee_AS")
        table.insert(Offers, "U_MilitarySword_Khana")
        table.insert(Offers, "U_MilitaryBow_Khana")
    end
    if (_Index == 0) then
        return Players
    elseif (_Index == 1) or (_Index == 3) or (_Index == 5) or (_Index == 7) then
        return Amount
    elseif (_Index == 2) or (_Index == 4) or (_Index == 6) or (_Index == 8) then
        return Offers
    end
end

RegisterBehavior(B_Reward_Merchant)

-- -------------------------------------------------------------------------- --

function Reward_DestroyEntity(...)
    return B_Reward_DestroyEntity:new(...);
end

B_Reward_DestroyEntity = CopyTable(B_Reprisal_DestroyEntity);
B_Reward_DestroyEntity.Name = "Reward_DestroyEntity";
B_Reward_DestroyEntity.Description.en = "Reward: Replaces an entity with an invisible script entity, which retains the entities name.";
B_Reward_DestroyEntity.Description.de = "Lohn: Ersetzt eine Entity mit einer unsichtbaren Script-Entity, die den Namen übernimmt.";
B_Reward_DestroyEntity.Description.fr = "Récompense: Remplace une entité par une entité de script invisible qui prend le nom.";
B_Reward_DestroyEntity.GetReprisalTable = nil;

B_Reward_DestroyEntity.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_DestroyEntity);

-- -------------------------------------------------------------------------- --

function Reward_DestroyEffect(...)
    return B_Reward_DestroyEffect:new(...);
end

B_Reward_DestroyEffect = CopyTable(B_Reprisal_DestroyEffect);
B_Reward_DestroyEffect.Name = "Reward_DestroyEffect";
B_Reward_DestroyEffect.Description.en = "Reward: Destroys an effect.";
B_Reward_DestroyEffect.Description.de = "Lohn: Zerstört einen Effekt.";
B_Reward_DestroyEffect.Description.fr = "Récompense: Détruit un effet.";
B_Reward_DestroyEffect.GetReprisalTable = nil;

B_Reward_DestroyEffect.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, { self, self.CustomFunction } };
end

RegisterBehavior(B_Reward_DestroyEffect);

-- -------------------------------------------------------------------------- --

function Reward_CreateBattalion(...)
    return B_Reward_CreateBattalion:new(...);
end

B_Reward_CreateBattalion = {
    Name = "Reward_CreateBattalion",
    Description = {
        en = "Reward: Replaces a script entity with a battalion, which retains the entities name",
        de = "Lohn: Ersetzt eine Script-Entity durch ein Bataillon, welches den Namen der Script-Entity übernimmt",
        fr = "Récompense: Remplace une entité de script par un bataillon qui prend le nom de l'entité de script.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script entity",               de = "Script Entity",           fr = "Entité de script" },
        { ParameterType.PlayerID,   en = "Player",                      de = "Spieler",                 fr = "Joueur" },
        { ParameterType.Custom,     en = "Type name",                   de = "Typbezeichnung",          fr = "Désignation du type" },
        { ParameterType.Number,     en = "Orientation (in degrees)",    de = "Ausrichtung (in Grad)",   fr = "Orientation (en degrés)" },
        { ParameterType.Number,     en = "Number of soldiers",          de = "Anzahl Soldaten",         fr = "Nombre de Soldats" },
        { ParameterType.Custom,     en = "Hide from AI",                de = "Vor KI verstecken",       fr = "Cacher de l'IA" },
    },
}

function B_Reward_CreateBattalion:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_CreateBattalion:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 2) then
        self.UnitKey = _Parameter
    elseif (_Index == 3) then
        self.Orientation = _Parameter * 1
    elseif (_Index == 4) then
        self.SoldierCount = _Parameter * 1
    elseif (_Index == 5) then
        self.HideFromAI = ToBoolean(_Parameter)
    end
end

function B_Reward_CreateBattalion:CustomFunction(_Quest)
    if not IsExisting( self.ScriptNameEntity ) then
        return false
    end
    local pos = GetPosition(self.ScriptNameEntity)
    local NewID = Logic.CreateBattalionOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID, self.SoldierCount )
    local posID = GetID(self.ScriptNameEntity)
    if Logic.IsBuilding(posID) == 0 then
        DestroyEntity(self.ScriptNameEntity)
        Logic.SetEntityName( NewID, self.ScriptNameEntity )
    end
    if self.HideFromAI then
        AICore.HideEntityFromAI( self.PlayerID, NewID, true )
    end
end

function B_Reward_CreateBattalion:GetCustomData( _Index )
    local Data = {}
    if _Index == 2 then
        for k, v in pairs( Entities ) do
            if Logic.IsEntityTypeInCategory( v, EntityCategories.Soldier ) == 1 then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 5 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_CreateBattalion:Debug(_Quest)
    if not Entities[self.UnitKey] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": got an invalid entity type!");
        return true;
    elseif not IsExisting(self.ScriptNameEntity) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": playerID is wrong!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": orientation must be a number!");
        return true;
    elseif tonumber(self.SoldierCount) == nil or self.SoldierCount < 1 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": you can not create a empty batallion!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reward_CreateBattalion);

-- -------------------------------------------------------------------------- --

function Reward_CreateSeveralBattalions(...)
    return B_Reward_CreateSeveralBattalions:new(...);
end

B_Reward_CreateSeveralBattalions = {
    Name = "Reward_CreateSeveralBattalions",
    Description = {
        en = "Reward: Creates a given amount of battalions",
        de = "Lohn: Erstellt eine gegebene Anzahl Bataillone",
        fr = "Récompense: Crée un nombre donné de bataillons",
    },
    Parameter = {
        { ParameterType.Number,     en = "Amount",                      de = "Anzahl",                  fr = "Quantité" },
        { ParameterType.ScriptName, en = "Script entity",               de = "Script Entity",           fr = "Quentité de Script" },
        { ParameterType.PlayerID,   en = "Player",                      de = "Spieler",                 fr = "Joueur" },
        { ParameterType.Custom,     en = "Type name",                   de = "Typbezeichnung",          fr = "Désignation de type" },
        { ParameterType.Number,     en = "Orientation (in degrees)",    de = "Ausrichtung (in Grad)",   fr = "Orientation (en degrés)" },
        { ParameterType.Number,     en = "Number of soldiers",          de = "Anzahl Soldaten",         fr = "Nombre de soldats" },
        { ParameterType.Custom,     en = "Hide from AI",                de = "Vor KI verstecken",       fr = "Cacher de l'AI" },
    },
}

function B_Reward_CreateSeveralBattalions:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_CreateSeveralBattalions:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Amount = _Parameter * 1
    elseif (_Index == 1) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 2) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 3) then
        self.UnitKey = _Parameter
    elseif (_Index == 4) then
        self.Orientation = _Parameter * 1
    elseif (_Index == 5) then
        self.SoldierCount = _Parameter * 1
    elseif (_Index == 6) then
        self.HideFromAI = ToBoolean(_Parameter)
    end
end

function B_Reward_CreateSeveralBattalions:CustomFunction(_Quest)
    if not IsExisting( self.ScriptNameEntity ) then
        return false
    end
    local tID = GetID(self.ScriptNameEntity)
    local x,y,z = Logic.EntityGetPos(tID);
    if Logic.IsBuilding(tID) == 1 then
        x,y = Logic.GetBuildingApproachPosition(tID)
    end

    for i=1, self.Amount do
        local NewID = Logic.CreateBattalionOnUnblockedLand( Entities[self.UnitKey], x, y, self.Orientation, self.PlayerID, self.SoldierCount )
        Logic.SetEntityName( NewID, self.ScriptNameEntity .. "_" .. i )
        if self.HideFromAI then
            AICore.HideEntityFromAI( self.PlayerID, NewID, true )
        end
    end
end

function B_Reward_CreateSeveralBattalions:GetCustomData( _Index )
    local Data = {}
    if _Index == 3 then
        for k, v in pairs( Entities ) do
            if Logic.IsEntityTypeInCategory( v, EntityCategories.Soldier ) == 1 then
                table.insert( Data, k )
            end
        end
        table.sort( Data )
    elseif _Index == 6 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_CreateSeveralBattalions:Debug(_Quest)
    if not Entities[self.UnitKey] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": got an invalid entity type!");
        return true;
    elseif not IsExisting(self.ScriptNameEntity) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": playerDI is wrong!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": orientation must be a number!");
        return true;
    elseif tonumber(self.SoldierCount) == nil or self.SoldierCount < 1 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": you can not create a empty batallion!");
        return true;
    elseif tonumber(self.Amount) == nil or self.Amount < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": amount can not be negative!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reward_CreateSeveralBattalions);

-- -------------------------------------------------------------------------- --

function Reward_CreateEffect(...)
    return B_Reward_CreateEffect:new(...);
end

B_Reward_CreateEffect = {
    Name = "Reward_CreateEffect",
    Description = {
        en = "Reward: Creates an effect at a specified position",
        de = "Lohn: Erstellt einen Effekt an der angegebenen Position",
        fr = "Récompense: Crée un effet à la position indiquée",
    },
    Parameter = {
        { ParameterType.Default,    en = "Effect name", de = "Effektname",      fr = "Nom de l'effet" },
        { ParameterType.Custom,     en = "Type name",   de = "Typbezeichnung",  fr = "Designation de type" },
        { ParameterType.PlayerID,   en = "Player",      de = "Spieler",         fr = "Joueur" },
        { ParameterType.ScriptName, en = "Location",    de = "Ort",             fr = "Lieu" },
        { ParameterType.Number,     en = "Orientation (in degrees)(-1: from locating entity)", de = "Ausrichtung (in Grad)(-1: von Positionseinheit)", fr = "Orientation (en degrés)(-1 : de l'unité de position)" },
    }
}

function B_Reward_CreateEffect:AddParameter(_Index, _Parameter)

    if _Index == 0 then
        self.EffectName = _Parameter;
    elseif _Index == 1 then
        self.Type = EGL_Effects[_Parameter];
    elseif _Index == 2 then
        self.PlayerID = _Parameter * 1;
    elseif _Index == 3 then
        self.Location = _Parameter;
    elseif _Index == 4 then
        self.Orientation = _Parameter * 1;
    end

end

function B_Reward_CreateEffect:GetRewardTable()
    return { Reward.Custom, { self, self.CustomFunction } };
end

function B_Reward_CreateEffect:CustomFunction(_Quest)
    if Logic.IsEntityDestroyed(self.Location) then
        return;
    end
    local entity = assert(GetID(self.Location), _Quest.Identifier .. "Error in " .. self.Name .. ": CustomFunction: Entity is invalid");
    if CONST_EFFECT_NAME_TO_ID[self.EffectName] and Logic.IsEffectRegistered(CONST_EFFECT_NAME_TO_ID[self.EffectName]) then
        return;
    end

    local posX, posY = Logic.GetEntityPosition(entity);
    local orientation = tonumber(self.Orientation);
    local effect = Logic.CreateEffectWithOrientation(self.Type, posX, posY, orientation, self.PlayerID);
    if self.EffectName ~= "" then
        CONST_EFFECT_NAME_TO_ID[self.EffectName] = effect;
    end
end

function B_Reward_CreateEffect:Debug(_Quest)
    if CONST_EFFECT_NAME_TO_ID[self.EffectName] and Logic.IsEffectRegistered(CONST_EFFECT_NAME_TO_ID[self.EffectName]) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": effect already exists!");
        return true;
    elseif not IsExisting(self.Location) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": location '" ..self.Location.. "' is missing!");
        return true;
    elseif self.PlayerID and (self.PlayerID < 0 or self.PlayerID > 8) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": invalid playerID!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": invalid orientation!");
        return true;
    end
end

function B_Reward_CreateEffect:GetCustomData(_Index)
    assert(_Index == 1, "Error in " .. self.Name .. ": GetCustomData: Index is invalid.");
    local types = {};
    for k, v in pairs(EGL_Effects) do
        table.insert(types, k);
    end
    table.sort(types);
    return types;
end

RegisterBehavior(B_Reward_CreateEffect);

-- -------------------------------------------------------------------------- --

function Reward_CreateEntity(...)
    return B_Reward_CreateEntity:new(...);
end

B_Reward_CreateEntity = {
    Name = "Reward_CreateEntity",
    Description = {
        en = "Reward: Replaces an entity by a new one of a given type",
        de = "Lohn: Ersetzt eine Entity durch eine neue gegebenen Typs",
        fr = "Récompense: Remplace une entité par une nouvelle entité de type donné",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script entity",               de = "Script Entity",           fr = "Entité de script" },
        { ParameterType.PlayerID,   en = "Player",                      de = "Spieler",                 fr = "Joueur" },
        { ParameterType.Custom,     en = "Type name",                   de = "Typbezeichnung",          fr = "Désignation de type" },
        { ParameterType.Number,     en = "Orientation (in degrees)",    de = "Ausrichtung (in Grad)",   fr = "Orientation (en degrés)" },
        { ParameterType.Custom,     en = "Hide from AI",                de = "Vor KI verstecken",       fr = "Cacher de l'AI" },
    },
}

function B_Reward_CreateEntity:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_CreateEntity:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 2) then
        self.UnitKey = _Parameter
    elseif (_Index == 3) then
        self.Orientation = _Parameter * 1
    elseif (_Index == 4) then
        self.HideFromAI = ToBoolean(_Parameter)
    end
end

function B_Reward_CreateEntity:CustomFunction(_Quest)
    if not IsExisting( self.ScriptNameEntity ) then
        return false
    end
    local pos = GetPosition(self.ScriptNameEntity)
    local NewID;
    if Logic.IsEntityTypeInCategory( self.UnitKey, EntityCategories.Soldier ) == 1 then
        NewID     = Logic.CreateBattalionOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID, 1 )
        local l,s = Logic.GetSoldiersAttachedToLeader(NewID)
        Logic.SetOrientation(s, math.floor(self.Orientation + 0.5))
    else
        NewID = Logic.CreateEntityOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID )
    end
    local posID = GetID(self.ScriptNameEntity)
    if Logic.IsBuilding(posID) == 0 then
        DestroyEntity(self.ScriptNameEntity)
        Logic.SetEntityName( NewID, self.ScriptNameEntity )
    end
    if self.HideFromAI then
        AICore.HideEntityFromAI( self.PlayerID, NewID, true )
    end
end

function B_Reward_CreateEntity:GetCustomData( _Index )
    local Data = {}
    if _Index == 2 then
        for k, v in pairs( Entities ) do
            local name = {"^M_*","^XS_*","^X_*","^XT_*","^Z_*"}
            local found = false;
            for i=1,#name do
                if k:find(name[i]) then
                    found = true;
                    break;
                end
            end
            if not found then
                table.insert( Data, k );
            end
        end
        table.sort( Data )

    elseif _Index == 4 or _Index == 5 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_CreateEntity:Debug(_Quest)
    if not Entities[self.UnitKey] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": got an invalid entity type!");
        return true;
    elseif not IsExisting(self.ScriptNameEntity) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 0 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": playerID is not valid!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": orientation must be a number!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reward_CreateEntity);

-- -------------------------------------------------------------------------- --

-- Kompatibelität
B_Reward_CreateSettler = CopyTable(B_Reward_CreateEntity);
B_Reward_CreateSettler.Name = "Reward_CreateSettler";
B_Reward_CreateSettler.Description.en = "Reward: Replaces an entity by a new one of a given type";
B_Reward_CreateSettler.Description.de = "Lohn: Ersetzt eine Entity durch eine neue gegebenen Typs";
B_Reward_CreateSettler.Description.fr = "Récompense: Remplace une entité par une nouvelle entité de type donné";
RegisterBehavior(B_Reward_CreateSettler);

-- -------------------------------------------------------------------------- --

function Reward_CreateSeveralEntities(...)
    return B_Reward_CreateSeveralEntities:new(...);
end

B_Reward_CreateSeveralEntities = {
    Name = "Reward_CreateSeveralEntities",
    Description = {
        en = "Reward: Creating serveral battalions at the position of a entity. They retains the entities name and a _[index] suffix",
        de = "Lohn: Erzeugt mehrere Entities an der Position der Entity. Sie übernimmt den Namen der Script Entity und den Suffix _[index]",
        fr = "Récompense: Crée plusieurs Entities à la position de l'Entity. Elle reprend le nom de l'entité script et le suffixe _[index].",
    },
    Parameter = {
        { ParameterType.Number,     en = "Amount",                      de = "Anzahl",                  fr = "Quantité" },
        { ParameterType.ScriptName, en = "Script entity",               de = "Script Entity",           fr = "Entité de script" },
        { ParameterType.PlayerID,   en = "Player",                      de = "Spieler",                 fr = "Joueur" },
        { ParameterType.Custom,     en = "Type name",                   de = "Typbezeichnung",          fr = "Designation de type" },
        { ParameterType.Number,     en = "Orientation (in degrees)",    de = "Ausrichtung (in Grad)",   fr = "Orientation (en degrés)" },
        { ParameterType.Custom,     en = "Hide from AI",                de = "Vor KI verstecken",       fr = "Cacher de l'AI" },
    },
}

function B_Reward_CreateSeveralEntities:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_CreateSeveralEntities:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Amount = _Parameter * 1
    elseif (_Index == 1) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 2) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 3) then
        self.UnitKey = _Parameter
    elseif (_Index == 4) then
        self.Orientation = _Parameter * 1
    elseif (_Index == 5) then
        self.HideFromAI = ToBoolean(_Parameter)
    end
end

function B_Reward_CreateSeveralEntities:CustomFunction(_Quest)
    if not IsExisting( self.ScriptNameEntity ) then
        return false
    end
    local pos = GetPosition(self.ScriptNameEntity)
    local NewID;
    for i=1, self.Amount do
        if Logic.IsEntityTypeInCategory( self.UnitKey, EntityCategories.Soldier ) == 1 then
            NewID     = Logic.CreateBattalionOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID, 1 )
            local l,s = Logic.GetSoldiersAttachedToLeader(NewID)
            Logic.SetOrientation(s, math.floor(self.Orientation + 0.5))
        else
            NewID = Logic.CreateEntityOnUnblockedLand( Entities[self.UnitKey], pos.X, pos.Y, self.Orientation, self.PlayerID )
        end
        Logic.SetEntityName( NewID, self.ScriptNameEntity .. "_" .. i )
        if self.HideFromAI then
            AICore.HideEntityFromAI( self.PlayerID, NewID, true )
        end
    end
end

function B_Reward_CreateSeveralEntities:GetCustomData( _Index )
    local Data = {}
    if _Index == 3 then
        for k, v in pairs( Entities ) do
            local name = {"^M_*","^XS_*","^X_*","^XT_*","^Z_*"}
            local found = false;
            for i=1,#name do
                if k:find(name[i]) then
                    found = true;
                    break;
                end
            end
            if not found then
                table.insert( Data, k );
            end
        end
        table.sort( Data )

    elseif _Index == 5 or _Index == 6 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data

end

function B_Reward_CreateSeveralEntities:Debug(_Quest)
    if not Entities[self.UnitKey] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": got an invalid entity type!");
        return true;
    elseif not IsExisting(self.ScriptNameEntity) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.PlayerID) == nil or self.PlayerID < 1 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif tonumber(self.Orientation) == nil then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": orientation must be a number!");
        return true;
    elseif tonumber(self.Amount) == nil or self.Amount < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": amount can not be negative!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reward_CreateSeveralEntities);

-- -------------------------------------------------------------------------- --

function Reward_MoveSettler(...)
    return B_Reward_MoveSettler:new(...);
end

B_Reward_MoveSettler = {
    Name = "Reward_MoveSettler",
    Description = {
        en = "Reward: Moves a (NPC) settler to a destination. Must not be AI controlled, or it won't move",
        de = "Lohn: Bewegt einen (NPC) Siedler zu einem Zielort. Darf keinem KI Spieler gehören, ansonsten wird sich der Siedler nicht bewegen",
        fr = "Récompense: Déplace un settler (NPC) vers une destination. Ne doit pas appartenir à un joueur IA, sinon le settler ne se déplacera pas.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Settler", de = "Siedler", fr = "Settler" },
        { ParameterType.ScriptName, en = "Destination", de = "Ziel", fr = "Destination" },
    },
}

function B_Reward_MoveSettler:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_MoveSettler:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptNameUnit = _Parameter
    elseif (_Index == 1) then
        self.ScriptNameDest = _Parameter
    end
end

function B_Reward_MoveSettler:CustomFunction(_Quest)
    if Logic.IsEntityDestroyed( self.ScriptNameUnit ) or Logic.IsEntityDestroyed( self.ScriptNameDest ) then
        return false
    end
    local DestID = GetID( self.ScriptNameDest )
    local DestX, DestY = Logic.GetEntityPosition( DestID )
    if Logic.IsBuilding( DestID ) == 1 then
        DestX, DestY = Logic.GetBuildingApproachPosition( DestID )
    end
    Logic.MoveSettler( GetID( self.ScriptNameUnit ), DestX, DestY )
end

function B_Reward_MoveSettler:Debug(_Quest)
    if not IsExisting(self.ScriptNameUnit) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": mover entity does not exist!");
        return true;
    elseif not IsExisting(self.ScriptNameDest) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": destination does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reward_MoveSettler);

-- -------------------------------------------------------------------------- --

function Reward_Victory()
    return B_Reward_Victory:new()
end

B_Reward_Victory = {
    Name = "Reward_Victory",
    Description = {
        en = "Reward: The player wins the game.",
        de = "Lohn: Der Spieler gewinnt das Spiel.",
        fr = "Récompense: Le Joueur gagne la partie.",
    },
}

function B_Reward_Victory:GetRewardTable()
    return {Reward.Victory};
end

RegisterBehavior(B_Reward_Victory);

-- -------------------------------------------------------------------------- --

function Reward_Defeat()
    return B_Reward_Defeat:new()
end

B_Reward_Defeat = {
    Name = "Reward_Defeat",
    Description = {
        en = "Reward: The player loses the game.",
        de = "Lohn: Der Spieler verliert das Spiel.",
        fr = "Récompense: le Joueur perd la partie.",
    },
}

function B_Reward_Defeat:GetRewardTable()
    return { Reward.Custom, {self, self.CustomFunction} }
end

function B_Reward_Defeat:CustomFunction(_Quest)
    _Quest:TerminateEventsAndStuff()
    Logic.ExecuteInLuaLocalState("GUI_Window.MissionEndScreenSetVictoryReasonText(".. g_VictoryAndDefeatType.DefeatMissionFailed ..")")
    Defeated(_Quest.ReceivingPlayer)
end

RegisterBehavior(B_Reward_Defeat);

-- -------------------------------------------------------------------------- --

function Reward_FakeVictory()
    return B_Reward_FakeVictory:new();
end

B_Reward_FakeVictory = {
    Name = "Reward_FakeVictory",
    Description = {
        en = "Reward: Display a victory icon for a quest",
        de = "Lohn: Zeigt ein Siegesicon fuer diese Quest",
        fr = "Récompense: Affiche une icône de victoire pour cette quête",
    },
}

function B_Reward_FakeVictory:GetRewardTable()
    return { Reward.FakeVictory }
end

RegisterBehavior(B_Reward_FakeVictory);

-- -------------------------------------------------------------------------- --

function Reward_AI_SpawnAndAttackTerritory(...)
    return B_Reward_AI_SpawnAndAttackTerritory:new(...);
end

B_Reward_AI_SpawnAndAttackTerritory = {
    Name = "Reward_AI_SpawnAndAttackTerritory",
    Description = {
        en = "Reward: Spawns AI troops and attacks a territory (Hint: Use for hidden quests as a surprise)",
        de = "Lohn: Erstellt KI Truppen und greift ein Territorium an (Tipp: Fuer eine versteckte Quest als Ueberraschung verwenden)",
        fr = "Récompense: Créez des troupes d'IA et attaquez un territoire (astuce : utilisez une surprise pour une quête cachée).",
    },
    Parameter = {
        { ParameterType.PlayerID,       en = "AI Player",       de = "KI Spieler",                  fr = "Joueur AI" },
        { ParameterType.ScriptName,     en = "Spawn point",     de = "Erstellungsort",              fr = "Lieu de création" },
        { ParameterType.TerritoryName,  en = "Territory",       de = "Territorium",                 fr = "Territoire" },
        { ParameterType.Number,         en = "Sword",           de = "Schwert",                     fr = "Épéiste" },
        { ParameterType.Number,         en = "Bow",             de = "Bogen",                       fr = "Archer" },
        { ParameterType.Number,         en = "Catapults",       de = "Katapulte",                   fr = "Catapultes" },
        { ParameterType.Number,         en = "Siege towers",    de = "Belagerungstuerme",           fr = "Tours de siège" },
        { ParameterType.Number,         en = "Rams",            de = "Rammen",                      fr = "Bélier" },
        { ParameterType.Number,         en = "Ammo carts",      de = "Munitionswagen",              fr = "Chariot à munitions" },
        { ParameterType.Custom,         en = "Soldier type",    de = "Soldatentyp",                 fr = "Type de soldat" },
        { ParameterType.Custom,         en = "Reuse troops",    de = "Verwende bestehende Truppen", fr = "Utiliser les troupes existantes" },
    },
}

function B_Reward_AI_SpawnAndAttackTerritory:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_SpawnAndAttackTerritory:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.AIPlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Spawnpoint = _Parameter
    elseif (_Index == 2) then
        self.TerritoryID = tonumber(_Parameter)
        if not self.TerritoryID then
            self.TerritoryID = GetTerritoryIDByName(_Parameter)
        end
    elseif (_Index == 3) then
        self.NumSword = _Parameter * 1
    elseif (_Index == 4) then
        self.NumBow = _Parameter * 1
    elseif (_Index == 5) then
        self.NumCatapults = _Parameter * 1
    elseif (_Index == 6) then
        self.NumSiegeTowers = _Parameter * 1
    elseif (_Index == 7) then
        self.NumRams = _Parameter * 1
    elseif (_Index == 8) then
        self.NumAmmoCarts = _Parameter * 1
    elseif (_Index == 9) then
        if _Parameter == "Normal" or _Parameter == false then
            self.TroopType = false
        elseif _Parameter == "RedPrince" or _Parameter == true then
            self.TroopType = true
        elseif _Parameter == "Bandit" or _Parameter == 2 then
            self.TroopType = 2
        elseif _Parameter == "Cultist" or _Parameter == 3 then
            self.TroopType = 3
        else
            assert(false)
        end
    elseif (_Index == 10) then
        self.ReuseTroops = ToBoolean(_Parameter)
    end
end

function B_Reward_AI_SpawnAndAttackTerritory:GetCustomData( _Index )
    local Data = {}
    if _Index == 9 then
        table.insert( Data, "Normal" )
        table.insert( Data, "RedPrince" )
        table.insert( Data, "Bandit" )
        if g_GameExtraNo >= 1 then
            table.insert( Data, "Cultist" )
        end
    elseif _Index == 10 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_AI_SpawnAndAttackTerritory:CustomFunction(_Quest)
    local TargetID = Logic.GetTerritoryAcquiringBuildingID( self.TerritoryID )
    if TargetID ~= 0 then
        AIScript_SpawnAndAttackCity(
            self.AIPlayerID,
            TargetID,
            self.Spawnpoint,
            self.NumSword,
            self.NumBow,
            self.NumCatapults,
            self.NumSiegeTowers,
            self.NumRams,
            self.NumAmmoCarts,
            self.TroopType,
            self.ReuseTroops
        )
    end
end

function B_Reward_AI_SpawnAndAttackTerritory:Debug(_Quest)
    if self.AIPlayerID < 2 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayerID .. " is wrong")
        return true
    elseif Logic.IsEntityDestroyed(self.Spawnpoint) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.SpawnPoint .. " is missing")
        return true
    elseif self.TerritoryID == 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Territory unknown")
        return true
    elseif self.NumSword < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Number of Swords is negative")
        return true
    elseif self.NumBow < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Number of Bows is negative")
        return true
    elseif self.NumBow + self.NumSword < 1 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": No Soldiers?")
        return true
    elseif self.NumCatapults < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Catapults is negative")
        return true
    elseif self.NumSiegeTowers < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": SiegeTowers is negative")
        return true
    elseif self.NumRams < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Rams is negative")
        return true
    elseif self.NumAmmoCarts < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": AmmoCarts is negative")
        return true
    end
    return false;
end

RegisterBehavior(B_Reward_AI_SpawnAndAttackTerritory);

-- -------------------------------------------------------------------------- --

function Reward_AI_SpawnAndAttackArea(...)
    return B_Reward_AI_SpawnAndAttackArea:new(...);
end

B_Reward_AI_SpawnAndAttackArea = {
    Name = "Reward_AI_SpawnAndAttackArea",
    Description = {
        en = "Reward: Spawns AI troops and attacks everything within the specified area, except the players main buildings",
        de = "Lohn: Erstellt KI Truppen und greift ein angegebenes Gebiet an, aber nicht die Hauptgebauede eines Spielers",
        fr = "Récompense: Crée des troupes IA et attaque une zone spécifiée, mais pas les bâtiments principaux d'un joueur.",
    },
    Parameter = {
        { ParameterType.PlayerID,   en = "AI Player",       de = "KI Spieler",                  fr = "Joueur AI" },
        { ParameterType.ScriptName, en = "Spawn point",     de = "Erstellungsort",              fr = "Lieu de création" },
        { ParameterType.ScriptName, en = "Target",          de = "Ziel",                        fr = "Cible" },
        { ParameterType.Number,     en = "Radius",          de = "Radius",                      fr = "Rayon" },
        { ParameterType.Number,     en = "Sword",           de = "Schwert",                     fr = "Épéiste" },
        { ParameterType.Number,     en = "Bow",             de = "Bogen",                       fr = "Archer" },
        { ParameterType.Custom,     en = "Soldier type",    de = "Soldatentyp",                 fr = "Type de soldats" },
        { ParameterType.Custom,     en = "Reuse troops",    de = "Verwende bestehende Truppen", fr = "Utiliser des troupes existantes" },
    },
}

function B_Reward_AI_SpawnAndAttackArea:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_SpawnAndAttackArea:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.AIPlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Spawnpoint = _Parameter
    elseif (_Index == 2) then
        self.TargetName = _Parameter
    elseif (_Index == 3) then
        self.Radius = _Parameter * 1
    elseif (_Index == 4) then
        self.NumSword = _Parameter * 1
    elseif (_Index == 5) then
        self.NumBow = _Parameter * 1
    elseif (_Index == 6) then
        if _Parameter == "Normal" or _Parameter == false then
            self.TroopType = false
        elseif _Parameter == "RedPrince" or _Parameter == true then
            self.TroopType = true
        elseif _Parameter == "Bandit" or _Parameter == 2 then
            self.TroopType = 2
        elseif _Parameter == "Cultist" or _Parameter == 3 then
            self.TroopType = 3
        else
            assert(false)
        end
    elseif (_Index == 7) then
        self.ReuseTroops = ToBoolean(_Parameter)
    end
end

function B_Reward_AI_SpawnAndAttackArea:GetCustomData( _Index )
    local Data = {}
    if _Index == 6 then
        table.insert( Data, "Normal" )
        table.insert( Data, "RedPrince" )
        table.insert( Data, "Bandit" )
        if g_GameExtraNo >= 1 then
            table.insert( Data, "Cultist" )
        end
    elseif _Index == 7 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    else
        assert( false )
    end
    return Data
end

function B_Reward_AI_SpawnAndAttackArea:CustomFunction(_Quest)
    if Logic.IsEntityAlive( self.TargetName ) and Logic.IsEntityAlive( self.Spawnpoint ) then
        local TargetID = GetID( self.TargetName )
        AIScript_SpawnAndRaidSettlement(
            self.AIPlayerID,
            TargetID,
            self.Spawnpoint,
            self.Radius,
            self.NumSword,
            self.NumBow,
            self.TroopType,
            self.ReuseTroops
        )
    end
end

function B_Reward_AI_SpawnAndAttackArea:Debug(_Quest)
    if self.AIPlayerID < 2 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayerID .. " is wrong")
        return true
    elseif Logic.IsEntityDestroyed(self.Spawnpoint) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.SpawnPoint .. " is missing")
        return true
    elseif Logic.IsEntityDestroyed(self.TargetName) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.TargetName .. " is missing")
        return true
    elseif self.Radius < 1 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Radius is to small or negative")
        return true
    elseif self.NumSword < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Number of Swords is negative")
        return true
    elseif self.NumBow < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Number of Bows is negative")
        return true
    elseif self.NumBow + self.NumSword < 1 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": No Soldiers?")
        return true
    end
    return false;
end

RegisterBehavior(B_Reward_AI_SpawnAndAttackArea);

-- -------------------------------------------------------------------------- --

function Reward_AI_SpawnAndProtectArea(...)
    return B_Reward_AI_SpawnAndProtectArea:new(...);
end

B_Reward_AI_SpawnAndProtectArea = {
    Name = "Reward_AI_SpawnAndProtectArea",
    Description = {
        en = "Reward: Spawns AI troops and defends a specified area",
        de = "Lohn: Erstellt KI Truppen und verteidigt ein angegebenes Gebiet",
        fr = "Récompense: Crée des troupes d'IA et défend un territoire donné",
    },
    Parameter = {
        { ParameterType.PlayerID,   en = "AI Player",               de = "KI Spieler",                  fr = "Joueur AI" },
        { ParameterType.ScriptName, en = "Spawn point",             de = "Erstellungsort",              fr = "Lieu de création" },
        { ParameterType.ScriptName, en = "Target",                  de = "Ziel",                        fr = "Cible" },
        { ParameterType.Number,     en = "Radius",                  de = "Radius",                      fr = "Rayon" },
        { ParameterType.Number,     en = "Time (-1 for infinite)",  de = "Zeit (-1 fuer unendlich)",    fr = "Temps (-1 pour infini)" },
        { ParameterType.Number,     en = "Sword",                   de = "Schwert",                     fr = "Épéiste" },
        { ParameterType.Number,     en = "Bow",                     de = "Bogen",                       fr = "Archer" },
        { ParameterType.Custom,     en = "Capture tradecarts",      de = "Handelskarren angreifen",     fr = "Attaquer les chariots de commerce" },
        { ParameterType.Custom,     en = "Soldier type",            de = "Soldatentyp",                 fr = "Type de soldat" },
        { ParameterType.Custom,     en = "Reuse troops",            de = "Verwende bestehende Truppen", fr = "Utiliser les troupes existantes" },
    },
}

function B_Reward_AI_SpawnAndProtectArea:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_SpawnAndProtectArea:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.AIPlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Spawnpoint = _Parameter
    elseif (_Index == 2) then
        self.TargetName = _Parameter
    elseif (_Index == 3) then
        self.Radius = _Parameter * 1
    elseif (_Index == 4) then
        self.Time = _Parameter * 1
    elseif (_Index == 5) then
        self.NumSword = _Parameter * 1
    elseif (_Index == 6) then
        self.NumBow = _Parameter * 1
    elseif (_Index == 7) then
        self.CaptureTradeCarts = ToBoolean(_Parameter)
    elseif (_Index == 8) then
        if _Parameter == "Normal" or _Parameter == true then
            self.TroopType = false
        elseif _Parameter == "RedPrince" or _Parameter == false then
            self.TroopType = true
        elseif _Parameter == "Bandit" or _Parameter == 2 then
            self.TroopType = 2
        elseif _Parameter == "Cultist" or _Parameter == 3 then
            self.TroopType = 3
        else
            assert(false)
        end
    elseif (_Index == 9) then
        self.ReuseTroops = ToBoolean(_Parameter)
    end

end

function B_Reward_AI_SpawnAndProtectArea:GetCustomData( _Index )

    local Data = {}
    if _Index == 7 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )
    elseif _Index == 8 then
        table.insert( Data, "Normal" )
        table.insert( Data, "RedPrince" )
        table.insert( Data, "Bandit" )
        if g_GameExtraNo >= 1 then
            table.insert( Data, "Cultist" )
        end

    elseif _Index == 9 then
        table.insert( Data, "false" )
        table.insert( Data, "true" )

    else
        assert( false )
    end

    return Data

end

function B_Reward_AI_SpawnAndProtectArea:CustomFunction(_Quest)
    if Logic.IsEntityAlive( self.TargetName ) and Logic.IsEntityAlive( self.Spawnpoint ) then
        local TargetID = GetID( self.TargetName )
        AIScript_SpawnAndProtectArea(
            self.AIPlayerID,
            TargetID,
            self.Spawnpoint,
            self.Radius,
            self.NumSword,
            self.NumBow,
            self.Time,
            self.TroopType,
            self.ReuseTroops,
            self.CaptureTradeCarts
        )
    end
end

function B_Reward_AI_SpawnAndProtectArea:Debug(_Quest)
    if self.AIPlayerID < 2 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayerID .. " is wrong")
        return true
    elseif Logic.IsEntityDestroyed(self.Spawnpoint) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.SpawnPoint .. " is missing")
        return true
    elseif Logic.IsEntityDestroyed(self.TargetName) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Entity " .. self.TargetName .. " is missing")
        return true
    elseif self.Radius < 1 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Radius is to small or negative")
        return true
    elseif self.Time < -1 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Time is smaller than -1")
        return true
    elseif self.NumSword < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Number of Swords is negative")
        return true
    elseif self.NumBow < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Number of Bows is negative")
        return true
    elseif self.NumBow + self.NumSword < 1 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": No Soldiers?")
        return true
    end
    return false;
end

RegisterBehavior(B_Reward_AI_SpawnAndProtectArea);

-- -------------------------------------------------------------------------- --

function Reward_AI_SetNumericalFact(...)
    return B_Reward_AI_SetNumericalFact:new(...);
end

B_Reward_AI_SetNumericalFact = {
    Name = "Reward_AI_SetNumericalFact",
    Description = {
        en = "Reward: Sets a numerical fact for the AI player",
        de = "Lohn: Setzt eine Verhaltensregel fuer den KI-Spieler. ",
        fr = "Récompense: Définit une règle de comportement pour le joueur IA.",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "AI Player",      de = "KI Spieler",         fr = "Joueur AI" },
        { ParameterType.Custom,   en = "Numerical Fact", de = "Verhaltensregel",    fr = "Règle de conduite" },
        { ParameterType.Number,   en = "Value",          de = "Wert",               fr = "Valeur" },
    },
}

function B_Reward_AI_SetNumericalFact:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_SetNumericalFact:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.AIPlayerID = _Parameter * 1
    elseif (_Index == 1) then
        -- mapping of numerical facts
        local fact = {
            ["Courage"]               = "FEAR",
            ["Reconstruction"]        = "BARB",
            ["Build Order"]           = "BPMX",
            ["Conquer Outposts"]      = "FCOP",
            ["Mount Outposts"]        = "FMOP",
            ["max. Bowmen"]           = "FMBM",
            ["max. Swordmen"]         = "FMSM",
            ["max. Rams"]             = "FMRA",
            ["max. Catapults"]        = "FMCA",
            ["max. Ammunition Carts"] = "FMAC",
            ["max. Siege Towers"]     = "FMST",
            ["max. Wall Catapults"]   = "FMBA",
            ["FEAR"]                  = "FEAR", -- > 0
            ["BARB"]                  = "BARB", -- 1 or 0
            ["BPMX"]                  = "BPMX", -- >= 0
            ["FCOP"]                  = "FCOP", -- 1 or 0
            ["FMOP"]                  = "FMOP", -- 1 or 0
            ["FMBM"]                  = "FMBM", -- >= 0
            ["FMSM"]                  = "FMSM", -- >= 0
            ["FMRA"]                  = "FMRA", -- >= 0
            ["FMCA"]                  = "FMCA", -- >= 0
            ["FMAC"]                  = "FMAC", -- >= 0
            ["FMST"]                  = "FMST", -- >= 0
            ["FMBA"]                  = "FMBA", -- >= 0
        }
        self.NumericalFact = fact[_Parameter]
    elseif (_Index == 2) then
        self.Value = _Parameter * 1
    end
end

function B_Reward_AI_SetNumericalFact:CustomFunction(_Quest)
    if self.NumericalFact ~= nil then
        AICore.SetNumericalFact(self.AIPlayerID, self.NumericalFact, self.Value)
    end
end

function B_Reward_AI_SetNumericalFact:GetCustomData(_Index)
    if (_Index == 1) then
        return {
            "Courage",
            "Reconstruction",
            "Build Order",
            "Conquer Outposts",
            "Mount Outposts",
            "max. Bowmen",
            "max. Swordmen",
            "max. Rams",
            "max. Catapults",
            "max. Ammunition Carts",
            "max. Siege Towers",
            "max. Wall Catapults",
        };
    end
end

function B_Reward_AI_SetNumericalFact:Debug(_Quest)
    if Logic.GetStoreHouse(self.AIPlayerID) == 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayerID .. " is wrong or dead!");
        return true;
    elseif not self.NumericalFact then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": invalid numerical fact choosen!");
        return true;
    else
        if self.NumericalFact == "BARB" or self.NumericalFact == "FCOP" or self.NumericalFact == "FMOP" then
            if self.Value ~= 0 and self.Value ~= 1 then
                debug(false, _Quest.Identifier.. ": " ..self.Name .. ": BARB, FCOP, FMOP: value must be 1 or 0!");
                return true;
            end
        elseif self.NumericalFact == "FEAR" then
            if self.Value <= 0 then
                debug(false, _Quest.Identifier.. ": " ..self.Name .. ": FEAR: value must greater than 0!");
                return true;
            end
        else
            if self.Value < 0 then
                debug(false, _Quest.Identifier.. ": " ..self.Name .. ": value must always greater than or equal 0!");
                return true;
            end
        end
    end
    return false
end

RegisterBehavior(B_Reward_AI_SetNumericalFact);

-- -------------------------------------------------------------------------- --

function Reward_AI_Aggressiveness(...)
    return B_Reward_AI_Aggressiveness:new(...);
end

B_Reward_AI_Aggressiveness = {
    Name = "Reward_AI_Aggressiveness",
    Description = {
        en = "Reward: Sets the AI player's aggressiveness.",
        de = "Lohn: Setzt die Aggressivität des KI-Spielers fest.",
        fr = "Récompense: Définit l'agressivité du joueur IA.",
    },
    Parameter =
    {
        { ParameterType.PlayerID, en = "AI player", de = "KI-Spieler", fr = "Joueur AI" },
        { ParameterType.Custom, en = "Aggressiveness (1-3)", de = "Aggressivität (1-3)", fr = "Agressivité (1-3)" }
    }
};

function B_Reward_AI_Aggressiveness:GetRewardTable()
    return {Reward.Custom, {self, self.CustomFunction} };
end

function B_Reward_AI_Aggressiveness:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.AIPlayer = _Parameter * 1;
    elseif _Index == 1 then
        self.Aggressiveness = tonumber(_Parameter);
    end
end

function B_Reward_AI_Aggressiveness:CustomFunction()
    local player = (PlayerAIs[self.AIPlayer]
        or AIPlayerTable[self.AIPlayer]
        or AIPlayer:new(self.AIPlayer, AIPlayerProfile_City));
    assert(player ~= nil);
    PlayerAIs[self.AIPlayer] = player;
    if self.Aggressiveness >= 2 then
        player.ProfileLoop = AIProfile_Skirmish;
        player.Skirmish = player.Skirmish or {};
        player.Skirmish.Claim_MinTime = SkirmishDefault.Claim_MinTime + (self.Aggressiveness - 2) * 390;
        player.Skirmish.Claim_MaxTime = player.Skirmish.Claim_MinTime * 2;
    else
        player.ProfileLoop = AIPlayerProfile_City;
    end
end

function B_Reward_AI_Aggressiveness:Debug(_Quest)
    if self.AIPlayer < 1 or Logic.GetStoreHouse(self.AIPlayer) == 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayer .. " is wrong");
        return true;
    end
end

function B_Reward_AI_Aggressiveness:GetCustomData(_Index)
    return { "1", "2", "3" };
end

RegisterBehavior(B_Reward_AI_Aggressiveness)

-- -------------------------------------------------------------------------- --

function Reward_AI_SetEnemy(...)
    return B_Reward_AI_SetEnemy:new(...);
end

B_Reward_AI_SetEnemy = {
    Name = "Reward_AI_SetEnemy",
    Description = {
        en = "Reward:Sets the enemy of an AI player (the AI only handles one enemy properly).",
        de = "Lohn: Legt den Feind eines KI-Spielers fest (die KI behandelt nur einen Feind korrekt).",
        fr = "Récompense: Définit l'ennemi d'un joueur IA (l'IA ne traite correctement qu'un seul ennemi).",
    },
    Parameter =
    {
        { ParameterType.PlayerID, en = "AI player", de = "KI-Spieler", fr = "Joueur AI" },
        { ParameterType.PlayerID, en = "Enemy", de = "Feind", fr = "Ennemi" }
    }
};

function B_Reward_AI_SetEnemy:GetRewardTable()
    return {Reward.Custom, {self, self.CustomFunction} };
end

function B_Reward_AI_SetEnemy:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.AIPlayer = _Parameter * 1;
    elseif _Index == 1 then
        self.Enemy = _Parameter * 1;
    end
end

function B_Reward_AI_SetEnemy:CustomFunction()
    local player = PlayerAIs[self.AIPlayer];
    if player and player.Skirmish then
        player.Skirmish.Enemy = self.Enemy;
    end
end

function B_Reward_AI_SetEnemy:Debug(_Quest)
    if self.AIPlayer < 1 or self.AIPlayer > 8 or Logic.PlayerGetIsHumanFlag(self.AIPlayer) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Player " .. self.AIPlayer .. " is wrong");
        return true;
    end
    return false;
end
RegisterBehavior(B_Reward_AI_SetEnemy)

-- -------------------------------------------------------------------------- --

function Reward_ReplaceEntity(...)
    return B_Reward_ReplaceEntity:new(...);
end

B_Reward_ReplaceEntity = CopyTable(B_Reprisal_ReplaceEntity);
B_Reward_ReplaceEntity.Name = "Reward_ReplaceEntity";
B_Reward_ReplaceEntity.Description.en = "Reward: Replaces an entity with a new one of a different type. The playerID can be changed too.";
B_Reward_ReplaceEntity.Description.de = "Lohn: Ersetzt eine Entity durch eine neue anderen Typs. Es kann auch die Spielerzugehörigkeit geändert werden.";
B_Reward_ReplaceEntity.Description.fr = "Récompense: Remplace une entité par une nouvelle entité d'un autre type. Il est également possible de changer l'appartenance d'un joueur.";
B_Reward_ReplaceEntity.GetReprisalTable = nil;

B_Reward_ReplaceEntity.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_ReplaceEntity);

-- -------------------------------------------------------------------------- --

function Reward_SetResourceAmount(...)
    return B_Reward_SetResourceAmount:new(...);
end

B_Reward_SetResourceAmount = {
    Name = "Reward_SetResourceAmount",
    Description = {
        en = "Reward: Set the current and maximum amount of a resource doodad (the amount can also set to 0)",
        de = "Lohn: Setzt die aktuellen sowie maximalen Resourcen in einem Doodad (auch 0 ist möglich)",
        fr = "Récompense: Définit les ressources actuelles ainsi que les ressources maximales dans un Doodad (0 est également possible)",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Ressource", de = "Resource", fr = "Ressources" },
        { ParameterType.Number, en = "Amount", de = "Menge", fr = "Quantité" },
    },
}

function B_Reward_SetResourceAmount:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_SetResourceAmount:AddParameter(_Index, _Parameter)

    if (_Index == 0) then
        self.ScriptName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
    end

end

function B_Reward_SetResourceAmount:CustomFunction(_Quest)
    if Logic.IsEntityDestroyed( self.ScriptName ) then
        return false
    end
    local EntityID = GetID( self.ScriptName )
    if Logic.GetResourceDoodadGoodType( EntityID ) == 0 then
        return false
    end
    Logic.SetResourceDoodadGoodAmount( EntityID, self.Amount )
end

function B_Reward_SetResourceAmount:Debug(_Quest)
    if not IsExisting(self.ScriptName) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": resource entity does not exist!")
        return true
    elseif not type(self.Amount) == "number" or self.Amount < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": resource amount can not be negative!")
        return true
    end
    return false;
end

RegisterBehavior(B_Reward_SetResourceAmount);

-- -------------------------------------------------------------------------- --

function Reward_Resources(...)
    return B_Reward_Resources:new(...);
end

B_Reward_Resources = {
    Name = "Reward_Resources",
    Description = {
        en = "Reward: The player receives a given amount of Goods in his store.",
        de = "Lohn: Legt der Partei die angegebenen Rohstoffe ins Lagerhaus.",
        fr = "Récompense: Placez les matières premières indiquées dans l'entrepôt de la faction.",
    },
    Parameter = {
        { ParameterType.RawGoods,   en = "Type of good",    de = "Resourcentyp",        fr = "Type de ressources" },
        { ParameterType.Number,     en = "Amount of good",  de = "Anzahl der Resource", fr = "Nombre de ressources" },
    },
}

function B_Reward_Resources:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 1) then
        self.GoodAmount = _Parameter * 1
    end
end

function B_Reward_Resources:GetRewardTable()
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    return { Reward.Resources, GoodType, self.GoodAmount }
end

RegisterBehavior(B_Reward_Resources);

-- -------------------------------------------------------------------------- --

function Reward_SendCart(...)
    return B_Reward_SendCart:new(...);
end

B_Reward_SendCart = {
    Name = "Reward_SendCart",
    Description = {
        en = "Reward: Sends a cart to a player. It spawns at a building or by replacing an entity. The cart can replace the entity if it's not a building.",
        de = "Lohn: Sendet einen Karren zu einem Spieler. Der Karren wird an einem Gebäude oder einer Entity erstellt. Er ersetzt die Entity, wenn diese kein Gebäude ist.",
        fr = "Récompense: Envoie un chariot à un joueur. Le chariot est créé sur un bâtiment ou une entité. Elle remplace l'entité si celle-ci n'est pas un bâtiment.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script entity",           de = "Script Entity",               fr = "Entité de Script" },
        { ParameterType.PlayerID,   en = "Owning player",           de = "Besitzer",                    fr = "Propriétaire" },
        { ParameterType.Custom,     en = "Type name",               de = "Typbezeichnung",              fr = "Désignation du type" },
        { ParameterType.Custom,     en = "Good type",               de = "Warentyp",                    fr = "Type de marchandise" },
        { ParameterType.Number,     en = "Amount",                  de = "Anzahl",                      fr = "Quantité" },
        { ParameterType.Custom,     en = "Override target player",  de = "Anderer Zielspieler",         fr = "Autre joueur destinataire" },
        { ParameterType.Custom,     en = "Ignore reservations",     de = "Ignoriere Reservierungen",    fr = "Ignorer les réservations" },
        { ParameterType.Custom,     en = "Replace entity",          de = "Entity ersetzen",             fr = "Remplacer une entité" },
    },
}

function B_Reward_SendCart:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_SendCart:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptNameEntity = _Parameter
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 2) then
        self.UnitKey = _Parameter
    elseif (_Index == 3) then
        self.GoodType = _Parameter
    elseif (_Index == 4) then
        self.GoodAmount = _Parameter * 1
    elseif (_Index == 5) then
        self.OverrideTargetPlayer = tonumber(_Parameter)
    elseif (_Index == 6) then
        self.IgnoreReservation = ToBoolean(_Parameter)
    elseif (_Index == 7) then
        self.ReplaceEntity = ToBoolean(_Parameter)
    end
end

function B_Reward_SendCart:CustomFunction(_Quest)

    if not IsExisting( self.ScriptNameEntity ) then
        return false;
    end

    local ID = SendCart(self.ScriptNameEntity, self.PlayerID, Goods[self.GoodType], self.GoodAmount, Entities[self.UnitKey], self.IgnoreReservation);

    if self.ReplaceEntity and Logic.IsBuilding(GetID(self.ScriptNameEntity)) == 0 then
        DestroyEntity(self.ScriptNameEntity);
        Logic.SetEntityName(ID, self.ScriptNameEntity);
    end
    if self.OverrideTargetPlayer then
        Logic.ResourceMerchant_OverrideTargetPlayerID(ID,self.OverrideTargetPlayer);
    end
end

function B_Reward_SendCart:GetCustomData( _Index )
    local Data = {};
    if _Index == 2 then
        Data = { "U_ResourceMerchant", "U_Medicus", "U_Marketer", "U_ThiefCart", "U_GoldCart", "U_Noblemen_Cart", "U_RegaliaCart" };
    elseif _Index == 3 then
        for k, v in pairs( Goods ) do
            if string.find( k, "^G_" ) then
                table.insert( Data, k );
            end
        end
        table.sort( Data );
    elseif _Index == 5 then
        table.insert( Data, "-" );
        for i = 1, 8 do
            table.insert( Data, i );
        end
    elseif _Index == 6 then
        table.insert( Data, "false" );
        table.insert( Data, "true" );
    elseif _Index == 7 then
        table.insert( Data, "false" );
        table.insert( Data, "true" );
    end
    return Data;
end

function B_Reward_SendCart:Debug(_Quest)
    if not IsExisting(self.ScriptNameEntity) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": spawnpoint does not exist!");
        return true;
    elseif not tonumber(self.PlayerID) or self.PlayerID < 1 or self.PlayerID > 8 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": got a invalid playerID!");
        return true;
    elseif not Entities[self.UnitKey] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": entity type '"..self.UnitKey.."' is invalid!");
        return true;
    elseif not Goods[self.GoodType] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": good type '"..self.GoodType.."' is invalid!");
        return true;
    elseif not tonumber(self.GoodAmount) or self.GoodAmount < 1 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": good amount can not be below 1!");
        return true;
    elseif tonumber(self.OverrideTargetPlayer) and (self.OverrideTargetPlayer < 1 or self.OverrideTargetPlayer > 8) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": overwrite target player with invalid playerID!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reward_SendCart);

-- -------------------------------------------------------------------------- --

function Reward_Units(...)
    return B_Reward_Units:new(...)
end

B_Reward_Units = {
    Name = "Reward_Units",
    Description = {
        en = "Reward: Creates units for the quest receiver.",
        de = "Lohn: Erzeugt einige Einheiten für den Auftragnehmer.",
        fr = "Récompense: Unités",
    },
    Parameter = {
        { ParameterType.Entity, en = "Type name", de = "Typbezeichnung", fr ="Désignation de type" },
        { ParameterType.Number, en = "Amount", de = "Anzahl", fr ="Quantité" },
    },
}

function B_Reward_Units:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.EntityName = _Parameter
    elseif (_Index == 1) then
        self.Amount = _Parameter * 1
    end
end

function B_Reward_Units:GetRewardTable()
    return { Reward.Units, assert( Entities[self.EntityName] ), self.Amount }
end

RegisterBehavior(B_Reward_Units);

-- -------------------------------------------------------------------------- --

function Reward_QuestRestart(...)
    return B_Reward_QuestRestart:new(...)
end

B_Reward_QuestRestart = CopyTable(B_Reprisal_QuestRestart);
B_Reward_QuestRestart.Name = "Reward_QuestRestart";
B_Reward_QuestRestart.Description.en = "Reward: Restarts a (completed) quest so it can be triggered and completed again.";
B_Reward_QuestRestart.Description.de = "Lohn: Startet eine (beendete) Quest neu, damit diese neu ausgelöst und beendet werden kann.";
B_Reward_QuestRestart.Description.fr = "Récompense: Redémarre une quête (terminée) pour qu'elle puisse être redéclenchée et terminée.";
B_Reward_QuestRestart.GetReprisalTable = nil;

B_Reward_QuestRestart.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_QuestRestart);

-- -------------------------------------------------------------------------- --

function Reward_QuestFailure(...)
    return B_Reward_QuestFailure:new(...)
end

B_Reward_QuestFailure = CopyTable(B_Reprisal_QuestFailure);
B_Reward_QuestFailure.Name = "Reward_QuestFailure";
B_Reward_QuestFailure.Description.en = "Reward: Lets another active quest fail.";
B_Reward_QuestFailure.Description.de = "Lohn: Lässt eine andere aktive Quest fehlschlagen.";
B_Reward_QuestFailure.Description.fr = "Récompense: Fait échouer une autre quête active.";
B_Reward_QuestFailure.GetReprisalTable = nil;

B_Reward_QuestFailure.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_QuestFailure);

-- -------------------------------------------------------------------------- --

function Reward_QuestSuccess(...)
    return B_Reward_QuestSuccess:new(...)
end

B_Reward_QuestSuccess = CopyTable(B_Reprisal_QuestSuccess);
B_Reward_QuestSuccess.Name = "Reward_QuestSuccess";
B_Reward_QuestSuccess.Description.en = "Reward: Completes another active quest successfully.";
B_Reward_QuestSuccess.Description.de = "Lohn: Beendet eine andere aktive Quest erfolgreich.";
B_Reward_QuestSuccess.Description.fr = "Récompense: Termine avec succès une autre quête active.";
B_Reward_QuestSuccess.GetReprisalTable = nil;

B_Reward_QuestSuccess.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_QuestSuccess);

-- -------------------------------------------------------------------------- --

function Reward_QuestActivate(...)
    return B_Reward_QuestActivate:new(...)
end

B_Reward_QuestActivate = CopyTable(B_Reprisal_QuestActivate);
B_Reward_QuestActivate.Name = "Reward_QuestActivate";
B_Reward_QuestActivate.Description.en = "Reward: Activates another quest that is not triggered yet.";
B_Reward_QuestActivate.Description.de = "Lohn: Aktiviert eine andere Quest die noch nicht ausgelöst wurde.";
B_Reward_QuestActivate.Description.fr = "Récompense: Active une autre quête qui n'a pas encore été déclenchée.";
B_Reward_QuestActivate.GetReprisalTable = nil;

B_Reward_QuestActivate.GetRewardTable = function(self, _Quest)
    return {Reward.Custom, {self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_QuestActivate)

-- -------------------------------------------------------------------------- --

function Reward_QuestInterrupt(...)
    return B_Reward_QuestInterrupt:new(...)
end

B_Reward_QuestInterrupt = CopyTable(B_Reprisal_QuestInterrupt);
B_Reward_QuestInterrupt.Name = "Reward_QuestInterrupt";
B_Reward_QuestInterrupt.Description.en = "Reward: Interrupts another active quest without success or failure.";
B_Reward_QuestInterrupt.Description.de = "Lohn: Beendet eine andere aktive Quest ohne Erfolg oder Misserfolg.";
B_Reward_QuestInterrupt.Description.fr = "Récompense: Termine une autre quête active sans succès ni échec.";
B_Reward_QuestInterrupt.GetReprisalTable = nil;

B_Reward_QuestInterrupt.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_QuestInterrupt);

-- -------------------------------------------------------------------------- --

function Reward_QuestForceInterrupt(...)
    return B_Reward_QuestForceInterrupt:new(...)
end

B_Reward_QuestForceInterrupt = CopyTable(B_Reprisal_QuestForceInterrupt);
B_Reward_QuestForceInterrupt.Name = "Reward_QuestForceInterrupt";
B_Reward_QuestForceInterrupt.Description.en = "Reward: Interrupts another quest (even when it isn't active yet) without success or failure.";
B_Reward_QuestForceInterrupt.Description.de = "Lohn: Beendet eine andere Quest, auch wenn diese noch nicht aktiv ist ohne Erfolg oder Misserfolg.";
B_Reward_QuestForceInterrupt.Description.fr = "Récompense: Termine une autre quête, même si elle n'est pas encore active, sans succès ni échec.";
B_Reward_QuestForceInterrupt.GetReprisalTable = nil;

B_Reward_QuestForceInterrupt.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_QuestForceInterrupt);

-- -------------------------------------------------------------------------- --

function Reward_CustomVariables(...)
    return B_Reward_CustomVariables:new(...);
end

B_Reward_CustomVariables = CopyTable(B_Reprisal_CustomVariables);
B_Reward_CustomVariables.Name = "Reward_CustomVariables";
B_Reward_CustomVariables.Description.en = "Reward: Executes a mathematical operation with this variable. The other operand can be a number or another custom variable.";
B_Reward_CustomVariables.Description.de = "Lohn: Führt eine mathematische Operation mit der Variable aus. Der andere Operand kann eine Zahl oder eine Custom-Varible sein.";
B_Reward_CustomVariables.Description.fr = "Récompense: Effectue une opération mathématique sur la variable. L'autre opérateur peut être un nombre ou une variable personnalisée.";
B_Reward_CustomVariables.GetReprisalTable = nil;

B_Reward_CustomVariables.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, {self, self.CustomFunction} };
end

RegisterBehavior(B_Reward_CustomVariables)

-- -------------------------------------------------------------------------- --

function Reward_MapScriptFunction(...)
    return B_Reward_MapScriptFunction:new(...);
end

B_Reward_MapScriptFunction = CopyTable(B_Reprisal_MapScriptFunction);
B_Reward_MapScriptFunction.Name = "Reward_MapScriptFunction";
B_Reward_MapScriptFunction.Description.en = "Reward: Calls a function within the global map script if the quest has failed.";
B_Reward_MapScriptFunction.Description.de = "Lohn: Ruft eine Funktion im globalen Kartenskript auf, wenn die Quest fehlschlägt.";
B_Reward_MapScriptFunction.Description.fr = "Récompense: Invoque une fonction dans le script global de la carte en cas d'échec de la quête.";
B_Reward_MapScriptFunction.GetReprisalTable = nil;

B_Reward_MapScriptFunction.GetRewardTable = function(self, _Quest)
    return {Reward.Custom, {self, self.CustomFunction}};
end

RegisterBehavior(B_Reward_MapScriptFunction);

-- -------------------------------------------------------------------------- --

function Reward_Technology(...)
    return B_Reward_Technology:new(...);
end

B_Reward_Technology = CopyTable(B_Reprisal_Technology);
B_Reward_Technology.Name = "Reward_Technology";
B_Reward_Technology.Description.en = "Reward: Locks or unlocks a technology for the given player.";
B_Reward_Technology.Description.de = "Lohn: Sperrt oder erlaubt eine Technolgie fuer den angegebenen Player.";
B_Reward_Technology.Description.fr = "Récompense: Bloque ou autorise une technologie pour le joueur spécifié.";
B_Reward_Technology.GetReprisalTable = nil;

B_Reward_Technology.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, {self, self.CustomFunction} }
end

RegisterBehavior(B_Reward_Technology);

-- -------------------------------------------------------------------------- --

function Reward_PrestigePoints(...)
    return B_Reward_PrestigePoints:mew(...);
end

B_Reward_PrestigePoints  = {
    Name = "Reward_PrestigePoints",
    Description = {
        en = "Reward: Gives the quest receiver prestige.",
        de = "Lohn: Gibt dem Auftragnehmer Prestige.",
        fr = "Récompense: Prestige",
    },
    Parameter = {
        { ParameterType.Number, en = "Points", de = "Punkte", fr = "Points" },
    },
}

function B_Reward_PrestigePoints :AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Points = _Parameter
    end
end

function B_Reward_PrestigePoints :GetRewardTable()
    return { Reward.PrestigePoints, self.Points }
end

RegisterBehavior(B_Reward_PrestigePoints);

-- -------------------------------------------------------------------------- --

function Reward_AI_MountOutpost(...)
    return B_Reward_AI_MountOutpost:new(...);
end

B_Reward_AI_MountOutpost = {
    Name = "Reward_AI_MountOutpost",
    Description = {
        en = "Reward: Places a troop of soldiers on a named outpost.",
        de = "Lohn: Platziert einen Trupp Soldaten auf einem Aussenposten der KI.",
        fr = "Récompense: Place un groupe de soldats sur un avant-poste de l'IA.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name",   de = "Skriptname",  fr = "Nom de l'entité" },
        { ParameterType.Custom,     en = "Soldiers type", de = "Soldatentyp", fr = "Type de soldat" },
    },
}

function B_Reward_AI_MountOutpost:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_AI_MountOutpost:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.Scriptname = _Parameter
    else
        self.SoldiersType = _Parameter
    end
end

function B_Reward_AI_MountOutpost:CustomFunction(_Quest)
    local outpostID = assert(
        not Logic.IsEntityDestroyed(self.Scriptname) and GetID(self.Scriptname),
       _Quest.Identifier .. ": Error in " .. self.Name .. ": CustomFunction: Outpost is invalid"
    )
    local AIPlayerID = Logic.EntityGetPlayer(outpostID)
    local ax, ay = Logic.GetBuildingApproachPosition(outpostID)
    local TroopID = Logic.CreateBattalionOnUnblockedLand(Entities[self.SoldiersType], ax, ay, 0, AIPlayerID, 0)
    AICore.HideEntityFromAI(AIPlayerID, TroopID, true)
    Logic.CommandEntityToMountBuilding(TroopID, outpostID)
end

function B_Reward_AI_MountOutpost:GetCustomData(_Index)
    if _Index == 1 then
        local Data = {}
        for k,v in pairs(Entities) do
            if string.find(k, "U_MilitaryBandit") or string.find(k, "U_MilitarySword") or string.find(k, "U_MilitaryBow") then
                Data[#Data+1] = k
            end
        end
        return Data
    end
end

function B_Reward_AI_MountOutpost:Debug(_Quest)
    if Logic.IsEntityDestroyed(self.Scriptname) then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Outpost " .. self.Scriptname .. " is missing")
        return true
    end
end

RegisterBehavior(B_Reward_AI_MountOutpost)

-- -------------------------------------------------------------------------- --

function Reward_QuestRestartForceActive(...)
    return B_Reward_QuestRestartForceActive:new(...);
end

B_Reward_QuestRestartForceActive = {
    Name = "Reward_QuestRestartForceActive",
    Description = {
        en = "Reward: Restarts a (completed) quest and triggers it immediately.",
        de = "Lohn: Startet eine (beendete) Quest neu und triggert sie sofort.",
        fr = "Récompense: Redémarre une quête (terminée) et la déclenche immédiatement.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name", de = "Questname", fr = "Nom de la quête" },
    },
}

function B_Reward_QuestRestartForceActive:GetRewardTable()
    return { Reward.Custom,{self, self.CustomFunction} }
end

function B_Reward_QuestRestartForceActive:AddParameter(_Index, _Parameter)
    self.QuestName = _Parameter
end

function B_Reward_QuestRestartForceActive:CustomFunction(_Quest)
    local QuestID, Quest = self:ResetQuest(_Quest);
    if QuestID then
        Quest:SetMsgKeyOverride();
        Quest:SetIconOverride();
        Quest:Trigger();
    end
end

B_Reward_QuestRestartForceActive.ResetQuest = B_Reward_QuestRestart.CustomFunction;
function B_Reward_QuestRestartForceActive:Debug(_Quest)
    if not Quests[GetQuestID(self.QuestName)] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Quest: "..  self.QuestName .. " does not exist");
        return true;
    end
    return false;
end

RegisterBehavior(B_Reward_QuestRestartForceActive)

-- -------------------------------------------------------------------------- --

function Reward_UpgradeBuilding(...)
    return B_Reward_UpgradeBuilding:new(...);
end

B_Reward_UpgradeBuilding = {
    Name = "Reward_UpgradeBuilding",
    Description = {
        en = "Reward: Upgrades a building",
        de = "Lohn: Baut ein Gebäude aus",
        fr = "Récompense: Améliore un Bâtiment",
    },
    Parameter =    {
        { ParameterType.ScriptName, en = "Building", de = "Gebäude", fr = "Bâtiment" }
    }
};

function B_Reward_UpgradeBuilding:GetRewardTable()
    return {Reward.Custom, {self, self.CustomFunction}};
end

function B_Reward_UpgradeBuilding:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.Building = _Parameter;
    end
end

function B_Reward_UpgradeBuilding:CustomFunction(_Quest)
    local building = GetID(self.Building);
    if building ~= 0
    and Logic.IsBuilding(building) == 1
    and Logic.IsBuildingUpgradable(building, true)
    and Logic.IsBuildingUpgradable(building, false)
    then
        Logic.UpgradeBuilding(building);
    end
end

function B_Reward_UpgradeBuilding:Debug(_Quest)
    local building = GetID(self.Building);
    if not (building ~= 0
            and Logic.IsBuilding(building) == 1
            and Logic.IsBuildingUpgradable(building, true)
            and Logic.IsBuildingUpgradable(building, false) )
    then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Building is wrong")
        return true
    end
end

RegisterBehavior(B_Reward_UpgradeBuilding)

-- -------------------------------------------------------------------------- --

function Reward_SetBuildingUpgradeLevel(...)
    return B_Reward_SetBuildingUpgradeLevel:new(...);
end

B_Reward_SetBuildingUpgradeLevel = {
    Name = "Reward_SetBuildingUpgradeLevel",
    Description = {
        en = "Reward: Sets the upgrade level of the specified building.",
        de = "Lohn: Legt das Upgrade-Level eines Gebaeudes fest.",
        fr = "Récompense: Définit le niveau d'amélioration d'un bâtiment.",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Building",        de = "Gebäude",         fr = "Bâtiment" },
        { ParameterType.Custom,     en = "Upgrade level",   de = "Upgrade-Level",   fr = "Niveau d'amélioration" },
    }
};

function B_Reward_SetBuildingUpgradeLevel:GetRewardTable()
    return {Reward.Custom, self, self.CustomFunction};
end

function B_Reward_SetBuildingUpgradeLevel:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.Building = _Parameter;
    elseif _Index == 1 then
        self.UpgradeLevel = tonumber(_Parameter);
    end
end

function B_Reward_SetBuildingUpgradeLevel:CustomFunction()
    local building = Logic.GetEntityIDByName(self.Building);
    local upgradeLevel = Logic.GetUpgradeLevel(building);
    local maxUpgradeLevel = Logic.GetMaxUpgradeLevel(building);
    if building ~= 0 
    and Logic.IsBuilding(building) == 1
    and (Logic.IsBuildingUpgradable(building, true)
    or (maxUpgradeLevel ~= 0 
    and maxUpgradeLevel == upgradeLevel))
    then
        Logic.SetUpgradableBuildingState(building, math.min(self.UpgradeLevel, maxUpgradeLevel), 0);
    end
end

function B_Reward_SetBuildingUpgradeLevel:Debug(_Quest)
    local building = Logic.GetEntityIDByName( self.Building )
    if not building or Logic.IsBuilding(building) == 0  then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Building " .. self.Building .. " is missing or no building.")
        return true
    elseif not self.UpgradeLevel or self.UpgradeLevel < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Upgrade level is wrong")
        return true
    end
end

function B_Reward_SetBuildingUpgradeLevel:GetCustomData(_Index)
    if _Index == 1 then
        return { "0", "1", "2", "3" };
    end
end

RegisterBehavior(B_Reward_SetBuildingUpgradeLevel);

-- -------------------------------------------------------------------------- --

function Trigger_PlayerDiscovered(...)
    return B_Trigger_PlayerDiscovered:new(...);
end

B_Trigger_PlayerDiscovered = {
    Name = "Trigger_PlayerDiscovered",
    Description = {
        en = "Trigger: if a given player has been discovered",
        de = "Auslöser: wenn ein angegebener Spieler entdeckt wurde",
        fr = "Déclencheur: lorsqu'un joueur spécifié est découvert",
    },
    Parameter = {
        { ParameterType.PlayerID, en = "Player", de = "Spieler", fr = "Joueur" },
    },
}

function B_Trigger_PlayerDiscovered:GetTriggerTable()
    return {Triggers.PlayerDiscovered, self.PlayerID}
end

function B_Trigger_PlayerDiscovered:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1;
    end
end

RegisterBehavior(B_Trigger_PlayerDiscovered);

-- -------------------------------------------------------------------------- --

function Trigger_OnDiplomacy(...)
    return B_Trigger_OnDiplomacy:new(...);
end

B_Trigger_OnDiplomacy = {
    Name = "Trigger_OnDiplomacy",
    Description = {
        en = "Trigger: if diplomatic relations have been established with a player",
        de = "Auslöser: wenn ein angegebener Diplomatie-Status mit einem Spieler erreicht wurde.",
        fr = "Déclencheur: lorsqu'un statut diplomatique spécifié a été atteint avec un joueur.",
    },
    Parameter = {
        { ParameterType.PlayerID,       en = "Player",      de = "Spieler",     fr = "Joueur" },
        { ParameterType.DiplomacyState, en = "Relation",    de = "Beziehung",   fr = "Relation diplomatique" },
    },
}

function B_Trigger_OnDiplomacy:GetTriggerTable()
    return {Triggers.Diplomacy, self.PlayerID, assert( DiplomacyStates[self.DiplState] ) }
end

function B_Trigger_OnDiplomacy:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.DiplState = _Parameter
    end
end

RegisterBehavior(B_Trigger_OnDiplomacy);

-- -------------------------------------------------------------------------- --

function Trigger_OnNeedUnsatisfied(...)
    return B_Trigger_OnNeedUnsatisfied:new(...);
end

B_Trigger_OnNeedUnsatisfied = {
    Name = "Trigger_OnNeedUnsatisfied",
    Description = {
        en = "Trigger: if a specified need is unsatisfied",
        de = "Auslöser: wenn ein bestimmtes Beduerfnis nicht befriedigt ist.",
        fr = "Déclencheur: lorsqu'un certain besoin n'est pas satisfait.",
    },
    Parameter = {
        { ParameterType.PlayerID,   en = "Player",              de = "Spieler",             fr = "Joueur" },
        { ParameterType.Need,       en = "Need",                de = "Beduerfnis",          fr = "Besoin" },
        { ParameterType.Number,     en = "Workers on strike",   de = "Streikende Arbeiter", fr = "Travailleurs en grève" },
    },
}

function B_Trigger_OnNeedUnsatisfied:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnNeedUnsatisfied:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.Need = _Parameter
    elseif (_Index == 2) then
        self.WorkersOnStrike = _Parameter * 1
    end
end

function B_Trigger_OnNeedUnsatisfied:CustomFunction(_Quest)
    return Logic.GetNumberOfStrikingWorkersPerNeed( self.PlayerID, Needs[self.Need] ) >= self.WorkersOnStrike
end

function B_Trigger_OnNeedUnsatisfied:Debug(_Quest)
    if Logic.GetStoreHouse(self.PlayerID) == 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": " .. self.PlayerID .. " does not exist.")
        return true
    elseif not Needs[self.Need] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": " .. self.Need .. " does not exist.")
        return true
    elseif self.WorkersOnStrike < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": WorkersOnStrike value negative")
        return true
    end
    return false;
end

RegisterBehavior(B_Trigger_OnNeedUnsatisfied);

-- -------------------------------------------------------------------------- --

function Trigger_OnResourceDepleted(...)
    return B_Trigger_OnResourceDepleted:new(...);
end

B_Trigger_OnResourceDepleted = {
    Name = "Trigger_OnResourceDepleted",
    Description = {
        en = "Trigger: if a resource is (temporarily) depleted",
        de = "Auslöser: wenn eine Ressource (zeitweilig) verbraucht ist",
        fr = "Déclencheur: lorsqu'une ressource est (temporairement) consommée",
    },
    Parameter = {
        { ParameterType.ScriptName, en = "Script name", de = "Skriptname", fr = "Nom de script" },
    },
}

function B_Trigger_OnResourceDepleted:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnResourceDepleted:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.ScriptName = _Parameter
    end
end

function B_Trigger_OnResourceDepleted:CustomFunction(_Quest)
    local ID = GetID(self.ScriptName)
    return not ID or ID == 0 or Logic.GetResourceDoodadGoodType(ID) == 0 or Logic.GetResourceDoodadGoodAmount(ID) == 0
end

RegisterBehavior(B_Trigger_OnResourceDepleted);

-- -------------------------------------------------------------------------- --

function Trigger_OnAmountOfGoods(...)
    return B_Trigger_OnAmountOfGoods:new(...);
end

B_Trigger_OnAmountOfGoods = {
    Name = "Trigger_OnAmountOfGoods",
    Description = {
        en = "Trigger: if the player has gathered a given amount of resources in his storehouse",
        de = "Auslöser: wenn der Spieler eine bestimmte Menge einer Ressource in seinem Lagerhaus hat",
        fr = "Déclencheur: lorsque le joueur a une certaine quantité d'une ressource dans son entrepôt",
    },
    Parameter = {
        { ParameterType.PlayerID,   en = "Player",          de = "Spieler",             fr = "Joueur" },
        { ParameterType.RawGoods,   en = "Type of good",    de = "Resourcentyp",        fr = "Type de ressources" },
        { ParameterType.Number,     en = "Amount of good",  de = "Anzahl der Resource", fr = "Quantité de ressources" },
    },
}

function B_Trigger_OnAmountOfGoods:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnAmountOfGoods:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.PlayerID = _Parameter * 1
    elseif (_Index == 1) then
        self.GoodTypeName = _Parameter
    elseif (_Index == 2) then
        self.GoodAmount = _Parameter * 1
    end
end

function B_Trigger_OnAmountOfGoods:CustomFunction(_Quest)
    local StoreHouseID = Logic.GetStoreHouse(self.PlayerID)
    if (StoreHouseID == 0) then
        return false
    end
    local GoodType = Logic.GetGoodTypeID(self.GoodTypeName)
    local GoodAmount = Logic.GetAmountOnOutStockByGoodType(StoreHouseID, GoodType)
    if (GoodAmount >= self.GoodAmount)then
        return true
    end
    return false
end

function B_Trigger_OnAmountOfGoods:Debug(_Quest)
    if Logic.GetStoreHouse(self.PlayerID) == 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": " .. self.PlayerID .. " does not exist.")
        return true
    elseif not Goods[self.GoodTypeName] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Good type is wrong.")
        return true
    elseif self.GoodAmount < 0 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Good amount is negative.")
        return true
    end
    return false;
end

RegisterBehavior(B_Trigger_OnAmountOfGoods);

-- -------------------------------------------------------------------------- --

function Trigger_OnQuestActive(...)
    return B_Trigger_OnQuestActiveWait:new(...);
end
Trigger_OnQuestActiveWait = Trigger_OnQuestActive;

B_Trigger_OnQuestActiveWait = {
    Name = "Trigger_OnQuestActiveWait",
    Description = {
        en = "Trigger: if a given quest has been activated. Waiting time optional",
        de = "Auslöser: wenn eine angegebene Quest aktiviert wurde. Optional mit Wartezeit",
        fr = "Déclencheur: lorsqu'une quête indiquée a été activée. En option avec délai d'attente",
    },
    Parameter = {
        { ParameterType.QuestName,  en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,     en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente" },
    },
}

function B_Trigger_OnQuestActiveWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestActiveWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestActiveWait:CustomFunction(_Quest)
    local QuestID = GetQuestID(self.QuestName)
    if QuestID ~= nil then
        assert(type(QuestID) == "number");

        if (Quests[QuestID].State == QuestState.Active) then
            self.WasActivated = self.WasActivated or true;
        end
        if self.WasActivated then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestActiveWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": waitTime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestActiveWait:Interrupt(_Quest)
    -- does this realy matter after interrupt?
    -- self.WaitTimeTimer = nil;
    -- self.WasActivated = nil;
end

function B_Trigger_OnQuestActiveWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
    self.WasActivated = nil;
end

RegisterBehavior(B_Trigger_OnQuestActiveWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestActive = CopyTable(B_Trigger_OnQuestActiveWait);
B_Trigger_OnQuestActive.Name = "Trigger_OnQuestActive";
B_Trigger_OnQuestActive.Description.en = "Trigger: Starts the quest after another has been activated.";
B_Trigger_OnQuestActive.Description.de = "Auslöser: Startet den Quest, wenn ein anderer aktiviert wird.";
B_Trigger_OnQuestActive.Description.fr = "Déclencheur: Démarre la quête lorsqu'une autre est activée.";
B_Trigger_OnQuestActive.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestActive:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

RegisterBehavior(B_Trigger_OnQuestActive);

-- -------------------------------------------------------------------------- --

function Trigger_OnQuestFailure(...)
    return B_Trigger_OnQuestFailureWait:new(...);
end
Trigger_OnQuestFailureWait = Trigger_OnQuestFailure;

B_Trigger_OnQuestFailureWait = {
    Name = "Trigger_OnQuestFailureWait",
    Description = {
        en = "Trigger: if a given quest has failed. Waiting time optional",
        de = "Auslöser: wenn eine angegebene Quest fehlgeschlagen ist. Optional mit Wartezeit",
        fr = "Déclencheur: lorsqu'une quête indiquée a échoué. En option avec délai d'attente",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,    en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente" },
    },
}

function B_Trigger_OnQuestFailureWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestFailureWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestFailureWait:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].Result == QuestResult.Failure) then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestFailureWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": waitTime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestFailureWait:Interrupt(_Quest)
    self.WaitTimeTimer = nil;
end

function B_Trigger_OnQuestFailureWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
end

RegisterBehavior(B_Trigger_OnQuestFailureWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestFailure = CopyTable(B_Trigger_OnQuestFailureWait);
B_Trigger_OnQuestFailure.Name = "Trigger_OnQuestFailure";
B_Trigger_OnQuestFailure.Description.en = "Trigger: Starts the quest after another has failed.";
B_Trigger_OnQuestFailure.Description.de = "Auslöser: Startet den Quest, wenn ein anderer fehlschlägt.";
B_Trigger_OnQuestFailure.Description.fr = "Déclencheur: Lance la quête lorsqu'une autre échoue.";
B_Trigger_OnQuestFailure.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestFailure:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

RegisterBehavior(B_Trigger_OnQuestFailure);

-- -------------------------------------------------------------------------- --

function Trigger_OnQuestNotTriggered(...)
    return B_Trigger_OnQuestNotTriggered:new(...);
end

B_Trigger_OnQuestNotTriggered = {
    Name = "Trigger_OnQuestNotTriggered",
    Description = {
        en = "Trigger: if a given quest is not yet active. Should be used in combination with other triggers.",
        de = "Auslöser: wenn eine angegebene Quest noch inaktiv ist. Sollte mit weiteren Triggern kombiniert werden.",
        fr = "Déclencheur: lorsqu'une quête indiquée est encore inactive. Doit être combiné avec d'autres déclencheurs."
    },
    Parameter = {
        { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
    },
}

function B_Trigger_OnQuestNotTriggered:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestNotTriggered:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    end
end

function B_Trigger_OnQuestNotTriggered:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].State == QuestState.NotTriggered) then
            return true;
        end
    end
    return false;
end

function B_Trigger_OnQuestNotTriggered:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Trigger_OnQuestNotTriggered);

-- -------------------------------------------------------------------------- --

function Trigger_OnQuestInterrupted(...)
    return B_Trigger_OnQuestInterruptedWait:new(...);
end
Trigger_OnQuestInterruptedWait = Trigger_OnQuestInterrupted;

B_Trigger_OnQuestInterruptedWait = {
    Name = "Trigger_OnQuestInterruptedWait",
    Description = {
        en = "Trigger: if a given quest has been interrupted. Should be used in combination with other triggers.",
        de = "Auslöser: wenn eine angegebene Quest abgebrochen wurde. Sollte mit weiteren Triggern kombiniert werden.",
        fr = "Déclencheur: lorsqu'une quête indiquée a été interrompue. Doit être combiné avec d'autres déclencheurs."
    },
    Parameter = {
        { ParameterType.QuestName,  en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,     en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente"},
    },
}

function B_Trigger_OnQuestInterruptedWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestInterruptedWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestInterruptedWait:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].State == QuestState.Over and Quests[QuestID].Result == QuestResult.Interrupted) then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestInterruptedWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": waitTime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestInterruptedWait:Interrupt(_Quest)
    self.WaitTimeTimer = nil;
end

function B_Trigger_OnQuestInterruptedWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
end

RegisterBehavior(B_Trigger_OnQuestInterruptedWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestInterrupted = CopyTable(B_Trigger_OnQuestInterruptedWait);
B_Trigger_OnQuestInterrupted.Name = "Trigger_OnQuestInterrupted";
B_Trigger_OnQuestInterrupted.Description.en = "Trigger: Starts the quest after another is interrupted.";
B_Trigger_OnQuestInterrupted.Description.de = "Auslöser: Startet den Quest, wenn ein anderer abgebrochen wurde.";
B_Trigger_OnQuestInterrupted.Description.fr = "Déclencheur: Démarre la quête lorsqu'une autre a été annulée.";
B_Trigger_OnQuestInterrupted.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestInterrupted:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

RegisterBehavior(B_Trigger_OnQuestInterrupted);

-- -------------------------------------------------------------------------- --

function Trigger_OnQuestOver(...)
    return B_Trigger_OnQuestOverWait:new(...);
end
Trigger_OnQuestOverWait = Trigger_OnQuestOver;

B_Trigger_OnQuestOverWait = {
    Name = "Trigger_OnQuestOverWait",
    Description = {
        en = "Trigger: if a given quest has been finished, regardless of its result. Waiting time optional",
        de = "Auslöser: wenn eine angegebene Quest beendet wurde, unabhängig von deren Ergebnis. Wartezeit optional",
        fr = "Déclencheur: lorsqu'une quête indiquée est terminée, indépendamment de son résultat. Délai d'attente optionnel"
    },
    Parameter = {
        { ParameterType.QuestName,  en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,     en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente"},
    },
}

function B_Trigger_OnQuestOverWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestOverWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestOverWait:CustomFunction(_Quest)
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].State == QuestState.Over and Quests[QuestID].Result ~= QuestResult.Interrupted) then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestOverWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": waitTime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestOverWait:Interrupt(_Quest)
    self.WaitTimeTimer = nil;
end

function B_Trigger_OnQuestOverWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
end

RegisterBehavior(B_Trigger_OnQuestOverWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestOver = CopyTable(B_Trigger_OnQuestOverWait);
B_Trigger_OnQuestOver.Name = "Trigger_OnQuestOver";
B_Trigger_OnQuestOver.Description.en = "Trigger: Starts the quest after another finished.";
B_Trigger_OnQuestOver.Description.de = "Auslöser: Startet den Quest, wenn ein anderer abgeschlossen wurde.";
B_Trigger_OnQuestOver.Description.fr = "Déclencheur: Démarre la quête lorsqu'une autre est terminée.";
B_Trigger_OnQuestOver.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestOver:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

RegisterBehavior(B_Trigger_OnQuestOver);

-- -------------------------------------------------------------------------- --

function Trigger_OnQuestSuccess(...)
    return B_Trigger_OnQuestSuccessWait:new(...);
end
Trigger_OnQuestSuccessWait = Trigger_OnQuestSuccess;

B_Trigger_OnQuestSuccessWait = {
    Name = "Trigger_OnQuestSuccessWait",
    Description = {
        en = "Trigger: if a given quest has been finished successfully. Waiting time optional",
        de = "Auslöser: wenn eine angegebene Quest erfolgreich abgeschlossen wurde. Wartezeit optional",
        fr = "Déclencheur: lorsqu'une quête indiquée a été accomplie avec succès. Délai d'attente optionnel",
    },
    Parameter = {
        { ParameterType.QuestName,  en = "Quest name",   de = "Questname", fr = "Nom de la quête" },
        { ParameterType.Number,     en = "Waiting time", de = "Wartezeit", fr = "Temps d'attente" },
    },
}

function B_Trigger_OnQuestSuccessWait:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnQuestSuccessWait:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter
    elseif (_Index == 1) then
        self.WaitTime = (_Parameter ~= nil and tonumber(_Parameter)) or 0
    end
end

function B_Trigger_OnQuestSuccessWait:CustomFunction()
    if (GetQuestID(self.QuestName) ~= nil) then
        local QuestID = GetQuestID(self.QuestName)
        if (Quests[QuestID].Result == QuestResult.Success) then
            if self.WaitTime and self.WaitTime > 0 then
                self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
                if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                    return true;
                end
            else
                return true;
            end
        end
    end
    return false;
end

function B_Trigger_OnQuestSuccessWait:Debug(_Quest)
    if type(self.QuestName) ~= "string" then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": invalid quest name!");
        return true;
    elseif self.WaitTime and (type(self.WaitTime) ~= "number" or self.WaitTime < 0) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": waittime must be a number!");
        return true;
    end
    return false;
end

function B_Trigger_OnQuestSuccessWait:Interrupt(_Quest)
    self.WaitTimeTimer = nil;
end

function B_Trigger_OnQuestSuccessWait:Reset(_Quest)
    self.WaitTimeTimer = nil;
end

RegisterBehavior(B_Trigger_OnQuestSuccessWait);

-- -------------------------------------------------------------------------- --

-- Kompatibelitätsmodus
B_Trigger_OnQuestSuccess = CopyTable(B_Trigger_OnQuestSuccessWait);
B_Trigger_OnQuestSuccess.Name = "Trigger_OnQuestSuccess";
B_Trigger_OnQuestSuccess.Description.en = "Trigger: Starts the quest after another finished successfully.";
B_Trigger_OnQuestSuccess.Description.de = "Auslöser: Startet den Quest, wenn ein anderer erfolgreich abgeschlossen wurde.";
B_Trigger_OnQuestSuccess.Description.de = "Déclencheur: Démarre la quête lorsqu'une autre a été accomplie avec succès.";
B_Trigger_OnQuestSuccess.Parameter = {
    { ParameterType.QuestName,     en = "Quest name", de = "Questname", fr = "Nom de la quête" },
}

function B_Trigger_OnQuestSuccess:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.QuestName = _Parameter;
        self.WaitTime = 0;
    end
end

RegisterBehavior(B_Trigger_OnQuestSuccess);

-- -------------------------------------------------------------------------- --

function Trigger_CustomVariables(...)
    return B_Trigger_CustomVariables:new(...);
end

B_Trigger_CustomVariables = {
    Name = "Trigger_CustomVariables",
    Description = {
        en = "Trigger: if the variable has a certain value.",
        de = "Auslöser: wenn die Variable einen bestimmen Wert eingenommen hat.",
        fr = "Déclencheur: lorsque la variable a pris une valeur déterminée."
    },
    Parameter = {
        { ParameterType.Default, en = "Name of Variable",   de = "Variablennamen",  fr = "Noms de variables" },
        { ParameterType.Custom,  en = "Relation",           de = "Relation",        fr = "Relation" },
        { ParameterType.Default, en = "Value",              de = "Wert",            fr = "Valeur" }
    }
};

function B_Trigger_CustomVariables:GetTriggerTable()
    return { Triggers.Custom2, {self, self.CustomFunction} };
end

function B_Trigger_CustomVariables:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.VariableName = _Parameter
    elseif _Index == 1 then
        self.Relation = _Parameter
    elseif _Index == 2 then
        local value = tonumber(_Parameter);
        value = (value ~= nil and value) or _Parameter;
        self.Value = value
    end
end

function B_Trigger_CustomVariables:CustomFunction()
    local Value1 = ObtainCustomVariable("BehaviorVariable_" ..self.VariableName, 0);
    local Value2 = self.Value;
    if type(self.Value) == "string" then
        Value2 = ObtainCustomVariable("BehaviorVariable_" ..self.Value, 0);
    end

    if self.Relation == "==" then
        return Value1 == Value2;
    elseif self.Relation ~= "~=" then
        return Value1 ~= Value2;
    elseif self.Relation == ">" then
        return Value1 > Value2;
    elseif self.Relation == ">=" then
        return Value1 >= Value2;
    elseif self.Relation == "<=" then
        return Value1 <= Value2;
    else
        return Value1 < Value2;
    end
    return false;
end

function B_Trigger_CustomVariables:GetCustomData( _Index )
    if _Index == 1 then
        return {"==", "~=", "<=", "<", ">", ">="};
    end
end

function B_Trigger_CustomVariables:Debug(_Quest)
    local relations = {"==", "~=", "<=", "<", ">", ">="}
    local results    = {true, false, nil}

    if not ObtainCustomVariable("BehaviorVariable_" ..self.VariableName) then
        warn(false, _Quest.Identifier.. ": " ..self.Name..": variable '"..self.VariableName.."' do not exist!");
    end
    if not table.contains(relations, self.Relation) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": '"..self.Relation.."' is an invalid relation!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Trigger_CustomVariables)

-- -------------------------------------------------------------------------- --

function Trigger_AlwaysActive()
    return B_Trigger_AlwaysActive:new()
end

B_Trigger_AlwaysActive = {
    Name = "Trigger_AlwaysActive",
    Description = {
        en = "Trigger: the map has been started.",
        de = "Auslöser: Start der Karte.",
        fr = "Déclencheur: Démarrage de la carte.",
    },
}

function B_Trigger_AlwaysActive:GetTriggerTable()
    return {Triggers.Time, 0 }
end

RegisterBehavior(B_Trigger_AlwaysActive);

-- -------------------------------------------------------------------------- --

function Trigger_OnMonth(...)
    return B_Trigger_OnMonth:new(...);
end

B_Trigger_OnMonth = {
    Name = "Trigger_OnMonth",
    Description = {
        en = "Trigger: a specified month",
        de = "Auslöser: ein bestimmter Monat",
        fr = "Déclencheur: un mois donné"
    },
    Parameter = {
        { ParameterType.Custom, en = "Month", de = "Monat", fr = "Mois" },
    },
}

function B_Trigger_OnMonth:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnMonth:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Month = _Parameter * 1
    end
end

function B_Trigger_OnMonth:CustomFunction(_Quest)
    return self.Month == Logic.GetCurrentMonth()
end

function B_Trigger_OnMonth:GetCustomData( _Index )
    local Data = {}
    if _Index == 0 then
        for i = 1, 12 do
            table.insert( Data, i )
        end
    else
        assert( false )
    end
    return Data
end

function B_Trigger_OnMonth:Debug(_Quest)
    if self.Month < 1 or self.Month > 12 then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Month has the wrong value")
        return true
    end
    return false;
end

RegisterBehavior(B_Trigger_OnMonth);

-- -------------------------------------------------------------------------- --

function Trigger_OnMonsoon()
    return B_Trigger_OnMonsoon:new();
end

B_Trigger_OnMonsoon = {
    Name = "Trigger_OnMonsoon",
    Description = {
        en = "Trigger: on monsoon.",
        de = "Auslöser: wenn der Monsun beginnt.",
        fr = "Déclencheur: lorsque la mousson commence.",
    },
    RequiresExtraNo = 1,
}

function B_Trigger_OnMonsoon:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnMonsoon:CustomFunction(_Quest)
    if Logic.GetWeatherDoesShallowWaterFlood(0) then
        return true
    end
end

RegisterBehavior(B_Trigger_OnMonsoon);

-- -------------------------------------------------------------------------- --

function Trigger_Time(...)
    return B_Trigger_Time:new(...);
end

B_Trigger_Time = {
    Name = "Trigger_Time",
    Description = {
        en = "Trigger: a given amount of time since map start",
        de = "Auslöser: eine gewisse Anzahl Sekunden nach Spielbeginn",
        fr = "Déclencheur: un certain nombre de secondes après le début du jeu",
    },
    Parameter = {
        { ParameterType.Number, en = "Time (sec.)", de = "Zeit (Sek.)", fr = "Temps (sec.)" },
    },
}

function B_Trigger_Time:GetTriggerTable()
    return {Triggers.Time, self.Time }
end

function B_Trigger_Time:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Time = _Parameter * 1
    end
end

RegisterBehavior(B_Trigger_Time);

-- -------------------------------------------------------------------------- --

function Trigger_OnWaterFreezes()
    return B_Trigger_OnWaterFreezes:new();
end

B_Trigger_OnWaterFreezes = {
    Name = "Trigger_OnWaterFreezes",
    Description = {
        en = "Trigger: if the water starts freezing",
        de = "Auslöser: wenn die Gewässer gefrieren",
        fr = "Déclencheur: lorsque les eaux gèlent",
    },
}

function B_Trigger_OnWaterFreezes:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnWaterFreezes:CustomFunction(_Quest)
    if Logic.GetWeatherDoesWaterFreeze(0) then
        return true
    end
end

RegisterBehavior(B_Trigger_OnWaterFreezes);

-- -------------------------------------------------------------------------- --

function Trigger_NeverTriggered()
    return B_Trigger_NeverTriggered:new();
end

B_Trigger_NeverTriggered = {
    Name = "Trigger_NeverTriggered",
    Description = {
        en = "Trigger: Never triggers a Quest. The quest may be set active by Reward_QuestActivate or Reward_QuestRestartForceActive",
        de = "Auslöser: Löst nie eine Quest aus. Die Quest kann von Reward_QuestActivate oder Reward_QuestRestartForceActive aktiviert werden.",
        fr = "Déclencheur: Ne déclenche jamais de quête. La quête peut être activée par Reward_QuestActivate ou Reward_QuestRestartForceActive.",
    },
}

function B_Trigger_NeverTriggered:GetTriggerTable()

    return {Triggers.Custom2, {self, function() end} }

end

RegisterBehavior(B_Trigger_NeverTriggered)

-- -------------------------------------------------------------------------- --

function Trigger_OnAtLeastOneQuestFailure(...)
    return B_Trigger_OnAtLeastOneQuestFailure:new(...);
end

B_Trigger_OnAtLeastOneQuestFailure = {
    Name = "Trigger_OnAtLeastOneQuestFailure",
    Description = {
        en = "Trigger: if one or both of the given quests have failed.",
        de = "Auslöser: wenn einer oder beide der angegebenen Aufträge fehlgeschlagen sind.",
        fr = "Déclencheur: si l'une des quêtes indiquées ou les deux ont échoué.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name 1", de = "Questname 1", fr = "Nom de la quête 1" },
        { ParameterType.QuestName, en = "Quest Name 2", de = "Questname 2", fr = "Nom de la quête 2" },
    },
}

function B_Trigger_OnAtLeastOneQuestFailure:GetTriggerTable()
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_OnAtLeastOneQuestFailure:AddParameter(_Index, _Parameter)
    self.QuestTable = {};

    if (_Index == 0) then
        self.Quest1 = _Parameter;
    elseif (_Index == 1) then
        self.Quest2 = _Parameter;
    end
end

function B_Trigger_OnAtLeastOneQuestFailure:CustomFunction(_Quest)
    local Quest1 = Quests[GetQuestID(self.Quest1)];
    local Quest2 = Quests[GetQuestID(self.Quest2)];
    if (Quest1.State == QuestState.Over and Quest1.Result == QuestResult.Failure)
    or (Quest2.State == QuestState.Over and Quest2.Result == QuestResult.Failure) then
        return true;
    end
    return false;
end

function B_Trigger_OnAtLeastOneQuestFailure:Debug(_Quest)
    if self.Quest1 == self.Quest2 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": Both quests are identical!");
        return true;
    elseif not IsValidQuest(self.Quest1) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest1.."' does not exist!");
        return true;
    elseif not IsValidQuest(self.Quest2) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest2.."' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Trigger_OnAtLeastOneQuestFailure);

-- -------------------------------------------------------------------------- --

function Trigger_OnAtLeastOneQuestSuccess(...)
    return B_Trigger_OnAtLeastOneQuestSuccess:new(...);
end

B_Trigger_OnAtLeastOneQuestSuccess = {
    Name = "Trigger_OnAtLeastOneQuestSuccess",
    Description = {
        en = "Trigger: if one or both of the given quests are won.",
        de = "Auslöser: wenn einer oder beide der angegebenen Aufträge gewonnen wurden.",
        fr = "Déclencheur : si une ou les deux missions indiquées ont été gagnées.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name 1", de = "Questname 1", fr = "Nom de la quête 1" },
        { ParameterType.QuestName, en = "Quest Name 2", de = "Questname 2", fr = "Nom de la quête 2" },
    },
}

function B_Trigger_OnAtLeastOneQuestSuccess:GetTriggerTable()
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_OnAtLeastOneQuestSuccess:AddParameter(_Index, _Parameter)
    self.QuestTable = {};

    if (_Index == 0) then
        self.Quest1 = _Parameter;
    elseif (_Index == 1) then
        self.Quest2 = _Parameter;
    end
end

function B_Trigger_OnAtLeastOneQuestSuccess:CustomFunction(_Quest)
    local Quest1 = Quests[GetQuestID(self.Quest1)];
    local Quest2 = Quests[GetQuestID(self.Quest2)];
    if (Quest1.State == QuestState.Over and Quest1.Result == QuestResult.Success)
    or (Quest2.State == QuestState.Over and Quest2.Result == QuestResult.Success) then
        return true;
    end
    return false;
end

function B_Trigger_OnAtLeastOneQuestSuccess:Debug(_Quest)
    if self.Quest1 == self.Quest2 then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": Both quests are identical!");
        return true;
    elseif not IsValidQuest(self.Quest1) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest1.."' does not exist!");
        return true;
    elseif not IsValidQuest(self.Quest2) then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest2.."' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Trigger_OnAtLeastOneQuestSuccess);

-- -------------------------------------------------------------------------- --

function Trigger_MapScriptFunction(...)
    return B_Trigger_MapScriptFunction:new(...);
end

B_Trigger_MapScriptFunction = {
    Name = "Trigger_MapScriptFunction",
    Description = {
        en = "Trigger: Calls a function within the global map script. If the function returns true the quest will be started",
        de = "Auslöser: Ruft eine Funktion im globalen Skript auf. Wenn sie true sendet, wird die Quest gestartet.",
        fr = "Déclencheur: Appelle une fonction dans le script global. Si elle envoie true, la quête est lancée.",
    },
    Parameter = {
        { ParameterType.Default, en = "Function name", de = "Funktionsname", fr = "Nom de la fonction" },
    },
}

function B_Trigger_MapScriptFunction:GetTriggerTable(_Quest)
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_MapScriptFunction:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.FuncName = _Parameter
    end
end

function B_Trigger_MapScriptFunction:CustomFunction(_Quest)
    if type(self.FuncName) == "function" then
        return self.FuncName(unpack(self.i47ya_6aghw_frxil));
    end
    return _G[self.FuncName](self, _Quest);
end

function B_Trigger_MapScriptFunction:Debug(_Quest)
    if not self.FuncName then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": function reference is invalid!");
        return true;
    end
    if type(self.FuncName) ~= "function" and not _G[self.FuncName] then
        debug(false, _Quest.Identifier.. ": " ..self.Name..": function does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Trigger_MapScriptFunction);

-- -------------------------------------------------------------------------- --

function Trigger_OnEffectDestroyed(...)
    return B_Trigger_OnEffectDestroyed:new(...);
end

B_Trigger_OnEffectDestroyed = {
    Name = "Trigger_OnEffectDestroyed",
    Description = {
        en = "Trigger: Starts a quest after an effect was destroyed",
        de = "Auslöser: Startet eine Quest, nachdem ein Effekt zerstoert wurde",
        fr = "Déclencheur: Démarre une quête après la destruction d'un effet.",
    },
    Parameter = {
        { ParameterType.Default, en = "Effect name", de = "Effektname", fr = "Nom de l'effet" },
    },
}

function B_Trigger_OnEffectDestroyed:GetTriggerTable()
    return { Triggers.Custom2, {self, self.CustomFunction} }
end

function B_Trigger_OnEffectDestroyed:AddParameter(_Index, _Parameter)
    if _Index == 0 then
        self.EffectName = _Parameter
    end
end

function B_Trigger_OnEffectDestroyed:CustomFunction()
    return not CONST_EFFECT_NAME_TO_ID[self.EffectName] or not Logic.IsEffectRegistered(CONST_EFFECT_NAME_TO_ID[self.EffectName]);
end

function B_Trigger_OnEffectDestroyed:Debug(_Quest)
    if not CONST_EFFECT_NAME_TO_ID[self.EffectName] then
        debug(false, _Quest.Identifier.. ": " ..self.Name .. ": Effect has never existed")
        return true
    end
end
RegisterBehavior(B_Trigger_OnEffectDestroyed)

-- -------------------------------------------------------------------------- --

