params [
	"_pos",
	["_echelon", "", [""]],
	["_name", "", [""]]
];

private [
	"_sibling_buffer_colour",
	"_sibling_buffer_radius",
	"_child_area_colour",
	"_child_area_max_radius",
	"_child_area_min_radius"
];

if (_name == "") then { _name = str _pos; };

try {
	switch (toUpper _echelon) do {
		case "II": {
			_sibling_buffer_colour = "Default";
			_sibling_buffer_radius = 8000;
			_child_area_colour = "ColorRed";
			_child_area_max_radius = 3000;
			_child_area_min_radius = 1000;
		};
		case "I": {
			_sibling_buffer_colour = "ColorRed";
			_sibling_buffer_radius = 2000;
			_child_area_colour = "ColorBlue";
			_child_area_max_radius = 2000;
			_child_area_min_radius = 500;
		};
		case "•••": {
			_sibling_buffer_colour = "ColorBlue";
			_sibling_buffer_radius = 600;
			_child_area_colour = "ColorBlack";
			_child_area_max_radius = 600;
			_child_area_min_radius = 25;
		};
		default {
			throw format ["Unknown echelon (%1)", _echelon];
		};
	};

	_marker_name = "marker_" + toLower _name;

	_sibling_buffer = createMarker [_marker_name + "_sibling_buffer", _pos];
	_sibling_buffer setMarkerColor _sibling_buffer_colour;
	_sibling_buffer setMarkerShape "ELLIPSE";
	_sibling_buffer setMarkerBrush "Solid";
	_sibling_buffer setMarkerAlpha 0.2;
	_sibling_buffer setMarkerSize [_sibling_buffer_radius, _sibling_buffer_radius];

	_child_area_max = createMarker [_marker_name + "_child_area_max", _pos];
	_child_area_max setMarkerShape "ELLIPSE";
	_child_area_max setMarkerBrush "Border";
	_child_area_max setMarkerColor _child_area_colour;
	_child_area_max setMarkerSize [_child_area_max_radius, _child_area_max_radius];

	_child_area_min = createMarker [_marker_name + "_child_area_min", _pos];
	_child_area_min setMarkerShape "ELLIPSE";
	_child_area_min setMarkerBrush "Border";
	_child_area_min setMarkerColor _child_area_colour;
	_child_area_min setMarkerSize [_child_area_min_radius, _child_area_min_radius];
} catch {
	[_exception] call BIS_fnc_error;
};
