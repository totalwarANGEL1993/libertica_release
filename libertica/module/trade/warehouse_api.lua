Lib.Require("comfort/IsLocalScript");
Lib.Register("module/trade/Warehouse_API");

function CreateWarehouse(_Data)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Warehouse.AquireContext();
    this:CreateWarehouse(_Data);
    Lib.Warehouse.ReleaseContext();
end
API.CreateWarehouse = CreateWarehouse;

function CreateWarehouseOffer(_Name, _Amount, _GoodOrEntityType, __GoodOrEntityTypeAmount, _Payment, _BasePrice, _Refresh)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Warehouse.AquireContext();
    local Offer = this:CreateOffer(_Name, _Amount, _GoodOrEntityType, __GoodOrEntityTypeAmount, _Payment, _BasePrice, _Refresh);
    Lib.Warehouse.ReleaseContext();
    return Offer;
end
API.CreateWarehouseOffer = CreateWarehouseOffer;

function RemoveWarehouseOffer(_Name, _ID)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Warehouse.AquireContext();
    this:RemoveOffer(_Name, _ID);
    Lib.Warehouse.ReleaseContext();
end
API.RemoveWarehouseOffer = RemoveWarehouseOffer;

function DeactivateWarehouseOffer(_Name, _ID, _Deactivate)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Warehouse.AquireContext();
    this:ActivateOffer(_Name, _ID, not _Deactivate);
    Lib.Warehouse.ReleaseContext();
end
API.DeactivateWarehouseOffer = DeactivateWarehouseOffer;

function GetWarehouseInflation(_PlayerID, _GoodOrEntityType)
    Lib.Warehouse.AquireContext();
    local Inflation = this:GetInflation(_PlayerID, _GoodOrEntityType);
    Lib.Warehouse.ReleaseContext();
    return Inflation;
end
API.GetWarehouseInflation = GetWarehouseInflation;

function SetWarehouseInflation(_PlayerID, _GoodOrEntityType, _Inflation)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Lib.Warehouse.AquireContext();
    this:SetInflation(_PlayerID, _GoodOrEntityType, _Inflation);
    Lib.Warehouse.ReleaseContext();
end
API.SetWarehouseInflation = SetWarehouseInflation;

function GetWarehouseOfferByID(_Name, _ID)
    Lib.Warehouse.AquireContext();
    local Offer = this:GetOfferByID(_Name, _ID);
    Lib.Warehouse.ReleaseContext();
    return Offer;
end
API.GetWarehouseOfferByID = GetWarehouseOfferByID;

function GetActivWarehouseOffers(_Name, _VisibleOnly)
    Lib.Warehouse.AquireContext();
    local Active = this:GetActivOffers(_Name, _VisibleOnly);
    Lib.Warehouse.ReleaseContext();
    return Active;
end
API.GetActivWarehouseOffers = GetActivWarehouseOffers;

