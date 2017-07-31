ALOC_reqQueue params ["_pdrQueue", "_fdrQueue", "_vdrQueue"];

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

//	PROCESS THE QUEUE
waitUntil {
	//	SPAWN THE HELICOPTER.
	([_heloPos, _heloDir, _heloType, WEST] call BIS_fnc_spawnVehicle) params ["_heloVeh", "_heloCrew", "_heloGroup"];
	ALOC_logHelo = _heloVeh;

	//	SET ATTRIBUTES, CLEAR INVENTORY.
	ALOC_logHelo setVehicleLock "LOCKED";
	clearWeaponCargoGlobal ALOC_logHelo;
	clearMagazineCargoGlobal ALOC_logHelo;
	clearItemCargoGlobal ALOC_logHelo;
	clearBackpackCargoGlobal ALOC_logHelo;
	_heloGroup setBehaviour "CARELESS";
	ALOC_logHelo action ["CollisionLightOn", ALOC_logHelo];
	ALOC_logHelo action ["lightOn", ALOC_logHelo];
	
	//	MOVE TO LANDING ZONE
	_lzWP = _heloGroup addWaypoint [_heloLZ, 0];
	_lzWP setWaypointStatements ["true","
		ALOC_logHelo landAt ALOC_logHelipad;
		ALOC_logHelo land 'LAND'
	"];
	
	//	HELO IN FLIGHT. WAIT UNTIL LANDING.
	waitUntil {
		uiSleep 1;
		getPos ALOC_logHelo select 2 <= 0.5;
	};
	uiSleep 2;

	//	CREATE THE FREIGHT CONTAINER CRATE.
	_freightCrate = "B_CargoNet_01_ammo_F" createVehicle _heloPos;
	clearWeaponCargoGlobal _freightCrate;
	clearMagazineCargoGlobal _freightCrate;
	clearItemCargoGlobal _freightCrate;
	clearBackpackCargoGlobal _freightCrate;
	_freightCrate attachTo [ALOC_logHelo,[0,-2,-1.33]];
	_freightCrate setVectorDirAndUp [[0,1,0],[0,0.33,0.66]];

	//	PROCESS THE ORDER, DEPLOY THE FREIGHT.
	[_freightCrate, _fdrQueue] call ASG_fnc_ALOCFDRProc;

	//	GATHER REFERENCE POINTS FOR CREWCHIEF
	_ejectPos = ALOC_logHelo modelToWorld [2,5.7,-1.5];
	_intPos1 = ALOC_logHelo modelToWorld [3.6,0,-2];
	_intPos2 = ALOC_logHelo modelToWorld [3.6,-3.5,-2];
	_idlePos = ALOC_logHelo modeltoWorld [1.8,-6.8,-3.2];
	_crateDumpWatchPos = ALOC_logHelo modelToWorld [0,-6.2,-2.15];
	_idleWatchPos = ALOC_logHelo modeltoWorld [1.8,-10.8,-3.2];

	//	OPEN CHIEF DOOR, CONDUCT ANIMATIONS.
	ALOC_logHelo animateDoor ["Door_R_source", 1, false];
	uiSleep 4;
	_crewChiefAgnt = createAgent ["B_helicrew_F", _ejectPos, [], 0, "CAN_COLLIDE"];
	_crewChiefAgnt switchMove "AcrgPknlMstpSnonWnonDnon_AmovPercMstpSrasWrflDnon_getOutMedium";
	_crewChiefAgnt disableAI "FSM";
	_crewChiefAgnt setBehaviour "CARELESS";
	uiSleep 3;
	_crewChiefAgnt setDestination [_intPos1, "LEADER DIRECT", true]; 
	_crewChiefAgnt limitSpeed 0.5;
	uiSleep 3.6;
	_crewChiefAgnt setDestination [_intPos2, "LEADER DIRECT", true];
	uiSleep 2.6;
	_crewChiefAgnt setDestination [_idlePos, "LEADER DIRECT", true];
	uiSleep 4;
	_crewChiefAgnt playMove "Acts_listeningToRadio_In";
	uiSleep 2;
	_crewChiefAgnt playMove "Acts_listeningToRadio_Loop";
	uiSleep 4;
	_crewChiefAgnt playMove "Acts_listeningToRadio_Out";
	_crewChiefAgnt doWatch _crateDumpWatchPos;
	uiSleep 3;
	ALOC_logHelo animateDoor ["Door_rear_source", 1, false];
	uiSleep 1.5;
	_crewChiefAgnt playMove "Acts_SignalToCheck";
	_crewChiefAgnt doWatch _idleWatchPos;
	uiSleep 2;

	//	MOVE THE CONTAINER
	_freightCrate attachTo [ALOC_logHelo,[0,-6.2,-2.15]];
	_freightCrate setVectorDirAndUp [[0,0.66,0.10],[0,0.33,0.66]];

	//	ADD DEPARTURE ORDER
	[_crewChiefAgnt, {
		_crewChiefAgnt = _this;
		//	SET DEPARTURE ORDERS
		missionNamespace setVariable ["ALOC_depart", false, true];
		_crewChiefAgnt addAction ["Order to Depart", {
			missionNamespace setVariable ["ALOC_depart", true, true];
		}, nil, 0, false, true, "", "!ALOC_depart", 8, false];		
	}] remoteExec ["call", allPlayers select {_x getVariable "ASG_rank" == 99}];

	//	WAIT UNTIL HELICOPTER IS READY
	waitUntil {
		uiSleep 15;
		ALOC_depart;
	};

	//	ANIMATE THE CHIEF
	_crewChiefAgnt doWatch objNull;
	uiSleep 1;
	_crewChiefAgnt playMove "Acts_listeningToRadio_In";
	uiSleep 2;
	_crewChiefAgnt playMove "Acts_listeningToRadio_Loop";
	uiSleep 4;
	_crewChiefAgnt playMove "Acts_listeningToRadio_Out";
	uiSleep 2;
	ALOC_logHelo engineOn true;
	uiSleep 3;
	_freightCrate attachTo [ALOC_logHelo,[0,-2,-1.33]];
	_freightCrate setVectorDirAndUp [[0,1,0],[0,0.33,0.66]];
	uiSleep 3;
	_crewChiefAgnt setDestination [_intPos2, "LEADER DIRECT", true];
	uiSleep 2.6;
	_crewChiefAgnt setDestination [_intPos1, "LEADER DIRECT", true];
	uiSleep 2.6;
	_crewChiefAgnt setDestination [_ejectPos, "LEADER DIRECT", true];
	uiSleep 3.6;
	deleteVehicle _crewChiefAgnt;
	uiSleep 1;
	ALOC_logHelo animateDoor ["Door_R_source", 0, false];
	uiSleep 7;
	ALOC_logHelo animateDoor ["Door_rear_source", 0, false];
	uiSleep 15;

	//	DEPART FOR REMOVAL ZONE.
	_departWP = _heloGroup addWaypoint [_heloPos, 100];
	_departWP setWaypointCompletionRadius 500;
	_departWP setWaypointStatements ["true","
		{ALOC_logHelo deleteVehicleCrew _x} forEach crew ALOC_logHelo;
		deleteVehicle ALOC_logHelo;
		ALOC_logHelo = nil;
	"];

	(ALOC_reqQueue select 1) deleteAt 0;

	//	WAIT UNTIL THE HELICOPTER HAS BEEN REMOVED
	waitUntil {
		uiSleep 5;
		isNil "ALOC_logHelo"
	};	
};

deleteVehicle ALOC_logHelipad;
deleteVehicle _freightCrate;
ALOC_logHelipad = nil;
