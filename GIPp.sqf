//Greek Infantry Platoon Off Duty (SAFE)
if (!isServer) exitwith {};
params ["_trigger"];
_G1 = [(getpos Objective), INDEPENDENT, ["I_Soldier_TL_F","I_Soldier_AR_F","I_soldier_F","I_soldier_F","I_Soldier_SL_F","I_soldier_F","I_Soldier_AR_F","I_soldier_F"],[],[],[],[],[],0] call BIS_fnc_spawnGroup;
_TL = leader _G1;
Sleep 2;

{
	_x setbehaviour "SAFE";
	Dostop _x;
} foreach (units _G1);
Sleep 2;

{
	_x domove ((getpos Objective) getpos [(1 + random 20), (0 + random 360)]);
} foreach (units _G1);
Sleep 10;

{
	_x domove ((getpos Objective) getpos [(1 + random 20), (0 + random 360)]);
} foreach (units _G1);
Sleep 10;



/*
{
	[_x, (selectrandom ["STAND","STAND_IA","SIT_LOW","KNEEL","WATCH","WATCH1","WATCH2"]), "RANDOM",
	{
		private _threats = (leader _G1) neartargets 400;
		_threats findif {side (_x select 4) != side (leader _G1)} != -1;
	}, "SAFE"] call BIS_fnc_ambientAnimCombat;
} foreach (units _G1);

/*
[C1, "STAND1", "NONE"] call BIS_fnc_ambientAnim;

[C1,"STAND","ASIS"] call BIS_fnc_ambientAnimCombat;

	{
		_x playmove selectrandom "AmovPercMstpSlowWrflDnon_AmovPsitMstpSlowWrflDnon";
	} foreach (units _G1);

Sleep 5;
playmove "AmovPsitMstpSrasWrflDnon"
	{
		_x switchmove "AidlPsitMstpSnonWnonDnon_ground00";
	} foreach (units _G1);

		_x playmove selectrandom ["amovppnemstpsraswrfldnon","AidlPsitMstpSnonWnonDnon_ground00"];
	{
		Dostop _x;
		_x domove ((getpos _this) getpos [(1 + random 20), (0+ random 360)]);
	} foreach (units _G1);

selectrandom

private _units = units _group;
private _origin = getPosWorld leader _group;
private _delta = 360 / count _units;
private _start = random 360;

{
    _x doMove (_origin getPos [100, _start + _forEachIndex * _delta]);
} forEach _units;

//Greek Infantry Platoon Off Duty (SAFE)
if (!isServer) exitwith {};
params ["_trigger"];
_trigger spawn {
	_G1 = [(getpos _this), INDEPENDENT, ["I_Soldier_TL_F","I_soldier_F"],[],[],[],[],[],0] call BIS_fnc_spawnGroup;
	_G1 addwaypoint [_this, 50];
	_G1 addwaypoint [_this, 50];
	_G1 addwaypoint [_this, 50];
	_G1 addwaypoint [_this, 50];
	[_G1, 2] setwaypointtype "DISMISS";
	[_G1, 4] setwaypointtype "CYCLE";
	Sleep 60;
	deleteWaypoint [_G1, 2];
	Hint "Deleting.";
};

//	Every AI Medic:
If (damage Chuck > 0.8) then {
//		Ben forceweaponfire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
//		Jack forceweaponfire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
//		Jon forceweaponfire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
//		Mark forceweaponfire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
//		Rick forceweaponfire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
//		Steve forceweaponfire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
	Ralph domove (position Chuck);
	Waituntil {Ralph distance Chuck < 2};
	Dostop Ralph;
	Ralph action ["Heal", Chuck];
	If (alive Chuck) then {
		Sleep 5;
		Chuck setdamage 0;
		Chuck setunconscious false;
		Waituntil {damage Chuck < 0.2};
		Sleep 5;
	};
	Ralph dofollow leader Ralph;
};


_G7 addwaypoint [(leader (_G3) getpos [50, (getdir leader (_G3)) + 300]), 5];


Select units _group domove getpos [(1 + round random 20), (getdir leader (_G3)) + round random 360]), 1];
disableAI "paths";
switchmove selectrandom "animations";
