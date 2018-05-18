/*
	ASG_fnc_deployFightingPos
	by:	Diffusion9
*/

params ["_playerBaseVar","_baseType","_deployPos","_deployOffset","_deployDir","_deployNormals"];

//	WAIT FOR ANIMATION, AND THEN DEPLOY FIRST LAYER
uiSleep 3;
missionNamespace setVariable [_playerBaseVar, [_baseType, _deployPos, _deployOffset, _deployDir, _deployNormals] call LAR_fnc_spawnComp];

//	RAISE SANDBAGS UPWARDS AT INTERVALS
_baseObjects = [missionNamespace getVariable _playerBaseVar] call LAR_fnc_getCompObjects;
_counter = 0;
while {_counter <= 7} do {
	uiSleep 11;
	{
		_x setPos (getPos _x vectorAdd [0,0,0.1])
	} forEach _baseObjects;
    _counter = _counter + 1;
};
