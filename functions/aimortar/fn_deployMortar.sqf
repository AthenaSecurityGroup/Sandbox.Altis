/*
	
	ASG_fnc_deployMortar
	
	Deploys a manned mortar position consisting of two mortars with 1 mortarman each.
	Attaches a trigger system to custom-control firing solutions based on detection.
	
	EXEC:	call.
	REQUIRED INPUTS:
	0 - ARRAY   Position to Spawn.
	1 - STRING  Faction. "Militia", "CSAT", "AAF"
	OPTIONAL INPUTS:
	2 - SCALAR  Attack threshold [5].
	3 - SCALAR  Engagement range [3000].
	4 - BOOL    Unlimited ammo [false].
	5 - SCALAR  Deployment direction [0].

*/


params [
  ['_mortarPOS', nil],
  ['_mortarFaction', nil],
  ['_mortarThreshold', 1],
  ['_mortarRange', 4000],
  ['_mortarUnlAmmo', false],
  ['_mortarDir', 0]
];

//	POSITION AND FACTION MUST BE DEFINED.
if ((isNil {_mortarPOS}) || (isNil {_mortarFaction})) exitWith {true};
//	GET MORTAR DATA; OBJ TYPE, SIDE, DETECTDATA, CREW TYPE.
_mortarData = [_mortarFaction] call ASG_fnc_defineMortarFaction;
_mortarData params ['_mortarType', '_mortarSide', '_detectSide', '_mortarCrewType', '_triggerActivate'];

//	GENERATE VARIABLE NAMES -- FOR USE LATER.
_mortarVarStr = format ["mortar_%1", round floor (_mortarPOS select 0)];
_mortarTrgStr = format ["%1_trigger", _mortarVarStr];
_mortarScrStr = format ["%1_script", _mortarVarStr];
_mortarPriStr = format ["%1_primary", _mortarVarStr];
_mortarSecStr = format ["%1_secondary", _mortarVarStr];
_mortarCrewStr = format ["%1_crew", _mortarVarStr];
_mortarDirStr = format ["%1_dir", _mortarVarStr];
_mortarAmmoStr = format ["%1_ammoState", _mortarVarStr];
missionNameSpace setVariable [_mortarAmmoStr, _mortarUnlAmmo];
missionNameSpace setVariable [_mortarDirStr, _mortarDir];

//	CREATE THE PRIMARY AND SECONDARY MORTARS.
missionNameSpace setVariable [_mortarPriStr, createVehicle [_mortarType, _mortarPOS, [], 0, "FORM"]];
missionNameSpace setVariable [_mortarSecStr, createVehicle [_mortarType, _mortarPOS, [], 0, "FORM"]];
(missionNameSpace getVariable _mortarPriStr) setVehicleVarName _mortarVarStr;

//	SPAWN THE MORTAR CREW, SET GROUPID.
missionNameSpace setVariable [_mortarCrewStr,[
	_mortarPOS,
	_mortarSide,
	[_mortarCrewType,_mortarCrewType],
	[],
	[],
	[],
	[],
	[],
	_mortarDir
] call BIS_fnc_spawnGroup];
(missionNameSpace getVariable _mortarCrewStr) setGroupId [_mortarVarStr];

//	CREW TWO MORTARS.
{
	if (_forEachIndex == 0) then {
		_x assignAsGunner (missionNameSpace getVariable _mortarPriStr);
		_x moveInGunner (missionNameSpace getVariable _mortarPriStr);
		_x disableAI "TARGET";
		_x disableAI "AUTOTARGET";
	} else {
		_x assignAsGunner (missionNameSpace getVariable _mortarSecStr);
		_x moveInGunner (missionNameSpace getVariable _mortarSecStr);
		_x disableAI "TARGET";
		_x disableAI "AUTOTARGET";
	};
} forEach units (missionNameSpace getVariable _mortarCrewStr);

//	CREATE TRACKING TRIGGERS, AND ATTACHTO MORTAR OBJ.
missionNamespace setVariable [
	_mortarTrgStr,
	createTrigger [
		"EmptyDetector",
		getPOS (missionNameSpace getVariable _mortarPriStr)
	]
];
(missionNameSpace getVariable _mortarTrgStr) attachTo [(missionNameSpace getVariable _mortarPriStr)];
(missionNameSpace getVariable _mortarTrgStr) setTriggerArea [_mortarRange, _mortarRange, 0, false];
(missionNameSpace getVariable _mortarTrgStr) setTriggerActivation [_triggerActivate, _detectSide, true];
(missionNameSpace getVariable _mortarTrgStr) setTriggerStatements [
	"
		this
	",
	"
		_mortarVarStr = (vehicleVarName (attachedTo thisTrigger));
		diag_log format ['[deployMortar]:	%1 has been triggered.', _mortarVarStr];
		missionNameSpace setVariable [format ['%1_script', _mortarVarStr], [_mortarVarStr, thisList, (missionNamespace getVariable (format ['%1_ammoState', _mortarVarStr]))] spawn ASG_fnc_initMortarLogic];
	",
	"
		_mortarVarStr = (vehicleVarName (attachedTo thisTrigger));
		diag_log format ['[deployMortar]:	%1 has deactivated.', _mortarVarStr];
		_mortarScrStr = format ['%1_script', _mortarVarStr];
		terminate (missionNameSpace getVariable _mortarScrStr);
		missionNameSpace setVariable [_mortarScrStr, nil];
	"
];
