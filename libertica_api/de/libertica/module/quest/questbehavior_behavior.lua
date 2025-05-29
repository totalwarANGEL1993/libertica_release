--- Fügt einige weitere Standard-Behavior hinzu.

--- Eine Entität muss zu einer Position bewegt werden.
--- @param _ScriptName string Skriptname der Entität
--- @param _Target string Skriptname des Ziel
--- @param _Distance integer Entfernung
--- @param _UseMarker boolean Marker anzeigen
function Goal_MoveToPosition(_ScriptName, _Target, _Distance, _UseMarker)
end

--- Eine Kriegsmaschine muss eine bestimmte Menge Munition haben.
--- @param _ScriptName string Skriptname der Entität
--- @param _Relation string Relationszeichen
--- @param _Amount integer Menge
function Goal_AmmunitionAmount(_ScriptName, _Relation, _Amount)
end

--- Es muss ein bestimmter Ruf der Stadt erreicht werden.
--- @param _Reputation integer 
function Goal_CityReputation(_Reputation)
end

--- Gespawnte Feinde oder Raubtiere müssen beseitigt werden.
--- @param _SpawnPoint string Skriptname des Spawnpoint
--- @param _Amount integer Menge
--- @param _Prefixed boolean Skriptname ist Prefix
function Goal_DestroySpawnedEntities(_SpawnPoint, _Amount, _Prefixed)
end

--- Es muss eine bestimmte Menge Gold durch Diebstahl verdient werden.
--- @param _Amount integer Menge
--- @param _PlayerID integer Zu bestehlender Spieler (-1 = alle)
--- @param _CheatEarnings boolean Einnahmen generieren
--- @param _ShowProgress boolean Fortschritt anzeigen
function Goal_StealGold(_Amount, _PlayerID, _CheatEarnings, _ShowProgress)
end

--- Ein Gebäude muss von einem Dieb bestohlen werden. Dazu muss der Dieb die
--- Einnahmen erst zurückbringen.
--- @param _ScriptName string Skriptname der Entität
--- @param _CheatEarnings boolean Einnahmen generieren
function Goal_StealFromBuilding(_ScriptName, _CheatEarnings)
end

--- Ein Gebäude muss mit einem Dieb infiltirert werden. Sobald der Dieb das
--- Gebäude betritt, ist das Ziel erreicht.
--- @param _ScriptName string Skriptname der Entität
--- @param _CheatEarnings boolean Einnahmen generieren
--- @param _DeleteThief boolean Dieb löschen
function Goal_SpyOnBuilding(_ScriptName, _CheatEarnings, _DeleteThief)
end

--- Ein Spieler muss Soldaten eines anderen Spielers besiegen.
--- @param _AttackerPlayerID integer Angreifender Spieler
--- @param _AttackedPlayerID integer Angegriffener Spieler
--- @param _Amount integer Menge
function Goal_DestroySoldiers(_AttackerPlayerID, _AttackedPlayerID, _Amount)
end

--- Versetzt die Entität auf die Position einer anderen.
--- @param _ScriptName string Skriptname der Entität
--- @param _Target string Skriptname des Ziel
--- @param _LookAt boolean Ziel anschauen
--- @param _Distance integer Entfernung
function Reprisal_SetPosition(_ScriptName, _Target, _LookAt, _Distance)
end

--- Ändert den Besitzer der Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _PlayerID integer ID des Spielers
function Reprisal_ChangePlayer(_ScriptName, _PlayerID)
end

--- Ändert die Sichtbarkeit der Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _Visible boolean Ist sichtbar
function Reprisal_SetVisible(_ScriptName, _Visible)
end

--- Andert den Verwundbarkeitsstatus der Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _Vulnerable boolean Ist verwundbar
function Reprisal_SetVulnerability(_ScriptName, _Vulnerable)
end

--- Ändert das Model der Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _Model string Name des Model
function Reprisal_SetModel(_ScriptName, _Model)
end

--- Versetzt eine Entität auf die Position einer anderen.
--- @param _ScriptName string Skriptname der Entität
--- @param _Target string Skriptname des Ziel
--- @param _LookAt boolean Ziel anschauen
--- @param _Distance integer Entfernung
function Reward_SetPosition(_ScriptName, _Target, _LookAt, _Distance)
end

--- Ändert den Besitzer einer Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _PlayerID integer ID des Spielers
function Reward_ChangePlayer(_ScriptName, _PlayerID)
end

--- Bewegt eine Entität zu einer anderen.
--- @param _ScriptName string Skriptname der Entität
--- @param _Destination string Skriptname des Ziel
--- @param _Distance integer Entfernung
--- @param _Angle integer Winkel
function Reward_MoveToPosition(_ScriptName, _Destination, _Distance, _Angle)
end

--- Lässt den Empfänger das Spiel gewinnen und Erzeugt eine Siegesfeier auf 
--- dem Marktplatz.
function Reward_VictoryWithParty()
end

--- Andert die Sichtbarkeit der Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _Visible boolean Ist sichtbar
function Reward_SetVisible(_ScriptName, _Visible)
end

--- Andert den Verwundbarkeitsstatus der Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _Vulnerable boolean Ist verwundbar
function Reward_SetVulnerability(_ScriptName, _Vulnerable)
end

--- Ändert das Model der Entität.
--- @param _ScriptName string Skriptname der Entität
--- @param _Model string Name des Model
function Reward_SetModel(_ScriptName, _Model)
end

--- Setzt, ob die Entität von der KI kontrolliert wird.
--- @param _ScriptName string Skriptname der Entität
--- @param _Controlled boolean Entität wird kontrolliert
function Reward_AI_SetEntityControlled(_ScriptName, _Controlled)
end

--- Löst den Auftrag aus, sobald die Munition aufgebraucht ist.
--- @param _ScriptName string Skriptname der Entität
function Trigger_AmmunitionDepleted(_ScriptName)
end

