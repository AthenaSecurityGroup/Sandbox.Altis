//	MERGE TO MASTER FUNCTION
//	Merges a multidimensional relational array with the master arrays for the related type. (sub function)

params ["_typeArray", "_amountArray"];
_typeArray apply {
    private ["_persArrIndex", "_arrTarget"];
    switch true do {
        case ("Mine" in (_x call BIS_fnc_itemType) || "Magazine" in (_x call BIS_fnc_itemType)): {
            //	MAGAZINES
            _persArrIndex = [persist_masterMagArr, _x] call BIS_fnc_findNestedelement;
            _amountArrayIndex = [_typeArray, _x] call BIS_fnc_findNestedelement select 0;
            _itemAmount = _amountArray select _amountArrayIndex;
            [_persArrIndex, _itemAmount, persist_masterMagArr] call ASG_fnc_processMerge;
        };
        case ("Item" in (_x call BIS_fnc_itemType)): {
            //	ITEMS
            _persArrIndex = [persist_masterItemArr, _x] call BIS_fnc_findNestedelement;
            _amountArrayIndex = [_typeArray, _x] call BIS_fnc_findNestedelement select 0;
            _itemAmount = _amountArray select _amountArrayIndex;
            [_persArrIndex, _itemAmount, persist_masterItemArr] call ASG_fnc_processMerge;
        };
        case ("Weapon" in (_x call BIS_fnc_itemType)): {
            //	WEAPONS
            _persArrIndex = [persist_masterWeaponsArr, _x] call BIS_fnc_findNestedelement;
            _amountArrayIndex = [_typeArray, _x] call BIS_fnc_findNestedelement select 0;
            _itemAmount = _amountArray select _amountArrayIndex;
            [_persArrIndex, _itemAmount, persist_masterWeaponsArr] call ASG_fnc_processMerge;
        };
        case ("Equipment" in (_x call BIS_fnc_itemType)): {
            //	CONTAINERS
            _persArrIndex = [persist_masterContainerArr, _x] call BIS_fnc_findNestedelement;
            _amountArrayIndex = [_typeArray, _x] call BIS_fnc_findNestedelement select 0;
            _itemAmount = _amountArray select _amountArrayIndex;
            [_persArrIndex, _itemAmount, persist_masterContainerArr] call ASG_fnc_processMerge;
        };
        default {
            diag_log format ["%1 defaulted", _x];
        };
    };
};
