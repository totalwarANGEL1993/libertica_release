--- This module allows to print text to the screen like being typed.
--- 
--- #### How it works
--- The text is put byte by byte to the screen. Each byte becomes a token to
--- be printed. If a special substring (like {cr}) is found, it will become
--- one token instead. The game automatically trims multiple spaces to a
--- single space. The typewriter will also be affected by this.
--- 
--- If used at game start, the typing starts after the loadscreen vanishes.
--- If another cinematic event is running, it must end first.
--- 



--- Displays a text byte by byte.
---
--- #### Fields `_Data`:
--- * `Text`:         <b>string</b> Text to display
--- * `Name`:         (Optional) <b>string</b> Name for event
--- * `PlayerID`:     (Optional) <b>integer</b> Player text is shown
--- * `Callback`:     (Optional) <b>function</b> Callback function
--- * `TargetEntity`: (Optional) <b>string</b> Entity camera is focused on
--- * `CharSpeed`:    (Optional) <b>integer</b> Factor of typing speed (default: 1.0)
--- * `Waittime`:     (Optional) <b>integer</b> Initial waittime before typing
--- * `Opacity`:      (Optional) <b>float</b> Opacity of background (default: 1.0)
--- * `Color`:        (Optional) <b>table</b> Background color (default: {R= 0, G= 0, B= 0})
--- * `Image`:        (Optional) <b>string</b> Background image (needs to be 16:9 ratio)
---
--- #### Example:
--- ```lua
--- local EventName = StartTypewriter {
---     PlayerID = 1,
---     Text     = "Lorem ipsum dolor sit amet, consetetur "..
---                "sadipscing elitr, sed diam nonumy eirmod "..
---                "tempor invidunt ut labore et dolore magna "..
---                "aliquyam erat, sed diam voluptua.",
---     Callback = function(_Data)
---     end
--- };
--- ```
---
--- @param _Data table Data table
--- @return string? EventName Name of event
function StartTypewriter(_Data)
    return "";
end
API.StartTypewriter = StartTypewriter;

