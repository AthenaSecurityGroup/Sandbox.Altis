//	LOAD ALL BASE-RELATED DATA FROM BASEDATA
{
    _x params ["_menuStr", "_rankAccess", "_compName", "_markerDetails", "_deployPos", "_cargoData", "_vehData"];
    //	IF DEPLOYPOS HAS DATA, THE BASE WAS ACTIVE, AND NEEDS TO BE RELOADED.
    if !(isNil {_deployPos} || {_deployPos isEqualTo []}) then {
        //	RE-DEPLOY THE BASE AT THE POSITION FROM MEMORY.
        //	LOAD CARGO INTO CARGO CONTAINERS.
        private _containerCounter = 0;
        {
            _objParents = [configFile >> "cfgVehicles" >> typeOf _x, true] call BIS_fnc_returnParents;
            if ("ReammoBox_F" in _objParents) then {
                _currentContainer = _x;
                //	CLEAR FOR INSERTION.
                clearWeaponCargoGlobal _x;
                clearMagazineCargoGlobal _x;
                clearItemCargoGlobal _x;
                clearBackpackCargoGlobal _x;
                //	ADD TO CONTAINER FROM CARGO DATA ARRAY
                {
                    [_currentContainer, _x] call ASG_fnc_loadCargo;
                } forEach (_cargoData select _containerCounter);
                //	+1 FOR CARGO DATA INDEXING
                _containerCounter = _containerCounter + 1;
            };
        } forEach ((missionNamespace getVariable _compName) call LAR_fnc_getCompObjects);
        //	RELOAD VEHICLES IN THE VICINITY.
        _x call ASG_fnc_loadBaseVehicles;
    };
} forEach (profileNamespace getVariable "baseData");
