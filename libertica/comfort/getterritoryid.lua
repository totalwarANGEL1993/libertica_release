Lib.Register("comfort/GetTerritoryID");

function GetTerritoryID(_Name)
    for _, TerritoryID in ipairs{Logic.GetTerritories()} do
        if _Name == Logic.GetTerritoryName(TerritoryID) then
            return TerritoryID;
        end
    end
    return 0;
end
API.GetTerritoryID = GetTerritoryID;

