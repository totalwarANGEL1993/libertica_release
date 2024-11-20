Lib.Register("comfort/HexToColor");

function HexToColor(_Hex)
    local shortHex;
    local hex = string.gsub(_Hex, "#", "");
    if string.len(hex) == 3 or string.len(hex) == 4 then
        shortHex, hex = hex, "";
        for i = 1, #shortHex do
            local char = shortHex:sub(i, i);
            hex = hex .. char .. char;
        end
    end
    if string.len(hex) ~= 6 and string.len(hex) ~= 8 then
        return -1;
    end
    local r = tonumber(string.sub(hex, 1, 2), 16);
    local g = tonumber(string.sub(hex, 3, 4), 16);
    local b = tonumber(string.sub(hex, 5, 6), 16);
    local a = 255;
    if string.len(hex) == 8 then
        a = tonumber(string.sub(hex, 7, 8), 16);
    end
    if not a or not g or not b or not a then
        return -1;
    end
    return r, g, b, a;
end

