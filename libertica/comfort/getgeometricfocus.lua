Lib.Require("comfort/GetPosition");
Lib.Register("comfort/GetGeometricFocus");

function GetGeometricFocus(...)
    local arg = {...}
    local PositionData = {X= 0, Y= 0, Z= 0};
    local ValidEntryCount = 0;
    for i= 1, #arg do
        local Position = GetPosition(arg[i]);
        if Position then
            PositionData.X = PositionData.X + Position.X;
            PositionData.Y = PositionData.Y + Position.Y;
            PositionData.Z = PositionData.Z + (Position.Z or 0);
            ValidEntryCount = ValidEntryCount +1;
        end
    end
    return {
        X= PositionData.X * (1/ValidEntryCount);
        Y= PositionData.Y * (1/ValidEntryCount);
        Z= PositionData.Z * (1/ValidEntryCount);
    }
end
API.GetGeometricFocus = GetGeometricFocus;

