Lib.Require("comfort/IsLocalScript");
Lib.Register("module/ui/UIBuilding_API");

function AddBuildingButtonAtPosition(_X, _Y, _Action, _Tooltip, _Update)
    return Lib.UIBuilding.Local:AddButtonBinding(0, _X, _Y, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonAtPosition = AddBuildingButtonAtPosition;

function AddBuildingButton(_Action, _Tooltip, _Update)
    ---@diagnostic disable-next-line: param-type-mismatch
    return AddBuildingButtonAtPosition(nil, nil, _Action, _Tooltip, _Update);
end
API.AddBuildingButton = AddBuildingButton;

function AddBuildingButtonByTypeAtPosition(_Type, _X, _Y, _Action, _Tooltip, _Update)
    return Lib.UIBuilding.Local:AddButtonBinding(_Type, _X, _Y, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByTypeAtPosition = AddBuildingButtonByTypeAtPosition;

function AddBuildingButtonByType(_Type, _Action, _Tooltip, _Update)
    ---@diagnostic disable-next-line: param-type-mismatch
    return AddBuildingButtonByTypeAtPosition(_Type, nil, nil, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByType = AddBuildingButtonByType;

function AddBuildingButtonByEntityAtPosition(_ScriptName, _X, _Y, _Action, _Tooltip, _Update)
    return Lib.UIBuilding.Local:AddButtonBinding(_ScriptName, _X, _Y, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByEntityAtPosition = AddBuildingButtonByEntityAtPosition;

function AddBuildingButtonByEntity(_ScriptName, _Action, _Tooltip, _Update)
    ---@diagnostic disable-next-line: param-type-mismatch
    return AddBuildingButtonByEntityAtPosition(_ScriptName, nil, nil, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByEntity = AddBuildingButtonByEntity;

function DropBuildingButton(_ID)
    Lib.UIBuilding.Local:RemoveButtonBinding(0, _ID);
end
API.DropBuildingButton = DropBuildingButton;

function DropBuildingButtonFromType(_Type, _ID)
    Lib.UIBuilding.Local:RemoveButtonBinding(_Type, _ID);
end
API.DropBuildingButtonFromType = DropBuildingButtonFromType;

function DropBuildingButtonFromEntity(_ScriptName, _ID)
    Lib.UIBuilding.Local:RemoveButtonBinding(_ScriptName, _ID);
end
API.DropBuildingButtonFromEntity = DropBuildingButtonFromEntity;

