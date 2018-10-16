/* Greek Infantry Platoon Small Base Security Patrol
After establishing a patrol base, the platoon is separated into a quartering party and a security patrol.
The quartering party remains at the patrol base, while the security patrol conducts close security sweeps of their area.
Security patrol withdraws to patrol base if they or the quartering party are challenged.
Platoon members at base withdraw if defeated.
*/

If (!isServer) exitwith {};
Params ["_trigger"];
_G1 = [(getpos _this), INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_Soldier_GL_F","I_soldier_F"],[],[],[],[],[],180] call BIS_fnc_spawnGroup;
Sleep 1;

_G1 addwaypoint [_this, 0];
_G1 addwaypoint [_this, (20 + random 40)];
_G1 addwaypoint [_this, (20 + random 40)];
_G1 addwaypoint [_this, (20 + random 40)];
_G1 addwaypoint [_this, 0];
[_G1, 3] setwaypointstatements ["true", "hint 'hello'; hint 'goodbye'"];

_G1 addwaypoint [_this, 0];
[_G1, 6] setwaypointtype "CYCLE";


/*Actions at rest:
	Waituntil {
		Sleep 30;
		Hint "Lap";
	};

_wp setWaypointStatements ["code code code; _returnBool", "onActivation block;"];

Kata
Sleep
Sit
Squats 
Kata

	_G1 = [(getpos _this), INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_Soldier_GL_F","I_soldier_F"],[],[],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G2 = [(getpos _this), INDEPENDENT, ["I_officer_F","I_Soldier_SL_F","I_Soldier_AR_F","I_soldier_UAV_F","I_Soldier_GL_F","I_Soldier_LAT_F"],[],[],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G3 = [(getpos _this), INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_Soldier_GL_F","I_soldier_F"],[],[],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;

	{
		{
//			_x execVM "Gear\AAF.sqf";
			_x setbehaviour "SAFE";
		} foreach units _x;
	} foreach [_G1,_G2,_G3];

	_G1 addwaypoint [_this, 600];
	_G1 addwaypoint [_this, 600];
	_G1 addwaypoint [_this, 600];
	_G1 addwaypoint [_this, 600];
	_G1 addwaypoint [_this, 600];
	_G1 addwaypoint [_this, 600];
	_G1 addwaypoint [_this, 600];
	[_G1, 1] setwaypointtype "MOVE";
	[_G1, 1] setwaypointspeed "LIMITED";
	[_G1, 6] setwaypointtype "CYCLE";
	Sleep 45;

	_G2 copywaypoints _G1;
	Sleep 45;
	
	_G3 copywaypoints _G1;