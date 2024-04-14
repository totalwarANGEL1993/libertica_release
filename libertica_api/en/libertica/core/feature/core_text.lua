--- Provides control over output, placeholders for text and overwrites for
--- type names in the interface.
Lib.Core.Text = {}

--- Localizes the passed text or table. 
--- @param _Text any Text to localize
--- @return string Localized Localized text
function Localize(_Text)
    return "";
end
API.Localize = Localize;

--- Replaces all placeholders inside the string with their respective values.
---
--- * {n:xyz} Replaces a scriptname with a predefined value
--- * {t:xyz} Replaces a type with a predefined value
--- * {v:xyz} Replaces a variable in _G with it's value.
--- * {color} Replaces the name of the color with it's color code.
--- 
--- Colors:
--- red, blue, yellow, green, white, black, grey, azure, orange, amber, violet,
--- pink, scarlet, magenta, olive, tooltip, none
---
--- @param _Text string Text to format
--- @return string Formatted Formatted text
function ConvertPlaceholders(_Text)
    return "";
end
API.ConvertPlaceholders = ConvertPlaceholders;

--- Prints a message into the debug text window.
--- @param _Text any Text as string or table
function AddNote(_Text)
end
API.Note = AddNote;

--- Prints a message into the debug text window. The messages stays until it
--- is actively removed.
--- @param _Text any Text as string or table
function AddStaticNote(_Text)
end
API.StaticNote = AddStaticNote;

--- Prints a message into the message window.
--- @param _Text any Text as string or table
--- @param _Sound? string Sound to play
function AddMessage(_Text, _Sound)
end

---Removes all text from the debug text window.
function ClearNotes()
end
API.ClearNotes = ClearNotes;

--- Saves a string text overwrite at the key.
--- @param _Key string Key of entry
--- @param _Text any Text or localized Table
function AddStringText(_Key, _Text)
end
API.AddStringText = AddStringText;

--- Deletes the string text overwrite at the key.
--- @param _Key string Key of entry
function DeleteStringText(_Key)
end
API.DeleteStringText = DeleteStringText;

--- Returns the String text at the key.
--- @param _Key string Key of entry
--- @return string Text String text
function GetStringText(_Key)
    return "";
end
API.GetStringText = GetStringText;

--- Adds a new language to the list.
--- @param _Shortcut string Language shortcut
--- @param _Name string     Display name of language
--- @param _Fallback string Fallback language shortcut
--- @param _Index? integer  List position
function DefineLanguage(_Shortcut, _Name, _Fallback, _Index)
end

