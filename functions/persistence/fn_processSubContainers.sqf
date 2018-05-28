//	PROCESS SUB CONTAINERS
//	Process the containers and contents and push them into the master array.

params ["_targetContainer"];
_backpackCargo = getBackpackCargo _targetContainer;
_backpackCargo call ASG_fnc_mergeToMaster;
_everyContainer = everyContainer _targetContainer;
if !(_everyContainer isEqualTo []) then {
	{
		_x params ["_containerType","_containerObj"];
		_containerObj call ASG_fnc_processWeaponsItemsMags;
	} forEach _everyContainer;
};
