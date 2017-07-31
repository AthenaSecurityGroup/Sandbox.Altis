/*
	ASG_fnc_getAASWdata
	by:	Diffusion9

	Gets data from the AASW data.
*/

params ["_location", "_index"];

_locDBindex = [AASW_locDB, [_location]] call KK_fnc_findAllGetPath;
_value = _locDBindex select _index;

_value
