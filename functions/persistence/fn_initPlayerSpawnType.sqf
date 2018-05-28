/*

	ASG_fnc_initPlayerSpawnType
	by:	Diffusion9

	When a player respawns, determine what type of respawn.
	Deliver the player via helicopter if they have died, or are new to the server.
	Respawn the player at the appropriate marker if they logged out safely at a base.
	Initiate the standby procedure for the player to wait until the admin has started the campaign.

*/


if (missionNamespace getVariable ["ASG_newCampaign", true]) then {
	diag_log "NEW CAMPAIGN. WAIT FOR THE ADMIN TO ACT.";
} else {
	//	CAMPAIGN IS ACTIVE, ASK SERVER IF PLAYER HAS STORED LOCATION?
	//	GET PLAYER POSITION FROM THE SERVER
	_player remoteExec ["ASG_fnc_getPlayerDBPos", 2];
	_storedPos = player getVariable ["ASG_playerDBPos", ""];
	
	//	WAIT FOR THE PLAYER TO RECEIVE THE POSITION
	waitUntil {!isNil {_storedPos}};
	if (_storedPos == "" || {isNil {_storedPos}}) then {
		//	IF NO, SEND TAXI REQUEST
		_player call ASG_fnc_requestPlayerDelivery;
	} else {
		//	IF YES, SPAWN THERE
		_player setPos (getMarkerPos _storedPos);
		[false, "", 4.5] call ASG_fnc_setPlayerState;
	};	
};
