//	LOAD ALL NEARBY VEHICLES WITH CORRECT CARGO, AND SET VEHICLE ATTRIBUTES
{
    _x params ["_vehType","_vehAttributes", "_vehTextures", "_vehCrew", "_vehDetails"];
    _vehDetails params ["_vehPos", "_vehDir", "_vehCargo"];
    _veh = createVehicle [_vehType, _vehPos,[],0,"NONE"];
    _veh setDir _vehDir;
    [_veh, [missionNamespace, "_vehAttributes"]] call BIS_fnc_loadVehicle;
    {_veh setObjectTextureGlobal [_forEachIndex, _x]} forEach _vehTextures;
    //	CLEAR FOR CARGO INSERTION
    clearWeaponCargoGlobal _veh;
    clearMagazineCargoGlobal _veh;
    clearItemCargoGlobal _veh;
    clearBackpackCargoGlobal _veh;
    {[_veh, _x] call ASG_fnc_loadCargo} forEach _vehCargo;
} forEach _vehData;
