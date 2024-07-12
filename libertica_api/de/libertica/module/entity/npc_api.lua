--- Ermöglicht es, Siedler wie interaktive Objekte zu verwenden.
---
--- NPCs sind Charaktere, die vom Spieler mit einem Helden aktiviert werden und 
--- daher mit ihnen sprechen. Ganz wie interaktive Objekte kann eine Aktion 
--- aufgerufen werden und einige andere Anpassungen können vorgenommen werden.
---
--- #### Reports
--- * `Report.NpcInteraction` - Jemand spricht mit einem NPC.
---
Lib.NPC = Lib.NPC or {};



--- Fügt einer Entität einen NPC hinzu.
---
--- #### Felder der Tabelle
--- * Name              Skriptname der Entität (obligatorisch)
--- * Active            NPC ist aktiv
--- * Callback          Funktion, die bei der Aktivierung aufgerufen wird
--- * Condition         Bedingung, die vor der Aktivierung überprüft wird
--- * Type              Typ des NPCs (1, 2, 3, 4)
--- * Player            Spieler, die sprechen dürfen
--- * WrongPlayerAction Nachricht für falsche Spieler
--- * Hero              Name eines bestimmten Helden
--- * WrongHeroAction   Nachricht für falsche Helden
--- * Follow            NPC folgt Helden
--- * FollowHero        NPC folgt diesem speziellen helden
--- * FollowCallback    Funktion, die bei Erreichen des Ziels aufgerufen wird
--- * FollowDestination Ort, zu dem der NPC folgt
--- * FollowDistance    max. Entfernung bei der ein NPC folgt (Default: 2000)
--- * FollowArriveArea  min. Entfernung zum Zielort (Default: 500)
--- * FollowSpeed       Bewegungsgeschwindigkeit (Default: 1.0)
--- * Arrived           NPC hat Position erreicht
---
--- #### Beispiele
--- ```lua
--- -- Beispiel #1: Erstellt einen einfachen NPC
--- MyNpc = NpcCompose {
---     Name     = "HansWurst",
---     Callback = function(_Data)
---         local HeroID = CONST_LAST_HERO_INTERACTED;
---         local NpcID = GetID(_Data.Name);
---     end
--- }
--- ```
---
--- ```lua
--- -- Beispiel #2: Erstellt einen NPC mit Bedingungen
--- MyNpc = NpcCompose {
---     Name      = "HansWurst",
---     Condition = function(_Data)
---         local NpcID = GetID(_Data.Name);
---         -- prüfe irgend etwas
---         return MyConditon == true;
---     end
---     Callback  = function(_Data)
---         local HeroID = CONST_LAST_HERO_INTERACTED;
---         local NpcID = GetID(_Data.Name);
---     end
--- }
---```
---
--- ```lua
--- -- Beispiel #3: Begrenzt Spieler für die Aktivierung
--- MyNpc = NpcCompose {
---     Name              = "HansWurst",
---     Player            = {1, 2},
---     WrongPlayerAction = function(_Data)
---         AddNote("Ich werde nicht mit dir sprechen!");
---     end,
---     Callback          = function(_Data)
---         local HeroID = CONST_LAST_HERO_INTERACTED;
---         local NpcID = GetID(_Data.Name);
---     end
--- }
---```
---
--- @param _Data table NPC-Daten
--- @return table NPC NPC-Daten
function NpcCompose(_Data)
    return {};
end
API.NpcCompose = NpcCompose;

--- Entfernt den NPC, löscht aber nicht die Entität.
--- @param _Data table NPC-Daten
function NpcDispose(_Data)
end
API.NpcDispose = NpcDispose;

--- Aktualisiert den NPC mit der Datentabelle.
---
--- #### Felder der Tabelle
--- * Name              Skriptname der Entität (obligatorisch)
--- * Callback          Funktion, die bei der Aktivierung aufgerufen wird
--- * Condition         Bedingung, die vor der Aktivierung überprüft wird
--- * Type              Typ des NPCs (1, 2, 3, 4)
--- * Player            Spieler, die sprechen dürfen
--- * WrongPlayerAction Nachricht für falsche Spieler
--- * Hero              Name eines bestimmten Helden
--- * WrongHeroAction   Nachricht für falsche Helden
--- * Active            NPC ist aktiv
---
--- #### Beispiele
--- ```lua
--- -- Beispiel #1: Setzt NPC zurück und ändert Aktion
--- MyNpc.Active = true;
--- MyNpc.TalkedTo = 0;
--- MyNpc.Callback = function(_Data)
---     -- mach was hier
--- end;
--- NpcUpdate(MyNpc);
--- ```
---
--- @param _Data table NPC-Daten
function NpcUpdate(_Data)
end
API.NpcUpdate = NpcUpdate;

--- Überprüft, ob der NPC aktiv ist.
--- @param _Data table NPC-Daten
--- @return boolean Active NPC ist aktiv
function NpcIsActive(_Data)
    return false;
end
API.NpcIsActive = NpcIsActive;

--- Gibt zurück, ob ein NPC gesprochen hat.
--- @param _Data table NPC-Daten
--- @param _Hero string Skriptname des Helden
--- @param _PlayerID integer ID des Spielers
--- @return boolean HasTalked NPC hat gesprochen
function NpcTalkedTo(_Data, _Hero, _PlayerID)
    return true;
end
API.NpcTalkedTo = NpcTalkedTo;

--- Gibt zurück, ob ein NPC das Ziel erreicht hat.
--- @param _Data table NPC-Daten
--- @return boolean HasArrived NPC ist eingetroffen
function NpcHasArrived(_Data)
    return false;
end



--- Jemand spricht mit einem NPC.
---
--- #### Parameter
--- * `NpcEntityID`  - ID des NPCs
--- * `HeroEntityID` - ID des Helden
Report.NpcInteraction = anyInteger;

