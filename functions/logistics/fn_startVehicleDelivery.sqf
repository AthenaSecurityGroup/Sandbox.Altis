logistics_reqQueue params ["_pdrQueue", "_fdrQueue", "_vdrQueue"];

//	FIND ACTIVE BASE, SET LZ.
private ["_heloLZ"];
if (isNil "TOC_0") then {
	_heloLZ = getMarkerPos "MOB_0_M";
} else {
	_heloLZ = getMarkerPos "TOC_0_M";
};
_heloLZ = getPos (_heloLZ nearestObject "Land_HelipadSquare_F");

//	Clogistics SPAWN DIRECTION, POSITION, HELO TYPE.
_heloSpawnDir = [(worldSize / 2),(worldSize / 2)] getDir campaignStartPos;
_heloPos = campaignStartPos getPos [2100, _heloSpawnDir];
_heloType = "B_T_VTOL_01_vehicle_F";
_heloDir = _heloPos getDir _heloLZ;

//	PROCESS THE VEHICLE ORDER.
waitUntil {
	
};
