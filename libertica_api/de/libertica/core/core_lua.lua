--- Stellt erweitere Lua-Basisfunktionen bereit.

--- Vergleicht zwei Tabellen mit einer Vergleichsfunktion.
--- @param t1 table Erste Tabelle
--- @param t2 table Zweite Tabelle
--- @param fx function Vergleichsfunktion
--- @return integer Ergebnis Vergleichsergebnis
table.compare = function(t1, t2, fx)
    return 0;
end

--- Gibt zurück, ob zwei Tabellen gleich sind.
--- @param t1 table Erste Tabelle
--- @param t2 table Zweite Tabelle
--- @return boolean Equals Tabellen sind gleich
table.equals = function(t1, t2)
    return true;
end

--- Gibt zurück, ob ein Element in der Tabelle enthalten ist.
--- @param t table Zu prüfende Tabelle
--- @param e any Zu findendes Element
--- @return boolean Found Element ist enthalten
table.contains = function (t, e)
    return false;
end

--- Gibt die Größe des Arrays zurück.
--- @param t table Tabelle
--- @return integer Length Länge
table.length = function(t)
    return 0;
end

--- Gibt die Anzahl aller Elemente zurück.
--- @param t table Tabelle
--- @return integer Size Anzahl der Elemente
table.size = function(t)
    return 0;
end

--- Überprüft, ob die Tabelle leer ist.
--- @param t table Tabelle
--- @return boolean Empty Tabelle ist leer
table.isEmpty = function(t)
    return false;
end

--- Klont eine Tabelle oder fusioniert zwei Tabellen.
--- @param t1 table Erste Tabelle
--- @param t2? table Zweite Tabelle
--- @return table Clone Kopierte Tabelle
table.copy = function (t1, t2)
    return {};
end

--- Gibt ein umgekehrtes Array zurück.
--- @param t1 table Tabelle
--- @return table Invert Umgekehrte Tabelle
table.invert = function (t1)
    return {};
end

--- Fügt ein Element vorne hinzu.
--- @param t table Tabelle
--- @param e any Element
table.push = function (t, e)
end

--- Entfernt das erste Element.
--- @param t table Tabelle
--- @return any Element Element
table.pop = function (t)
    return nil;
end

--- Gibt die Tabelle als Lua-String zurück.
--- @param t table Tabelle
--- @return string Serialized Serialisierte Tabelle
table.tostring = function(t)
    return "";
end

--- Gibt true zurück, wenn der Teilstring gefunden wird.
--- @param self stringlib Zu durchsuchender String
--- @param s string       Teilstring
--- @return boolean Found Teilstring gefunden
string.contains = function (self, s)
    return true;
end

--- Gibt true zurück, wenn der Teilstring gefunden wird.
--- @param self stringlib Zu durchsuchender String
--- @param s string       Teilstring
--- @return integer Beginn Start des Teils
--- @return integer End   Ende des Teils
string.indexOf = function (self, s)
    return 0, 0;
end

--- Trennt einen String in mehrere Teilstrings auf.
--- @param self stringlib Zu durchsuchender String
--- @param _sep string    Trennzeichen
--- @return table Liste    Liste von Teilstrings
string.slice = function(self, _sep)
    return {};
end

--- Verkettet eine Liste von Werten zu einem einzigen String.
---@param self stringlib Zu durchsuchender String
---@param ... any        Werte
---@return string String Ergebnisstring
string.join = function(self, ...)
    return "";
end

--- Ersetzt einen Teilstring durch einen anderen.
--- @param self stringlib Zu durchsuchender String
--- @param p string       Muster
--- @param r string       Ersatz
--- @return string String Neuer String
string.replace = function(self, p, r)
    return "";
end

--- Ersetzt alle Vorkommen eines Teilstrings durch einen anderen.
--- @param self stringlib Zu durchsuchender String
--- @param p string       Muster
--- @param r string       Ersatz
--- @return string String Neuer String
string.replaceAll = function(self, p, r)
    return "";
end

---
--- Linear interpoliert zwischen zwei Werten.
---
--- @param s number Startwert
--- @param c number Aktueller Wert
--- @param e number Endwert
--- @return number Interpolierter Wert
---
math.lerp = function(s, c, e)
    local f = (c - s) / e;
    return (f > 1 and 1) or f;
end

---
--- Berechnet den positiven Modulus einer Zahl.
---
--- @param a number Dividend
--- @param b number Divisor
--- @return number Positiver Modulus
---
math.qmod = function(a, b)
    return a - math.floor(a/b)*b;
end

