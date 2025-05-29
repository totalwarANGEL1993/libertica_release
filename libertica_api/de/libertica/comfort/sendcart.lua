--- Schickt einen Wagen mit einer Ware zu einem Spieler.

--- Schickt einen Wagen mit einer Ware zu einem Spieler.
--- @param _Position any ID oder Skriptname
--- @param _PlayerID integer Spieler-ID des Empfängers
--- @param _GoodType integer Typ der Ware
--- @param _Amount integer Menge der Ware
--- @param _CartOverlay? integer Typ des Karren
--- @param _IgnoreReservation? boolean Belegten Marktplatz ignorieren
--- @param _Overtake? boolean Skriptentität ersetzen
--- @return integer ID ID des Karren
function SendCart(_Position, _PlayerID, _GoodType, _Amount, _CartOverlay, _IgnoreReservation, _Overtake)
    return 0;
end
API.SendCart = SendCart;

