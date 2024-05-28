Lib.Require("comfort/IsLocalScript");
Lib.Register("module/trade/Warehouse_API");

function CreateWarehouse(_Data)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Warehouse.Global:CreateWarehouse(_Data);
end
API.CreateWarehouse = CreateWarehouse;

function CreateWarehouseOffer(_Name, _Amount, _GoodOrEntityType, __GoodOrEntityTypeAmount, _Payment, _BasePrice, _Refresh)
    assert(not IsLocalScript(), "Can not be used in local script!");
    return Lib.Warehouse.Global:CreateOffer(_Name, _Amount, _GoodOrEntityType, __GoodOrEntityTypeAmount, _Payment, _BasePrice, _Refresh);
end
API.CreateWarehouseOffer = CreateWarehouseOffer;

function RemoveWarehouseOffer(_Name, _ID)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Warehouse.Global:RemoveOffer(_Name, _ID);
end
API.RemoveWarehouseOffer = RemoveWarehouseOffer;

function DeactivateWarehouseOffer(_Name, _ID, _Deactivate)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Warehouse.Global:ActivateOffer(_Name, _ID, not _Deactivate);
end
API.DeactivateWarehouseOffer = DeactivateWarehouseOffer;

function GetWarehouseInflation(_PlayerID, _GoodOrEntityType)
    if IsLocalScript() then
        return Lib.Warehouse.Local:GetInflation(_PlayerID, _GoodOrEntityType);
    end
    return Lib.Warehouse.Global:GetInflation(_PlayerID, _GoodOrEntityType);
end
API.GetWarehouseInflation = GetWarehouseInflation;

function SetWarehouseInflation(_PlayerID, _GoodOrEntityType, _Inflation)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Warehouse.Global:SetInflation(_PlayerID, _GoodOrEntityType, _Inflation);
end
API.SetWarehouseInflation = SetWarehouseInflation;

function GetWarehouseOfferByID(_Name, _ID)
    if IsLocalScript() then
        return Lib.Warehouse.Local:GetOfferByID(_Name, _ID);
    end
    return Lib.Warehouse.Global:GetOfferByID(_Name, _ID)
end
API.GetWarehouseOfferByID = GetWarehouseOfferByID;

function GetActivWarehouseOffers(_Name, _VisibleOnly)
    if IsLocalScript() then
        return Lib.Warehouse.Local:GetActivOffers(_Name, _VisibleOnly);
    end
    return Lib.Warehouse.Global:GetActivOffers(_Name, _VisibleOnly)
end
API.GetActivWarehouseOffers = GetActivWarehouseOffers;

