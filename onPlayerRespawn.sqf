params ["_player", "_oldPlayer", "_respawn", "_respawnDelay"];

//	WAIT FOR PLAYER TO INITIALIZE
waitUntil {!(isNull player)};

//	DISABLE VOICE AND SUBS
oldSubs = showSubtitles false;
_player setSpeaker "NoVoice";
[_player, "NoVoice"] remoteExecCall ["setSpeaker", 0];

//	DISABLE PLAYER FOR SPAWN PROCESS
[true, "", 0.001] call ASG_fnc_setPlayerState;

//	SET ASG UNIFORM AND GEAR
[_player] call ASG_fnc_setASGequipment;// [player] call ASG_fnc_setASGUniform;

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
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;
};

//	SEND logistics CALL FOR HELICOPTER
if !ACDEP_State then {
	//	SEND TAXI REQUEST
	logistics_reqPVEH = ["PDR", str _player];
	publicVariableServer "logistics_reqPVEH";
} else {
	//	ACDEP INITIALIZATION (CLIENT)
	[] call ASG_fnc_initCampaignStart;
};

