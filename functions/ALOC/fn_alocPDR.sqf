ALOC_reqQueue params ["_pdrQueue", "_fdrQueue", "_vdrQueue"];

//	CHECK IF TIED TO EXISTING LOCATION
{
	if ([_x, getPlayerUID (missionNamespace getVariable _x), true] call ASG_fnc_procASGloc) then {
		[false, "", 4.5] remoteExec ["ASG_fnc_setPlayerState", (missionNamespace getVariable _x)];
		(ALOC_reqQueue select 0) deleteAt ([ALOC_reqQueue, _x] call BIS_fnc_findNestedElement select 1);
	};
} forEach _pdrQueue;
if (count _pdrQueue == 0) exitWith {true};

//	FIND ACTIVE BASE, SET LZ.
private ["_heloLZ"];
if (isNil "TOC_0") then {
	_heloLZ = getMarkerPos "MOB_0_M";
} else {
	_heloLZ = getMarkerPos "TOC_0_M";
};
_heloLZ = getPos (_heloLZ nearestObject "Land_HelipadSquare_F");
ALOC_logHelipad = "Land_HelipadEmpty_F" createVehicle _heloLZ;
ALOC_logHelipad setDir (getDir (_heloLZ nearestObject "Land_HelipadSquare_F"));

if (_heloLZ isEqualTo [0,0,0]) then {
	_heloLZ = ACDEP_Pos;
};

//	CALC SPAWN DIRECTION, POSITION, HELO TYPE, AND TRANSPORT CAPACITY.
_heloSpawnDir = [(worldSize / 2),(worldSize / 2)] getDir ACDEP_Pos;
_heloPos = ACDEP_Pos getPos [2100, _heloSpawnDir];
_heloType = "B_Heli_Transport_03_black_F";
_heloDir = _heloPos getDir _heloLZ;
_cargoAvail = getNumber (configfile >> "CfgVehicles" >> _heloType >> "transportSoldier");

//	PROCESS QUEUE UNTIL EMPTY, EXECUTE DELIVERY.
waitUntil {
	//	SPAWN THE HELICOPTER.
	([_heloPos, _heloDir, _heloType, WEST] call BIS_fnc_spawnVehicle) params ["_heloVeh", "_heloCrew", "_heloGroup"];
	ALOC_logHelo = _heloVeh;
	
	//	SET ATTRIBUTES, CLEAR INVENTORY.
	ALOC_logHelo setVehicleLock "LOCKED";
	(driver ALOC_logHelo) setBehaviour "CARELESS";
	ALOC_logHelo action ["CollisionLightOn", ALOC_logHelo];
	ALOC_logHelo action ["lightOn", ALOC_logHelo];
	clearWeaponCargoGlobal ALOC_logHelo;
	clearMagazineCargoGlobal ALOC_logHelo;
	clearItemCargoGlobal ALOC_logHelo;
	clearBackpackCargoGlobal ALOC_logHelo;
	
	//	PROCESS CHALK.
	_heloQueue = _pdrQueue select [0, _cargoAvail];
	_pdrQueue deleteRange [0, (count _heloQueue)];
	
	//	LOAD CHALK INTO HELICOPTER.
	{
		_unit = missionNamespace getVariable _x;
		[_unit, ALOC_logHelo] remoteExec ["assignAsCargo", _unit];
		[_unit, ALOC_logHelo] remoteExec ["moveInCargo", 0];
		[false, "", 4.5] remoteExec ["ASG_fnc_setPlayerState", _unit];
	} forEach _heloQueue;
	
	//	MOVE TO LANDING ZONE
	_lzWP = _heloGroup addWaypoint [_heloLZ, 0.5];
	_lzWP setWaypointStatements ["true","
		ALOC_logHelo landAt ALOC_logHelipad;
		ALOC_logHelo land 'GET OUT';
		ALOC_logHelo animateDoor ['Door_rear_source', 1];
	"];
	
	//	HELO IN FLIGHT. WAIT UNTIL LANDING.
	waitUntil {
		uiSleep 5;
		getPos ALOC_logHelo select 2 <= 0.5;
	};
	
	//	UNLOAD CHALK.
	{
		_unit = missionNamespace getVariable _x;
		waitUntil {getPos ALOC_logHelo select 2 <= 0.5};
		unassignVehicle _unit;
		_unit action ["Eject", vehicle _unit];
	} forEach _heloQueue;

	//	WAIT UNTIL HELICOPTER IS EMPTY.
	waitUntil {
		uiSleep 5;
		{missionNamespace getVariable _x in ALOC_logHelo} count _heloQueue == 0;
	};
	
	//	ANIMATE HELICOPTER DOORS.
	ALOC_logHelo animateDoor ['Door_rear_source', 0];

	uiSleep 5;

	//	DEPART FOR REMOVAL ZONE.
	_departWP = _heloGroup addWaypoint [_heloPos, 100];
	_departWP setWaypointCompletionRadius 500;
	_departWP setWaypointStatements ["true","
		{ALOC_logHelo deleteVehicleCrew _x} forEach crew ALOC_logHelo;
		deleteVehicle ALOC_logHelo;
		ALOC_logHelo = nil;
	"];
	
	//	WAIT UNTIL THE HELICOPTER HAS BEEN REMOVED
	waitUntil {
		uiSleep 5;
		isNil "ALOC_logHelo"
	};
	
	//	CHECK QUEUE AND REPEAT IF NECESSARY.
	(count _pdrQueue) == 0;
};

deleteVehicle ALOC_logHelipad;
ALOC_logHelipad = nil;
