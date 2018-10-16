/* Greek Infantry Platoon Contact Patrol (Wedge, column, wedge)
Single script serves multiple roles. Serves as exploitation, feint, movement to contact, or as a spoiling attack.
An exploitation is a follow up maneuver to gain ground on a retreating opponent.
A feint is an attack that is intended to distract and displace defenders, rather than seize an objective.
A movement to contact is conducted as a way to quickly establish lines of contact with an opposing force.
A spoiling attack is an attack that is intended to disrupt an opposing force's current actions, rather than seize an objective.
These actions server different tactical purposes, but are executed similarly enough that one scheme of maneuver serves each role.
Technically, an AI platoon chases players until the AI group must break contact or reaches limit of advance.
Patrol withdraws to combat out post if engaged.
*/

If (!isServer) exitwith {};
Params ["_trigger"];
_Base = (getmarkerpos "Origin");
_Rally = (_this getpos [2200,(_this getdir _Base) -60 + round random 120]);
_HQ = [_Rally, INDEPENDENT, ["I_officer_F","I_medic_F","I_officer_F","I_soldier_UAV_F"],[],["LIEUTENANT","PRIVATE","SERGEANT","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G1 = [_Rally, INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G2 = [_Rally, INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_M_F","I_Soldier_AR_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G3 = [_Rally, INDEPENDENT, ["I_Soldier_TL_F","I_soldier_F","I_Soldier_AR_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G4 = [_Rally, INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_GL_F","I_Soldier_AR_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G5 = [_Rally, INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G6 = [_Rally, INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_AR_F","I_Soldier_GL_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;

_PL = leader _HQ;
_L1 = leader _G1;
_L2 = leader _G2;
_L3 = leader _G3;
_L4 = leader _G4;
_L5 = leader _G5;
_L6 = leader _G6;

{
	{
		_x execvm "Gear\AAF.sqf";
		_x setbehaviour "AWARE";
	} foreach units _x;
} foreach [_HQ, _G1, _G2, _G3, _G4, _G5, _G6];

_G1 addwaypoint [_this getpos [500, (getpos leader (_G1) getdir _this)], 0];
[_G1, 1] setwaypointspeed "FULL";
Sleep 45;

_G2 copywaypoints _G1;
_G3 copywaypoints _G1;
_G5 copywaypoints _G1;

{
	private _waypoint = _x;
	private _wpposition = waypointposition _waypoint;
	_wpposition = _wpposition getpos [400, (getdir leader (_G1)) + 270];
	_waypoint setWPPos _wpposition;
} foreach waypoints _G3;

{
	private _waypoint = _x;
	private _wpposition = waypointposition _waypoint;
	_wpposition = _wpposition getpos [400, (getdir leader (_G1)) + 90];
	_waypoint setwppos _wpposition;
} foreach waypoints _G5;
Sleep 45;

_HQ copywaypoints _G1;
_G4 copywaypoints _G1;
_G6 copywaypoints _G1;

{
	private _waypoint = _x;
	private _wpPosition = waypointposition _waypoint;
	_wpPosition = _wpPosition getpos [400, (getdir leader (_G1)) + 270];
	_waypoint setWPPos _wpPosition;
} foreach waypoints _G4;

{
	private _waypoint = _x;
	private _wpPosition = waypointPosition _waypoint;
	_wpPosition = _wpPosition getpos [400, (getdir leader (_G1)) + 90];
	_waypoint setWPPos _wpPosition;
} foreach waypoints _G6;

Waituntil {
	Sleep 60;
	private _threats = _PL neartargets 400;
	_threats findif {side (_x select 4) != side _PL} != -1
};
/*
findNearestEnemy

nearTargets

[_G1, group player, {endcondition}, _Base] call BIS_fnc_stalk;

[_G1, group player, nil, nil, endCondition, endDestination] call BIS_fnc_stalk;

[stalker, stalked, refresh, radius, endCondition, endDestination] call BIS_fnc_stalk;
