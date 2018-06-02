
//	INCOMING / DEFINED VARIABLES
params ["_bPos"];
_bSortedArr = [];
_bMarkerArr = [];

//	SORT THROUGH NEARBY MAPMARKERS
{
	if (_x find "_USER_DEFINED" == -1 && (getMarkerPos _x) distance _bPos < 300) then {
		_bMarkerArr pushback (_x splitString "_M" joinString "_");
	};
} forEach allMapMarkers;
if (_bMarkerArr isEqualTo []) exitWith {
	true
};

//	TURN BASE MARKER REFERENCES INTO NUMERICS
if !(_bSortedArr isEqualTo []) then {
	{_bSortedArr pushback ([baseData, _x] call BIS_fnc_findNestedElement select 0)} forEach _bMarkerArr;

	//	SORT THE ARRAY, SET PRIORITY BASE ALPHA 1
	_bSortedArr sort false;
	_bPriority = _bSortedArr deleteAt 0;
	([baseData select _bPriority select 2, "M"] joinString "_") setMarkerAlpha 1;

	//	SET OTHER BASES TO 0
	{
		([baseData select _x select 2, "M"] joinString "_") setMarkerAlpha 0;
	} forEach _bSortedArr;
};
