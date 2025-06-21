Lib = {
    Loader = {
        Paths = {
            -- Search in script directory
            "script/",
        },

        Version = "LIB 1.3.2",
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
    local Name = Framework.GetCurrentMapName();
    table.insert(Lib.Loader.Paths, 1, "maps/externalmap/" ..Name.. "/");
    -- Check for History Edition
    Lib.Loader.IsHistoryEdition = Network.IsNATReady ~= nil;
end

API = {};
QSB = {};

--- @diagnostic disable: cast-local-type
--- @diagnostic disable: duplicate-set-field
--- @diagnostic disable: missing-return-value

function Lib.Loader.PushPath(_Path)
end

function Lib.Loader.Require(_Path)
end
Lib.Require = Lib.Loader.Require;

function Lib.Loader.Register(_Path)
end
Lib.Register = Lib.Loader.Register;

function Lib.Loader.LoadSourceFile(_Source, _Path)
end

