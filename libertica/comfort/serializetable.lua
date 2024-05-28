Lib.Register("comfort/SerializeTable");

function SerializeTable(_Table)
    local String = "{";
    for k, v in pairs(_Table) do
        local key = (type(k) == "string" and k) or ("[" .. k .. "]");
        if type(v) == "table" then
            String = String .. key .. " = " .. SerializeTable(v) .. ", ";
        elseif type(v) == "number" then
            String = String .. key .. " = " .. v .. ", ";
        elseif type(v) == "string" then
            String = String .. key .. " = \"" .. v .. "\", ";
        elseif type(v) == "boolean" or type(v) == "nil" then
            String = String .. key .. " = " .. tostring(v) .. ", ";
        else
            String = String .. key .. " = \"" .. tostring(v) .. "\", ";
        end
    end
    String = String .. "}";
    return String;
end
API.SerializeTable = SerializeTable;

