Lib.Require("comfort/IsLocalScript");
Lib.Register("module/ui/UIEffects_API");

function ActivateColoredScreen(_PlayerID, _Red, _Green, _Blue, _Alpha)
    ActivateImageScreen(_PlayerID, "", _Red or 0, _Green or 0, _Blue or 0, _Alpha or 255);
end
API.ActivateColoredScreen = ActivateColoredScreen;

function DeactivateColoredScreen(_PlayerID)
    DeactivateImageScreen(_PlayerID);
end
API.DeactivateColoredScreen = DeactivateColoredScreen;

function ActivateImageScreen(_PlayerID, _Image, _Red, _Green, _Blue, _Alpha)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not IsLocalScript() then
        ExecuteLocal(
            [[Lib.UIEffects.Local:InterfaceActivateImageBackground(%d, "%s", %d, %d, %d, %d)]],
            _PlayerID,
            _Image,
            (_Red ~= nil and _Red) or 255,
            (_Green ~= nil and _Green) or 255,
            (_Blue ~= nil and _Blue) or 255,
            (_Alpha ~= nil and _Alpha) or 255
        );
        return;
    end
    Lib.UIEffects.Local:InterfaceActivateImageBackground(_PlayerID, _Image, _Red, _Green, _Blue, _Alpha);
end
API.ActivateImageScreen = ActivateImageScreen;

function DeactivateImageScreen(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.UIEffects.Local:InterfaceDeactivateImageBackground(%d)",
            _PlayerID
        );
        return;
    end
    Lib.UIEffects.Local:InterfaceDeactivateImageBackground(_PlayerID);
end
API.DeactivateImageScreen = DeactivateImageScreen;

function ActivateNormalInterface(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.UIEffects.Local:InterfaceActivateNormalInterface(%d)",
            _PlayerID
        );
        return;
    end
    Lib.UIEffects.Local:InterfaceActivateNormalInterface(_PlayerID);
end
API.ActivateNormalInterface = ActivateNormalInterface;

function DeactivateNormalInterface(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.UIEffects.Local:InterfaceDeactivateNormalInterface(%d)",
            _PlayerID
        );
        return;
    end
    Lib.UIEffects.Local:InterfaceDeactivateNormalInterface(_PlayerID);
end
API.DeactivateNormalInterface = DeactivateNormalInterface;

