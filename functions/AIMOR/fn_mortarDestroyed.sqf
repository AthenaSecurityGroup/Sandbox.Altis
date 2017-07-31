/*

	ASG_fnc_mortarDestroyed
	
	Turns the received string into a mortar group reference, and checks if that group has been eliminated.
	If the group has been eliminated the mortars are destroyed, and triggers and scripts related to the mortar system
	are destroyed.
	
	REQUIRED INPUT:
	0	STRING	Name to parse into variables.

*/

params ['_mortarVarStr'];
_mortarTrgStr = format ["%1_trigger", _mortarVarStr];
_mortarScrStr = format ["%1_script", _mortarVarStr];
_mortarPriStr = format ["%1_primary", _mortarVarStr];
_mortarSecStr = format ["%1_secondary", _mortarVarStr];
_mortarCrewStr = format ["%1_crew", _mortarVarStr];	
if (units (missionNameSpace getVariable _mortarCrewStr) isEqualTo []) exitWith {
	diag_log format ['[ASG_fnc_mortarDestroyed]:	%1 has been eliminated. Beginning variable purge', _mortarVarStr];
	deleteVehicle (missionNameSpace getVariable _mortarTrgStr);
	terminate (missionNameSpace getVariable _mortarScrStr);
	deleteGroup (missionNameSpace getVariable _mortarCrewStr);
	true
};
false;
