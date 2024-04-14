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
* Die Datei `mapscript.lua` muss im Mapeditor als lokales Skript importiert werden
* Die Datei `localmapscript.lua` muss im Mapeditor als lokales Skript importiert werden.
* Die Datei `qsb_full.lua` muss im Mapeditor importiert werden.

### Als Repository

**Wichtig:** Beachte, dass für die Verwendung des Repository das BBA-Tool benötigt wird, um zusätzliche Inhalte in die Map zu importieren. Außerdem löscht jedes Speichern im Editor alle zusatzinhalte. Es empfielt sich, mit entpackten Maps zu arbeiten. Der Lua-Debugger ermöglicht dies.

* Importiere das Unterverveichnis `libertica` in die Map.
* Verschiebe `mapscript.lua`, `localmapscript.lua` und `qsb.lua` in das Wurzelverzeichnis der Map. (Das ist `maps/externalmap/nameofmap`.) Die Mapskripte sind bereits vorbereitet, sodass sie ohne Anpassungen prinzipiell funktionieren.
* Benenne `qsb.lua` in `questsystembehavior.lua` um.
* Passe die Imports in beiden Mapskripten nach deinen Bedürfnissen an. Importierte Komponenten laden rekursiv ihre Abhängigkeiten.

## Projekt konfigurieren

Um die vollständige Funktionalität zu garantieren, sollte Visual Studio Code als Editor verwendet werden. Ob die nachfolgend beschriebene Konfiguration auch in anderen Editoren vorgenommen werden kann, musst du selbst herausfinden. Für VSC gibt es das Plugin "Lua Language Server", das viele Comfort-Funktionen wie z.B. Auto-Vervollständigung oder Tooltips mit Funktionsdokumentationen anbietet.

### Konfigurationsdatei für Einzeldatei

Wenn die Einzeldatei verwendet wird, dann sollte das Repository zentral auf dem Rechner abgelegt werden. Beispiel: `C:/Settlers6/QSB/libertica_release`

Es folgt die grundlegende Projektkonfiguration. Diese ist als `settings.json` im Ordner `.vscode` abzulegen.
```json
{
    "Lua.diagnostics.globals": [],
    "Lua.workspace.ignoreDir": [
        "C:/Settlers6/QSB/libertica_release/libertica_api/en",
        "C:/Settlers6/QSB/libertica_release/libertica",
        "C:/Settlers6/QSB/libertica_release/single",
    ],
    "Lua.workspace.library": [
        "C:/Settlers6/QSB/libertica_release/libertica_api/de"
    ]
}
```
Wenn du das Repository in einem anderen Verzeichnis ablegts, müssen die Pfade angepasst werden.

### Konfigurationsdatei für Repository

Wenn das Repository verwendet wird, dann kann der ganze Ordner (abzüglich `.git`) in die Map kopiert werden. Dann ist auch die API-Dokumentation bereits innerhalb der Map.

In diesem Fall sieht die `settings.json` wie folgt aus:
```json
{
    "Lua.diagnostics.globals": [],
    "Lua.workspace.ignoreDir": [
        "libertica_release/libertica_api/en",
        "libertica_release/libertica",
        "libertica_release/single",
    ],
    "Lua.workspace.library": [
        "libertica_release/libertica_api/de"
    ]
}
```

## Projektstruktur

Ich empfehle folgende Projektstruktur, falls mit dem Repository und nicht mit der Einzeldatei der QSB gearbeitet wird:

```
Project
|- .vscode
 |- settings.json
|- mapname.s6xmap.unpacked
 |- maps
  |- externalmap
   |- mapname
    |- libertica_release
     |- ... library files
    |- scripts
    |- localmapscript.lua
    |- mapscript.lua
    |- questsystembehavior.lua
    |- ... other files
```
Diese Struktur vereinfacht das Auslagern von Skripten. Die Skripte liegen im Ordner `scripts` und werden in den Hauptskripten nur geladen. Während der Entwicklung kann anstelle des Path in der Map der absolute Path im System angegeben werden.

`maps/externalmap/mapname/scripts/luafile.lua` - Das ist ein relativer Pfad innerhalb der Map.

`C:/Settlers6/mapname/scripts/luafile.lua` - Das ist ein absoluter Pfad auf deinem Rechner.