Lib.Require("comfort/HexToColor");
Lib.Register("comfort/HexToColorString");

function HexToColorString(_Hex)
    local r,g,b,a = HexToColor(_Hex);
    if r == -1 then
        return "";
    end
    return string.format("{@color:%d,%d,%d,%d}", r, g, b, a);
end

