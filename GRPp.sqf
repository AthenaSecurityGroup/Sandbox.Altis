/* Mounted Greek Recon Patrol
Conducts long range security for FOB.
*/

If (!isServer) exitwith {};
params ["_trigger"];
_trigger spawn {
	_Base = (getpos _this);
	_G1 = [(_this getpos [100,180]), INDEPENDENT, ["I_Soldier_TL_F","I_soldier_F","I_soldier_F"],[],["CORPORAL","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G2 = [(_this getpos [100,180]), INDEPENDENT, ["I_Soldier_SL_F","I_soldier_F","I_soldier_F"],[],["SERGEANT","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G3 = [(_this getpos [100,180]), INDEPENDENT, ["I_officer_F","I_Soldier_TL_F","I_soldier_F","I_soldier_F"],[],["LIEUTENANT","CORPORAL","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G4 = [(_this getpos [100,180]), INDEPENDENT, ["I_Soldier_SL_F","I_soldier_F","I_soldier_F","I_soldier_UAV_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G5 = [(_this getpos [100,180]), INDEPENDENT, ["I_officer_F","I_Soldier_TL_F","I_soldier_F","I_soldier_F"],[],["SERGEANT","CORPORAL","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G6 = [(_this getpos [100,180]), INDEPENDENT, ["I_Soldier_SL_F","I_soldier_F","I_soldier_F","I_medic_F"],[],["SERGEANT","PRIVATE","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;

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
	} foreach [_G1, _G2, _G3, _G4, _G5, _G6];
	Sleep 1;

	_Vic1 = "I_MRAP_03_hmg_F" createvehicle _Base;
	Sleep 1;
	_Vic2 = "I_MRAP_03_hmg_F" createvehicle _Base;
	Sleep 1;
	_Vic3 = "I_MRAP_03_gmg_F" createvehicle _Base;
	Sleep 1;
	_Vic4 = "I_MRAP_03_hmg_F" createvehicle _Base;
	Sleep 1;
	_Vic5 = "I_MRAP_03_hmg_F" createvehicle _Base;
	Sleep 1;
	_Vic6 = "I_MRAP_03_gmg_F" createvehicle _Base;
	Sleep 1;

	_G1 addWaypoint [position _Vic1, 0];
	[_G1, 1] setWaypointType "GETIN NEAREST";
	_G2 addWaypoint [position _Vic2, 0];
	[_G2, 1] setWaypointType "GETIN NEAREST";
	_G3 addWaypoint [position _Vic3, 0];
	[_G3, 1] setWaypointType "GETIN NEAREST";
	_G4 addWaypoint [position _Vic4, 0];
	[_G4, 1] setWaypointType "GETIN NEAREST";
	_G5 addWaypoint [position _Vic5, 0];
	[_G5, 1] setWaypointType "GETIN NEAREST";
	_G6 addWaypoint [position _Vic6, 0];
	[_G6, 1] setWaypointType "GETIN NEAREST";
	Sleep 30;

	[_G1, getpos _this, 3000] call bis_fnc_taskPatrol;
	Sleep 1;
	_G2 copywaypoints _G1;
	Sleep 1;
	_G3 copywaypoints _G2;
	Sleep 1;
	_G4 copywaypoints _G3;
	Sleep 1;
	_G5 copywaypoints _G4;
	Sleep 1;
	_G6 copywaypoints _G5;
};