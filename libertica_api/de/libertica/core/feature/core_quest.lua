--- Fügt zusätzliche Funktionalität zum Quest-System hinzu.
Lib.Core.Quest = {}

--- Setzt die Menge an Ressourcen in einer Mine und optional die Auffüllmenge.
--- @param _Entity string|integer Entität, die geändert werden soll
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

