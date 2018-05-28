//	SAVE ALL VEHICLES, THEIR ATTRIBUTES, AND CARGO, WITHIN 200 M

//	GET ALL NEARBY VEHICLES, MINUS THE LOGISTICS HELO (IF ITS PARKED).
private _baseVehicles = (_baseDeployPos nearEntities [["LandVehicle", "Helicopter"], 200]);
//	IF THE LOGISTICS HELO IS ACTIVE, REMOVE IT FROM THE BASE VEHICLES ARRAY
if (!isNil {logistics_logHelo}) then {_baseVehicles deleteAt ([_baseVehicles, logistics_logHelo] call BIS_fnc_findNestedElement select 0)};
//	SAVE VEHICLE ATTRIBUTES
private _vehicleMasterArray = [];
{
    //	SAVE VEHICLE TEXTURES, AND PRIMARY ATTRIBUTES
    private _vehTextures = getObjectTextures _x;
    _vehAttributes = [_x, [missionNamespace, ""],[getPos _x, getDir _x]] call BIS_fnc_saveVehicle;
    //	REBRAND TO ASG, IF OFFROAD
    if (["Offroad",(typeOf _x), false] call BIS_fnc_inString) then {
        _vehTextures = ["a3\soft_f\offroad_01\data\offroad_01_ext_base01_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_10_co.paa"];
    };
    _vehAttributes set [2, _vehTextures];
    //	SAVE VEHICLE CARGO, RESET THE MASTER PERSISTENCE ARRAYS
    persist_masterMagArr = [[],[]];
    persist_masterItemArr = [[],[]];
    persist_masterWeaponsArr = [[],[]];
    persist_masterContainerArr = [[],[]];
    persist_containerMaster = [];
    //	GET ALL CONTENTS OF THIS BASE VEHICLE
    _x call ASG_fnc_processWeaponsItemsMags;
    _x call ASG_fnc_processSubContainers;
    //	FORM CONTAINER MASTER ARRAY
    persist_containerMaster = [persist_masterMagArr,persist_masterItemArr,persist_masterWeaponsArr,persist_masterContainerArr];
    //	ADD EACH CONTAINER ARRAY TO THE PRIMARY DATA ARRAY FOR THE COMPOSITION
    (_vehAttributes select 4) set [2, persist_containerMaster];
    //	SAVE FUEL, FUEL CARGO, HITPOINTS, VEHICLE AMMO
    //	TODO: (_vehAttributes select 4) set [3, fuel _x];
    //	TODO: (_vehAttributes select 4) set [4, VEHICLE_AMMO_FOR_EACH_WEAPON_HERE];
    //	TODO: (_vehAttributes select 4) set [5, VEHICLE_HITPOINTS_FOR_EACH_PART_HERE];
    //	PUSH INTO MASTER VEHICLE ARRAY FOR THIS BASE
    _vehicleMasterArray pushBack _vehAttributes;
} forEach _baseVehicles;

//	PUSH THE PRIMARY DATA ARRAY INTO BASEDATA
_baseDataIndex = [baseData, _compName] call BIS_fnc_findNestedElement select 0;
(baseData select _baseDataIndex) set [6, _vehicleMasterArray];

