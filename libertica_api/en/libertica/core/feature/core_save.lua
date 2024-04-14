--- Adds additional functionality to control access to loading and saving.
Lib.Core.Save = {};

--- Deactivates the autosave of the History Edition.
--- @param _Flag boolean Auto save is disabled
function DisableAutoSave(_Flag)
end
API.DisableAutoSave = DisableAutoSave;

--- Deactivates saving the game.
--- @param _Flag boolean Saving is disabled
function DisableSaving(_Flag)
end
API.DisableSaving = DisableSaving;

--- Deactivates loading of savegames.
--- @param _Flag boolean Loading is disabled
function DisableLoading(_Flag)
end
API.DisableLoading = DisableLoading;

