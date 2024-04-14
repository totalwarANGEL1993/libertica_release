--- Allows to open the chat input in normal and debug mode. Sending a message
--- will trigger a report that other components can listen to.
Lib.Core.Chat = {};

--- Open the chat console.
--- @param _PlayerID number    ID of player
--- @param _AllowDebug boolean Debug codes allowed
function ShowTextInput(_PlayerID, _AllowDebug)
end
API.ShowTextInput = ShowTextInput;

