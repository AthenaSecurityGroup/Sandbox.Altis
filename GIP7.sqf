/* Greek Infantry Combat Out Post Security (AWARE or SAFE)
Platoon size foot patrol conducts a security sweep near their combat out post.
The patrol withdraws to combat outpost if defeated (WIP).

Design:
Spawn groups;
Generate random waypoints with a minimum and maximum radius of original position;
Return to original position (WIP);
Go off duty (WIP);
Random sleep time (WIP);
Repeat (WIP);
*/

if (!isServer) exitwith {};
params ["_trigger"];
_trigger spawn {
	_Base = (getpos _this);
	_HQ = [(_this getpos [50,180]), INDEPENDENT, ["I_officer_F","I_medic_F","I_officer_F","I_soldier_UAV_F"],[],["LIEUTENANT","PRIVATE","SERGEANT","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G1 = [(_this getpos [50,180]), INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G2 = [(_this getpos [50,180]), INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_M_F","I_Soldier_AR_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G3 = [(_this getpos [50,180]), INDEPENDENT, ["I_Soldier_TL_F","I_soldier_F","I_Soldier_AR_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G4 = [(_this getpos [50,180]), INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_GL_F","I_Soldier_AR_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G5 = [(_this getpos [50,180]), INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G6 = [(_this getpos [50,180]), INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_AR_F","I_Soldier_GL_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;

	_PL = leader _HQ;
	_L1 = leader _G1;

	{
		{
			_gearhandle = _x execvm "Gear\AAF.sqf";
			waituntil {scriptDone _gearhandle};

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
		_x setbehaviour "SAFE";
	} foreach [_HQ, _G1, _G2, _G3, _G4, _G5, _G6];
	Sleep 1;

	[_G1, getpos _this, 1500] call bis_fnc_taskPatrol; Sleep 45;

/*
	_G1 addwaypoint [_this, 0];
	_G1 addwaypoint [_this, (400 + random 600)];
	_G1 addwaypoint [_this, (400 + random 600)];
	_G1 addwaypoint [_this, (400 + random 600)];
	_G1 addwaypoint [_this, (400 + random 600)];
	_G1 addwaypoint [_this, 0];
	[_G1, 6] setwaypointtype "CYCLE";
	Sleep 30;
*/
	_G2 copywaypoints _G1;
	Sleep 45;

	_HQ copywaypoints _G2;	
	_G3 copywaypoints _HQ;
	_G4 copywaypoints _HQ;

	{
		private _waypoint = _x;
		private _wpposition = waypointposition _waypoint;
		_wpposition = _wpposition getpos [120, (getdir leader (_HQ)) + 270];
		_waypoint setWPPos _wpposition;
	} foreach waypoints _G3;

	{
		private _waypoint = _x;
		private _wpposition = waypointposition _waypoint;
		_wpposition = _wpposition getpos [120, (getdir leader (_HQ)) + 90];
		_waypoint setwppos _wpposition;
	} foreach waypoints _G4;
	Sleep 45;

	_G5 copywaypoints _HQ;
	Sleep 45;

	_G6 copywaypoints _G5;
};