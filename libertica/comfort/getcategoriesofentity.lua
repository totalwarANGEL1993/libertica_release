Lib.Require("comfort/GetCategoriesOfType");
Lib.Register("comfort/GetCategoriesOfEntity");

function GetCategoriesOfEntity(_Entity)
    local Type = Logic.GetEntityType(_Entity);
    return GetCategoriesOfType(Type);
end

