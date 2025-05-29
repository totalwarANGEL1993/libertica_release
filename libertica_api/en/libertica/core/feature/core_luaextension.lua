--- Adds additional functionality to table, string and math API.

--- Compares two tables with a comperator function.
--- @param t1 table First table
--- @param t2 table Second table
--- @param fx function Comparator function
--- @return integer Result Comparison result
table.compare = function(t1, t2, fx)
    return 0;
end

--- Returns if two tables are equal.
--- @param t1 table First table
--- @param t2 table Second table
--- @return boolean Equals Tables are equal
table.equals = function(t1, t2)
    return true;
end

--- Returns if element is contained in table.
--- @param t table Table to check
--- @param e any Element to find
--- @return boolean Found Element is contained
table.contains = function (t, e)
    return false;
end

--- Returns the size of the array.
--- @param t table Table
--- @return integer Length Length
table.length = function(t)
    return 0;
end

--- Returns the amount of all elements.
--- @param t table Table
--- @return integer Size Element count
table.size = function(t)
    return 0;
end

--- Checks if table is empty
--- @param t table Table
--- @return boolean Empty Table is empty
table.isEmpty = function(t)
    return false;
end

--- Clones a table or merges two tables.
--- @param t1 table First table
--- @param t2? table Second table
--- @return table Clone Copied table
table.copy = function (t1, t2)
    return {};
end

--- Returns a reversed array.
--- @param t1 table Table
--- @return table Invert Inverted table
table.invert = function (t1)
    return {};
end

--- Adds an element in front.
--- @param t table Table
--- @param e any Element
table.push = function (t, e)
end

--- Removes the first element.
--- @param t table Table
--- @return any Element Element
table.pop = function (t)
    return nil;
end

--- Returns the table as lua string.
--- @param t table Table
--- @return string Serialized Serialized table
table.tostring = function(t)
    return "";
end


--- Returns true if the partial string is found.
--- @param self stringlib String to search
--- @param s string       Partial string
--- @return boolean Found Partial string found
string.contains = function (self, s)
    return true;
end

--- Returns true if the partial string is found.
--- @param self stringlib String to search
--- @param s string       Partial string
--- @return integer Begin Start of part
--- @return integer End   End of part
string.indexOf = function (self, s)
    return 0, 0;
end

--- Separates a string into multiple strings.
--- @param self stringlib String to search
--- @param _sep string    Separator string
--- @return table List    List of partial strings
string.slice = function(self, _sep)
    return {};
end

---Concatinates a list of values to a single string.
---@param self stringlib String to search
---@param ... any        Values
---@return string String Resulting string
string.join = function(self, ...)
    return "";
end

--- Replaces a substring with another once.
--- @param self stringlib String to search
--- @param p string       Pattern
--- @param r string       Replacement
--- @return string String New string
string.replace = function(self, p, r)
    return "";
end

--- Replaces all occurances of a substring with another.
--- @param self stringlib String to search
--- @param p string       Pattern
--- @param r string       Replacement
--- @return string String New string
string.replaceAll = function(self, p, r)
    return "";
end

---
--- Linearly interpolates between two values.
---
--- @param s number Starting value
--- @param c number Current value
--- @param e number End value
--- @return number Interpolated value
---
math.lerp = function(s, c, e)
    local f = (c - s) / e;
    return (f > 1 and 1) or f;
end

---
--- Calculates the positive modulus of a number.
---
--- @param a number Dividend
--- @param b number Divisor
--- @return number Positive modulus
---
math.qmod = function(a, b)
    return a - math.floor(a/b)*b;
end

