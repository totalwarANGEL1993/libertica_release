--- Ermöglicht das Hinzufügen von Notizen zu einer Quest.
--- 
Lib.QuestJournal = Lib.QuestJournal or {};



--- Aktiviert oder deaktiviert das Journal oder eine bestimmte Quest.
--- @param _Quest string Name der Quest
--- @param _Flag boolean Aktivieren/Deaktivieren
function ShowJournalForQuest(_Quest, _Flag)
end

--- Ermöglicht es dem Spieler, Notizen im Journal zu machen.
--- @param _Quest string Name der Quest
--- @param _Flag boolean Aktivieren/Deaktivieren
function AllowNotesForQuest(_Quest, _Flag)
end

--- Erstellt einen neuen Journaleintrag und gibt die ID zurück.
---
--- Der Eintrag kann jedem Journal jeder Quest hinzugefügt werden.
--- @param _Text string Text des Eintrags
--- @return integer ID ID des Eintrags
function CreateJournalEntry(_Text)
    return 0;
end

--- Aktualisiert den Journaleintrag mit der ID.
--- @param _ID integer ID des Eintrags
--- @param _Text string Text des Eintrags
function AlterJournalEntry(_ID, _Text)
end

--- Markiert einen Journaleintrag als wichtig und hebt ihn hervor.
--- @param _ID integer ID des Eintrags
--- @param _Important boolean Eintrag hervorheben
function HighlightJournalEntry(_ID, _Important)
end

--- Löscht einen Eintrag. Der Eintrag wird aus allen Journals gelöscht, an die er
--- angehängt ist.
--- @param _ID integer ID des Eintrags
function DeleteJournalEntry(_ID)
end

--- Stellt einen gelöschten Eintrag wieder her. Der Eintrag erscheint erneut in allen Journals,
--- an die er angehängt ist.
--- @param _ID integer ID des Eintrags
function RestoreJournalEntry(_ID)
end

--- Fügt einen Eintrag dem Journal der Quest hinzu.
--- @param _ID integer ID des Eintrags
--- @param _Quest string Name der Quest
function AddJournalEntryToQuest(_ID, _Quest)
end

--- Entfernt einen Eintrag aus dem Journal der Quest.
--- @param _ID integer ID des Eintrags
--- @param _Quest string Name der Quest
function RemoveJournalEntryFromQuest(_ID, _Quest)
end

