# Getting Started

## Einleitung

Diese Bibliothek für "DIE SIEDLER - Aufstieg eines Königreich" erweitert die
mitgelieferte Bibliothek, die QSB, um zahlreiche weitere Funktionalitäten. Dabei
wird das Rad nicht neu erfunden, sondern auf der bestehenden QSB aufgebaut. 

Dabei kann der Anwender zwischen einem Komplettpaket oder dem einzelnen Import
von Komponenten wählen.

## Installation

### Als einzelne Datei

* Starte den Mapeditor und aktiviere den Expertenmodus.
* Alle benötigten Dateien befinden sich im Unterverzeichnis `single`. Die Mapskripte sind bereits vorbereitet, sodass keine weiteren Anpassungen gemacht werden müssen.
* Die Datei `mapscript.lua` muss im Mapeditor als globales Skript importiert werden
* Die Datei `localmapscript.lua` muss im Mapeditor als lokales Skript importiert werden.
* Die Datei `qsb.min.lua` muss im Mapeditor importiert werden.

### Als Bibliothek

**Wichtig:** Beachte, dass für die Verwendung als Bibliothek das BBA-Tool benötigt wird, um zusätzliche Inhalte in die Map zu importieren. Außerdem löscht jedes Speichern im Editor alle zusatzinhalte. Es empfielt sich, mit entpackten Maps zu arbeiten. Der Lua-Debugger ermöglicht dies.

* Als Bibliothek wird die Datei `questsystembehavior.lua` nicht verwendet, daher funktioniert es nicht mit dem Quest-Assistenten!
* Importiere das Unterverveichnis `libertica` in die Map.
* Verschiebe `mapscript.lua` und `localmapscript.lua` in das Wurzelverzeichnis der Map. (Das ist `maps/externalmap/nameofmap`.) Die Mapskripte sind bereits vorbereitet, sodass sie ohne Anpassungen prinzipiell funktionieren.
* Passe die Imports in beiden Mapskripten nach deinen Bedürfnissen an. Importierte Komponenten laden rekursiv ihre Abhängigkeiten.

## Projekt konfigurieren

Um die vollständige Funktionalität zu garantieren, sollte Visual Studio Code als Editor verwendet werden. Ob die nachfolgend beschriebene Konfiguration auch in anderen Editoren vorgenommen werden kann, musst du selbst herausfinden. Für VSC gibt es das Plugin "Lua Language Server", das viele Comfort-Funktionen wie z.B. Auto-Vervollständigung oder Tooltips mit Funktionsdokumentationen anbietet.

### Konfigurationsdatei für Komplettpaket

Wenn das Komplettpaket verwendet wird, dann sollte das Repository zentral auf dem Rechner abgelegt werden. Beispiel: `C:/Settlers6/QSB/libertica_release`

Es folgt die grundlegende Projektkonfiguration. Diese ist als `settings.json` im Ordner `.vscode` abzulegen.
```json
{
    "Lua.diagnostics.globals": [],
    "Lua.workspace.ignoreDir": [
        "C:/Settlers6/QSB/libertica_release/libertica_api/en",
        "C:/Settlers6/QSB/libertica_release/libertica",
        "C:/Settlers6/QSB/libertica_release/single"
    ],
    "Lua.workspace.library": [
        "C:/Settlers6/QSB/libertica_release/libertica_api/de"
    ]
}
```
Wenn du das Repository in einem anderen Verzeichnis ablegts, müssen die Pfade angepasst werden.

### Konfigurationsdatei für Repository

Wenn das Repository verwendet wird, dann kann der Ordner `libertica` in die Map kopiert werden. Dann ist auch die API-Dokumentation bereits innerhalb der Map.

In diesem Fall sieht die `settings.json` wie folgt aus:
```json
{
    "Lua.diagnostics.globals": [],
    "Lua.workspace.ignoreDir": [
        "nameofmap.s6xmap.unpacked/maps/externalmap/nameofmap/libertica_release/libertica_api/en",
        "nameofmap.s6xmap.unpacked/maps/externalmap/nameofmap/libertica_release/libertica",
        "nameofmap.s6xmap.unpacked/maps/externalmap/nameofmap/libertica_release/single"
    ],
    "Lua.workspace.library": [
        "nameofmap.s6xmap.unpacked/maps/externalmap/nameofmap/libertica_release/libertica_api/de"
    ]
}
```

### HE als Bibliothek

Für Besitzer der History Edition ist es zudem möglich, das Spiel selbst als Bibliothek anzugeben. Das hat den Vorteil, dass auch die Lua-Funktionen des Spiels in der Autovervollständigung auftauchen. Dies hat jedoch seine Grenzen, da die C-Bindungs (z.B. Logic) davon ausgenommen sind.

Um das Spiel zur Bibliothek hinzuzufügen, muss es als Library konfiguriert werden. Achte darauf, dass die Pfade ggf. angepasst werden müssen!
```json
{
"Lua.workspace.library": [
    "nameofmap.s6xmap.unpacked/maps/externalmap/nameofmap/libertica_release/libertica_api/de",
    "C:/Program Files (x86)/Steam/SteamApps/common/The Settlers - Rise of an Empire - History Edition/Data/base/shr/Script/Global",
    "C:/Program Files (x86)/Steam/SteamApps/common/The Settlers - Rise of an Empire - History Edition/Data/base/shr/Script/Local",
    "C:/Program Files (x86)/Steam/SteamApps/common/The Settlers - Rise of an Empire - History Edition/Data/base/shr/Script/Shared",
    "C:/Program Files (x86)/Steam/SteamApps/common/The Settlers - Rise of an Empire - History Edition/Data/extra1/shr/Script/Global",
    "C:/Program Files (x86)/Steam/SteamApps/common/The Settlers - Rise of an Empire - History Edition/Data/extra1/shr/Script/Local",
    "C:/Program Files (x86)/Steam/SteamApps/common/The Settlers - Rise of an Empire - History Edition/Data/extra1/shr/Script/Shared"
]
}
```

## Projektstruktur

Ich empfehle folgende Projektstruktur, falls mit dem Repository und __nicht__ mit dem Komplettpaket der QSB gearbeitet wird:

```
Project
|- .vscode
 |- settings.json
|- mapname.s6xmap.unpacked
 |- maps
  |- externalmap
   |- mapname
    |- libertica
     |- ... library files
    |- scripts
    |- localmapscript.lua
    |- mapscript.lua
    |- ... other files
```
Diese Struktur vereinfacht das Auslagern von Skripten. Die Skripte liegen im Ordner `scripts` und werden in den Hauptskripten nur geladen. Während der Entwicklung kann anstelle des Path in der Map der absolute Path im System angegeben werden.

`maps/externalmap/mapname/scripts/luafile.lua` - Das ist ein relativer Pfad innerhalb des Spiels.

`C:/Settlers6/mapname/scripts/luafile.lua` - Das ist ein absoluter Pfad auf deinem Rechner.