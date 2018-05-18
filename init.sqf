//	SERVER PARAMS
setViewDistance 2000;												//	Max View distance.
{_x disableTIEquipment true;} forEach (allMissionObjects "All");	//	Disable thermals.
{_x disableNVGEquipment true;} forEach (allMissionObjects "All");	//	Disable NVGs.
enableEngineArtillery false;										//	Disable auto-calculated artillery.

//	DEDICATED SERVER, OR PLAYER-HOST
if (isServer) then {
	//	INIT PLAYER DISCONNECT EVENT HANDLER
	call ASG_fnc_initAPDH;
	
	//	ACDEP INITIALIZATIOn (SERVER)
	call ASG_fnc_initCampaignStart;
	
	//	ALOC QUEUE WATCHER
	call ASG_fnc_alocInit;

	//	INIT PLAYER DATABASE
	ASG_pDB = [
		["Diffusion9","76561197972564938",99,""],
		["DEL-J","76561198031485127",99,""],
		["jmlane","76561197967188494",99,""]
	];
};

//	DYNAMIC GROUPS - SERVER EXEC
if (isServer) then {
	// Initializes the Dynamic Groups framework and groups led by a player at mission start will be registered
	["Initialize"] call BIS_fnc_dynamicGroups;
};

//	DYNAMIC GROUPS - CLIENT EXEC
if (hasInterface) then {
	// Initializes the player/client side Dynamic Groups framework and registers the player group
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;
};

//	INITIALIZE DEPLOYMENT SYSTEM
call ASG_fnc_initDeployment;

//	INITIALIZE ARCS
call ASG_fnc_ARCSinit;
