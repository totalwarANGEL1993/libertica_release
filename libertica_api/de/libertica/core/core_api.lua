--- Die Funktionalotäten des Basis-Modul.
--- 
--- #### Scripting Values:
--- * `CONST_SCRIPTING_VALUES.Destination.X`: <b>integer</b> X-Koordinate des Bewegungsziels
--- * `CONST_SCRIPTING_VALUES.Destination.Y`: <b>integer</b> Y-Koordinate des Bewegungsziels
--- * `CONST_SCRIPTING_VALUES.Health`: <b>integer</b> Gesundheit der Entität
--- * `CONST_SCRIPTING_VALUES.Player`: <b>integer</b> Spieler-ID der Entität
--- * `CONST_SCRIPTING_VALUES.Size`: <b>integer</b> Skalierung der Entität
--- * `CONST_SCRIPTING_VALUES.Visible`: <b>integer</b> Ist die Entität sichtbar (= 801280)
--- * `CONST_SCRIPTING_VALUES.NPC`: <b>integer</b> Art des NPCs (> 0)
--- 
--- #### Console Commands:
--- In der Konsole können spezielle Komandos eingegeben werden. Eingeklammerte
--- Angaben sind dabei optional.
--- * `restartmap`:        Startet die Map sofort neu
--- * `clear`:             Entfernt alle Nachrichten vom Bildschirm
--- * `version`:           Zeigt die aktuelle Version von Libertica an
--- * `&gt; any code`:     Führt beliebigen Code in der globalen Umgebung aus
--- * `&gt;&gt; any code`: Führt beliebigen Code in der lokalen Umgebung aus
--- * `&lt; path`:         Läd ein Lua-File in die globale Umgebung
--- * `&lt;&lt; path`:     Läd ein Lua-File in die lokale Umgebung

--- Öffnet die Chat-Konsole.
--- 
--- @param _PlayerID number    ID des Spielers
--- @param _AllowDebug boolean Debug-Codes erlaubt
function ShowTextInput(_PlayerID, _AllowDebug)
end
API.ShowTextInput = ShowTextInput;

--- Aktiviert den Debug-Modus des Spiels.
--- @param _DisplayScriptErrors boolean Fehlermeldungen anzeigen
--- @param _CheckAtRun boolean          Benutzerdefiniertes Verhalten überprüfen an/aus
--- @param _DevelopingCheats boolean    Cheats an/aus
--- @param _DevelopingShell boolean     Eingabebefehle an/aus
--- @param _TraceQuests boolean         Quests verfolgen an/aus
function ActivateDebugMode(_DisplayScriptErrors, _CheckAtRun, _DevelopingCheats, _DevelopingShell, _TraceQuests)
end
API.ActivateDebugMode = ActivateDebugMode;

--- Fordert einen Job des übergebenen Ereignistyps an.
--- @param _EventType integer Typ des Jobs
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestJobByEventType(_EventType, _Function, ...)
    return 0;
end
API.RequestJobByEventType = RequestJobByEventType;
API.StartJobByEventType = RequestJobByEventType;

--- Fordert einen Job an, der jede Sekunde ausgelöst wird.
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestJob(_Function, ...)
    return 0;
end
API.RequestJob = RequestJob;
API.StartJob = RequestJob;
StartSimpleJob = RequestJob;
StartSimpleJobEx = RequestJob;

--- Fordert einen Job an, der jede Runde ausgelöst wird.
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestHiResJob(_Function, ...)
    return 0;
end
API.RequestHiResJob = RequestHiResJob;
API.StartHiResJob = RequestHiResJob;
StartSimpleHiResJob = RequestHiResJob;
StartSimpleHiResJobEx = RequestHiResJob;

--- Fordert eine verzögerte Aktion an, verzögert um Sekunden.
--- @param _Waittime integer Sekunden
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestDelay(_Waittime, _Function, ...)
    return 0;
end
API.RequestDelay = RequestDelay;
API.StartDelay = RequestDelay;

--- Fordert eine verzögerte Aktion an, verzögert um Runden.
--- @param _Waittime integer Runden
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestHiResDelay(_Waittime, _Function, ...)
    return 0;
end
API.RequestHiResDelay = RequestHiResDelay;
API.StartHiResDelay = RequestHiResDelay;

--- Fordert eine verzögerte Aktion an, verzögert um Echtzeit-Sekunden.
--- @param _Waittime integer Sekunden
--- @param _Function any Funktionsreferenz oder -name
--- @param ... unknown Parameter
--- @return integer ID ID des Jobs
function RequestRealTimeDelay(_Waittime, _Function, ...)
    return 0;
end
API.RequestRealTimeDelay = RequestRealTimeDelay;
API.StartRealTimeDelay = RequestRealTimeDelay;

--- Beendet einen Job. Der Job kann nicht reaktiviert werden.
--- @param _JobID integer ID des Jobs
function StopJob(_JobID)
end
API.StopJob = StopJob;
API.EndJob = StopJob;

--- Gibt zurück, ob der Job ausgeführt wird.
--- @param _JobID integer ID des Jobs
--- @return boolean Running Job wird ausgeführt
function IsJobRunning(_JobID)
    return true;
end
API.IsJobRunning = IsJobRunning;
API.JobIsRunning = IsJobRunning;

--- Setzt einen pausierten Job fort.
--- @param _JobID integer ID des Jobs
function ResumeJob(_JobID)
end
API.ResumeJob = ResumeJob;

--- Pausiert einen laufenden Job.
--- @param _JobID integer ID des Jobs
function YieldJob(_JobID)
end
API.YieldJob = YieldJob;

--- Gibt die seit dem Spielstart vergangenen Echtzeit-Sekunden zurück.
--- @return integer Sekunden Anzahl der Sekunden
function GetSecondsRealTime()
    return 0;
end
API.RealTimeGetSecondsPassedSinceGameStart = GetSecondsRealTime;
API.GetSecondsRealTime = GetSecondsRealTime;

--- Erlaubt es Namen, Farben und Portraits von Spielern anzupassen.
---
--- Folgende Dinge können angepasst werden:
--- <li>Spielerfarbe</li>
--- <li>Spielername</li>
--- <li>Spielerporträt</li>
--- <li>Territoriumsname</li>

--- Gibt den Namen des Gebiets zurück.
--- @param _TerritoryID number ID des Gebiets
--- @return string Name Name des Gebiets
function GetTerritoryName(_TerritoryID)
    return "";
end
API.GetTerritoryName = GetTerritoryName;

--- Gibt den Namen des Spielers zurück.
--- @param _PlayerID number ID des Spielers
--- @return string Name Name des Spielers
function GetPlayerName(_PlayerID)
    return "";
end
API.GetPlayerName = GetPlayerName;

--- Ändert den Namen eines Spielers.
---@param _PlayerID number ID des Spielers
---@param _Name string Spielername
function SetPlayerName(_PlayerID, _Name)
end
API.SetPlayerName = SetPlayerName;

--- Ändert die Farbe eines Spielers.
--- @param _PlayerID number ID des Spielers
--- @param _Color any Name oder ID der Farbe
--- @param _Logo? number ID des Logos
--- @param _Pattern? number ID des Musters
function SetPlayerColor(_PlayerID, _Color, _Logo, _Pattern)
end
API.SetPlayerColor = SetPlayerColor;

--- Ändert das Porträt eines Spielers.
---
--- #### Example:
--- ```lua
--- -- Beispiel #1: Modell nach Spielerheld setzen
--- SetPlayerPortrait(2);
--- -- Beispiel #2: Modell nach Art der Entität setzen
--- SetPlayerPortrait(2, "amma");
--- -- Beispiel #3: Modellname direkt setzen
--- SetPlayerPortrait(2, "H_NPC_Monk_AS");
--- ```
--- 
--- @param _PlayerID number  ID des Spielers
--- @param _Portrait? string Name des Modells
function SetPlayerPortrait(_PlayerID, _Portrait)
end
API.SetPlayerPortrait = SetPlayerPortrait;

--- Setzt die Menge an Ressourcen in einer Mine und optional die Auffüllmenge.
--- @param _Entity any Entität, die geändert werden soll
--- @param _StartAmount integer Anfangsmenge
--- @param _RefillAmount integer? (optional) Auffüllmenge
function SetResourceAmount(_Entity, _StartAmount, _RefillAmount)
end

--- Ändert die angezeigte Beschreibung eines benutzerdefinierten Verhaltens.
--- @param _QuestName string Name des Quests
--- @param _Text string Quest-Text
function SetCustomBehaviorText(_QuestName, _Text)
end
API.SetCustomBehaviorText = SetCustomBehaviorText;

--- Startet einen Quest neu.
---
--- Quests müssen beendet sein, um erneut gestartet zu werden. Entweder müssen alle Trigger erfolgreich sein
--- oder der Quest muss manuell ausgelöst werden.
--- @param _QuestName string Name des Quests
--- @param _NoMessage boolean Debug-Nachricht deaktivieren
--- @return integer ID Neue Quest-ID
--- @return table Data Quest-Instanz
function RestartQuest(_QuestName, _NoMessage)
    return 0, {};
end
API.RestartQuest = RestartQuest;

--- Scheitert an einem Quest.
--- @param _QuestName string Name des Quests
--- @param _NoMessage boolean Debug-Nachricht deaktivieren
function FailQuest(_QuestName, _NoMessage)
end
API.FailQuest = FailQuest;

--- Startet einen Quest.
--- @param _QuestName string Name des Quests
--- @param _NoMessage boolean Debug-Nachricht deaktivieren
function StartQuest(_QuestName, _NoMessage)
end
API.StartQuest = StartQuest;

--- Unterbricht einen Quest.
--- @param _QuestName string Name des Quests
--- @param _NoMessage boolean Debug-Nachricht deaktivieren
function StopQuest(_QuestName, _NoMessage)
end
API.StopQuest = StopQuest;

--- Gewinnt einen Quest.
--- @param _QuestName string Name des Quests
--- @param _NoMessage boolean Debug-Nachricht deaktivieren
function WinQuest(_QuestName, _NoMessage)
end
API.WinQuest = WinQuest;

--- Erstellt einen neuen Berichtstyp.
--- @param _Name string Name des Berichts
--- @return integer
function CreateReport(_Name)
    return 0;
end
API.CreateScriptEvent = CreateReport;

--- Sendet einen Bericht mit optionalen Parametern.
--- @param _ID integer Berichts-ID
--- @param ... unknown Parameter
function SendReport(_ID, ...)
end
API.SendScriptEvent = SendReport;

--- Gibt den Spieler zurück, der den aktuellen Report gesendet hat.
--- 
--- Wird diese Funktion außerhalb der Behandlung eines Reports aufgerufen oder
--- tritt ein anderer Fehler auf, wird 0 zurückgegeben.
--- 
--- @return integer PlayerID ID des Ursprungsspielers
function GetReportSender()
    return 0;
end
API.GetReportSender = GetReportSender;
API.GetReportSourcePlayerID = GetReportSender;

--- Sendet einen Bericht mit optionalen Parametern an das globale Skript.
---
--- Dies wird immer eine Broadcast sein!
--- @param _ID integer Berichts-ID
--- @param ... unknown Parameter
function SendReportToGlobal(_ID, ...)
end
API.SendScriptEventToGlobal = SendReportToGlobal;

--- Sendet einen Bericht mit optionalen Parametern an das lokale Skript.
--- @param _ID integer Berichts-ID
--- @param ... unknown Parameter
function SendReportToLocal(_ID, ...)
end
API.SendScriptEventToLocal = SendReportToLocal;

--- Erstellt einen Berichtslistener für den Berichtstyp.
--- @param _EventID integer ID des Berichts
--- @param _Function function Listener-Funktion
--- @return integer
function CreateReportReceiver(_EventID, _Function)
    return 0;
end
API.CreateReportReceiver = CreateReportReceiver;

--- Löscht einen Berichtslistener für den Berichtstyp.
--- @param _EventID integer ID des Berichts
--- @param _ID integer ID des Listeners
function RemoveReportReceiver(_EventID, _ID)
end
API.RemoveReportReceiver = RemoveReportReceiver;

--- Deaktiviert das Autospeichern der History Edition.
--- @param _Flag boolean Autospeichern ist deaktiviert
function DisableAutoSave(_Flag)
end
API.DisableAutoSave = DisableAutoSave;

--- Deaktiviert das Speichern des Spiels.
--- @param _Flag boolean Speichern ist deaktiviert
function DisableSaving(_Flag)
end
API.DisableSaving = DisableSaving;

--- Deaktiviert das Laden von Spielständen.
--- @param _Flag boolean Laden ist deaktiviert
function DisableLoading(_Flag)
end
API.DisableLoading = DisableLoading;

--- Gibt das aktuelle Bewegungsziel der Entität zurück.
--- @param _Entity any ID oder Skriptname
--- @return table Position Bewegungsziel der Entität
function GetEntityDestination(_Entity)
    return {};
end
API.GetEntityDestination = GetEntityDestination;

--- Gibt die Gesundheit der Entität zurück.
--- @param _Entity any ID oder Skriptname
--- @return integer Health Gesundheit der Entität
function GetEntityHealth(_Entity)
    return 0;
end
API.GetEntityHealth = GetEntityHealth;

--- Setzt die Gesundheit der Entität, ohne Prüfung auf plausibelität.
--- @param _Entity any ID oder Skriptname
--- @param _Health integer Gesundheit der Entität
function SetEntityHealth(_Entity, _Health)
end
API.SetEntityHealth = SetEntityHealth;

--- Gibt zurück, ob die Entität ein NPC ist.
--- @param _Entity any ID oder Skriptname
--- @return boolean Active Entität ist NPC 
function GetEntityNpc(_Entity)
    return true;
end
API.GetEntityNpc = GetEntityNpc;

--- Gibt den Besitzer der Entität zurück.
--- @param _Entity any ID oder Skriptname
--- @return integer Player ID des Spielers
function GetEntityPlayer(_Entity)
    return 0;
end
API.GetEntityPlayer = GetEntityPlayer;

--- Setzt den Eigentümer der Entität, ohne Prüfung auf plausibelität.
--- @param _Entity any ID oder Skriptname
--- @param _Player integer Player ID des Spielers
function SetEntityPlayer(_Entity, _Player)
end
API.SetEntityPlayer = SetEntityPlayer;

--- Gibt die Skalierung der Entität zurück.
--- @param _Entity any
--- @return number Scaling Skalierung der Entität
function GetEntityScaling(_Entity)
    return 0;
end
API.GetEntityScaling = GetEntityScaling;

--- Setzt die Skalierung der Entität.
--- @param _Entity any ID oder Skriptname
--- @param _Scaling number Skalierung der Entität
function SetEntityScaling(_Entity, _Scaling)
end
API.SetEntityScaling = SetEntityScaling;

--- Gibt das aktuell genutzte Model der Entität zurück.
--- @param _Entity any ID oder Skriptname
--- @return integer Model Model der Entität
function GetEntityModel(_Entity)
    return 0;
end
API.GetEntityModel = GetEntityModel;

--- Gibt zurück, ob die Entität unsichtbar ist,
--- @param _Entity any ID oder Skriptname
--- @return boolean Visible Entity ist unsichtbar
function IsEntityInvisible(_Entity)
    return true;
end
API.IsEntityInvisible = IsEntityInvisible;

--- Gibt zurück, ob die Entität nicht auswählbar ist.
--- @param _Entity any ID oder Skriptname
--- @return boolean Visible Entity nicht auswählbar
function IsEntityInaccessible(_Entity)
    return true;
end
API.IsEntityInaccessible = IsEntityInaccessible;

--- Gibt den Wert des Index als Ganzzahl zurück.
--- @param _Entity any ID oder Skriptname
--- @param _SV integer Index des Skriptwerts
--- @return integer Wert Wert am Index
function GetInteger(_Entity, _SV)
    return 0;
end
API.GetInteger = GetInteger;

--- Gibt den Wert des Index als Gleitkommazahl zurück.
--- @param _Entity any ID oder Skriptname
--- @param _SV integer Index des Skriptwerts
--- @return number Wert Wert am Index
function GetFloat(_Entity, _SV)
    return 0;
end
API.GetFloat = GetFloat;

--- Legt einen Ganzzahlwert am Index fest.
--- @param _Entity any ID oder Skriptname
--- @param _SV integer Index des Skriptwerts
--- @param _Value integer Zu setzender Wert
function SetInteger(_Entity, _SV, _Value)
end
API.SetInteger = SetInteger;

--- Legt einen Gleitkommawert am Index fest.
--- @param _Entity any ID oder Skriptname
--- @param _SV integer Index des Skriptwerts
--- @param _Value number Zu setzender Wert
function SetFloat(_Entity, _SV, _Value)
end
API.SetFloat = SetFloat;

--- Konvertiert den Gleitkommawert in die Ganzzahldarstellung um.
--- @param _Value number Ganzzahliger Wert
--- @return number Wert Gleitkommawert
function ConvertIntegerToFloat(_Value)
    return 0;
end
API.ConvertIntegerToFloat = ConvertIntegerToFloat;

--- Konvertiert den Ganzzahlwert in die Gleitkommadarstellung um.
--- @param _Value number Gleitkommawert
--- @return integer Wert Ganzzahliger Wert
function ConvertFloatToInteger(_Value)
    return 0;
end
API.ConvertFloatToInteger = ConvertFloatToInteger;

--- Lokalisiert den übergebenen Text oder die Tabelle.
--- @param _Text any Text zur Lokalisierung
--- @return any Lokalisierter Text
function Localize(_Text)
    return "";
end
API.Localize = Localize;

--- Ersetzt alle Platzhalter innerhalb des Strings durch ihre jeweiligen Werte.
---
--- * `{n:xyz}` - Ersetzt einen Skriptnamen durch einen vordefinierten Wert
--- * `{t:xyz}` - Ersetzt einen Typen durch einen vordefinierten Wert
--- * `{v:xyz}` - Ersetzt eine Variable in _G durch ihren Wert.
--- * `{color}` - Ersetzt den Namen der Farbe durch ihren Farbcode.
--- 
--- <p>Farben: 
--- red, blue, yellow, green, white, black, grey, azure, orange, amber, violet,
--- pink, scarlet, magenta, olive, tooltip, none
---
--- @param _Text string Zu formatierender Text
--- @return string Formatierter Text
function ConvertPlaceholders(_Text)
    return "";
end
API.ConvertPlaceholders = ConvertPlaceholders;

--- Gibt eine Nachricht in das Debug-Textfenster aus.
--- @param _Text any Text als String oder Tabelle
function AddNote(_Text)
end
API.Note = AddNote;

--- Gibt eine Nachricht in das Debug-Textfenster aus. Die Nachricht bleibt bestehen, bis sie
--- aktiv entfernt wird.
--- @param _Text any Text als String oder Tabelle
function AddStaticNote(_Text)
end
API.StaticNote = AddStaticNote;

--- Gibt eine Nachricht in das Nachrichtenfenster aus.
--- @param _Text any Text als String oder Tabelle
--- @param _Sound? string Sound zum Abspielen
function AddMessage(_Text, _Sound)
end
API.Message = AddMessage;

--- Entfernt alle Texte aus dem Debug-Textfenster.
function ClearNotes()
end
API.ClearNotes = ClearNotes;

--- Ersetzt einen Namen mit dem Text.
--- @param _Name string Name zum Ersetzen
--- @param _Replacement any Wert der eingefügt wird
function AddNamePlaceholder(_Name, _Replacement)
end
API.AddNamePlaceholder = AddNamePlaceholder;

--- Ersetzt einen Entity Type mit dem Text.
--- @param _Type integer Entity Type zum Ersetzen
--- @param _Replacement any Wert der eingefügt wird
function AddEntityTypePlaceholder(_Type, _Replacement)
end
API.AddEntityTypePlaceholder = AddEntityTypePlaceholder;

--- Speichert eine Zeichenfolgenüberschreibung unter dem Schlüssel.
--- @param _Key string Schlüssel des Eintrags
--- @param _Text any Text oder lokalisierte Tabelle
function AddStringText(_Key, _Text)
end
API.AddStringText = AddStringText;

--- Löscht die Zeichenfolgenüberschreibung unter dem Schlüssel.
--- @param _Key string Schlüssel des Eintrags
function DeleteStringText(_Key)
end
API.DeleteStringText = DeleteStringText;

--- Gibt den Zeichenfolgentext am Schlüssel zurück.
--- @param _Key string Schlüssel des Eintrags
--- @return string Text Zeichenfolgentext
function GetStringText(_Key)
    return "";
end
API.GetStringText = GetStringText;

--- Fügt eine neue Sprache zur Liste hinzu.
--- @param _Shortcut string Sprachkürzel
--- @param _Name string     Anzeigename der Sprache
--- @param _Fallback string Fallback-Sprachkürzel
--- @param _Index? integer  Listenposition
function DefineLanguage(_Shortcut, _Name, _Fallback, _Index)
end

--- Gibt die geschätzte Anzahl Zeilen zurück, die zur Anzeige benötigt wird.
--- 
--- #### Einordnung:
--- <li>Länge 4: `ABCDEFGHKLMNOPQRSTUVWXYZÄÖÜÁÂÃÅÇÈÉÊËÐÐÑÒÓÔÕÖØÙÚÛÜÝ`</li>
--- <li>Länge 3: `abcdeghkmnopqsuvwxyzäöüßIJÆÌÍÎÏÞàáâãåæçèéêëìíîïðñòóôõ÷øùúûüýþÿ`</li>
--- <li>Länge 2: `\"#+*~_\\§$%&=?@fijlft`</li>
--- <li>Länge 1: `!-/()?',.|[]{}`</li>
--- 
--- Alle nicht gelisteten Zeichen werden mit Länge 2 geschätzt.
--- 
--- @param _Text string Text
--- @param _LineLength integer Zeilenlänge
--- @return integer Anzahl Anzahl an Zeilen
function CountTextLines(_Text, _LineLength)
    return 0;
end

--- Setzt den inoffiziellen Patch als Bedingung.
--- 
--- Diese Funktion muss zu Spielbeginn aufgerufen werden! Ist der inoffizielle
--- Patch nicht installiert, sieht der Spieler eine Information und wird ins 
--- Hauptmenü zurück geschickt.
--- @param _Version? string Patch version (Beispiel: "UP 1.0.0")
function SetUnofficialPatchRequired(_Version)
end
API.SetUnofficialPatchRequired = SetUnofficialPatchRequired;

