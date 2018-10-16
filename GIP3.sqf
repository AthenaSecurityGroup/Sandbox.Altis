/* Greek Infantry Platoon Attack (Wedge, Wedge)
Platoon in wedge, squads in wedge, the infantry platoon attacks a known target, with intent to secure it.
Patrol withdraws to combat out post if defeated.
*/

If (!isserver) exitwith {};
Params ["_trigger"];
_Base = (getmarkerpos "Origin");
_Rally = (_this getpos [2200,(_this getdir _Base) -60 + round random 120]);
_HQ = [_Rally, INDEPENDENT, ["I_officer_F","I_medic_F","I_Soldier_SL_F","I_soldier_UAV_F"],[],[],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G1 = [_Rally, INDEPENDENT, ["I_Soldier_TL_F","I_soldier_F","I_Soldier_M_F","I_Soldier_SL_F","I_Soldier_AR_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],[],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G2 = [_Rally, INDEPENDENT, ["I_Soldier_TL_F","I_soldier_F","I_soldier_F","I_Soldier_SL_F","I_Soldier_AR_F","I_Soldier_AR_F","I_soldier_F","I_Soldier_GL_F"],[],[],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G3 = [_Rally, INDEPENDENT, ["I_Soldier_TL_F","I_soldier_F","I_soldier_F","I_Soldier_SL_F","I_Soldier_AR_F","I_Soldier_AR_F","I_Soldier_GL_F","I_soldier_F"],[],[],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;

_PL = leader _HQ;
_L1 = leader _G1;
_L2 = leader _G2;
_L3 = leader _G3;

{
	{
		_x execvm "Gear\AAF.sqf";
		_x setbehaviour "AWARE";
		_x setcombatmode "RED";
		_x setformation "LINE";
	} foreach units _x;
} foreach [_HQ, _G1, _G2, _G3];
_G1 addwaypoint [_this getpos [200, (getpos _L1 getdir _this)], 0];
[_G1, 1] setwaypointspeed "FULL";

Sleep 30;

_HQ copywaypoints _G1;
_G2 copywaypoints _G1;
_G3 copywaypoints _G1;

{
	Private _waypoint = _x;
	Private _wpposition = waypointposition _waypoint;
	_wpposition = _wpposition getpos [50, (getdir _L1) + 180];
	_waypoint setWPPos _wpposition;
} foreach waypoints _HQ;

{
	Private _waypoint = _x;
	Private _wpposition = waypointposition _waypoint;
	_wpposition = _wpposition getpos [200, (getdir _L1) + 240];
	_waypoint setWPPos _wpposition;
} foreach waypoints _G2;

{
	Private _waypoint = _x;
	Private _wpposition = waypointposition _waypoint;
	_wpposition = _wpposition getpos [200, (getdir _L1) + 120];
	_waypoint setwppos _wpposition;
} foreach waypoints _G3;

Waituntil {
	Sleep 30;
	(_PL distance _this) < 200
};

_G1 addwaypoint [_this, 10];
_G2 addwaypoint [_this, 10];
_G3 addwaypoint [_this, 10];
_HQ addwaypoint [_this, 10];

Waituntil {
	Sleep 30;
	(((_L2 distance _this) < 20) && ((_L3 distance _this) < 20))
};

{
	{
		_x setformation "WEDGE";
	} foreach units _x;
} foreach [_HQ, _G1, _G2, _G3];

Sleep 60;

_G1 addwaypoint [(_PL getpos [40, (getdir _PL) + 0]), 1];
_G2 addwaypoint [(_PL getpos [40, (getdir _PL) + 120]), 1];
_G3 addwaypoint [(_PL getpos [40, (getdir _PL) + 240]), 1];

Sleep (30 + random 30);

{
	{
		_x setunitpos selectrandom ["Middle","Down"];
	} foreach units _x;
} foreach [_HQ, _G1, _G2, _G3];