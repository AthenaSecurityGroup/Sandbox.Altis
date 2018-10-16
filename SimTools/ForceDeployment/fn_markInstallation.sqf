params [
	"_pos",
	["_name", "", [""]]
];

if (_name == "") then { _name = format ["marker_installation_%1", _pos]; };

_marker = createMarker [_name, _pos];
_marker setMarkerShape "ICON";
_marker setMarkerType "n_installation";
_marker setMarkerText _name;

_marker;
