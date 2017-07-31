/*

	KK_fnc_isFlatEmpty
	by: Killzone Kid
	from: https://community.bistudio.com/wiki/isFlatEmpty

	EXEC TYPE:	Call
	INPUT:		0	ARRAY	Position to check
				1	ARRAY	Params for isFlatEmpty in format:
					[minDistance, mode, maxGradient, maxGradientRadius, overLandOrWater, shoreLine, ignoreObject]
	OUTPUT:		0	ARRAY	Position.
*/

params ["_pos", "_params"];
_pos = _pos findEmptyPosition [0, _params select 0];
if (_pos isEqualTo []) exitWith {[]};
_params =+ _params;
_params set [0, -1];
_pos = _pos isFlatEmpty _params;
if (_pos isEqualTo []) exitWith {[]};
_pos
