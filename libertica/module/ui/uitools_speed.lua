Lib.Register("module/ui/UITools_Speed");

Lib.UITools = Lib.UITools or {};
Lib.UITools.Speed = {
    SpeedLimit = 1,
    Text = {
        Message = {
            NoSpeedUp = {
                de = "Die Spielgeschwindigkeit kann nicht erhöht werden!",
                en = "The game speed can not be increased!",
                fr = "La vitesse du jeu ne peut pas être augmentée!"
            }
        }
    };
};

function Lib.UITools.Speed:SetSpeedLimit(_Limit)
    if Framework.IsNetworkGame() then
        log("ModuleGuiControl: Detect network game. Aborting!");
        return;
    end
    _Limit = (_Limit < 1 and 1) or math.floor(_Limit);
    log("ModuleGuiControl: Setting speed limit to " .._Limit);
    self.SpeedLimit = _Limit;
end

function Lib.UITools.Speed:ActivateSpeedLimit(_Flag)
    if Framework.IsNetworkGame() then
        log("ModuleGuiControl: Detect network game. Aborting!");
        return;
    end
    self.UseSpeedLimit = _Flag == true;
    if _Flag and Game.GameTimeGetFactor(GUI.GetPlayerID()) > self.SpeedLimit then
        log("ModuleGuiControl: Speed is capped at " ..self.SpeedLimit);
        Game.GameTimeSetFactor(GUI.GetPlayerID(), self.SpeedLimit);
        g_GameSpeed = 1;
    end
end

function Lib.UITools.Speed:InitForbidSpeedUp()
    GameCallback_GameSpeedChanged_Orig_Preferences_ForbidSpeedUp = GameCallback_GameSpeedChanged;
    GameCallback_GameSpeedChanged = function( _Speed )
        GameCallback_GameSpeedChanged_Orig_Preferences_ForbidSpeedUp( _Speed );
        if Lib.UITools.Speed.UseSpeedLimit == true then
            log("ModuleGuiControl: Checking speed limit.");
            if _Speed > Lib.UITools.Speed.SpeedLimit then
                log("ModuleGuiControl: Speed is capped at " ..tostring(_Speed).. ".");
                Game.GameTimeSetFactor(GUI.GetPlayerID(), Lib.UITools.Speed.SpeedLimit);
                g_GameSpeed = 1;
                Message(Lib.UITools.Speed.Text.Message.NoSpeedUp);
            end
        end
    end
end

