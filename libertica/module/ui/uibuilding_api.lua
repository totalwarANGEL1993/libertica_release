Lib.Require("comfort/IsLocalScript");
Lib.Register("module/ui/UIBuilding_API");

function AddBuildingButtonAtPosition(_X, _Y, _Action, _Tooltip, _Update)
    assert(IsLocalScript());
    Lib.UIBuilding.AquireContext();
    local Button = this:AddButtonBinding(0, _X, _Y, _Action, _Tooltip, _Update);
    Lib.UIBuilding.ReleaseContext();
    return Button;
end
API.AddBuildingButtonAtPosition = AddBuildingButtonAtPosition;

function AddBuildingButton(_Action, _Tooltip, _Update)
    ---@diagnostic disable-next-line: param-type-mismatch
    return AddBuildingButtonAtPosition(nil, nil, _Action, _Tooltip, _Update);
end
API.AddBuildingButton = AddBuildingButton;

function AddBuildingButtonByTypeAtPosition(_Type, _X, _Y, _Action, _Tooltip, _Update)
    assert(IsLocalScript());
    Lib.UIBuilding.AquireContext();
    local Button = this:AddButtonBinding(_Type, _X, _Y, _Action, _Tooltip, _Update);
    Lib.UIBuilding.ReleaseContext();
    return Button;
end
API.AddBuildingButtonByTypeAtPosition = AddBuildingButtonByTypeAtPosition;

function AddBuildingButtonByType(_Type, _Action, _Tooltip, _Update)
    ---@diagnostic disable-next-line: param-type-mismatch
    return AddBuildingButtonByTypeAtPosition(_Type, nil, nil, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByType = AddBuildingButtonByType;

function AddBuildingButtonByEntityAtPosition(_ScriptName, _X, _Y, _Action, _Tooltip, _Update)
    assert(IsLocalScript());
    Lib.UIBuilding.AquireContext();
    local Button = this:AddButtonBinding(_ScriptName, _X, _Y, _Action, _Tooltip, _Update);
    Lib.UIBuilding.ReleaseContext();
    return Button;
end
API.AddBuildingButtonByEntityAtPosition = AddBuildingButtonByEntityAtPosition;

function AddBuildingButtonByEntity(_ScriptName, _Action, _Tooltip, _Update)
    ---@diagnostic disable-next-line: param-type-mismatch
    return AddBuildingButtonByEntityAtPosition(_ScriptName, nil, nil, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByEntity = AddBuildingButtonByEntity;

function DropBuildingButton(_ID)
    assert(IsLocalScript());
    Lib.UIBuilding.AquireContext();
    this:RemoveButtonBinding(0, _ID);
    Lib.UIBuilding.ReleaseContext();
end
API.RemoveCustomBuildingButton = DropBuildingButton;
API.DropBuildingButton = DropBuildingButton;

function DropBuildingButtonFromType(_Type, _ID)
    assert(IsLocalScript());
    Lib.UIBuilding.AquireContext();
    this:RemoveButtonBinding(_Type, _ID);
    Lib.UIBuilding.ReleaseContext();
end
API.DropBuildingButtonFromType = DropBuildingButtonFromType;

function DropBuildingButtonFromEntity(_ScriptName, _ID)
    assert(IsLocalScript());
    Lib.UIBuilding.AquireContext();
    this:RemoveButtonBinding(_ScriptName, _ID);
    Lib.UIBuilding.ReleaseContext();
end
API.DropBuildingButtonFromEntity = DropBuildingButtonFromEntity;

function ActivateDowngradeBuilding()
    error(not IsLocalScript(), "Can only be used in global script!");
    ExecuteLocal([[Lib.UIBuilding.Local.ExtraButton.Downgrade:Activate()]]);
end
API.ActivateDowngradeBuilding = ActivateDowngradeBuilding;

function DeactivateDowngradeBuilding()
    error(not IsLocalScript(), "Can only be used in global script!");
    ExecuteLocal([[Lib.UIBuilding.Local.ExtraButton.Downgrade:Deactivate()]]);
end
API.DeactivateDowngradeBuilding = DeactivateDowngradeBuilding;

function SetDowngradeBuildingCost(_MoneyCost)
    error(not IsLocalScript(), "Can only be used in global script!");
    error(type(_MoneyCost) == "number", "Costs must be a number!");
    ExecuteLocal([[Lib.UIBuilding.Local.ExtraButton.Downgrade:SetCost(%d)]], _MoneyCost or 0)
end
API.SetDowngradeCosts = SetDowngradeBuildingCost;
API.SetDowngradeBuildingCost = SetDowngradeBuildingCost;

function ActivateSingleReserveBuilding()
    error(not IsLocalScript(), "Can only be used in global script!");
    ExecuteLocal([[Lib.UIBuilding.Local.ExtraButton.SingleReserve:Activate()]]);
end
API.ActivateSingleReserveBuilding = ActivateSingleReserveBuilding;

function DeactivateSingleReserveBuilding()
    error(not IsLocalScript(), "Can only be used in global script!");
    ExecuteLocal([[Lib.UIBuilding.Local.ExtraButton.SingleReserve:Deactivate()]]);
end
API.DeactivateSingleReserveBuilding = DeactivateSingleReserveBuilding;

function ActivateSingleStopBuilding()
    error(not IsLocalScript(), "Can only be used in global script!");
    ExecuteLocal([[Lib.UIBuilding.Local.ExtraButton.SingleStop:Activate()]]);
end
API.ActivateSingleStopBuilding = ActivateSingleStopBuilding;

function DeactivateSingleStopBuilding()
    error(not IsLocalScript(), "Can only be used in global script!");
    ExecuteLocal([[Lib.UIBuilding.Local.ExtraButton.SingleStop:Deactivate()]]);
end
API.DeactivateSingleStopBuilding = DeactivateSingleStopBuilding;




API.UseDowngrade = function(_Flag)
    if _Flag then
        ActivateDowngradeBuilding();
        return;
    end
    DeactivateDowngradeBuilding();
end

API.UseSingleReserve = function(_Flag)
    if _Flag then
        ActivateSingleReserveBuilding();
        return;
    end
    DeactivateSingleReserveBuilding();
end

API.UseSingleStop = function(_Flag)
    if _Flag then
        ActivateSingleStopBuilding();
        return;
    end
    DeactivateSingleStopBuilding();
end

