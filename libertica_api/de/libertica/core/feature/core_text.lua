--- Bietet Kontrolle über die Ausgabe, Platzhalter für Text und Überschreibungen
--- für Typnamen in der Benutzeroberfläche.
Lib.Core.Text = {}

--- Lokalisiert den übergebenen Text oder die Tabelle.
--- @param _Text any Text zur Lokalisierung
--- @return any Lokalisierter Text
function Localize(_Text)
    return "";
end
API.Localize = Localize;

--- Ersetzt alle Platzhalter innerhalb des Strings durch ihre jeweiligen Werte.
---
--- * {n:xyz} Ersetzt einen Skriptnamen durch einen vordefinierten Wert
--- * {t:xyz} Ersetzt einen Typen durch einen vordefinierten Wert
--- * {v:xyz} Ersetzt eine Variable in _G durch ihren Wert.
--- * {color} Ersetzt den Namen der Farbe durch ihren Farbcode.
--- 
--- Farben:
--- red, blue, yellow, green, white, black, grey, azure, orange, amber, violet,
--- pink, scarlet, magenta, olive, tooltip, none
---
--- @param _Text string Zu formatierender Text
--- @return string Formatierter Text
function ConvertPlaceholders(_Text)
    return "";
end
API.ConvertPlaceholders = ConvertPlaceholders;

--- Gibt eine Nachricht in das Debug-Textfenster aus.
--- @param _Text any Text als String oder Tabelle
function AddNote(_Text)
end
API.Note = AddNote;

--- Gibt eine Nachricht in das Debug-Textfenster aus. Die Nachricht bleibt bestehen, bis sie
--- aktiv entfernt wird.
--- @param _Text any Text als String oder Tabelle
function AddStaticNote(_Text)
end
API.StaticNote = AddStaticNote;

--- Gibt eine Nachricht in das Nachrichtenfenster aus.
--- @param _Text any Text als String oder Tabelle
--- @param _Sound? string Sound zum Abspielen
function AddMessage(_Text, _Sound)
end

--- Entfernt alle Texte aus dem Debug-Textfenster.
function ClearNotes()
end
API.ClearNotes = ClearNotes;

--- Speichert eine Zeichenfolgenüberschreibung unter dem Schlüssel.
--- @param _Key string Schlüssel des Eintrags
--- @param _Text any Text oder lokalisierte Tabelle
function AddStringText(_Key, _Text)
end
API.AddStringText = AddStringText;

--- Löscht die Zeichenfolgenüberschreibung unter dem Schlüssel.
--- @param _Key string Schlüssel des Eintrags
function DeleteStringText(_Key)
end
API.DeleteStringText = DeleteStringText;

--- Gibt den Zeichenfolgentext am Schlüssel zurück.
--- @param _Key string Schlüssel des Eintrags
--- @return string Text Zeichenfolgentext
function GetStringText(_Key)
    return "";
end
API.GetStringText = GetStringText;

--- Fügt eine neue Sprache zur Liste hinzu.
--- @param _Shortcut string Sprachkürzel
--- @param _Name string     Anzeigename der Sprache
--- @param _Fallback string Fallback-Sprachkürzel
--- @param _Index? integer  Listenposition
function DefineLanguage(_Shortcut, _Name, _Fallback, _Index)
end

--- Gibt die geschätzte Anzahl Zeilen zurück, die zur Anzeige benötigt wird.
--- 
--- #### Einordnung:
--- * Länge 4: ABCDEFGHKLMNOPQRSTUVWXYZÄÖÜÁÂÃÅÇÈÉÊËÐÐÑÒÓÔÕÖØÙÚÛÜÝ
--- * Länge 3: abcdeghkmnopqsuvwxyzäöüßIJÆÌÍÎÏÞàáâãåæçèéêëìíîïðñòóôõ÷øùúûüýþÿ
--- * Länge 2: \"#+*~_\\§$%&=?@fijlft
--- * Länge 1: !-/()?',.|[]{}
--- 
--- Alle nicht gelisteten Zeichen werden mit Länge 2 geschätzt.
--- 
--- @param _Text string Text
--- @param _LineLength integer Zeilenlänge
--- @return integer Anzahl Anzahl an Zeilen
function CountTextLines(_Text, _LineLength)
    return 0;
end

