params ["_player", "_oldPlayer", "_respawn", "_respawnDelay"];

//	WAIT FOR PLAYER TO INITIALIZE
waitUntil {!(isNull _player)};

//	DISABLE VOICE AND SUBS
oldSubs = showSubtitles false;
_player setSpeaker "NoVoice";
[_player, "NoVoice"] remoteExecCall ["setSpeaker", 0];

//	ZERO VELOCITY, AND MOVE TO MAP CENTER
_player setVelocity [0,0,0];
_player setPos [(worldsize/2),((worldsize/2) + 1000),0];

//	DISABLE PLAYER FOR SPAWN PROCESS
[true, "", 0.001] call ASG_fnc_setPlayerState;

//	SET ASG UNIFORM AND GEAR
[_player] call ASG_fnc_setASGequipment;
// [player] call ASG_fnc_setASGUniform;

//	OBTAIN RANK FROM SERVER
[_player] remoteExec ["ASG_fnc_getPlayerASGRank", 2];

//	EARPLUGS
call ASG_fnc_initEarPro;

//	PLAYER NAMETAGS
call ASG_fnc_initNametags;

//	MEDICAL SYSTEM
call ASG_fnc_initMedical;

//	DISABLE SQUAD COMMAND BAR, AND VEH DIRECTION UI
showHUD [true, true, true, true, false, true, false, true];

//	DYNAMIC GROUPS - CLIENT EXEC
if (hasInterface) then {
	// Initializes the player/client side Dynamic Groups framework and registers the player group
	["InitializePlayer", [_player]] call BIS_fnc_dynamicGroups;
};

//	DETERMINE PLAYER RESPAWN TYPE
//	TRUE	NEW CAMPAIGN
//	FALSE	ACTIVE CAMPAIGN
if !campaignState then {
	//	CAMPAIGN IS ACTIVE, ASK SERVER IF PLAYER HAS STORED LOCATION?
	_player remoteExec ["ASG_fnc_getPlayerDBPos", 2];
	_storedPos = player getVariable ["ASG_playerDBPos", ""];
	waitUntil {!isNil {_storedPos}};
	if (_storedPos == "" || {isNil {_storedPos}}) then {
		//	IF NO, SEND TAXI REQUEST
		_player call ASG_fnc_requestPlayerDelivery;
	} else {
		//	IF YES, SPAWN THERE
		_player setPos (getMarkerPos _storedPos);
		[false, "", 4.5] call ASG_fnc_setPlayerState;
	};
} else {
	//	ACDEP INITIALIZATION (CLIENT)
	[] call ASG_fnc_initCampaignStart;
};
