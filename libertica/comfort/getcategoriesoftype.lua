Lib.Register("comfort/GetCategoriesOfType");

function GetCategoriesOfType(_Type)
    local Categories = {};
    for k, v in pairs(EntityCategories) do
        if Logic.IsEntityTypeInCategory(_Type, v) == 1 then
            table.insert(Categories, v);
        end
    end
    return Categories;
end

