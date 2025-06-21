Lib.IOChest = Lib.IOChest or {};
Lib.IOChest.Name = "IOChest";
Lib.IOChest.Global = {};
Lib.IOChest.Local = {};

Lib.Require("comfort/IsHistoryEdition");
Lib.Require("core/Core");
Lib.Require("module/io/IO");
Lib.Require("module/io/IOChest_API");
Lib.Register("module/io/IOChest");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.IOChest.Global:Initialize()
    if not self.IsInstalled then
        Report.InteractiveTreasureActivated = CreateReport("Event_InteractiveTreasureActivated");

        -- Garbage collection
        Lib.IOChest.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.IOChest.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.IOChest.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.ChatClosed then
        if arg[3] then
            self:ProcessChatInput(arg[1]);
        end
    elseif _ID == Report.ObjectReset then
        if CONST_IO[arg[1]] and CONST_IO[arg[1]].IsInteractiveChest then
            self:ResetIOChest(arg[1]);
        end
    elseif _ID == Report.ObjectDelete then
        if CONST_IO[arg[1]] and CONST_IO[arg[1]].IsInteractiveChest then
            -- Nothing to do?
        end
    end
end

function Lib.IOChest.Global:ProcessChatInput(_Text)
    local Commands = Lib.Core.Debug:CommandTokenizer(_Text);
    for i= 1, #Commands, 1 do
        if Commands[i][1] == "goldchest" then
            error(IsExisting(Commands[i][2]), "object " ..Commands[i][2].. " does not exist!");
            CreateRandomGoldChest(Commands[i][2]);
        elseif Commands[i][1] == "goodchest" then
            error(IsExisting(Commands[i][2]), "object " ..Commands[i][2].. " does not exist!");
            CreateRandomResourceChest(Commands[i][2]);
        elseif Commands[i][1] == "luxurychest" then
            error(IsExisting(Commands[i][2]), "object " ..Commands[i][2].. " does not exist!");
            CreateRandomLuxuryChest(Commands[i][2]);
        end
    end
end

function Lib.IOChest.Global:CreateRandomChest(_Name, _Good, _Min, _Max, _DirectPay, _NoModelChange, _Condition, _Action)
    _Min = math.floor((_Min ~= nil and _Min > 0 and _Min) or 1);
    _Max = math.floor((_Max ~= nil and _Max > 1 and _Max) or 2);
    assert(_Good ~= nil, "CreateRandomChest: Good does not exist!");
    assert(_Min <= _Max, "CreateRandomChest: min amount must be smaller or equal than max amount!");

    -- Debug Informationen schreiben
    log(
        "Creating chest (%s, %s, %d, %d, %s, %s)",
        _Name,
        Logic.GetGoodTypeName(_Good),
        _Min,
        _Max,
        tostring(_DirectPay == true),
        tostring(_NoModelChange == true)
    );

    -- Model setzen
    if not _NoModelChange then
        local eID = ReplaceEntity(_Name, Entities.XD_ScriptEntity, 0);
        Logic.SetModel(eID, Models.Doodads_D_X_ChestClose);
        Logic.SetVisible(eID, true);
    end

    -- Menge an Gütern ermitteln
    local GoodAmount = _Min;
    if _Min < _Max then
        GoodAmount = math.random(_Min, _Max);
    end

    -- Rewards
    local DirectReward;
    local IOReward;
    if not _DirectPay then
        IOReward = {_Good, GoodAmount};
    else
        DirectReward = {_Good, GoodAmount};
    end

    SetupObject {
        Name                    = _Name,
        IsInteractiveChest      = true,
        Reward                  = IOReward,
        DirectReward            = DirectReward,
        Texture                 = {1, 6},
        Distance                = (_NoModelChange and 1200) or 650,
        Waittime                = 0,
        State                   = 0,
        DoNotChangeModel        = _NoModelChange == true,
        ActivationCondition     = _Condition,
        ActivationAction        = _Action,
        Condition               = function(_Data)
            if _Data.ActivationCondition then
                return _Data.ActivationCondition(_Data);
            end
            return true;
        end,
        Action                  = function(_Data, _KnightID, _PlayerID)
            if not _Data.DoNotChangeModel then
                Logic.SetModel(GetID(_Data.ScriptName), Models.Doodads_D_X_ChestOpenEmpty);
            end
            if _Data.DirectReward then
                AddGood(_Data.DirectReward[1], _Data.DirectReward[2], _PlayerID);
            end
            if _Data.ActivationAction then
                _Data.ActivationAction(_Data, _KnightID, _PlayerID);
            end

            SendReport(Report.InteractiveTreasureActivated, _Data.ScriptName, _KnightID, _PlayerID);
            SendReportToLocal(Report.InteractiveTreasureActivated, _Data.ScriptName, _KnightID, _PlayerID);
        end,
    };
end

function Lib.IOChest.Global:ResetIOChest(_ScriptName)
    if not CONST_IO[_ScriptName].DoNotChangeModel then
        local EntityID = ReplaceEntity(_ScriptName, Entities.XD_ScriptEntity, 0);
        Logic.SetModel(EntityID, Models.Doodads_D_X_ChestClose);
        Logic.SetVisible(EntityID, true);
    end
end

function Lib.IOChest.Global:CreateRandomGoldChest(_Name)
    self:CreateRandomChest(_Name, Goods.G_Gold, 300, 600, false);
end

function Lib.IOChest.Global:CreateRandomResourceChest(_Name)
    local PossibleGoods = {
        Goods.G_Iron, Goods.G_Stone, Goods.G_Wood, Goods.G_Wool,
        Goods.G_Carcass, Goods.G_Herb, Goods.G_Honeycomb,
        Goods.G_Milk, Goods.G_RawFish, Goods.G_Grain
    };
    local Good = PossibleGoods[math.random(1, #PossibleGoods)];
    self:CreateRandomChest(_Name, Good, 30, 60, false);
end

function Lib.IOChest.Global:CreateRandomLuxuryChest(_Name)
    local Luxury = {Goods.G_Salt, Goods.G_Dye};
    if g_GameExtraNo >= 1 then
        table.insert(Luxury, Goods.G_Gems);
        table.insert(Luxury, Goods.G_MusicalInstrument);
        table.insert(Luxury, Goods.G_Olibanum);
    end
    local Good = Luxury[math.random(1, #Luxury)];
    self:CreateRandomChest(_Name, Good, 50, 100, false);
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.IOChest.Local:Initialize()
    if not self.IsInstalled then
        Report.InteractiveTreasureActivated = CreateReport("Event_InteractiveTreasureActivated");

        self:CreateDefaultObjectNames();

        -- Garbage collection
        Lib.IOChest.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.IOChest.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.IOChest.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.IOChest.Local:CreateDefaultObjectNames()
    AddStringText("UI_ObjectNames/D_X_ChestClosed", {
        de = "Verschlossene Schatztruhe",
        en = "Closed Treasure Chest",
        fr = "Coffre au trésor fermé"
    });
    AddStringText("UI_ObjectNames/D_X_ChestOpenEmpty", {
        de = "Leere Truhe",
        en = "Empty Chest",
        fr = "Coffre vide"
    });
    AddStringText("UI_ObjectNames/D_X_ChestOpen01", {
        de = "Leere Truhe",
        en = "Empty Chest",
        fr = "Coffre vide"
    });
    AddStringText("UI_ObjectNames/D_X_ChestOpen02", {
        de = "Leere Truhe",
        en = "Empty Chest",
        fr = "Coffre vide"
    });
    AddStringText("UI_ObjectNames/D_X_ChestOpen03", {
        de = "Leere Truhe",
        en = "Empty Chest",
        fr = "Coffre vide"
    });
    AddStringText("UI_ObjectNames/D_X_ChestOpen04", {
        de = "Leere Truhe",
        en = "Empty Chest",
        fr = "Coffre vide"
    });
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.IOChest.Name);

