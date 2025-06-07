Lib.Require("comfort/IsMultiplayer");
Lib.Register("module/information/Typewriter_API");

Lib.Typewriter = Lib.Typewriter or {};

function StartTypewriter(_Data)
    if Framework.IsNetworkGame() ~= true then
        _Data.PlayerID = _Data.PlayerID or 1; -- Human Player
    end
    if _Data.PlayerID == nil or (_Data.PlayerID < 1 or _Data.PlayerID > 8) then
        return;
    end
    _Data.Text = Localize(_Data.Text or "");
    _Data.Callback = _Data.Callback or function() end;
    _Data.CharSpeed = _Data.CharSpeed or 1;
    _Data.Waittime = (_Data.Waittime or 8) * 10;
    _Data.TargetEntity = GetID(_Data.TargetEntity or 0);
    _Data.Image = _Data.Image or "";
    _Data.Color = _Data.Color or {
        R = (_Data.Image and _Data.Image ~= "" and 255) or 0,
        G = (_Data.Image and _Data.Image ~= "" and 255) or 0,
        B = (_Data.Image and _Data.Image ~= "" and 255) or 0,
        A = 255
    };
    if _Data.Opacity and _Data.Opacity >= 0 and _Data.Opacity then
        _Data.Color.A = math.floor((255 * _Data.Opacity) + 0.5);
    end
    _Data.Delay = 15;
    _Data.Index = 0;
    return Lib.Information.Global:StartTypewriter(_Data);
end
API.StartTypewriter = StartTypewriter;

