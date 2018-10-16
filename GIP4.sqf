/* Greek Infantry Platoon at Rest (Establish a Patrol Base)
A platoon is dispatched from their parent combat out post to attempts to occupy and fortify a position.
Platoon withdraws to combat out post if engaged.
*/

If (!isServer) exitwith {};
Params ["_trigger"];
_Base = (getmarkerpos "Origin");
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
	} foreach units _x;
	_x setformation "LINE";
	_x setspeedmode "LIMITED";
} foreach [_G1, _G2, _G3, _G4, _G5, _G6, _HQ];

Sleep 1;

_G1 addwaypoint [_PL getpos [40, (getdir _PL) + 000], 5];
_G2 addwaypoint [_PL getpos [40, (getdir _PL) + 060], 5];
_G3 addwaypoint [_PL getpos [40, (getdir _PL) + 120], 5];
_G4 addwaypoint [_PL getpos [40, (getdir _PL) + 180], 5];
_G5 addwaypoint [_PL getpos [40, (getdir _PL) + 240], 5];
_G6 addwaypoint [_PL getpos [40, (getdir _PL) + 300], 5];

Sleep 1;

_L1 dowatch (_PL getpos [1000, (getdir _PL) + 000]);
_L2 dowatch (_PL getpos [1000, (getdir _PL) + 060]);
_L3 dowatch (_PL getpos [1000, (getdir _PL) + 120]);
_L4 dowatch (_PL getpos [1000, (getdir _PL) + 180]);
_L5 dowatch (_PL getpos [1000, (getdir _PL) + 240]);
_L6 dowatch (_PL getpos [1000, (getdir _PL) + 300]);

Sleep 20;

{
	{
		_x setunitpos selectrandom ["Middle","Down","Down"];
	} foreach units _x;
} foreach [_G1, _G2, _G3, _G4, _G5, _G6, _HQ];

/*
	_HQ = [_Base, INDEPENDENT, ["I_officer_F","I_medic_F","I_Soldier_SL_F","I_soldier_UAV_F"],[],[],[],[],[],0] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G1 = [_Base, INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],[],[],[],[],0] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G2 = [_Base, INDEPENDENT, ["I_Soldier_SL_F","I_soldier_F","I_Soldier_AR_F","I_Soldier_M_F"],[],[],[],[],[],0] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G3 = [_Base, INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F"],[],[],[],[],[],0] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G4 = [_Base, INDEPENDENT, ["I_Soldier_SL_F","I_Soldier_AR_F","I_soldier_F","I_Soldier_LAT_F"],[],[],[],[],[],0] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G5 = [_Base, INDEPENDENT, ["I_Soldier_TL_F","I_soldier_F","I_Soldier_AR_F","I_soldier_F"],[],[],[],[],[],0] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G6 = [_Base, INDEPENDENT, ["I_Soldier_SL_F","I_soldier_F","I_Soldier_AR_F","I_Soldier_LAT_F"],[],[],[],[],[],0] call BIS_fnc_spawnGroup;
	Sleep 1;

	_PL = leader _HQ;
	_L1 = leader _G1;
	_L2 = leader _G2;
	_L3 = leader _G3;
	_L4 = leader _G4;
	_L5 = leader _G5;
	_L6 = leader _G6;

	Sleep 1;

	{
		{
//			_x execVM "Gear\AAF.sqf";
		} foreach units _x;
		_x setformation "LINE";
		_x setspeedmode "LIMITED";
	} foreach [_G1,_G2,_G3,_G4,_G5,_G6,_HQ];

	Sleep 1;

	_G1 addwaypoint [_PL getpos [40, (getdir _PL) + 000], 5];
	_G2 addwaypoint [_PL getpos [40, (getdir _PL) + 060], 5];
	_G3 addwaypoint [_PL getpos [40, (getdir _PL) + 120], 5];
	_G4 addwaypoint [_PL getpos [40, (getdir _PL) + 180], 5];
	_G5 addwaypoint [_PL getpos [40, (getdir _PL) + 240], 5];
	_G6 addwaypoint [_PL getpos [40, (getdir _PL) + 300], 5];

	Sleep 1;

	_L1 dowatch (_PL getpos [1000, (getdir _PL) + 000]);
	_L2 dowatch (_PL getpos [1000, (getdir _PL) + 060]);
	_L3 dowatch (_PL getpos [1000, (getdir _PL) + 120]);
	_L4 dowatch (_PL getpos [1000, (getdir _PL) + 180]);
	_L5 dowatch (_PL getpos [1000, (getdir _PL) + 240]);
	_L6 dowatch (_PL getpos [1000, (getdir _PL) + 300]);

	Sleep 20;

	{
		{
			_x setunitpos selectrandom ["Middle","Down","Down"];
		} foreach units _x;
	} foreach [_G1,_G2,_G3,_G4,_G5,_G6,_HQ];