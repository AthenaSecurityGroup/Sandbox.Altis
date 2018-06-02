/*

	ASG_fnc_selectMarkerAct
	by:	Diffusion9
	
	Hide all base-type markers from nearby bases that are around the deployed base.
	Only hide if the deployed base is of higher base tier score.
	
	0	SCALAR	Base index from baseData
	1	STRING	Request type: CREATE, DELETE, UPDATE
	2	ARRAY	
	
	[_base, "HIDE"]

*/

params [["_bIndex",-1], ["_rType",""], ["_bPos",[]],["_bDir",-1]];

private ["_bComp","_bMarker","_mType", "_mColour", "_mText"];
if !(_bIndex isEqualTo -1) then {
	_bComp = (baseData select _bIndex select 2);
	_bMarker = format ["%1_M", _bComp];
	_markerData = (baseData select _bIndex select 3);
	_mType = _markerData select 0;
	_mColour = _markerData select 1;
	_mText = _markerData select 2;
};

switch (toUpper _rType) do {
    case "CREATE": {
		_markerstr = createMarker [_bMarker, _bPos];
		_markerstr setMarkerType _mType;
		_markerstr setMarkerColor _mColour;
		_markerstr setMarkerText _mText;
		_markerstr setMarkerAlpha 1;
		[_markerstr, _bDir] remoteExec ["setMarkerDirLocal", 2]; // _markerstr setMarkerDirLocal _bDir;
	};
    case "DELETE": {
		deleteMarker _bMarker;
	};
    case "UPDATE": {
		//	UPDATE MARKERS
		[_bPos] call ASG_fnc_updateMarker;
	};
    default {
		diag_log format ["[selectMarkerAct]:	DEFAULT SWITCH"];
	};
};

