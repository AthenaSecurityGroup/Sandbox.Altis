/*

	ASG_fnc_remPlayerObj
	by:	Diffusion9

	Cleans up the player body when they leave the server. Does not delete the body if it still has non-default equipment present in cargo.

	EXEC TYPE:	Call
	INPUT:	0	OBJECT	Player object.
	OUTPUT:	0	NONE	No output.

*/

params ["_discObj"];
private ["_weapons"];
_itemCntArray = [];

_uniformItems = uniformItems _discObj;
if (!(_uniformItems isEqualTo [])) then {_itemCntArray pushBack _uniformItems};
_backpackItems = backpackContainer _discObj;
if (!(_backpackItems isEqualTo objNull)) then {_itemCntArray pushBack _backpackItems};
_vestItems = vestItems _discObj;
if (!(_vestItems isEqualTo [])) then {_itemCntArray pushBack _vestItems};
_weapons = weapons _discObj;
if !(count _weapons == 0) then { _itemCntArray pushBack _weapons };
if ((count _itemCntArray) == 0) then {deleteVehicle _discObj};
