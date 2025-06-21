Lib.Register("comfort/ColorToHex");

function ColorToHex(_R, _G, _B, _A)
    _A = _A or 255;
    if (not _R or type(_R) ~= "number")
    or (not _G or type(_G) ~= "number")
    or (not _B or type(_B) ~= "number")
    or (not _A or type(_A) ~= "number") then
        return "";
    end
    if _R < 0 or _R > 255
    or _G < 0 or _G > 255
    or _B < 0 or _B > 255
    or _A < 0 or _A > 255 then
        return "";
    end
    local hex = string.format("#%02X%02X%02X%02X", _R, _G, _B, _A);
    return hex;
end

