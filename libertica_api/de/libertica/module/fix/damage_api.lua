--- Ermöglicht die Veränderung der Schadenswerte von Einheiten.
---
--- <b>Achtung</b>: Die Funktionen `MakeVulnerable` und `MakeInvulnerable`
--- wurden überschrieben. Die Funktion `Logic.SetEntityInvulnerabilityFlag`
--- wird stattdessen intern benutzt und darf nicht mehr verwendet werden!
---
--- #### Funktionen:
--- <li>Besseres Balancing für Bogenschützen</li>
--- <li>Nahe Mauerkatapulte schwächen sich gegenseitig (gilt nicht für KI)</li>
--- <li>Anpassen der Kampfkraft von Einheiten über Lua</li>
--- <li>Zusätzliche Rüstung für Einheiten vergeben</li>
--- <li>Anpassen des Own Territoy Bonus</li>
--- <li>Anpassen des Height Modifier</li>
---
--- <b>Achtung</b>: Diese Funktionen werden sofort aktiv, wenn das Modul
--- geladen wird!
---



--- Setzt den Schaden für einen Entitätstypen.
---
--- Optional können Feindkategorien angegeben werden, für die der Schaden gilt.
---
--- Der angegebene Schaden zu einer Liste von Kategorien ersetzt den Basischaden
--- des Entitätstypen. Der finale Schaden Ergibt sich aus Moral, Höhenbonus und 
--- Territorienbonus.
---
--- @param _Type integer Entitätstyp
--- @param _Damage integer Höhe des Schaden
--- @param ... integer? Optionale Feindkategorien
function SetEntityTypeDamage(_Type, _Damage, ...)
end
API.SetEntityTypeDamage = SetEntityTypeDamage;

--- Setzt den Schaden für eine benannte Entität.
---
--- Optional können Feindkategorien angegeben werden, für die der Schaden gilt.
---
--- Der angegebene Schaden zu einer Liste von Kategorien ersetzt den Basischaden
--- der Entität. Der finale Schaden Ergibt sich aus Moral, Höhenbonus und
--- Territorienbonus.
---
--- @param _Name string Scriptname der Entität
--- @param _Damage integer Höhe des Schaden
--- @param ... integer? Optionale Feindkategorien
function SetEntityNameDamage(_Name, _Damage, ...)
end
API.SetEntityNameDamage = SetEntityNameDamage;

--- Setzt Die Rüstung für einen Entitätstypen.
---
--- Der Rüstungswert wird nach der eigentlichen Schadensberechnung vom übrigen
--- Schaden abgezogen. Der Schaden kann niemals kleiner als 1 werden.
---
--- @param _Type integer Entitätstyp
--- @param _Armor integer Stärke der Rüstung
function SetEntityTypeArmor(_Type, _Armor)
end
API.SetEntityTypeArmor = SetEntityTypeArmor;

--- Setzt die Rüstung für eine benannte Entität.
---
--- Der Rüstungswert wird nach der eigentlichen Schadensberechnung vom übrigen
--- Schaden abgezogen. Der Schaden kann niemals kleiner als 1 werden.
---
--- @param _Name string Scriptname der Entität
--- @param _Armor integer Stärke der Rüstung
function SetEntityNameArmor(_Name, _Armor)
end
API.SetEntityNameArmor = SetEntityNameArmor;

--- Setzt den Bonusfaktor für den Schaden bei Kämpfen auf eigenem Gebiet.
---
--- Der angegebene Faktor wird mit dem eigentlichen Faktor multipliziert. Für
--- 0.5 bedeutet dies, der Territorienbonus wird halbiert. Bei der Berechnung
--- wird der Territorienbonus zur Moral dazu addiert.
---
--- @param _PlayerID integer ID des Spielers
--- @param _Bonus number Faktor
function SetTerritoryBonus(_PlayerID, _Bonus)
end
API.SetTerritoryBonus = SetTerritoryBonus;

--- Setzt den Bonusfaktor für den Schaden bei Kämpfen von erhöhter Position.
---
--- Der angegebene Faktor wird mit dem eigentlichen Faktor multipliziert. Für
--- 0.5 bedeutet dies, der Höhenbonus wird halbiert. Bei der Berechnung wird
--- die Summe von Moral und Territorienbonus mit dem Höhenbonus multipliziert.
---
--- @param _PlayerID integer ID des Spielers
--- @param _Bonus number Faktor
function SetHeightModifier(_PlayerID, _Bonus)
end
API.SetHeightModifier = SetHeightModifier;

--- Prüft, ob die Entität unverwundbar ist.
--- @param _Entity any Skriptname oder Entität-ID
--- @return boolean Invulnerable Entität ist unverwundbar
function IsInvulnerable(_Entity)
    return true;
end
API.IsInvulnerable = IsInvulnerable;

