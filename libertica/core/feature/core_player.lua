Lib.Core = Lib.Core or {};
Lib.Core.Player = {}

CONST_PLAYER_NAMES = {};

Lib.Register("core/feature/Core_Player");

-- -------------------------------------------------------------------------- --

function Lib.Core.Player:Initialize()
    for PlayerID = 1, 8 do
        CONST_PLAYER_NAMES[PlayerID] = "";
    end
    self:OverwriteNamingComforts();
end

function Lib.Core.Player:OnSaveGameLoaded()
end

function Lib.Core.Player:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Player:OverwriteNamingComforts()
    GetPlayerName = function(_PlayerID)
        return Lib.Core.Player:GetPlayerName(_PlayerID);
    end

    SetPlayerName = function(_PlayerID, _Name)
        assert(type(_PlayerID) == "number");
        assert(type(_Name) == "string");
        if not IsLocalScript() then
            ExecuteLocal([[SetPlayerName(%d, "%s")]], _PlayerID, _Name);
        end
        return Lib.Core.Player:SetPlayerName(_PlayerID, _Name);
    end

    SetPlayerColor = function(_PlayerID, _Color, _Logo, _Pattern)
        error(not IsLocalScript(), "Player color must be set from logic!");
        Lib.Core.Player:SetPlayerColor(_PlayerID, _Color, _Logo, _Pattern);
    end

    GetTerritoryName = function(_TerritoryID)
        return Lib.Core.Player:GetTerritoryName(_TerritoryID);
    end
end

function SetPlayerPortrait(_PlayerID, _Portrait)
    error(_PlayerID >= 1 and _PlayerID <= 8, "Invalid player ID!");
    if not IsLocalScript() then
        local Portrait = (_Portrait ~= nil and "'" .._Portrait.. "'") or "nil";
        ExecuteLocal("SetPlayerPortrait(%d, %s)", _PlayerID, Portrait)
        return;
    end
    if _Portrait == nil then
        Lib.Core.Player:SetPlayerPortraitByPrimaryKnight(_PlayerID);
    elseif _Portrait ~= nil and IsExisting(_Portrait) then
        Lib.Core.Player:SetPlayerPortraitBySettler(_PlayerID, _Portrait);
    else
        Lib.Core.Player:SetPlayerPortraitByModelName(_PlayerID, _Portrait);
    end
end
API.SetPlayerPortrait = SetPlayerPortrait;

-- -------------------------------------------------------------------------- --

function Lib.Core.Player:GetPlayerName(_PlayerID)
    local PlayerName = Logic.GetPlayerName(_PlayerID);
    local name = CONST_PLAYER_NAMES[_PlayerID];
    if name ~= nil and name ~= "" then
        PlayerName = name;
    end

    local MapType = Framework.GetCurrentMapTypeAndCampaignName();
    local MapName = Framework.GetCurrentMapName();
    local MutliplayerMode = Framework.GetMultiplayerMapMode(MapName, MapType);

    if MutliplayerMode > 0 then
        return PlayerName;
    end
    if MapType == 1 or MapType == 3 then
        local PlayerNameTmp, _, _ = Framework.GetPlayerInfo(_PlayerID);
        if PlayerName ~= "" then
            return PlayerName;
        end
        return PlayerNameTmp;
    end
    return PlayerName;
end

function Lib.Core.Player:SetPlayerName(_PlayerID, _Name)
    CONST_PLAYER_NAMES[_PlayerID] = _Name;
    if IsLocalScript() then
        GUI_MissionStatistic.PlayerNames[_PlayerID] = _Name;
    end
end

function Lib.Core.Player:SetPlayerColor(_PlayerID, _Color, _Logo, _Pattern)
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

function Lib.Core.Player:GetTerritoryName(_TerritoryID)
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

function Lib.Core.Player:SetPlayerPortraitByPrimaryKnight(_PlayerID)
    local KnightID = Logic.GetKnightID(_PlayerID);
    local HeadModelName = "H_NPC_Generic_Trader";
    if KnightID ~= 0 then
        local KnightType = Logic.GetEntityType(KnightID);
        local KnightTypeName = Logic.GetEntityTypeName(KnightType);
        HeadModelName = "H" .. string.sub(KnightTypeName, 2, 8) .. "_" .. string.sub(KnightTypeName, 9);

        if not Models["Heads_" .. HeadModelName] then
            HeadModelName = "H_NPC_Generic_Trader";
        end
    end
    g_PlayerPortrait[_PlayerID] = HeadModelName;
end

function Lib.Core.Player:SetPlayerPortraitBySettler(_PlayerID, _Portrait)
    local PortraitMap = {
        ["U_KnightChivalry"]           = "H_Knight_Chivalry",
        ["U_KnightHealing"]            = "H_Knight_Healing",
        ["U_KnightPlunder"]            = "H_Knight_Plunder",
        ["U_KnightRedPrince"]          = "H_Knight_RedPrince",
        ["U_KnightSabatta"]            = "H_Knight_Sabatt",
        ["U_KnightSong"]               = "H_Knight_Song",
        ["U_KnightTrading"]            = "H_Knight_Trading",
        ["U_KnightWisdom"]             = "H_Knight_Wisdom",
        ["U_NPC_Amma_NE"]              = "H_NPC_Amma",
        ["U_NPC_Castellan_ME"]         = "H_NPC_Castellan_ME",
        ["U_NPC_Castellan_NA"]         = "H_NPC_Castellan_NA",
        ["U_NPC_Castellan_NE"]         = "H_NPC_Castellan_NE",
        ["U_NPC_Castellan_SE"]         = "H_NPC_Castellan_SE",
        ["U_MilitaryBandit_Ranged_ME"] = "H_NPC_Mercenary_ME",
        ["U_MilitaryBandit_Melee_NA"]  = "H_NPC_Mercenary_NA",
        ["U_MilitaryBandit_Melee_NE"]  = "H_NPC_Mercenary_NE",
        ["U_MilitaryBandit_Melee_SE"]  = "H_NPC_Mercenary_SE",
        ["U_NPC_Monk_ME"]              = "H_NPC_Monk_ME",
        ["U_NPC_Monk_NA"]              = "H_NPC_Monk_NA",
        ["U_NPC_Monk_NE"]              = "H_NPC_Monk_NE",
        ["U_NPC_Monk_SE"]              = "H_NPC_Monk_SE",
        ["U_NPC_Villager01_ME"]        = "H_NPC_Villager01_ME",
        ["U_NPC_Villager01_NA"]        = "H_NPC_Villager01_NA",
        ["U_NPC_Villager01_NE"]        = "H_NPC_Villager01_NE",
        ["U_NPC_Villager01_SE"]        = "H_NPC_Villager01_SE",
    }

    if g_GameExtraNo > 0 then
        PortraitMap["U_KnightPraphat"]           = "H_Knight_Praphat";
        PortraitMap["U_KnightSaraya"]            = "H_Knight_Saraya";
        PortraitMap["U_KnightKhana"]             = "H_Knight_Khana";
        PortraitMap["U_MilitaryBandit_Melee_AS"] = "H_NPC_Mercenary_AS";
        PortraitMap["U_NPC_Castellan_AS"]        = "H_NPC_Castellan_AS";
        PortraitMap["U_NPC_Villager_AS"]         = "H_NPC_Villager_AS";
        PortraitMap["U_NPC_Monk_AS"]             = "H_NPC_Monk_AS";
        PortraitMap["U_NPC_Monk_Khana"]          = "H_NPC_Monk_Khana";
    end

    local HeadModelName = "H_NPC_Generic_Trader";
    local EntityID = GetID(_Portrait);
    if EntityID ~= 0 then
        local EntityType = Logic.GetEntityType(EntityID);
        local EntityTypeName = Logic.GetEntityTypeName(EntityType);
        HeadModelName = PortraitMap[EntityTypeName] or "H_NPC_Generic_Trader";
        if not HeadModelName then
            HeadModelName = "H_NPC_Generic_Trader";
        end
    end
    g_PlayerPortrait[_PlayerID] = HeadModelName;
end

function Lib.Core.Player:SetPlayerPortraitByModelName(_PlayerID, _Portrait)
    if not Models["Heads_" .. tostring(_Portrait)] then
        _Portrait = "H_NPC_Generic_Trader";
    end
    g_PlayerPortrait[_PlayerID] = _Portrait;
end

