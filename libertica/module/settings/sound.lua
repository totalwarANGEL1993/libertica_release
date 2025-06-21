Lib.Sound = Lib.Sound or {};
Lib.Sound.Name = "Sound";
Lib.Sound.Global = {};
Lib.Sound.Local = {
    Config = {
        DoAlternateSound = true,
    },
    SoundBackup = {},
};

Lib.Require("comfort/IsMultiplayer");
Lib.Require("core/Core");
Lib.Require("module/information/Requester");
Lib.Require("module/settings/Sound_Text");
Lib.Require("module/settings/Sound_API");
Lib.Register("module/settings/Sound");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Sound.Global:Initialize()
    if not self.IsInstalled then
        -- Garbage collection
        Lib.Sound.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Sound.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Sound.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Sound.Local:Initialize()
    if not self.IsInstalled then
        -- Garbage collection
        Lib.Sound.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Sound.Local:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Sound.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.Sound.Local:RequestAlternateSound()
    -- Request window won't show in Multiplayer
    if IsMultiplayer() then
        return;
    end
    -- Ask the player if they want to allow changing sound settings.
    DialogRequestBox(
        GUI.GetPlayerID(),
        Lib.Sound.Text.Request.Title,
        Lib.Sound.Text.Request.Text,
        function(_Yes)
            Lib.Sound.Local.Config.DoAlternateSound = _Yes == true;
        end,
        false
    );
end

function Lib.Sound.Local:AdjustSound(_Global, _Music, _Voice, _Atmo, _UI)
    -- Prevent changing sound altogether if player chosed to
    if not self.Config.DoAlternateSound then
        return;
    end
    -- Save sound backup
    self:SaveSound();
    -- Make changes to the sound
    if _Global then
        Sound.SetGlobalVolume(_Global);
    end
    if _Music then
        Sound.SetMusicVolume(_Music);
    end
    if _Voice then
        Sound.SetSpeechVolume(_Voice);
    end
    if _Atmo then
        Sound.SetFXSoundpointVolume(_Atmo);
        Sound.SetFXAtmoVolume(_Atmo);
    end
    if _UI then
        Sound.Set2DFXVolume(_UI);
        Sound.SetFXVolume(_UI);
    end
end

function Lib.Sound.Local:SaveSound()
    if not self.SoundBackup.Saved then
        self.SoundBackup.Saved = true;
        self.SoundBackup.FXSP = Sound.GetFXSoundpointVolume();
        self.SoundBackup.FXAtmo = Sound.GetFXAtmoVolume();
        self.SoundBackup.FXVol = Sound.GetFXVolume();
        self.SoundBackup.Sound = Sound.GetGlobalVolume();
        self.SoundBackup.Music = Sound.GetMusicVolume();
        self.SoundBackup.Voice = Sound.GetSpeechVolume();
        self.SoundBackup.UI = Sound.Get2DFXVolume();
    end
end

function Lib.Sound.Local:RestoreSound()
    if self.SoundBackup.Saved then
        Sound.SetFXSoundpointVolume(self.SoundBackup.FXSP);
        Sound.SetFXAtmoVolume(self.SoundBackup.FXAtmo);
        Sound.SetFXVolume(self.SoundBackup.FXVol);
        Sound.SetGlobalVolume(self.SoundBackup.Sound);
        Sound.SetMusicVolume(self.SoundBackup.Music);
        Sound.SetSpeechVolume(self.SoundBackup.Voice);
        Sound.Set2DFXVolume(self.SoundBackup.UI);
        self.SoundBackup = {};
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Sound.Name);

