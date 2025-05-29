--- Dieses Modul ermöglicht die Steuerung des Sounds.
---
--- #### Funktionen
--- <li>Starten/Stoppen von Musik-Playlists</li>
--- <li>Starten/Stoppen von Sprachwiedergabe</li>
--- <li>Starten/Stoppen von Soundeffekten</li>
--- <li>Ändern der Soundkonfiguration</li>
--- 
--- #### Aufbau Playlist
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



--- Startet eine Ereignis-Playlist.
---
--- Es ist möglich, benutzerdefinierte Dateien in das Spiel zu importieren, indem sie in
--- das Kartenarchiv gespeichert werden. Eine Playlist benötigt eine XML-Datei, die sie definiert, und die Dateien
--- mit der Musik.
---
--- Um Probleme mit Musikdateien zu vermeiden, ist es am besten, allen Dateien
--- einen eindeutigen Namen zu geben. Zum Beispiel finden Sie für alle Dateien aus
--- dem Kartenname einen kurzen Präfix. Wenn mehrere Karten mit denselben Dateien innerhalb der Playlist oder
--- des Musikverzeichnisses vorhanden sind, werden Dateien überschrieben!
---
--- #### Dateistruktur für benutzerdefinierte Playlists:
--- ```xml
--- map_xyz.s6xmap.unpacked
--- |-- music/*
--- |-- config/sound/*
--- |-- maps/externalmap/map_xyz/*
--- |-- ...
--- ```
---
--- Playlist-Einträge können mit `Loop` als Typ wiederholt oder einmal abgespielt werden
--- mit `Normal` als Typ.
--- 
--- @param _Playlist string Name der Playlist
--- @param _PlayerID integer ID des Spielers
function StartEventPlaylist(_Playlist, _PlayerID)
end
API.StartEventPlaylist = StartEventPlaylist;

--- Stoppt eine Ereignis-Playlist.
--- @param _Playlist string Name der Playlist
--- @param _PlayerID integer ID des Spielers
function StopEventPlaylist(_Playlist, _PlayerID)
end
API.StopEventPlaylist = StopEventPlaylist;

--- Spielt einen Interface-Sound ab.
---
--- Es ist möglich, benutzerdefinierte Dateien in das Spiel zu importieren, indem sie in
--- das Kartenarchiv gespeichert werden. Um Namensprobleme zu vermeiden, geben Sie allen Dateien
--- einen eindeutigen Namen.
---
--- #### Dateistruktur für benutzerdefinierte Sounds:
--- ```xml
--- map_xyz.s6xmap.unpacked
--- |-- sounds/high/ui/*
--- |-- sounds/low/ui/*
--- |-- maps/externalmap/map_xyz/*
--- |-- ...
--- ```
--- @param _Sound string Pfad zum Sound
--- @param _PlayerID integer ID des Spielers
function Play2DSound(_Sound, _PlayerID)
end
API.Play2DSound = Play2DSound;

--- Spielt einen Sound an einer Weltkoordinate ab.
---
--- Es ist möglich, benutzerdefinierte Dateien in das Spiel zu importieren, indem sie in
--- das Kartenarchiv gespeichert werden. Um Namensprobleme zu vermeiden, geben Sie allen Dateien
--- einen eindeutigen Namen.
---
--- #### Dateistruktur für benutzerdefinierte Sounds:
--- ```xml
--- map_xyz.s6xmap.unpacked
--- |-- sounds/high/ui/*
--- |-- sounds/low/ui/*
--- |-- maps/externalmap/map_xyz/*
--- |-- ...
--- ```
--- @param _Sound string Pfad zum Sound
--- @param _X number X-Koordinate des Sounds
--- @param _Y number Y-Koordinate des Sounds
--- @param _Z number Z-Koordinate des Sounds
--- @param _PlayerID integer ID des Spielers
function Play3DSound(_Sound, _X, _Y, _Z, _PlayerID)
end
API.Play3DSound = Play3DSound;

--- Setzt die Gesamtlautstärke des Sounds.
---
--- Die aktuellen Werte werden automatisch als Standard gespeichert, wenn kein Standard
--- gefunden wird.
--- @param _Volume integer Lautstärke der Soundeigenschaft
function SoundSetVolume(_Volume)
end
API.SoundSetVolume = SoundSetVolume;

--- Setzt die Lautstärke der Musik.
---
--- Die aktuellen Werte werden automatisch als Standard gespeichert, wenn kein Standard
--- gefunden wird.
--- @param _Volume integer Lautstärke der Soundeigenschaft
function SoundSetMusicVolume(_Volume)
end
API.SoundSetMusicVolume = SoundSetMusicVolume;

--- Setzt die Lautstärke der Stimmen.
---
--- Die aktuellen Werte werden automatisch als Standard gespeichert, wenn kein Standard
--- gefunden wird.
--- @param _Volume integer Lautstärke der Soundeigenschaft
function SoundSetVoiceVolume(_Volume)
end
API.SoundSetVoiceVolume = SoundSetVoiceVolume;

--- Setzt die Lautstärke der Umgebungsgeräusche.
---
--- Die aktuellen Werte werden automatisch als Standard gespeichert, wenn kein Standard
--- gefunden wird.
--- @param _Volume integer Lautstärke der Soundeigenschaft
function SoundSetAtmoVolume(_Volume)
end
API.SoundSetAtmoVolume = SoundSetAtmoVolume;

--- Setzt die Lautstärke der Interface-Sounds.
---
--- Die aktuellen Werte werden automatisch als Standard gespeichert, wenn kein Standard
--- gefunden wird.
--- @param _Volume integer Lautstärke der Soundeigenschaft
function SoundSetUIVolume(_Volume)
end
API.SoundSetUIVolume = SoundSetUIVolume;

--- Speichert manuell die Soundlautstärken als Standard.
function SoundSave()
end
API.SoundSave = SoundSave;

--- Stellt manuell die Soundlautstärken auf Standard zurück.
function SoundRestore()
end
API.SoundRestore = SoundRestore;

--- Spielt eine Sounddatei als Stimme ab.
--- @param _File string Pfad zum Sound
--- @param _Identifier? string Name der Sprachausgabe
function PlayVoice(_File, _Identifier)
end
API.PlayVoice = PlayVoice;

--- Stoppt eine abgespielte Stimme.
--- @param _Identifier? string Name der Sprachausgabe
function StopVoice(_Identifier)
end
API.StopVoice = StopVoice;

--- Fragt den Spieler, ob Laufstärkeänderung vorgenommen werden dürfen.
---
--- Diese Funktionalität ist im Multiplayer deaktiviert.
function RequestAlternateSound()
end
API.RequestAlternateSound = RequestAlternateSound;

