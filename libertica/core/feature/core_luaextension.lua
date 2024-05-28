--- @diagnostic disable: param-type-mismatch
--- @diagnostic disable: return-type-mismatch

Lib.Core = Lib.Core or {};
Lib.Core.LuaExtension = {};

Lib.Require("comfort/CopyTable");
Lib.Require("comfort/SerializeTable");
Lib.Register("core/feature/Core_LuaExtension");

function Lib.Core.LuaExtension:Initialize()
    self:OverrideTable();
    self:OverrideString();
    self:OverrideMath();
end

function Lib.Core.LuaExtension:OnSaveGameLoaded()
    self:OverrideTable();
    self:OverrideString();
    self:OverrideMath();
end

function Lib.Core.LuaExtension:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

function Lib.Core.LuaExtension:OverrideTable()
    --- Compares two tables with a comperator function.
    --- @param t1 table First table
    --- @param t2 table Second table
    --- @param fx function Comparator function
    --- @return integer Result Comparison result
    table.compare = function(t1, t2, fx)
        assert(type(t1) == "table");
        assert(type(t2) == "table");
        fx = fx or function(t1, t2)
            return tostring(t1) < tostring(t2);
        end
        assert(type(fx) == "function");
        return fx(t1, t2);
    end

    --- Returns if two tables are equal.
    --- @param t1 table First table
    --- @param t2 table Second table
    --- @return boolean Equals Tables are equal
    table.equals = function(t1, t2)
        assert(type(t1) == "table");
        assert(type(t2) == "table");
        local fx = function(t1, t2)
            return table.tostring(t1) < table.tostring(t2);
        end
        assert(type(fx) == "function");
        return fx(t1, t2);
    end

    --- Returns if element is contained in table.
    --- @param t table Table to check
    --- @param e any Element to find
    --- @return boolean Found Element is contained
    table.contains = function (t, e)
        assert(type(t) == "table");
        for k, v in pairs(t) do
            if v == e then
                return true;
            end
        end
        return false;
    end

    --- Returns the size of the array.
    --- @param t table Table
    --- @return integer Length Length
    table.length = function(t)
        return #t;
    end

    --- Returns the amount of all elements.
    --- @param t table Table
    --- @return integer Size Element count
    table.size = function(t)
        local c = 0;
        for k, v in pairs(t) do
            -- Ignore n if set
            if k ~= "n" or (k == "n" and type(v) ~= "number") then
                c = c +1;
            end
        end
        return c;
    end

    --- Checks if table is empty
    --- @param t table Table
    --- @return boolean Empty Table is empty
    table.isEmpty = function(t)
        return table.size(t) == 0;
    end

    --- Clones a table or merges two tables.
    --- @param t1 table First table
    --- @param t2? table Second table
    --- @return table Clone Copied table
    table.copy = function (t1, t2)
        t2 = t2 or {};
        assert(type(t1) == "table");
        assert(type(t2) == "table");
        return CopyTable(t1, t2);
    end

    --- Returns a reversed array.
    --- @param t1 table Table
    --- @return table Invert Inverted table
    table.invert = function (t1)
        assert(type(t1) == "table");
        local t2 = {};
        for i= table.length(t1), 1, -1 do
            table.insert(t2, t1[i]);
        end
        return t2;
    end

    --- Adds an element in front.
    --- @param t table Table
    --- @param e any Element
    table.push = function (t, e)
        assert(type(t) == "table");
        table.insert(t, 1, e);
    end

    --- Removes the first element.
    --- @param t table Table
    --- @return any Element Element
    table.pop = function (t)
        assert(type(t) == "table");
        return table.remove(t, 1);
    end

    --- Returns the table as lua string.
    --- @param t table Table
    --- @return string Serialized Serialized table
    table.tostring = function(t)
        return SerializeTable(t);
    end
end

function Lib.Core.LuaExtension:OverrideString()
    --- Returns true if the partial string is found.
    --- @param self stringlib String to search
    --- @param s string       Partial string
    --- @return boolean Found Partial string found
    string.contains = function (self, s)
        return self:find(s) ~= nil;
    end

    --- Returns true if the partial string is found.
    --- @param self stringlib String to search
    --- @param s string       Partial string
    --- @return integer Begin Start of part
    --- @return integer End   End of part
    string.indexOf = function (self, s)
        return self:find(s);
    end

    --- Separates a string into multiple strings.
    --- @param self stringlib String to search
    --- @param _sep string    Separator string
    --- @return table List    List of partial strings
    string.slice = function(self, _sep)
        _sep = _sep or "%s";
        local t = {};
        if self then
            for str in self:gmatch("([^".._sep.."]+)") do
                table.insert(t, str);
            end
        end
        return t;
    end

    ---Concatinates a list of values to a single string.
    ---@param self stringlib String to search
    ---@param ... any        Values
    ---@return string String Resulting string
    string.join = function(self, ...)
        local s = "";
        local parts = {self, ...};
        for i= 1, #parts do
            if type(parts[i]) == "table" then
                s = s .. string.join(unpack(parts[i]));
            else
                s = s .. tostring(parts[i]);
            end
        end
        return s;
    end

    --- Replaces a substring with another once.
    --- @param self stringlib String to search
    --- @param p string       Pattern
    --- @param r string       Replacement
    --- @return string String New string
    string.replace = function(self, p, r)
        local s, c = self:gsub(p, r, 1);
        return s;
    end

    --- Replaces all occurances of a substring with another.
    --- @param self stringlib String to search
    --- @param p string       Pattern
    --- @param r string       Replacement
    --- @return string String New string
    string.replaceAll = function(self, p, r)
        local s, c = self:gsub(p, r);
        return s;
    end
end

function Lib.Core.LuaExtension:OverrideMath()
    math.lerp = function(s, c, e)
        local f = (c - s) / e;
        return (f > 1 and 1) or f;
    end

    math.qmod = function(a, b)
        return a - math.floor(a/b)*b;
    end
end

