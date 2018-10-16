/* Greek Infantry Platoon Reconnaissance/Surveillance Patrol (Wedge, column, wedge)
Infantry platoon conducts mobile surveillance from their combat out post using the clover or fan method.
Patrol withdraws to combat out post if engaged.
*/

if (!isServer) exitwith {};
params ["_trigger"];
_Base = (getmarkerpos "Origin");
_HQ = [_Base, INDEPENDENT, ["I_officer_F","I_medic_F","I_officer_F","I_soldier_UAV_F"],[],["LIEUTENANT","PRIVATE","SERGEANT","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G1 = [_Base, INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G2 = [_Base, INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_M_F","I_Soldier_AR_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G3 = [_Base, INDEPENDENT, ["I_Soldier_TL_F","I_soldier_F","I_Soldier_AR_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G4 = [_Base, INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_GL_F","I_Soldier_AR_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G5 = [_Base, INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;
_G6 = [_Base, INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_AR_F","I_Soldier_GL_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;

_PL = leader _HQ;
_L1 = leader _G1;

{
	{
		_gearhandle = _x execvm "Gear\AAF.sqf";
		waitUntil {scriptDone _gearhandle};

		if ((_x getunittrait "medic") && {"Medikit" in items _x}) then {
			[_x, IndiCasualties] execVM "Combat Medic.sqf";
		};

		_x addeventhandler ["Handledamage",{
			if (_this select 2 > 0.8) then {
				_unit = _this select 0;
				_unit setunconscious true;
				IndiCasualties pushbackunique _unit;
			};
		}];
	} foreach units _x;
	_x deletegroupwhenempty true;
} foreach [_HQ, _G1, _G2, _G3, _G4, _G5, _G6];
Sleep 1;

_G1 addwaypoint [Objective getpos [-1800, (getpos _L1 getdir Objective)], 0];
_G1 addwaypoint [Objective getpos [100, (getpos _L1 getdir Objective)], 600];
Sleep 30;

_G2 copywaypoints _G1;
_G3 copywaypoints _G1;
_G5 copywaypoints _G1;

{
	private _waypoint = _x;
	private _wpposition = waypointposition _waypoint;
	_wpposition = _wpposition getpos [300, (getdir leader (_G1)) + 270];
	_waypoint setWPPos _wpposition;
} foreach waypoints _G3;

{
	private _waypoint = _x;
	private _wpposition = waypointposition _waypoint;
	_wpposition = _wpposition getpos [300, (getdir leader (_G1)) + 90];
	_waypoint setwppos _wpposition;
} foreach waypoints _G5;
Sleep 30;

_HQ copywaypoints _G1;
_G4 copywaypoints _G1;
_G6 copywaypoints _G1;

{
	private _waypoint = _x;
	private _wpPosition = waypointposition _waypoint;
	_wpPosition = _wpPosition getpos [300, (getdir leader (_G1)) + 270];
	_waypoint setWPPos _wpPosition;
} foreach waypoints _G4;

{
	private _waypoint = _x;
	private _wpPosition = waypointPosition _waypoint;
	_wpPosition = _wpPosition getpos [300, (getdir leader (_G1)) + 90];
	_waypoint setWPPos _wpPosition;
} foreach waypoints _G6;

/*
	[_G3, 1] setwaypointstatements ["code; _returnBool", "onActivation block;"];

	_G1 addwaypoint [_this, 10];
	_G2 addwaypoint [_this, 10];
	_G3 addwaypoint [_this, 10];
	_G4 addwaypoint [_this, 10];
	_G5 addwaypoint [_this, 10];
	_G6 addwaypoint [_this, 10];
	_G7 addwaypoint [_this, 10];

	_G1 addwaypoint [(leader (_G3) getpos [50, (getdir leader (_G3))]), 10];
	_G2 addwaypoint [(leader (_G3) getpos [50, (getdir leader (_G3)) + 60]), 10];
	_G4 addwaypoint [(leader (_G3) getpos [50, (getdir leader (_G3)) + 120]), 10];
	_G5 addwaypoint [(leader (_G3) getpos [50, (getdir leader (_G3)) + 180]), 10];
	_G6 addwaypoint [(leader (_G3) getpos [50, (getdir leader (_G3)) + 240]), 10];
	_G7 addwaypoint [(leader (_G3) getpos [50, (getdir leader (_G3)) + 300]), 10];

	{
		{
			_x setunitpos selectrandom ["Middle","Down"];
		} foreach units _x;
	} foreach [_G1,_G2,_G3,_G4,_G5,_G6,_G7];

	[_G3, 1] setwaypointstatements ["true", "
	_G2 addwaypoint [_this, 10];
    _G3 addwaypoint [_this, 10];
    _G4 addwaypoint [_this, 10];
    _G5 addwaypoint [_this, 10];
    _G6 addwaypoint [_this, 10];
    _G7 addwaypoint [_this, 10];
	"];