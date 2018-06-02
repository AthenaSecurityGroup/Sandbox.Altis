
_x params ["_menuStr", "_rankAccess", "_compName", "_markerDetails", "_deployPos", "_cargoData", "_vehData"];
private _baseDataMaster = [];
{
    //	FOR EACH COMP OBJECT, CHECK IF IT IS A VALID CONTAINER:
    _objParents = [configFile >> "cfgVehicles" >> typeOf _x, true] call BIS_fnc_returnParents;
    if ("ReammoBox_F" in _objParents) then {
        //	IF IT IS A VALID CONTAINER, GET ITS CONTENTS, CREATE SUB-ARRAY
        //	DEFINE MASTER ARRAYS
        persist_masterMagArr = [[],[]];
        persist_masterItemArr = [[],[]];
        persist_masterWeaponsArr = [[],[]];
        persist_masterContainerArr = [[],[]];
        persist_containerMaster = [];
        //	GET ALL CONTAINER CONTENTS
        _x call ASG_fnc_processWeaponsItemsMags;
        _x call ASG_fnc_processSubContainers;
        //	FORM MASTER CONTAINER ARRAY
        persist_containerMaster = [persist_masterMagArr,persist_masterItemArr,persist_masterWeaponsArr,persist_masterContainerArr];
        //	ADD EACH CONTAINER ARRAY TO THE PRIMARY DATA ARRAY FOR THE COMPOSITION
        _baseDataMaster pushBack persist_containerMaster;
    };
} forEach ((missionNamespace getVariable _compName) call LAR_fnc_getCompObjects);
//	PUSH THE PRIMARY DATA ARRAY INTO BASEDATA
_baseDataIndex = [baseData, _compName] call BIS_fnc_findNestedElement select 0;
(baseData select _baseDataIndex) set [5, _baseDataMaster];