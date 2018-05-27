//	SERVER PARAMS
setViewDistance 2000;												//	Max View distance.
{_x disableTIEquipment true;} forEach (allMissionObjects "All");	//	Disable thermals.
{_x disableNVGEquipment true;} forEach (allMissionObjects "All");	//	Disable NVGs.
enableEngineArtillery false;										//	Disable auto-calculated artillery.

//	DEDICATED SERVER, OR PLAYER-HOST
if (isServer) then {
	//	INIT PLAYER DISCONNECT EVENT HANDLER
	call ASG_fnc_handlePlayerDisconnect;
	
	//	CAMPAIGN INITIALIZATION (SERVER)
	call ASG_fnc_initCampaignStart;
	
	//	LOGISTICS REQUEST QUEUE MONITOR
	call ASG_fnc_initLogistics;

	//	INIT PLAYER DATABASE
	ASG_pDB = [
		["Diffusion9","76561197972564938",99,""],
		["DEL-J","76561198031485127",99,""],
		["jmlane","76561197967188494",99,""]
	];

	//	BIS DYNAMIC GROUPS INIT (SERVER-SIDE)
	["Initialize"] call BIS_fnc_dynamicGroups;	
};

//	DYNAMIC GROUPS - CLIENT EXEC
if (hasInterface) then {["InitializePlayer", [player]] call BIS_fnc_dynamicGroups};

//	INITIALIZE DEPLOYMENT SYSTEM
call ASG_fnc_initDeployment;

//	INITIALIZE radio
call ASG_fnc_initRadio;
