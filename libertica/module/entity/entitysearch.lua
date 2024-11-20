Lib.EntitySearch = Lib.EntitySearch or {};
Lib.EntitySearch.Name = "EntitySearch";
Lib.EntitySearch.Global = {};
Lib.EntitySearch.Local  = {};
Lib.EntitySearch.Shared  = {
    Filters = {
        ["__Default"] = function(_ID) return true; end,
    },
    Caches = {
        Entity = {},
        Filter = {},
    },
};

Lib.Require("comfort/GetPosition");
Lib.Require("comfort/GetDistance");
Lib.Require("core/Core");
Lib.Require("module/entity/EntitySearch_API");
Lib.Register("module/entity/EntitySearch");

-- Global ------------------------------------------------------------------- --

function Lib.EntitySearch.Global:Initialize()
end

function Lib.EntitySearch.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

-- Local -------------------------------------------------------------------- --

function Lib.EntitySearch.Local:Initialize()
end

function Lib.EntitySearch.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

-- Shared ------------------------------------------------------------------- --

function Lib.EntitySearch.Shared:CreateFilter(_Identifier, _Function)
    self.Filters[_Identifier] = _Function;
end

function Lib.EntitySearch.Shared:DropFilter(_Identifier)
    self.Filters[_Identifier] = nil;
end

function Lib.EntitySearch.Shared:IterateOverEntities(_Filter)
    local FilterName = (self.Filters[_Filter] and _Filter) or "__Default";
    local Time = math.floor(Logic.GetTime());
    local ResultList = {};
    local AllEntities;

    -- Invoke filter cache if not too old and return cache
    if self.Caches.Filter[FilterName] and self.Caches.Filter[FilterName][1] then
        -- Clear to old result...
        if self.Caches.Filter[FilterName][1] +3 <= Time then
            self.Caches.Filter[FilterName] = nil;
        -- ...or use cache
        elseif FilterName ~= "__Default" and self.Caches.Filter[FilterName][1] +1 <= Time then
            return self.Caches.Filter[FilterName][2];
        end
    end

    -- Invoke entity cache if not to old or scan all entities
    if self.Caches.Entity[1] and self.Caches.Entity[1] +1 > Time then
        AllEntities = self.Caches.Entity[2];
    else
        AllEntities = {};
        for _, v in pairs(Entities) do
            for _, ID in pairs(Logic.GetEntitiesOfType(v)) do
                AllEntities[#AllEntities +1] = ID;
            end
        end
        self.Caches.Entity = {Time, AllEntities};
    end

    -- Do actual search and save results in cache
    local Filter = self.Filters[_Filter] or self.Filters["__Default"];
    for i= 1, #AllEntities do
        if Filter(AllEntities[i]) then
            ResultList[#ResultList +1] = AllEntities[i];
        end
    end
    self.Caches.Filter[FilterName] = {Time, ResultList};
    return ResultList;
end

function Lib.EntitySearch.Shared:SearchEntities(_PlayerID, _WithoutDefeatResistant)
    if _WithoutDefeatResistant == nil then
        _WithoutDefeatResistant = false;
    end

    local Time = math.floor(Logic.GetTime());
    local Key = "hupl_".._PlayerID.."_"..tostring(_WithoutDefeatResistant);

    local Function = function(_ID)
        if _PlayerID and Logic.EntityGetPlayer(_ID) ~= _PlayerID then
            return false;
        end
        if _WithoutDefeatResistant then
            if (Logic.IsBuilding(_ID) or Logic.IsWall(_ID)) and Logic.IsConstructionComplete(_ID) == 0 then
                return false;
            end
            local Type = Logic.GetEntityType(_ID);
            local TypeName = Logic.GetEntityType(Type);
            if TypeName and (string.find(TypeName, "^S_") or string.find(TypeName, "^XD_")) then
                return false;
            end
        end
        return true;
    end

    if not self.Filters[Key] then
        self:CreateFilter(Key, Function);
    end
    if  self.Caches.Filter[Key]
    and self.Caches.Filter[Key][2]
    and self.Caches.Filter[Key][1] +1 > Time then
        return self.Caches.Entity[Key][2];
    end
    return CommenceEntitySearch(Key);
end

function Lib.EntitySearch.Shared:SearchEntitiesByScriptname(_Pattern)
    local Time = math.floor(Logic.GetTime());

    local Key = "name_".._Pattern;

    local Function = function(_ID)
        local ScriptName = Logic.GetEntityName(_ID);
        if not string.find(ScriptName, _Pattern) then
            return false;
        end
        return true;
    end

    if not self.Filters[Key] then
        self:CreateFilter(Key, Function);
    end
    if  self.Caches.Filter[Key]
    and self.Caches.Filter[Key][2]
    and self.Caches.Filter[Key][1] +1 > Time then
        return self.Caches.Entity[Key][2];
    end
    return CommenceEntitySearch(Key);
end

function Lib.EntitySearch.Shared:SearchEntitiesInArea(_Area, _Position, _PlayerID, _Type, _Category)
    local Time = math.floor(Logic.GetTime());
    local Position = _Position;
    if type(Position) ~= "table" then
        Position = GetPosition(Position);
    end

    local a = _Area;
    local x,y = Position.X, Position.Y;
    local p = _PlayerID;
    local t = _Type;
    local c = _Category;

    local Key = "area_"..a.."_"..x.."_"..y.."_"..p.."_"..t.."_"..c;

    local Function = function(_ID)
        if _PlayerID and Logic.EntityGetPlayer(_ID) ~= _PlayerID then
            return false;
        end
        if _Type and Logic.GetEntityType(_ID) ~= _Type then
            return false;
        end
        if _Category and Logic.IsEntityInCategory(_ID, _Category) == 0 then
            return false;
        end
        if GetDistance(_ID, Position) > _Area then
            return false;
        end
        return true;
    end

    if not self.Filters[Key] then
        self:CreateFilter(Key, Function);
    end
    if  self.Caches.Filter[Key]
    and self.Caches.Filter[Key][2]
    and self.Caches.Filter[Key][1] +1 > Time then
        return self.Caches.Entity[Key][2];
    end
    return CommenceEntitySearch(Key);
end

function Lib.EntitySearch.Shared:SearchEntitiesInTerritory(_Territory, _PlayerID, _Type, _Category)
    local Time = math.floor(Logic.GetTime());

    local a = _Territory;
    local p = _PlayerID;
    local t = _Type or "0";
    local c = _Category or "0";

    local Key = "teri_"..a.."_"..p.."_"..t.."_"..c;

    local Function = function(_ID)
        if _PlayerID and Logic.EntityGetPlayer(_ID) ~= _PlayerID then
            return false;
        end
        if _Type and Logic.GetEntityType(_ID) ~= _Type then
            return false;
        end
        if _Category and Logic.IsEntityInCategory(_ID, _Category) == 0 then
            return false;
        end
        if _Territory and GetTerritoryUnderEntity(_ID) ~= _Territory then
            return false;
        end
        return true;
    end

    if not self.Filters[Key] then
        self:CreateFilter(Key, Function);
    end
    if  self.Caches.Filter[Key]
    and self.Caches.Filter[Key][2]
    and self.Caches.Filter[Key][1] +1 > Time then
        return self.Caches.Entity[Key][2];
    end
    return CommenceEntitySearch(Key);
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.EntitySearch.Name);

