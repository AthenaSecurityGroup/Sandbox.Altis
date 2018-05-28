//	SERVER PARAMS
setViewDistance 2000;												//	Max View distance.
{_x disableTIEquipment true;} forEach (allMissionObjects "All");	//	Disable thermals.
{_x disableNVGEquipment true;} forEach (allMissionObjects "All");	//	Disable NVGs.
enableEngineArtillery false;										//	Disable auto-calculated artillery.

//	DEDICATED SERVER, OR PLAYER-HOST
if (isServer) then {
	//	INIT PLAYER DATABASE
	call ASG_fnc_initPlayerDatabase;

	//	INIT CAMPAIGN SEQUENCE (LOAD OR NEW)
	call ASG_fnc_initCampaignStart;

	//	INIT PLAYER DISCONNECT EVENT HANDLER
	call ASG_fnc_handlePlayerDisconnect;
	
	//	LOGISTICS REQUEST QUEUE MONITOR
	call ASG_fnc_initLogistics;

	//	BIS DYNAMIC GROUPS INIT (SERVER-SIDE)
	["Initialize"] call BIS_fnc_dynamicGroups;

	//	PERSISTENCE STATE SAVING
	call ASG_fnc_scheduledStateSave;
};

//	DYNAMIC GROUPS - CLIENT EXEC
if (hasInterface) then {["InitializePlayer", [player]] call BIS_fnc_dynamicGroups};

//	INITIALIZE DEPLOYMENT SYSTEM
call ASG_fnc_initDeployment;

//	INITIALIZE radio
call ASG_fnc_initRadio;
