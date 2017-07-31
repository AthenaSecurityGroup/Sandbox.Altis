/*

	KK_fnc_findAll
	by:	Killzone Kid
	
	From:	http://killzonekid.com/arma-scripting-tutorials-kk_fnc_findall/
	Unlike BIS_fnc_arrayFindDeep, KK_fnc_findAll will return paths for every match, no matter how
	deep it is buried inside multidimensional array. Of course the larger and deeper the array is,
	the longer the search will be.

	EXEC TYPE:	Call
	INPUT:		0	ARRAY	Array to find.
				1	ITEM	Item to find.
	OUTPUT:		0	ARRAY	Array of found items and their paths to index for findAllGetPath.
	
*/


private ["_fnc","_tmp","_res","_lvl","_def"];
_fnc = {
	{
		if (isNil "_x") then {
			if (!_def) then {
				_tmp set [_lvl,_forEachIndex];
				_res pushBack +_tmp;
			};
		} else {
			if (typeName _x == "ARRAY") then {
				_tmp set [_lvl,_forEachIndex];
				_lvl = _lvl + 1;
				_x call _fnc;
				_tmp resize _lvl;
				_lvl = _lvl - 1;
			} else {
				if (_def) then {
					if (_x isEqualTo _fnd) then {
						_tmp set [_lvl,_forEachIndex];
						_res pushBack +_tmp;
					};
				};
			};
		};
	} forEach _this;
};
_tmp = []; _res = []; _lvl = 0;
_fnd = _this select 1;
_def = !isNil "_fnd";
_this select 0 call _fnc;
_res
