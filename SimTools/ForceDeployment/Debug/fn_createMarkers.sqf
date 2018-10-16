params [
	["_orbat", []]
];

if (!isnil "SIMTOOLS_FORCEDEPLOYMENT_DEBUG_MARKERS" && {count SIMTOOLS_FORCEDEPLOYMENT_DEBUG_MARKERS > 0}) exitWith {
	["Debug markers already defined: %1", SIMTOOLS_FORCEDEPLOYMENT_DEBUG_MARKERS] call BIS_fnc_Error;
};

SIMTOOLS_FORCEDEPLOYMENT_DEBUG_MARKERS = [];

[_orbat, {
	params [
		"_echelon",
		"_pos",
		"_children"
	];

	private _name = format ["%1-%2-%3", player, _echelon, _pos];
	SIMTOOLS_FORCEDEPLOYMENT_DEBUG_MARKERS pushBack (
		[_pos, _name] call SimTools_ForceDeployment_fnc_markComposition);
	SIMTOOLS_FORCEDEPLOYMENT_DEBUG_MARKERS append (
		[_pos, _echelon, _name] call SimTools_ForceDeployment_fnc_markRadii);

	_children
}] call SimTools_ForceDeployment_fnc_breadthFirstTraversal;

SIMTOOLS_FORCEDEPLOYMENT_DEBUG_MARKERS
