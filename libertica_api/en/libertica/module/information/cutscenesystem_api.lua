--- Allows to define cutscenes
---
--- Cutscenes are XML defined camera movemehts that can be played by the
--- game engine. Cutscenes feature smooth camera animations.
---
Lib.CutsceneSystem = Lib.CutsceneSystem or {};



--- Starts a cutscene.
---
--- #### Settings
--- 
--- Possible fields for the cutscene table:
--- * `Starting`                - Function called when cutscene is started              
--- * `Finished`                - Function called when cutscene is finished                 
--- * `EnableGlobalImmortality` - During cutscenes all entities are invulnerable        
--- * `EnableSky`               - Display the sky during the cutscene                   
--- * `EnableFoW`               - Displays the fog of war during the cutscene           
--- * `EnableBorderPins`        - Displays the border pins during the cutscene 
---
--- #### Example
---
--- ```lua
--- function Cutscene1(_Name, _PlayerID)
---     local Cutscene = {};
---     local AP = API.AddCutscenePages(Cutscene);
---
---     -- Pages ...
---
---     Cutscene.Starting = function(_Data)
---     end
---     Cutscene.Finished = function(_Data)
---     end
---     API.StartCutscene(Cutscene, _Name, _PlayerID);
--- end
--- ```
---
--- @param _Cutscene table   Cutscene table
--- @param _Name string      Name of cutscene
--- @param _PlayerID integer Player ID of receiver
function StartCutscene(_Cutscene, _Name, _PlayerID)
end
API.StartCutscene = StartCutscene;

--- Checks if a cutscene ist active.
--- @param _PlayerID integer PlayerID of receiver
--- @return boolean IsActive Briefing is active
function IsCutsceneActive(_PlayerID)
    return true;
end
API.IsCutsceneActive = IsCutsceneActive;

--- Prepares the cutscene and returns the page function.
---
--- Must be called before pages are added.
--- @param _Cutscene table Cutscene table
--- @return function AP  Page function
function AddCutscenePages(_Cutscene)
    return function(...) end;
end
API.AddCutscenePages = AddCutscenePages;

--- Creates a page.
---
--- #### Cutscene Page
--- Possible fields for the page:
---
--- * `Flight`          - Name of flight XML (without .cs)
--- * `Title`           - Displayed page title
--- * `Text`            - Displayed page text
--- * `Action`          - Function called when page is displayed
--- * `FarClipPlane`    - Render distance
--- * `FadeIn`          - Duration of fadein from black
--- * `FadeOut`         - Duration of fadeout to black
--- * `FaderAlpha`      - Mask alpha
--- * `DisableSkipping` - Allow/forbid skipping pages
--- * `BarOpacity`      - Opacity of bars
--- * `BigBars`         - Use big bars
---
--- #### Example
---
--- ```lua
--- AP {
---     Flight       = "c02",
---     FarClipPlane = 45000,
---     Title        = "Title",
---     Text         = "Text of the flight.",
--- };
--- ```
---
--- @param _Data table Page data
function AP(_Data)
    assert(false);
end

