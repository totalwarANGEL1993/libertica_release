Lib.Register("comfort/KeyOf");

function KeyOf(_wert, _table)
    if _table == nil then
        return false;
    end
    for k, v in pairs(_table) do
        if v == _wert then
            return k;
        end
    end
end
API.KeyOf = KeyOf;

