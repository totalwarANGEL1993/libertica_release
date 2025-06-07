--- Ein System, dass es ermöglicht, Arbeiter für den Kriegsdienst einzuziehen.
--- 
--- #### Milizen einziehen
--- 
--- Milizen werden aus der Bevölkerung rekrutiert. Damit Arbeiter als Rekruten
--- verfügbar werden, muss ihr Gebäude angehalten werden. Die Arbeiter werden 
--- zu Soldaten.
--- 
--- Wird die Einheit entlassen, kehren die Arbeiter zu ihrem Gebäude zurück.
--- 
--- Werden Soldaten getötet, kommt ein neuer Arbeiter in die Siedlung. Ist der
--- Rekrut verheiratet gewesen, verlässt die Ehefrau die Stadt.
--- 
--- #### Spezialfähigkeiten
--- 
--- Für Milizeinheiten können Spezialfähigkeiten zugeschaltet werden. Jeder
--- Typ hat andere Spezialeinheiten. Sie werden im Tooltip angezeigt. Zudem
--- ändert sich die Farbe des Icons, um Militionäre mit Spezialfähigkeiten
--- von normalen Söldnern zu unterscheiden.



--- Aktiviert die Rekrutierung von Milizen.
function ActivateMilitia()
end
API.ActivateMilitia = ActivateMilitia;

--- Deaktiviert die Rekrutierung von Milizen.
function DeactivateMilitia()
end
API.DeactivateMilitia = DeactivateMilitia;

--- Fügt den Milizeinheiten Spezialfähigkeiten hinzu.
--- 
--- Sind Spezialfähigkeiten aktiv, werden die Icons der Milizen eingefärbt und
--- die Fähigkeit wird im Tooltip angezeigt.
function ActivateMilitiaSkills()
end
API.ActivateMilitiaSkills = ActivateMilitiaSkills;

--- Entfernt die Spezialfähigkeiten der Milizeinheiten.
function DeactivateMilitiaSkills()
end
API.DeactivateMilitiaSkills = DeactivateMilitiaSkills;

--- Setzt die zur Klimazone passenden Einheitentypen für den Spieler.
--- @param _PlayerID integer ID des Spielers
function UseDefaultMilitiaTypes(_PlayerID)
end
API.UseDefaultMilitiaTypes = UseDefaultMilitiaTypes;

--- Setzt die zur Klimazone passenden Einheitentypen für alle Spieler.
function UseDefaultMilitiaTypesForAllPlayers()
end
API.UseDefaultMilitiaTypesForAllPlayers = UseDefaultMilitiaTypesForAllPlayers;

--- Setzt neue zufällige Einheitentypen für den Spieler.
--- @param _PlayerID integer ID des Spielers
function UseRandomMilitiaTypes(_PlayerID)
end
API.UseRandomMilitiaTypes = UseRandomMilitiaTypes;

--- Setzt neue zufällige Einheitentypen für alle Spieler.
function UseRandomMilitiaTypesForAllPlayers()
end
API.UseRandomMilitiaTypesForAllPlayers = UseRandomMilitiaTypesForAllPlayers;

--- Erlaubt nur inaktive Arbeiter zum Kriegstdiens einzuziehen.
function UseOnlyIdlingWorkersForMilitia()
end
API.UseOnlyIdlingWorkersForMilitia = UseOnlyIdlingWorkersForMilitia;

--- Erlaubt Arbeiter immer zum Kriegsdienst einzuziehen.
function UseAllWorkersForMilitia()
end
API.UseAllWorkersForMilitia = UseAllWorkersForMilitia;

--- Setzt den benötigten Titel für Nahkampfmilizen.
--- @param _Title integer Benötigter Titel
function RequireTitleForMeleeMilitia(_Title)
end
API.RequireTitleForMeleeMilitia = RequireTitleForMeleeMilitia;

--- Setzt den benötigten Titel für Fernkampfmilizen.
--- @param _Title integer Benötigter Titel
function RequireTitleForRangedMilitia(_Title)
end
API.RequireTitleForRangedMilitia = RequireTitleForRangedMilitia;

