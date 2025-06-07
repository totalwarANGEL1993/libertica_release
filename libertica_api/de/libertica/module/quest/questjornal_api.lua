--- Ermöglicht das Hinzufügen von Notizen zu einem Quest.
--- 
--- Notizen zu einem Auftrag werden in einem Textfenster angezeigt. Für
--- Quests mit Notizen wird ein neuer Button angezeigt, mit dem das Textfenster
--- geöffnet werden kann. Notizen können in normale (blau) und erhöhte (rot)
--- Wichtigkeit eingeteilt werden.
--- 
--- Zusätzlich kannst du dem Spieler erlauben, sich selbst Notizen zu machen.
--- Die Notizen des Spielers haben eine höhere Priorität gegenüber allen anderen
--- Notizen und sich violet hervorgehoben.



--- Aktiviert oder deaktiviert das Journal oder einem bestimmtem Quest.
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
--- Der Eintrag kann jedem Journal jedem Quest hinzugefügt werden.
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

--- Fügt einen Eintrag dem Journal des Quest hinzu.
--- @param _ID integer ID des Eintrags
--- @param _Quest string Name des Quest
function AddJournalEntryToQuest(_ID, _Quest)
end

--- Entfernt einen Eintrag aus dem Journal des Quest.
--- @param _ID integer ID des Eintrags
--- @param _Quest string Name des Quest
function RemoveJournalEntryFromQuest(_ID, _Quest)
end

