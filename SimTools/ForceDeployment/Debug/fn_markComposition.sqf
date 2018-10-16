params [
	"_pos",
	["_name", "", [""]]
];

if (_name == "") then { _name = format ["marker_composition_%1", _pos]; };

_marker = createMarkerLocal [_name, _pos];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "n_unknown";
_marker setMarkerTextLocal _name;

_marker;
