/*
	ASG_fnc_setAASWdata
	by:	Diffusion9

	Sets data in the data array.
*/

params ["_primIndex", "_secIndex", "_value"];

private ["_nest"];
_nest = ([AASW_locDB, _primIndex] call BIS_fnc_findNestedElement) select 0;
(AASW_locDB select _nest) set [_secIndex, _value];
