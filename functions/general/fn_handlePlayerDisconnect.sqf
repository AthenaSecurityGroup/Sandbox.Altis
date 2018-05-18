/*
	ASG_fnc_handlePlayerDisconnect
	by:	Diffusion9

	An event handler which handles players disconnecting from the server.
	Contains a variety of sub-functions kicked off when handler is triggered.

	EXEC TYPE:	Call
	INPUT:		Nothing
	OUTPUT:		Nothing
*/

APDH_handler = addMissionEventHandler ["handleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	//	CLEAN UP PLAYER EQUIPMENT, IF EMPTY
	[_unit] call ASG_fnc_remPlayerObj;

	//	TRACK PLAYER DEPARTURE FOR DATABASE
	//	EXIT IF INCAPACITATED
	if (_unit getVariable "ASGmedical_stateIncap") exitWith {true};
	//	IF NOT INCAPACITATED, SAVE ASGLOC POSITION
	[_unit, _uid, false] call ASG_fnc_savePlayerLoc;
}];
APDH_handler
