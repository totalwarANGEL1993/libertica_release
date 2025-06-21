Lib.Require("comfort/IsLocalScript");
Lib.Register("module/ui/UITools_API");

function ChangeIcon(_WidgetID, _Coordinates, _Size, _Name)
    error(IsLocalScript(), "Can only be done in local script!");
    _Coordinates = _Coordinates or {10, 14};
    Lib.UITools.Widget:SetIcon(_WidgetID, _Coordinates, _Size, _Name);
end
API.InterfaceSetIcon = ChangeIcon;
API.SetIcon = ChangeIcon;

function SetTooltipNormal(_Title, _Text, _DisabledText)
    error(IsLocalScript(), "Can only be done in local script!");
    Lib.UITools.Widget:TooltipNormal(_Title, _Text, _DisabledText);
end
API.InterfaceSetTooltipNormal = SetTooltipNormal;
API.SetTooltipNormal = SetTooltipNormal;

function SetTooltipCosts(_Title, _Text, _DisabledText, _Costs, _InSettlement)
    error(IsLocalScript(), "Can only be done in local script!");
    Lib.UITools.Widget:TooltipCosts(_Title,_Text,_DisabledText,_Costs,_InSettlement);
end
API.InterfaceSetTooltipCosts = SetTooltipCosts;
API.SetTooltipCosts = SetTooltipCosts;

function HideMinimap(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideMinimap(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/Minimap/MinimapOverlay",_Flag);
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/Minimap/MinimapTerrain",_Flag);
end
API.InterfaceHideMinimap = HideMinimap;
API.HideMinimap = HideMinimap;

function HideToggleMinimap(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideToggleMinimap(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/MinimapButton",_Flag);
end
API.InterfaceHideToggleMinimap = HideToggleMinimap;
API.HideToggleMinimap = HideToggleMinimap;

function HideDiplomacyMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideDiplomacyMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/DiplomacyMenuButton",_Flag);
end
API.InterfaceHideDiplomacyMenu = HideDiplomacyMenu;
API.HideDiplomacyMenu = HideDiplomacyMenu;

function HideProductionMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideProductionMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/ProductionMenuButton",_Flag);
end
API.InterfaceHideProductionMenu = HideProductionMenu;
API.HideProductionMenu = HideProductionMenu;

function HideWeatherMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideWeatherMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/WeatherMenuButton",_Flag);
end
API.InterfaceHideWeatherMenu = HideWeatherMenu;
API.HideWeatherMenu = HideWeatherMenu;

function HideBuyTerritory(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideBuyTerritory(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/ClaimTerritory",_Flag);
end
API.InterfaceHideBuyTerritory = HideBuyTerritory;
API.HideBuyTerritory = HideBuyTerritory;

function HideKnightAbility(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideKnightAbility(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbilityProgress",_Flag);
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbility",_Flag);
end
API.InterfaceHideKnightAbility = HideKnightAbility;
API.HideKnightAbility = HideKnightAbility;

function HideKnightButton(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideKnightButton(%s)", tostring(_Flag));
        Logic.SetEntitySelectableFlag("..KnightID..", (_Flag and 0) or 1);
        return;
    end
    local KnightID = Logic.GetKnightID(GUI.GetPlayerID());
    if _Flag then
        GUI.DeselectEntity(KnightID);
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightButtonProgress",_Flag);
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightButton",_Flag);
end
API.InterfaceHideKnightButton = HideKnightButton;
API.HideKnightButton = HideKnightButton;

function HideSelectionButton(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideSelectionButton(%s)", tostring(_Flag));
        return;
    end
    HideKnightButton(_Flag);
    GUI.ClearSelection();
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/BattalionButton",_Flag);
end
API.InterfaceHideSelectionButton = HideSelectionButton;
API.HideSelectionButton = HideSelectionButton;

function HideBuildMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideBuildMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/BuildMenu", _Flag);
end
API.InterfaceHideBuildMenu = HideBuildMenu;
API.HideBuildMenu = HideBuildMenu;

function AddShortcutDescription(_Key, _Description)
    if not IsLocalScript() then
        return -1;
    end
    g_KeyBindingsOptions.Descriptions = nil;
    for i= 1, #Lib.UITools.Shortcut.HotkeyDescriptions do
        if Lib.UITools.Shortcut.HotkeyDescriptions[i][1] == _Key then
            return -1;
        end
    end
    local ID = #Lib.UITools.Shortcut.HotkeyDescriptions+1;
    table.insert(Lib.UITools.Shortcut.HotkeyDescriptions, {ID = ID, _Key, _Description});
    return #Lib.UITools.Shortcut.HotkeyDescriptions;
end
API.AddShortcutEntry = AddShortcutDescription;
API.AddShortcutDescription = AddShortcutDescription;

function RemoveShortcutDescription(_ID)
    if not IsLocalScript() then
        return;
    end
    g_KeyBindingsOptions.Descriptions = nil;
    for k, v in pairs(Lib.UITools.Shortcut.HotkeyDescriptions) do
        if v.ID == _ID then
            Lib.UITools.Shortcut.HotkeyDescriptions[k] = nil;
        end
    end
end
API.RemoveHotKey = RemoveShortcutDescription;
API.RemoveShortcutEntry = RemoveShortcutDescription;
API.RemoveShortcutDescription = RemoveShortcutDescription;

function SpeedLimitActivate(_Flag)
    if IsLocalScript() or Framework.IsNetworkGame() then
        return;
    end
    ExecuteLocal(
        "Lib.UITools.Speed:ActivateSpeedLimit(%s)",
        tostring(_Flag)
    );
end
API.SpeedLimitActivate = SpeedLimitActivate;

function SpeedLimitSetLimit(_Limit)
    if IsLocalScript() or Framework.IsNetworkGame() then
        return;
    end
    ExecuteLocal("Lib.UITools.Speed:SetSpeedLimit(%f)",_Limit);
end
API.SetSpeedLimit = SpeedLimitSetLimit;
API.SpeedLimitSet = SpeedLimitSetLimit;
API.SpeedLimitSetLimit = SpeedLimitSetLimit;

