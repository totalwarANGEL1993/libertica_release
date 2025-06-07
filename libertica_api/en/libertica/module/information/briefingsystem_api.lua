--- Allows the definition of briefings.
---
--- The pinnacle for scripting dialogs and simple camera animations.
--- A versatile tool for scripting map presentations.
---

--- Initializes the builder for a briefing.
---
--- #### Functions `BriefingBuilder`:
--- * `SetName(_Name)`:              Sets the name of the briefing.
--- * `SetPlayer(_Player)`:          Sets the receiving player of the briefing.
--- * `UseBigBars(_Flag)`:           Uses the wide briefing bars.
--- * `UseRestoreCamera(_Flag)`:     Restores the camera to its original position after the briefing.
--- * `UseRestoreGameSpeed(_Flag)`:  Restores game speed after the briefing.
--- * `UseGlobalImmortality(_Flag)`: All entities are invulnerable during the briefing.
--- * `UseFarClipping(_Flag)`:       Uses a wide field of view. <b>Attention</b>: May cause stuttering on low-end systems.
--- * `SetHideNotes(_Flag)`:         Hides the notes window during the briefing.
--- * `SetEnableSky(_Flag)`:         Displays the sky during the briefing.
--- * `SetEnableFoW(_Flag)`:         Displays fog of war during the briefing.
--- * `SetEnableBorderPins(_Flag)`:  Displays border pins during the briefing.
--- * `SetOnBegin(_Function)`:       Function called at the start of the briefing.
--- * `SetOnFinish(_Function)`:      Function called at the end of the briefing.
--- * `BeginPage()`:                 Opens the `PageBuilder`.
--- * `Redirect(_Target)`:           Jumps to the page with the specified name. If not specified, ends the briefing here.
--- * `Start()`:                     Starts the briefing.
---
--- #### Functions `PageBuilder`:
---
--- A briefing can have unlimited pages.
--- * `SetName(_Name)`:            Sets the name of the page.
--- * `SetSpeech(_Speech)`:        Sets the path to the voice line.
--- * `SetTitle(_Title)`:          Sets the title to be displayed on the page.
--- * `SetText(_Text)`:            Sets the text to be displayed on the page.
--- * `SetDuration(_Duration)`:    Sets how long the page is displayed.
--- * `SetFadeIn(_Time)`:          Fades in from black.
--- * `SetFadeOut(_Time)`:         Fades out to black.
--- * `SetFaderAlpha(_Opacity)`:   Sets the alpha value of the fade mask.
--- * `SetAction(_Action)`:        Function executed whenever the page is shown.
--- * `UseBigBars(_Flag)`:         Uses wide briefing bars on this page.
--- * `UsePerformanceMode(_Flag)`: Disables some graphics effects to improve performance.
--- * `UseSkipping(_Flag)`:        Allows skipping this page.
--- * `BeginCamera()`:             Opens the `CameraBuilder`.
--- * `BeginCameraAnimation()`:    Opens the `CameraAnimationBuilder`.
--- * `BeginParallaxAnimation()`:  Opens the `ParallaxAnimationBuilder`.
--- * `BeginChoice()`:             Opens the `ChoiceBuilder`.
--- * `EndPage()`:                 Ends the `PageBuilder` and returns to the `BriefingBuilder`.
---
--- #### Functions `CameraBuilder`:
---
--- * `UseCloseUp(_Flag)`:      Switches to close-up or distant view.
--- * `SetPosition(_Position)`: Sets the camera position.
--- * `SetAngle(_Angle)`:       Sets the camera elevation angle.
--- * `SetRotation(_Rotation)`: Sets the camera rotation angle.
--- * `SetZoom(_Zoom)`:         Sets the camera zoom.
--- * `BeginFlyTo()`:           Opens the `FlyToBuilder`.
--- * `EndCamera()`:            Ends the `CameraBuilder` and returns to the `PageBuilder`.
---
--- #### Functions `FlyToBuilder`:
---
--- * `SetPosition(_Position)`: Sets the camera position.
--- * `SetAngle(_Angle)`:       Sets the camera elevation angle.
--- * `SetRotation(_Rotation)`: Sets the camera rotation angle.
--- * `SetZoom(_Zoom)`:         Sets the camera zoom.
--- * `EndFlyTo()`:             Ends the `FlyToBuilder` and returns to the `CameraBuilder`.
---
--- #### Functions `ChoiceBuilder`:
---
--- * `Option(_ID?, _Text, _Target, _Condition?)`: Adds a new choice. (Parameters marked with ? are optional)
--- * `EndChoice()`:                               Ends the `ChoiceBuilder` and returns to the `PageBuilder`.
---
--- #### Functions `CameraAnimationBuilder`:
---
--- * `SetRepeat(_Flag)`:          Repeats the animations after they end.
--- * `SetClear(_Flag)`:           Removes all running animations from the queue.
--- * `SetPostpone(_Flag)`:        Postpones all running animations.
--- * `BeginAnimationSet()`:       Begins the `AnimationSetBuilder`.
--- * `EndCameraAnimation()`:      Ends the `CameraAnimationBuilder` and returns to the `PageBuilder`.
---
--- #### Functions `AnimationSetBuilder`:
---
--- * `SetDuration(_Duration)`:                  Sets the duration of the animation.
--- * `SetLocal(_Flag)`:                         The animation is bound to the page.
--- * `Animation(_px, _py, _pz, _lx, _ly, _lz)`: Coordinates for position and look-at target of the camera.
--- * `EndAnimationSet()`:                       Ends the `AnimationSetBuilder` and returns to the `CameraAnimationBuilder`.
---
--- #### Functions `ParallaxAnimationBuilder`:
---
--- * `SetRepeat(_Flag)`:       Repeats the animations after they end.
--- * `SetClear(_Flag)`:        Removes all running animations from the queue.
--- * `SetPostpone(_Flag)`:     Postpones all running animations.
--- * `BeginLayer()`:           Begins the `LayerBuilder`.
--- * `EndParallaxAnimation()`: Ends the `ParallaxAnimationBuilder` and returns to the `PageBuilder`.
---
--- #### Functions `LayerBuilder`:
---
--- Up to 6 different layers can exist.
--- * `SetDuration(_Duration)`:            Sets the duration of the animation.
--- * `SetImage(_Image)`:                  Path to the displayed image.
--- * `SetLocal(_Flag)`:                   The animation is bound to the page.
--- * `Animation(_u0, _v0, _u1, _v1, _a)`: Coordinates and alpha value of the displayed graphic portion (coordinates between 0 and 1).
--- * `EndLayer()`:                        Ends the `LayerBuilder` and returns to the `ParallaxAnimationBuilder`.
---
--- #### Example:
--- Create a simple briefing that uses the dialog camera.
--- ```lua
--- NewBriefing("TestBriefing", 1)
---     :BeginPage()
---         :SetTitle("Title")
---         :SetText("This is a test page.")
---         :BeginCamera()
---             :SetPosition("Hakim")
---             :UseCloseUp(true)
---         :EndCamera()
---     :EndPage()
---     :Start();
--- ```
---
--- #### Example:
--- Create a simple briefing with a basic camera movement.
--- ```lua
--- NewBriefing("TestBriefing", 1)
---     :BeginPage()
---         :SetTitle("Title")
---         :SetText("This is a test page.")
---         :BeginCamera()
---             :SetPosition("Hakim")
---             :SetRotation(90)
---             :SetAngle(50)
---             :SetZoom(3000)
---             :BeginFlyTo()
---                 :SetPosition("Saraya")
---                 :SetRotation(-90)
---                 :SetAngle(20)
---                 :SetZoom(3000)
---             :EndFlyTo()
---         :EndCamera()
---     :EndPage()
---     :Start();
--- ```
---
--- #### Example:
--- Create a briefing using complex camera animations. The function
--- `Animation` can be used with direct coordinates, or use
--- names to determine coordinates. A negative number indicates an absolute height,
--- while a positive number is an offset from the entity height.
--- ```lua
--- NewBriefing("TestBriefing", 1)
---     :BeginPage()
---         :SetTitle("Title")
---         :SetText("This is a test page.")
---         :BeginCameraAnimation()
---             :SetClear(true)
---             :BeginAnimationSet()
---                 :SetDuration(30)
---                 :SetLocal(true)
---                 :Animation("Pos1", -2500, "npc1", -2200)
---                 :Animation("Pos2", -2500, "npc1", -2000)
---             :EndAnimationSet()
---         :EndCameraAnimation()
---     :EndPage()
---     :Start();
--- ```

--- @param _Name string Name of the briefing
--- @param _PlayerID integer Player ID of the receiver
--- @return table BriefingBuilder Builder of the briefing
function NewBriefing(_Name, _PlayerID)
    return {};
end
API.NewBriefing = NewBriefing;

--- Checks whether a briefing is active.
--- @param _PlayerID integer Player ID of the receiver
--- @return boolean IsActive Briefing is active
function IsBriefingActive(_PlayerID)
    return true;
end
API.IsBriefingActive = IsBriefingActive;

--- Starts a briefing.
--- <p>
--- <b>Attention</b>: This function is deprecated and can only be used with the
--- declarative API.
---
--- #### Fields `_Briefing`:
--- * `Starting`:                (optional) <b>function</b> Called at the beginning of the briefing
--- * `Finished`:                (optional) <b>function</b> Called at the end of the briefing
--- * `RestoreCamera`:           (optional) <b>boolean</b> Saves and restores the camera position at the end
--- * `RestoreGameSpeed`:        (optional) <b>boolean</b> Saves and restores game speed at the end
--- * `EnableGlobalImmortality`: (optional) <b>boolean</b> All entities are invulnerable during the briefing
--- * `EnableSky`:               (optional) <b>boolean</b> Displays the sky during the briefing
--- * `EnableFoW`:               (optional) <b>boolean</b> Displays fog of war during the briefing
--- * `EnableBorderPins`:        (optional) <b>boolean</b> Displays the border pins during the briefing
--- * `PreloadAssets`:           (optional) <b>boolean</b> Allows far clipping in briefings
--- * `HideNotes`:               (optional) <b>boolean</b> Hides messages
---
function StartBriefing(_Briefing, _Name, _PlayerID)
end
API.StartBriefing = StartBriefing;

--- Prepares the briefing and returns the page functions.
--- <p>
--- <b>Attention</b>: This function is deprecated and can only be used with the
--- declarative API.
---
--- Must be called before pages are added.
--- 
--- @param _Briefing table Briefing table
--- @return function AP  Page function
--- @return function ASP Simplified page function
function AddBriefingPages(_Briefing)
    return function() end, function() end;
end
API.AddBriefingPages = AddBriefingPages;

--- Creates a page.
--- <p>
--- <b>Attention</b>: This function is deprecated and can only be used with the
--- declarative API.
---
--- @param _Data table Page data
--- @return table Page Created page
function AP(_Data)
    return {};
end

--- Creates a simplified page.
--- <p>
--- <b>Attention</b>: This function is deprecated and can only be used with the
--- declarative API.
---
--- @param _Name? string Optional name of the page
--- @param _Title string Displayed page title
--- @param _Text string Displayed page text
--- @param _DialogCamera boolean Use close-up camera
--- @param _Position? string Script name of the focused entity
--- @param _Action? function Function executed when the page is shown
--- @return table Page Created page
function ASP(...)
    return {};
end

