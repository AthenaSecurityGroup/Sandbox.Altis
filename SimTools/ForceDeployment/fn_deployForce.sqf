params [
	["_orbat", []]
];

if (count _orbat < 1) exitWith { "Orbat is empty" call BIS_fnc_error; };

breadthFirstTraversal = {
	params [
		["_tree", []],
		["_nodeCode", {}]
	];

	private _q = [_tree];

	while {count _q > 0} do {
		private _current = _q deleteAt 0;

		{
			private _enqueue = _x call _nodeCode;

			if (count _enqueue > 0) then {
				_q pushBack _enqueue;
			};
		} forEach _current;
	};
};

// [[echelon, pos, parentArrayRef], ...]
private _queue = [];

[_orbat, {
	params [
		"_echelon",
		"_pos",
		["_children", []],
		["_parent", []]
	];

	private _element = [_echelon, _pos, _parent];
	_queue pushBack _element;

	{
		// Set index 3 explicitly for leaf (childless) nodes
		_x set [3, _element];
	} forEach _children;

	_children;
}] call breadthFirstTraversal;

prepareAndPlace = {
	params [
		"_echelon",
		"_composition",
		"_pos",
		"_name",
		"_killzoneRadius"
	];

	// Debug aids
	[_pos, _name] call SimTools_ForceDeployment_fnc_markInstallation;
	[_pos, _echelon, _name] call SimTools_ForceDeployment_fnc_markRadii;

	// TODO: Figure out if MVP compositions are doing this in their inits/triggers
	{ _x hideObjectGlobal true } foreach nearestTerrainObjects [_pos, [], _killzoneRadius];

	// LARs_fnc_spawnComp expects 3D ATL pos, everything else can handle 2D.
	if (count _pos == 2) then { _pos pushBack 0; };

	[_composition, _pos] call LARs_fnc_spawnComp;
};

switchOnEchelon = {
	params [
		"_echelon",
		"_BNCode",
		"_COYCode",
		"_PLCode",
		[
			"_defaultCode",
			{ format ["Unknown echelon '(%1)'", _echelon] call BIS_fnc_error; },
			{}
		]
	];
	
	switch (toUpper _echelon) do {
		case "II": _BNCode;
		case "I": _COYCode;
		case "•••": _PLCode;
		default _defaultCode;
	};
};

private _fobs = [];
private _cops = [];
private _pbs = [];
private _pbBacklist = [];
{
	private _next = [
		_x select 0,
		_x select 1,
		_x select 2
	];
	if (_x select 0 == "•••") then {
		_next pushBack _pbBacklist;
		diag_log format ["••• _x %1 %2", _forEachIndex, _x];
	};
	_next call {
		params [
			"_echelon",
			["_pos", [], [[0]], [0,2,3]],
			["_parent", [], [[]], [0,3]],
			["_blacklist", [], [[]]]
		];

		private [
			"_composition",
			"_killzoneRadius",
			"_blacklistRadius",
			"_siblings"
		];
		[
			_echelon,
			{
				_composition = "FOB";
				_killzoneRadius = 50;
				_blacklistRadius = 8000;
				_siblings = _fobs;
			},
			{
				_composition = "COP";
				_killzoneRadius = 40;
				_blacklistRadius = 2000;
				_siblings = _cops;
			},
			{
				_composition = "PB";
				_killzoneRadius = 15;
				_blacklistRadius = 600;
				_siblings = _pbs;
			}
		] call switchOnEchelon;

		if (count _pos < 2) then {
			private _parentPos = [];
			if (count _parent > 2) then {_parentPos = _parent select 1};

			{
				_blacklist pushBack [_x, _blacklistRadius];
			} forEach _siblings;

			private _newPos = [_composition, _parentPos, _blacklist] call SimTools_ForceDeployment_fnc_findValidPos;
			_pos set [0, _newPos select 0];
			_pos set [1, _newPos select 1];
			if (count _newPos < 3) then { _pos pushBack 0; };

			if (toUpper _echelon == "I") then {
				private _vector = (_pos vectorFromTo _parentPos);
				_vector = _vector vectorMultiply 1000;
				private _dir = (_vector select 0) atan2 (_vector select 1);
				if (_dir < 0) then {_dir = 360 + _dir};
				private _blacklistCenter = _pos vectorAdd _vector;

				// DEBUG
				diag_log format ["_blacklistCenter: %1", _blacklistCenter];
				diag_log format ["dir: %1", _dir];
				private _marker = createMarker ["MarkerPBRear_" + str _blacklistCenter, _blacklistCenter];
				_marker setMarkerShape "RECTANGLE";
				_marker setMarkerSize [2000, 1000];
				_marker setMarkerDir _dir;

				_pbBacklist pushBack ([_blacklistCenter, [2000, 1000, _dir, true]]);
				//_pbBacklist pushBack _marker;
			};
		};

		[
			_echelon,
			{ _fobs },
			{ _cops },
			{ _pbs }
		] call switchOnEchelon pushBack _pos;

		// TODO: Add naming scheme
		private _name = str _forEachIndex;
		[_echelon, _composition, _pos, _name, _killzoneRadius] call prepareAndPlace;
		_x set [1, _pos];

		_pos
	};
} forEach _queue;

_orbat
