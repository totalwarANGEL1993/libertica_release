Lib = {
    Loader = {
        Paths = {
            -- Search in script directory
            "script/",
        },

        Version = "LIB 1.0.3",
        Root = "libertica",
        IsLocalEnv = GUI ~= nil,
        IsHistoryEdition = false,

        Sources = {},
        Loaded = {},
    },
};
-- Prevent the null reference bug
if Framework and Network then
    -- Search for files in map file
    local name = Framework.GetCurrentMapName();
    table.insert(Lib.Loader.Paths, 1, "maps/externalmap/" ..name.. "/");
    -- Check for History Edition
    Lib.Loader.IsHistoryEdition = Network.IsNATReady ~= nil;
end

API = {};
QSB = {};

--- @diagnostic disable: duplicate-set-field

--- Loads a component at the given relative path.
---
--- Must be called before questsystembehavior.lua is loaded (if loaded).
---
--- If the path does contain "/global/" or "/local/" then the operation will
--- be aborted if the environment does not match. Scripts outside of those
--- folders will be treated as shared scripts and are always loaded.
---
--- @param _Path string Relative path
function Lib.Loader.Require(_Path)
    _Path = _Path:lower();
    local key = _Path:gsub("/", "_");

    -- Do not load globals in local
    if Lib.Loader.IsLocalEnv == true and _Path:find("/global/") then
        return;
    end
    -- Do not load locals in global
    if Lib.Loader.IsLocalEnv == false and _Path:find("/local/") then
        return;
    end

    for i= 1, #Lib.Loader.Paths do
        if not Lib.Loader.Loaded[key] then
            Lib.Loader.Sources[key] = Lib.Loader.Paths[i];
            Lib.Loader.LoadSourceFile(Lib.Loader.Paths[i], _Path);
        end
    end
    assert(Lib.Loader.Loaded[key] ~= nil, "\nFile not found: \n".._Path);
    Lib.Loader.Sources[key] = nil;
end
Lib.Require = Lib.Loader.Require;

--- Adds a custom path at the top of the search order.
--- @param _Path string Relative path
function Lib.Loader.PushPath(_Path)
    table.insert(Lib.Loader.Paths, 1, _Path:lower());
end

--- DO NOT USE THIS MANUALLY!
--- Registers a component as found.
--- @param _Path string Relative path
function Lib.Loader.Register(_Path)
    local key = _Path:gsub("/", "_"):lower();
    Lib.Loader.Loaded[key] = Lib.Loader.Sources[key] .. Lib.Loader.Root .. "/";
end
Lib.Register = Lib.Loader.Register;

--- DO NOT USE THIS MANUALLY!
--- Loads the component from the source folder.
--- @param _Source string Path where the component is loaded from
--- @param _Path string   Relative path of component
function Lib.Loader.LoadSourceFile(_Source, _Path)
    local path = _Source .. Lib.Loader.Root .. "/" .._Path:lower();
    Script.Load(path.. ".lua");
end

