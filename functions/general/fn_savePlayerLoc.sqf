/*
	ASG_fnc_savePlayerLoc
	by:	Diffusion9

	Sets the players logout location (if valid) in the player database.
	Used for spawning players when returning to persistent sessions.

	Exec Type:	CALL
	Input:		0	OBJ	Player to set entry of.
				1	UID	getPlayerUID of the disconnected\connecting player.
				2	FALSE for disconnecting player.
					TRUE for spawning player.
	Output:		Nothing
*/
params ["_unit", "_uid", "_state"];
private ["_unit"];

if (typeName _unit == "STRING") then {_unit = missionNamespace getVariable _unit};

//	LOCATE EXISTING DATABASE ENTRY, PROCESS
_dbIndex = [ASG_pDB, _uid] call KK_fnc_findAll select 0 select 0;
_playerLoc = getPos _unit;

//	LOCATE MARKERS WITHIN X DISTANCE OF DISCONECT POSITION
//	If valid, gather the closest marker and store the name for future spawning.
private ["_completedState"];
if (_state) then {
	//	TRUE - Player is spawning.
	//	Check and clear the position.
	_savedLoc = [ASG_pDB, [_dbIndex,3]] call KK_fnc_findallGetPath;
	if !(_savedLoc isEqualTo "") then {
		//	HAS VALUE -- A Markername
		_savedLocPos = getMarkerPos _savedLoc; 
		_spawnPos = [_savedLocPos, 2, 5, 1, 0, 50, 0, [], _savedLocPos] call BIS_fnc_findSafePos;
		_unit setPos _spawnPos;
		(ASG_pDB select _dbIndex) set [3,""];
		_completedState = true;
		[_unit, "amovpercmstpsnonwnondnon"] remoteExec ["switchMove", allPlayers];
	} else {
		//	HAS NO VALUE -- ""
		//	do nothing.
		_completedState = false;
	};
} else {
	//	FALSE - Player is disconnecting
	//	Check and log the position.
	if (getMarkerPos (allMapMarkers select {_x find "_USER_DEFINED" == -1} select 0) distance (getPos _unit) <= 150) then {
		(ASG_pDB select _dbIndex) set [3,(allMapMarkers select {_x find "_USER_DEFINED" == -1} select 0)];
		_completedState = true;
	} else {
		_completedState = false;
	};
};

_completedState
