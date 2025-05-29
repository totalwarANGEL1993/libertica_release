--- Gibt zurück, ob ein Entity im Sichtfeld eines anderen liegt.

--- Gibt zurück, ob ein Entity im Sichtfeld eines anderen liegt.
--- @param _Target any      Scriptname oder ID des Ziels
--- @param _Viewer any      Scriptname oder ID des Viewer
--- @param _Length integer  Länge des Kegels
--- @param _Width number?   Klemmwinkel (beide Seiten)
--- @return boolean InCone Ziel ist in Sicht
function IsInSight(_Target, _Viewer, _Length, _Width)
    return true
end

