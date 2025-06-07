--- Allows defining cutscenes.
---
--- Cutscenes are XML-defined camera movements that can be played
--- by the game engine. Cutscenes are characterized by
--- smooth camera transitions.
---

--- Initializes the builder for a cutscene.
--- 
--- #### Functions `CutsceneBuilder`:
--- * `SetName(_Name)`:              Sets the name of the cutscene.
--- * `SetPlayer(_Player)`:          Sets the receiving player of the cutscene.
--- * `UseBigBars(_Flag)`:           Uses wide briefing bars. (Not recommended for aesthetic reasons.)
--- * `UseGlobalImmortality(_Flag)`: All entities are invulnerable during the cutscene.
--- * `SetHideNotes(_Flag)`:         Hides the notes window during the cutscene.
--- * `SetEnableSky(_Flag)`:         Shows the sky during the cutscene.
--- * `SetEnableFoW(_Flag)`:         Shows the fog of war during the cutscene.
--- * `SetEnableBorderPins(_Flag)`:  Shows the border markers during the cutscene.
--- * `SetOnBegin(_OnBegin)`:        Function executed at the start of the cutscene.
--- * `SetOnFinish(_OnFinish)`:      Function executed at the end of the cutscene.
--- * `BeginFlight()`:               Opens the `FlightBuilder`.
--- * `Start()`:                     Starts the cutscene.
---
--- #### Functions `FlightBuilder`:
--- * `SetSpeech(_Speech)`:         Sets the path to the voice line.
--- * `SetTitle(_Title)`:           Sets the title of the page.
--- * `SetText(_Text)`:             Sets the text of the page.
--- * `SetFadeIn(_Time)`:           Fades in from black.
--- * `SetFadeOut(_Time)`:          Fades out to black.
--- * `SetFaderAlpha(_Opacity)`:    Sets the alpha value of the fade mask.
--- * `UseBigBars(_Flag)`:          Uses wide cutscene bars on this page. (Not recommended for aesthetic reasons.)
--- * `UseSkipping(_Flag)`:         The page can be skipped.
--- * `SetFarClipPlane(_Distance)`: Sets the maximum viewing distance. <b>Warning</b>: May stutter on weak systems.
--- * `EndFlight()`:                Ends the `FlightBuilder` and returns to the `CutsceneBuilder`.
--- 
--- #### Example:
--- ```lua
--- NewCutscene("TestCutscene", 1)
---     :SetEnableBorderPins(true)
---     :SetEnableSky(true)
---     :BeginFlight()
---         :SetFlight("c01")
---         :SetTitle("Flight 1")
---         :SetText("This is the shown text.")
---         :SetFadeIn(3)
---     :EndFlight()
---     :BeginFlight()
---         :SetFlight("c02")
---         :SetTitle("Flight 2")
---         :SetText("This is the shown text.")
---     :EndFlight()
---     :BeginFlight()
---         :SetFlight("c03")
---         :SetTitle("Flight 3")
---         :SetText("This is the shown text.")
---         :SetFadeOut(3)
---     :EndFlight()
---     :Start();
--- ``` 
---  
--- @param _Name string Name of the cutscene
--- @param _PlayerID integer Player ID of the receiver
--- @return table BriefingBuilder Builder for the cutscene
function NewCutscene(_Name, _PlayerID)
    return {};
end
API.NewCutscene = NewCutscene;

--- Checks if a cutscene is active.
--- @param _PlayerID integer Player ID of the receiver
--- @return boolean IsActive Cutscene is active
function IsCutsceneActive(_PlayerID)
    return true;
end
API.IsCutsceneActive = IsCutsceneActive;

--- Starts a cutscene.
--- <p>
--- <b>Warning</b>: This function is deprecated and can only be used
--- with the declarative API.
---
--- #### Fields `_Cutscene`:
--- * `Starting`:                (optional) <b>function</b> Function called at the beginning of the intro              
--- * `Finished`:                (optional) <b>function</b> Function called at the end of the intro                
--- * `EnableGlobalImmortality`: (optional) <b>boolean</b> All entities are invulnerable during intros        
--- * `EnableSky`:               (optional) <b>boolean</b> Shows the sky during the intro                   
--- * `EnableFoW`:               (optional) <b>boolean</b> Shows the fog of war during the intro 
--- * `EnableBorderPins`:        (optional) <b>boolean</b> Shows the border pins during the intro     
--- * `HideNotes`:               (optional) <b>boolean</b> Do not show messages
---
--- #### Example:
--- ```lua
--- function Cutscene1(_Name, _PlayerID)
---     local Cutscene = {};
---     local AP = API.AddCutscenePages(Cutscene);
---     -- Pages
---     Cutscene.Starting = function(_Data)
---     end
---     Cutscene.Finished = function(_Data)
---     end
---     API.StartCutscene(Cutscene, _Name, _PlayerID);
--- end
--- ```
---
--- @param _Cutscene table   Cutscene table
--- @param _Name string      Name of the cutscene
--- @param _PlayerID integer Player ID of the receiver
function StartCutscene(_Cutscene, _Name, _PlayerID)
end
API.StartCutscene = StartCutscene;

--- Prepares the cutscene and returns the page function.
--- <p>
--- <b>Warning</b>: This function is deprecated and can only be used
--- with the declarative API.
---
--- Must be called before adding pages.
--- @param _Cutscene table Cutscene table
--- @return function AP  Page function
function AddCutscenePages(_Cutscene)
    return function(...) end;
end
API.AddCutscenePages = AddCutscenePages;

--- Creates a page.
--- <p>
--- <b>Warning</b>: This function is deprecated and can only be used
--- with the declarative API.
---
--- #### Fields `_Data`:
--- * `Flight`:          <b>string</b> Name of the flight XML (without .cs)
--- * `Title`:           (optional) <b>any</b> Displayed page title (String or language table)
--- * `Text`:            (optional) <b>any</b> Displayed page text (String or language table)
--- * `Speech`:          (optional) <b>string</b> Path to voiceover (MP3 file)
--- * `Action`:          (optional) <b>function</b> Function called when the page is shown
--- * `FarClipPlane`:    (optional) <b>boolean</b> Render distance
--- * `FadeIn`:          (optional) <b>float</b> Duration of fade-in from black
--- * `FadeOut`:         (optional) <b>float</b> Duration of fade-out to black
--- * `FaderAlpha`:      (optional) <b>float</b> Mask alpha
--- * `DisableSkipping`: (optional) <b>boolean</b> Allow/prevent skipping pages
--- * `BarOpacity`:      (optional) <b>float</b> Bar opacity
--- * `BigBars`:         (optional) <b>boolean</b> Use large bars
---
--- #### Example:
--- ```lua
--- AP {
---     Flight       = "c02",
---     FarClipPlane = 45000,
---     Title        = "Title",
---     Text         = "Flight text.",
--- };
--- ```
---
--- @param _Data table Page data
--- @return table Page Created page
function AP(_Data)
    return {};
end

