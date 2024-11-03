Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntityEvent_API");

function ThiefDisableStorehouseEffect(_Flag)
    Lib.EntityEvent.Global.DisableThiefStorehouseHeist = _Flag == true;
end
API.ThiefDisableStorehouseEffect = ThiefDisableStorehouseEffect;

function ThiefDisableCathedralEffect(_Flag)
    Lib.EntityEvent.Global.DisableThiefCathedralSabotage = _Flag == true;
end
API.ThiefDisableCathedralEffect = ThiefDisableCathedralEffect;

function ThiefDisableCisternEffect(_Flag)
    Lib.EntityEvent.Global.DisableThiefCisternSabotage = _Flag == true;
end
API.ThiefDisableCisternEffect = ThiefDisableCisternEffect;

