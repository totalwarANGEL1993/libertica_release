--- Dieses Modul ermöglicht die Anzeige eines Textes im Schreibmaschienstil.
--- 
--- #### Funktionsweise
--- Der Text wir Zeichenweise auf dem Bildschirm ausgegeben. Dabei wird der
--- Text in Token zerlegt. Normale Zeichen ergeben jeweils ein Token. Wird
--- eine spezielle Zeichenkette (z.B. {cr}) gefunden, wird diese als ein 
--- Token behandelt. Mehrere Leerzeichen hindereinander werden (innerhalb
--- der Engine) zu einem Leerzeichen verkürzt.
--- 
--- Wenn bei Spielstart verwendet, beginnt der Text nach dem Laden der Karte.
--- Wenn ein anderes Kino-Event läuft, wartet der Typewriter auf den Abschluss.



--- Zeigt einen Text Zeichen für Zeichen an.
---
---
--- #### Fields `_Data`:
--- * `Text`:         <b>string</b> Anzuzeigender Text
--- * `Name`:         (Optional) <b>string</b> Name für das Ereignis
--- * `PlayerID`:     (Optional) <b>integer</b> Spieler, dessen Text angezeigt wird
--- * `Callback`:     (Optional) <b>function</b> Callback Function
--- * `TargetEntity`: (Optional) <b>string</b> Entität, auf die die Kamera fokussiert ist
--- * `CharSpeed`:    (Optional) <b>integer</b> Faktor der Schreibgeschwindigkeit (Standard: 1.0)
--- * `Waittime`:     (Optional) <b>integer</b> Anfangswartezeit vor dem Schreiben
--- * `Opacity`:      (Optional) <b>float</b> Deckkraft des Hintergrunds (Standard: 1.0)
--- * `Color`:        (Optional) <b>table</b> Hintergrundfarbe (Standard: {R= 0, G= 0, B= 0})
--- * `Image`:        (Optional) <b>string</b> Hintergrundbild (muss im 16:9-Format sein)
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
--- @param _Data table Daten-Tabelle
--- @return string? EventName Name des Ereignisses
function StartTypewriter(_Data)
    return "";
end
API.StartTypewriter = StartTypewriter;

