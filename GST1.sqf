/* Greek Sniper Team
Three man sniper element.
Stealthily inserts and survey's hostile positions.
Will call for fire if appropriate.
Will fire if appropriate.
Will withdraw if discovered.
*/

If (!isServer) exitwith {};
Params ["_trigger"];
_Base = (getmarkerpos "Origin");
_G1 = [(_this getpos [2200,(_this getdir _Base) -60 + round random 120]), INDEPENDENT, ["I_Spotter_F","I_Spotter_F","I_Sniper_F"],[],["CORPORAL","PRIVATE","PRIVATE"],[],[],[],180] call BIS_fnc_spawnGroup;
_TL = leader _G1;

{
	_x execVM "Gear\AAF.sqf";
} foreach units _G1;

_G1 setcombatmode "BLUE";

Sleep 5;

_G1 addwaypoint [_this getpos [-1200, (getpos leader (_G1) getdir _this)], 0];
[_G1, 1] setwaypointformation "VEE";
[_G1, 1] setwaypointspeed "FULL";

_G1 addwaypoint [_this getpos [-800, (getpos leader (_G1) getdir _this)], 0];
[_G1, 2] setwaypointspeed "NORMAL";

Waituntil {
	Sleep 10;
	(_TL distance _this) < 1100
};

{
	_x setunitpos "Down";
} foreach units _G1;

Waituntil {
	Sleep 10;
	private _threats = _TL neartargets 400;
	_threats findif {side (_x select 4) != side _TL} != -1
};

_wp = _G1 addwaypoint [_Base, 0];
[_G1, 3] setwaypointbehaviour "AWARE";
[_G1, 3] setwaypointspeed "FULL";
_G1 setcombatmode "GREEN";

{
	_x setunitpos "Up";
} foreach units _G1;