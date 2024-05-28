Lib.Require("comfort/IsLocalScript");
Lib.Register("module/settings/Sound_API");

function StartEventPlaylist(_Playlist, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if not GUI then
        ExecuteLocal("StartEventPlaylist('%s', %d)", _Playlist, _PlayerID);
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.MusicStartEventPlaylist(_Playlist)
    end
end
API.StartEventPlaylist = StartEventPlaylist;

function StopEventPlaylist(_Playlist, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if not GUI then
        ExecuteLocal("StopEventPlaylist('%s', %d)", _Playlist, _PlayerID);
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.MusicStopEventPlaylist(_Playlist)
    end
end
API.StopEventPlaylist = StopEventPlaylist;

function Play2DSound(_Sound, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if not GUI then
        ExecuteLocal([[Play2DSound("%s", %d)]], _Sound, _PlayerID);
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.FXPlay2DSound(_Sound:gsub("/", "\\"));
    end
end
API.Play2DSound = Play2DSound;

function Play3DSound(_Sound, _X, _Y, _Z, _PlayerID)
    _PlayerID = _PlayerID or 1;
    _X = _X or 1;
    _Y = _Y or 1
    _Z = _Z or 0
    if not GUI then
        ExecuteLocal([[Play3DSound("%s", %f, %f, %d)]], _Sound, _X, _Y, _PlayerID);
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.FXPlay3DSound(_Sound:gsub("/", "\\"), _X, _Y, _Z);
    end
end
API.Play3DSound = Play3DSound;

function SoundSetVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(_Volume, nil, nil, nil, nil);
end
API.SoundSetVolume = SoundSetVolume;

function SoundSetMusicVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetMusicVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(nil, _Volume, nil, nil, nil);
end
API.SoundSetMusicVolume = SoundSetMusicVolume;

function SoundSetVoiceVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetVoiceVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(nil, nil, _Volume, nil, nil);
end
API.SoundSetVoiceVolume = SoundSetVoiceVolume;

function SoundSetAtmoVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetAtmoVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(nil, nil, nil, _Volume, nil);
end
API.SoundSetAtmoVolume = SoundSetAtmoVolume;

function SoundSetUIVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetUIVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(nil, nil, nil, nil, _Volume);
end
API.SoundSetUIVolume = SoundSetUIVolume;

function SoundSave()
    if not GUI then
        Logic.ExecuteInLuaLocalState("SoundSave()");
        return;
    end
    Lib.Sound.Local:SaveSound();
end
API.SoundSave = SoundSave;

function SoundRestore()
    if not GUI then
        ExecuteLocal("SoundRestore()");
        return;
    end
    Lib.Sound.Local:RestoreSound();
end
API.SoundRestore = SoundRestore;

function PlayVoice(_File)
    if not GUI then
        ExecuteLocal([[PlayVoice("%s")]], _File);
        return;
    end
    StopVoice();
    Sound.PlayVoice("ImportantStuff", _File);
end
API.PlayVoice = PlayVoice;

function StopVoice()
    if not GUI then
        ExecuteLocal("StopVoice()");
        return;
    end
    Sound.StopVoice("ImportantStuff");
end
API.StopVoice = StopVoice;

function RequestAlternateSound()
    if not GUI then
        ExecuteLocal("RequestAlternateSound()");
        return;
    end
    Lib.Sound.Local:RequestAlternateSound();
end
API.RequestAlternateSound = RequestAlternateSound;

