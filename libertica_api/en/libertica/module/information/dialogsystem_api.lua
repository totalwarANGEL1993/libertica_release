--- Allows to define dialogs
---
--- Dialogs can be used to create conversations between characters using the
--- animated heads in a feature stripped briefing.
---
Lib.DialogSystem = Lib.DialogSystem or {};



--- Starts a dialog.
---
--- #### Settings
---
--- Possible fields for the dialog table:
--- * `Starting`                - Function called when dialog is started              
--- * `Finished`                - Function called when dialog is finished             
--- * `RestoreCamera`           - Camera position is saved and restored at dialog end 
--- * `RestoreGameSpeed`        - Game speed is saved and restored at dialog end      
--- * `EnableGlobalImmortality` - During dialogs all entities are invulnerable        
--- * `EnableSky`               - Display the sky during the dialog                   
--- * `EnableFoW`               - Displays the fog of war during the dialog           
--- * `EnableBorderPins`        - Displays the border pins during the dialog 
---
--- #### Example
---
--- ```lua
--- function Dialog1(_Name, _PlayerID)
---     local Dialog = {
---         DisableFow = true,
---         DisableBoderPins = true,
---     };
---     local AP, ASP = API.AddDialogPages(Dialog);
---
---     -- Pages ...
---
---     Dialog.Starting = function(_Data)
---     end
---     Dialog.Finished = function(_Data)
---     end
---     API.StartDialog(Dialog, _Name, _PlayerID);
--- end
--- ```
---
--- @param _Dialog table     Dialog table
--- @param _Name string      Name of dialog
--- @param _PlayerID integer Player ID of receiver
function StartDialog(_Dialog, _Name, _PlayerID)
end
API.StartDialog = StartDialog;

--- Asks the player for the permission to change graphic settings.
---
--- If the BriefingSystem is loaded, it's functionality will be used.
---
--- This feature is deactivated in Multiplayer.
function RequestDialogAlternateGraphics()
end
API.RequestDialogAlternateGraphics = RequestDialogAlternateGraphics;

--- Checks if a dialog ist active.
--- @param _PlayerID integer PlayerID of receiver
--- @return boolean IsActive Dialog is active
function IsDialogActive(_PlayerID)
    return true;
end
API.IsDialogActive = IsDialogActive;

--- Prepares the dialog and returns the page functions.
---
--- Must be called before pages are added.
--- @param _Dialog table Dialog table
--- @return function AP  Page function
--- @return function ASP Short page function
function AddDialogPages(_Dialog)
    return function(...) end, function(...) end
end
API.AddDialogPages = AddDialogPages;

--- Creates a page.
---
--- #### Dialog Page
--- Possible fields for the page:
---
--- * `Actor`           - (optional) PlayerID of speaker
--- * `Title`           - (optional) Name of actor (only with actor)
--- * `Text`            - (optional) Displayed page text
--- * `Position`        - Position of camera (not with target)
--- * `Target`          - Entity the camera follows (not with position)
--- * `Distance`        - (optional) Distance of camera
--- * `Action`          - (optional) Function called when page is displayed
--- * `FadeIn`          - (optional) Duration of fadein from black
--- * `FadeOut`         - (optional) Duration of fadeout to black
--- * `FaderAlpha`      - (optional) Mask alpha
--- * `MC`              - (optional) Table with choices to branch of in dialogs
---
--- *-> Example #1*
---
--- #### Flow control
--- In a dialog the player can be forced to make a choice that will have
--- different results. That is called multiple choice. Options must be provided
--- in a table. The target page can be defined with it's name or a function can
--- be provided for more control over the flow. Such funktions must return a
--- page name.
---
--- *-> Example #2*
---
--- Additionally each function can be marked to be removed when used
--- and not shown again when reentering the page.
---
--- *-> Example #3*
---
--- Also pages can be hidden by providing a function to check conditions.
---
--- *-> Example #4*
---
--- If a dialog is branched it must be manually ended after a branch is done
--- or it just simply shows the next page. To end a dialog, an empty page
--- must be added.
---
--- *-> Example #5*
---
--- Alternativly the dialog can continue at a different page. This allows to
--- create repeating structures within a dialog.
---
--- *-> Example #6*
---
--- To obtain selected answers at a later point the selection can be saved in a
--- global variable either in a option callback or in the finished function. The
--- number returned is the ID of the answer.
---
--- *-> Example #7*
---
--- #### Examples
---
--- * Example #1: A simple page
--- ```lua
--- AP {
---     Title        = "Hero",
---     Text         = "This page has an actor and a choice.",
---     Actor        = 1,
---     Duration     = 2,
---     FadeIn       = 2,
---     Position     = "npc1",
---     DialogCamera = true,
--- };
--- ```
---
---
--- * Example #2: Usage of multiple choices
--- ```lua
-- AP {
---     Title        = "Hero",
---     Text         = "This page has an actor and a choice.",
---     Actor        = 1,
---     Duration     = 2,
---     FadeIn       = 2,
---     Position     = "npc1",
---     DialogCamera = true,
---     MC = {
---         {"Option 1", "TargetPage"},
---         {"Option 2", Option2Clicked},
---     },
--- };
--- ```
---
---
--- * Example #3: One time usage option
--- ```lua
--- MC = {
---     ...,
---     {"Option 3", "AnotherPage", Remove = true},
--- }
--- ```
---
---
--- * Example #4: Option with condition
--- ```lua
--- MC = {
---     ...,
---     {"Option 3", "AnotherPage", Disable = OptionIsDisabled},
--- }
--- ```
---
---
--- * Example #5: Abort dialog
--- ```lua
--- AP()
--- ```
---
---
--- * Example #6: Jump to other page
--- ```lua
--- AP("SomePageName")
--- ```
---
---
--- * Example #7: Get selected option
--- ```lua
--- Dialog.Finished = function(_Data)
---     MyChoosenOption = _Data:GetPage("Choice"):GetSelected();
--- end
--- ```
---
function AP(_Data)
    assert(false);
end

--- Creates a page in a simplified manner.
---
--- The function can create a automatic page name based of the page index. A
--- name can be an optional parameter at the start.
---
--- #### Settings
--- The function expects the following parameters:
--- 
--- * `Name`           - (Optional) Name of page
--- * `Sender`         - Player ID of actor
--- * `Target`         - Entity the camera is looking at
--- * `Title`          - Displayed page title
--- * `Text`           - Displayed page text
--- * `DialogCamera`   - Use closeup camera
--- * `Action`         - (Optional) Action when page is shown
---
--- #### Examples
---
--- ```lua
--- -- Long shot
--- ASP("Title", "Some important text.", false, "HQ");
--- -- Page Name
--- ASP("Page1", "Title", "Some important text.", false, "HQ");
--- -- Close-Up
--- ASP("Title", "Some important text.", true, "Marcus");
--- -- Call action
--- ASP("Title", "Some important text.", true, "Marcus", MyFunction);
--- -- Allow/forbid skipping
--- ASP("Title", "Some important text.", true, "HQ", nil, true);
--- ```
---
--- @param ... any List of page parameters
function ASP(...)
    assert(false);
end

