Lib.Require("comfort/IsLocalScript");
Lib.Register("module/ui/UITools_API");

function ChangeIcon(_WidgetID, _Coordinates, _Size, _Name)
    error(IsLocalScript(), "Can only be done in local script!");
    _Coordinates = _Coordinates or {10, 14};
    Lib.UITools.Widget:SetIcon(_WidgetID, _Coordinates, _Size, _Name);
end
API.SetIcon = ChangeIcon;

function SetTooltipNormal(_Title, _Text, _DisabledText)
    error(IsLocalScript(), "Can only be done in local script!");
    Lib.UITools.Widget:TooltipNormal(_Title, _Text, _DisabledText);
end
API.SetTooltipNormal = SetTooltipNormal;

function SetTooltipCosts(_Title, _Text, _DisabledText, _Costs, _InSettlement)
    error(IsLocalScript(), "Can only be done in local script!");
    Lib.UITools.Widget:TooltipCosts(_Title,_Text,_DisabledText,_Costs,_InSettlement);
end
API.SetTooltipCosts = SetTooltipCosts;

function HideMinimap(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideMinimap(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/Minimap/MinimapOverlay",_Flag);
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/Minimap/MinimapTerrain",_Flag);
end
API.HideMinimap = HideMinimap;

function HideToggleMinimap(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideToggleMinimap(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/MinimapButton",_Flag);
end
API.HideToggleMinimap = HideToggleMinimap;

function HideDiplomacyMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideDiplomacyMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/DiplomacyMenuButton",_Flag);
end
API.HideDiplomacyMenu = HideDiplomacyMenu;

function HideProductionMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideProductionMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/ProductionMenuButton",_Flag);
end
API.HideProductionMenu = HideProductionMenu;

function HideWeatherMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideWeatherMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/WeatherMenuButton",_Flag);
end
API.HideWeatherMenu = HideWeatherMenu;

function HideBuyTerritory(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideBuyTerritory(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/ClaimTerritory",_Flag);
end
API.HideBuyTerritory = HideBuyTerritory;

function HideKnightAbility(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideKnightAbility(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbilityProgress",_Flag);
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbility",_Flag);
end
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
API.HideSelectionButton = HideSelectionButton;

function HideBuildMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideBuildMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/BuildMenu", _Flag);
end
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
API.RemoveShortcutDescription = RemoveShortcutDescription;

function SpeedLimitActivate(_Flag)
    if IsLocalScript() or Framework.IsNetworkGame() then
        return;
    end
    return ExecuteLocal(
        "Lib.UITools.Speed:ActivateSpeedLimit(%s)",
        tostring(_Flag)
    );
end
API.SpeedLimitActivate = SpeedLimitActivate;

function GetTerritoryName(_TerritoryID)
    local Name = Logic.GetTerritoryName(_TerritoryID);
    local MapType = Framework.GetCurrentMapTypeAndCampaignName();
    if MapType == 1 or MapType == 3 then
        return Name;
    end

    local MapName = Framework.GetCurrentMapName();
    local StringTable = "Map_" .. MapName;
    local TerritoryName = string.gsub(Name, " ","");
    TerritoryName = XGUIEng.GetStringTableText(StringTable .. "/Territory_" .. TerritoryName);
    if TerritoryName == "" then
        TerritoryName = Name .. "(key?)";
    end
    return TerritoryName;
end
API.GetTerritoryName = GetTerritoryName;

function GetPlayerName(_PlayerID)
    local PlayerName = Logic.GetPlayerName(_PlayerID);
    local name = CONST_PLAYER_NAMES[_PlayerID];
    if name ~= nil and name ~= "" then
        PlayerName = name;
    end

    local MapType = Framework.GetCurrentMapTypeAndCampaignName();
    local MutliplayerMode = Framework.GetMultiplayerMapMode(Framework.GetCurrentMapName(), MapType);

    if MutliplayerMode > 0 then
        return PlayerName;
    end
    if MapType == 1 or MapType == 3 then
        local PlayerNameTmp, PlayerHeadTmp, PlayerAITmp = Framework.GetPlayerInfo(_PlayerID);
        if PlayerName ~= "" then
            return PlayerName;
        end
        return PlayerNameTmp;
    end
    return PlayerName;
end
API.GetPlayerName = GetPlayerName;

function SetPlayerName(_PlayerID, _Name)
    assert(type(_PlayerID) == "number");
    assert(type(_Name) == "string");
    if not IsLocalScript() then
        ExecuteLocal([[SetPlayerName(%d, "%s")]], _PlayerID, _Name);
        return;
    end
    GUI_MissionStatistic.PlayerNames[_PlayerID] = _Name
    CONST_PLAYER_NAMES[_PlayerID] = _Name;
end
API.SetPlayerName = SetPlayerName;

function SetPlayerColor(_PlayerID, _Color, _Logo, _Pattern)
    error(not IsLocalScript(), "Player color must be set from logic!");
    g_ColorIndex["ExtraColor1"] = g_ColorIndex["ExtraColor1"] or 16;
    g_ColorIndex["ExtraColor2"] = g_ColorIndex["ExtraColor2"] or 17;

    local Col     = (type(_Color) == "string" and g_ColorIndex[_Color]) or _Color;
    local Logo    = _Logo or -1;
    local Pattern = _Pattern or -1;
    Logic.PlayerSetPlayerColor(_PlayerID, Col, Logo, Pattern);
    ExecuteLocal([[
        Display.UpdatePlayerColors()
        GUI.RebuildMinimapTerrain()
        GUI.RebuildMinimapTerritory()
    ]]);
end
API.SetPlayerColor = SetPlayerColor;

function SetPlayerPortrait(_PlayerID, _Portrait)
    error(_PlayerID >= 1 and _PlayerID <= 8, "Invalid player ID!");
    if not IsLocalScript() then
        local Portrait = (_Portrait ~= nil and "'" .._Portrait.. "'") or "nil";
        ExecuteLocal("SetPlayerPortrait(%d, %s)", _PlayerID, Portrait)
        return;
    end
    if _Portrait == nil then
        Lib.UITools.Player:SetPlayerPortraitByPrimaryKnight(_PlayerID);
    elseif _Portrait ~= nil and IsExisting(_Portrait) then
        Lib.UITools.Player:SetPlayerPortraitBySettler(_PlayerID, _Portrait);
    else
        Lib.UITools.Player:SetPlayerPortraitByModelName(_PlayerID, _Portrait);
    end
end
API.SetPlayerPortrait = SetPlayerPortrait;

