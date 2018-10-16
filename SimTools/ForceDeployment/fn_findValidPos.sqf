params [
	"_composition",
	["_parent", []],
	["_blacklist", []]
];
private [
	"_parent_max_radius",
	"_parent_min_radius",
	"_sibling_buffer_radius",
	"_object_dist"
];

try {
	switch (toUpper _composition) do {
		case "FOB": {
			// Place a FOB randomly
			// Add 8km buffer around FOB for siblings
			_parent_min_radius = 0;
			_parent_max_radius = -1;
			_sibling_buffer_radius = 8000;
			_object_dist = 10;
		};
		case "COP": {
			// Place a COP between 1-3km from FOB
			// Add 2km buffer around COP for siblings
			_parent_min_radius = 1000;
			_parent_max_radius = 3000;
			_sibling_buffer_radius = 2000;
			_object_dist = 10;
		};
		case "PB": {
			// Place a PB between 500-2km from COP
			// Add 600m buffer around PB for siblings
			_parent_min_radius = 500;
			_parent_max_radius = 2000;
			_sibling_buffer_radius = 600;
			_object_dist = 10;
		};
		default { throw format ["Unknown type (%1)", _composition]; };
	};

	_blacklist pushBackUnique "water";

	[_parent, _parent_min_radius, _parent_max_radius, _object_dist, 0, 0.1, 0, _blacklist, [[0,0], [0,0]]] call SimTools_ForceDeployment_fnc_findSafePos;
} catch {
	_exception call BIS_fnc_error;
};
