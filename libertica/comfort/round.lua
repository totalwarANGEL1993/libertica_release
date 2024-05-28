Lib.Register("comfort/Round");

function Round(_Value, _Decimals)
    _Decimals = math.ceil(_Decimals or 0);
    if _Decimals <= 0 then
        return math.floor(_Value + 0.5);
    end
    return tonumber(string.format("%." .._Decimals.. "f", _Value));
end
API.Round = Round;

