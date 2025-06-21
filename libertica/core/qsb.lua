Lib.Register("core/QSB");

--- @diagnostic disable: cast-local-type
--- @diagnostic disable: duplicate-set-field
--- @diagnostic disable: missing-return-value

ParameterType = ParameterType or {};
Report = Report or {};

g_QuestBehaviorVersion = 1;
g_QuestBehaviorTypes = {};

g_GameExtraNo = 0;
if Framework then
    g_GameExtraNo = Framework.GetGameExtraNo();
elseif MapEditor then
    g_GameExtraNo = MapEditor.GetGameExtraNo();
end

function LoadBehaviors()
    for i= 1, #g_QuestBehaviorTypes, 1 do
        local Behavior = g_QuestBehaviorTypes[i];

        if not _G["B_" .. Behavior.Name].new then
            _G["B_" .. Behavior.Name].new = function(self, ...)
                local parameter = {...};
                local behavior = table.copy(self);
                -- Raw parameters
                behavior.i47ya_6aghw_frxil = {};
                -- Overhead parameters
                behavior.v12ya_gg56h_al125 = {};
                for j= 1, #parameter, 1 do
                    table.insert(behavior.v12ya_gg56h_al125, parameter[j]);
                    if self.Parameter and self.Parameter[j] ~= nil then
                        behavior:AddParameter(j-1, parameter[j]);
                    else
                        table.insert(behavior.i47ya_6aghw_frxil, parameter[j]);
                    end
                end
                return behavior;
            end
        end
    end
end

function RegisterBehavior(_Behavior)
    if GUI ~= nil then
        return;
    end
    if type(_Behavior) ~= "table" or _Behavior.Name == nil then
        assert(false, "Behavior is invalid!");
        return;
    end
    if _Behavior.RequiresExtraNo and _Behavior.RequiresExtraNo > g_GameExtraNo then
        return;
    end
    if not _G["B_" .. _Behavior.Name] then
        error(string.format("Behavior %s does not exist!", _Behavior.Name));
        return;
    end

    for i= 1, #g_QuestBehaviorTypes, 1 do
        if g_QuestBehaviorTypes[i].Name == _Behavior.Name then
            return;
        end
    end

    if _Behavior.CustomFunction then
        if not _Behavior.CustomFunction_Orig then
            _Behavior.CustomFunction_Orig = _Behavior.CustomFunction;
            _Behavior.CustomFunction = function(_self, _quest)
                if Lib.Core.Debug.CheckAtRun
                and _self.DEBUG
                and not _self.DEBUG_ERROR_FOUND
                and _self:Debug(_quest)
                then
                    _self.DEBUG_ERROR_FOUND = true
                end
                return _self:CustomFunction_Orig(_quest);
            end
        end
    end

    table.insert(g_QuestBehaviorTypes, _Behavior);
end

