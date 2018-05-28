//	GET ACTIVE BASES
//	Should only run on the server.

{
	_x params ["_menuStr", "_rankAccess", "_compName", "_markerDetails", "_deployPos", "_cargoData", "_vehData"];
	//	SKIP ENTRIES WITH NO MARKER DETAILS (SMALLER BASES, NO CARGO)
	if !(isNil {_markerDetails}) then {
		//	CONSTRUCT THE MARKER NAME
		_markerName = format ["%1_M", _compName];
		if !((getMarkerPos _markerName) isEqualTo [0,0,0]) then {
			//	MARKER IS ACTIVE, START GATHERING PERSISTENCE
			//	GET POSITION
			_baseDeployPos = getMarkerPos _markerName;
			_x set [4, _baseDeployPos];
			//	GET CARGO
			_x call ASG_fnc_saveBaseCargo;
			//	GET VEHICLES
			_baseDeployPos call ASG_fnc_saveBaseVehicles;
		};
	};
} forEach baseData;
//	SAVE TO SERVER PROFILE NAMESPACE
profileNamespace setVariable ["baseData", baseData];
saveProfileNamespace;
