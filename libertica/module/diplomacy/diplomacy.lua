Lib.Diplomacy = Lib.Diplomacy or {};
Lib.Diplomacy.Name = "Diplomacy";
Lib.Diplomacy.Global = {
    DiplomacyBackup = {},
};
Lib.Diplomacy.Local  = {};

Lib.Require("core/Core");
Lib.Require("module/diplomacy/Diplomacy_API");
Lib.Register("module/diplomacy/Diplomacy");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Diplomacy.Global:Initialize()
    if not self.IsInstalled then
        Report.DiplomacyChanged = CreateReport("Event_DiplomacyChanged");

        self:OverwriteDiplomaticEntity();

        -- Garbage collection
        Lib.Diplomacy.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Diplomacy.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Diplomacy.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.Diplomacy.Global:SaveDiplomacy()
    if #self.DiplomacyBackup == 0 then
        for PlayerID1 = 1, 8 do
            self.DiplomacyBackup[PlayerID1] = {};
            for PlayerID2 = 1, 8 do
                if PlayerID1 ~= PlayerID2 then
                    self.DiplomacyBackup[PlayerID1][PlayerID2] = GetDiplomacyState(PlayerID1, PlayerID2);
                end
            end
        end
    end
end

function Lib.Diplomacy.Global:SetDiplomacyStateForPlayer(_PlayerID, _State, _PlayerList)
    local State = _State or DiplomacyStates.Undecided;
    self:SaveDiplomacy();
    for i = 1, #_PlayerList do
        if _PlayerID ~= _PlayerList[i] then
            SetDiplomacyState(_PlayerID, _PlayerList[i], State);
        end
    end
end

function Lib.Diplomacy.Global:ResetDiplomacy()
    if #self.DiplomacyBackup ~= 0 then
        for PlayerID1 = 1, 8 do
            for PlayerID2 = 1, 8 do
                SetDiplomacyState(PlayerID1, PlayerID2, self.DiplomacyBackup[PlayerID1][PlayerID2]);
            end
        end
        self.DiplomacyBackup = {};
    end
end

function Lib.Diplomacy.Global:OverwriteDiplomaticEntity()
    self.Orig_DiplomaticEntity_OnDiplomacyStatusChange = DiplomaticEntity.OnDiplomacyStatusChange;
    DiplomaticEntity.OnDiplomacyStatusChange = function(_this, _relation, _diplomaticEntity, _oldState)
        -- Send event
        SendReport(Report.DiplomacyChanged, _this.ID, _diplomaticEntity.ID, _oldState, _relation.Status.State);
        SendReportToLocal(Report.DiplomacyChanged, _this.ID, _diplomaticEntity.ID, _oldState, _relation.Status.State);
        -- Call original
        Lib.Diplomacy.Global.Orig_DiplomaticEntity_OnDiplomacyStatusChange(_this, _relation, _diplomaticEntity, _oldState);
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Diplomacy.Local:Initialize()
    if not self.IsInstalled then
        Report.DiplomacyChanged = CreateReport("Event_DiplomacyChanged");

        -- Garbage collection
        Lib.Diplomacy.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Diplomacy.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.Diplomacy.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Diplomacy.Name);

