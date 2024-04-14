--- Bietet eine bequemere Möglichkeit, Quests zu erstellen.
---
--- Quests können als einzelne Quests oder als verschachtelte Quests erstellt 
--- werden. Eine verschachtelte Quest ist eine vereinfachte Notation für Quests, 
--- die voneinander abhängig sind.
---
--- #### Debug-Befehle
--- * `stop <QuestName>`      - Unterbricht eine Quest
--- * `start <QuestName>`     - Startet eine Quest
--- * `win <QuestName>`       - Beendet eine Quest erfolgreich
--- * `fail <QuestName>`      - Beendet eine Quest mit einem Fehler
--- * `restart <QuestName>`   - Setzt eine Quest zurück und startet sie neu
---
Lib.Quest = Lib.Quest or {};



--- Erstellt eine normale Quest.
---
--- #### Felder der Tabelle
--- * Name:        Eindeutiger Name für die Quest
--- * Sender:      Spieler-ID des Quest-Gebers
--- * Receiver:    Spieler-ID des Quest-Empfängers
--- * Suggestion:  Vorschlagstext der Quest
--- * Success:     Erfolgsmeldung der Quest
--- * Failure:     Fehlermeldung der Quest
--- * Description: Benutzerdefinierte Quest-Beschreibung
--- * Time:        Zeit bis zum automatischen Scheitern
--- * Loop:        Loop-Funktion
--- * Callback:    Rückruffunktion
--- 
--- #### Beispiele
--- ```lua
--- -- Erstellt eine einfache Quest
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
--- @param _Data table Quest-Daten
--- @return string Name Name der Quest
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
--- "Unterquests". Jedes Segment der Quest ist selbst eine Quest, die weitere 
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
--- #### Beispiele
--- ```lua
--- -- Erstellt eine verschachtelte Quest
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
--- @return string Name Name der Quest
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

