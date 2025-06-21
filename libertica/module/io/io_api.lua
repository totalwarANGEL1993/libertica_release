Lib.Require("comfort/IsLocalScript");
Lib.Register("module/io/IO_API");

function SetupObject(_Description)
    if GUI then
        return;
    end
    return Lib.IO.Global:CreateObject(_Description);
end
API.SetupObject = SetupObject;
API.CreateObject = SetupObject;

function DisposeObject(_ScriptName)
    if GUI or not CONST_IO[_ScriptName] then
        return;
    end
    Lib.IO.Global:DestroyObject(_ScriptName);
end
API.DisposeObject = DisposeObject;

function ResetObject(_ScriptName)
    if GUI or not CONST_IO[_ScriptName] then
        return;
    end
    Lib.IO.Global:ResetObject(_ScriptName);
    InteractiveObjectDeactivate(_ScriptName);
end
API.ResetObject = ResetObject;

function InteractiveObjectAddCustomName(_Key, _Text)
    local Prefix = (Entities[_Key] and "UI_Names/") or "Names/";
    if not IsLocalScript() then
        ExecuteLocal(
            [[InteractiveObjectSetQuestName("%s", %s)]],
            _Key,
            (type(_Text) == "table" and table.tostring(_Text))
            or ("\"" .. _Text .. "\"")
        );
        return;
    end
    AddStringText(Prefix .. _Key, _Text);
end
API.InteractiveObjectSetQuestName = InteractiveObjectAddCustomName;

function InteractiveObjectDeleteCustomName(_Key)
    local Prefix = (Entities[_Key] and "UI_Names/") or "Names/";
    if not IsLocalScript() then
        ExecuteLocal([[InteractiveObjectDeleteCustomName("%s")]], _Key);
        return;
    end
    DeleteStringText(Prefix .. _Key);
end
API.InteractiveObjectUnsetQuestName = InteractiveObjectDeleteCustomName;

function AllowActivateIronMines(_PlayerID, _Allowed)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Logic.TechnologySetState(_PlayerID, Technologies.R_RefillIronMine, (_Allowed and 3 or 1));
end
API.AllowActivateIronMines = AllowActivateIronMines;

function RequireTitleToRefilIronMines(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], 1, Technologies.R_RefillIronMine)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], 1, Technologies.R_RefillIronMine);
    CreateTechnologyKnightTitleTable()
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_RefillIronMine, 0);
    end
end
API.RequireTitleToRefilIronMines = RequireTitleToRefilIronMines;

function AllowActivateStoneMines(_PlayerID, _Allowed)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Logic.TechnologySetState(_PlayerID, Technologies.R_RefillStoneMine, (_Allowed and 3 or 1));
end
API.AllowActivateStoneMines = AllowActivateStoneMines;

function RequireTitleToRefilStoneMines(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], 1, Technologies.R_RefillStoneMine)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], 1, Technologies.R_RefillStoneMine);
    CreateTechnologyKnightTitleTable()
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_RefillStoneMine, 0);
    end
end
API.RequireTitleToRefilStoneMines = RequireTitleToRefilStoneMines;

function AllowActivateCisterns(_PlayerID, _Allowed)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Logic.TechnologySetState(_PlayerID, Technologies.R_RefillCistern, (_Allowed and 3 or 1));
end
API.AllowActivateCisterns = AllowActivateCisterns;

function RequireTitleToRefilCisterns(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], 1, Technologies.R_RefillCistern)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], 1, Technologies.R_RefillCistern);
    CreateTechnologyKnightTitleTable()
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_RefillCisternMine, 0);
    end
end
API.RequireTitleToRefilCisterns = RequireTitleToRefilCisterns;

function AllowActivateTradepost(_PlayerID, _Allowed)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Logic.TechnologySetState(_PlayerID, Technologies.R_Tradepost, (_Allowed and 3 or 1));
end
API.AllowActivateTradepost = AllowActivateTradepost;

function RequireTitleToBuildTradeposts(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], 1, Technologies.R_Tradepost)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], 1, Technologies.R_Tradepost);
    CreateTechnologyKnightTitleTable();
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_Tradepost, 0);
    end
end
API.RequireTitleToBuildTradeposts = RequireTitleToBuildTradeposts;

InteractiveObjectActivate = function(_ScriptName, _State, ...)
    arg = arg or {1};
    if not IsLocalScript() then
        if CONST_IO[_ScriptName] then
            local SlaveName = (CONST_IO[_ScriptName].Slave or _ScriptName);
            if CONST_IO[_ScriptName].Slave then
                CONST_IO_SLAVE_STATE[SlaveName] = 1;
                Logic.ExecuteInLuaLocalState(string.format(
                    [[CONST_IO_SLAVE_STATE["%s"] = 1]],
                    SlaveName
                ));
            end
            Lib.IO.Global:SetObjectState(SlaveName, _State, unpack(arg));
            CONST_IO[_ScriptName].IsActive = true;
            ExecuteLocal([[CONST_IO["%s"].IsActive = true]], _ScriptName);
        else
            Lib.IO.Global:SetObjectState(_ScriptName, _State, unpack(arg));
        end
    end
end
API.InteractiveObjectActivate = InteractiveObjectActivate;

InteractiveObjectDeactivate = function(_ScriptName, ...)
    arg = arg or {1};
    if not IsLocalScript() then
        if CONST_IO[_ScriptName] then
            local SlaveName = (CONST_IO[_ScriptName].Slave or _ScriptName);
            if CONST_IO[_ScriptName].Slave then
                CONST_IO_SLAVE_STATE[SlaveName] = 0;
                Logic.ExecuteInLuaLocalState(string.format(
                    [[CONST_IO_SLAVE_STATE["%s"] = 0]],
                    SlaveName
                ));
            end
            Lib.IO.Global:SetObjectState(SlaveName, 2, unpack(arg));
            CONST_IO[_ScriptName].IsActive = false;
            ExecuteLocal([[CONST_IO["%s"].IsActive = false]], _ScriptName);
        else
            Lib.IO.Global:SetObjectState(_ScriptName, 2, unpack(arg));
        end
    end
end
API.InteractiveObjectDeactivate = InteractiveObjectDeactivate;

