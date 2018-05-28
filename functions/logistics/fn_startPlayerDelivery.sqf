logistics_reqQueue params ["_pdrQueue", "_fdrQueue", "_vdrQueue"];

//	CHECK IF TIED TO EXISTING LOCATION
{
	if ([_x, getPlayerUID (missionNamespace getVariable _x), true] call ASG_fnc_savePlayerLoc) then {
		[false, "", 4.5] remoteExec ["ASG_fnc_setPlayerState", (missionNamespace getVariable _x)];
		(logistics_reqQueue select 0) deleteAt ([logistics_reqQueue, _x] call BIS_fnc_findNestedElement select 1);
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
if (_heloLZ isEqualTo [0,0,0]) then {_heloLZ = campaignStartPos};

logistics_logHelipad = "Land_HelipadEmpty_F" createVehicle _heloLZ;
logistics_logHelipad setDir (getDir (_heloLZ nearestObject "Land_HelipadSquare_F"));
logistics_logHelipad allowDamage false;

//	CALC SPAWN DIRECTION, POSITION, HELO TYPE, AND TRANSPORT CAPACITY.
_heloSpawnDir = [(worldSize / 2),(worldSize / 2)] getDir campaignStartPos;
_heloPos = campaignStartPos getPos [2100, _heloSpawnDir];
_heloType = "B_Heli_Transport_03_black_F";
_heloDir = _heloPos getDir _heloLZ;
_cargoAvail = getNumber (configfile >> "CfgVehicles" >> _heloType >> "transportSoldier");

//	PROCESS QUEUE UNTIL EMPTY, EXECUTE DELIVERY.
waitUntil {
	//	SPAWN THE HELICOPTER.
	([_heloPos, _heloDir, _heloType, WEST] call BIS_fnc_spawnVehicle) params ["_heloVeh", "_heloCrew", "_heloGroup"];
	logistics_logHelo = _heloVeh;
	
	//	SET ATTRIBUTES, CLEAR INVENTORY.
	logistics_logHelo setVehicleLock "LOCKED";
	(driver logistics_logHelo) setBehaviour "CARELESS";
	logistics_logHelo action ["CollisionLightOn", logistics_logHelo];
	logistics_logHelo action ["lightOn", logistics_logHelo];
	clearWeaponCargoGlobal logistics_logHelo;
	clearMagazineCargoGlobal logistics_logHelo;
	clearItemCargoGlobal logistics_logHelo;
	clearBackpackCargoGlobal logistics_logHelo;
	
	//	PROCESS CHALK.
	_heloQueue = _pdrQueue select [0, _cargoAvail];
	_pdrQueue deleteRange [0, (count _heloQueue)];
	
	//	LOAD CHALK INTO HELICOPTER.
	{
		_unit = missionNamespace getVariable _x;
		[_unit, logistics_logHelo] remoteExec ["assignAsCargo", _unit];
		[_unit, logistics_logHelo] remoteExec ["moveInCargo", 0];
		[false, "", 4.5] remoteExec ["ASG_fnc_setPlayerState", _unit];
	} forEach _heloQueue;
	
	//	MOVE TO LANDING ZONE
	_lzWP = _heloGroup addWaypoint [_heloLZ, 0.5];
	_lzWP setWaypointStatements ["true","
		logistics_logHelo landAt logistics_logHelipad;
		logistics_logHelo land 'GET OUT';
		logistics_logHelo animateDoor ['Door_rear_source', 1];
	"];
	
	//	HELO IN FLIGHT. WAIT UNTIL LANDING.
	waitUntil {
		uiSleep 5;
		getPos logistics_logHelo select 2 <= 0.5;
	};
	
	//	UNLOAD CHALK.
	{
		_unit = missionNamespace getVariable _x;
		waitUntil {getPos logistics_logHelo select 2 <= 0.5};
		unassignVehicle _unit;
		_unit action ["Eject", vehicle _unit];
	} forEach _heloQueue;

	//	WAIT UNTIL HELICOPTER IS EMPTY.
	waitUntil {
		uiSleep 5;
		{missionNamespace getVariable _x in logistics_logHelo} count _heloQueue == 0;
	};
	
	//	ANIMATE HELICOPTER DOORS.
	logistics_logHelo animateDoor ['Door_rear_source', 0];

	uiSleep 5;

	//	DEPART FOR REMOVAL ZONE.
	_departWP = _heloGroup addWaypoint [_heloPos, 100];
	_departWP setWaypointCompletionRadius 500;
	_departWP setWaypointStatements ["true","
		{logistics_logHelo deleteVehicleCrew _x} forEach crew logistics_logHelo;
		deleteVehicle logistics_logHelo;
		logistics_logHelo = nil;
	"];
	
	//	WAIT UNTIL THE HELICOPTER HAS BEEN REMOVED
	waitUntil {
		uiSleep 5;
		isNil "logistics_logHelo"
	};
	
	//	CHECK QUEUE AND REPEAT IF NECESSARY.
	(count _pdrQueue) == 0;
};

deleteVehicle logistics_logHelipad;
logistics_logHelipad = nil;
