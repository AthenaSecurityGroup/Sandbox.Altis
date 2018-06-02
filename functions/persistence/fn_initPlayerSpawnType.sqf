/*

	ASG_fnc_initPlayerSpawnType
	by:	Diffusion9

	When a player respawns, determine what type of respawn.
	Deliver the player via helicopter if they have died, or are new to the server.
	Respawn the player at the appropriate marker if they logged out safely at a base.
	Initiate the standby procedure for the player to wait until the admin has started the campaign.

*/

//	WAIT UNTIL THE SERVER IS READY, AND THEN DETERMINE SPAWN TYPE.
waitUntil {(missionNamespace getVariable ["ASG_serverReady",0]) > 0};

//	IS THERE A STORED POSITION FOR THIS PLAYER?
_player remoteExec ["ASG_fnc_getPlayerDBPos", 2];
_storedPos = player getVariable ["ASG_playerDBPos", ""];
waitUntil {!isNil {_storedPos}};

//	2 = EXISTING SERVER STATE, LOAD USER DATA.
if (ASG_serverReady isEqualTo 2) then {
	//	CHECK FOR SAVED POS, CALL TAXI OR RESPAWN
	if (_storedPos isEqualTo "") then {_player call ASG_fnc_requestPlayerDelivery} else {
		//	CHECK IF SAVED POS STILL VALID. ELSE TAXI
		if !((getMarkerPos _storedPos) isEqualTo [0,0,0]) then {
			_player setPos (getMarkerPos _storedPos);
			[false, "", 4.5] call ASG_fnc_setPlayerState;
		} else {
			_player call ASG_fnc_requestPlayerDelivery;
		};
	};
};
