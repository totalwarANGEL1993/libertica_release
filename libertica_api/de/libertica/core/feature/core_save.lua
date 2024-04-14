--- Fügt zusätzliche Funktionalitäten hinzu, um den Zugriff auf Laden und Speichern zu steuern.
Lib.Core.Save = {};

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

