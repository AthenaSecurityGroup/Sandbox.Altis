//	SERVER PARAMS
setViewDistance 2000;												//	View distance.
{_x disableTIEquipment true;} forEach (allMissionObjects "All");	//	Disable thermals.
{_x disableNVGEquipment true;} forEach (allMissionObjects "All");	//	Disable NVGs.
enableEngineArtillery false;										//	Disable auto-calculated artillery.

//	DEDICATED SERVER, OR PLAYER-HOST
if (isServer) then {
	//	INIT PLAYER DISCONNECT EVENT HANDLER
	call ASG_fnc_initAPDH;
	
	//	ACDEP INITIALIZATIOn (SERVER)
	call ASG_fnc_initACDEP;
	
	//	ALOC QUEUE WATCHER
	call ASG_fnc_alocInit;

	//	INIT PLAYER DATABASE
	ASG_pDB = [
		["Diffusion9","76561197972564938",99,""],
		["DEL-J","76561198031485127",99,""]
	];

	// TODO: properly integrate force deployment entrypoint
	[] call compileFinal preprocessFile "ghettoForceDeployEntry.sqf";
};

//	INITIALIZE AASW
call ASG_fnc_initAASW;

//	INITIALIZE ABDEP
call ASG_fnc_bdInit;

//	INITIALIZE DYNAMIC GROUPS
call ASG_fnc_initADYN;

//	INITIALIZE ARCS
call ASG_fnc_ARCSinit;
