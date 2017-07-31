/*

	KK_fnc_arrayUnShift
	by:	Killzone Kid
	
	From:	https://community.bistudio.com/wiki/append
	Array "unshift" implementation using append, a faster alternative to BIS_fnc_arrayUnShift.
	Example:
				arr = [1,2,3];
				[arr, 0] call KK_fnc_unshift; //both arr and return of function are [0,1,2,3]

	EXEC TYPE:	Call
	INPUT		0	ARRAY	Array to UnShift from.
				1	ANY		Item to UnShift.
	OUTPUT:		0	ARRAY	UnShifted Array.

	INPUT:

*/

private ["_arr", "_tmp"];
_arr = _this select 0;
_tmp = [_this select 1];
_tmp append _arr;
_arr resize 0;
_arr append _tmp;
_arr
