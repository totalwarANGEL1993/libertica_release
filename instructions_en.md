# Getting Started

## Introduction

This library for "THE SETTLERS - Rise of an Empire" expands the included library, QSB, with numerous additional functionalities. The wheel is not reinvented, but built upon the existing QSB.

Users can choose between a complete package or the individual import of components.

## Installation

### As a Single File

* Start the map editor and enable expert mode.
* All required files are located in the subdirectory `single`. The map scripts are already prepared, so no further adjustments are necessary.
* The file `mapscript.lua` must be imported into the map editor as the global script.
* The file `localmapscript.lua` must be imported into the map editor as the local script.
* The file `qsb.min.lua` must be imported into the map editor.

### As a repository

**Important:** Note that using the repository requires the BBA tool to import additional content into the map. Additionally, saving in the editor deletes all additional content. It is recommended to work with unpacked maps. The Lua debugger enables this.

* Import the subdirectory `libertica` into the map.
* Move `mapscript.lua`, `localmapscript.lua`, and `qsb.min.lua` to the root directory of the map. (That is `maps/externalmap/nameofmap`.) The map scripts are already prepared, so they should function in principle without any adjustments.
* Rename `qsb.min.lua` to `questsystembehavior.lua`.
* Customize the imports in both map scripts according to your needs. Imported components recursively load their dependencies.

## Configuring the Project

To ensure full functionality, Visual Studio Code should be used as the editor. Whether the configuration described below can also be done in other editors, you'll have to find out yourself. For VSC, there's the "Lua Language Server" plugin, which offers many convenience functions such as auto-completion or tooltips with function documentation.

### Config for single file

If the single file is used then the repository should be located somewhere central on the system. Example: `C:/Settlers6/QSB/libertica_release`

The following is the project configuration. It is to be saved as `settings.json` im in the subdirectory `.vscode`.
```json
{
    "Lua.diagnostics.globals": [],
    "Lua.workspace.ignoreDir": [
        "C:/Settlers6/QSB/libertica_release/libertica_api/de",
        "C:/Settlers6/QSB/libertica_release/libertica",
        "C:/Settlers6/QSB/libertica_release/single",
    ],
    "Lua.workspace.library": [
        "C:/Settlers6/QSB/libertica_release/libertica_api/en"
    ]
}
```
If you wish to locate the repository somewhere else, the paths must be adjusted.

### Config for repository

If the repository is used directly, it is - minus `.git` - to be imported into the map. In that case the API documentation is also located inside the map.

The contet of `settings.json` will look as follows:
```json
{
    "Lua.diagnostics.globals": [],
    "Lua.workspace.ignoreDir": [
        "nameofmap.s6xmap.unpacked/maps/externalmap/nameofmap/libertica_release/libertica_api/de",
        "nameofmap.s6xmap.unpacked/maps/externalmap/nameofmap/libertica_release/libertica",
        "nameofmap.s6xmap.unpacked/maps/externalmap/nameofmap/libertica_release/single",
    ],
    "Lua.workspace.library": [
        "nameofmap.s6xmap.unpacked/maps/externalmap/nameofmap/libertica_release/libertica_api/en"
    ]
}
```

## Project Structure

I recommend the following project structure if working with the library and not with the single QSB file:

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

This structure simplifies the outsourcing of scripts. The scripts are located in the scripts folder and are only loaded in the main scripts. During development, the absolute path on the system can be specified instead of the path in the map.

`maps/externalmap/mapname/scripts/luafile.lua` - This is a relative path within the games file system.

`C:/Settlers6/mapname/scripts/luafile.lua` - This is an absolute path on your computer.