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

	private _marker_name = "marker_" + toLower _name;

	private _sibling_buffer = createMarkerLocal [_marker_name + "_sibling_buffer", _pos];
	_sibling_buffer setMarkerColorLocal _sibling_buffer_colour;
	_sibling_buffer setMarkerShapeLocal "ELLIPSE";
	_sibling_buffer setMarkerBrushLocal "Solid";
	_sibling_buffer setMarkerAlphaLocal 0.2;
	_sibling_buffer setMarkerSizeLocal [_sibling_buffer_radius, _sibling_buffer_radius];

	private _child_area_max = createMarkerLocal [_marker_name + "_child_area_max", _pos];
	_child_area_max setMarkerShapeLocal "ELLIPSE";
	_child_area_max setMarkerBrushLocal "Border";
	_child_area_max setMarkerColorLocal _child_area_colour;
	_child_area_max setMarkerSizeLocal [_child_area_max_radius, _child_area_max_radius];

	private _child_area_min = createMarkerLocal [_marker_name + "_child_area_min", _pos];
	_child_area_min setMarkerShapeLocal "ELLIPSE";
	_child_area_min setMarkerBrushLocal "Border";
	_child_area_min setMarkerColorLocal _child_area_colour;
	_child_area_min setMarkerSizeLocal [_child_area_min_radius, _child_area_min_radius];

	[_sibling_buffer, _child_area_max, _child_area_min]
} catch {
	[_exception] call BIS_fnc_error;
};
