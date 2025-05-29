--- Provides dialog and text windows.



--- opens a large text window with the provided text.
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
--- @param _Caption string Window title
--- @param _Content string Window content
--- @param _PlayerID integer ID of Receiver
function TextWindow(_Caption, _Content, _PlayerID)
end
API.TextWindow = TextWindow;

--- Opens a simple dialog.
---
--- #### Example:
---
--- ```lua
--- DialogInfoBox("Information", "This is important!");
--- ```
--- 
--- @param _PlayerID integer (Optional) ID of receiver
--- @param _Title any Title of window
--- @param _Text any Text of window
--- @param _Action function Action function
function DialogInfoBox(_PlayerID, _Title, _Text, _Action)
end
API.DialogInfoBox = DialogInfoBox;

--- Opens a dialog with a yes/no option.
---
--- #### Example:
---
--- ```lua
--- function YesNoAction(_Yes, _PlayerID)
---     if _Yes then
---         GUI.AddNote("'Yes' has been clicked!");
---     end
--- end
--- DialogRequestBox("Question", "Do you really want to do this?", YesNoAction, false);
--- ```
--- 
--- @param _PlayerID integer (Optional) ID of receiver
--- @param _Title any Title of window
--- @param _Text any Text of window
--- @param _Action function Action function
--- @param _OkCancel boolean Use Okay/Cancel for buttons
function DialogRequestBox(_PlayerID, _Title, _Text, _Action, _OkCancel)
end
API.DialogRequestBox = DialogRequestBox;

--- Opens a dialog with a option box.
---
--- #### Example:
---
--- ```lua
--- function OptionsAction(_Idx, _PlayerID)
---     GUI.AddNote(_Idx.. " was chosen!");
--- end
--- local List = {"Option A", "Option B", "Option C"};
--- DialogSelectBox("Selection", "Choose an option!", OptionsAction, List);
--- ```
--- 
--- @param _PlayerID integer (Optional) ID of receiver
--- @param _Title any Title of window
--- @param _Text any Text of window
--- @param _Action function Action function
--- @param _List table List of options
function DialogSelectBox(_PlayerID, _Title, _Text, _Action, _List)
end
API.DialogSelectBox = DialogSelectBox;

--- Displays the language selection for a player.
--- @param _PlayerID integer ID pf receiver
function DialogLanguageSelection(_PlayerID)
end
API.DialogLanguageSelection = DialogLanguageSelection;

