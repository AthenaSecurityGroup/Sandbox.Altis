params [
	"_size",
	"_position",
	"_killzoneRadius"
];

private _composition =
	switch (_size) do {
		case "Battalion": {"FOB"};
		case "Company": {"COP"};
		case "Platoon": {"PB"};
		default {["%1 composition not implemented.", _size] call BIS_fnc_error};
	};

// TODO: Figure out if MVP compositions are doing this in their inits/triggers.
nearestTerrainObjects [_position, [], _killzoneRadius] apply {_x hideObjectGlobal true};

// LARs_fnc_spawnComp expects 3D ATL pos, everything else can handle 2D.
if (count _position < 3) then {
	["position size invalid: %1", _position] call BIS_fnc_error;
	_position pushBack 0
};

// TODO: figure out HC stuff here.
if (!isNil "HC") then {
	[_composition, _position] remoteExec ["LARs_fnc_spawnComp", HC];
} else {
	[_composition, _position] call LARs_fnc_spawnComp;
};
