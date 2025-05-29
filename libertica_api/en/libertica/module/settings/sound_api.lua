--- This module enables to controll the sound.
---
--- #### Features
--- <li>Start/stop music playlists</li>
--- <li>Start/stop voice playback</li>
--- <li>Start/stop sound effecs</li>
--- <li>Change sound configuration</li>
--- 
--- #### Playlist structure
--- ```xml
--- &lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
--- &lt;PlayList&gt;
---  &lt;PlayListEntry&gt;
---    &lt;FileName&gt;Music\some_music_file.mp3&lt;/FileName&gt;
---    &lt;Type&gt;Loop&lt;/Type&gt;
---    &lt;Chance&gt;10&lt;/Chance&gt; &lt;!-- optional --&gt;
---  &lt;/PlayListEntry&gt;
---  &lt;!-- Add entries here --&gt;
--- &lt;/PlayList&gt;
--- xml```
---



--- Starts an event playlist.
---
--- It is possible to import custom files into the game by saving them into
--- the map archive. A playlist needs a XML file defining it and the files
--- with the music.
---
--- To avoid problems with music files it is best practice to give all files
--- a unique name. For example find a short prefix for all files taken from
--- the map name. If multiple maps with the same files inside the playlist or
--- music directory are present then files will be overwritten!
---
--- #### File structure for custom playlists:
--- ```xml
--- map_xyz.s6xmap.unpacked
--- |-- music/*
--- |-- config/sound/*
--- |-- maps/externalmap/map_xyz/*
--- |-- ...
--- ```
---
--- Playlist entries can be looped by using `Loop` as type or be played once
--- with `Normal` as type.
--- 
--- @param _Playlist string Name of playlist
--- @param _PlayerID integer ID of player
function StartEventPlaylist(_Playlist, _PlayerID)
end
API.StartEventPlaylist = StartEventPlaylist;

--- Stops an event playlist.
--- @param _Playlist string Name of playlist
--- @param _PlayerID integer ID of player
function StopEventPlaylist(_Playlist, _PlayerID)
end
API.StopEventPlaylist = StopEventPlaylist;

--- Plays an interface sound.
---
--- It is possible to import custom files into the game by saving them into
--- the map archive. To avoid naming problems give all files a unique name.
---
--- #### File structure for custom sounds:
--- ```xml
--- map_xyz.s6xmap.unpacked
--- |-- sounds/high/ui/*
--- |-- sounds/low/ui/*
--- |-- maps/externalmap/map_xyz/*
--- |-- ...
--- ```
--- @param _Sound string Path to sound
--- @param _PlayerID integer ID of player
function Play2DSound(_Sound, _PlayerID)
end
API.Play2DSound = Play2DSound;

--- Plays a sound at a world coordinate.
---
--- It is possible to import custom files into the game by saving them into
--- the map archive. To avoid naming problems give all files a unique name.
---
--- #### File structure for custom sounds:
--- ```xml
--- map_xyz.s6xmap.unpacked
--- |-- sounds/high/ui/*
--- |-- sounds/low/ui/*
--- |-- maps/externalmap/map_xyz/*
--- |-- ...
--- ```
--- @param _Sound string Path to sound
--- @param _X number X coordinate of sound
--- @param _Y number Y coordinate of sound
--- @param _Z number Z coordinate of sound
--- @param _PlayerID integer ID of player
function Play3DSound(_Sound, _X, _Y, _Z, _PlayerID)
end
API.Play3DSound = Play3DSound;

--- Sets the master volume of the sound.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetVolume(_Volume)
end
API.SoundSetVolume = SoundSetVolume;

--- Sets the volume of the music.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetMusicVolume(_Volume)
end
API.SoundSetMusicVolume = SoundSetMusicVolume;

--- Sets the volume of voices.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetVoiceVolume(_Volume)
end
API.SoundSetVoiceVolume = SoundSetVoiceVolume;

--- Sets the volume of atmospheric sounds.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetAtmoVolume(_Volume)
end
API.SoundSetAtmoVolume = SoundSetAtmoVolume;

--- Sets the volume of interface sounds.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetUIVolume(_Volume)
end
API.SoundSetUIVolume = SoundSetUIVolume;

--- Manually saves the sound volumes as default.
function SoundSave()
end
API.SoundSave = SoundSave;

--- Manually restores the sound volumes to default.
function SoundRestore()
end
API.SoundRestore = SoundRestore;

--- Plays a sound file as voice.
--- @param _File string Path to sound
--- @param _Identifier? string Name of speech
function PlayVoice(_File, _Identifier)
end
API.PlayVoice = PlayVoice;

--- Stops a playing voice.
--- @param _Identifier? string Name of speech
function StopVoice(_Identifier)
end
API.StopVoice = StopVoice;

--- Asks the player, if they permit temporarily changes of the sound volume.
---
--- This functionality is not available in Multiplayer.
function RequestAlternateSound()
end
API.RequestAlternateSound = RequestAlternateSound;

