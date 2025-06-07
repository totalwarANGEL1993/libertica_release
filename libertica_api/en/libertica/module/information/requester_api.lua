--- Provides dialog and text window functions.
---
--- #### Info Dialog
--- A simple window for displaying information. The window must be confirmed
--- with OK and can then execute a function.
---
--- #### Confirmation Dialog
--- A simple window for a binary decision. The window can be closed with
--- Yes/No or OK/Cancel. In the callback function, the chosen option
--- can be distinguished.
---
--- #### Selection Dialog
--- A window with some text and a dropdown menu. An option can be selected
--- from the menu and then confirmed with OK. The callback can use the selected
--- option to take action accordingly.
---
--- #### Language Selection Dialog
--- A special selection dialog that sets the language for user texts.
--- Use this dialog if your map is multilingual. When a language is chosen,
--- an event is triggered.
---
--- #### Text Window
--- A modified version of the chat log for displaying a longer text.
--- When the window is closed, a callback function can be executed.
--- Optionally, a button can be shown below the text. The button has its own
--- callback function.



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

