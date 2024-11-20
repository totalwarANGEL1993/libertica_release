Lib.IOMine = Lib.IOMine or {};
Lib.IOMine.Name = "IOMine";
Lib.IOMine.Global = {
    Mines = {},
};
Lib.IOMine.Local  = {};

Lib.Require("core/Core");
Lib.Require("module/io/IO");
Lib.Require("module/io/IOMine_API");
Lib.Register("module/io/IOMine");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.IOMine.Global:Initialize()
    if not self.IsInstalled then
        Report.InteractiveMineErected = CreateReport("Event_InteractiveMineErected");

        -- Garbage collection
        Lib.IOMine.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.IOMine.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.IOMine.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.ObjectReset then
        if CONST_IO[arg[1]] and CONST_IO[arg[1]].IsInteractiveMine then
            self:ResetIOMine(arg[1], CONST_IO[arg[1]].Type);
        end
    elseif _ID == Report.ObjectDelete then
        if CONST_IO[arg[1]].IsInteractiveMine and CONST_IO[arg[1]].Type then
            ReplaceEntity(arg[1], CONST_IO[arg[1]].Type);
        end
    end
end

function Lib.IOMine.Global:CreateIOMine(
    _Position, _Type, _Title, _Text, _Costs, _ResourceAmount,
    _RefillAmount, _Condition, _ConditionInfo, _Action
)
    local BlockerID = self:ResetIOMine(_Position, _Type);
    local Icon = {14, 10};
    local TextKey;
    if _Type == Entities.R_IronMine then
        TextKey = "Names/R_IronMine";
        Icon = {14, 10};
    end
    if _Type == Entities.R_StoneMine then
        TextKey = "Names/R_StoneMine";
        Icon = {14, 10};
    end

    SetupObject {
        Name                 = _Position,
        IsInteractiveMine    = true,
        Title                = _Title or TextKey,
        Text                 = _Text,
        Texture              = Icon,
        Type                 = _Type,
        ResourceAmount       = _ResourceAmount or 250,
        RefillAmount         = _RefillAmount or 75,
        Costs                = _Costs,
        InvisibleBlocker     = BlockerID,
        Distance             = 1200,
        Waittime             = 0,
        ConditionInfo        = _ConditionInfo,
        AdditionalCondition  = _Condition,
        AdditionalAction     = _Action,
        Condition            = function(_Data)
            if _Data.AdditionalCondition then
                return _Data:AdditionalCondition(_Data);
            end
            return true;
        end,
        Action               = function(_Data, _KnightID, _PlayerID)
            local ID = ReplaceEntity(_Data.ScriptName, _Data.Type);
            SetResourceAmount(ID, _Data.ResourceAmount, _Data.RefillAmount);
            DestroyEntity(_Data.InvisibleBlocker);
            SendReport(Report.InteractiveMineErected, _Data.ScriptName, _KnightID, _PlayerID);
            SendReportToLocal(Report.InteractiveMineErected, _Data.ScriptName, _KnightID, _PlayerID);
            if _Data.AdditionalAction then
                _Data.AdditionalAction(_Data, _KnightID, _PlayerID);
            end
        end
    };
end

function Lib.IOMine.Global:ResetIOMine(_ScriptName, _Type)
    if CONST_IO[_ScriptName] then
        DestroyEntity(CONST_IO[_ScriptName].InvisibleBlocker);
    end
    local EntityID = ReplaceEntity(_ScriptName, Entities.XD_ScriptEntity);
    local Model = Models.Doodads_D_SE_ResourceIron_Wrecked;
    if _Type == Entities.R_StoneMine then
        Model = Models.R_SE_ResorceStone_10;
    end
    Logic.SetVisible(EntityID, true);
    Logic.SetModel(EntityID, Model);
    local x, y, z = Logic.EntityGetPos(EntityID);
    local BlockerID = Logic.CreateEntity(Entities.D_ME_Rock_Set01_B_07, x, y, 0, 0);
    Logic.SetVisible(BlockerID, false);
    if CONST_IO[_ScriptName] then
        CONST_IO[_ScriptName].InvisibleBlocker = BlockerID;
    end
    return BlockerID;
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.IOMine.Local:Initialize()
    if not self.IsInstalled then
        Report.InteractiveMineErected = CreateReport("Event_InteractiveMineErected");

        -- Garbage collection
        Lib.IOMine.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.IOMine.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.IOMine.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.IOMine.Name);

