--- Bietet Dialog- und Textfenster-Funktionen.



--- Öffnet ein großes Textfenster mit dem bereitgestellten Text.
---
--- #### Example:
---
--- ```lua
--- local Text = "Lorem ipsum dolor sit amet, consetetur".."..
---              " sadipscing elitr, sed diam nonumy eirmod"..
---              " tempor invidunt ut labore et dolore magna"..
---              " magna aliquyam erat, sed diam voluptua.";
--- TextWindow("Lorem ipsum", Text);
--- ```
--- 
--- @param _Caption string Fenstertitel
--- @param _Content string Fensterinhalt
--- @param _PlayerID integer ID des Empfängers
function TextWindow(_Caption, _Content, _PlayerID)
end
API.TextWindow = TextWindow;

--- Öffnet einen einfachen Dialog.
---
--- #### Example:
---
--- ```lua
--- DialogInfoBox("Information", "Das ist wichtig!");
--- ```
--- 
--- @param _PlayerID integer (Optional) ID des Empfängers
--- @param _Title any Titel des Fensters
--- @param _Text any Text des Fensters
--- @param _Action function Aktionsfunktion
function DialogInfoBox(_PlayerID, _Title, _Text, _Action)
end
API.DialogInfoBox = DialogInfoBox;

--- Öffnet einen Dialog mit einer Ja/Nein-Option.
---
--- #### Example:
---
--- ```lua
--- function YesNoAction(_Ja, _PlayerID)
---     if _Ja then
---         GUI.AddNote("'Ja' wurde angeklickt!");
---     end
--- end
--- DialogRequestBox("Frage", "Möchtest du das wirklich tun?", YesNoAction, false);
--- ```
--- 
--- @param _PlayerID integer (Optional) ID des Empfängers
--- @param _Title any Titel des Fensters
--- @param _Text any Text des Fensters
--- @param _Action function Aktionsfunktion
--- @param _OkCancel boolean Verwenden Sie Okay/Abbrechen für Schaltflächen
function DialogRequestBox(_PlayerID, _Title, _Text, _Action, _OkCancel)
end
API.DialogRequestBox = DialogRequestBox;

--- Öffnet einen Dialog mit einer Optionsbox.
---
--- #### Example:
---
--- ```lua
--- function OptionsAction(_Idx, _PlayerID)
---     GUI.AddNote(_Idx.. " wurde ausgewählt!");
--- end
--- local List = {"Option A", "Option B", "Option C"};
--- DialogSelectBox("Auswahl", "Wähle eine Option!", OptionsAction, List);
--- ```
--- 
--- @param _PlayerID integer (Optional) ID des Empfängers
--- @param _Title any Titel des Fensters
--- @param _Text any Text des Fensters
--- @param _Action function Aktionsfunktion
--- @param _List table Liste der Optionen
function DialogSelectBox(_PlayerID, _Title, _Text, _Action, _List)
end
API.DialogSelectBox = DialogSelectBox;

--- Zeigt die Sprachauswahl für einen Spieler an.
--- @param _PlayerID integer ID des Empfängers
function DialogLanguageSelection(_PlayerID)
end
API.DialogLanguageSelection = DialogLanguageSelection;

