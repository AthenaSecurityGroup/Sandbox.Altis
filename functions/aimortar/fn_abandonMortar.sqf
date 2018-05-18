/*

	ASG_fnc_abandonMortar
	
	Turns the received value into a mortar group reference and checks if that group is down to 1 member.
	Or checks if there are enemies within 200 m of the mortar.
	If the group is down to 1 member the mortar team is suffering from combat attrition, and the remaining mortar man
	abandons the mortar position. Related triggers to the mortar system are deleted and scripts cancelled. Mortars are destroyed.
	
	REQUIRED INPUT:
	0	STRING	Name to parse into variables.

*/

params ['_mortarVarStr'];
_mortarTrgStr = format ["%1_trigger", _mortarVarStr];
_mortarScrStr = format ["%1_script", _mortarVarStr];
_mortarCrewStr = format ["%1_crew", _mortarVarStr];
if (( ( ((units (missionNameSpace getVariable _mortarCrewStr)) select 0) findNearestEnemy (getPOS ((units (missionNameSpace getVariable _mortarCrewStr)) select 0)) ) distance (getPOS ((units (missionNameSpace getVariable _mortarCrewStr)) select 0)) < 150 ) || (count units (missionNameSpace getVariable _mortarCrewStr) < 2)) exitWith {
	diag_log format ['[mortarAttrition]:	Abandoning %1', _mortarVarStr];
	{
		_xVeh = assignedVehicle _x;
		unassignVehicle _x;
		_x action ['getOut', (vehicle _x)];
	} forEach (units (missionNameSpace getVariable _mortarCrewStr));
	deleteVehicle (missionNameSpace getVariable _mortarTrgStr);
	terminate (missionNameSpace getVariable _mortarScrStr);
	true;
};
false;
