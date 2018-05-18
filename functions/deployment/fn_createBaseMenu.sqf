/*

	ASG_fnc_createBaseMenu
	by:	Diffusion9
	
	Create the entries for the bd_subMenu based on the baseData player whitelist using KK_fnc_findAll.
	
	INPUT:
	None
	
	OUTPUT:
	None

*/

_whitelist = [baseData, player getVariable "ASG_rank"] call KK_fnc_findAll;

//	EXIT IF PLAYER IS NOT VALID
if (_whitelist isEqualto []) exitWith {bd_subMenu = nil; false};

//	PROCESS WHITELIST ITEMS TO CREATE MENU
{
	_x params ["_baseIndex"];
	_title = (baseData select _baseIndex select 0);
	_hotkey = 0;
	_code = format ["bd_requestBase = [player, %1]; publicVariableServer 'bd_requestBase'", _baseIndex];
	_visible = "1";
	_active = "1";
	_iconPath = "";
	bd_subMenu pushback [_title, [_hotkey], "", -5, [["expression", _code]], _visible, _active, _iconPath];
} forEach _whitelist;
true
