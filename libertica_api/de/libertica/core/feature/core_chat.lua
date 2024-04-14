--- Ermöglicht das Öffnen der Chat-Eingabe im Normal- und Debug-Modus. Das 
--- Senden einer Nachricht löst einen Bericht aus, den andere Komponenten 
--- abhören können.
Lib.Core.Chat = {};

--- Öffnet die Chat-Konsole.
--- @param _PlayerID number    ID des Spielers
--- @param _AllowDebug boolean Debug-Codes erlaubt
function ShowTextInput(_PlayerID, _AllowDebug)
end
API.ShowTextInput = ShowTextInput;

