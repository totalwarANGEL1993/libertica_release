--- Sends a cart with a good to a player.

--- Sends a cart with a good to a player.
--- @param _Position any ID or script name
--- @param _PlayerID integer Receiving player ID
--- @param _GoodType integer Type of good
--- @param _Amount integer Amount of good
--- @param _CartOverlay? integer Type of cart
--- @param _IgnoreReservation? boolean Ignore if market full
--- @param _Overtake? boolean Replace script entity
--- @return integer ID ID of cart
function SendCart(_Position, _PlayerID, _GoodType, _Amount, _CartOverlay, _IgnoreReservation, _Overtake)
    return 0;
end
API.SendCart = SendCart;

