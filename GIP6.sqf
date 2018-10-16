/* Greek Infantry Patrol Base Security (AWARE or SAFE)
Squad size foot patrol conducts a close security sweep of their patrol base.
The patrol withdraws to patrol base if defeated (WIP).

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
	_HQ = [_Base, INDEPENDENT, ["I_officer_F","I_medic_F"],[],["LIEUTENANT","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G1 = [_Base, INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G2 = [_Base, INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_M_F","I_Soldier_AR_F","I_Soldier_GL_F"],[],["CORPORAL","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G3 = [_Base, INDEPENDENT, ["I_Soldier_SL_F","I_soldier_F","I_Soldier_AR_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
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
	} foreach [_HQ, _G1, _G2, _G3];
	Sleep 1;

//	[_G1, getpos _this, 600] call bis_fnc_taskPatrol;

	_G1 addwaypoint [_this, 0];
	_G1 addwaypoint [_this, (200 + random 300)];
	_G1 addwaypoint [_this, (200 + random 300)];
	_G1 addwaypoint [_this, (200 + random 300)];
	_G1 addwaypoint [_this, (200 + random 300)];
	_G1 addwaypoint [_this, 0];
	[_G1, 6] setwaypointtype "CYCLE";
	Sleep 30;

	_HQ copywaypoints _G1;
	Sleep 10;

	_G2 copywaypoints _HQ;
	Sleep 30;

	_G3 copywaypoints _G2;
};