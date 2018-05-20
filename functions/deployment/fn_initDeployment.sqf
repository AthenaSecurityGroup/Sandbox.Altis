/*
	ASG_fnc_initDeployment
	by:	Diffusion9
	
	Initializes the required elements for the Athena Security base deployment system. baseData contains names,
	whitelist arrays, and marker information for each base type if applicable. When run during init.sqf will
	initialize the server and client elements of the system. Both elements must be initialized properly for the
	system to function.

	Persistence data is saved into the end of the baseData arrays and stored for restarts.
	
*/

if hasInterface then {
	waitUntil {
		!isNil {player getVariable "ASG_rank"}
	};
};

//	BASE DATA ARRAY
baseData = [
	["Fighting Position",(player getVariable "ASG_rank"),"HFP_0"],
	["Recon Hide",[7, 99],"RH_0"],
	[
		"Patrol Base 1",								//	0	- Menu item name.
		[8,20, 99],										//	1	- Rank numbers with access.
		"PB_0",											//	2	- Composition name.
		["mil_flag", "ColorRed", "Patrol Base One"],	//	3	- Marker info.
		[],												//	4	- Persistence: Deployment Position
		[],												//	5	- Persistence: Cargo Data
		[]												//	6	- Persistence: Vehicle Data
	],
	["Patrol Base 2",[8,20,99],"PB_1",["mil_flag", "ColorGreen", "Patrol Base Two"]],
	["Patrol Base 3",[8,20,99],"PB_2",["mil_flag", "ColorBlue", "Patrol Base Three"]],
	["Fire Support Position",[8,99],"FSP_0",["mil_flag", "ColorUnknown", "Company FSP"]],
	["Field Command Post",[10,21,22,99],"FCP_0",["mil_flag", "ColorUnknown", "Field CP"]],
	["Tactical Operations Center",[12,25,99],"TOC_0",["mil_flag", "ColorUnknown", "Tactical Operations Center"]],
	["Combat Outpost",[10,21,22,99],"COP_0",["mil_flag", "ColorUnknown", "Company COP"]],
	["Forward Operating Base",[23,11,99],"FOB_0",["mil_flag", "ColorUnknown", "Battalion FOB"]],
	["Main Operating Base",[12,25,99],"MOB_0",["mil_flag", "ColorUnknown", "Regiment MOB"]]
];

//	EXECUTE ON SERVER ONLY
if isServer then {
	//	RUN DEPLOYMENT SERVER
	"bd_requestBase" addPublicVariableEventHandler {
		params ['_pVar','_data'];
		_data call ASG_fnc_deployBase;
	};
};

//	EXECUTE ON ALL PLAYER CLIENTS
if hasInterface then {
	//	INIT MENU ON PLAYER
	bd_subMenu = [["Deploy", false]];
	
	//	PARSE DEPLOYMENT DATA BASED ON PLAYER
	_eligible = [] call ASG_fnc_createBaseMenu;
	
	//	ACTIVE MENU FOR PLAYER
	if _eligible then {
		bd_id = [player, "bd_menu", nil, nil, ""] call BIS_fnc_addCommMenuItem;
	};
};
