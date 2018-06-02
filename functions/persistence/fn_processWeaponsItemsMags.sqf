//	PROCESS WEAPONS, ITEMS, AND MAGAZINES FUNCTION
//	Process the weapons, items, and magazines in a target container and pushes them to the master array.

params ["_targetContainer"];
//	GET RELATIONAL ARRAYS FOR CORE ITEMS
_magazineCargo = getMagazineCargo _targetContainer;
_itemCargo = getItemCargo _targetContainer;
_weaponCargo = getWeaponCargo _targetContainer;

//	GET WEAPON ATTACHMENTS
_weaponsItemsCargo = weaponsItemsCargo _targetContainer;
_weaponsItemsCargo apply {_x deleteAt 0};
{
	_x apply {
		private ["_existingIndex", "_itemName"];
		switch true do {
			//	ITEM
			case ((typeName _x == "STRING") && {(_x != "")}): {
				_existingIndex = [_itemCargo, _x] call BIS_fnc_findNestedElement;
				//	IF ITEM ALREADY EXISTS, INCREMENT RELATIONAL ARRAY BY 1. IF NOT, ADD AN ENTRY
				if (count _existingIndex != 0) then {
					_existingIndex = _existingIndex select 1;
					(_itemCargo select 1) set [_existingIndex, (_itemCargo select 1 select _existingIndex) + 1];
				} else {
					(_itemCargo select 0) pushBack _x;
					(_itemCargo select 1) pushBack 1;
				};
			};
			//	MAGAZINE
			case ((typeName _x == "ARRAY") && {!(_x isEqualTo [])}): {
				_existingIndex = [_magazineCargo, _x select 0] call BIS_fnc_findNestedElement;
				if (count _existingIndex != 0) then {
					_existingIndex = _existingIndex select 1;
					(_magazineCargo select 1) set [_existingIndex, (_magazineCargo select 1 select _existingIndex) + 1];
				} else {
					(_magazineCargo select 0) pushBack (_x select 0);
					(_magazineCargo select 1) pushBack 1;
				};
			};
			default {};
		};
	};
} forEach _weaponsItemsCargo;

{_x call ASG_fnc_mergeToMaster} forEach [_magazineCargo, _itemCargo, _weaponCargo];
