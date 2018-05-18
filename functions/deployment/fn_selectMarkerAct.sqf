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

params ["_bIndex", "_rType", "_bPos"];

(baseData select _bIndex select 2) params ["_bComp"];
(baseData select _bIndex select 3) params ["_mType", "_mColour", "_mText"];
_bMarker = format ["%1_M", _bComp];

switch (toUpper _rType) do {
    case "CREATE": {
		_markerstr = createMarker [_bMarker, _bPos];
		_markerstr setMarkerType _mType;
		_markerstr setMarkerColor _mColour;
		_markerstr setMarkerText _mText;
		_markerstr setMarkerAlpha 1;
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
