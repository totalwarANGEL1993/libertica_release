Lib.Require("comfort/GetAngleBetween");
Lib.Register("comfort/IsInCone");

function IsInCone(_Position, _Center, _MiddleAlpha, _BetaAvaiable)
	local a = GetAngleBetween(_Center, _Position);
	local lb = _MiddleAlpha - _BetaAvaiable;
	local hb = _MiddleAlpha + _BetaAvaiable;
	if a >= lb and a <= hb then
		return true;
	end
	if (a + 180) % 360 >= (lb + 180) % 360 and (a + 180) % 360 <= (hb + 180) % 360 then
		return true;
    end
    return false;
end
API.IsInCone = IsInCone;

