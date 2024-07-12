Lib.Require("comfort/IsLocalScript");
Lib.Register("module/settings/Sound_API");

function StartEventPlaylist(_Playlist, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if GUI and _PlayerID == GUI.GetPlayerID() then
        Sound.MusicStartEventPlaylist(_Playlist);
    end
    ExecuteLocal("StartEventPlaylist('%s', %d)", _Playlist, _PlayerID);
end
API.StartEventPlaylist = StartEventPlaylist;

function StopEventPlaylist(_Playlist, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if GUI and _PlayerID == GUI.GetPlayerID() then
        Sound.MusicStopEventPlaylist(_Playlist);
    end
    ExecuteLocal("StopEventPlaylist('%s', %d)", _Playlist, _PlayerID);
end
API.StopEventPlaylist = StopEventPlaylist;

function Play2DSound(_Sound, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if GUI or _PlayerID == GUI.GetPlayerID() then
        Sound.FXPlay2DSound(_Sound:gsub("/", "\\"));
    end
    ExecuteLocal([[Play2DSound("%s", %d)]], _Sound, _PlayerID);
end
API.Play2DSound = Play2DSound;

function Play3DSound(_Sound, _X, _Y, _Z, _PlayerID)
    _PlayerID = _PlayerID or 1;
    _X = _X or 1;
    _Y = _Y or 1
    _Z = _Z or 0
    if GUI or _PlayerID == GUI.GetPlayerID() then
        Sound.FXPlay3DSound(_Sound:gsub("/", "\\"), _X, _Y, _Z);
    end
    ExecuteLocal([[Play3DSound("%s", %f, %f, %d)]], _Sound, _X, _Y, _PlayerID);
end
API.Play3DSound = Play3DSound;

function SoundSetVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if GUI then
        Lib.Sound.Local:AdjustSound(_Volume, nil, nil, nil, nil);
    end
    ExecuteLocal("SoundSetVolume(%d)", _Volume);
end
API.SoundSetVolume = SoundSetVolume;

function SoundSetMusicVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if GUI then
        Lib.Sound.Local:AdjustSound(nil, _Volume, nil, nil, nil);
    end
    ExecuteLocal("SoundSetMusicVolume(%d)", _Volume);
end
API.SoundSetMusicVolume = SoundSetMusicVolume;

function SoundSetVoiceVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if GUI then
        Lib.Sound.Local:AdjustSound(nil, nil, _Volume, nil, nil);
    end
    ExecuteLocal("SoundSetVoiceVolume(%d)", _Volume);
end
API.SoundSetVoiceVolume = SoundSetVoiceVolume;

function SoundSetAtmoVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if GUI then
        Lib.Sound.Local:AdjustSound(nil, nil, nil, _Volume, nil);
    end
    ExecuteLocal("SoundSetAtmoVolume(%d)", _Volume);
end
API.SoundSetAtmoVolume = SoundSetAtmoVolume;

function SoundSetUIVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if GUI then
        Lib.Sound.Local:AdjustSound(nil, nil, nil, nil, _Volume);
    end
    ExecuteLocal("SoundSetUIVolume(%d)", _Volume);
end
API.SoundSetUIVolume = SoundSetUIVolume;

function SoundSave()
    if GUI then
        Lib.Sound.Local:SaveSound();
    end
    Logic.ExecuteInLuaLocalState("SoundSave()");
end
API.SoundSave = SoundSave;

function SoundRestore()
    if GUI then
        Lib.Sound.Local:RestoreSound();
    end
    ExecuteLocal("SoundRestore()");
end
API.SoundRestore = SoundRestore;

function PlayVoice(_File, _Identifier)
    _Identifier = _Identifier or "ImportantStuff";
    if GUI then
        StopVoice();
        Sound.PlayVoice(_Identifier, _File);
    end
    ExecuteLocal([[PlayVoice("%s", "%s")]], _File, _Identifier);
end
API.PlayVoice = PlayVoice;

function StopVoice(_Identifier)
    _Identifier = _Identifier or "ImportantStuff";
    if GUI then
        Sound.StopVoice(_Identifier);
    end
    ExecuteLocal("StopVoice()");
end
API.StopVoice = StopVoice;

function RequestAlternateSound()
    if GUI then
        Lib.Sound.Local:RequestAlternateSound();
    end
    ExecuteLocal("RequestAlternateSound()");
end
API.RequestAlternateSound = RequestAlternateSound;

