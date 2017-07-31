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
[_player] remoteExec ["ASG_fnc_getASGrank", 2];

//	EARPLUGS
call ASG_fnc_initAEAR;

//	PLAYER NAMETAGS
call ASG_fnc_initANAT;

//	MEDICAL SYSTEM
call ASG_fnc_initACOM;

//	DISABLE SQUAD COMMAND BAR, AND VEH DIRECTION UI
showHUD [true, true, true, true, false, true, false, true];

//	INITIALIZE DYNAMIC GROUPS
call ASG_fnc_initADYN;

//	SEND ALOC CALL FOR HELICOPTER
if !ACDEP_State then {
	//	SEND TAXI REQUEST
	ALOC_reqPVEH = ["PDR", str _player];
	publicVariableServer "ALOC_reqPVEH";
} else {
	//	ACDEP INITIALIZATION (CLIENT)
	[] call ASG_fnc_initACDEP;
};

