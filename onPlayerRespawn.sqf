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

//	INIT DYNAMIC GROUPS
["InitializePlayer", [_player]] call BIS_fnc_dynamicGroups;

//	DETERMINE PLAYER RESPAWN TYPE
call ASG_fnc_initPlayerSpawnType;
