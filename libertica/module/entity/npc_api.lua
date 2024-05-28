Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/NPC_API");

function NpcCompose(_Data)
    error(not IsLocalScript(), "NPC manipulated in local script.");
    error(type(_Data) == "table", "NPC must be a table.");
    error(_Data.Name ~= nil, "NPC needs a script name.");
    error(IsExisting(_Data.Name), "Entity does not exist.");

    local Npc = Lib.NPC.Global:GetNpc(_Data.Name);
    error(Npc == nil or not Npc.Active, "NPC already active.");
    error(not _Data.Type or (_Data.Type >= 1 or _Data.Type <= 4), "NPC type is invalid.");
    return Lib.NPC.Global:CreateNpc(_Data);
end
API.NpcCompose = NpcCompose;

function NpcDispose(_Data)
    error(not IsLocalScript(), "NPC manipulated in local script.");
    error(IsExisting(_Data.Name), "Entity does not exist.");
    error(Lib.NPC.Global:GetNpc(_Data.Name) == nil, "NPC must first be composed.");
    Lib.NPC.Global:DestroyNpc(_Data);
end
API.NpcDispose = NpcDispose;

function NpcUpdate(_Data)
    error(not IsLocalScript(), "NPC manipulated in local script.");
    error(IsExisting(_Data.Name), "Entity does not exist.");
    error(Lib.NPC.Global:GetNpc(_Data.Name) ~= nil, "NPC must first be composed.");
    Lib.NPC.Global:UpdateNpc(_Data);
end
API.NpcUpdate = NpcUpdate;

function NpcIsActive(_Data)
    error(not IsLocalScript(), "NPC manipulated in local script.");
    error(IsExisting(_Data.Name), "Entity does not exist.");
    local NPC = Lib.NPC.Global:GetNpc(_Data.Name);
    error(NPC ~= nil, "NPC was not found.");
    if NPC.Active == true then
        return GetInteger(_Data.Name, CONST_SCRIPTING_VALUES.NPC) == 6;
    end
    return false;
end
API.NpcIsActive = NpcIsActive;

function NpcTalkedTo(_Data, _Hero, _PlayerID)
    error(not IsLocalScript(), "NPC manipulated in local script.");
    error(IsExisting(_Data.Name), "Entity does not exist.");

    local NPC = Lib.NPC.Global:GetNpc(_Data.Name);
    error(NPC ~= nil, "NPC was not found.");
    local TalkedTo = NPC.TalkedTo ~= nil and NPC.TalkedTo ~= 0;
    if _Hero and TalkedTo then
        TalkedTo = NPC.TalkedTo == GetID(_Hero);
    end
    if _PlayerID and TalkedTo then
        TalkedTo = Logic.EntityGetPlayer(NPC.TalkedTo) == _PlayerID;
    end
    return TalkedTo;
end
API.NpcTalkedTo = NpcTalkedTo;

