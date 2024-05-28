Lib.Technology = Lib.Technology or {};
Lib.Technology.Name = "Technology";
Lib.Technology.Global = {};
Lib.Technology.Local  = {};
Lib.Technology.Shared  = {
    CustomTechnologySequence = 0,
    CustomTechnologies = {},
};

CONST_TECHNOLOGY_TO_INDEX = {};

Lib.Require("comfort/IsLocalScript");
Lib.Require("core/Core");
Lib.Require("module/faker/Technology_API");
Lib.Register("module/faker/Technology");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Technology.Global:Initialize()
    if not self.IsInstalled then
        Lib.Technology.Shared:OverwriteLogic();
        Lib.Technology.Shared:InitNewTechnologies();

        -- Garbage collection
        Lib.Technology.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Technology.Global:OnSaveGameLoaded()
    Lib.Technology.Shared:OverwriteLogic();
    Lib.Technology.Shared:RestoreNewTechnologies();
end

-- Global report listener
function Lib.Technology.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Technology.Local:Initialize()
    if not self.IsInstalled then
        Lib.Technology.Shared:OverwriteLogic();
        Lib.Technology.Shared:InitNewTechnologies();

        -- Garbage collection
        Lib.Technology.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Technology.Local:OnSaveGameLoaded()
    Lib.Technology.Shared:OverwriteLogic();
    Lib.Technology.Shared:RestoreNewTechnologies();
end

-- Local report listener
function Lib.Technology.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --
-- Shared

function Lib.Technology.Shared:AddCustomTechnology(_Key, _Name, _Icon)
    if Technologies[_Key] then
        return;
    end
    self.CustomTechnologySequence = self.CustomTechnologySequence + 1;
    local Technology = {_Key, self.CustomTechnologySequence, _Icon, {}, _Name};
    table.insert(self.CustomTechnologies, Technology);
    Technologies[_Key] = self.CustomTechnologySequence;

    CONST_TECHNOLOGY_TO_INDEX[Technologies[_Key]] = #self.CustomTechnologies;
    CONST_TECHNOLOGY_TO_INDEX[_Key] = #self.CustomTechnologies;

    if IsLocalScript() then
        AddStringText("UI_ObjectNames/" .._Key, _Name);
        g_TexturePositions.Technologies[Technologies[_Key]] = _Icon;
    else
        for i= 1, 8 do
            Logic.TechnologySetState(i, Technologies[_Key], 0);
        end
    end
end

function Lib.Technology.Shared:IsCustomTechnology(_Technology)
    return _Technology >= 1000 and CONST_TECHNOLOGY_TO_INDEX[_Technology] ~= nil;
end

function Lib.Technology.Shared:OverwriteLogic()
    -- Get state of technology
    Lib.Technology.Shared.Orig_Logic_TechnologyGetState = Logic.TechnologyGetState;
    Logic.TechnologyGetState = function(_PlayerID, _Technology)
        return Lib.Technology.Shared:GetTechnologyState(_PlayerID, _Technology);
    end

    -- Change state of technology
    if not IsLocalScript() then
        Lib.Technology.Shared.Orig_Logic_TechnologySetState = Logic.TechnologySetState;
        Logic.TechnologySetState = function(_PlayerID, _Technology, _State)
            Lib.Technology.Shared:SetTechnologyState(_PlayerID, _Technology, _State);
        end
    end
end

function Lib.Technology.Shared:InitNewTechnologies()
    self.CustomTechnologySequence = 0;
    for k,v in pairs(Technologies) do
        if self.CustomTechnologySequence < v then
            self.CustomTechnologySequence = v;
        end
    end
    self.CustomTechnologySequence = self.CustomTechnologySequence + (1000 - self.CustomTechnologySequence);
    for i= 1, #self.CustomTechnologies do
        self.CustomTechnologySequence = self.CustomTechnologySequence + 1;
        self.CustomTechnologies[i][2] = self.CustomTechnologySequence;

        local Data = self.CustomTechnologies[i];
        Technologies[Data[1]] = self.CustomTechnologySequence;
        CONST_TECHNOLOGY_TO_INDEX[Technologies[Data[1]]] = i;
        CONST_TECHNOLOGY_TO_INDEX[Data[1]] = i;
        if IsLocalScript() then
            AddStringText("UI_ObjectNames/" ..Data[1], Data[4]);
            g_TexturePositions.Technologies[Technologies[Data[1]]] = Data[3];
        end
    end
end

function Lib.Technology.Shared:RestoreNewTechnologies()
    for i= 1, #self.CustomTechnologies do
        local Data = self.CustomTechnologies[i];
        Technologies[Data[1]] = Data[2];
        CONST_TECHNOLOGY_TO_INDEX[Technologies[Data[1]]] = i;
        CONST_TECHNOLOGY_TO_INDEX[Data[1]] = i;
    end
end

function Lib.Technology.Shared:GetTechnologyState(_PlayerID, _Technology)
    if _Technology and self:IsCustomTechnology(_Technology) then
        local Index = CONST_TECHNOLOGY_TO_INDEX[_Technology];
        if self.CustomTechnologies[Index] then
            return self.CustomTechnologies[Index][4][_PlayerID] or TechnologyStates.Locked;
        end
    end
    return self.Orig_Logic_TechnologyGetState(_PlayerID, _Technology);
end

function Lib.Technology.Shared:SetTechnologyState(_PlayerID, _Technology, _State)
    if _Technology and self:IsCustomTechnology(_Technology) then
        local Index = CONST_TECHNOLOGY_TO_INDEX[_Technology];
        if self.CustomTechnologies[Index] then
            self.CustomTechnologies[Index][4][_PlayerID] = _State;
            RequestHiResDelay(
                1, ExecuteLocal,
                [[Lib.Technology.Shared.CustomTechnologies[%d][4][%d] = %d]],
                Index, _PlayerID, _State
            );
            return;
        end
    end
    self.Orig_Logic_TechnologySetState(_PlayerID, _Technology, _State);
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Technology.Name);

