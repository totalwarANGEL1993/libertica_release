--- Bietet eine bequemere Möglichkeit, Quests zu erstellen.
---
--- Quests können als einzelne Quests oder als verschachtelte Quests erstellt 
--- werden. Eine verschachtelte Quest ist eine vereinfachte Notation für Quests, 
--- die voneinander abhängig sind.
---
--- Alle Texte eines Quest-Texte können auch String Tables sein. Das Format für
--- diese Texte ist "FileName/StringName".
--- 
--- #### Console Commands:
--- In der Konsole können spezielle Komandos eingegeben werden. Eingeklammerte
--- Angaben sind dabei optional.
--- * `fail pattern`:    Lässt einen Quest fehlschlagen
--- * `start pattern`:   Startet einen Quest
--- * `restart pattern`: Startet einen beendeten Quest erneut
--- * `stop pattern`:    Stoppt einen Quest
--- * `win pattern`:     Beendet einen Quest erfolgreich
--- * `stopped`:         Listet alle Quests, die unterbrochen wurden
--- * `active`:          Listet alle Quests, die aktiv sind
--- * `won`:             Listet alle Quests, die gewonnen wurden
--- * `failed`:          Listet alle Quests, die fehlgeschlagen sind
--- * `waiting`:         Listet alle Quests, die nicht ausgelöst sind
--- * `find pattern`:    Sucht alle Quests mit ähnlichen Namen



--- Erstellt eine normale Quest.
---
--- #### Fields `_Data`:
--- * `Name`        - Eindeutiger Name für die Quest
--- * `Sender`      - Spieler-ID des Quest-Gebers
--- * `Receiver`    - Spieler-ID des Quest-Empfängers
--- * `Suggestion`  - Vorschlagstext des Quest
--- * `Success`     - Erfolgsmeldung des Quest
--- * `Failure`     - Fehlermeldung des Quest
--- * `Description` - Benutzerdefinierte Quest-Beschreibung
--- * `Time`        - Zeit bis zum automatischen Scheitern
--- * `Loop`        - Loop-Funktion
--- * `Callback`    - Rückruffunktion
--- 
--- #### Example:
--- Erstellt eine einfache Quest.
--- ```lua
--- SetupQuest {
---     Name        = "SomeQuestName",
---     Suggestion  = "Wir müssen das Kloster finden.",
---     Success     = "Das sind die berühmten Heilermönche.",
---
---     Goal_DiscoverPlayer(4),
---     Reward_Diplomacy(1, 4, "EstablishedContact"),
---     Trigger_Time(0),
--- }
--- ```
--- 
--- @param _Data table Quest-Daten
--- @return string Name Name des Quest
--- @return number Amount Quest-Betrag
function SetupQuest(_Data)
    return "", 0;
end
API.CreateQuest = SetupQuest;

--- Erstellt eine verschachtelte Quest.
---
--- #### Was sind verschachtelte Quests?
--- Verschachtelte Quests vereinfachen die Notation von miteinander verbundenen 
--- Quests. Die "Hauptquest" ist immer unsichtbar und enthält Segmente als 
--- "Unterquests". Jedes Segment des Quest ist selbst eine Quest, die weitere 
--- Segmente enthalten kann.
---
--- Der Name eines Segments kann definiert werden. Wenn er leer gelassen wird, 
--- wird automatisch ein Name vergeben. Dieser Name setzt sich aus dem Namen der
--- Hauptquest und dem Segmentnamen zusammen (z. B. "BeispielName@Segment1").
---
--- Segmente haben ein erwartetes Ergebnis. Normalerweise Erfolg. Das erwartete
--- Ergebnis kann in Misserfolg geändert oder vollständig ignoriert werden. Eine
--- verschachtelte Quest ist abgeschlossen, wenn alle Segmente mit ihrem 
--- erwarteten Ergebnis (Erfolg) abgeschlossen sind oder wenn mindestens ein 
--- Segment mit einem anderen Ergebnis (Fehler) abgeschlossen ist.
---
--- Segmente benötigen keinen Auslöser, da sie alle automatisch gestartet 
--- werden. Es können zusätzliche Auslöser hinzugefügt werden (z. B. Auslösen 
--- auf einem anderen Segment).
---
--- #### Example:
--- Erstellt eine verschachtelte Quest.
--- ```lua
--- SetupNestedQuest {
---     Name        = "Hauptquest",
---     Segments    = {
---         {
---             Suggestion  = "Wir brauchen einen höheren Titel!",
---
---             Goal_KnightTitle("Bürgermeister"),
---         },
---         {
---             -- Dies ignoriert einen Fehler
---             Result      = SegmentResult.Ignore,
---
---             Suggestion  = "Wir brauchen mehr Geld. Und schnell!",
---             Success     = "Wir haben es geschafft!",
---             Failure     = "Wir haben versagt!",
---             Time        = 3 * 60,
---
---             Goal_Produce("G_Gold", 5000),
---
---             Trigger_OnQuestSuccess("Hauptquest@Segment1", 1),
---             -- Segmentierte Quest wird gewonnen.
---             Reward_QuestSuccess("Hauptquest"),
---         },
---         {
---             Suggestion  = "Okay, wir können es mit Eisen versuchen...",
---             Success     = "Wir haben es geschafft!",
---             Failure     = "Wir haben versagt!",
---             Time        = 3 * 60,
---
---             Trigger_OnQuestFailure("Hauptquest@Segment2"),
---             Goal_Produce("G_Eisen", 50),
---         }
---     },
---
---     -- Verlieren, wenn eine Quest nicht ordnungsgemäß endet
---     Reprisal_Defeat(),
---     -- Das Spiel gewinnen, wenn alles erledigt ist.
---     Reward_VictoryWithParty(),
--- };
--- ```
---
--- @param _Data table Quest-Daten
--- @return string Name Name des Quest
function SetupNestedQuest(_Data)
    return "";
end
API.CreateNestedQuest = SetupNestedQuest;

--- Fügt eine Funktion hinzu, um zu steuern, ob Auslöser ausgewertet werden.
--- @param _Function function Bedingung
function AddDisableTriggerCondition(_Function)
end
API.AddDisableTriggerCondition = AddDisableTriggerCondition;

--- Fügt eine Funktion hinzu, um zu steuern, ob Timer ausgewertet werden.
--- @param _Function function Bedingung
function AddDisableTimerCondition(_Function)
end
API.AddDisableTimerCondition = AddDisableTimerCondition;

--- Fügt eine Funktion hinzu, um zu steuern, ob Ziele ausgewertet werden.
--- @param _Function function Bedingung
function AddDisableDecisionCondition(_Function)
end
API.AddDisableDecisionCondition = AddDisableDecisionCondition;

