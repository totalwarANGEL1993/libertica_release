Lib.Register("module/ui/UITools_Widget");

Lib.UITools = Lib.UITools or {};
Lib.UITools.Widget = {
    HiddenWidgets = {},
};

function Lib.UITools.Widget:DisplayInterfaceButton(_Widget, _Hide)
    self.HiddenWidgets[_Widget] = _Hide == true;
    XGUIEng.ShowWidget(_Widget, (_Hide == true and 0) or 1);
end

function Lib.UITools.Widget:UpdateHiddenWidgets()
    for k, v in pairs(self.HiddenWidgets) do
        XGUIEng.ShowWidget(k, 0);
    end
end

function Lib.UITools.Widget:OverrideMissionGoodCounter()
    StartMissionGoodOrEntityCounter = function(_Icon, _AmountToReach)
        local IconWidget = "/InGame/Root/Normal/MissionGoodOrEntityCounter/Icon";
        local CounterWidget = "/InGame/Root/Normal/MissionGoodOrEntityCounter";
        if type(_Icon[3]) == "string" or _Icon[3] > 2 then
            Lib.UITools.Widget:SetIcon(IconWidget, _Icon, 64, _Icon[3]);
        else
            SetIcon(IconWidget, _Icon);
        end
        g_MissionGoodOrEntityCounterAmountToReach = _AmountToReach;
        g_MissionGoodOrEntityCounterIcon = _Icon;
        XGUIEng.ShowWidget(CounterWidget, 1);
    end
end

function Lib.UITools.Widget:OverrideUpdateClaimTerritory()
    GUI_Knight.ClaimTerritoryUpdate_Orig_QSB_Interface = GUI_Knight.ClaimTerritoryUpdate;
    --- @diagnostic disable-next-line: duplicate-set-field
    GUI_Knight.ClaimTerritoryUpdate = function()
        GUI_Knight.ClaimTerritoryUpdate_Orig_QSB_Interface();
        local Key = "/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/ClaimTerritory";
        if Lib.UITools.Widget.HiddenWidgets[Key] == true then
            XGUIEng.ShowWidget(Key, 0);
            return true;
        end
    end
end

function Lib.UITools.Widget:SetIcon(_WidgetID, _Coordinates, _Size, _Name)
    _Size = _Size or 64;
    _Coordinates[3] = _Coordinates[3] or 0;
    if _Name == nil then
        return SetIcon(_WidgetID, _Coordinates, _Size);
    end
    assert(_Size == 44 or _Size == 64 or _Size == 128);
    if _Size == 44 then
        _Name = _Name.. ".png";
    end
    if _Size == 64 then
        _Name = _Name.. "big.png";
    end
    if _Size == 128 then
        _Name = _Name.. "verybig.png";
    end

    local u0, u1, v0, v1;
    u0 = (_Coordinates[1] - 1) * _Size;
    v0 = (_Coordinates[2] - 1) * _Size;
    u1 = (_Coordinates[1]) * _Size;
    v1 = (_Coordinates[2]) * _Size;
    State = 1;
    if XGUIEng.IsButton(_WidgetID) == 1 then
        State = 7;
    end
    XGUIEng.SetMaterialAlpha(_WidgetID, State, 255);
    XGUIEng.SetMaterialTexture(_WidgetID, State, _Name);
    XGUIEng.SetMaterialUV(_WidgetID, State, u0, v0, u1, v1);
end

function Lib.UITools.Widget:TooltipNormal(_title, _text, _disabledText)
    if _title and _title:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
        _title = XGUIEng.GetStringTableText(_title);
    end
    if _text and _text:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
        _text = XGUIEng.GetStringTableText(_text);
    end
    _disabledText = _disabledText or "";
    if _disabledText and _disabledText:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
        _disabledText = XGUIEng.GetStringTableText(_disabledText);
    end

    local TooltipContainerPath = "/InGame/Root/Normal/TooltipNormal";
    local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath);
    local TooltipNameWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Name");
    local TooltipDescriptionWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Text");
    local TooltipBGWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/BG");
    local TooltipFadeInContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn");
    local PositionWidget = XGUIEng.GetCurrentWidgetID();

    local title = (_title and _title) or "";
    local text = (_text and _text) or "";
    local disabled = "";
    if XGUIEng.IsButtonDisabled(PositionWidget) == 1 and _disabledText then
        disabled = disabled .. "{cr}{@color:255,32,32,255}" .. _disabledText;
    end

    XGUIEng.SetText(TooltipNameWidget, "{center}" .. title);
    XGUIEng.SetText(TooltipDescriptionWidget, text .. disabled);
    local Height = XGUIEng.GetTextHeight(TooltipDescriptionWidget, true);
    local W, H = XGUIEng.GetWidgetSize(TooltipDescriptionWidget);
    XGUIEng.SetWidgetSize(TooltipDescriptionWidget, W, Height);

    GUI_Tooltip.ResizeBG(TooltipBGWidget, TooltipDescriptionWidget);
    local TooltipContainerSizeWidgets = {TooltipBGWidget};
    GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget);
    GUI_Tooltip.FadeInTooltip(TooltipFadeInContainer);
end

function Lib.UITools.Widget:TooltipCosts(_title,_text,_disabledText,_costs,_inSettlement)
    _costs = _costs or {};
    local Costs = {};
    -- This transforms the content of a metatable to a new table so that the
    -- internal script does correctly render the costs.
    for i= 1, 4, 1 do
        Costs[i] = _costs[i];
    end
    if _title and _title:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
        _title = XGUIEng.GetStringTableText(_title);
    end
    if _text and _text:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
        _text = XGUIEng.GetStringTableText(_text);
    end
    if _disabledText and _disabledText:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
        _disabledText = XGUIEng.GetStringTableText(_disabledText);
    end

    local TooltipContainerPath = "/InGame/Root/Normal/TooltipBuy";
    local TooltipContainer = XGUIEng.GetWidgetID(TooltipContainerPath);
    local TooltipNameWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Name");
    local TooltipDescriptionWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/Text");
    local TooltipBGWidget = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn/BG");
    local TooltipFadeInContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/FadeIn");
    local TooltipCostsContainer = XGUIEng.GetWidgetID(TooltipContainerPath .. "/Costs");
    local PositionWidget = XGUIEng.GetCurrentWidgetID();

    local title = (_title and _title) or "";
    local text = (_text and _text) or "";
    local disabled = "";
    if XGUIEng.IsButtonDisabled(PositionWidget) == 1 and _disabledText then
        disabled = disabled .. "{cr}{@color:255,32,32,255}" .. _disabledText;
    end

    XGUIEng.SetText(TooltipNameWidget, "{center}" .. title);
    XGUIEng.SetText(TooltipDescriptionWidget, text .. disabled);
    local Height = XGUIEng.GetTextHeight(TooltipDescriptionWidget, true);
    local W, H = XGUIEng.GetWidgetSize(TooltipDescriptionWidget);
    XGUIEng.SetWidgetSize(TooltipDescriptionWidget, W, Height);

    GUI_Tooltip.ResizeBG(TooltipBGWidget, TooltipDescriptionWidget);
    GUI_Tooltip.SetCosts(TooltipCostsContainer, Costs, _inSettlement);
    local TooltipContainerSizeWidgets = {TooltipContainer, TooltipCostsContainer, TooltipBGWidget};
    GUI_Tooltip.SetPosition(TooltipContainer, TooltipContainerSizeWidgets, PositionWidget, nil, true);
    GUI_Tooltip.OrderTooltip(TooltipContainerSizeWidgets, TooltipFadeInContainer, TooltipCostsContainer, PositionWidget, TooltipBGWidget);
    GUI_Tooltip.FadeInTooltip(TooltipFadeInContainer);
end

