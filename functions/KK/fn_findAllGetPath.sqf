/*

	KK_fnc_findAllGetPath
	by:	Killzone Kid
	
	Retrieve a found element from an array.

	EXEC TYPE:	Call
	INPUT:		0	ARRAY	Array to search.
				1	ARRAY	Array index path to item.
	OUTPUT:		0	ANY		Found element.
	
*/

private "_arr";
_arr = _this select 0;
{
	_arr = _arr select _x;
} forEach (_this select 1);
if (isNil "_arr") then [{nil},{_arr}]
