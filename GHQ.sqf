/* Greek Infantry Battalion Headquarters and Staff
Occupy the FOB. Fight if attacked.


	_G1 addwaypoint [_Base, 5];
	_G2 addwaypoint [_Base, 5];
	_G3 addwaypoint [_Base, 5];
	Sleep 45;

	_G1 addwaypoint [_CO getpos [30, (getdir _CO) + 060], 0];
	_G2 addwaypoint [_CO getpos [30, (getdir _CO) + 180], 0];
	_G3 addwaypoint [_CO getpos [30, (getdir _CO) + 240], 0];
	Sleep 15;
*/

if (!isServer) exitwith {};
params ["_trigger"];
_trigger spawn {
	_Base = (getpos _this);
	_HQ = [(_this getpos [15,000]), INDEPENDENT, ["I_officer_F","I_officer_F","I_officer_F","I_officer_F","I_officer_F","I_officer_F"],[],["MAJOR","CAPTAIN","CAPTAIN","LIEUTENANT","LIEUTENANT","LIEUTENANT"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G1 = [(_this getpos [15,090]), INDEPENDENT, ["I_officer_F","I_Soldier_TL_F","I_soldier_F","I_officer_F","I_Soldier_TL_F","I_soldier_F"],[],["LIEUTENANT","CORPORAL","PRIVATE","LIEUTENANT","CORPORAL","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G2 = [(_this getpos [15,180]), INDEPENDENT, ["I_officer_F","I_Soldier_TL_F","I_soldier_F","I_officer_F","I_Soldier_TL_F","I_soldier_F"],[],["LIEUTENANT","CORPORAL","PRIVATE","LIEUTENANT","CORPORAL","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;
	_G3 = [(_this getpos [15,270]), INDEPENDENT, ["I_officer_F","I_Soldier_TL_F","I_soldier_F","I_officer_F","I_Soldier_TL_F","I_soldier_F"],[],["LIEUTENANT","CORPORAL","PRIVATE","LIEUTENANT","CORPORAL","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
	Sleep 1;

	_CO = leader _HQ;
	_S1 = leader _G1;
	_S2 = leader _G2;
	_S3 = leader _G3;

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
	} foreach [_HQ, _G1, _G2, _G3];
	Sleep 1;

	{
		{
			_x domove (_this getpos [30 * sqrt random 1, random 360]);
		} foreach units _x;
	} foreach [_HQ, _G1, _G2, _G3];
	Sleep 15;

	_HQ addwaypoint [getpos _this, 0];
	[_HQ, 1] setwaypointbehaviour "SAFE";
	[_HQ, 1] setWaypointType "DISMISS";

	_G1 addwaypoint [getpos _this, 0];
	[_G1, 1] setwaypointbehaviour "SAFE";
	[_G1, 1] setWaypointType "DISMISS";

	_G2 addwaypoint [_Base, 0];
	[_G2, 1] setwaypointbehaviour "SAFE";
	[_G2, 1] setWaypointType "DISMISS";
	
	_G3 addwaypoint [_Base, 0];
	[_G3, 1] setwaypointbehaviour "SAFE";
	[_G3, 1] setWaypointType "DISMISS";
};