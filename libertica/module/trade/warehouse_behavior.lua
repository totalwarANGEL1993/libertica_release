Lib.Register("module/trade/Warehouse_Behavior");

B_Reward_TradePost.DEBUG_Orig_Warehouse = B_Reward_TradePost.DEBUG;
--- @diagnostic disable-next-line: duplicate-set-field
B_Reward_TradePost.DEBUG = function(self, _Quest)
    local Index = Lib.Warehouse.Global:GetIndex(self.ScriptName);
    if Index ~= 0 then
        debug(false, _Quest.Identifier .. ": Error in " .. self.Name ..": Can not use a tradepost that is already a warehouse!");
        return false;
    end
    return self:DEBUG_Orig_Warehouse(_Quest);
end

B_Reward_TradePost.CustomFunction_Orig_Warehouse = B_Reward_TradePost.CustomFunction;
--- @diagnostic disable-next-line: duplicate-set-field
B_Reward_TradePost.CustomFunction = function(self, _Quest)
    local Index = Lib.Warehouse.Global:GetIndex(self.ScriptName);
    if Index ~= 0 then
        debug(false, _Quest.Identifier .. ": Error in " .. self.Name ..": Can not use a tradepost that is already a warehouse!");
        return;
    end
    self:CustomFunction_Orig_Warehouse(_Quest);
end

-- -------------------------------------------------------------------------- --

