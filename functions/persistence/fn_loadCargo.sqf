//	LOAD CARGO INTO A SPECIFIC CONTAINER

params ["_targetContainer","_masterArray"];
_masterArray params ["_typeArray","_amountArray"];
_typeArray apply {
	switch true do {
		case ("Mine" in (_x call BIS_fnc_itemType) || "Magazine" in (_x call BIS_fnc_itemType)): {
			//	MAGAZINE
			_targetContainer addMagazineCargoGlobal [_x, _amountArray select ([_typeArray, _x] call BIS_fnc_findNestedElement select 0)];	//	, getNumber (configfile >> "CfgMagazines" >> _x >> "count")
		};
		case ("Item" in (_x call BIS_fnc_itemType)): {
			//	ITEM 
			_targetContainer addItemCargoGlobal [_x, _amountArray select ([_typeArray, _x] call BIS_fnc_findNestedElement select 0)];
		};
		case ("Weapon" in (_x call BIS_fnc_itemType)): {
			//	WEAPON
			_targetContainer addWeaponCargoGlobal [_x call BIS_fnc_baseWeapon, _amountArray select ([_typeArray, _x] call BIS_fnc_findNestedElement select 0)];
		};
		case ("Equipment" in (_x call BIS_fnc_itemType)): {
			_itemTypeArr = [];
			//	GLASSES
			_itemTypeArr pushback ("G_Balaclava_blk" in ([configfile >> "CfgGlasses" >> _x , true] call BIS_fnc_returnParents));	//	"G_Balaclava_blk"
			//	HEADGEAR
			_itemTypeArr pushback ("ItemCore" in ([configfile >> "CfgWeapons" >> _x , true] call BIS_fnc_returnParents));			//	"ItemCore"
			//	VEST
			_itemTypeArr pushback ("ItemCore" in ([configfile >> "CfgWeapons" >> _x , true] call BIS_fnc_returnParents));			//	"ItemCore"
			//	UNIFORM
			_itemTypeArr pushback ("Uniform_Base" in ([configfile >> "CfgWeapons" >> _x , true] call BIS_fnc_returnParents));		//	"Uniform_Base"
			//	BACKPACK
			_itemTypeArr pushback ("Bag_Base" in ([configfile >> "cfgVehicles" >> _x , true] call BIS_fnc_returnParents));			//	"Bag_Base"
			
			switch true do {
				case (_itemTypeArr select 0);
				case (_itemTypeArr select 1);
				case (_itemTypeArr select 2);
				case (_itemTypeArr select 3): {
					//	ADD	HEAD\VEST\UNIFORM
					_targetContainer addItemCargoGlobal [_x, _amountArray select ([_typeArray, _x] call BIS_fnc_findNestedElement select 0)];
				};
				case (_itemTypeArr select 4): {
					//	ADD BACKPACK
					_targetContainer addBackpackCargoGlobal  [_x, _amountArray select ([_typeArray, _x] call BIS_fnc_findNestedElement select 0)];
				};
				default {};
			};
		};
		default {};
	};
};