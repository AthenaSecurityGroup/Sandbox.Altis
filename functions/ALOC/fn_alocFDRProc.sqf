//	ASG_fnc_fdrProc
params ["_freightCrate", "_fdrQueue"];
_fdrQueue = (_fdrQueue select 0);

//	SORT WEAPONS, ITEMS, MAGAZINES, ETC.
{
	_x params ["_item","_amount"];
	_item call BIS_fnc_itemType params ["_type","_category"];
	switch (_type) do {
		case "Weapon": {
			_freightCrate addWeaponCargoGlobal [_item, _amount];
		};
		case "Item": {
			_freightCrate addItemCargoGlobal [_item, _amount];
		};
		case "Magazine": {
			_freightCrate addMagazineCargoGlobal [_item, _amount];
		};
		case "Equipment": {
			_freightCrate addBackpackCargoGlobal [_item,_amount];
		};
	};
} forEach _fdrQueue;
