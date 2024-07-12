--- Ermöglicht das Definieren von Dialogen.
---
--- Dialoge können verwendet werden, um Gespräche zwischen Charakteren unter Verwendung der
--- animierten Köpfe in einem funktionsgestrippten Briefing zu erstellen.
---
Lib.DialogSystem = Lib.DialogSystem or {};



--- Startet einen Dialog.
---
--- #### Einstellungen
---
--- Mögliche Felder für die Dialogtabelle:
--- * `Starting`                - Funktion, die aufgerufen wird, wenn der Dialog gestartet wird              
--- * `Finished`                - Funktion, die aufgerufen wird, wenn der Dialog beendet ist             
--- * `RestoreCamera`           - Kameraposition wird am Ende des Dialogs gespeichert und wiederhergestellt 
--- * `RestoreGameSpeed`        - Spielgeschwindigkeit wird am Ende des Dialogs gespeichert und wiederhergestellt      
--- * `EnableGlobalImmortality` - Während der Dialoge sind alle Einheiten unverwundbar        
--- * `EnableSky`               - Anzeige des Himmels während des Dialogs                   
--- * `EnableFoW`               - Anzeige des Nebels des Krieges während des Dialogs           
--- * `EnableBorderPins`        - Anzeige der Grenznadeln während des Dialogs 
---
--- #### Beispiel
---
--- ```lua
--- function Dialog1(_Name, _PlayerID)
---     local Dialog = {
---         DisableFow = true,
---         DisableBoderPins = true,
---     };
---     local AP, ASP = API.AddDialogPages(Dialog);
---
---     -- Seiten ...
---
---     Dialog.Starting = function(_Data)
---     end
---     Dialog.Finished = function(_Data)
---     end
---     API.StartDialog(Dialog, _Name, _PlayerID);
--- end
--- ```
---
--- @param _Dialog table     Dialogtabelle
--- @param _Name string      Name des Dialogs
--- @param _PlayerID integer Spieler-ID des Empfängers
function StartDialog(_Dialog, _Name, _PlayerID)
end
API.StartDialog = StartDialog;

--- Fragt den Spieler um Erlaubnis, Grafikeinstellungen zu ändern.
---
--- Ist das BriefingSystem geladen, wird dessen Funktionalität genutzt.
---
--- Diese Funktionalität ist im Multiplayer deaktiviert.
function RequestDialogAlternateGraphics()
end
API.RequestDialogAlternateGraphics = RequestDialogAlternateGraphics;

--- Überprüft, ob ein Dialog aktiv ist.
--- @param _PlayerID integer Spieler-ID des Empfängers
--- @return boolean IsActive Dialog ist aktiv
function IsDialogActive(_PlayerID)
    return true;
end
API.IsDialogActive = IsDialogActive;

--- Bereitet den Dialog vor und gibt die Seitenfunktionen zurück.
---
--- Muss aufgerufen werden, bevor Seiten hinzugefügt werden.
--- @param _Dialog table Dialogtabelle
--- @return function AP  Seitenfunktion
--- @return function ASP Kurze Seitenfunktion
function AddDialogPages(_Dialog)
    return function(...) end, function(...) end
end
API.AddDialogPages = AddDialogPages;

--- Erstellt eine Seite.
---
--- #### Dialogseite
--- Mögliche Felder für die Seite:
---
--- * `Actor`           - (optional) Spieler-ID des Sprechers
--- * `Title`           - (optional) Name des Akteurs (nur mit Akteur)
--- * `Text`            - (optional) Angezeigter Seitentext
--- * `Speech`          - Pfad zum Voiceover (MP3-Datei)
--- * `Position`        - Position der Kamera (nicht mit Ziel)
--- * `Target`          - Einheit, der die Kamera folgt (nicht mit Position)
--- * `Distance`        - (optional) Entfernung der Kamera
--- * `Action`          - (optional) Funktion, die aufgerufen wird, wenn die Seite angezeigt wird
--- * `FadeIn`          - (optional) Dauer des Einblendens aus Schwarz
--- * `FadeOut`         - (optional) Dauer des Ausblendens zu Schwarz
--- * `FaderAlpha`      - (optional) Maskenalpha
--- * `MC`              - (optional) Tabelle mit Auswahlmöglichkeiten zum Verzweigen in Dialogen
---
--- *-> Beispiel #1*
---
--- #### Flusssteuerung
--- In einem Dialog kann der Spieler gezwungen werden, eine Auswahl zu treffen, die
--- unterschiedliche Ergebnisse haben wird. Das nennt man Mehrfachauswahl. Optionen müssen bereitgestellt werden
--- in einer Tabelle. Die Zielseite kann mit ihrem Namen definiert werden oder eine Funktion kann bereitgestellt werden
--- für mehr Kontrolle über den Fluss. Solche Funktionen müssen einen
--- Seitennamen zurückgeben.
---
--- *-> Beispiel #2*
---
--- Darüber hinaus kann jede Funktion markiert werden, um entfernt zu werden, wenn sie verwendet wird
--- und nicht erneut angezeigt werden, wenn die Seite erneut betreten wird.
---
--- *-> Beispiel #3*
---
--- Außerdem können Seiten ausgeblendet werden, indem eine Funktion bereitgestellt wird, um Bedingungen zu überprüfen.
---
--- *-> Beispiel #4*
---
--- Wenn ein Dialog verzweigt ist, muss er manuell beendet werden, nachdem ein Zweig abgeschlossen ist
--- oder es zeigt einfach die nächste Seite an. Um einen Dialog zu beenden, muss eine leere Seite
--- hinzugefügt werden.
---
--- *-> Beispiel #5*
---
--- Alternativ kann der Dialog an einer anderen Seite fortgesetzt werden. Dies ermöglicht es, zu erstellen
--- sich wiederholende Strukturen innerhalb eines Dialogs.
---
--- *-> Beispiel #6*
---
--- Um ausgewählte Antworten zu einem späteren Zeitpunkt zu erhalten, können die Auswahlmöglichkeiten in einer
--- globalen Variable entweder in einem Optionsrückruf oder in der fertigen Funktion gespeichert werden. Die
--- zurückgegebene Zahl ist die ID der Antwort.
---
--- *-> Beispiel #7*
---
--- #### Beispiele
---
--- * Beispiel #1: Eine einfache Seite
--- ```lua
--- AP {
---     Title        = "Hero",
---     Text         = "Diese Seite hat einen Schauspieler und eine Auswahl.",
---     Actor        = 1,
---     Duration     = 2,
---     FadeIn       = 2,
---     Position     = "npc1",
---     DialogCamera = true,
--- };
--- ```
---
---
--- * Beispiel #2: Verwendung von Mehrfachauswahlen
--- ```lua
-- AP {
---     Title        = "Hero",
---     Text         = "Diese Seite hat einen Schauspieler und eine Auswahl.",
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
--- * Beispiel #3: Einmalige Verwendungsoption
--- ```lua
--- MC = {
---     ...,
---     {"Option 3", "AnotherPage", Remove = true},
--- }
--- ```
---
---
--- * Beispiel #4: Option mit Bedingung
--- ```lua
--- MC = {
---     ...,
---     {"Option 3", "AnotherPage", Disable = OptionIsDisabled},
--- }
--- ```
---
---
--- * Beispiel #5: Dialog abbrechen
--- ```lua
--- AP()
--- ```
---
---
--- * Beispiel #6: Zu anderer Seite springen
--- ```lua
--- AP("SomePageName")
--- ```
---
---
--- * Beispiel #7: Ausgewählte Option abrufen
--- ```lua
--- Dialog.Finished = function(_Data)
---     MyChoosenOption = _Data:GetPage("Choice"):GetSelected();
--- end
--- ```
---
function AP(_Data)
end

--- Erstellt eine Seite auf vereinfachte Weise.
---
--- Die Funktion kann einen automatischen Seitennamen basierend auf dem Seitenindex erstellen. Ein
--- Name kann ein optionales Parameter am Anfang sein.
---
--- #### Einstellungen
--- Die Funktion erwartet die folgenden Parameter:
--- 
--- * `Name`           - (Optional) Name der Seite
--- * `Sender`         - Spieler-ID des Akteurs
--- * `Target`         - Einheit, auf die die Kamera schaut
--- * `Title`          - Angezeigter Seitentitel
--- * `Text`           - Angezeigter Seitentext
--- * `DialogCamera`   - Verwendung der Nahkamera
--- * `Action`         - (Optional) Aktion, wenn die Seite angezeigt wird
---
--- #### Beispiele
---
--- ```lua
--- -- Totalaufnahme
--- ASP("Titel", "Einige wichtige Texte.", false, "HQ");
--- -- Seitennamen
--- ASP("Seite1", "Titel", "Einige wichtige Texte.", false, "HQ");
--- -- Nahansicht
--- ASP("Titel", "Einige wichtige Texte.", true, "Marcus");
--- -- Aktion aufrufen
--- ASP("Titel", "Einige wichtige Texte.", true, "Marcus", MyFunction);
--- -- Überspringen erlauben/verbieten
--- ASP("Titel", "Einige wichtige Texte.", true, "HQ", nil, true);
--- ```
---
--- @param ... any Liste der Seiteneinstellungen
function ASP(...)
end

